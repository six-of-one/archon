 /*
		+---------------------------------------+
		|	auto sentry code										 | SEC-HEAD
		+---------------------------------------+
*/

$frame gunsearch gunfire1 gunfire2 gunfire3 gunfire4 gunmisfire1 gunmisfire2


float PK_TUR_RELOAD; // chance turret will reload when low on ammo
float PK_TUR_DEATHRAD;
float PK_TUR_CRITICALMASS; // too many in rad blows them all up
float PK_TUR_CRITICALMASS_DIST;
#define CRIT_BLOW 2
//float PK_TUR_VARIETY; // a variety of turrets - 
//															bits:		1 - orange kryptonite nails,	2 - lasers,	4 - pulse nails,	8 - lightning,	16 - rockets,	not done yet - 	32 - railgun,		64 - chaos
//								fixed percentages:		60%													20%				10%						5%						4%														1%							0.5%
float PK_TUR_LIMIT; // max turrets on a given server - used if inf detected
#define PK_TUR_INVRETIME 80 // what to retime invs to if infinite turrets exist

#define SENTRY_SDOT 0.8 // view radius

// last one made, for chaos item
entity turret;

void() turret_searchForEnemy;
void() turret_findTarget;
//float (entity e) turret_inFront;
void() turret_attackEnemy;
void() turret_deathAnim;
//void() turret_deathAnimBase;
void(vector org, vector vec) turret_launchNail;
void() turret_checkIfCanBeSolid;
void(string gibname, float dm) turret_throwGib;
void() turret_gibTouch;

// so we can set infinite or unkillable turrets to destruct when certain things happen
// allow players to kill server set indestructible / infinite ammo turrets

// grav well pull, grapple hit

void(entity e, float tm) turret_KillStraker =
{
	e.think = turret_deathAnim;	
	e.nextthink = time + tm;
};


