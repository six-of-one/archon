/*
		+---------------------------------------+
		|  sphere of annihilation               | SEC-HEAD
		+---------------------------------------+
*/

// 10.28.14 - fixed touch reverse issues - items with a touch field were not being touched
// 10.23.14 - added: sphere go wild, random entity suck in, teleport wild sphere to new location
// 10.22.14 - added: occasionally teleport instead of destroy, try to use ai_walk to move a wild sphere - does not seem to work in game
// 10.29.14 - reality bomb expands as it runs


// sphere special flags
float FL_ANNIHILATED			= 8192; // something has already been annihilated once - like monsters
// sphere move states
float ST_FREEZE				= -500;
float ST_FOLLOW				= -501;
float ST_ANGLE					= -502;
float ST_VOLUME				= -503;
float SP_MAXDIST				= 150; // cant control from further away than this


void() gravity_pull;
void() gravity_touch;

//entity sphere_a; // only one of these ever

// the venerable ad&d standard super disposal device and mayhem maker

// live7 - super eye added for monster_eye

// skins - black (soa), (1-4 group) tele sphere, ghroth (see __deriv dir)

$frame live1 live2 live3 live4 live5 live6 live7
$frame grvbomb1 grvbomb2 grvbomb3 grvbomb4 grvbomb5 grvbomb6 grvbomb7 grvbomb8 grvbomb9 grvbomb10 grvbomb11 grvbomb12 grvbomb13 grvbomb14 grvbomb15 grvbomb16 grvbomb17 grvbomb18 grvbomb19 grvbomb20
$frame die1 die2 die3 die4 die5 die6 die7

// dist to grab stuff when touching sphere - not all things call touch fn
float SPHERE_HORIZON_CLI = 30; // client check 
float SPHERE_HORIZON_ENT = 45; // general entity check
float SPHERE_HORIZON = 100; // pull in missiles at this dist

// sphere of annihilation code - for now summoned by shalrath
	
// IDEA: if summoner killed, the sphere goes wild!
// IDEA: move think code

// fn(sphere_annihilation_move) - move sphere - think fn for wild sphere & pulse of controlled sphere
// fn(sphere_annihilation_death) - sphere dying
// fn(sphere_become_gravbomb) - dying or unused sphere becomes gravity well
// fn(sphere_annihilation_touch) - things touch sphere

