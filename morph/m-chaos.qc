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

Chaos...what came before Order (dont let him hear you say that...)

A formless mass of pulsating energy, plasma and quantum states.
Alive?  Intelligent?

What is life?  What is sentience.
Your sentient form supplies your intelligence from elctro-chemical signals operating in a biological circuit.

Chaos simply is.

And its here.

Not too happy about the organized state of things either.

Chaos intends to change all of that.
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
	precache_sound ("chaos/cbeam.1.wav");
	precache_sound ("chaos/cbeam.2.wav");
	precache_sound ("weapons/pbeam/pt_fire.wav");

//archon
	precache_model ("progs/nodule1.mdl");
	precache_model ("progs/nodule10.mdl");
	precache_model ("progs/nodule11.mdl");
	precache_model ("progs/nodule001.bsp");
	precache_model ("progs/nodule010.bsp");
	precache_model ("progs/nodule011.bsp");
	precache_model ("progs/nodule110110110.bsp");
	precache_model ("progs/arc_pp.bsp");
	precache_sound ("items/r_item2.wav");
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
float CHAOS_BEAM_GAIN;					// beam min added to this - beam locked out after every up
float CHAOS_MELO_MIN;//		= 60; // min lockout time

// were in chaos.defs.qc
float ci_last, ci_fr, ci_sk, ci_flg, ci_tur; // last item made & frame set, master flag, turret count
string ci_md; // last item model

float FL_SAME						= 2; // make same thing
float FL_FFLY						= 8; // move field by velocity
float FL_FJUMP						= 4; // move field by setorg
float FL_FLIT						= 32768; // light field
float FL_FPART						= 65536; // particle field
float LT_CHAOS						= 7;  // chaos beam -- IMP: replace with some other effects system
float USE_PULSE_SPIKES			= -257368;
float C_FBPER						= 0.7; // % for chaos explode to fire bolts
float CFCBALL						= 207;
float CI_EXPLBOX					= 0.1; // % chance chaos item capable will become explode box
float CI_FLAMEREAL				= 0.2; // % chance chaos item tossed flame2.mdl burns
.float chaosattnoise; // IDEA: remove
// end


void() chaos_item;


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

#ifdef warning
													if (WARNING & 4)
													{
														bprint("next burst: ");
														bprint(ftos(MAX_CHAOS_LVL));
														bprint(", lvl: ");
														bprint(ftos(self.volume));
														bprint(", beam: ");
														bprint(ftos(CHAOS_BEAM_MIN));
														bprint(", dt: ");
														bprint(ftos(dt));
														newline(world);
													}
#endifdef

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
//	local float sf;

	sv = self;
	if (cent != world) self = cent;
	if (!(pl > IMP_MIN && pl < IMP_MAX)) pl = self.height;

	if (pl == self.morphy) // already there
	{
		self = sv;
		return;
	}
//	sf = self.volume;
	polymorph_check(pl, 0); // IDEA - small chance of taking another form?
//	self.volume = sf;
//	sf = 25;
	if (IS_CHAOS(self)) 
		{
		if (pl == self.state) { self.aflag = FL_MELO; self.wait = time + CHAOS_MELO_MIN + 30 * random(); }
//		sf = 10 + random() * 35;
		}
//	sf = sf + morph_heal(self, sf);
//	if (pl == self.state)
//		if (self.health < (self.max_health * self.health_modifier * 0.5))
//			T_Heal(self, sf,0);
	self = sv;
};

// fn(chaos_morph_chgthk) - think to change morph - restores chaos from other forms

/// self.goalentity = chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, cmd + (crandom() * 150.0), chaos_morph_chgthk, SUB_Null, self, world);

void() chaos_morph_chgthk =
{
	if (self.owner.model != null_model && self.owner.model != null_string)
		chaos_morph_chg(self.owner, 0);
	if (self.owner.goalentity == self) self.owner.goalentity = world;

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

	if (md == "progs/nodule11.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/teleport.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b2.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b3.1col.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b3.2rot.mdl") mt = MOVETYPE_FLY;
	if (md == "progs/chaos_b3.3rsm.mdl") mt = MOVETYPE_FLY;

// cheat a little bit - this should be down below
	if (mt == MOVETYPE_FLY)
		setsize (e, '-16 -16 -24', '16 16 40'); // flying states
	else
		setsize (e, '-16 -16 0', '16 16 56'); // model poly

	flyer_check(e, (mt == MOVETYPE_FLY));
};

// fn(chaos_base_mdl) - restore chaos to base model or any specced model