void() turret_dropTurret =
{
//	local	entity turret;
	local vector dir;

	if (self.flags & FL_CLIENT) // NOTE: if pk*bot is set back to no client flag
	{
		if (self.pk_turretammo <= 0)
		{
			return;
		}

		if (!self.button0)
		{
			player_run ();
		  return;
		}
	}

	if (!PK_TUR_SET)
	{
		PK_TUR_SET = TRUE;
// defs
		PK_TUR_AMMO = 40;
		PK_TUR_TIME = 20;
		PK_TUR_HEAL = 300;
		PK_TUR_TARGOWN = 3;
		PK_TUR_RELOAD = 0.15; // not much chance
		PK_TUR_VARIETY = 1; // regular orange nails
		PK_TUR_QUADCON =  0; // if true, quad player takes ownership of turrets in deathrad
		PK_TUR_DEATHRAD = 300; // this close to active pent destroys
		PK_TUR_CRITICALMASS = 8; // more than this many
		PK_TUR_CRITICALMASS_DIST = 160; // critical mass distance

		if (DARKPLACES || chaos)
		{
			PK_TUR_AMMO = cvar("pk_tur_ammo");
			PK_TUR_TIME = cvar("pk_tur_time");
			if (PK_TUR_TIME < 0) PK_TUR_TIME = 20;
			PK_TUR_HEAL = cvar("pk_tur_health");
			PK_TUR_TARGOWN = cvar("pk_tur_targetown");
			PK_TUR_VARIETY = cvar("pk_tur_variety");
			if (PK_TUR_VARIETY < 1) PK_TUR_VARIETY = 1;
			PK_TUR_QUADCON = cvar("pk_tur_quadcon");
		}
	}

	// check if near a wall
	makevectors(self.v_angle);
	dir = self.origin + self.view_ofs;
	traceline (dir, dir + v_forward * 50, FALSE, self);

	makevectors (self.angles);
	if (trace_fraction != 1.0 && !trace_ent.takedamage)
	{
		// To near a wall, can't throw turret
	  sprint(self, "Can't throw AutoSentry, too close to a wall!!\n");
	  return;
	}

	if (self.flags & FL_CLIENT) // some qualification
		self.currentammo = self.pk_turretammo = self.pk_turretammo - 1; // Cataboligne - 8.20.9 - moved here so wall fail doesnt eat ammo
									// NOTE: self must always then be firing entity

	turret = spawn ();
	turret.owner = self;
	turret.movetype = MOVETYPE_STEP;
//	turret.movetype = MOVETYPE_TOSS;
//	turret.solid = SOLID_BBOX;
	turret.solid = SOLID_NOT;
	turret.classname = "turret";
	turret.netname = "Auto sentry";
	turret.takedamage = TRUE;
	turret.health = PK_TUR_HEAL;
	if (PK_TUR_HEAL > 0) turret.th_die = turret_deathAnim;
	else turret.th_die = SUB_Null; // turret_searchForEnemy; -- this was causing a badwolf loop bug when a grav well radius explosion was calling this, and the 2nd findradius was busting the .chain loop
	turret.currentammo = turret.ammo_cells = PK_TUR_AMMO;
// new stuff
	turret.cnt = 0;
	turret.AIRG_Flags = AIRG_EXCLUDEENTITY; // dont blow turret - just base
	turret.dmg = 15;

	local float ri;
	ri = random();
	turret.state = 0;
	if ((PK_TUR_VARIETY & 1) && ri < 0.6) turret.state = 1;
	else if ((PK_TUR_VARIETY & 2) && ri < 0.8) turret.state = 2;
	else if ((PK_TUR_VARIETY & 4) && ri < 0.9) turret.state = 4;
	else if ((PK_TUR_VARIETY & 8) && ri < 0.95) turret.state = 8;
	else if ((PK_TUR_VARIETY & 16) && ri < 0.99) turret.state = 16;

	ri = 1;
	if (!turret.state)
	while (ri < 32 && !turret.state)
	{
		if (ri & PK_TUR_VARIETY) turret.state = ri;
		ri = ri * 2;
	}

	if (turret.state == 2) turret.dmg = 25;
	else if (turret.state == 4) turret.dmg = 27;
	else if (turret.state == 8) turret.dmg = 30;
	else if (turret.state == 16) turret.dmg = 33.3;

// set direction
	turret.angles = self.angles;
	turret.v_angle = self.v_angle;

// set turret duration
	if (!PK_TUR_TIME) turret.turret_timeout = 0;
	else turret.turret_timeout = time + PK_TUR_TIME;

// set when the turret can target the owner
	if (!PK_TUR_TARGOWN) turret.turret_ownertimeout = 0;
	else turret.turret_ownertimeout = time + PK_TUR_TARGOWN;

// look for enemy
	turret.nextthink = time + 0.1;
	turret.think = turret_searchForEnemy;

//		setmodel (turret, "progs/turtop.mdl"); -- remove model
	setmodel (turret, "progs/turtop2.mdl"); // removed orange barrel flare - looks wrong with variety

//	setsize (turret, '-16 -16 -16', '16 16 16');
	setorigin (turret, self.origin);


	turret.turret_base = spawn ();
	turret.turret_base.owner = turret;
	turret.turret_base.movetype = MOVETYPE_TOSS;
//	turret.turret_base.solid = SOLID_BBOX;
	turret.turret_base.solid = SOLID_NOT;
	turret.turret_base.classname = "turret_base";
	turret.turret_base.netname = "Auto sentry";

// Cataboligne - 6.5.10 - removed base killable because of T_Dam loop deal

//	turret.turret_base.takedamage = TRUE;
//	turret.turret_base.health = rint(PK_TUR_HEAL * 0.667);
//	if (PK_TUR_HEAL > 0) turret.turret_base.th_die = turret_deathAnimBase;
//	else turret.turret_base.th_die = SUB_Null;

	// Throw away from you
	makevectors (self.angles);
	turret.velocity = turret.turret_base.velocity = (v_forward * (200 + random() * 100)) + (v_up * (200 + random() * 100));

// set direction
	turret.turret_base.angles = self.angles;
	turret.turret_base.v_angle = self.v_angle;

// set turret duration
//	turret.turret_timeout = time + 20;

// look for enemy
	turret.nextthink = time + 0.1;
	turret.think = turret_searchForEnemy;

	setmodel(turret.turret_base, "progs/turstand.mdl");
//	setsize(turret.turret_base, '-15 -14 -18', '9 14 1');
//	setsize (turret, '-5 -5 -18', '5 5 1');
//	setorigin (turret.turret_base, self.origin + self.view_ofs);
	setorigin (turret.turret_base, self.origin);

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(turret);
};