void() sphere_gravity_pulse1 = [ $grvbomb1, sphere_gravity_pulse2 ] { gravity_pull(); };
void() sphere_gravity_pulse2 = [ $grvbomb2, sphere_gravity_pulse3 ] { gravity_pull(); };
void() sphere_gravity_pulse3 = [ $grvbomb3, sphere_gravity_pulse4 ] { gravity_pull(); };
void() sphere_gravity_pulse4 = [ $grvbomb4, sphere_gravity_pulse5 ] { gravity_pull(); self.scale = self.scale + self.aflag; };
void() sphere_gravity_pulse5 = [ $grvbomb5, sphere_gravity_pulse6 ] { gravity_pull(); };
void() sphere_gravity_pulse6 = [ $grvbomb6, sphere_gravity_pulse7 ] { gravity_pull(); };
void() sphere_gravity_pulse7 = [ $grvbomb7, sphere_gravity_pulse8 ] { gravity_pull(); self.scale = self.scale + self.aflag;  };
void() sphere_gravity_pulse8 = [ $grvbomb8, sphere_gravity_pulse9 ] { gravity_pull(); };
void() sphere_gravity_pulse9 = [ $grvbomb9, sphere_gravity_pulse10 ]
{
	gravity_pull();
	if ((self.attack_finished - time) > 8)
	if ((time & 7) == 4)
		sound (self, CHAN_BODY, "misc/ambient/machine6.wav", 1, ATTN_NORM); // IMP: better sound
};
void() sphere_gravity_pulse10 = [ $grvbomb10, sphere_gravity_pulse11 ] { gravity_pull(); };
void() sphere_gravity_pulse11 = [ $grvbomb11, sphere_gravity_pulse12 ] { gravity_pull(); };
void() sphere_gravity_pulse12 = [ $grvbomb12, sphere_gravity_pulse13 ] { gravity_pull();  self.scale = self.scale + self.aflag; };
void() sphere_gravity_pulse13 = [ $grvbomb13, sphere_gravity_pulse14 ] { gravity_pull(); };
void() sphere_gravity_pulse14 = [ $grvbomb14, sphere_gravity_pulse15 ] { gravity_pull(); };
void() sphere_gravity_pulse15 = [ $grvbomb15, sphere_gravity_pulse16 ] { gravity_pull(); };
void() sphere_gravity_pulse16 = [ $grvbomb16, sphere_gravity_pulse17 ] { gravity_pull();  self.scale = self.scale + self.aflag; };
void() sphere_gravity_pulse17 = [ $grvbomb15, sphere_gravity_pulse18 ] { gravity_pull(); };
void() sphere_gravity_pulse18 = [ $grvbomb13, sphere_gravity_pulse19 ] { gravity_pull(); };
void() sphere_gravity_pulse19 = [ $grvbomb11, sphere_gravity_pulse20 ] { gravity_pull(); };
void() sphere_gravity_pulse20 = [ $grvbomb9, sphere_gravity_pulse1 ]
{
	gravity_pull();
	if ((self.attack_finished - time) > 8)
	if ((time & 7) == 4)
		sound (self, CHAN_BODY, "misc/ambient/machine6.wav", 1, ATTN_NORM); // IMP: better sound
	self.aflag = 0.02;

	self.maxs_x = 7 * self.scale;
	self.maxs_y = 7 * self.scale;
	self.maxs_z = 7 * self.scale;
	self.mins_x = -7 * self.scale;
	self.mins_y = -7 * self.scale;
	self.mins_z = -7 * self.scale;
	setsize(self, self.mins, self.maxs);

};

void() sphere_become_gravbomb =
{
	sphere_a = world;
	self.owner = world; // kill owner now
	if (self.count)
		self.attack_finished = self.count;
	else
		self.attack_finished = time + 4.0 + random() * 4;
	self.aflag = 0.2;
	self.touch = gravity_touch;
	self.effects = self.effects | EF_BRIGHTLIGHT;
	self.think = sphere_gravity_pulse1;
	self.nextthink = time + 0.1;
	sound (self, CHAN_BODY, "grav/grav_new.wav", 1, ATTN_NORM);
};

float rngbm;

// die sound
void() sphere_annihilation_death  = [ $die1, sphere_annihilation_death2 ] { self.owner = world; rngbm = random() * 0.2; };
void() sphere_annihilation_death2 = [ $die2, sphere_annihilation_death3 ] { if (random() < rngbm) sphere_become_gravbomb(); };
void() sphere_annihilation_death3 = [ $die3, sphere_annihilation_death4 ] { if (random() < rngbm) sphere_become_gravbomb(); };
void() sphere_annihilation_death4 = [ $die4, sphere_annihilation_death5 ] {};
void() sphere_annihilation_death5 = [ $die5, sphere_annihilation_death6 ] { if (random() < 0.5) if (random() < rngbm) sphere_become_gravbomb(); };
void() sphere_annihilation_death6 = [ $die6, sphere_annihilation_death7 ] { if (random() < 0.3) if (random() < rngbm) sphere_become_gravbomb(); };
void() sphere_annihilation_death7 = [ $die7, SUB_Null ]
{
	remove(self);
	sphere_a = world;
};

// for now this is animation code - free spheres do not move on thier own - but they need to

float sphere_audio;
float SPHERE_AUDIO_LIMIT = 3;

