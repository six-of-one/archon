/* ::-::
 *
 * Cataboligne
 *
 * file: m-chaos.qc
 *
 * date: 8/6/13
 *
 * qc - support chaos mod morph ability
 *
 */
 
 /*
Archon: CHAOS

"the Story"



 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/

$frame chaos1 chaos2 chaos3 chaos4 chaos5 chaos6 chaos7 chaos8 chaos9 chaos10 chaos11 chaos12 chaos13 chaos14  chaos15 chaos16 chaos17 chaos18 chaos19 chaos20
$frame chaosfade1 chaosfade2 chaosfade3 chaosfade4 chaosfade5 chaosfade6 chaosfade7 chaosfade8 chaosfade9 chaosfade10 chaosfade11 chaosfade12 chaosfade13

float CHAOS_FIREBOLT_FRAME_ADJ = 8;

/*
		+---------------------------------------+
		|  world code                           | SEC-HEAD
		+---------------------------------------+
*/

void() m_precache_chaos =
{
	precache_model ("progs/chaos_b2.mdl");
	precache_model ("progs/chaos_b3.1col.mdl");
	precache_model ("progs/chaos_b3.2rot.mdl");
	precache_model ("progs/chaos_b3.3rsm.mdl");

	precache_sound ("ambience/comp1.wav");
	precache_sound ("ambience/buzz1.wav");
	precache_sound ("boss2/idle.wav");
	precache_sound ("weapons/lhit.wav");
	precache_sound ("misc/power.wav");
	precache_sound ("chaos/lava1.wav");
//	precache_sound ("chaos/pist1.wav");
	precache_sound ("chaos/cbeam.1.wav");
	precache_sound ("chaos/cbeam.2.wav");
};

float FL_CSB						= 16; // star burst in progress
float FL_MELO						= 32; // move effect lock out - uses .wait
float FL_SPIKE						= 16384; // chaos morph only now
float FL_CBALL						= 32768; // chromatic ball chaos

// chaos  power is archon power now
float CHAOS_INC					= 10; // amount chaos increments by per frame
float CHAOS_DEC					= -7; // amount used firing beam
float CHAOS_ABSOLUTE				= 256000; // ultimate max chaos level - if this is reached, total chaos ensues
float MAX_CHAOS_LVL;//			= 16000;// max chaos level - when exceeded chaos star burst happens.
float MIN_CHAOS_DEC;//			= 3000; // min burst needs to dec
float CHAOS_BEAM_MIN;//		= 1000;
float CHAOS_BEAM_GAIN;					// beam min added to this - beam locked out after every up
float CHAOS_MELO_MIN;//		= 60; // min lockout time

// were in chaos.defs.qc
float FL_SAME						= 2; // make same thing
float FL_FFLY						= 8; // move field by velocity
float FL_FJUMP						= 4; // move field by setorg
float FL_FLIT						= 32768; // light field
float FL_FPART						= 65536; // particle field
float LT_CHAOS						= 7;  // chaos beam -- IMP: replace with some other effects system
float USE_PULSE_SPIKES			= -257368;
float C_FBPER						= 0.7; // % for chaos explode to fire bolts
float CFCBALL						= 207;
float ci_last, ci_fr, ci_sk, ci_flg; // last item made & frame set, master flag
string ci_md; // last item model
float CI_EXPLBOX					= 0.1; // % chance chaos item capable will become explode box
float CI_FLAMEREAL				= 0.2; // % chance chaos item tossed flame2.mdl burns
.float chaosattnoise; // IDEA: remove
// end


void() chaos_item;

// NOTE: keeping because archon power does not have a build cycle for Archons, yet



// fn(chaos_level) - set chaos level, maintain health for chaos
// cent - chaos entity to change level for
// l1 - level to add (- value subs, this is added to master)
// cent == world - add to master level
// since chaos morph cant get health boxes, health gets maintained here as fn() of chaos levels

void(float l1, entity cent) chaos_level =
{
	local float l2;

	l2 = 0;
	if (cent == world) world.archon = world.archon + l1;
	if (cent.classname == "player")
	{
		if (cent.morphy == IMP_MCHAOS) // IS_CHAOS(cent) - loop
		{
			if (cent.health < (cent.max_health * cent.health_modifier * 0.10)) l2 = 2 + random() * 8; // IDEA - health gain for any player setting chaos_level
			else if (cent.health < (cent.max_health * cent.health_modifier * 0.40)) l2 = 1 + random() * 4;
			else if (cent.health < (cent.max_health * cent.health_modifier * 0.95) && random() < 0.3) l2 = random() * 4;
			if (l2) cent.health = cent.health + l2;
			l2 = l1 - l2;
		}
		else
			l2 = l1;
		cent.volume = cent.volume + l2;
		if (l2 < 0) world.archon = world.archon - l2; // subtr from player, add back to master?
	}

//	if (cent.volume > CHAOS_ABSOLUTE || world.archon > CHAOS_ABSOLUTE) total_chaos();
};

// fn(chaos_constant) - set chaos contants

// dt - multiplication factor for existing contants
// CHECK - no safety for loop

void(float dt) chaos_constant =
{
	local float dx, dy;

	if (MAX_CHAOS_LVL < CHAOS_ABSOLUTE) dy = 1;
	if (dt && MAX_CHAOS_LVL && MIN_CHAOS_DEC && CHAOS_BEAM_MIN && CHAOS_MELO_MIN && dy) // upgrade
	{
		CHAOS_BEAM_GAIN	= MAX_CHAOS_LVL - MIN_CHAOS_DEC; // additive to min to fire beam
		MAX_CHAOS_LVL		= MAX_CHAOS_LVL * dt; // max chaos level - when exceeded chaos star burst happens.
		MIN_CHAOS_DEC		= MIN_CHAOS_DEC * dt; // min burst needs to dec
		CHAOS_BEAM_MIN		= CHAOS_BEAM_MIN * dt; // min to fire beam
		CHAOS_MELO_MIN		= CHAOS_MELO_MIN * dt; // min lockout time
	}
	else
	{
		MAX_CHAOS_LVL		= 16000;// 32000; // max chaos level - when exceeded chaos star burst happens.
		MIN_CHAOS_DEC		= 4000; // min burst needs to dec
		CHAOS_BEAM_MIN		= 2000; // min to fire beam
		CHAOS_MELO_MIN		= 120; // min lockout time
		CHAOS_BEAM_GAIN	= 0; // additive to min to fire beam
	}

	dx = 0.16;
	if (dt > 1.49 || dy < 1) // if increasing, randomize a bit
	while (random() < dx)
	{
		chaos_constant(1 + dx);
		dx = dx * (0.5 + random() * 0.3);
	}
//
													if (WARNING) if (TRUE) { bprint("next burst: "); bprint(ftos(MAX_CHAOS_LVL)); bprint(", lvl: "); bprint(ftos(self.volume)); bprint(", beam: "); bprint(ftos(CHAOS_BEAM_MIN)); bprint(", dt: "); bprint(ftos(dt)); newline(world); }
//
	if (MAX_CHAOS_LVL > CHAOS_ABSOLUTE) chaos_constant(0); // this really needs to fire of total levelwide chaos
};


/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

void() player_chaos_sight;
void() player_chaos_explode1;
void() player_chaos_unexplode1;
void(float flg) chaos_form;
void() chaos_bomb;
string(entity e) chaos_bomb_rndmdl;

// fn(chaos_morph_chg) - automated code to change morph to self.state or pl with polymorph check
// cent - change ent, will use self if this is world
// pl - new polymorph code, self.state used if invalid

void(entity cent, float pl) chaos_morph_chg =
{
	local entity sv;
	local float sf;
	local vector v1,v2;

	sv = self;
	if (cent != world) self = cent;
	if (!(pl > IMP_MIN && pl < IMP_MAX)) pl = self.state;

	if (pl == self.morphy) // already there
	{
		self = sv;
		return;
	}
	sf = self.volume;
	polymorph_check(pl, 0); // IDEA - small chance of taking another form?
	self.volume = sf;
	sf = 25;
	if (IS_CHAOS(self)) 
		{
		if (pl == self.state) { self.aflag = FL_MELO; self.wait = time + CHAOS_MELO_MIN + 30 * random(); }
		sf = 10 + random() * 35;
		}
	sf = sf + morph_heal(self, sf);
	if (pl == self.state)
		if (self.health < (self.max_health * self.health_modifier * 0.5))
			T_Heal(self, sf,0);
	self = sv;
};

// fn(chaos_morph_chgthk) - think to change morph

void() chaos_morph_chgthk =
{
	if (self.owner.model != "progs/null.mdl" && self.owner.model != "")
		chaos_morph_chg(self.owner, 0);
//	if (IS_CHAOS(self.owner)) chaos_poly = world;
	remove(self);
};

// fn(chaos_flycheck) - set proper movetype and sizeing
// e - ent to test & set
// md - model string