void() turret_searchForEnemy =
{
/*
	if (BOTFREEZE) // Cataboligne - 6.9.10 - bot freeze affects these too
	{
		self.nextthink = time + 5;
		return;
	}
*/

	if (self.turret_timeout)
	// check if the turret time is up
	if (self.turret_timeout < time) {
	  turret_deathAnim();
	  return;
	}

	if (!self.currentammo && !self.turret_timeout && self.health < 1)
	{
		local float f, c, d;
		local entity e;

		self.delay = TRUE; // KillStraker candidate
		c = FALSE;
		if (random() < 0.1)
		{
//d invuln
			f = pk_mcode("d_art_invulnerable", world); 
			e = find(world, classname, "d_art_invulnerable"); 
//			if (!e) e = find(world, sscode, ftos(f)); // Cataboligne - 8.8.13 - removing sscode array / func dealy
			if (e)
			{
				c = TRUE;
				if (e.think == SUB_regen)
				if (e.nextthink > (time + PK_TUR_INVRETIME))
					e.nextthink = time + PK_TUR_INVRETIME; // we retime invulnerables if inf turrets exist - this is an exploitable item
			}

//q2 invuln
			f = pk_mcode("item_invulnerability", world); 
			e = find(world, classname, "item_invulnerability"); 
//			if (!e) e = find(world, sscode, ftos(f));
			if (e)
			{
				c = TRUE;
				if (e.think == SUB_regen)
				if (e.nextthink > (time + PK_TUR_INVRETIME))
					e.nextthink = time + PK_TUR_INVRETIME;
			}

//q invuln
			f = pk_mcode("item_artifact_invulnerability", world); 
			e = find(world, classname, "item_artifact_invulnerability"); 
//			if (!e) e = find(world, sscode, ftos(f));
			if (e)
			{
				c = TRUE;
				if (e.think == SUB_regen)
				if (e.nextthink > (time + PK_TUR_INVRETIME))
					e.nextthink = time + PK_TUR_INVRETIME;
			}

			d = -1;
			if (MAP_MODE == "W") d = rint(random() * 2.35); //f = pk_mcode("d_art_invulnerable", world); 
			if (MAP_MODE == "Q3") d = rint(random() * 2.35);
			if (MAP_MODE == "D" || d == 0) f = pk_mcode("d_art_invulnerable", world); 
			if (MAP_MODE == "Q" || d == 1) f = pk_mcode("item_artifact_invulnerability", world); 
			if (MAP_MODE == "PK") f = pk_mcode("item_artifact_invulnerability", world); 
			if (MAP_MODE == "Q2" || d == 2) f = pk_mcode("item_invulnerability", world); 

			if (!c) fn_make(f, v0, null_string); // if we didnt find an invulernable, now make one
		}
	}

	// set the gun, so always lines up with the stand
	setorigin(self, self.turret_base.origin);

#ifdef enhanced
// fix attempt for "flying down" turret
//	if (self.velocity != self.turret_base.velocity) self.velocity = self.turret_base.velocity;
//	self.velocity_z = 0;

// this works...makes no sense, but it works
	if (self.velocity_z < 0) self.movetype = MOVETYPE_NONE;
#endifdef

	// check if needs to be seet solid
	if (self.solid == SOLID_NOT)
	{
		turret_checkIfCanBeSolid();
	}

	// set animation frame to the search frame
	self.frame = $gunsearch;

	// rotate and check for siting of the enemy
	self.angles = self.angles + '0 10 0'; // can be conditional for a 'track' only turret with no 360 search
	self.v_angle = self.angles;

	// try to find a enemy to target....
	turret_findTarget();

	// next check time
	self.nextthink = time + 0.1;
};