void() sphere_annihilation_move =
{
	local float r1, v1;

// wild sphere thoughts
	if (!self.owner)
	if (self.movetype)
	{
		if (self.state == ST_FOLLOW)
		{
			if (random() < 0.06) self.state = 0;
			self.walkframe = 0;
			ai_walk(self.lefty); // but this does not seem to work ?
		}
		else
		{
			if (random() < 0.1) self.state = ST_FOLLOW;
			self.lefty = 2 + random() * 8;
		}
	}

// sphere - chance of going wild ever 7 = 7 rels
	if (time & 7 == 7)
	if (self.owner)
	{
		if (self.dmg > 100)
		if (random() < 0.05)
		{
			self.owner = world; // oh shit - free sphere
		}

		if (self.dmg > 500)
		if (random() < 0.1)
		{
			self.owner = world;
		}

		if (self.dmg > 2000)
		if (random() < (self.dmg / 10000)) // eventually - uncontrollable
		{
			self.owner = world;
		}
	}
	else
	{
		if (random() < 0.07) archon_bouncer(self); // boink!
	}

	self.nextthink = time + 0.1 + random();
	if (random() < 0.2) self.frame = self.frame + crandom();

	if (self.frame > $live6) self.frame = $live1;
	if (self.frame < $live1) self.frame = $live6;

	if (random() > 0.6) self.avelocity = '0 0 0';
	else
	{
		r1 = random();
		v1 = random() * 600;
		if (r1 < 0.33) self.avelocity_x = crandom() * v1;
		else if (r1 < 0.66) self.avelocity_y = crandom() * v1;
		else self.avelocity_z = crandom() * v1;
	}


#ifdef warning
if (WARNING & 32)
if (self.classname != "chaos_teleport_icon")
if (self.classname != "sphere_annihilation")
{
		bprint("*** dev: SoA_move classn = ");
		bprint(self.classname);
		bprint(" - netn = ");
		bprint(self.netname);
//		bprint(item_ident(self));
		bprint("\n");
}
#endifdef



	if (self.classname == "chaos_teleport_icon")
	{
		if (self.model != self.mdl) {self.model = self.mdl; // CHECK: fix attempt for sum cube made sphere issue - maybe remove later

#ifdef warning
bprint("\n\n\n*** *** *** *** *** chaos teleport model restore\n\n\n\n");
#endifdef

}

	if (self.trigger_field)
	{
/* TEST
		if (random() < 0.02)
		{
		if (self.trigger_field.aflag) self.trigger_field.aflag = 0;
		else */
			if (self.trigger_field.aflag != -666)
				self.trigger_field.aflag = CHAOS_UNSTABLE_TELE; // base chance of selecting new dest
//		}
/*
		if (random() < 0.2) // simple bobber code - doesnt work
		{
			v2 = self.origin;
			v2_z = v2_z + crandom();
//			if (fabs(v2_z - self.oldorigin_z) < 21)
				setorigin(self, v2);
		}
*/
		setorigin(self.trigger_field, self.origin); // field follows icon
	}

		if (self.search_time < time)
		{
		r1 = self.effects;
		if (random() > 0.7) self.effects = EF_DIMLIGHT;
		else if (random() < 0.1) self.effects = EF_BRIGHTLIGHT;
		else self.effects = 0;
		if (r1 != self.effects) self.search_time = time + 4 + random() * 4; // dont change this for a bit
		}

		if (random() < 0.05)
		{
			if (self.aiment)
			{
//				self.aiment.search_time = 0;
//				remove(self.aiment); // aiment is audio source - loop_play does null & remove
				sound (self.aiment, self.aiment.cnt,"misc/null.wav",1,ATTN_NORM);
//				self.enemy.aiment.search_time = 0;
				remove(self.aiment); // Cat - 10.31.12 - now removing these
				self.aiment = world;
				sphere_audio = sphere_audio - 1;
				if (sphere_audio < 0) sphere_audio = 0;
			}
		}
		else
		if (!self.aiment && random() > 0.85)
		if (sphere_audio < SPHERE_AUDIO_LIMIT)
		{
			self.aiment = loop_sound(self, CHAN_WEAPON,"alt_ambience/hum1.wav", 0.9, ATTN_NORM, 3.62, self.origin, 0, LOOPFOREVER);
			sphere_audio = sphere_audio + 1;
		}
	}
// IDEA self.count < time - 120 = start checking after 2 mins, when something sucked in self.count = time
};