void(entity e, string md) chaos_flycheck =
{
	local float mt;

	mt = MOVETYPE_WALK;

//	if (!IS_CHAOS(e)) return; // do we need this check??
	if (md == "progs/teleport.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b2.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b3.1col.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b3.2rot.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b3.3rsm.mdl") mt = MOVETYPE_FLY;
//	if (md == "") mt = MOVETYPE_FLY;

// cheat a little bit - this should be down below
	if (mt == MOVETYPE_FLY)
		setsize (e, '-16 -16 -24', ' 16 16 40'); // flying states
	else
		setsize (e, '-16 -16 0', ' 16 16 56'); // model poly

	flyer_check(e, (mt == MOVETYPE_FLY));
};

// fn(chaos_base_mdl) - restore chaos to base model or any specced model

void(entity e, string md) chaos_base_mdl =
{
	local string md2;

	if (e.morphy != IMP_MCHAOS && e.state == IMP_MCHAOS)
		chaos_morph_chg(e, 0); // back to our own true morph, restores model - (! IS_CHAOS_PURE(self))
	else
	{
		if (md == "") md2 = "progs/chaos_b2.mdl";
		else md2 = md;
		if (self.model != md2)
		{
			setmodel(e, md2);

//			if (self.health < (self.max_health * self.health_modifier * 0.15)) self.health = self.health + 10 + random() * 50;
//			else if (self.health < (self.max_health * self.health_modifier * 0.30)) self.health = self.health + 5 + random() * 25;
//			else 
			if (self.health < (self.max_health * self.health_modifier * 0.90)) self.health = self.health + random() * 15;
		}
	}
	e.modelindex_morph=e.modelindex;
	chaos_flycheck(e, e.model);
};

// fn(chaos_mdlsize) - set sizes for certain models

/*
void(entity e) chaos_mdlsize =
{
	local vector vmin, vmax;
	if (!e) return;

	vmin = vmax = v0;
	if (e.model == "progs/teleport.mdl")			{ vmin = '-16 -16 -16'; vmax = ' 16 16 16'; }
	else if (e.model == "progs/lavaball.mdl" || e.model == "progs/snowball.mdl")
	{
		if (e.frame == 0 || e.frame == 5)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 2 || e.frame == 3 ||
			  e.frame == 7 || e.frame == 8)			{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
		if (e.frame == 4 || e.frame == 9)			{ vmin = '-1 -1 -1'; vmax = ' 1 1 1'; }
	}
	else if (e.model == "progs/grenade.mdl")
	{
		if (e.frame == 0)								{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; } // reg grenade
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; } // telespheres
		if (e.frame == 2 || e.frame == 7)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 3 || e.frame == 4 ||
			  e.frame == 8 || e.frame == 9)			{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
		if (e.frame == 5 || e.frame == 10)		{ vmin = '-1 -1 -1'; vmax = ' 1 1 1'; }
	}
	else if (e.model == "progs/proxbomb.mdl")	{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
	else if (e.model == "progs/hook.mdl")			{ vmin = '-5 -5 -5'; vmax = ' 5 5 5'; }
	else if (e.model == "progs/v_spike.mdl")		{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
//	else if (e.model == "progs/ejbatt.mdl")		{ vmin = '-2 -2 -6'; vmax = ' 2 2 4'; }
	else if (e.model == "progs/s_bubble.spr")	{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
	else if (e.model == "progs/chaos_b2.mdl")	{ vmin = '-16 -16 -24'; vmax = ' 16 16 40'; }
	if (vmin != v0 && vmax != v0) setsize(e, vmin, vmax);
};
*/

// fn(chaos_mdlsel) - select various map forms

string() chaos_mdlsel =
{
	local string s1;

	s1 = "spike ball";
	if (ci_md == "progs/teleport.mdl")				{ ci_md = "maps/b_rock0.bsp";					s1 = "rocket box"; }
	else if (ci_md == "maps/b_rock0.bsp")			{ ci_md = "maps/b_exbox2.bsp";				s1 = "explode box"; }
	else if (ci_md == "maps/b_exbox2.bsp")		{ ci_md = "progs/gas.mdl";						s1 = "gas cylinders"; }
	else if (ci_md == "progs/gas.mdl")				{ ci_md = "progs/drycel6.mdl";				s1 = "batterys"; }
	else if (ci_md == "progs/drycel6.mdl")		{ ci_md = "progs/quaddama.mdl";				s1 = "quad"; }
	else if (ci_md == "progs/quaddama.mdl")		{ ci_md = "progs/g_rock2.mdl";				s1 = "rocket launcher"; }
	else if (ci_md == "progs/g_rock2.mdl")		{ ci_md = "maps/b_bh100.bsp";					s1 = "health box"; }
	else if (ci_md == "maps/b_bh100.bsp")			{ ci_md = "progs/chaos_b2.mdl";				s1 = "natural state"; }
	else if (ci_md == "progs/chaos_b2.mdl")		{ ci_md = "progs/teleport.mdl"; }
	else ci_md = "progs/teleport.mdl"; // IDEA - custom forms that chaos beam has hit

	return(s1);
};

// fn(chaos_mdlchk) - returns false if chaos is any native model

float(string md) chaos_mdlchk =
{
	if (md == "progs/null.mdl") return FALSE; // dead state
	if (md == "progs/chaos_b2.mdl") return FALSE;
	if (md == "progs/chaos_b3.1col.mdl") return FALSE;
	if (md == "progs/chaos_b3.2rot.mdl") return FALSE;
	if (md == "progs/chaos_b3.3rsm.mdl") return FALSE;
	return TRUE;
};

// fn(chaos_mdlchg) - think to change forms

void() chaos_mdlchg =
{
	if (self.owner.morphy == IMP_MCHAOS) //(IS_CHAOS_PURE(self.owner))
	if (chaos_mdlchk(self.owner.model))
		{
		if (random() < 0.5) 	chaos_base_mdl(self.owner, "");
		else
			{
//			while (pointcontents(self.origin + ' 0 0 -26') == CONTENT_SOLID) setorigin(self, self.origin + ' 0 0 1');
			chaos_mdlsel();
			setmodel(self.owner,ci_md);
			chaos_flycheck(self.owner, self.owner.model);
			self.owner.modelindex_morph=self.owner.modelindex;
			if (ci_md != "progs/chaos_b2.mdl")
				chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "chaos_morph", "", SUB_Null, 10.0 + (random() * 110.0), chaos_mdlchg, SUB_Null, self.owner, world);
			}
		}
	remove(self);
}


// fn(chaos_teleport_restore_think) - think fn - send ent back to level if stuck outside or living ent cant move after teleport / forced move
// fn(chaos_teleport_restore) - spawn fn

// NOTE - spawn Must (MUST) be called before changing origin if items are moved, so a think can restore them from solids

// runs tests for 4 secs every .5 sec.  if all checks are non-solid test is removed
// other wise self.owner is teleported to a random level location
// self.oldorigin - test for monster movement from ai_run

// IDEA - wraiths too?
/*
void() chaos_teleport_restore_think =
{
	local entity e;
	local float t;
	local vector org;

	self.nextthink = time + 0.5;

	if (self.search_time > time)
	{
		t = TRUE;
//		ent_waterlevel(self.owner); // checks a few spots
		if (self.owner.watertype == CONTENT_SOLID) t = FALSE;
// origin check - if living ent cant move after teleport
		if (self.owner.flags & FL_MONSTER) if (self.oldorigin != v0) if (self.owner.origin == self.oldorigin) t = FALSE;

		if (t || (! MONSTER_STICK_TELE && (self.owner.flags & FL_MONSTER)))
		{
//			if (self.owner.flags & FL_MONSTER) self.owner.oldorigin = v0;
			remove(self);
		}
		return;
	}

	if (IS_CHAOS(self.owner)) chaos_base_mdl(self.owner, ""); // restore chaos to plasma flux
	if (self.owner.flags & FL_MONSTER) self.owner.oldorigin = v0;

	e = world;
	org = v0;
	t = 7;
	while (t > 0 && !e)
	{
		t = t - 1;
		e = find_tdest(FL_RSALL, ""); //SelectSpawnPoint ();
	}
	if (e.flags & FL_ITEM) org = ' 0 0 32';
	setorigin(self.owner, e.origin + org);
	self.owner.angles = e.angles;
	self.owner.fixangle = TRUE;

//	if (deathmatch || coop) 
//	{
		makevectors(self.owner.angles);
		spawn_tfog (self.owner.origin + v_forward*20);
//	}
	
	self.owner.bt_immune_time = time + BT_BUFFER;
	if (self.owner.flags & FL_ONGROUND) self.owner.flags = self.owner.flags - FL_ONGROUND;
	if (self.owner.flags & FL_CLIENT) spawn_tdeath (self.owner.origin, self);
	remove(self);
};


// e - ent for test
// org - dest org for non move check
// ts - ts & 255 - seconds spent checking before restore.
// ts & FL_ITEM - apply to non living ents

void(entity e, vector org, float ts) chaos_teleport_restore =
{
	local entity c;
	local float t;

	if (!(e.health > 0 || e.solid == SOLID_SLIDEBOX)) return;

	t = ts & 255;
	c = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, v0, v0, v0, v0, v0, "chaos_teleport_restore", "", SUB_Null, 1, chaos_teleport_restore_think, SUB_Null, e, world);
	if (t > 0)
		c.search_time = time + t;
	else
		c.search_time = time + 4;

	if (e.health > 0 || e.solid == SOLID_SLIDEBOX)
	{
		e.bt_immune_time = time + BT_BUFFER;
	}
};
*/