void() turret_findTarget =
{
	local float dist, tempDist, e;
	local entity head, selected;

//	if (BOTFREEZE) return; // Cataboligne - 6.9.10 - bot freeze affects these too

	// find the closest target within the current view of the turret.

	e = 0;
	self.style = 1000; // loop safety
	// max distance that the turret can "see"
	dist = 10000;
	selected = world;

	head = findradius(self.origin, dist);

	while(head && (self.style > 0))
	{
		if (head.health > 1)
		if (head.takedamage)
		if (head != self)
		if (head.classname != "beartrap")
		if (!((head.classname == "turret") && (head.owner == self.owner))) // target other players turrets - these things are viscious, hasnt any one seen screamers?
		if (head.classname != "turret_base")
		if (pk_art_movshot_ck(head, "turret")) // Cataboligne 8.12.9 purify - pk artifacts
	  //if (!(head.classname == "turret"))
	  //if (!(head.classname == "turret_base"))
		if ((self.turret_ownertimeout > 0 && self.turret_ownertimeout < time) || head != self.owner)
		if (!head.charmer || head.charmer != self.owner) // dont target owners helpers
	 	if (head.classname != "player" || !(head.items & IT_INVISIBILITY))
	  {
	    tempDist = vlen(head.origin - self.origin);
	  	traceline(self.origin, head.origin, TRUE, self);

	    if (trace_fraction >= 1)
	    if (tempDist < dist)
//	    if (turret_inFront(head))
		 if(infront(head, SENTRY_SDOT, self.v_angle, v0)) // this is PK100 compat code
	    if (visible(head))
	    {
		  	selected = head;
		    dist = tempDist;
	    }
	  }

		if ((time & 3) == 3)
		if (self.delay) // infinite turret check
		{
			if (head.classname == "turret")
			{
				if (vlen(self.origin - head.origin) < PK_TUR_CRITICALMASS_DIST) e = e + 1;
				if (e > PK_TUR_CRITICALMASS)
				{
					self.delay = CRIT_BLOW;
					turret_deathAnim();
					return;
				}
			}
			if (head.classname == "player")
			{
				if (head.invincible_finished > time)
				if (head.pkplus_actortype != PKPLUS_ACTORPENT)
				if (vlen(self.origin - head.origin) < PK_TUR_DEATHRAD)
				{
					turret_deathAnim();
					return;
				}

				if (PK_TUR_QUADCON)
				if (self.owner != head)
				if (head.super_damage_finished > time)
				if (head.pkplus_actortype != PKPLUS_ACTORQUAD)
				if (vlen(self.origin - head.origin) < PK_TUR_DEATHRAD)
				{
					self.owner = head;
					return;
				}
			}
		}

		self.style = self.style - 1;
	  head = head.chain;
	}

	// Make the turning sound.
	if (self.cnt < 61) // make noise for 30 rels - if timeout is longer or we are on ammo mode / inf
	if (self.turret_soundtimeout < time)
	{
		sound (self, CHAN_WEAPON, "weapons/sentry/turrt_3.wav", 1, ATTN_NORM);
		self.turret_soundtimeout = time + 0.5;
		self.cnt = self.cnt + 1;
	}

	// target found
	if (selected != world)
	{
		// set it as the enemy
	  self.enemy = selected;

	  // set view to the target
		self.angles = vectoangles(selected.origin - self.origin);

	  // Target Acquired...
//		sound (self, CHAN_AUTO, "weapons/sentry/turr_2b.wav", 1, ATTN_NORM);

	  // attack target now

	  // attack until can't see anymore.
		self.think = turret_attackEnemy;
	}
};