/*
		+---------------------------------------+
		|  Annihilation code                    | SEC-HEAD
		+---------------------------------------+
*/
/*
cant destroy - 
ideally - any trigger, telelport, map feature, static models, lights, control ents

SOLID_BSP
SOLID_TRIGGER
MOVETYPE_PUSH

if held it must be dropped
if player, any vw_* must be removed
if turret, must remove stand

*/

void () respawnBot;

// fn(annihilate) - it gets destroyed in the portable stable black hole

// ents sucked into sphere as fn of 1/6 of 1st dist to sphere, along that vector - all other motion stops
// FL_ANNIHILATED - for monster so heads can also be sucked
// self.cnt - countdown to destruction & motion into sphere

// NOTE: it is possible for some missile to evade motion into sphere somehow

void() annihilate =
{
	local float f;

	self.nextthink = time + 0.1;

	if (self.flags & FL_ITEM) 						// get rid of respawns right away - avoids repositioning issues with using setorigin
//	if (self._stand == SUB_regen)			// regen respawn items - to do other wise would make shalraths really cruel
	if (self.event != "dynamic_item")
	{
		self.model = null_string;
		self.solid = SOLID_NOT;
		if (deathmatch == 1)
		{
			self.nextthink = time + RSP_TIME;
			self.think = SUB_regen;
		}
//		set_respawn();
		return;
	}

	if (self.cnt < 0)
	{
// suck sounds - mebbe 3

#ifdef warning
if (WARNING & 32)
{
		bprint("		----> Destroying ");
		bprint(self.classname);
		bprint("\n");
}
#endifdef

 // dont re-annihilate
		self.nextthink = -1;
		self.think = SUB_Null; // just in case some deaths dont set think fn

		self.rad_time = 0;
		if ((self.flags & FL_MONSTER) && ! self.flags & FL_ANNIHILATED)
		{
			T_Damage (self, world, world, self.health * 3);
			self.flags = self.flags | FL_ANNIHILATED; // allow head to be sucked
			return;
		}
		else if (self.flags & FL_CLIENT) // gib players - gibs should be sucked
		{
				if (self.classname == "pk*bot")
				{
					self.think = respawnBot;
					self.nextthink = time + 10 + random() * 45;
				}
				self.invincible_finished = time - 1; // not invincible enough
				CheckPowerups();
				T_Damage (self, world, world, self.health * 5 + 100); // this shit can kill anybody

				if (self.flags & FL_CLIENT)
				if (self.mask_x & MORPH_ARCHON)
				if (self.AIRG_Timeout != -6)
				{
					self.velocity = v0;
					self.attack_finished = time + 3;
					self.AIRG_Timeout = -6;
					power_drain(self);
					newmis.owner = world;
					newmis._alt_fire = archon_bouncer;
					newmis.wait = 0.1;
					newmis.archon = 50 + random() * 50;
					newmis.count = 5 * newmis.archon * ceil(0.4 + (3 * random()));
					self.nextthink = time + 2;
					self.think = player_run;
				}
				return;
		}
		if (self.classname == "Harpoon")
		{
			if (self.th_stand != SUB_Null) self.th_stand();
		}
		else
			SUB_Remove(); // for all the other ents... buh-bye
		return;
	}

	self.cnt = self.cnt - 1;
};

// fn(annihilation_check) - find out if we can destroy something

// returns TRUE if ent can be annihilated

// xTDO: comparison into cmod code ? - not sure of purpose, its likely meant to compare to move_check