// fn(chaos_health) - random health effects

// .t_length - health additive
// .bubble_count - change timer
// .search_time - additive timer

void() chaos_health =
{
//	local float ht, low;

	self.health = rint(self.health);

	if (random() < 0.3) return;// && self.health > (self.max_health * self.health_modifier * 0.5)) return;

	self.t_length = crandom() * 3;

	if (self.search_time < time) // health trend for a bit
	{
		if (random() < 0.8) self.search_time = time + 1 + 2 * crandom();
		else self.search_time = time + 4 + 40 * random();
//		if (!low && random() < 0.3) self.search_time = ht + 3 * random();
 		if (self.health < (self.max_health * self.health_modifier * 0.3)) self.t_length = 1.2 * random();
		self.health = self.health + self.t_length;
	}

};

// fn(chaos_move_effect) - effects for chaos stand & run frames

float() chaos_move_effect =
{
	local entity c;
	local float dx;

	if (intermission_running || self.deadflag) return TRUE; //stop effects seen in intermix view - left in so other morphs turn off walksounds

	chaos_health(); // chaos does not obey normal health rules - this still needs a good test

	if (self.volume > MAX_CHAOS_LVL) self.aflag = self.aflag | FL_CSB;

// IDEA - more violent as chaos level increases
	if (self.aflag & FL_CSB) // Chaos star burst in progress
		{
		if (chaos_mdlchk(self.model)) chaos_form(FL_SPIKE);
		if (self.wait > time) return FALSE;
		self.wait = time + random() / 2.0;
		fire_burst (chaos_item, self.origin, 0, 100, "", "", 0, 1, 0, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND /* | FL_OWNOWN */, world);
//		if (self.health < (self.max_health * self.health_modifier * 0.30)) self.health = self.health + random() * 10;
//		else 
		if (self.health < (self.max_health * self.health_modifier * 0.70)) self.health = self.health + random() * 3;
		if (random() < 0.08) if(newmis) newmis.movetype = MOVETYPE_FLYMISSILE;
		if ((MAX_CHAOS_LVL - self.volume) > MIN_CHAOS_DEC)
		if (random() < ( MAX_CHAOS_LVL / ( self.volume * (MAX_CHAOS_LVL / 350))))
			{
			self.aflag = FL_MELO;//self.aflag - (self.aflag & FL_CSB) | FL_MELO;
			self.wait = time + CHAOS_MELO_MIN + (((MAX_CHAOS_LVL - self.volume) * 20) / MIN_CHAOS_DEC) + 25 * random();
			sprint(self, "Chaos star burst is over\n");
			dx = 1.5 + random() * 0.25;
			chaos_constant(dx); // up the ante on csbs
			}
		return FALSE;
		}

	if (!chaos_mdlchk(self.model)) chaos_particle(self.origin, 105, 0.8, -1);

	if (self.aflag & FL_MELO)
		{
		if (self.wait > time) return FALSE;
		self.aflag = self.aflag - (self.aflag & FL_MELO);
		}

	chaos_level(CHAOS_INC, self);

	if (chaos_mdlchk(self.model)) return TRUE; // not in plasma bit form

	if (random() < 0.05)
		{
		chaos_fire_fly(rnd_string(' 95.0 85.0 40.0',"progs/v_spike.mdl","progs/teleport.mdl","progs/lavaball.mdl","progs/snowball.mdl","progs/snowball.mdl"));
		if (newmis) 
			{
			if (random() < 0.24) newmis.think = chaos_bomb;
			else if (random() < 0.11) newmis.touch = GrenadeTouch;
			if (newmis.model == "progs/snowball.mdl")
			{
				if (random() < 0.5)
					newmis.skin = SKSNOW;
				else
				{
					newmis.skin = SKTELE;
					if (random() < 0.8)
					{
						local vector v;
						v = newmis.origin;
						remove(newmis); // gets replaced
						chaos_teleport(v, "", world);
//						newmis.touch = telesph_touch;
//						if (random() < 0.5) newmis.movetarget = find_tdest(FL_RSALL, "");
						newmis.search_time = time + 0.15 + (0.1 * random());
					}
				}
			}
			if (newmis.think == chaos_bomb)
				{
				if (random() < 0.4) newmis.aflag = MOVETYPE_BOUNCE;
				if (newmis.classname == "fireball")
				if (random() < 0.7) chaos_bomb_rndmdl(newmis);

				sprint(self, "chaos bomb launched: ");
				sprint(self, newmis.model );
				newline(self);
				}
			}
		}
	else if (random() < 0.02)
		{
		fire_burst (chaos_item, self.origin, 0, 150, "", "", 0, 1, 0, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND /* | FL_OWNOWN */, world); // IDEA overall chaos affect cnt on this
		if (self.health < (self.max_health * self.health_modifier * 0.70)) self.health = self.health + random() * 3;
		}

	if (self.walkframe & 2) self.alpha = random() + 0.4; // FIX gradual delta
	if (self.walkframe == 2) morph_sound (0.1, rnd_string(' 80.0 60.0 40.0',"enforcer/enfstop.wav","misc/power.wav","ambience/comp1.wav","ambience/buzz1.wav","ambience/thunder1.wav"), 2);
	else if (self.walkframe == 3) player_chaos_sight();
	else if (self.walkframe == 6 && self.wait < time) // if move_effect ever called from frameset with frame 6 these need to be valid!
		{
		if (random() < 0.1)
			{
			player_chaos_explode1();
			return TRUE;
			}
		else if (random() < 0.2)
			{
			self.wait = time + 5 + rint(random() * 15);
			chaos_base_mdl(self, "progs/chaos_b3.2rot.mdl");
			}
		else if (random() < 0.4)
			{
			chaos_base_mdl(self, "progs/chaos_b3.3rsm.mdl");
			}
		else
			{
			chaos_base_mdl(self, "");
			}
//		chaos_flycheck(self, self.model);
		}
	return FALSE;
};

void() player_chaos_stand = [ $chaos1, player_stand1 ]
{
	local float rdir;
	self.nextthink = time + 0.2;
	rdir = 0;
 
	if (chaos_move_effect()) return;
	else if (self.walkframe > 6) self.walkframe = 5;
	else if (self.walkframe < 0) self.walkframe = 1;
	else rdir = rint(random() * 2) - 1;

	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;

	self.frame = $chaos1 + self.walkframe;
	self.walkframe = self.walkframe + rdir;
};

void() player_chaos_run = [ $chaos1, player_run ]
{
	local float rdir;
	self.nextthink = time + 0.1;
	rdir = 0;

	if (chaos_move_effect()) return;
	else if(self.walkframe > 6) self.walkframe = 5;
	else if(self.walkframe < 0) self.walkframe = 1;
	else rdir = rint(random() * 2) - 1;

	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;

	self.frame = $chaos1 + self.walkframe;
	self.walkframe = self.walkframe + rdir;
};

void() chaos_ball_move =
{
	local float rskn;
	self.nextthink = time + 0.05 + (random() / 2);
//3 - 7 or 4,8,9,10,11
	if (self.wait > time)
		{
		self.wait = time + rint(random() * 2);
		rskn = self.skin + self.lip;
		if(rskn > 7) {rskn = 6; self.lip = -1;}
		if(rskn < 3) {rskn = 4; self.lip = 1;}
		self.skin = rskn;
		}
	else
		{
		rskn = rint(random() * 4) + 8;
		if (rskn > 11) rskn = 4;
		self.skin = rskn;
		if (rskn == 4 && random() < 0.03) self.wait = time + 3 + rint(random() * 3);
		if (rskn > 8 && random() < 0.1)
			{
			player_chaos_unexplode1();
			return;
			}
		}
	chaos_move_effect();
	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;
	if (self.skin == 4) morph_sound (0.1, rnd_string(' 80.0 60.0 40.0',"enforcer/enfstop.wav","misc/power.wav","ambience/comp1.wav","ambience/buzz1.wav","ambience/thunder1.wav"), 2);
	if (self.skin == 4) player_chaos_sight();

};

void() player_chaos_ball = [ $chaos9, player_stand1 ]
{

chaos_ball_move();

};

void() player_chaos_ballr = [ $chaos9, player_run ]
{

chaos_ball_move();

};

// fn(fire_cbolt) - fire off a chaos plasma prong bolt
// fn(cbolt_touch) - handle touching things