void(entity e, string md) chaos_base_mdl =
{
	local string md2;

	if (e.morphy != IMP_MCHAOS && e.height == IMP_MCHAOS)
		chaos_morph_chg(e, 0); // back to our own true morph, restores model
	else
	{
		if (md == null_string) md2 = "progs/chaos_b2.mdl";
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
	if (e.model == "progs/teleport.mdl")			{ vmin = '-16 -16 -16'; vmax = '16 16 16'; }
	else if (e.model == "progs/lavaball.mdl" || e.model == "progs/snowball.mdl")
	{
		if (e.frame == 0 || e.frame == 5)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 2 || e.frame == 3 ||
			  e.frame == 7 || e.frame == 8)			{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
		if (e.frame == 4 || e.frame == 9)			{ vmin = '-1 -1 -1'; vmax = '1 1 1'; }
	}
	else if (e.model == "progs/grenade.mdl")
	{
		if (e.frame == 0)								{ vmin = '-2 -2 -2'; vmax = '2 2 2'; } // reg grenade
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; } // telespheres
		if (e.frame == 2 || e.frame == 7)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 3 || e.frame == 4 ||
			  e.frame == 8 || e.frame == 9)			{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
		if (e.frame == 5 || e.frame == 10)		{ vmin = '-1 -1 -1'; vmax = '1 1 1'; }
	}
	else if (e.model == "progs/proxbomb.mdl")	{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
	else if (e.model == "progs/hook.mdl")			{ vmin = '-5 -5 -5'; vmax = ' 5 5 5'; }
	else if (e.model == "progs/v_spike.mdl")		{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
//	else if (e.model == "progs/ejbatt.mdl")		{ vmin = '-2 -2 -6'; vmax = '2 2 4'; }
	else if (e.model == "progs/s_bubble.spr")	{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
	else if (e.model == "progs/chaos_b2.mdl")	{ vmin = '-16 -16 -24'; vmax = '16 16 40'; }
	if (vmin != v0 && vmax != v0) setsize(e, vmin, vmax);
};
*/

// fn(chaos_mdlsel) - select various map forms

string(float mb) chaos_mdlsel =
{
	local string s1;

	s1 = "spike ball";
	if (mb == 1)				{ ci_md = "progs/teleport.mdl"; }
	else if (mb == 2)			{ ci_md = "maps/b_rock0.bsp";					s1 = "rocket box"; }
	else if (mb == 4)			{ ci_md = "maps/b_exbox2.bsp";				s1 = "explode box"; }
	else if (mb == 8)			{ ci_md = "progs/g_gas.mdl";					s1 = "gas cylinders"; }
//	else if (mb == 16)		{ ci_md = "progs/drycel6.mdl";				s1 = "batterys"; }
	else if (mb == 16)		{ ci_md = "maps/b_batt1.bsp";					s1 = "batterys"; }
	else if (mb == 32)		{ ci_md = "progs/quaddama.mdl";				s1 = "quad"; }
	else if (mb == 64)		{ ci_md = "progs/g_rock2.mdl";				s1 = "rocket launcher"; }
	else if (mb == 128)		{ ci_md = "maps/b_bh100.bsp";					s1 = "health box"; }
	else if (mb == 256)		{ ci_md = "progs/chaos_b2.mdl";				s1 = "chaos"; }
	else if (mb == 512)		{ ci_md = "progs/nodule11.mdl";				s1 = "nodule"; }
	else ci_md = "progs/teleport.mdl";

	return(s1);
};

// fn(chaos_mdlchk) - returns false if chaos is any native model

float(string md) chaos_mdlchk =
{
	if (md == null_model) return FALSE; // dead state
	if (md == "progs/chaos_b2.mdl") return FALSE;
	if (md == "progs/chaos_b3.1col.mdl") return FALSE;
	if (md == "progs/chaos_b3.2rot.mdl") return FALSE;
	if (md == "progs/chaos_b3.3rsm.mdl") return FALSE;
	return TRUE;
};

// fn(chaos_mdlchg) - think to change forms

void() chaos_mdlchg =
{
	if (self.owner.morphy == IMP_MCHAOS)
	if (chaos_mdlchk(self.owner.model))
	{
		if (random() < 0.2) 	chaos_base_mdl(self.owner, null_string);
		else
			{
				self.alpha = 1;
				self.skin = 0;
				chaos_mdlsel(rnd_bit_mask(1023));
				setmodel(self.owner,ci_md);
				chaos_flycheck(self.owner, self.owner.model);
				self.owner.modelindex_morph=self.owner.modelindex;
				if (ci_md != "progs/chaos_b2.mdl")
					chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, 10.0 + (random() * 110.0), chaos_mdlchg, SUB_Null, self.owner, world);
			}
	}
	remove(self);
}


// fn(chaos_teleport_restore_think) - think fn - send ent back to level if stuck outside or living ent cant move after teleport / forced move
// fn(chaos_teleport_restore) - spawn fn

// NOTE - spawn Must (MUST) be called before changing origin if items are moved, so a think can restore them from solids

// runs tests for 4 rels every .5 sec.  if all checks are non-solid test is removed
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

	if (IS_CHAOS(self.owner)) chaos_base_mdl(self.owner, null_string); // restore chaos to plasma flux
	if (self.owner.flags & FL_MONSTER) self.owner.oldorigin = v0;

	e = world;
	org = v0;
	t = 7;
	while (t > 0 && !e)
	{
		t = t - 1;
		e = find_tdest(FL_RSALL, null_string); //SelectSpawnPoint ();
	}
	if (e.flags & FL_ITEM) org = '0 0 32';
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
// ts - ts & 255 - rels spent checking before restore.
// ts & FL_ITEM - apply to non living ents

void(entity e, vector org, float ts) chaos_teleport_restore =
{
	local entity c;
	local float t;

	if (!(e.health > 0 || e.solid == SOLID_SLIDEBOX)) return;

	t = ts & 255;
	c = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, v0, v0, v0, v0, v0, "chaos_teleport_restore", null_string, SUB_Null, 1, chaos_teleport_restore_think, SUB_Null, e, world);
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

/*
 we have removed health for Archons

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
*/

// fn(chaos_move_effect) - effects for chaos stand & run frames

// return 0 - do chaos model framing for plasma form
// return 1 - skip model framing

float() chaos_move_effect =
{
	local entity c;
	local float dx;

	if (intermission_running || self.deadflag) return TRUE; //stop effects seen in intermix view - left in so other morphs turn off walksounds

//	chaos_health(); // chaos does not obey normal health rules - this still needs a good test

	if (self.volume > MAX_CHAOS_LVL) self.aflag = self.aflag | FL_CSB;

// in solid - no move effect, star burst will be on hold
	if (pointcontents(self.origin) == CONTENT_SOLID) return FALSE;

// IDEA - more violent as chaos level increases
	if (self.aflag & FL_CSB) // Chaos star burst in progress
	{
		if (chaos_mdlchk(self.model)) chaos_form(FL_SPIKE);
		if (self.wait > time) return FALSE;
		self.wait = time + random() / 2.0;
		fire_burst (chaos_item, self.origin, 0, 100, null_string, null_string, 0, 1, 0, '0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND /* | FL_OWNOWN */, world);
//		if (self.health < (self.max_health * self.health_modifier * 0.30)) self.health = self.health + random() * 10;
//		else 
		if (self.health < (self.max_health * self.health_modifier * 0.70)) self.health = self.health + random() * 3;
		if (random() < 0.08) if(newmis) newmis.movetype = MOVETYPE_FLYMISSILE;
		if ((MAX_CHAOS_LVL - self.volume) > MIN_CHAOS_DEC)
		if (random() < ( MAX_CHAOS_LVL / ( self.volume * (MAX_CHAOS_LVL / 350))))
		{
			self.aflag = FL_MELO;//self.aflag - (self.aflag & FL_CSB) | FL_MELO;
			self.wait = time + CHAOS_MELO_MIN + (((MAX_CHAOS_LVL - self.volume) * 20) / MIN_CHAOS_DEC) + 25 * random();
//			sprint(self, "Chaos star burst is over\n");
			stuffcmd(self, "hud_message \"Chaos star burst is over\"\n");
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
//		chaos_fire_fly(rnd_string('95.0 85.0 40.0',"progs/v_spike.mdl","progs/teleport.mdl","progs/lavaball.mdl","progs/snowball.mdl","progs/snowball.mdl"));
		chaos_fire_fly(null_string); // this is not doing that -^
		if (newmis) 
		{
			newmis.owner = self; // fix for chaos bombs just exploding on launch
			setmodel(newmis, rnd_string('95.0 85.0 40.0',"progs/v_spike.mdl","progs/teleport.mdl","progs/lavaball.mdl","progs/snowball.mdl","progs/snowball.mdl"));
			if (random() < 0.24) newmis.think = chaos_bomb;
			else if (random() < 0.11) newmis.touch = GrenadeTouch;
			if (newmis.model == "progs/snowball.mdl")
			{
				if (random() < 0.5)
					newmis.skin = SKSNOW;
				else
				{
					newmis.skin = SKTELE;
					if (random() < 0.015)
					{
						local vector v;
						v = newmis.origin;
						remove(newmis); // gets replaced
						chaos_teleport(v, null_string, world);
//						newmis.touch = telesph_touch;
//						if (random() < 0.5) newmis.movetarget = find_tdest(FL_RSALL, null_string);
						newmis.search_time = time + 0.15 + (0.1 * random());
					}
				}
			}
			if (newmis.think == chaos_bomb)
			{
				if (random() < 0.4) newmis.aflag = MOVETYPE_BOUNCE;
				if (newmis.classname == "fireball")
				if (random() < 0.7) chaos_bomb_rndmdl(newmis);

#ifdef warning
//				if (WARNING & 4)
//				{
					sprint(self, "chaos bomb launched: ");
					sprint(self, newmis.model );
					newline(self);
//				}
#endifdef

			}
		}
	}
	else if (random() < 0.02)
	{
		fire_burst (chaos_item, self.origin, 0, 150, null_string, null_string, 0, 1, 0, '0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND /* | FL_OWNOWN */, world); // IDEA overall chaos affect cnt on this
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
			chaos_base_mdl(self, null_string);
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
 
	if (self.archon < 0)
	{
		de_archon(self);
		return;
	}
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

	if (self.archon < 0)
	{
		de_archon(self);
		return;
	}
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

	if (sky_touch(null_string, v0, self))
	{
		SUB_Remove();
		return;
	}

	if (self.classname != "calderashard")
	if (other.height == IMP_MCHAOS || other.morphy == IMP_MCHAOS) return; //IS_CHAOS(other)

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
		move_stop(self, null_string);
	}
};

float chaos_dynlit; // limit dynamic lights in tenebrae

void() fire_cbolt =
{
	float f1;

	fire_missile(700, MOVETYPE_FLYMISSILE, 0, RM_SKY, self.origin, '0 0 0', "chaosbolt", "progs/spike.mdl", null_string, cbolt_touch, 6 + random() * 6, SUB_Remove, SUB_Nop); // SUB_FadeRemove, SUB_Nop);
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
		setsize (self, '-16 -16 -24', '16 16 40');
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
		chaos_base_mdl(self, null_string);
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
		fire_burst (fire_cbolt, self.origin, 0, 0, null_string, null_string, 0, 8, 28, '0 0 0', ' 360 360 360', SUB_Null, FL_VELRND2 /* | FL_OWNOWN */, world);
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
void() player_chaos_fade15 = [ $chaosfade8,   SUB_Nop  ] { setmodel(self,null_model); }; // IDEA: pop sound?
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
	fire_burst (wfire, self.origin + '0 0 30', 0, 0, null_string, null_string, 0, 3, 8, '120 0 0', ' 300 360 360', vspk, FL_ANGADR | FL_VELRND | FL_FRCORG | FL_NEWSELF | FL_OWNOWN, world);
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
	if (ft || random() < 0.02) // lava balls - CHECK: dont seem to see many of these
		{
		if (!ft) ci_fr = floor(random() * 2.2);
		ci_last = 2;
		chaos_fire_fly(null_string);
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
			if (!ft) ci_fr = floor(random() * 11.3);
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
			else if (ci_fr == 9) { beartrap_dropBearTrap(); newmis.beartrap_time = time + 9 + random() * 20; }
			else if (ci_fr == 10)
			{
				self.cnt = 1;
				if (self.morphy == IMP_MCHAOS) // chaos personal rnd turret toss
				{
					if (self.aflag & FL_CSB) self.cnt = 3;
					ci_tur = cnt_ent(world, "owner",  "turret");
					ci_tur = ci_tur + 1;
					if (ci_tur > self.cnt) self.cnt = 0;
				}

				if (self.cnt)
				{
					turret_dropTurret();
					turret.owner = self.owner;
				}
				else
				{
					beartrap_dropBearTrap();
					newmis.beartrap_time = time + 9 + random() * 40;
				}
			}
			else if (ci_fr == 11)
			{
				newmis = spawn();
				item_call_save(newmis, "archon_altar");
				newmis.goalentity = self;
				dyn_remove(newmis, 160 + crandom() * 60, SUB_Null);
			}
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
			else if (r1 == 2) {ci_md = "progs/h_dog.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 20; }
			else if (r1 == 3) ci_md = "progs/hook.mdl";
			else if (r1 == 4) {ci_md = "maps/b_rock0.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 50; }
			else if (r1 == 5) {ci_md = "maps/b_exbox2.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 80; }
			else if (r1 == 6) ci_md = "progs/flame2.mdl";
			else if (r1 == 7) ci_md = "progs/end1.mdl";
			else if (r1 == 8) ci_md = "progs/end2.mdl";
			else if (r1 == 9) ci_md = "progs/end3.mdl";
			else if (r1 == 10) ci_md = "progs/end4.mdl";
			else if (r1 == 11) {ci_md = "maps/b_batt1.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 30; }
			else if (r1 == 12) ci_md = "progs/zom_gib.mdl";
			else if (r1 == 13) ci_md = "progs/s_bubble.spr";
			else if (r1 == 14) ci_md = "progs/nodule110110110.bsp"; // this is cruel - a fake god particle
			else if (r1 == 15) {ci_md = "progs/chaos_b2.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 100; }
			else if (r1 == 16) ci_md = "progs/grenade.mdl";
			else if (r1 == 17) {ci_md = "progs/invulner.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 30; }
			else if (r1 == 18) {ci_md = "progs/g_gas.mdl"; ci_fr = CI_EXPL_BASE_DMG + random() * 80; }
			else if (r1 == 19) ci_md = "progs/beartrap.mdl";
			else if (r1 == 20) {ci_md = "maps/b_eshel0.bsp"; ci_fr = CI_EXPL_BASE_DMG + random() * 50; }
			else if (r1 == 21) { ci_md = "progs/laser_m.mdl"; ci_sk = floor(random() * 10.4); ci_fr = floor(random() * 10.4); }
		}
	if (ft || random() < 0.05) // random inert crap
		{
			ci_last = 4;
			newmis = chaos_spawn(MOVETYPE_TOSS, SOLID_TRIGGER, 0, RM_SKY | MLT_LAVA | FLT_LAVA | PF_WATER | PF_SLIME | CK_EARTHQUAKE | PF_SOLID, v0, v0, v0, v0, v0, "chaos_item", ci_md, sky_touch_pointer, 5 + (random() * 20), remove_fade, SUB_Null, self, world);
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
						if (newmis.size_z > 60) setsize(newmis, '-16 -16 -16', '16 16 16'); // some are sized huge
						if (random() < 0.98) newmis.th_stand = SUB_Remove; // in case of respawn being called - dont regen
#ifdef warning
																														if (WARNING & 4)
																														{
																															bprint("chaos_item(explode box) = ");
																															bprint(newmis.model);
																															newline(world);
																														}
#endifdef
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
						newmis.view_ofs = '0 0 -12';
						setsize(newmis, newmis.mins, newmis.maxs);
						if (random() < CI_FLAMEREAL)
							newmis.touch = FlameTouch;
					}
				chaos_mdlsize(newmis);

				if (ci_md == "progs/chaos_b2.mdl")
				{
					newmis.movetype = MOVETYPE_FLY;
					newmis.think = chaos_field_thk; // give some random movement
					newmis.nextthink = time + random();
					newmis.aflag = FL_FFLY;
					if (random() < 0.5) newmis.flags = newmis.flags | FL_FPART;
					newmis.wait = time + 10 + (random() * 30);
				}
			}

// NOTE: does not work the same way - compare code
			if (random() < 0.8) item_eject(newmis, MED_BOUNCE);
			else if (random() < 0.3) newmis.movetype = MOVETYPE_FLY;

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
			newmis = drop_item(r1, null_string, self, MED_BOUNCE);

			if (newmis)
			{
				newmis.class_select = "chaos_item";

				if (f1 > 8) f1 = f1 - 2;
				chaos_level( 0 - (f1 * 8) - 1, self.owner);

	// select a random trail
				f1 = newmis.modelflags & 8; // keep rotates mostly
				if (random() < 0.2) f1 = 0;
				r1 = rnd_bit_mask(MF_HAPPYTRAIL);
				if (r1 < 256) newmis.modelflags = r1 | f1;

				dyn_remove(newmis, 50 + crandom() * 40, SUB_Null);
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

	fire_burst (chaos_item, org, 0, 75, null_string, null_string, 0, c1, c2, '0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND2 | FL_FRCORG | FL_NEWSELF /* | FL_OWNOWN */, world);
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
float lf_per						= 0.06; // chance per sec of light field
float pf_per						= 0.05; // chance per sec of particle field
float pf_len						= 5.0; // avg field 5 rels
float pf_dev						= 1.5; // +- 1.5
float pf_exc						= 17.0; // exceptional fields are longer
float particle_fields;

float(float ad) fieldadd = // field count controls
{
	if ((particle_fields + ad) < 1) return 0.0; // MR, BLUTARSKI...
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
	if (random() < 0.5) self.distance = 20 + random() * 200;
	else self.distance = 85;
	if (random() < 0.5) self.cnt = 0.333 + random();
	else self.cnt = 0.8;

	if (self.morphy != IMP_MORDER) // for now order fields wont move - cause they cant move chaotically
	if (random() < 0.2) chaos_fieldmove(self);

	if (self.flags & FL_FPART) chaos_particle(self.origin, self.distance, self.cnt, -1);
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
	newmis = world;
	if (particle_fields > MAX_FIELDS) return;
	particle_fields = fieldadd(1);
	newmis = chaos_spawn(0, 0, FL_FPART, 0, org, v0, v0, v0, v0, "chaos_field", null_string, SUB_Null, 0.1, chaos_field_thk, SUB_Null, self, world);
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
	newmis = chaos_spawn(0, 0, FL_FLIT, 0, org, v0, v0, v0, v0, "chaos_field", null_model, SUB_Null, 0.1, chaos_field_thk, SUB_Null, self, world);
	newmis.wait = time + pf_len + crandom() * pf_dev;
	if (random() < 0.5) newmis.aflag = FL_FJUMP;
	else if (random() < 0.5) newmis.aflag = FL_FFLY;
	chaos_fieldmove(newmis);
};

// fn(spawn_chaos_monster) - call fn to creat a random chaos monster
// torg - target origin
// monster count for level, SVC msg - done in item_call *
// pre set codes - use CB_M instead

// NOTE: redo with item_call_save

void(float sel, vector torg) spawn_chaos_monster =
{
	self.charmer = chaos_spawn(0, 0, 0, 0, torg, v0, v0, v0, v0, null_string, null_string, SUB_Null, 0.0, SUB_Null, SUB_Null, self, world);

	if (!sel) sel = floor(random() * 11.5);
	if (random() < 0.4)																// float WEAK_MONSTER = 0.4; // percentage chance of weaker monster only
		while (sel > 5) sel = floor(random() * 10.5);

	if (sel == 0)				sg = "monster_dog"; 		// monster_dog(A_MONSTER);
	else if (sel == 1)	sg = "monster_zombie"; 		// monster_zombie(A_MONSTER);
	else if (sel == 2)	sg = "monster_wizard"; 		// monster_wizard(A_MONSTER);
	else if (sel == 3)	sg = "monster_army"; 		// monster_army(A_MONSTER);
	else if (sel == 4)	sg = "monster_enforcer"; 	// monster_enforcer(A_MONSTER);
	else if (sel == 5)	sg = "monster_ogre"; 		// monster_ogre(A_MONSTER);
	else if (sel == 6)	sg = "monster_hell_knight"; // monster_hell_knight(A_MONSTER);
	else if (sel == 7)	sg = "monster_tarbaby"; 	// monster_tarbaby(A_MONSTER);
	else if (sel == 8)	sg = "monster_shalrath"; 	// monster_shalrath(A_MONSTER);
	else if (sel == 9)	sg = "monster_demon1"; 		// monster_demon1(A_MONSTER);
	else if (sel == 10)	sg = "monster_shambler"; 	// monster_shambler(A_MONSTER);
	else if (sel == 12)	sg = "monster_scourge"; 	// monster_scourge(A_MONSTER);

	item_call_save(self.charmer, sg);

	self.charmer.charmer = self;
	self.charmer.charmed = 1;
	self.charmer.target1 = "chaos_item";

	norm = self.charmer.origin;
	norm_z = norm_z + self.charmer.mins_z;
	gsf = 250;
	while ((pointcontents(norm) == CONTENT_SOLID) && gsf > 0) // try to move out of solid because source ent has lower origin than monsters
	{
		norm_z = norm_z + 2;
		gsf = gsf - 1;
	}
	if (gsf < 250 && gsf > 0) setorigin(self.charmer, norm + '0 0 22');
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
float CBURST						= 0.04; // chance of chaos burst per sec
float CBQUAKE						= 0.05; // chance of chaos beam quake
float CBTELEP						= 0.03; // chance of chaos beam teleport
float CBEXCH						= 0.05; // chance of chaos beam exchange
float CBDROPI						= 0.02; // chance of chaos beam drop item - done in chaos_item for now
float CBXFORM						= 0.03; // chance of chaos beam transform
float CBSUMMON						= 0.015; // chance of chaos beam summon monster

#ifdef testset
entity x3;
#endifdef

void() chaos_beam =
{
	local vector org, ep;
	local entity rent, e, f;
	local float f1;

#ifdef testset
if (x3 == world) x3 = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0, v0, v0, v0, v0, v0, "chaos_item", "progs/chaos_b2.mdl", SUB_Null, 0, SUB_Null, SUB_Null, self, world); // TEST--
#endifdef


	if (self.aflag & FL_CSB) return;
	if (self.volume < CHAOS_BEAM_MIN + CHAOS_BEAM_GAIN) return;

	chaos_level(CHAOS_DEC, self);
	if (self.chaosattnoise < time) // select beam sound
		{
//		if (random() < 0.5) beam_hum = "chaos/cbeam.2.wav";
//		else beam_hum = "chaos/cbeam.1.wav";
			beam_hum = "weapons/pbeam/pt_fire.wav";
		self.chaosattnoise = time + 10 + (random() * 30);
//		if (random() < 0.3) self.chaosattnoise = self.chaosattnoise + random() * 100;
		}

	if (self.t_width < time) // sound beam
	{
		sound (self, CHAN_WEAPON, beam_hum, 1, ATTN_NORM);
		if (beam_hum == "chaos/cbeam.1.wav") self.t_width = time + 6.0;
		else self.t_width = time + 2.954;
	}

	self.aflag = self.aflag | FL_MELO;
	self.wait = time + random() * random();
	self.attack_finished = time + 0.1;

	org = self.origin + '0 0 4';
	traceline (org, org + v_forward*900, FALSE, self);
	ep = trace_endpos;

	if (pointcontents(ep) == CONTENT_SOLID) return;

//	set_CLE("calderashard", null_string, null_string, null_string, null_string, null_string, null_string);

	if (trace_ent == world) ep = trace_endpos - (v_forward * (32 + (64 * random())) ); // move burst away from wall
// try beam struck ent
	else
	if (move_check(trace_ent, 15999)) rent = trace_ent; // beam hit something specific

//	if (chaos == CHAOS_ENG) cvar_set("findnonsolid","1");

// fire beam
	if (self.classname == "player") beam4(org, trace_endpos, LT_CHAOS);

// field effect
	if (random() < pf_per) spawn_particle_field(ep);
	if (random() < lf_per) spawn_light_field(ep);


// beam didnt hit anything - pick an ent in beam strike area
	if (!rent)
	{
		e = findradius(ep, 64 + random() * 64);
		rent = rnd_list(e, 0); // any random ent in beam strike range

		if (self.rune_flag & RUNE_VAMPIRE) // note: dont get a drain on a "direct" beam hit
		if (archon_high != self)
		if (archon_high.archon > 0.2)
		{
			if (archon_high.archon > 500)
			{
				if (autocvar_hud_vampire_target == null_string) // IMP: more archon shields - ps
				{
					power_drain(archon_high);
					newmis.archon = 6 + random() * 6 + random() * 6; // per sec drain
					newmis.spawnflags = 1; // varmpire rune power drain
					stuffcmd(self, "hud_vampire_target \"");
					stuffcmd(self, newmis.netname);
					stuffcmd(self, "\"\n");
				}
			}
			else
			{
				f1 = 0;
				if (random() < 0.5)
				if (archon_high.archon < 10)
					f1 = archon_high.archon / 2;
				else
				{
					f1 = archon_high.archon * 0.2;
					f1 = f1 * (random() + 0.5);
					if (f1 > 100) f1 = 10 + random() * 50;
					if (!archon_high) f1 = random() * 6;
				}
				self.archon = self.archon + f1;
				archon_high.archon = archon_high.archon - f1;
			}
		}
	}

/* no volcano yet
	if (random() < CBQUAKE)
	{
		if (rent) VolcanoQuake(rent, "chaos beam");
		else
		{
			e = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0, ep, v0, v0, v0, v0, "quakelocate", null_string, SUB_Null, 0.1, SUB_Remove, SUB_Null, self, world);
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
		e = find_tdest(FL_RSALL, null_string);
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
		f = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  rent.origin , '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", null_string, teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
		f.movetarget = e;
		force_retouch = 2;

		sprint(self, "teleported: ");
		if (rent.netname != null_string) sprint(self, rent.netname);
		else sprint(self, rent.classname);
		sprint(self, ", to: ");
		if (e.netname != null_string) sprint(self, e.netname);
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
		if (e.netname != null_string) sprint(self, e.netname);
		else sprint(self, e.classname);

		org = e.origin;
		org_z = rent.origin_z;
		f = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  org , '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", null_string, teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
		f.enemy = e;

		org = rent.origin;
		org_z = e.origin_z;
		e = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  org , '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", null_string, teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
		e.enemy = rent;

		f.spawnflags = e.spawnflags = 48 + 128; // NONDIR, nodeath code
		f.movetarget = e; f.aflag = -6;
		e.movetarget = f; e.aflag = -6;
		force_retouch = 2;
	
		sprint(self, ", with: ");
		if (rent.netname != null_string) sprint(self, rent.netname);
		else sprint(self, rent.classname);
		newline(self);
	}
	else if (random() < CBSUMMON)
	{
		if (rent == world) rent = rnd_list(e, 0);
		if (rent == world) return;
		spawn_chaos_monster(0, rent.origin);
	}

#ifdef testset
		else
		{
			if (rent == world) rent = rnd_list(e, 0);
			if (rent == world) return;
			spawn_chaos_monster(0, rent.origin);
		}

setorigin(x3, trace_endpos); // TEST--
#endifdef

#ifdef warning
																						if (trace_ent != world)
																						if (WARNING & 4)
																						{
																							bprint("beam hit ");
																							bprint(trace_ent.classname);
																							newline(world);
																						}
#endifdef

};

// spell code
/// teleports

void() multi_teleport =
{
	gsf = 0;
	v1 = self.bolt_target.origin;
	newmis = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  v1 , '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", null_string, teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
	newmis.enemy = self.bolt_target;

	v1 = self.enemy.origin;
	trace_ent = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0,  v1 , '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", null_string, teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
	trace_ent.enemy = self.enemy;

// compensate for different relative origin heights from ground
	if (self.bolt_target.mins_z < self.enemy.mins_z)
	{
		gsf = self.enemy.mins_z - self.bolt_target.mins_z;
		trace_ent.origin_z = trace_ent.origin_z + gsf;
		newmis.origin_z = newmis.origin_z - gsf;
	}
	if (self.enemy.mins_z < self.bolt_target.mins_z)
	{
		gsf = self.bolt_target.mins_z - self.enemy.mins_z;
		trace_ent.origin_z = trace_ent.origin_z - gsf;
		newmis.origin_z = newmis.origin_z + gsf;
	}
//	if (newmis.enemy.movetype == MOVETYPE_NONE) - find out why some stuff doesnt port


	trace_ent.spawnflags = newmis.spawnflags = 48 + 128; // NONDIR, nodeath, NOVEL code
	trace_ent.movetarget = newmis; trace_ent.aflag = -6;
	newmis.movetarget = trace_ent; newmis.aflag = -6;
	force_retouch = 2;

	self.archon = self.archon - self.pk_explode_ammo;
	self.pk_explode_ammo = 0;
	self.bolt_targetTimeout = 0;	
};

void() uni_teleport =
{
	if (self.bolt_target.classname != "beacon")
	{
		gsf = 5;
		v1 = self.bolt_targetNext.origin;

		if (self.bolt_targetNext.angles_x == 0) // verticle wall
		{
			if (self.bolt_target.mins == v0)
				gsf = self.bolt_target.maxs_x / 2;
			else
				gsf = self.bolt_target.maxs_x;

	//		traceline(self.origin + self.view_ofs, self.origin + self.view_ofs + v_forward * 3000, FALSE, self);
	//		v1 = v1 + trace_plane_normal * (gsf * 1.2);
			if (self.bolt_target.flags & FL_CLIENT) gsf = gsf * 1.5;
			v1 = v1 - v_forward * (gsf * 1.2);

			gsf = 0;
		}

		if (self.bolt_targetNext.angles_x == 270)
			v1_z = v1_z + gsf - self.bolt_target.maxs_z;
		else
		if (self.bolt_targetNext.angles_x == 90)
		{
			v1_z = v1_z - gsf - self.bolt_target.mins_z;
			if (self.bolt_target.class_select == "class_monster") v1_z = v1_z + 16; // because they are chronic floor slippers
		}
	}
	else
	{
		if (self.bolt_target.nextthink < time + 60) self.bolt_target.nextthink = time + 60;
		v1 = self.bolt_target.angles;
		makevectors(v1);
		v1 = self.bolt_target.origin;
		v1 = v1 + v_forward * 32;
		self.bolt_target = self;
	}


// teleport to this
	trace_ent = chaos_spawn(MOVETYPE_NONE, 0, 0, 0, v1, v0, v0, v0, v0, "chaos_teleport_dst_temp", null_string, SUB_Null, 0.3, SUB_Remove, SUB_Null, world, world);

	newmis = chaos_spawn(MOVETYPE_NONE, SOLID_TRIGGER, 0, 0, self.bolt_target.origin, '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", null_string, teleport_touch, 0.1, SUB_Remove, SUB_Null, world, world);
	newmis.enemy = self.bolt_target;
//	if (newmis.enemy.movetype == MOVETYPE_NONE) - find out why some stuff doesnt port

	newmis.spawnflags = 16 + 128; // NONDIR, NOVEL  code - death allowed
	newmis.movetarget = trace_ent;
	newmis.aflag = -6; // code to use .enemy instead of other touch entity
	force_retouch = 2;

	self.archon = self.archon - self.pk_explode_ammo;
	self.pk_explode_ammo = 0;
	self.bolt_targetTimeout = 0;	
};

void() remove_beacon =
{
		if (self.owner.goalentity == self)
		{
			if (self.owner.goalentity == self.owner.bolt_target) self.owner.bolt_target = world;
			self.owner.goalentity = world;
			sprint(self.owner, "Beacon expired.");
		}
		remove(self); // IMP: fade remove this later
};

void() beacon_touch =
{
	move_stop(self, "player/axhit2.wav");
	self.touch = SUB_Null;
	self.movetype = MOVETYPE_FLY;
};

void() set_beacon =
{
	fire_missile(FIREBALL_WEP_VEL, MOVETYPE_FLYMISSILE, 0 , RM_SKY | PF_LAVA, self.origin, v0, "beacon", "progs/chaos_b3.3rsm.mdl", null_string, beacon_touch, 180,  remove_beacon, remove_beacon);
	newmis.frame = 11;
	newmis.morphy = self.morphy;	
	self.archon = self.archon - self.pk_explode_ammo;
	self.goalentity = newmis;

// beacon set - teleport mode
	spell_target();
};

/// polymoprh

void() poly_restore =
{
	if (self.owner.flags & (FL_MONSTER | FL_ITEM))
	if (self.owner.target2)
	if (self.owner.target2 != self.owner.classname)
	{
		self.owner.think = SUB_Null; // incase it was a monster

		item_call_save(self.owner, self.owner.target2);
		if (self.owner.flags & FL_ITEM)
		{
			self.owner.takedamage = 0;
			self.owner.touch = painkeep_touch;
		}
	}
	remove(self);
};

void() poly_monster =
{
	trace_ent = self;
	if ((self.pk_explode_ammo < 50) && !self.bolt_target.flags & FL_MONSTER) self.pk_explode_ammo = 50; // repeat defaults to 30
	self.stack3 = monster_id(self.pk_beartrapammo, MON_FUNC_REG);
	self = self.bolt_target;
	setorigin(self, self.origin + '0 0 32');

// so order can attempt to put it back
	if (! self.target2) self.target2 = self.classname;

// chaos poly stuff does not always stay so
	if (trace_ent.morphy == IMP_MCHAOS)
#ifdef testset
		chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, 10.0 + (random() * 20.0), poly_restore, SUB_Null, self, world);
#else
	if (random() < 0.25)
		chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, 50.0 + (random() * 110.0), poly_restore, SUB_Null, self, world);
#endifdef

	trace_ent.stack4 = self.class_select;
	if (self.flags & FL_MONSTER) total_monsters = total_monsters - 1; // because this will be bumped and this guy is already a mosnter
	else self.class_select = "class_monster"; // so item_call does right stuff
	self.flags = FL_ONGROUND; // strips of item flags, etc
	self.touch = SUB_Null;
	self.spawnflags = 0;
	if (self.map == "rune") self.map = null_string; // rune server has to make a new rune now!
	item_call(trace_ent.stack3);

	self.class_select = trace_ent.stack4;
	self = trace_ent;
	self.archon = self.archon - self.pk_explode_ammo;
	self.impulse = 0;
	remove(self.eweapon);
	cube_rearm(); // re arm player - in case other was a player - get rid of after client mode is done for poly players
	self.pk_explode_ammo = 0;
	self.bolt_targetTimeout = 0;	
};

void() poly_init =
{
	other = self;
	self = spawn(); // tricky - we "make" a hidden morph cube
	morph_cube();
	if (other.ammo_nails == 5) // poly other can use all forms accessible
	{
		if (other.bolt_target.flags & FL_CLIENT)
			self.mask_x = MORPH_MONSTER;
		else
		{
			self.mask_x = 421887; // CB_M_ARMY+ CB_M_FISH+ CB_M_KNIGHT+ CB_M_DOG + CB_M_DEMON + CB_M_ENF + CB_M_HKNIGHT + CB_M_OGRE+ CB_M_SHALR+ CB_M_SHAMBL + CB_M_SCRAG + CB_M_ZOMBY + CB_M_TARBABY	+ CB_M_SCOURGE +CB_M_GREMLIN + CB_M_VOMIT;
			self.ammo_nails = FL_MONSTER;
			self._alt_fire = poly_monster;
		}
	}
	else
	if (other.height == IMP_MCHAOS)
		self.mask_x = CB_DEMON + CB_OGRE + CB_SHALR + CB_SCRAG + CB_ZOMBY + CB_CTHON + CB_GREMLIN + CB_SCOURGE;
	else
	if (other.height == IMP_MORDER)
		self.mask_x = IMP_MHUMAN + CB_ENF + CB_HKNIGHT + CB_OGRE;

	other.state = 0;
	self.model = null_string;
	self.wad = "morph_cube";
	self.mcode = -666; // use archon magic vector in HUD - still will display cube info
	cube_touch();
	self.nextthink = 0;
	self = other;
	self.weapon = IT_SUPER_SHOTGUN; // for HUD
	self.archon = self.archon - self.pk_explode_ammo;
	morphic_impulse();
};

// chaos special - order can not do

void() transmogrify =
{
	if (self.height == IMP_MORDER)
	{
		if (self.model == "progs/orderform.mdl")
		{
			setmodel(self,"progs/chaos_b2.mdl");
			self.skin = 4;
		}
		else
		{
			setmodel(self,"progs/orderform.mdl");
			self.skin = 0;
		}
		self.modelindex_morph = self.modelindex;
		self.archon = self.archon - self.pk_explode_ammo;
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		return;
	}
	chaos_mdlsel(self.pk_beartrapammo);
	if (ci_md != self.model)
	{
		self.alpha = 1;
		self.skin = 0;
		setmodel(self,ci_md);
		chaos_flycheck(self, self.model);
		self.modelindex_morph = self.modelindex;
		if (ci_md != "progs/chaos_b2.mdl")
			chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, 10.0 + (random() * 110.0), chaos_mdlchg, SUB_Null, self, world);
		self.archon = self.archon - self.pk_explode_ammo;
	}
};

/// powers

void() rune_powers =
{
	if (self.pk_beartrapammo == 4194304)
	{
		if (self.rune_flag) self.archon = self.archon - self.pk_explode_ammo;
		self.rune_flag = 0;
		self.pk_beartrapammo = 1;
		self.pk_explode_ammo = 0;
		self.bolt_targetTimeout = 0;	
	}
	else
	if (!self.rune_flag)
	if (self.archon > 1500)
	{
		self.rune_flag = self.rune_flag | self.pk_beartrapammo;
		self.archon = self.archon - self.pk_explode_ammo;
	}
};

void() archon_gwell =
{
	drop_gravity();
	setorigin(newmis, self.bolt_targetNext.origin - v_forward * 15);
	newmis.goalentity = self;
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce - or this fires 1 - 4
};

void() monster_speed =
{
	if (! self.bolt_target.flags & FL_MONSTER) return;
	if (self.pk_beartrapammo == 1)
		self.bolt_target.speed = self.bolt_target.speed - 0.01;
	else
		self.bolt_target.speed = self.bolt_target.speed + 0.01;
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
};

/// create spells

void() archon_makepp =
{
	newmis = spawn();
	newmis.spawnflags = 1; // no heal
	setorigin(newmis, self.bolt_targetNext.origin - v_forward * 15);
	newmis.wad = "archon_power";
	newmis.event = "dynamic_item";

	item_call_save(newmis, newmis.wad);
	setsize(newmis, self.mins,self.maxs);
	newmis.touch = archon_power_touch;
	newmis.solid = SOLID_TRIGGER;
	newmis.goalentity = self;
	
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 3; //debounce
};

void() archon_maketele =
{
	chaos_teleport(self.bolt_targetNext.origin - v_forward * 15, null_string, world);
	
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
};

/* quake stuff archons can make

bits = 6377471

IT_QUAD
IT_SUIT
IT_SUPERHEALTH
IT_ARMOR2
IT_CELLS
IT_ROCKETS
IT_NAILS
IT_SHELLS
IT_LIGHTNING
IT_EXTRA_WEAPON - mjolnir
IT_ROCKET_LAUNCHER
IT_GRENADE_LAUNCHER
IT_SUPER_NAILGUN
IT_NAILGUN
IT_SUPER_SHOTGUN
IT_SHOTGUN
*/

// items by classic bits

// op -
// 	- 1 - quake items

string (float bc, float op) item_by_clbit =
{
	if (bc == IT_AXE)														return("weapon_axe");
	if (bc == IT_SHOTGUN)												return("weapon_shotgun");
	if (bc == IT_SUPER_SHOTGUN)										return("weapon_supershotgun");
	if (bc == IT_NAILGUN)												return("weapon_nailgun");
	if (bc == IT_SUPER_NAILGUN)										return("weapon_supernailgun");
	if (bc == IT_GRENADE_LAUNCHER)									return("weapon_grenadelauncher");
	if (bc == IT_ROCKET_LAUNCHER)										return("weapon_rocketlauncher");
	if (bc == IT_LIGHTNING)												return("weapon_lightning");
	if (bc == IT_MJOLNIR)												return("weapon_mjolnir");

	if (bc == IT_INVULNERABILITY)										return("item_artifact_invulnerability");
	if (bc == IT_SUIT)													return("item_artifact_envirosuit");
	if (bc == IT_INVISIBILITY)											return("item_artifact_invisibility");
	if (bc == IT_QUAD)													return("item_artifact_super_damage");

	if (bc == IT_ARMOR1)													return("item_armor1");
	if (bc == IT_ARMOR2)													return("item_armor2");
	if (bc == IT_ARMOR3)													return("item_armorInv");

	if (bc == IT_SUPERHEALTH)											return("item_health_mega");

	if (bc == IT_KEY1)													return("item_key1");
	if (bc == IT_KEY2)													return("item_key2");

	if (bc == IT_SHELLS)													return("item_shells_lg");
	if (bc == IT_NAILS)													return("item_spikes_lg");
	if (bc == IT_ROCKETS)												return("item_rockets_lg");
	if (bc == IT_CELLS)													return("item_cells_lg");

/// op 2

//	if (bc == MC_HEALTHROT)												return("item_health_15");
//	if (bc == MC_HEALTH)													return("item_health");
//	if (bc == MC_SIGIL1)													return("item_sigil1");
//	if (bc == MC_SIGIL2)													return("item_sigil2");
//	if (bc == MC_SIGIL4)													return("item_sigil4");
//	if (bc == MC_SIGIL8)													return("item_sigil8");

//	if (bc == MC_SIGIL16)												return("item_sigil16");
//	if (bc == MC_SIGIL32)												return("item_sigil32");
//	if (bc == MC_SIGIL64)												return("item_sigil64");

	return(null_string);
};

void() archon_makeit =
{
	if (self.ammo_bullet == 7) self.stack3 = item_by_clbit(self.pk_beartrapammo, 1);
	else if (self.ammo_bullet == 11) self.stack3 = ammo_by_bit(self.pk_beartrapammo);
	if (self.stack3 == null_string) return;

	newmis = spawn();
	setorigin(newmis, self.bolt_targetNext.origin - v_forward * 15);

	newmis.class_select = "chaos_item";
	item_call_save(newmis, self.stack3);
	
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
};
/// archon I & II spells

void() archon_heal =
{
// things we cant heal
	if (self.bolt_target == self) return;
	if (self.bolt_target.health <= 0) return;
	if (! self.bolt_target.takedamage) return;
	if (self.bolt_target.mask_x & MORPH_ARCHON) return;
//	if (self.bolt_target.flags & FL_GODMODE) return;

	if (self.bolt_target.max_health <= 0)
	{
		if (self.bolt_target.health > 100) self.bolt_target.max_health = self.bolt_target.health;
		else self.bolt_target.max_health = 100;
	}
	
	self.AIRG_Timeout = self.bolt_target.max_health * self.bolt_target.health_modifier;

	if (self.pk_beartrapammo & 1)
	{
		if (self.bolt_target.health >= self.AIRG_Timeout) return;
		self.AIRG_Flags = floor((self.AIRG_Timeout - self.bolt_target.health) / 2);
		if (self.AIRG_Flags < 5) self.AIRG_Flags = 5;
		if (self.bolt_target.flags & FL_CLIENT) T_Heal(self.bolt_target, self.AIRG_Flags, 0);
		else self.bolt_target.health = self.bolt_target.health + self.AIRG_Flags;
	}
	else
	{
		self.AIRG_Flags = floor(self.bolt_target.health / 2);
		if (self.AIRG_Flags > 200) self.AIRG_Flags = 200; // cap this
		T_Damage(self.bolt_target, self, self, self.AIRG_Flags);
//		self.bolt_target.health = self.bolt_target.health - self.AIRG_Flags;		
	}
	
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
};

// keep things imprisoned - reduce points for archon doing imprisoning

void() bot_stand1;

void() thing_imprisoned =
{
	if (self.enemy.disconnectPlayer)
	{
		remove(self);
		return;
	}

	self.classname = "imprisoned";
	self.nextthink = time + 0.25;

// NOTE: archon sub-game idea -
//					imprisoned pieces in arc I are freed when color reaches their favor, in arc II they are not freed, but dont die


	if (self.button4 <= 0) // player freed in one complete color exchange, monsters when they die of neglect
	{
		if (self.enemy.flags & FL_CLIENT)
		{
			self.enemy.movetype = MOVETYPE_WALK;
			self.enemy.think = player_stand1;
			if (self.enemy.classname == "pk*bot") self.enemy.think = bot_stand1;
		}
		else if (self.enemy.flags & FL_MONSTER)
		{
			Killed(self.enemy, self.owner);
		}

		self.enemy.attack_finished = 0;
		self.enemy.event = null_string; // clear imprison notice so we can re-imprison
		self.owner.archon = self.owner.archon + 50; // self.pk_explode_ammo; - we dont have release spell set in this case
		remove(self.enemy.bolt_target); // NOTE: may need verification in case they get hit by clg !!
		remove(self);
	}
	else if (! self.owner.mask_x & MORPH_ARCHON) // caster was de-archoned, free prisoners
	{
		if (self.enemy.flags & FL_CLIENT)
		{
			self.enemy.movetype = MOVETYPE_WALK;
			self.enemy.think = player_stand1;
			if (self.enemy.classname == "pk*bot") self.enemy.think = bot_stand1;
		}
		else if (self.enemy.flags & FL_MONSTER)
		{
			self.enemy.think = self.enemy.th_run;
			self.enemy.nextthink = time + 1;
		}
		self.enemy.attack_finished = 0;
		self.enemy.event = null_string;
		self.owner.archon = self.owner.archon + 50; // still releases energy back to former Archon
		remove(self.enemy.bolt_target); // NOTE: may need verification in case they get hit by clg !!
		remove(self);
	}
	else
	{
		if (self.enemy.flags & FL_CLIENT)
		{
			self.enemy.movetype = MOVETYPE_NONE;
		}
		if (self.enemy.health <= 0) self.button4 = 0;
		self.enemy.attack_finished = MAXFL;
		self.enemy.think = SUB_Null; // for bots & monsters
		self.enemy.event = "imprisoned";

		if (self.ltime < time) // only fire this every 3 secs
		{
			self.ltime = time + 3;
			self.button4 = self.button4 - 3;
			self.owner.archon = self.owner.archon - 5;
		}
	}
};

// select next in imprisoned list for a given archon

void() next_imprisoned =
{
	gsf = 200;
	if (!self.bolt_target)
		self.bolt_target = find(world, classname, "imprisoned");
	else
		self.bolt_target = find(self.bolt_target, classname, "imprisoned");

	while ((gsf > 0) && self.bolt_target)
	{
		if (self.bolt_target.owner == self) gsf = 0;
		else self.bolt_target = find(self.bolt_target, classname, "imprisoned");
		gsf = gsf - 1;
	}

	if (!self.bolt_target)
	{
		stuffcmd(self.owner, "hud_message \"No prisoners to free\"\n");
		self.pk_explode_ammo = 0;
		self.bolt_targetTimeout = 0;	
		self.ammo_cells = 11;
	}
};

// release spell - lets archon release their own prisoners (but not other archons!)

void() archon_release =
{
#ifdef testset
bprint(" --- in archon release - at entry\n");
#endifdef
	if (!self.bolt_target) return;
	if (self.bolt_target == self) return;
	if (!self.bolt_target.owner != self) return;
#ifdef testset
bprint(" --- in archon release - at verified\n");
#endifdef

	if (self.bolt_target.classname == "imprisoned")
	{
#ifdef testset
bprint(" --- in archon release - released\n");
#endifdef
		if (self.bolt_target.enemy.flags & FL_CLIENT)
		{
			self.bolt_target.enemy.movetype = MOVETYPE_WALK;
			self.bolt_target.enemy.think = player_stand1;
			if (self.bolt_target.enemy.classname == "pk*bot") self.bolt_target.enemy.think = bot_stand1;
		}
		else if (self.bolt_target.flags & FL_MONSTER)
		{
			self.bolt_target.enemy.think = self.bolt_target.enemy.th_run;
			self.bolt_target.enemy.nextthink = time + 1;
		}
		self.bolt_target.enemy.attack_finished = 0;
		self.bolt_target.enemy.event = null_string;
		remove(self.bolt_target.enemy.bolt_target); // NOTE: may need verification in case they get hit by clg !!
		remove(self.bolt_target);
		self.archon = self.archon + self.pk_explode_ammo; // get back this many pts
	}
};

// imprison spell - freezes a player, bot or monster
//						- players are released after 40 rels - 1 complete floor color change on hub map from black to white or VV
//						- monsters stay imprisoned until they die

// makes a think ent to keep prison in effect and take points from archon for maintaining prison

void() archon_imprison =
{
	if (self.bolt_target == self) return;
	if ((self.bolt_target.flags & FL_CLIENT) || (self.bolt_target.flags & FL_MONSTER))
	{
		if (self.bolt_target.event == "imprisoned")
		{
			self.bolt_targetTimeout = 0;	
			return; // could not imprison
		}
		newmis = spawn();
		newmis.think = thing_imprisoned;
		newmis.nextthink = time + 0.1;
		newmis.owner = self;
		newmis.enemy = self.bolt_target;
		newmis.button4 = 40; // 40 rels, black to white on arc_hub floor changes
		if (self.bolt_target.flags & FL_CLIENT)
		{
			self.bolt_target.movetype = MOVETYPE_NONE;
		}
		else if (self.bolt_target.flags & FL_MONSTER)
		{
			newmis.button4 = self.bolt_target.max_health;
			if (newmis.button4 <= 0) newmis.button4 = 100;
		}
		self.bolt_target = world; // leave reticle on the imprisoned - maybe change
	}
	else
	{
		self.bolt_targetTimeout = 0;	
		return; // could not imprison
	}

	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
	self.pk_explode_ammo = 0;
	self.bolt_targetTimeout = 0;	
};

void() archon_summon =
{
	self.stack3 = monster_id(self.pk_beartrapammo, MON_FUNC_REG);
	newmis = spawn();
	setorigin(newmis, self.bolt_targetNext.origin - v_forward * 15);

	newmis.class_select = "class_monster"; // so item_call does right stuff
	item_call_save(newmis, self.stack3);

	if (self.morphy == IMP_MCHAOS) newmis.target1 = "chaos_item";

	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
};

// banish something - expensive spell

// makes things go "away" by remove fade - monsters & players are killed first, players _should_ have a respawn penalty

// IDEA: sparks / parts whilst fading

void() archon_banish =
{
	if (self.bolt_target.mask_x & MORPH_ARCHON) return;
	if (! self.bolt_target.solid) return;

//	if (self.bolt_target.flags & FL_GODMODE) return;

	if (self.bolt_target.flags & FL_CLIENT)
	{
		self.bolt_target.deathtype = "banished";
		Killed(self.bolt_target, self); // NOTE: throws viswep, pack
//		CopyToBodyQue(self.bolt_target); // cant be part of loop - it gets removed
		BodyQueAsset(self.bolt_target, world, TRUE);
		self.bolt_target.model = null_string;
		self.bolt_target.think = SUB_Null; // prevent imm. respawn
		newmis.nextthink = time + 60; // penalty for banish // ARCHON_BANISH_PENALTY
		bodyque_head.nextthink = time + 1;
		bodyque_head.think = remove_fade;
	}
	else if (self.bolt_target.flags & FL_MONSTER)
	{
		Killed(self.bolt_target, self);
		self.bolt_target.nextthink = time + 1;
		self.bolt_target.think = remove_fade;
		self.pk_explode_ammo = 100;
	}
	else
	{														// NOTE: rune should enter delayed move code
		if (self.bolt_target.flags & FL_ITEM)
		if (self.bolt_target.event != "dynamic_item")
		{
			self.bolt_target.button4 = -664; // respawn instead of remove
		}
		if (self.bolt_target.classname == "turret_base")
		{
			self.bolt_target.owner.solid = SOLID_NOT; // no touch
			self.bolt_target.owner.nextthink = time + 1;
			self.bolt_target.owner.think = remove_fade;			
		}
		if (self.bolt_target.classname == "chaos_teleport_icon")
			remove(self.bolt_target.trigger_field);

		self.bolt_target.solid = SOLID_NOT; // no touch
		self.bolt_target.nextthink = time + 1;
		self.bolt_target.think = remove_fade;
		self.pk_explode_ammo = 20;
	}

	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
	self.pk_explode_ammo = 0;
	self.bolt_targetTimeout = 0;	
};

void() archon_time_flow =
{
	if (self.pk_beartrapammo == 1)
	{
		self.AIRG_Flags = cvar("slowmo");
		if (self.AIRG_Flags == 1) return;
		self.AIRG_Flags = 1;
	}
	else if (self.pk_beartrapammo == 2)
	{
		self.AIRG_Flags = cvar("slowmo");
		if (self.AIRG_Flags == 0.5) return;
		self.AIRG_Flags = self.AIRG_Flags - 0.05;
		if (self.AIRG_Flags < 0.5) self.AIRG_Flags = 0.5;
	}
	else if (self.pk_beartrapammo == 4)
	{
		self.AIRG_Flags = cvar("slowmo");
		if (self.AIRG_Flags == 1.5) return;
		self.AIRG_Flags = self.AIRG_Flags + 0.05;
		if (self.AIRG_Flags > 1.5) self.AIRG_Flags = 1.5;
	}
	else return;

	localcmd("slowmo ");
	localcmd(ftos(self.AIRG_Flags));
	localcmd("\n");
	self.archon = self.archon - self.pk_explode_ammo;
	self.attack_finished = time + 1; //debounce
};


// setup spells

void() clear_reticle =
{
	if (self.bolt_targetNext)
	if (self.bolt_targetNext.classname == "gfx/reticle.spr")
	{
		remove(self.bolt_targetNext); // IMP: fade remove this later
		self.bolt_targetNext = world;
	}

	if (self.bolt_target)
		archon_target_clear(self.bolt_target);

	if (self.enemy)
		archon_target_clear(self.enemy);
};

void() spell_target;


// main attack


void() player_chaos_attack =
{
	local vector org;
	local float r1;
	local string sd, md;

	if (self.impulse == ALT_FIRE_IMP)
	{
		if (self.weapon != IT_AXE) // in spell casting mode
		{
			if (self.pkplus_actorammo & 2) // swap able targets - alt fire main fn in spell mode
			if (self.bolt_target)
			if (self.enemy)
			{
				self.th_missile();
				archon_target_clear(self.bolt_target);
				self.bolt_target = self.enemy;
				self.stack1 = self.stack2;
				self.bolt_target.bolt_target.scale = self.bolt_target.bolt_target.scale * 1.2;
				self.enemy = world;
				self.stack2 = null_string;
				stuffcmd(self, "hud_target1 \"");
				stuffcmd(self, self.stack1);
				stuffcmd(self, "\"\n");
				stuffcmd(self, "hud_target2 \"");
				stuffcmd(self, "\"\n");
			}
		}
		else
			chaos_beam();
		return;
	}

// fire pressed with spell selected
	if (self.weapon != IT_AXE)
	{
		if (self.pkplus_actorammo & 65536) // spell needs reset
		{
			self.attack_finished = time + 1;
			self.th_missile();
			return;
		}
		if (self.pkplus_actorammo & 2) // spell needs target
		{
			if (!self.bolt_target) return;

			if (self.bolt_target != self)
			if (self.bolt_target.bolt_target == self.bolt_target) // arc ppp protect on
				return;
		}

		if (self.pkplus_actorammo & 4) // spell needs 2nd target
		if (!self.enemy) return;

//		if ((self.ammo_nails > 3) && self.bolt_target == self) return; // cant target self w/ this spell

		self.th_melee(); // cast spell
		return;
	}

	if (self.chaosweptime < time) // pick a weapon and some time to fire it
	{
		self.chaosweptime = time + 1 + (random() * 5); // more complex later, based on level, couple a fudge vars, etc
		r1 = random();
		if (r1 < 0.17)
		{
			self.lastweapon = IT_SUPER_NAILGUN | IT_LIGHTNING;  // reflective laser
			self.chaosweptime = self.chaosweptime + random() * 25;
		}
		else if (r1 < 0.27) self.lastweapon = IT_SUPER_NAILGUN;  // laser
		else if (r1 < 0.5) self.lastweapon = IT_NAILGUN; // vary these ?...
		else if (r1 < 0.57)
		{
			self.lastweapon = IT_NAILGUN | IT_LIGHTNING; // pulse spikes
			self.chaosweptime = self.chaosweptime + random() * 25;
		}
		else if (r1 < 0.87) self.lastweapon = IT_ROCKET_LAUNCHER;
		else if (r1 < 0.92) self.lastweapon = IT_MJOLNIR;
		else self.lastweapon = IT_LIGHTNING;
//		self.delay = 3 + rint(random() * 2);
		if (random() < 0.15) self.chaosattnoise = 0;
		else self.chaosattnoise = 1;
	}



// NOTE: crap hard to do with this code
//		if (rune_haste(0.275))
//		self.attack_finished=time+0.55;

	chaos_level(-1, self); // take away 1 point of mana

//		newmis.morphy = self.morphy; // missiles should have a morphy

	if (self.lastweapon == IT_MJOLNIR) // plasma ball
	{
		X_FireOnePlasma();
		newmis.skin = rint(random() * 2);
		self.attack_finished = time + 0.15;
		chaos_level(-2, self);
	}
	if (self.lastweapon == IT_LIGHTNING)
	{
		if (self.t_width < time)
		{
			if (self.chaosattnoise) sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
			self.t_width = time + 7;//0.6;
			self.delay = self.delay + 1;
		}
		org = self.origin + '0 0 4';
		traceline (org, org + v_forward*600, TRUE, self);

		self.attack_finished = time + 0.1;
//		if (self.delay < LT_RED || self.delay > LT_BLACK) self.delay = LT_NEG; // bounds on bolt model
if (self.delay < 0 || self.delay > LT_CHAOS) self.delay = 0; // bounds on bolt model

		beam4(org, trace_endpos, self.delay);

		LightningDamage_x(FALSE, self.origin, trace_endpos + v_forward*4, self, 20);
		chaos_level(-3, self);
	}
	else if (self.lastweapon == IT_ROCKET_LAUNCHER)
	{
		self.attack_finished = time + 0.8;
		if (random() < 0.16) 
		{
			W_FireRocket();
			chaos_level(-5, self); // more expensive
		}
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
			if (self.chaosattnoise) sd ="boss1/throw.wav";//rnd_string('95.0 66.6 66.6',"weapons/grenade.wav","weapons/sgun1.wav",null_string,null_string,"boss1/throw.wav");
			fire_missile(FIREBALL_WEP_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | FLT_IMM | MLT_LAVA | FLT_LAVA | PF_LAVA | CK_EARTHQUAKE, self.origin, '0 0 0', "fireballwep", "progs/lavaball.mdl", sd, fire_fly_touch, 5 + (random() * 4), meltthink, fire_fly_adj);

			newmis.frame = floor(random() * 3);
			newmis.avelocity = '200 100 300';
			newmis.dmgtime = time + 0.2;  // release time?
			newmis.rad_time = time + 2; // content check timer
			newmis.dmg = rint(10 + (random() * 20));
			newmis.t_length = 0.2 + (random() / 2.0); // FBW_NAPALM + (random() / 2.0);
			newmis.dest_y = 16;

			self.attack_finished = time + 0.55;
			chaos_level(-2, self);
		}
	}
	else if (self.lastweapon & IT_NAILGUN) // fire some spikes
	{
//		md = rnd_string(' 66.6 66.6 66.6',"progs/s_spike.mdl",null_string,null_string,null_string,"progs/spike.mdl"); 
		if (self.chaosattnoise) sd = rnd_string('95.0 66.6 66.6',"weapons/spike2.wav","chaos/pist1.wav",null_string,null_string,"weapons/rocket1i.wav");
		if (self.lastweapon & IT_LIGHTNING)
		{
			if (sd != null_string && random() < 0.7) sd = "pulse/pulse_1.wav";
			fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + '0 0 4', '0 0 0', "pulse_spike", "progs/spike.mdl", sd, spike_touch, 2 + random() * 4, SUB_Remove, spike_touch);
			if (random() < 0.5) newmis.dmg = 16 + random() * 4;
		}
		else
			fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + '0 0 4', '0 0 0', "chaosspike", "progs/spike.mdl", sd, spike_touch, 6, SUB_Remove, spike_touch);
		RND_frame = random() * 7.4;
		RND_skin = random() * 3.4;
		if (random() < 0.6) RND_Spike();

		if (random() > 0.666) newmis.dmg = 18;
		self.attack_finished = time + 0.2;
	}
	else if (self.lastweapon & IT_SUPER_NAILGUN)
	{
		if (self.chaosattnoise) sd = rnd_string('90.0 90.0 90.0',"misc/r_tele3.wav",null_string,null_string,null_string,"enforcer/enfire.wav");
		if (self.lastweapon & IT_LIGHTNING)
		{
			if (random() < 0.5) sd = "lasercannon/laserg.wav";
			HIP_LaunchLaser(self.origin + '0 0 4', v_forward, rint(random()), sd); //gun_aim(self, v0), rint(random()), sd);
		}
		else
			fire_missile(LASERCAN_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + '0 0 4', '0 0 0', "laser", "progs/laser_m.mdl", sd, Laser_Blast, 6, SUB_Remove, Laser_Blast);
		newmis.skin = random() * 10.4;
		newmis.frame = random() * 10.4;
		newmis.effects = newmis.effects | EF_FULLBRIGHT;
		self.attack_finished = time + 0.3;
		chaos_level(-1, self);
	}
};

// clear archon target reticles

// e - entity that was targeted

void(entity e) archon_target_clear =
{
	if (!e) return;

	if (e.bolt_target)
	{
		if (e.bolt_target.classname == "gfx/reticle.spr")
		{
			remove(e.bolt_target); // IMP: fade remove this later
			e.bolt_target = world;
		}
	}
};

// think clear reticle

void() clear_target =
{
	if (self.pkplus_actorammo == -66)
	{
		if (self.owner.bolt_targetNext == self)
			self.owner.bolt_targetNext = world;
	}
	else
	if (self.owner.bolt_target == self)
		self.owner.bolt_target = world;
	remove(self); // IMP: fade remove this later
};

// clear all spell parms

void() clear_spell =
{
	clear_reticle();

	self.enemy = self.bolt_target = world;
	if (self.pk_explode_ammo > 0) self.pk_explode_ammo = -6; // send cancel code to HUD
	else self.pk_explode_ammo = 0; // a 2nd clear will zero the cancel message
/*
		stuffcmd(self, "infobar 5 \"Spell canceled\"\n");
	else
		stuffcmd(self, "infobar 0 \"\"\n");
	self.pk_explode_ammo = 0;
*/
	self.bolt_targetTimeout = 0;
	self.pkplus_actorammo = 65536; // if a spell is active it needs reset
	self.th_melee = SUB_Null;
	self.stack1 = self.stack2 = null_string;
	stuffcmd(self, "hud_target1 \"");
	stuffcmd(self, "\"\n");
	stuffcmd(self, "hud_target2 \"");
	stuffcmd(self, "\"\n");
	self.mcode = -666; // archon casting spell
};


// 65536 - spell reset req.

void() spell_target =
{
	self.pk_explode_ammo = 0;
	self.pkplus_actorammo = 0;
	self.cnt = self.pkplus_actorammo & 2; // reticle controls
	if (self.weapon == IT_SHOTGUN)
	{
		if (!self.ammo_shells) self.ammo_shells = 3; // teleport
		if (self.ammo_shells == 3) { self.pk_explode_ammo = 15; self.pkplus_actorammo = 3; self.th_melee = uni_teleport; }
		else if (self.ammo_shells == 5) { self.pk_explode_ammo = 30; self.pkplus_actorammo = 7; self.th_melee = multi_teleport; }
		else if (self.ammo_shells == 7)
		{
			self.pk_explode_ammo = 5;
			self.pkplus_actorammo = 1;
			self.th_melee = uni_teleport;
			self.bolt_target = self;
		}
		else if (self.ammo_shells == 11)
		{
			self.pk_explode_ammo = 20;
			self.pkplus_actorammo = 1;
			self.th_melee = set_beacon;
 			if (self.goalentity)
			if (self.goalentity.classname == "beacon") // beacon has been set
			{
				self.pk_explode_ammo = 5;
				self.pkplus_actorammo = 0;
				self.th_melee = uni_teleport;
				self.bolt_target = self.goalentity;
			}
		}
	}
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		if (!self.ammo_nails) self.ammo_nails = 3;
		if (self.ammo_nails == 3) { self.pk_explode_ammo = 24; self.pkplus_actorammo = 0; self.th_melee = poly_init; self.bolt_target = self; }
		if (self.ammo_nails == 5) { self.pk_explode_ammo = 24; self.pkplus_actorammo = 3; self.th_melee = poly_init; if (self.bolt_target == self) self.bolt_target = world; }
		if (self.ammo_nails == 7) { self.pk_explode_ammo = 30; self.pkplus_actorammo = 19; self.th_melee = poly_monster; if (self.bolt_target == self) self.bolt_target = world; } // repeat last monster poly
		if (self.ammo_nails == 11) { self.pk_explode_ammo = 10; self.pkplus_actorammo = 0; self.th_melee = transmogrify; if (self.pk_beartrapammo == 0 || random() < 0.7) self.pk_beartrapammo = rnd_bit_mask(1023); }
	}
	if (self.weapon == IT_NAILGUN)
	{
		if (!self.ammo_rockets) self.ammo_rockets = 3;
		if (self.ammo_rockets == 3) { self.pk_explode_ammo = 20; self.pkplus_actorammo = 0; self.th_melee = rune_powers; }
		if (self.ammo_rockets == 5) { self.pk_explode_ammo = 500; self.pkplus_actorammo = 1; self.th_melee = archon_gwell; }
		if (self.ammo_rockets == 7) { self.pk_explode_ammo = 5; self.pkplus_actorammo = 35; self.th_melee = monster_speed; if (self.bolt_target == self) self.bolt_target = world; }
	}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (!self.ammo_bullet) self.ammo_bullet = 3;
		if (self.ammo_bullet == 3) { self.pk_explode_ammo = 500; self.pkplus_actorammo = 1; self.th_melee = archon_makepp; }
		if (self.ammo_bullet == 5) { self.pk_explode_ammo = 50; self.pkplus_actorammo = 1; self.th_melee = archon_maketele; }
		if (self.ammo_bullet == 7) { self.pk_explode_ammo = 10; self.pkplus_actorammo = 1; self.th_melee = archon_makeit; }
		if (self.ammo_bullet == 11) { self.pk_explode_ammo = 10; self.pkplus_actorammo = 1; self.th_melee = archon_makeit; }
	}
	if (self.weapon == IT_LIGHTNING)
	{
		if (self.bolt_target == self) self.bolt_target = world;
		if (!self.ammo_cells) self.ammo_cells = 3;
		if (self.ammo_cells == 3) { self.pk_explode_ammo = 20; self.pkplus_actorammo = 3; self.th_melee = archon_heal; }
		if (self.ammo_cells == 5) { self.pk_explode_ammo = 100; self.pkplus_actorammo = 43; self.th_melee = archon_imprison; }
		if (self.ammo_cells == 7) { self.pk_explode_ammo = 50; self.pkplus_actorammo = 0; self.th_melee = archon_release; self.bolt_target = world; next_imprisoned(); }
		if (self.ammo_cells == 11) { self.pk_explode_ammo = 50; self.pkplus_actorammo = 1; self.th_melee = archon_summon; }
		if (self.ammo_cells == 13) { self.pk_explode_ammo = 500; self.pkplus_actorammo = 3; self.th_melee = archon_banish; }
		if (self.ammo_cells == 17) { self.pk_explode_ammo = 100; self.pkplus_actorammo = 0; self.th_melee = archon_time_flow; }
	}

	if (self.pkplus_actorammo == 0) // changed - remove existing reitcles
		clear_reticle();
	self.bolt_targetTimeout = time + 30;
	self.mcode = -666; // archon casting spell
	self.th_missile = spell_target;
};

// pkplus_actorammo - targeting for server & HUD
// 		0 - no reticles or targets - spell just fires
//			1 - free roaming reticle
//			2 - target(s) needed on this spell
//				- if bit 2 is set, normal targeting will occur - this will always show potential alternates
//			4 - spell uses 2 targets - for HUD to display both
//			8 - spell target must be a player / bot
//		 16 - spell can NOT be a client / bot
//		 32 - spell target must be a monster

// self is archon, sets .bolt_target if world, if not sets potential new target in .enemy

void() archon_target =
{
	local float f;

	if (self.bolt_target != self) // Archons can teleport self
	if (self.bolt_target) setorigin(self.bolt_target.bolt_target, self.bolt_target.origin + self.bolt_target.bolt_target.view_ofs);
	if (self.enemy) setorigin(self.enemy.bolt_target, self.enemy.origin + self.enemy.bolt_target.view_ofs);

// 3000 - traceline targeting range
	traceline(self.origin + self.view_ofs, self.origin + self.view_ofs + v_forward * 3000, FALSE, self);

   norm = trace_plane_normal;
   norm_x = 0 - norm_x;
   norm_y = 0 - norm_y;

// run a free roaming reticle - not tied to a specific target
	if (self.pkplus_actorammo & 1)
	if (!self.bolt_targetNext)
	{
		self.bolt_targetNext = spawn();
		self.bolt_targetNext.classname = "gfx/reticle.spr";
		if (self.morphy == IMP_MORDER)
			self.bolt_targetNext.mdl = "gfx/reticle2.spr";
		else
			self.bolt_targetNext.mdl = "gfx/reticle.spr";
		self.bolt_targetNext.nextthink = time + 31;
		self.bolt_targetNext.pkplus_actorammo = -66;
		self.bolt_targetNext.think = clear_target;
		setmodel(self.bolt_targetNext, self.bolt_targetNext.mdl);
		self.bolt_targetNext.scale = 0.4;
		self.bolt_targetNext.owner = self;
		self.bolt_targetNext.movetype = MOVETYPE_FLY;
	}

	if (self.bolt_targetNext)
	if (self.bolt_targetNext.classname == "gfx/reticle.spr")
	{
		setorigin(self.bolt_targetNext, trace_endpos -  (v_forward * 6));

// set facing on roaming reticle
		self.bolt_targetNext.mangle = vectoangles( norm );

		if (self.bolt_targetNext.angles_x != self.bolt_targetNext.mangle_x) self.bolt_targetNext.angles = self.bolt_targetNext.mangle;
		
		if (!self.bolt_targetNext.angles_x)
		if (self.bolt_targetNext.angles_y != self.bolt_targetNext.mangle_y) self.bolt_targetNext.angles = self.bolt_targetNext.mangle;

		self.bolt_targetNext.avelocity = v0;
		if (self.bolt_targetNext.angles_x == 90 || self.bolt_targetNext.angles_x == 270)
			self.bolt_targetNext.avelocity_y = 40;
		else if (self.bolt_targetNext.angles_x == 0)
			self.bolt_targetNext.avelocity_z = -40;
	}

	if (! self.pkplus_actorammo & 2) return; // no target aligned reticles needed

// no target on traceline, look for ents the hard way
	if (!trace_ent)
	{
		f = 3000;
		gsf = 100;
		newmis = world;
		trace_ent = findradius(trace_endpos, 128);
		while (trace_ent && (gsf > 0))
		{
			if (vlen(trace_ent.origin - trace_endpos) < f)
			{
				newmis = trace_ent;
				f = vlen(trace_ent.origin - trace_endpos);
			}
			trace_ent = trace_ent.chain;
			gsf = gsf - 1;
		}
		if (!newmis) return;// none shall pass
		trace_ent = newmis;
	}

// things we should not target
	if (! trace_ent.flags & (FL_CLIENT | FL_MONSTER | FL_ITEM))
	{
		if (trace_ent.map == "nonmove") return; // 7.22.13 - func_models we should not suck
		if (trace_ent.classname == OBSERVER) return;

		if (trace_ent.movetype == MOVETYPE_NONE) return;
		if (trace_ent.movetype == MOVETYPE_PUSH) return;
		if (trace_ent.movetype == MOVETYPE_NOCLIP) return;
	}

	if (self.pkplus_actorammo & 16)
	if (trace_ent.flags & FL_CLIENT) return;

	if ((self.pkplus_actorammo & 40) == 40) // test for both due to mutual exclusivity of next 2 test
	{
		if (! trace_ent.flags & 40) return;
	}
	else
	{
		if (self.pkplus_actorammo & FL_CLIENT)
		if (! trace_ent.flags & FL_CLIENT) return;

		if (self.pkplus_actorammo & FL_MONSTER)
		if (! trace_ent.flags & FL_MONSTER) return;
	}

	if (trace_ent.classname == "turret") // target the turrets base so it can be moved - note other spells will be diff
	if (trace_ent.turret_base)
	if (trace_ent.turret_base.classname == "turret_base")
		trace_ent = trace_ent.turret_base;

// already targeted, power point protection or in a clg bolt loop
/// *** an archon with a primary target will not be targetable!
	if (trace_ent.bolt_target) return;

// already acquired - ignore
	if (self.bolt_target == trace_ent) return;
	if (self.enemy == trace_ent) return;

	self.bolt_targetTimeout = time + 30;

// setup new target reticle
	trace_ent.bolt_target = spawn();
	trace_ent.bolt_target.classname = "gfx/reticle.spr";
	trace_ent.bolt_target.nextthink = time + 31;
	trace_ent.bolt_target.think = clear_target;
	trace_ent.bolt_target.owner = trace_ent;
	trace_ent.bolt_target.goalentity = self; // for remote clears
	trace_ent.bolt_target.movetype = MOVETYPE_FLY;

// because bottom point of ammo boxes is mostly on ground - can submerge reticle
	trace_ent.bolt_target.view_ofs = v0;

	if (!trace_ent.mins) // center ammo boxes with odd co-ords -- not always perfect align because boxes are offset in bounding boxes!
	{
		trace_ent.bolt_target.view_ofs_x = trace_ent.maxs_x / 2;
		trace_ent.bolt_target.view_ofs_y = trace_ent.maxs_y / 2;
		trace_ent.bolt_target.view_ofs_z = 7;
	}

   trace_ent.bolt_target.angles = vectoangles( norm );

	if (trace_ent.bolt_target.angles_x == 90 || trace_ent.bolt_target.angles_x == 270)
		trace_ent.bolt_target.avelocity_y = 20;
	else if (trace_ent.bolt_target.angles_x == 0)
		trace_ent.bolt_target.avelocity_z = -20;

	setorigin(trace_ent.bolt_target, trace_ent.origin + trace_ent.bolt_target.view_ofs);
//	setmodel(trace_ent.bolt_target, "progs/reticle.mdl");
	if (self.morphy == IMP_MORDER)
		trace_ent.bolt_target.mdl = "gfx/reticle2.spr";
	else
		trace_ent.bolt_target.mdl = "gfx/reticle.spr";
	setmodel(trace_ent.bolt_target, trace_ent.bolt_target.mdl);
	if (trace_ent.flags & FL_ITEM)
		trace_ent.bolt_target.scale = 0.7;

//	trace_ent.effects = EF_BRIGHTLIGHT; // IMP: poss HUD info
	
// first / main target

	if (!self.bolt_target)
	{
		self.bolt_target = trace_ent;
		archon_target_clear(self.enemy);
		self.stack1 = "Acquired 1";
		if (trace_ent.netname) self.stack1 = trace_ent.netname;
		self.enemy = world;
		self.stack2 = null_string;
		stuffcmd(self, "hud_target1 \"");
		stuffcmd(self, self.stack1);
		stuffcmd(self, "\"\n");
		stuffcmd(self, "hud_target2 \"");
		stuffcmd(self, "\"\n");
		return;
	}

// secondary - selected as main with ALT_FIRE

	archon_target_clear(self.enemy);
	self.enemy = trace_ent;
	trace_ent.bolt_target.scale = trace_ent.bolt_target.scale * 0.8;
	self.stack2 = "Acquired 2";
	if (trace_ent.netname) self.stack2 = trace_ent.netname;
	stuffcmd(self, "hud_target2 \"");
	stuffcmd(self, self.stack2);
	stuffcmd(self, "\"\n");
};

/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/
void(float msk) aux_bits =
{
	local float f;
	self.pk_beartrapammo = self.pk_beartrapammo * 2;
	self.pk_beartrapammo = morph_selinc(self.pk_beartrapammo);

	gsf = 64; // only 24 bits to test in one float, but he must complete 1 loop

	while (gsf > 0)
	{
		f = 0;
		while (!f && gsf > 0)
		{
			f = msk & self.pk_beartrapammo;
			if (!f) self.pk_beartrapammo = self.pk_beartrapammo * 2;
			self.pk_beartrapammo = morph_selinc(self.pk_beartrapammo);
			gsf = gsf - 1;
		}

		if (!f)
			gsf = 0;
		else
			self.pk_beartrapammo = f;
	}
};

void() player_chaos_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

//	morph_impulse();

	if (self.aflag & 16) // no morph during star bursts
	{
		self.items = self.items - (self.items & IT_SUPER_SHOTGUN);
	}
	else
		self.items = self.items | IT_SUPER_SHOTGUN;	

	if (self.impulse == 1)
		self.weapon = IT_AXE;
	else if (self.impulse == 10)
		morph_CycleWeaponCommand(1);
	else if (self.impulse == 12)
		morph_CycleWeaponCommand(-1);
	else if (self.impulse == 14) // slot loops
	{
		if (self.weapon == IT_SHOTGUN) self.impulse = 2;
		if (self.weapon == IT_SUPER_SHOTGUN) self.impulse = 3;
		if (self.weapon == IT_NAILGUN) self.impulse = 4;
		if (self.weapon == IT_SUPER_NAILGUN) self.impulse = 5;
		if (self.weapon == IT_LIGHTNING) self.impulse = 8;
	}
	else if (self.impulse == 16) // aux spell loops
	{
		if (self.weapon == IT_SUPER_SHOTGUN)
		{
			if (self.ammo_nails == 5) aux_bits(421887); // monster set
			else if (self.ammo_nails == 7) aux_bits(421887); // monster set
			else if (self.ammo_nails == 11) aux_bits(1023);
		}
		if (self.weapon == IT_NAILGUN)
		{
			if (self.rune_flag) self.AIRG_Flags = 4194375;
			else self.AIRG_Flags = 71;
			if (self.ammo_rockets == 3) aux_bits(self.AIRG_Flags);
			if (self.ammo_rockets == 7) aux_bits(3);
		}
		if (self.weapon == IT_SUPER_NAILGUN)
		{
			if (self.ammo_bullet == 7) aux_bits(6377471);
			if (self.ammo_bullet == 11) aux_bits(196480);
		}
		if (self.weapon == IT_LIGHTNING)
		{
			if (self.ammo_cells == 3) aux_bits(3);
//			if (self.ammo_cells == 5) aux_bits(3);
			if (self.ammo_cells == 7) { self.bolt_target = world; next_imprisoned(); }
			if (self.ammo_cells == 11) aux_bits(421887); // monster set
			if (self.ammo_cells == 17) aux_bits(7);
		}
	}

	if (self.weapon == IT_AXE)
	{
//		sprint(self, "Chaos firing random bolts\n");
		clear_spell(); // timeout any spell in selection
	}


	if (self.impulse == 2) // spell list 1 - teleports
	{
		if (self.weapon == IT_SHOTGUN) // loop thru spell set
		{
			if (self.ammo_shells == 3) self.ammo_shells = 5; // tele swap
			else if (self.ammo_shells == 5) self.ammo_shells = 7;
			else if (self.ammo_shells == 7) self.ammo_shells = 11;
			else if (self.ammo_shells == 11) self.ammo_shells = 3;
		}
		self.weapon = IT_SHOTGUN;
	}
	if (self.impulse == 3) // spell list 2 - polymorph, transmogrify
	{
		if (self.weapon == IT_SUPER_SHOTGUN) // loop thru spell set
		{
			if (self.ammo_nails == 3) self.ammo_nails = 5;
			else if (self.ammo_nails == 5) self.ammo_nails = 7;
			else if (self.ammo_nails == 7) self.ammo_nails = 11;
//			else if (self.ammo_nails == 11) self.ammo_nails = 13;
//			else if (self.ammo_nails == 13) self.ammo_nails = 17;
//			else if (self.ammo_nails == 17) self.ammo_nails = 19;
//			else if (self.ammo_nails == 19) self.ammo_nails = 23;
//			else if (self.ammo_nails == 23) self.ammo_nails = 29;
			else if (self.ammo_nails == 11) self.ammo_nails = 3;

			if (self.ammo_nails == 11)
			{
				if (! self.pk_beartrapammo & 1023) self.pk_beartrapammo = 1;
			}
			else
				if (! self.pk_beartrapammo & 421887) self.pk_beartrapammo = 1;
		}
		self.weapon = IT_SUPER_SHOTGUN;
	}
	if (self.impulse == 4) // spell list 3
	{
		if (self.weapon == IT_NAILGUN) // loop thru spell set
		{
			if (self.ammo_rockets == 3) self.ammo_rockets = 5;
			else if (self.ammo_rockets == 5) self.ammo_rockets = 7;
			else if (self.ammo_rockets == 7) self.ammo_rockets = 3;

			if (self.ammo_rockets == 7)
			{
				if (! self.pk_beartrapammo & 3) self.pk_beartrapammo = 1;
			}
			else
				if (! self.pk_beartrapammo & 71) self.pk_beartrapammo = 1;
		}
//		if ((self.archon < 1500) && self.ammo_rockets == 3) self.ammo_rockets = 5;
		self.weapon = IT_NAILGUN;
	}
	if (self.impulse == 5) // spell list 4 - create
	{
		if (self.weapon == IT_SUPER_NAILGUN) // loop thru spell set
		{
			if (self.ammo_bullet == 3) self.ammo_bullet = 5;
			else if (self.ammo_bullet == 5) self.ammo_bullet = 7;
			else if (self.ammo_bullet == 7) self.ammo_bullet = 11;
			else if (self.ammo_bullet == 11) self.ammo_bullet = 3;

			if (self.ammo_bullet == 7)
			{
				if (! self.pk_beartrapammo & 6377471) self.pk_beartrapammo = 1;
			}
			if (self.ammo_bullet == 11)
			{
				if (! self.pk_beartrapammo & 196480) self.pk_beartrapammo = 1;
			}
		}
		self.weapon = IT_SUPER_NAILGUN;
	}
	if (self.impulse == 8) // spell list - archon legacy
	{
		if (self.weapon == IT_LIGHTNING) // loop thru spell set
		{
			if (self.ammo_cells == 3) self.ammo_cells = 5;
			else if (self.ammo_cells == 5) self.ammo_cells = 7;
			else if (self.ammo_cells == 7) self.ammo_cells = 11;
			else if (self.ammo_cells == 11) self.ammo_cells = 13;
			else if (self.ammo_cells == 13) self.ammo_cells = 17;
			else if (self.ammo_cells == 17) self.ammo_cells = 3;

			if (self.ammo_cells == 3)
			{
				if (! self.pk_beartrapammo & 3) self.pk_beartrapammo = 1;
			}
			else if (self.ammo_cells == 11)
			{
				if (! self.pk_beartrapammo & 421887) self.pk_beartrapammo = 1;
			}
			else if (self.ammo_cells == 17)
			{
				if (! self.pk_beartrapammo & 7) self.pk_beartrapammo = 1;
			}
		}
		self.weapon = IT_LIGHTNING;
	}
	else if (self.impulse == IMP_MSIGHT)
		morph_sound(2, self.msight, 3);							// let player morphs "talk"

	if (self.weapon != IT_AXE)
		spell_target(); // turn on targeter
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
	return(rnd_string(' 60.0 50.0 40.0'," transcended reality with ",null_string," danced the hot plasma boogie with "," was touched by the hand of "," felt the wrath of Chaos Lord "));
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

void() player_chaos_become = 
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

	if (self.pkplus_tombammo == CFCBALL) // this doesnt seem to do anything - check mkI
	{
		self.pkplus_tombammo = 0;
		tc = FL_CBALL;
	}
	else
		tc = FL_SPIKE;

	if (self.height != IMP_MCHAOS) self.state = self.height; // save previous form for de-archon
	self.height = IMP_MCHAOS;

	chaos_form(tc);

	self.cam_z = 10 / 100;
	self.cam_y = 36;

	stuffcmd(self, "exec cfg/morph/m-chaos.cfg\n");

	self.builtin = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_LIGHTNING;
	self.items = self.builtin; // Archons shouldnt have any other items
	self.weapon = IT_AXE;
	self.pk_currentitem = PK_IT_AXE;
// spell init - done in target
	self.ammo_shells = 7;
	self.ammo_nails = 3;
	self.ammo_rockets = 3;
	self.ammo_cells = 3;
	self.ammo_bullet = 3;
	if (!self.pk_beartrapammo) self.pk_beartrapammo = 1;

	self.pk_explode_ammo = 0; // spell cost
	self.th_missile = SUB_Null; // spell target
	clear_spell();

	self.msight = null_string;
	self.noise2 = "boss2/idle.wav";
	self.noise3 = null_string;
	self.movetype = MOVETYPE_FLY;
	self.aflag = 0; // chaos form states
	self.view_ofs = '0 0 4';

	self.health = 100 * MCHAOS_HEALMOD + 10 * crandom() * 3.14159265;
	self.health_modifier = MCHAOS_HEALMOD;

	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!MAX_CHAOS_LVL) chaos_constant(0);

	self.skin = 1;
};