float(entity g) annihilation_check =
{
	float t,f;
	t = TRUE;

	if (g.class_select == "class_missile") f = TRUE;
	else if (IS_MISSILE(g)) f = TRUE;

	if (g == world) t = FALSE;
	else if (g == sphere_a) t = FALSE;
	else if (g.think == annihilate) t = FALSE; // already annihilating
	else if (g.model == null_string) t = FALSE;
	else if (g.classname == "whirl") t = FALSE;
	else if (g.classname == OBSERVER) t = FALSE;
	else if (g.flags & FL_CLIENT && g.health <= 0) t = FALSE;
	else if (g.flags & FL_CLIENT && vlen(g.origin - sphere_a.origin) > SPHERE_HORIZON_CLI) t = FALSE;
	else if (g.classname == "viswep" && g.owner != world) t = FALSE; // viswep held by player
	else if (! f && vlen(g.origin - sphere_a.origin) > SPHERE_HORIZON_ENT) t = FALSE;
	else if (vlen(g.origin - sphere_a.origin) > SPHERE_HORIZON) t = FALSE;
	else if (g.model == null_model) t = FALSE; // note - not the same as null_string
	else if (g.solid == SOLID_TRIGGER && g.movetype == MOVETYPE_NONE) t = FALSE;
	else if (g.solid == SOLID_BSP) t = FALSE;
	else if (g.movetype == MOVETYPE_PUSH) t = FALSE;
//	else if (g.classname == "crosshair_targeter") t = FALSE; // removed

	return(t);
};

// fn(set_annihilate) - set up an ent to get annihilated

// g - entity to annihilate

void(entity g) set_annihilate =
{
	local float t;

	if (g.classname == "gravity") // whoopsie - note: maybe this should be even more violent
	{
		if (g.frame > 19) self.scale = 2; // sgw effect // $cubelf20 - frame 19
		t = g.attack_finished - time; // time left on grav well
		if (t < 0) t = 2 + random() * 4;
		remove(g);
		sphere_a.think = sphere_become_gravbomb; // self might not be sphere
		sphere_a.count = time + (t * 48) + random() * 100;
		bprint("\nSome idiots just put a sphere of annihilation and a gravity well together!\nSmooth move on making a \bReality Bomb\b genius!\n");
		return;
	}

	if (g.classname == "chaos_teleport_icon") // NOTE: if this is the anti-sphere this is the place to do it
	{
		g.classname = "whirl"; // block repeater
		g.trigger_field.touch = SUB_Null; // allow no more teleports
		dyn_remove(g, 1, chaos_tele_expire); // cant call tele_exp directly
		return;
	}


#ifdef warning
if (WARNING & 32)
{
		bprint("*** dev: set_annihilate on - ");
		bprint(item_ident(g));
		bprint("- from self = ");
		bprint(item_ident(self));
		bprint("\n");
}
#endifdef

	g.think = annihilate;
	g.nextthink = time + 0.02;
	g.touch = SUB_Null; // touch is restored by SUB_Regen
	g.effects = 0;
	g.attack_finished = time + 20;
//	content_clear(g);
//	if (g.flags & FL_HELD) {drop_held(g, v0); if (WARNING & 32) bprint("sphere annihilate - item drop\n");} // item_held()
	g.cnt = 2;
	g.velocity = v0;
	g.dest1 = g.origin - sphere_a.origin + '0 0 12';
};

void() sphere_annihilation_touch =
{


#ifdef warning
if (WARNING & 32)
if (other)
if (other.think != annihilate)
if (other.deathtype != "SOA")
{
		other.deathtype = "SOA";
		bprint("*** dev: SoA_touch classn = ");
		bprint(self.classname);
		bprint(" - netn = ");
		bprint(self.netname);
		bprint(" --- other classn = ");
		bprint(other.classname);
		bprint(" - netn = ");
		bprint(other.netname);
//		bprint(item_ident(self));
		bprint("\n");
}
#endifdef



	if (random() < 0.02) // its other's lucky rel - teleport this one thing
	{


#ifdef warning
if (WARNING & 32)
{
		bprint("*** dev: SoA sneak teleported - ");
		bprint(item_ident(other));
		bprint("- from self = ");
		bprint(item_ident(self));
		bprint("\n");
}
#endifdef


		archon_bouncer(other);
	}
	else

	if (annihilation_check(other))
	{
		self.dmg = self.dmg + 1;
		set_annihilate(other);
	}
};