void() cbolt_touch =
{
	if (other)
	if (other == self.owner)
		return;

	if (sky_touch("", v0, self))
	{
		SUB_Remove();
		return;
	}

	if (self.classname != "calderashard")
	if (other.state == IMP_MCHAOS || other.morphy == IMP_MCHAOS) return; //IS_CHAOS(other)

// hit something that bleeds
	if (other.takedamage)
	{
		if (other.solid == SOLID_SLIDEBOX)  // BLOODCHECK - in case some other bit of gib / dead body can make blood
			spawn_touchblood (self.dmg);
		else if (self.classname != "calderashard")
		{
			T_Damage (other, self.owner, self.owner, 10);
		// hit the trigger, then bounce off
			self.movetype = MOVETYPE_BOUNCE;
			return;
		}
		if (self.classname == "calderashard")
			T_FireDamage (other, self, self.owner, self.dmg);
		else
		{
			T_Damage (other, self, self.owner, self.dmg);
			self.touch = SUB_Null;
		}
	}
	else if (other.classname == "worldspawn")
	{
//		if (self.classname == "calderashard") calderashard_cb();
		move_stop(self, "");
	}
};

float chaos_dynlit; // limit dynamic lights in tenebrae

void() fire_cbolt =
{
	float f1;

	fire_missile(700, MOVETYPE_FLYMISSILE, 0, RM_SKY, self.origin, ' 0 0 0', "chaosbolt", "progs/spike.mdl", "", cbolt_touch, 6 + random() * 6, SUB_Remove, SUB_Nop); // SUB_FadeRemove, SUB_Nop);
	newmis.frame = CHAOS_FIREBOLT_FRAME_ADJ + floor(random() * 6);
	newmis.dmg = 30 + random() * 100; // hot plasma is very dangerous

	if (random() < 0.1)
		newmis.skin = random() * 1.45;
	else
		newmis.skin = 3;

	if (random() < 0.4)
		f1 = 0.25;
	else
		f1 = 0.1;
	if (random() < f1)
		{
		newmis.effects = EF_DIMLIGHT;
		chaos_dynlit = chaos_dynlit + 1;
		}
};

// fn(chaos_form) - change chaos into one of its many forms
// self - chaos client ent
// flg -
//			FL_SPIKE - spikey chaos
//			FL_CBALL - chromatic ball chaos
//			FL_ELEM	- elemental chaos - not done yet

void(float flg) chaos_form =
{
	local float f1;
	if (!flg) flg = FL_SPIKE;

	if (flg & FL_CBALL)
		{
		setmodel(self,"progs/chaos_b3.1col.mdl");
		self.modelindex_morph=self.modelindex;
		setsize (self, '-16 -16 -24', ' 16 16 40');
		self._stand=player_chaos_ball;
		self._run=player_chaos_ballr;
		self.wait = time + 5;
		self.skin = 1;
		self.lip = 1;
		self._hk_lesser = player_chaos_unexplode1;
		f1 = FL_CBALL;
		}
	if (flg & FL_SPIKE) // always the last form in case multiple get set
		{
		chaos_base_mdl(self, "");
		self.skin = 1;
		self._stand=player_chaos_stand;
		self._run=player_chaos_run;
		self._hk_lesser = player_chaos_explode1; // FIX
		f1 = FL_SPIKE;
		}
	self.flags = self.flags - (self.flags & (FL_SPIKE | FL_CBALL)) + f1;
};

void()   player_chaos_fade16;
void()   player_chaos_explode1  =[ $chaos8,   player_chaos_explode2  ] { chaos_form(FL_SPIKE); };
void()   player_chaos_explode2  =[ $chaos9,   player_chaos_explode3  ] { };// do lots of effluence during seq
void()   player_chaos_explode3  =[ $chaos10,  player_chaos_explode4  ] { };
void()   player_chaos_explode4  =[ $chaos11,  player_chaos_explode5  ] { };
void()   player_chaos_explode5  =[ $chaos12,  player_chaos_explode6  ] { };
void()   player_chaos_explode6  =[ $chaos13,  player_chaos_explode7  ] { };
void()   player_chaos_explode7  =[ $chaos14,  player_chaos_explode8  ] { };
void()   player_chaos_explode8  =[ $chaos15,  player_chaos_explode9  ] { };
void()   player_chaos_explode9  =[ $chaos16,  player_chaos_explode10 ]
{
	chaos_dynlit = 0; // tenebrae stuff - use cvar
	if (random() < C_FBPER)
		fire_burst (fire_cbolt, self.origin, 0, 0, "", "", 0, 8, 28, ' 0 0 0', ' 360 360 360', SUB_Null, FL_VELRND2 /* | FL_OWNOWN */, world);
};
void()   player_chaos_explode10 =[ $chaos17,  player_chaos_explode11 ] { };
void()   player_chaos_explode11 =[ $chaos18,  player_chaos_explode12 ] { };
void()   player_chaos_explode12 =[ $chaos19,  player_chaos_explode13 ] { };
void()   player_chaos_explode13 =[ $chaos20,  player_chaos_explode14 ]
	{
	if (self.deadflag == DEAD_DYING) { player_chaos_fade16(); return; }
	self.walkframe = 8;
	self.frame = $chaos1 + self.walkframe;
	chaos_form(FL_CBALL);
	};
void()   player_chaos_explode14 =[ $chaos9,  player_stand1          ] { };

void()   player_chaos_unexplode1  =[ $chaos9,   player_chaos_unexplode2  ] { self.skin = 6; };
void()   player_chaos_unexplode2  =[ $chaos9,   player_chaos_unexplode3  ] { self.skin = 5; };
void()   player_chaos_unexplode3  =[ $chaos9,   player_chaos_unexplode4  ] { self.skin = 4; };
void()   player_chaos_unexplode4  =[ $chaos9,   player_chaos_unexplode5  ] { self.skin = 3; };
void()   player_chaos_unexplode5  =[ $chaos9,   player_chaos_unexplode6  ] { self.skin = 2; };
void()   player_chaos_unexplode6  =[ $chaos9,   player_chaos_unexplode7  ] { self.skin = 1; };
void()   player_chaos_unexplode7  =[ $chaos8,   player_chaos_unexplode8  ] { };
void()   player_chaos_unexplode8  =[ $chaos7,   player_chaos_unexplode9  ] { };
void()   player_chaos_unexplode9  =[ $chaos6,   player_stand1  ]
	{
	chaos_form(FL_SPIKE);
	self.walkframe = 6;
	self.frame = $chaos1 + self.walkframe;
	};

void(entity attacker, float damage)	player_chaos_pain =
{
	local float r;

	r = random ();
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1 + r;

	morph_sound (0.8, "misc/power.wav", 1); // randomize
};

// fn(chaos_fade*) - chaos has lost all power and is fading out (where other morphs die)

void() player_chaos_fade1 = [ $chaos6,   player_chaos_fade2  ] { chaos_form(FL_SPIKE); };
void() player_chaos_fade2 = [ $chaos5,   player_chaos_fade3  ] { };
void() player_chaos_fade3 = [ $chaos4,   player_chaos_fade4  ] { };
void() player_chaos_fade4 = [ $chaos3,   player_chaos_fade5  ] { };
void() player_chaos_fade5 = [ $chaos2,   player_chaos_fade6  ] { };
void() player_chaos_fade6 = [ $chaos1,   player_chaos_fade7  ] { };
void() player_chaos_fade7 = [ $chaosfade1,   player_chaos_fade8  ] { };
void() player_chaos_fade8 = [ $chaosfade2,   player_chaos_fade9  ] { };
void() player_chaos_fade9 = [ $chaosfade3,   player_chaos_fade10  ] { };
void() player_chaos_fade10 = [ $chaosfade4,   player_chaos_fade11  ] { self.skin = 2; };
void() player_chaos_fade11 = [ $chaosfade5,   player_chaos_fade12  ] { };
void() player_chaos_fade12 = [ $chaosfade6,   player_chaos_fade13  ] { };
void() player_chaos_fade13 = [ $chaosfade7,   player_chaos_fade14  ] { };
void() player_chaos_fade14 = [ $chaosfade8,   player_chaos_fade15  ] { };//if (random() < 0.45) VolcanoQuake(self, "chaos fade"); };
void() player_chaos_fade15 = [ $chaosfade8,   SUB_Nop  ] { setmodel(self,"progs/null.mdl"); }; // IDEA: pop sound?
// explode then fade
void() player_chaos_fade16 = [ $chaosfade9,   player_chaos_fade17  ] { };
void() player_chaos_fade17 = [ $chaosfade10,   player_chaos_fade18  ] { };
void() player_chaos_fade18 = [ $chaosfade11,   player_chaos_fade19  ] { };
void() player_chaos_fade19 = [ $chaosfade12,   player_chaos_fade20  ] { };
void() player_chaos_fade20 = [ $chaosfade13,   player_chaos_fade10  ] { };