// modification of infront() from ai.qc to be tighter
/*
float (entity e) turret_inFront =
{
	local vector  vec;
	local float    dot;

	makevectors (self.v_angle);
	vec = normalize (e.origin - self.origin);
	dot = vec * v_forward;

	if (dot > 0.8)
	{
	  return TRUE;
	}
	return FALSE;
};

*/


void() turret_attackEnemy =
{
/*
	if (BOTFREEZE) // Cataboligne - 6.9.10 - bot freeze affects these too
	{
		self.nextthink = time + 5;
		return;
	}
*/

	if (self.turret_timeout)
	// check if the turret time is up
	if (self.turret_timeout < time) {
	  turret_deathAnim();
	  return;
	}

	// set the gun, so always lines up with the stand
	setorigin(self, self.turret_base.origin);

	self.nextthink = time + 0.1; // Cataboligne - 6.14.10 - moved here to stop turret freeze ups

	// check if needs to be seet solid
	if (self.solid == SOLID_NOT)
	{
		turret_checkIfCanBeSolid();
	}

 	if (self.ammo_cells > 0 || !self.currentammo) {
		// attack frame's
		self.frame = self.frame + 1;

		// loop if at end of anim
		if (self.frame > 5) {
			self.frame = $gunfire1;
		}
	}
	else
	{
	  // Not enough ammo
		if (random() < PK_TUR_RELOAD) self.ammo_cells = PK_TUR_AMMO + random() * PK_TUR_AMMO; // reloaded
		else
		if (self.frame != 5)
	  {
			self.frame = $gunmisfire1;
			sound (self, CHAN_WEAPON, "weapons/sentry/turcl_2b.wav", 0.2, ATTN_NORM);
	  }
	  else
	  {
			self.frame = $gunmisfire2;
			if (!self.turret_timeout) // no time - done when ammo runs out
			{
				turret_deathAnim();
				return;
			}
	  }
	}

	// if still visiable & alive
	if (visible(self.enemy) && self.enemy.health > 1 && (self.enemy.classname != "player" || !(self.enemy.items & IT_INVISIBILITY)))
	{
		local vector targetview;

	  // set view to the target
	  targetview = vectoangles((self.enemy.origin + self.enemy.view_ofs)- self.origin);

	  if (targetview != self.angles)
	  {
			self.angles = targetview;

	    if (self.turret_soundtimeout < time)
	    {
	      sound (self, CHAN_WEAPON, "weapons/sentry/turrt_3.wav", 1, ATTN_NORM);
	      self.turret_soundtimeout = time + 0.5;
			self.cnt = self.cnt + 1;
	    }
	  }

	  // attack target now if you can
//	  if (self.attack_finished < time)
		if (self.frame == 1 || self.frame == 3)
	  {
	  	if (self.ammo_cells > 0 || !self.currentammo)
	    { // is there enough ammo to fire?
	    	local vector firePosition;
				makevectors (self.angles);
	      if (self.frame == 1)
	      {
	      	firePosition = self.origin + (v_up * 2) + (v_forward * 29) - (v_right * 3);
					turret_launchNail(firePosition, (self.enemy.origin + self.enemy.view_ofs) - firePosition);
	      }
	      else
	      {
	      	firePosition = self.origin + (v_up * 2)  + (v_forward * 29) + (v_right * 3);
					turret_launchNail(firePosition, self.enemy.origin - firePosition);
	      }

	      self.ammo_cells = self.ammo_cells - 1;
			self.cnt = 0; // fired. restart sound count down
	    }

	    // when can I attack again
//	    self.attack_finished = time + 0.5;
	  }
	}
	else
	{ // not visible, look for next target.
		self.think = turret_searchForEnemy;

	  // change back to gun search frame
		self.frame = $gunsearch;

	  // reset view angle to normal
	  self.angles_x = 0;
//	  self.angles_y = 0;
	  self.angles_z = 0;
		self.v_angle = self.angles;
	}

// check infinte turret stuff
	local entity head;
	local float e;
	head = findradius(self.origin, PK_TUR_DEATHRAD);
	e = 0;

	if (self.delay) // infinite turret check
	if ((time & 3) == 3) // every 3 rels?
	while(head)
	{
			if (head.classname == "turret")
			{
				if (vlen(self.origin - head.origin) < PK_TUR_CRITICALMASS_DIST) e = e + 1;
				if (e > PK_TUR_CRITICALMASS)
				{
					self.delay = CRIT_BLOW;
					turret_deathAnim();
					return;
				}
			}
			if (head.classname == "player")
			{

			if (head.invincible_finished > time)
			if (head.pkplus_actortype != PKPLUS_ACTORPENT)
			{
				turret_deathAnim();
				return;
			}

			if (PK_TUR_QUADCON)
			if (self.owner != head)
			if (head.super_damage_finished > time)
			if (head.pkplus_actortype != PKPLUS_ACTORQUAD)
			if (vlen(self.origin - head.origin) < PK_TUR_DEATHRAD)
			{
				self.owner = head;
				return;
			}

			}
	  head = head.chain;
	}
};