// reverse touch - called from other item touch function
// -- because for some reason touchable items are not annihilating

void() sphere_annihilation_reverse_touch =
{



#ifdef warning
if (WARNING & 32)
if (self.think != annihilate)
if (self.deathtype != "SOA")
{
		self.deathtype = "SOA";
		bprint("	  *** dev: SoA_touch \breversed\b classn = ");
		bprint(self.classname);
		bprint(" - netn = ");
		bprint(self.netname);
		bprint(" --- other classn = ");
		bprint(other.classname);
		bprint(" - netn = ");
		bprint(other.netname);
//		bprint(item_ident(self));
		bprint("\n");
}
#endifdef



	if (random() < 0.02) // its other's lucky rel - teleport this one thing
	{
		archon_bouncer(self);


#ifdef warning
if (WARNING & 32)
{
		bprint("*** dev: SoA sneak teleported - ");
		bprint(item_ident(other));
		bprint("- from self = ");
		bprint(item_ident(self));
		bprint("\n");
}
#endifdef


	}
	else

	if (annihilation_check(self))
	{
		other.dmg = other.dmg + 1;
		set_annihilate(self);
	}
};

// fn(sphere_annihilation_spawn) - create one of these nasty things

void() sphere_annihilation_spawn =
{
	sphere_a = chaos_spawn(MOVETYPE_FLY, SOLID_BBOX, 0, 0, self.origin + '0 0 24' + v_forward * 60, '-7 -7 -7', ' 7 7 7', '0 0 0', '0 0 0', "sphere_annihilation", "progs/sphere_annihilation.mdl", sphere_annihilation_touch, 0.1, sphere_annihilation_move, sphere_annihilation_death, self, world); // here we divide by zero...
	sphere_a.wait = time + 3;// TEST120; // cant kill off for this long
	sphere_a.dest1 = sphere_a.origin - sphere_a.owner.origin; // position from holder
	sphere_a.dest2_z = sphere_a.lefty = 0; // location controls
	sphere_a.state = ST_FOLLOW; // tag along to start
	sphere_a.frame = $live2;
	sphere_a.skin = 0; //2;
	sphere_a.scale = 1;
	sphere_a.map = "sphere_annihilation"; // double check search
// spawn sound?




#ifdef warning
if (WARNING & 32)
{
		bprint("*** dev: SoA_spawn classn = ");
		bprint(self.classname);
		bprint(" - netn = ");
		bprint(self.netname);
//		bprint(item_ident(self));
		bprint("\n");
}
#endifdef




};

// whirl things around

void() sphere_whirl =
{
	local float d;
	local vector org;
	local float gPercent;
	local float gDist = 960;		// range of the weapon
	local float gPower = 512;

	org = (sphere_a.absmin + sphere_a.absmax) * 0.5;

	d = vlen(self.origin - org);
	gPercent = 1 - (d / gDist);

	self.velocity = self.velocity + normalize(sphere_a.origin - self.origin) * gPower * gPercent;

	if (self.attack_finished < time) set_annihilate(self); // whirl for a bit then go away

	self.nextthink = time + 0.1;
};

// fn(sphere_annihilation_phys_move) - move the sphere and its flotsam in physics code - following controller player / monster

// IDEA: when a player controls it, use attach method if in dp, instead of jump follow