void() chaos_fade =
{
	morph_sound_off();
	self.deadflag = DEAD_DYING;

	if (self.health < -70 || random() < 0.1) player_chaos_fade1();
	else player_chaos_explode1();
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/


// fn(chaos_bomb_rndmdl) - random model for chaos bomb
// if e == world return model string, else set model / sizes
/*
string(entity e) chaos_bomb_rndmdl =
{
	local string s1;
	local float r1;
	r1 = floor(random() * 17.3);

	s1 = "progs/teleport.mdl";
	if (r1 > 15) s1 = "progs/gas.mdl";
	else if (r1 > 13) s1 = "progs/grenade.mdl";
	else if (r1 > 10) s1 = "maps/b_exbox2.bsp";
	else if (r1 > 8) s1 = "maps/b_rock0.bsp";
//	else if (r1 > 7) s1 = "progs/ejbatt.mdl";
	else if (r1 > 5) s1 = "progs/proxbomb.mdl";
	else if (r1 > 3) s1 = "progs/hook.mdl";
	else if (r1 > 2) s1 = "progs/v_spike.mdl";
	if (e)
	{
		setmodel(e, s1);
	}
	return(s1);
};

// fn(chaos_bomb) - explode a chaos thrown item shooting variable wep missiles
// fn(RND_Spike) - create random spikes for chaos bomb
// fn(RND_Damage) - random damage for explosives (just because 10 random grenades from a betty are pretty damn dangerous for anything nearby)

float RND_frame;
float RND_skin;
float RND_maxdmg; // set to CBOMB_DEF_MAX if > 0 this is the max damage all explosives from bomb can cause

void() RND_Spike =
{
	if (newmis)
	{
		newmis.frame = RND_frame;
		newmis.skin = RND_skin;
	}
};

void() RND_Damage =
{
	local float dm;

	if (newmis)
	{
		dm = CBOMB_DEF_DMG + random() * DUD_DEF_DMG; // 10 + rnd * 20
		if (RND_maxdmg >= 0) // in use if not < 0
		{
			if (dm > RND_maxdmg) dm = RND_maxdmg;
			RND_maxdmg = RND_maxdmg - dm;
			if (RND_maxdmg < 0) RND_maxdmg = 0;
		}
		newmis.dmg = dm;
	}
};



// for the obit

void() W_FireClusterRock =
{
	W_FireRocket();
	newmis.classname = "cluster_bomb";
};

void() W_FireClusterGren =
{
	W_FireGrenade();
	newmis.classname = "cluster_bomb";	
};


void() chaos_bomb =
{
	local float r1;
	local void() wfire, vspk;

	if (self.aflag == MOVETYPE_BOUNCE) // the bouncing part of betty, she is a bad ass too
	{
		self.nextthink = time + 0.1 + random() * 0.4; // time to bounce
		self.velocity_z = 200 + 200 * random();
		if (random() < 0.5)
		{
			self.velocity_x = 50 * crandom();
			self.velocity_y = 50 * crandom();
		}
		self.aflag = 0;
		return;
	}
	r1 = floor(random() * 8.6);
	wfire = W_FireSpikes;
	vspk = SUB_Null;
	if (self.weapon == IMP_MOGRE) { wfire = W_FireGrenade; r1 = 5; }
	else if (r1 > 7) wfire = fire_laser1;
	else if (r1 > 6) wfire = fire_cbolt;
	else if (r1 > 5) { wfire = W_FireGrenade; vspk = RND_Damage; }
	else if (r1 > 5) { wfire = W_FireRocket; vspk = RND_Damage; }
	else if (r1 > 4) wfire = W_FireLightning;
	if (r1 < 4) vspk = RND_Spike;

	RND_frame = random() * 7.4;
	RND_skin = random() * 3.4;
	RND_maxdmg = CBOMB_DEF_MAX;
	
// really just a fancy bouncing betty
	fire_burst (wfire, self.origin + ' 0 0 30', 0, 0, "", "", 0, 3, 8, ' 120 0 0', ' 300 360 360', vspk, FL_ANGADR | FL_VELRND | FL_FRCORG | FL_NEWSELF | FL_OWNOWN, world);
	RND_maxdmg = 0; // reset
	remove(self);
};
*/

// Chaos beam - fired in attack by alt fire

// fn(chaos_item) - randomly generate a chaos item
// returns ent & may set newmis

void() chaos_field_thk;

// deprecated entity(), uses newmis for all items + caused compiler warning
// deprecated float flg - not used & caused a compiler warning

void() chaos_item =
{
	local float f1, ft, sf, r1;

	f1 = ci_flg;// | flg;
	sf = 100;

	newmis = world;
	while (TRUE)
	{

	sf = sf - 1;
	if (sf < 0) return;

	ft = (ci_last == 1 && (f1 & FL_SAME));
/* no shell casings
	if (ft || random() < 0.09) // shell casings
		{
		if (!ft) ci_fr = floor(random() * 4.3);
		ci_last = 1;
		eject (v0 ,v0 ,SHELL_CASING, ci_fr);
		if (newmis)
			{
			droprnd(v0, newmis);
			NextThink(newmis, 4 + random() * 8);
			newmis.owner = self.owner;
			chaos_level(-5, self.owner);
			}
		return;
		}
*/
	ft = (ci_last == 2 && (f1 & FL_SAME));
	if (ft || random() < 0.02) // lava balls
		{
		if (!ft) ci_fr = floor(random() * 2.2);
		ci_last = 2;
		chaos_fire_fly("");
		if (newmis)
			{
			newmis.frame = ci_fr;
			newmis.wait = NOFLYMIRV;
			newmis.owner = self.owner;
			chaos_level(-20, self.owner);
			}
		return;
		}

	ft = (ci_last == 3 && (f1 & FL_SAME));
	if (ft || random() < 0.1) // various wep effects
		{
		if (!ft) ci_fr = floor(random() * 10.3);
		ci_last = 3;
		if (ci_fr == 0) W_FireSpikes(0);
		else if (ci_fr == 1) W_FireLightning(); // IDEA - just use diff lightning code here
		else if (ci_fr == 2) fire_laser1(0);
		else if (ci_fr == 3) W_FireGrenade();
		else if (ci_fr == 4) W_Fire_Proxmine();
		else if (ci_fr == 5) W_FireRocket();
		else if (ci_fr == 6) W_FireSpikes(USE_PULSE_SPIKES);
		else if (ci_fr == 7) HIP_LaunchLaser(v0, v0, rint(random()), "lasercannon/laserg.wav");
		else if (ci_fr == 8) fire_cbolt();
		else if (ci_fr == 9) { beartrap_dropBearTrap(); newmis.beartrap_time = time + 9; }
		else if (ci_fr == 10) turret_dropTurret(); //if (newmis) if (random() < 0.333) newmis.th_stand = chaos_sentry_lt; }
		if (newmis)
		{
			if (ci_fr == 4) newmis.classname = "chaos_prox";
		}
		chaos_level( 0 - (ci_fr * 5) - 1, self.owner);
		return;
		}


	ft = (ci_last == 4 && (f1 & FL_SAME));
	if (!ft) // IDEA - build list of stuff chaos has touched?
		{
		local float CI_EXPL_BASE_DMG = 15; // must be greater than all random frames
		ci_sk = ci_fr = 0;
		r1 = floor(random() * 20.3);
		if (r1 == 0) ci_md = "progs/proxbomb.mdl";
		else if (r1 == 1) {ci_md = "progs/bolt2.mdl"; ci_fr = floor(random() * 6.3);}
		else if (r1 == 2) {ci_md = "progs/ejbatt.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 20; }
		else if (r1 == 3) ci_md = "progs/hook.mdl";
		else if (r1 == 4) {ci_md = "maps/b_rock0.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 50; }
		else if (r1 == 5) {ci_md = "maps/b_exbox2.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 80; }
		else if (r1 == 6) ci_md = "progs/flame2.mdl";
		else if (r1 == 7) ci_md = "progs/end1.mdl";
		else if (r1 == 8) ci_md = "progs/end2.mdl";
		else if (r1 == 9) ci_md = "progs/end3.mdl";
		else if (r1 == 10) ci_md = "progs/end4.mdl";
		else if (r1 == 11) {ci_md = "progs/drycel6.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 30; }
		else if (r1 == 12) ci_md = "progs/zom_gib.mdl";
		else if (r1 == 13) ci_md = "progs/s_bubble.spr";
		else if (r1 == 14) ci_md = "progs/eyes.mdl";
		else if (r1 == 15) {ci_md = "progs/chaos_b2.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 100; }
		else if (r1 == 16) ci_md = "progs/grenade.mdl";
		else if (r1 == 17) {ci_md = "progs/invulner.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 30; }
		else if (r1 == 18) {ci_md = "progs/gas.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 80; }
		else if (r1 == 19) ci_md = "progs/beartrap.mdl";
		else if (r1 == 20) {ci_md = "progs/b_eshel0.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 50; }
		else if (r1 == 21) { ci_md = "progs/laser_m.mdl"; ci_sk = floor(random() * 10.4); ci_fr = floor(random() * 10.4); }
		}
	if (ft || random() < 0.05) // random inert crap
		{
		ci_last = 4;
		newmis = chaos_spawn(MOVETYPE_TOSS, SOLID_TRIGGER, 0, RM_SKY | MLT_LAVA | FLT_LAVA | PF_WATER | PF_SLIME | CK_EARTHQUAKE | PF_SOLID, v0, v0, v0, v0, v0, "chaos_item", ci_md, sky_touch_pointer, 5 + (random() * 20), meltthink, SUB_Null, self, world);
		if (newmis)
			{
			newmis.th_stand = SUB_Null;
//			if (random() < 0.717) newmis.th_stand = floaterPointer; // no float yet
			if (random() < 0.234) newmis.bubble_count = NO_BUBBLES;
			if (ci_fr > (CI_EXPL_BASE_DMG - 1)) // chance item is explode box - this is dmg ( heh heh )
			{
				if (random() < CI_EXPLBOX)
				{
					misc_explodbox_set(newmis, ci_md, ci_fr, 10 + random() * 40, MOVETYPE_TOSS);
					newmis._stand = SUB_Remove; // in case of respawn being called
																													if (WARNING)
																													{
																														bprint("chaos_item(explode box) = ");
																														bprint(newmis.model);
																														newline(world);
																													}
				}
			}
			else
				newmis.frame = ci_fr;
			newmis.skin = ci_sk;
			newmis.owner = self.owner;
			chaos_level(-10, self.owner);
			if (ci_md == "progs/flame2.mdl")
				{
					newmis.content_flag = (newmis.content_flag | FLT_IMM) - (newmis.content_flag & MLT_LAVA);
					newmis.effects = newmis.effects | EF_DIMLIGHT;
					newmis.mins_z = newmis.mins_z - 12; // move flame up out of floor
					newmis.view_ofs = ' 0 0 -12';
					setsize(newmis, newmis.mins, newmis.maxs);
					if (random() < CI_FLAMEREAL)
						newmis.touch = FlameTouch;
				}
			chaos_mdlsize(newmis);
			}
		if (random() < 0.8) item_eject(newmis, MED_BOUNCE);
		else if (random() < 0.3) newmis.movetype = MOVETYPE_FLY;
		if (newmis)
		if (ci_md == "progs/chaos_b2.mdl")
		{
			newmis.movetype = MOVETYPE_FLY;
			newmis.think = chaos_field_thk; // give some random movement
			newmis.nextthink = time + random();
			newmis.aflag = FL_FFLY;
			if (random() < 0.5) newmis.flags = newmis.flags | FL_FPART;
			newmis.wait = time + 10 + (random() * 30);
		}
		if (random() < 0.02) newmis.effects = newmis.effects | EF_DIMLIGHT; // light a few of these up for kicks
		return;
		}

	if (random() < 0.08) // real map items
		{
		f1 = r1 = floor(random() * 13.4);
		if (r1 == 1) r1 = MC_KEY2;
		else if (r1 == 2) r1 = MC_ANAILS;
		else if (r1 == 3) r1 = MC_ACELLS_LG;
		else if (r1 == 4) r1 = MC_ACELLS_LG;
		else if (r1 == 5) r1 = MC_AROCKETS;
		else if (r1 == 6) r1 = MC_ARMOR2;
		else if (r1 == 7) r1 = MC_HIP_LASERCAN;
		else if (r1 == 8) r1 = MC_AEXPLSH;
		else if (r1 == 9) r1 = MC_RING;
		else if (r1 == 10) r1 = MC_PENT;
		else if (r1 == 11) r1 = MC_GRAVITY;
		else if (r1 == 12) r1 = MC_Q3_RAILGUN;
		else if (r1 == 13) r1 = MC_REGGUN;
//		else if (r1 == 13) r1 = MC_DYNAMO; // NOTE: lots of other things
		else r1 = MC_AXE;
//		else if (r1 == ) r1 = MC_
//		proc_dropitem(r1, TRUE);
		newmis = drop_item(r1, "", self, MED_BOUNCE);

		if (newmis)
		{
			newmis.classname = "chaos_item";
/* upgrades are now done by cycle code
			if (random() < 0.17)
			if (r1 == MC_REGGUN || r1 == MC_Q3_RAILGUN || r1 == MC_GRAVITY)
			{
				newmis.upgrade_mc = 100 + rint(random() * 17); // random upgrade item - this will be made a permanent map item by load fn
				newmis.upgrade_cnt = random() * 5;
				newmis.upgrade_time = 5 + random() * 35;
				newmis.invincible_time = time + newmis.upgrade_time + (random() * 0.3 * newmis.upgrade_time);
			}
*/
			if (f1 > 8) f1 = f1 - 2;
			chaos_level( 0 - (f1 * 8) - 1, self.owner);
		}
		return;
		}

	if (FALSE) //(flg & FL_RNDBURST) 
		{
		return; // less normal stuff here
		}

	} // while true
};

// fn(chaos_burst) - burst out chaos items
// org - origin of burst

void(vector org, float flg) chaos_burst =
{
	local float c1, c2;

	ci_flg = flg;
	if (!ci_flg)
	if (random() < 0.2) ci_flg = FL_SAME;
//	else if (random() < 0.2) ci_flg = FL_RNDBURST;

	c2 = floor(random() * 4);
	c1 = 3;// + floor(random() * c2);
//	if (random() < 0.2) c2 = random() * 30;

	fire_burst (chaos_item, org, 0, 75, "", "", 0, c1, c2, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND2 | FL_FRCORG | FL_NEWSELF /* | FL_OWNOWN */, world);
	ci_last = ci_fr = ci_flg = 0;
};

// *** chaos particle fields for beam strike point

// fn(chaos_field_thk) - think for chaos fields at random locations

// .wait - lifetime
// .flags as indicated:

float MAX_FIELDS			= 7.8;
/*

moved up for chaos item

float FL_FJUMP				= 4; // move field by setorg
float FL_FFLY					= 8; // move field by velocity
float FL_FLIT						= 32768; // light field
float FL_FPART					= 65536; // particle field
*/

float fwalk_dist					= 12; // field move velocity max | rnd jump origin additive
float lf_per							= 0.06; // chance per sec of light field
float pf_per							= 0.05; // chance per sec of particle field
float pf_len							= 5.0; // avg field 5 secs
float pf_dev							= 1.5; // +- 1.5
float pf_exc							= 17.0; // exceptional fields are longer
float particle_fields;

float(float ad) fieldadd = // field count controls
{
	if ((particle_fields + ad) < 1) return 0.0;
	else return(particle_fields + ad);
};

void(entity fe) chaos_fieldmove = // set move vectors for field
{
	fe.v_angle_x = random() * 360;
	fe.v_angle_y = random() * 360;
	fe.view_ofs_x = crandom() * fwalk_dist;
	fe.view_ofs_y = crandom() * fwalk_dist;
	fe.view_ofs_z = crandom() * fwalk_dist;
	if (fe.aflag == FL_FFLY) fe.movetype = MOVETYPE_FLY;
};

void() chaos_field_thk =
{
	local float rng, pr;
	local vector v1;

	if (random() < 0.5) rng = 20 + random() * 200;
	else rng = 85;
	if (random() < 0.5) pr = 0.333 + random();
	else pr = 0.8;
	if (random() < 0.2) chaos_fieldmove(self);

	if (self.flags & FL_FPART) chaos_particle(self.origin, rng, pr, -1);
	if (self.flags & FL_FLIT) 
		{
		self.effects = (self.effects - (self.effects & 15)) | EF_BRIGHTFIELD;//FL_rnd(15); // randomly selected effect
		if (random() < 0.4) self.flags = self.flags - (self.flags & FL_FLIT);
		}
	if (self.aflag == FL_FJUMP) setorigin(self, self.origin + self.view_ofs);
	if (self.aflag == FL_FFLY) self.velocity = self.view_ofs * 200;

	if (self.wait > time)
		{
		self.nextthink = time + 0.05 + (random() / 4.0);
		}
	else
		{
		if (self.flags & FL_FPART) particle_fields = fieldadd(-1);
		if ((self.flags & FL_FLIT) || (self.effects & 15)) if (chaos_dynlit > 0) chaos_dynlit = chaos_dynlit - 1;
		remove(self);
		}
};

void(vector org) spawn_particle_field =
{
	if (particle_fields > MAX_FIELDS) return;
	particle_fields = fieldadd(1);
	newmis = chaos_spawn(0, 0, FL_FPART, 0, org, v0, v0, v0, v0, "chaos_field", "", SUB_Null, 0.1, chaos_field_thk, SUB_Null, self, world);
	if (random() < 0.333) newmis.wait = time + pf_exc + crandom() * pf_dev * 3;
	else newmis.wait = time + pf_len + crandom() * pf_dev;
	if (random() < 0.25) newmis.aflag = FL_FJUMP;
	else if (random() < 0.25) newmis.aflag = FL_FFLY;
	chaos_fieldmove(newmis);
};

void(vector org) spawn_light_field =
{
//	if (tenebrae) if (chaos_dynlit > 3) return;
	chaos_dynlit = chaos_dynlit + 1;
	newmis = chaos_spawn(0, 0, FL_FLIT, 0, org, v0, v0, v0, v0, "chaos_field", "progs/null.mdl", SUB_Null, 0.1, chaos_field_thk, SUB_Null, self, world);
	newmis.wait = time + pf_len + crandom() * pf_dev;
	if (random() < 0.5) newmis.aflag = FL_FJUMP;
	else if (random() < 0.5) newmis.aflag = FL_FFLY;
	chaos_fieldmove(newmis);
};

// fn(spawn_chaos_monster) - call fn to creat a random chaos monster
// torg - target origin
float WEAK_MONSTER = 0.4; // percentage chance of weaker monster only
// IDEA: monster count for level, SVC msg
// pre set codes
float scm_dog				= 0;
float scm_zombie			= 1;
float scm_wizard			= 2;
float scm_army				= 3;
float scm_enforcer		= 4;
float scm_ogre				= 5;
float scm_hknight			= 6;
float scm_tarbaby			= 7;
float scm_shalrath		= 8;
float scm_demon1		= 9;
float scm_shambler		= 10;

// NOTE: redo with item_call_save

void(float sel, vector torg) spawn_chaos_monster =
{
	local entity sv;

	sv = self;
	self = chaos_spawn(0, 0, 0, 0, torg, v0, v0, v0, v0, "", "", SUB_Null, 0.0, SUB_Null, SUB_Null, sv, world);

	if (!sel) sel = floor(random() * 11.5);
	if (random() < WEAK_MONSTER)
		while (sel > 5) sel = floor(random() * 10.5);

	if (sel == 0)				monster_dog(A_MONSTER);
	else if (sel == 1)	monster_zombie(A_MONSTER);
	else if (sel == 2)	monster_wizard(A_MONSTER);
	else if (sel == 3)	monster_army(A_MONSTER);
	else if (sel == 4)	monster_enforcer(A_MONSTER);
	else if (sel == 5)	monster_ogre(A_MONSTER);
	else if (sel == 6)	monster_hell_knight(A_MONSTER);
	else if (sel == 7)	monster_tarbaby(A_MONSTER);
	else if (sel == 8)	monster_shalrath(A_MONSTER);
	else if (sel == 9)	monster_demon1(A_MONSTER);
	else if (sel == 10)	monster_shambler(A_MONSTER);
	else if (sel == 12)	monster_scourge(A_MONSTER);

	self = sv;
};

/*
// fn(chaos_beam) - fire chaos beam

effects:

flashing lights
* particle field effects
wall decals

* burst effects
* drop item effect
portal effect
item change|evolution effect

volcano
launcher
puddle (lava + acid)


*/
string beam_hum;
float CBURST					= 0.04; // chance of chaos burst per sec
float CBQUAKE					= 0.05; // chance of chaos beam quake
float CBTELEP					= 0.03; // chance of chaos beam teleport
float CBEXCH					= 0.05; // chance of chaos beam exchange
float CBDROPI					= 0.02; // chance of chaos beam drop item - done in chaos_item for now
float CBXFORM					= 0.03; // chance of chaos beam transform
float CBSUMMON				= 0.015; // chance of chaos beam summon monster

entity x3;


void() chaos_beam =
{
	local vector org, ep;
	local entity rent, e, f;
	local float f1;

//	if (x3 == world) x3 = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0, v0, v0, v0, v0, v0, "chaos_item", "progs/chaos_b2.mdl", SUB_Null, 0, SUB_Null, SUB_Null, self, world); // TEST
	if (self.aflag & FL_CSB) return;
	if (self.volume < CHAOS_BEAM_MIN + CHAOS_BEAM_GAIN) return;

	chaos_level(CHAOS_DEC, self);
	if (self.chaosattnoise < time) // select beam sound
		{
		if (random() < 0.5) beam_hum = "chaos/cbeam.2.wav";
		else beam_hum = "chaos/cbeam.1.wav";
		self.chaosattnoise = time + 10 + (random() * 30);
//		if (random() < 0.3) self.chaosattnoise = self.chaosattnoise + random() * 100;
		}

	if (self.t_width < time) // sound beam
	{
		sound (self, CHAN_WEAPON, beam_hum, 1, ATTN_NORM);
		if (beam_hum == "chaos/cbeam.1.wav") self.t_width = time + 6.0;
		else self.t_width = time + 2.954;
		if (random() < 0.3)
		{
			sprint(self, "Master Chaos level ");
			sprint(self, ftos(self.volume ));
			newline(self);
		}
	}

	self.aflag = self.aflag | FL_MELO;
	self.wait = time + random();
	self.attack_finished = time + 0.1;

	org = self.origin + ' 0 0 4';
	traceline (org, org + v_forward*900, TRUE, self);
	ep = trace_endpos;
	if (trace_ent == world) ep = trace_endpos - (v_forward * (32 + (64 * random())) ); // move burst away from wall

	if (chaos == CHAOS_ENG) cvar_set("findnonsolid","1");

// fire beam
	if (self.classname == "player") beam4(org, trace_endpos, LT_CHAOS);

// field effect
	if (random() < pf_per) spawn_particle_field(ep);
	if (random() < lf_per) spawn_light_field(ep);

// try beam struck ent
//	set_CLE("calderashard", "", "", "", "", "", "");
	if (trace_ent != world)
	if (move_check(trace_ent, 15999)) rent = trace_ent; // beam hit something specific

// beam didnt hit anything - pick an ent in beam strike area
	if (!rent)
	{
		e = findradius(ep, 64 + random() * 64);
		rent = rnd_list(e, 0); // any random ent in beam strike range
	}

/* no volcano yet
	if (random() < CBQUAKE)
	{
		if (rent) VolcanoQuake(rent, "chaos beam");
		else
		{
			e = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0, ep, v0, v0, v0, v0, "quakelocate", "", SUB_Null, 0.1, SUB_Remove, SUB_Null, self, world);
			VolcanoQuake(e, "chaos beam");
		}
	}
*/

// another random ent list
	e = findradius(ep, 1500);
//	e = rnd_list(e, 0); // random ent somewhere nearby


	if (random() < CBURST)
		{
		chaos_burst(ep, 0);
		}
// need a validated ent for this code
	else if (rent == world) return;
	else if (random() < CBTELEP)
		{
		e = find_tdest(FL_RSALL, "");
		if (!e) return;

//		makevectors (e.angles);
//		org = e.origin + 24 * v_forward;

//		if (random() < 0.5) spawn_tfog (org);
//		if (random() < 0.5) spawn_tfog (rent.origin);

//		if (rent.flags & FL_ONGROUND) rent.flags = rent.flags - FL_ONGROUND;
//		if (rent.flags & FL_ITEM) chaos_teleport_restore(rent, org, 0); // called before move for items
//		setorigin(rent, org);
//		if (rent.flags & FL_CLIENT)
//			{
//			spawn_tdeath(org, rent);
//			rent.velocity = v_forward * 30 * random();
//			}
		f = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  rent.origin , '-16 -16 -16', ' 16 16 16', v0, v0, "chaos_teleport", "", teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
		f.movetarget = e;
		force_retouch = 2;

		sprint(self, "teleported: ");
		if (rent.netname != "") sprint(self, rent.netname);
		else sprint(self, rent.classname);
		sprint(self, ", to: ");
		if (e.netname != "") sprint(self, e.netname);
		else sprint(self, e.classname);
		newline(self);
		}
	else if (random() < CBEXCH)
		{
//		if (rent == world) return;
		f1 = list_test(rent, FL_LTALL);
		if (!f1) return;
//		e = findradius(ep, 1500);
		e = rnd_list(e, f1); // ent must match rent
		if (e == world) return;

// restore on respawn...well sometimes at least
//		if (random() < 0.27)
//		{
//			if (rent.flags & FL_ITEM && rent.oldorigin == v0) rent.oldorigin = rent.origin;
//			if (random() < 0.27)  if (e.flags & FL_ITEM && e.oldorigin == v0) e.oldorigin = e.origin;
//		}

//		if (random() < 0.5) spawn_tfog (rent.origin);
//		if (random() < 0.5) spawn_tfog (e.origin);
//		org = rent.origin;

//		if (rent.flags & FL_ONGROUND) rent.flags = rent.flags - FL_ONGROUND;
//		if (rent.flags & FL_ITEM) chaos_teleport_restore(rent, e.origin, 0);
//		setorigin(rent, e.origin);
//		if (rent.flags & FL_CLIENT)
//			{
//			spawn_tdeath(org, rent);
//			rent.velocity = v_forward * 30 * random();
//			}

//		if (e.flags & FL_ONGROUND) e.flags = e.flags - FL_ONGROUND;
//		if (e.flags & FL_ITEM) chaos_teleport_restore(e, org, 0);
//		setorigin(e, org);
//		if (e.flags & FL_CLIENT)
//			{
//			spawn_tdeath(org, rent);
//			e.velocity = v_forward * 30 * random();
//			}
		sprint(self, "Items exchanged: ");
		if (e.netname != "") sprint(self, e.netname);
		else sprint(self, e.classname);

		org = e.origin;
		e = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  rent.origin , '-16 -16 -16', ' 16 16 16', v0, v0, "chaos_teleport", "", teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
		f = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  org , '-16 -16 -16', ' 16 16 16', v0, v0, "chaos_teleport", "", teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);

		f.movetarget = e; f.aflag = -1;
		e.movetarget = f; e.aflag = -1;
		force_retouch = 2;
	
		sprint(self, ", with: ");
		if (rent.netname != "") sprint(self, rent.netname);
		else sprint(self, rent.classname);
		newline(self);
		}
	else if (random() < CBSUMMON)
		{
		if (rent == world) rent = rnd_list(e, 0);
		if (rent == world) return;
		spawn_chaos_monster(0, rent.origin);
		}

																						if (TRUE && trace_ent != world) if (WARNING) { bprint("beam hit "); bprint(trace_ent.classname); newline(world); }

//setorigin(x3, trace_endpos); // TEST

};

// main attack


void() player_chaos_attack =
{
	local vector org;
	local float r1;
	local string sd, md;

	if (self.impulse == ALT_FIRE_IMP)
	{
		chaos_beam();
		return;
	}

	if (self.chaosweptime < time) // pick a weapon and some time to fire it
		{
		self.chaosweptime = time + 1 + (random() * 5); // more complex later, based on level, couple a fudge vars, etc
		r1 = random();
		if (r1 < 0.17)
		{
			self.weapon = IT_SUPER_NAILGUN | IT_LIGHTNING;  // reflective laser
			self.chaosweptime = self.chaosweptime + random() * 25;
		}
		else if (r1 < 0.27) self.weapon = IT_SUPER_NAILGUN;  // laser
		else if (r1 < 0.5) self.weapon = IT_NAILGUN; // vary these ?...
		else if (r1 < 0.57)
		{
			self.weapon = IT_NAILGUN | IT_LIGHTNING; // pulse spikes
			self.chaosweptime = self.chaosweptime + random() * 25;
		}
		else if (r1 < 0.87) self.weapon = IT_ROCKET_LAUNCHER;
		else self.weapon = IT_LIGHTNING;
//		self.delay = 3 + rint(random() * 2);
		if (random() < 0.15) self.chaosattnoise = 0;
		else self.chaosattnoise = 1;
		}

// NOTE: crap hard to do with this code
//		if (rune_haste(0.275))
//		self.attack_finished=time+0.55;

//		newmis.morphy = self.morphy; // missiles should have a morphy

	if (self.weapon == IT_LIGHTNING)
		{
		if (self.t_width < time)
		{
			if (self.chaosattnoise) sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
			self.t_width = time + 7;//0.6;
self.delay = self.delay + 1;
		}
		org = self.origin + ' 0 0 4';
		traceline (org, org + v_forward*600, TRUE, self);

		self.attack_finished = time + 0.1;
//		if (self.delay < LT_RED || self.delay > LT_BLACK) self.delay = LT_NEG; // bounds on bolt model
if (self.delay < 0 || self.delay > LT_CHAOS) self.delay = 0; // bounds on bolt model

		beam4(org, trace_endpos, self.delay);

		LightningDamage_x(FALSE, self.origin, trace_endpos + v_forward*4, self, 20);
		}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
		self.attack_finished = time + 0.8;
		if (random() < 0.16)  W_FireRocket();
		else
/* REMOVED
		 if (random() < 0.30) //0.40) 
			{
			W_FireGrenade();
			self.attack_finished = time + 0.65;
			}
		else  // lava ball
*/
			{
			if (self.chaosattnoise) sd ="boss1/throw.wav";//rnd_string(' 95.0 66.6 66.6',"weapons/grenade.wav","weapons/sgun1.wav","","","boss1/throw.wav");
			fire_missile(FIREBALL_WEP_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | FLT_IMM | MLT_LAVA | FLT_LAVA | PF_LAVA | CK_EARTHQUAKE, self.origin, ' 0 0 0', "fireballwep", "progs/lavaball.mdl", sd, fire_fly_touch, 5 + (random() * 4), meltthink, fire_fly_adj);

			newmis.frame = floor(random() * 3);
			newmis.avelocity = ' 200 100 300';
			newmis.dmgtime = time + 0.2;  // release time?
			newmis.rad_time = time + 2; // content check timer
			newmis.dmg = rint(10 + (random() * 20));
			newmis.t_length = 0.2 + (random() / 2.0); // FBW_NAPALM + (random() / 2.0);
			newmis.dest_y = 16;

			self.attack_finished = time + 0.55;
			}
		}
	else if (self.weapon & IT_NAILGUN) // fire some spikes
		{
//		md = rnd_string(' 66.6 66.6 66.6',"progs/s_spike.mdl","","","","progs/spike.mdl"); 
		if (self.chaosattnoise) sd = rnd_string(' 95.0 66.6 66.6',"weapons/spike2.wav","chaos/pist1.wav","","","weapons/rocket1i.wav");
		if (self.weapon & IT_LIGHTNING)
		{
			if (sd != "" && random() < 0.7) sd = "pulse/pulse_1.wav";
			fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + ' 0 0 4', ' 0 0 0', "pulse_spike", "progs/spike.mdl", sd, spike_touch, 2 + random() * 4, SUB_Remove, spike_touch);
			if (random() < 0.5) newmis.dmg = 16 + random() * 4;
		}
		else
			fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + ' 0 0 4', ' 0 0 0', "chaosspike", "progs/spike.mdl", sd, spike_touch, 6, SUB_Remove, spike_touch);
		RND_frame = random() * 7.4;
		RND_skin = random() * 3.4;
		if (random() < 0.6) RND_Spike();

		if (random() > 0.666) newmis.dmg = 18;
		self.attack_finished = time + 0.2;
		}
	else if (self.weapon & IT_SUPER_NAILGUN)
		{
		if (self.chaosattnoise) sd = rnd_string(' 90.0 90.0 90.0',"misc/r_tele3.wav","","","","enforcer/enfire.wav");
		if (self.weapon & IT_LIGHTNING)
		{
			if (random() < 0.5) sd = "lasercannon/laserg.wav";
			HIP_LaunchLaser(self.origin + ' 0 0 4', aim(self, 10000), rint(random()), sd); //gun_aim(self, v0), rint(random()), sd);
		}
		else
			fire_missile(LASERCAN_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + ' 0 0 4', ' 0 0 0', "laser", "progs/laser_m.mdl", sd, Laser_Blast, 6, SUB_Remove, Laser_Blast);
		newmis.skin = random() * 10.4;
		newmis.frame = random() * 10.4;
		self.attack_finished = time + 0.3;
		}
};


/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/


void() player_chaos_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

/*
	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		sprint(self, "Lava Bomb using ( Jump attack )\n");
	}
*/
	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		sprint(self, "Chaos firing random bolts\n");
		self.items = self.items | IT_CELLS;
	}
/*
	for now alt fire is chaos beam fire
	
	if (self.weapon == IT_SHOTGUN)
	{
		sprint(self, "Chaos Beam!\n");
		self.items = self.items | IT_CELLS;
	}
*/
};

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/

void() player_chaos_sight =
{
	if (random() < 0.45)
	{
		self.msight = rnd_string(' 80.0 60.0 40.0',"enforcer/sight4.wav","chaos/lava1.wav","boss2/idle.wav","ambience/buzz1.wav","ambience/thunder1.wav");
	}
};

string() player_chaos_killmsg =
{
	return(rnd_string(' 60.0 50.0 40.0'," transcended reality with ",""," danced the hot plasma boogie with "," was touched by the hand of "," felt the wrath of Chaos Lord "));
};
string() player_chaos_killmsg2 =
{
	return "\n";
};

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_chaos_become = 
{
	local float tc;

	self._stand=player_chaos_stand;
	self._run=player_chaos_run;
	self._pain=SUB_False;//player_chaos_pain; do something different
	self._die=chaos_fade;
	self._jump=SUB_Null;
	self._jump2= SUB_Null;
	self._attack=player_chaos_attack;
	self._impulse=player_chaos_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_chaos_killmsg;
	self._killmsg2=player_chaos_killmsg2;

	if (self.ammo_nails == CFCBALL)
	{
		self.ammo_nails = 0;
		tc = FL_CBALL;
	}
	else
		tc = FL_SPIKE;

	chaos_form(tc);
	self.dest_y = CB_CHAOS | CB_HUMAN | CB_SHALR | CB_CTHON | CB_SCOURGE | CB_GREMLIN | CB_TANK | CB_ARACHN | CB_ENF | CB_SCRAG;

//	if (chaos != QRACK_ENGINE) self.dest_y = self.dest_y | CB_GREMLIN;
// RESTORE - rest of morphs CB_DEMON | CB_HKNIGHT | CB_OGRE | CB_SHAMBL | CB_ZOMBY

	self.cam_z = 10 / 100;
	self.cam_y = 36;
	stuffcmd(self, "chase_up 10\n");
	stuffcmd(self, "chase_back 36\n");
	stuffcmd(self, "exec cfg/morph/m-chaos.cfg\n");

	self.items = self.items | IT_AXE | IT_SHOTGUN;
	self.builtin = IT_AXE | IT_SHOTGUN;
	self.weapon = IT_AXE;

	self.msight = "";
	self.noise2 = "boss2/idle.wav";
	self.noise3 = "";
	self.movetype = MOVETYPE_FLY;
	self.aflag = 0; // chaos form states
	self.view_ofs = ' 0 0 4';
	self.cam_z = 0.2;  //cam

//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = self.health * MCHAOS_HEALMOD / self.health_modifier;
	self.health_modifier = MCHAOS_HEALMOD;

	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!MAX_CHAOS_LVL) chaos_constant(0);

	if (!silent) // silent for starting new level as this beasty
	{
		bprint(self.netname);
		bprint(" has become \bChaos\n"); 
	}
	self.skin = 1;
};