void() turret_deathAnim =
{
	local float numOfGibs;

	self.th_die = SUB_Null; // just in case - prevent a turret "death" loop

	if (self.delay == CRIT_BLOW) // critical mass check
	{
		local entity head;
		head = findradius(self.origin, PK_TUR_CRITICALMASS_DIST);

		while(head)
		{
			if (head.classname == "turret")
			if (head.delay != CRIT_BLOW)
			{
					head.delay = CRIT_BLOW;
					head.think = turret_deathAnim;
					head.nextthink = 1 + random() * 5; // spread out
			}
			head = head.chain;
		}
	}
	// ThrowGib is a function in player.qc
	turret_throwGib("progs/turgib1.mdl", -50);
	turret_throwGib("progs/turgib2.mdl", -50);
	turret_throwGib("progs/turgib3.mdl", -50);


	numOfGibs = random() * 5;

	while(numOfGibs > 0)
	{
		local float dam;
	  dam = random() * -50;
		turret_throwGib("progs/turgib3.mdl", dam);
	  numOfGibs = numOfGibs - 1;
	}

	remove(self.turret_base);
//	remove(self);

	T_RadiusDamage (self, self, 100, self);

	// Taken from the function T_MissileTouch in weapons.qc
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	// Functions is in weapons.qc
	BecomeExplosion ();
};


/*

// deprecated - no longer used

void() turret_deathAnimBase =
{
	self = self.owner;
	turret_deathAnim();
};
*/

void(string gibname, float dm) turret_throwGib =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
	new.classname = "turret_gib";
	new.owner = self.owner;
	new.touch = turret_gibTouch;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(new);
};


void() turret_gibTouch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		return;
	}

	org = self.origin - 8 * normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (other, org, self.velocity * 0.2, 10);
		T_Damage (other, self, self, 10);

		remove(self);
	  return;
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
};


// fn(chaos_sentry_lt) - fire lightning bolts from sentrys