void() sphere_annihilation_phys_move =
{
	local entity head;
	local float f;

	if (sphere_a.classname != "sphere_annihilation") // something has gone wrong with the pointer!
	{
		sphere_a = find(world, map, "sphere_annihilation");
//		if (head) remove(head); // get rid of it - cant control with global and we'd rather not reass.
//		sphere_a = world; // finally - clear it
		return;
	}

	if (sphere_a.owner)
	if(sphere_a.state != ST_FREEZE) // move sphere with controlling player
	{
		local float d1;
		local vector an;
		d1 = vlen(sphere_a.dest1);
		an = sphere_a.owner.angles;
		an_y = an_y + sphere_a.lefty;
		makevectors(an);
		normalize(v_forward);
		setorigin(sphere_a,  sphere_a.owner.origin + sphere_a.dest2 + d1 * v_forward);
	}


	head = findradius(sphere_a.origin, SPHERE_HORIZON); // check for things flying by - suck missiles out of the air
	if (sphere_a.delay < time)
	{
		sphere_a.delay = time + 0.05;
		while (head)
		{
			if (annihilation_check(head))
			{
				f = FALSE;
				if (head.class_select == "class_missile") f = TRUE;
				else if (IS_MISSILE(head)) f = TRUE;
				if (head.classname == "fireball") f = TRUE;
				if (head.classname == "bubble") f = TRUE;

				if (time & 3 == 3)
				if (!f)
				{
					if (self.dmg > 30)
					if (random() < 0.03) // random suck up
					{
						f = TRUE;
					}
					if (self.dmg > 300)
					if (random() < 0.09)
					{
						f = TRUE;
					}
				}

				if (f)
				{
					head.dest1 = head.origin - sphere_a.origin;
					if (vlen(head.dest1) > 20)
 					{
						head.touch = SUB_Null;
						head.cnt = vlen(head.velocity);
						head.velocity = normalize(head.dest1) * -1;
						head.velocity = head.velocity * head.cnt;
						head.angles = vectoangles(normalize(head.velocity)); // point missiles at sphere
					}
					else
					{
						set_annihilate(head);
						head.cnt = -1; // zap missiles instantly
					}
				}
//				set_annihilate(head);
			}
			head = head.chain;
		}

// IMP: sound effect (maybe from black hole 06 ?)
		if (random() < 0.06) // sphere pulls particles out of air - IDEA: something else in water - whirl around sphere of water tex
		{
			f = FALSE;
			v1 = v0;
			if (random() < 0.75)
			while ( (v1_z > -48) && (!f) )
			{
				if (pointcontents(sphere_a.origin + v1) == CONTENT_LAVA) f = TRUE;
				v1_z = v1_z - 1;
			}
			newmis = chaos_spawn(MOVETYPE_TOSS, SOLID_BBOX, 0, RM_SKY,  sphere_a.origin , v0, v0, v0, v0, "whirl", "progs/steam.mdl", SUB_Null, 5 + random() * 4, SUB_Remove, SUB_Null, sphere_a, world);
			newmis.origin_x = newmis.origin_x + crandom() * 80;
			newmis.origin_y = newmis.origin_y + crandom() * 80;
			newmis.origin_z = newmis.origin_z + random() * 32;
			newmis.think = sphere_whirl;
			newmis.nextthink = time + 0.1;
			newmis.attack_finished = time + 3 + random() * 4;
			if (random() < 0.1 || f)
			{
				setmodel(newmis, "progs/lavaball.mdl");
				if (!f)
				if (random() < 0.5)
					newmis.effects = EF_NOMODELFLAGS;
				setsize(newmis, v0, v0);
				newmis.skin = 8 + rint(random() * 4);
				newmis.frame = 18 + rint(random());
			}
			if (f) // suck lava
			{
				newmis.skin = 0;
				newmis.frame = 2 + rint(random() * 2);
				newmis.origin_z = v1_z + crandom() * 5;
				newmis.velocity = v0;
				newmis.velocity_z = 20 + random() *  100;
				set_annihilate(newmis);
			}
		}
	}
	else
		while (head)
		{
			if (head.think == annihilate)
			if (!(head.flags & FL_ITEM) && head.event != "dynamic_item") // && head._stand == SUB_regen)) // dont even initially move respawnables
			{
				if (head.cnt > 0) setorigin(head, sphere_a.origin + head.dest1 * (head.cnt / 6)); // move'r into sphere
				else setorigin(head, sphere_a.origin);
			}
			head = head.chain;
		}
};