void(vector org, vector vec) chaos_sentry_lt =
{
	if (self.t_width < time)
	{
		sound (self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}

	traceline (org, org + vec * 600, TRUE, self);
//	beam4(org, trace_endpos, LT_NEG);
	  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	  WriteByte (MSG_BROADCAST, TE_LIGHTNING3);
	  WriteEntity (MSG_BROADCAST, self);
	  WriteCoord (MSG_BROADCAST, org_x);
	  WriteCoord (MSG_BROADCAST, org_y);
	  WriteCoord (MSG_BROADCAST, org_z);
	  WriteCoord (MSG_BROADCAST, trace_endpos_x);
	  WriteCoord (MSG_BROADCAST, trace_endpos_y);
	  WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage(org, trace_endpos + vec * 4, self, self.dmg);
};

void(vector org, vector vec) turret_launchNail =
{
//	local entity newmis;
//															bits:		1 - orange kryptonite nails,	2 - lasers,	4 - pulse nails,	8 - lightning,	16 - rockets,	not done yet - 	32 - railgun,		64 - chaos

	if (self.state == 2)
	{
		LaunchLaser(org, vec);
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
		newmis.dmg = self.dmg;
		newmis.weapon = PK_IT_TURRET;
		return;
	}
	else if (self.state == 4)
	{
		if (self.attack_finished > time) return;
	}
	else if (self.state == 8)
	{
		if (self.attack_finished < time)
		{
			chaos_sentry_lt(org, vec);
			self.attack_finished = time + 0.5;
		}
		return;
	}
	else if (self.state == 16)
	{
		if (self.attack_finished < time)
		{
			local float ca;
			ca = self.currentammo;
//			self.v_angle = org + vec; // we hope
			W_FireRocket();
			setorigin(newmis, org);
			newmis.velocity = normalize((self.enemy.origin + self.enemy.view_ofs) - org);
			newmis.velocity = newmis.velocity * 800;
			newmis.angles = vectoangles (newmis.velocity);
			newmis.dmg = self.dmg;
			setorigin (newmis, org + v_forward * 31);
			self.attack_finished = time + 0.75;
			self.currentammo = ca;
			newmis.weapon = PK_IT_TURRET;
		}
		return;
	}

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "spike"; // Cataboligne - 6.11.10 - these were hard to id in other checks
	newmis.weapon = PK_IT_TURRET;
//	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, v0, v0);

	newmis.skin = 1; // orange kryptonite nails
	newmis.modelflags = MF_GRENADE;

//	setmodel (newmis, "progs/nail.mdl"); // removed

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = spike_touch;

// new damage setting
	newmis.dmg = self.dmg; // 15
	if (random() < 0.03) newmis.dmg = (self.dmg * 2) + random() * self.dmg; // some nails are "super", must be the orange kryptonite

	// For the correct death messages
	newmis.pk_currentitem = PK_IT_TURRET;
	newmis.weapon = IT_AXE;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(newmis);


	if (self.state == 4)
	{
		sound (self, CHAN_WEAPON, "weapons/pulse/pulse_1.wav", 1, ATTN_NORM);
		self.attack_finished = time + 0.35;
		newmis.touch = spike_touch;
		newmis.theowner = self.owner;
		newmis.classname = "pulse_spike";
		newmis.wad = "turret"; // Cataboligne - 11.5.13 - still having obit issues
//		setmodel (newmis, "progs/spike.mdl");
		newmis.skin = 3;
	}
	else
		sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
};

/* removed for spike_touch
void() turret_nailTouch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	org = self.origin - 8 * normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (other, org, self.velocity * 0.2, self.dmg);
		T_Damage (other, self, self.owner, self.dmg);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);
};
*/

void() turret_checkIfCanBeSolid =
{
	local entity head;
	local float f;

	f = TRUE;  // Cataboligne - UNK.10 - fix broken solidify code

	// see if there are any objects that block the turret from becoming solid
	head = findradius(self.origin, 28);
	while (head)
	{
		if (head != self.turret_base && head != self) f = FALSE;
		head = head.chain;
	}

	if (f)
	{
		// if can become solid!!!
		self.turret_base.solid = SOLID_BBOX;
		self.solid = SOLID_BBOX;

	  // make correct size
//		setsize(self, '-15 -14 -18', '21 7 10');
		setsize(self, '-12 -12 -24', '12 12 12');
//		setsize(self.turret_base, '-15 -14 -18', '9 14 1');
	}
};