/*
		+---------------------------------------+
		|  Control code                         | SEC-HEAD
		+---------------------------------------+
*/

// player controls implemented - was only called from shalrath

// .dest1 - vector distance from player to sphere
// .dest2_z - sphere controlled hieght - FIX needs limits
// .lefty - radial bearing of sphere around player

// state control & banish

// impulse 13 = change sphere control mode for impulse 10 & 12, or leave sphere idle

void() sphere_attack =
{
	if (self.impulse == ALT_FIRE_IMP) // alt fire - allow reposition of sphere
	{
		if (sphere_a.state == ST_FOLLOW)
		{
			sphere_a.state = ST_ANGLE; // adjust sphere angle
//			sprint(self,"You can adjust the Sphere's bearing.\n");
		}
		else if (sphere_a.state == ST_ANGLE)
		{
			sphere_a.state = ST_FREEZE;
//			sprint(self,"Sphere is now idle - it will not follow you.\n");
			if (self.morphy == IMP_MSHALR) stuffcmd(self, "exec cfg/morph/m-shalrath.cfg\n");
			self.mcode = -662; // tell HUD sphere is fixed position
		}
		else
		{
			sphere_a.dest1 = sphere_a.origin - sphere_a.owner.origin; // position from holder
			if (vlen(sphere_a.dest1) > SP_MAXDIST)
			{
				self.mcode = -504; // tell HUD sphere is out of range
//				sprint(self,"Cannot regain control of sphere - it is too far away.\n");
				return;
			}
			sphere_a.state = ST_FOLLOW;
			if (self.morphy == IMP_MSHALR) stuffcmd(self, "exec cfg/morph/m-shalrath-soa.cfg\n");
			self.mcode = 0; // tell HUD back in control
		}
	self.mcode = sphere_a.state; // tells HUD sphere state
	return;
	}
	if (sphere_a.wait < time)
	{
		if (vlen(sphere_a.dest1) > SP_MAXDIST)
			sprint(self,"Cannot control sphere - it is too far away.\n");
		else if (self.archon < 251)
			sprint(self,"Cannot banish sphere - not enough archon power.\n");
		else
		{
			if (self.morphy == IMP_MSHALR) stuffcmd(self, "exec cfg/morph/m-shalrath.cfg\n");
			sprint(self,"Sphere of annihilation is banished.\n");
			sphere_a.think = sphere_annihilation_death;
			self.attack_finished = time + 1;
// use archon power
			if (self.volume < 0)
				self.archon = self.archon + self.volume;
			self.volume = 0;
			self.weapon = IT_SUPER_NAILGUN;
		}
	}
};

// positional controls

// IDEA: adjust size?

// impulse 10
// - increase height in follow mode
// - increase bearing angle in angle mode
// impulse 12
// - decrease height in follow mode
// - decrease bearing angle in angle mode

void() sphere_control =
{
	local float dx;
	local vector vx;

	if (self.impulse == 10) dx = 1;
	else if (self.impulse == 12) dx = -1;
	else return;

	vx = v0;
	vx_z = sphere_a.dest2_z + dx;
	if (sphere_a.state == ST_FOLLOW)
		if (vlen((sphere_a.origin + vx) - self.origin) < SP_MAXDIST)
			sphere_a.dest2_z = sphere_a.dest2_z + dx;

	if (sphere_a.state == ST_ANGLE) sphere_a.lefty = sphere_a.lefty + dx;
};
