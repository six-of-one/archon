/* ::-::
 *
 * Cataboligne
 *
 * file: archon.qc
 *
 * date: 9/29/13
 *
 * qc - support chaos mod archon being and powers
 *
 */

/*
Archon: the power

Notes:
In the original archon and adept power points did several things.
They could heal icons, protect against magic attack and in adept, increase the master power level.

The beauty of the new model design - it is from an M.C. Escher print...the one used for archon I box art.  And it was hard to make.
The eponimus power points will provide archon power, heal, protect against Archon spells and on the hub map, generate the items.


"the Story"

The power of the Archons comes from a quantum universe hidden all around us...
No one knows who made the complex 4D construct, but they were made for Archons to use.

The mathematically twisted power access device transferes that power to living beings.

*/

 // return an archon to its previous form, previous morph or human state if archon power is ever < 0

// fn(de_archon_thk) - keep checking to see when an Archon has enough power to return to archon form, return is automatic

void() de_archon_thk =
{
	self.lefty = 2000;
	if (self.owner.height == IMP_MCHAOS) self.lefty = CHAOS_BEAM_MIN;
	if (self.owner.archon > self.lefty)
	{
		newmis = self;
		self = self.owner;
		if (self.goalentity == newmis) self.goalentity = world;
		polymorph_check(self.height, 0);
		self.archon = self.archon - (newmis.lefty * 0.25);
		remove(newmis);
	}
	else
	if (self.owner.disconnectPlayer)
		remove(self);
	else
		self.nextthink = time + 10;
};

// lost power - no longer a god among mortals - he can be  hurt, even killed now

void(entity e) de_archon =
{
	local entity f;

	f = self;
	self = e;

	if (self.state == 0) self.state = IMP_MHUMAN;
	if (self.state == IMP_MCHAOS) self.state = IMP_MHUMAN;
	else if (self.state == IMP_MORDER) self.state = IMP_MHUMAN;
	polymorph_check(self.state, 0);

	if (self.state == self.morphy) self.rune_flag = 0; // clear rune powers spells
// idea - clear reticles

	self.goalentity = chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, 10, de_archon_thk, SUB_Null, self, world);
	self = f;
};

// archon_ppp_thk - portable power point think

void() archon_ppp_thk =
{
	if (self.netname == "Portable power point")
	{
		newmis = spawn();
		newmis.classname = "archon_power_act"; // protect from archon magic targeting system
		newmis.think = archon_ppp_thk;
		newmis.nextthink = time + 1;
		newmis.owner = other;
		return;
	}

	self.aflag = 0;
	if (! self.owner.x_items & X_PP) self.aflag = 1;
	if (self.owner.mask_x & MORPH_ARCHON) self.aflag = 1;
	if (self.owner.solid == SOLID_NOT) self.aflag = 1;

	if (self.aflag)
	{
		self.owner.x_items = self.owner.x_items - (self.owner.x_items & X_PP);
		remove(self);
		return;
	}

	if (! self.owner.bolt_conduitTimeout)
	{
		archon_target_clear(self.owner.bolt_target.goalentity);
		self.owner.bolt_target = self; // not a clg target - protect it
		self.owner.bolt_targetTimeout = time + 9;
	}
	self.owner.archon = self.owner.archon + 9;// ARCHON_PPP; // portable power point

	self.nextthink = time + 3;
};

// archon altar - map item - converts xp to archon pts

void() altar_touch =
{
	if (self.attack_finished > time) return;
	self.attack_finished = time + self.delay;

	if (other.xp > self.aflag)
	{
		other.archon = other.archon + 1;
		other.xp = other.xp - self.aflag;
		if (random() < 0.002) sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

 		if (self.goalentity) // made by an Archon, he gets some every usage
		{
			if (self.goalentity == other) return; // this might be a redundant check, as Archons cant touch altars
			self.goalentity.archon = self.goalentity.archon + 0.1;
		}
	}

	if (time > 240) self.aflag = 64;
	else if (time > 180) self.aflag = 32;
	else if (time > 120) self.aflag = 16;
	else if (time > 60) self.aflag = 8;
	else if (time > 30) self.aflag = 4;
	else if (time > 10) self.aflag = 2;
};

void() archon_altar =
{
	self.netname = "\bArchon Altar\b";
	if (!self.model)
	{
		setmodel (self,"progs/flag.mdl");
		if (!self.skin) self.skin = rint(2.7 + random());
	}
	else
	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);

	if (!self.noise) self.noise = "items/r_item2.wav";

	self.mask_x = MORPH_ALL;
	self.class_select = "chaos_item";
	self.touch = altar_touch;

	if (!self.aflag) self.aflag = 1; // conversion ratio
	if (!self.delay) self.delay = 0.125; // allow retouch every

	StartItem ();
};

// archon nodule - map item - gives archon pts

void() archon_nodule =
{
	if (!self.netname) self.netname = "Nodule";
	if (!self.model) setmodel (self,"progs/nodule1.mdl");
	if (!self.noise) self.noise = "items/r_item2.wav";
	if (!self.archon) self.archon = 20 + crandom() * 5;

	setmodel (self, self.model);
	setsize (self,'-8 -8 -8','8 8 8');
	self.mins_z = self.mins_z - floor(random() * 4) * 4;
	self.mask_x = MORPH_ALL + MORPH_ARCHON;
	self.class_select = "x_item";
	self.touch = x_item_touch;

	StartItem ();
};


void() archon_ppp =
{
	archon_nodule(); // made from a nodule

	if (random() < 0.3) self.modelflags = self.modelflags | 128; // purple light

	self.netname = "Portable power point";
	self.mask_x = MORPH_ALL;
	setmodel (self,"progs/arc_pp.bsp");
	self.scale = 0.2;
	self.x_items = X_PP;
};

// random nodule maker

// also randomly makes collectable portable power points

entity altar; // altar for archon pts

void() archon_nodule_rnd =
{
	archon_nodule();
	self.mins_z = self.mins_z - floor(random() * 6) * 4;

// some random rotation
	if (!self.modelflags)
	if (random() < 0.3) self.modelflags = 8;

	gsf = rint(random() * 6);

// try to create an altar every time we make a nodule
#ifdef testset
	if ((time > 10) && !altar) // TEST--
#else
	if ((time > 30) && (random() < 0.05) && !altar) // random altar - only one on smaller maps
#endifdef
	{
		altar = self;
		self.model = null_string;
		self.modelflags = 0;

		archon_altar();
//		setsize (self,'-16 -16 -24','16 16 16');
		self.angles_y = random() * 360; // random facing for flag - may change for other models
		self.effects = EF_BRIGHTFIELD; 
		self.button13 = -666; // tell dyn_rem to relocate this guy
		self.wait = 240; // long time to relocation cycle
		bprint("***  the \bArchon Altar\b has spawned \b!\n");
	}

#ifdef testset
	else if ((time > 60) && !god_particle) // TEST--
#else
	else if ((time > 240) && (random() < 0.02) && !god_particle) // god particle - only one
#endifdef
	{
		god_particle = self;
		self.netname = "\bGod Particle\b";
		setmodel (self,"progs/nodule110110110.bsp");
//		setsize (self,'-16 -16 -24','16 16 16');
		self.scale = 0.6;
		self.modelflags = self.modelflags | 1; // rocket light
		self.archon = 4500 + crandom() * 500;	// almost an archon
		self.alpha = 0.4 + random() * 0.4;
		self.button13 = -666; // tell dyn_rem to relocate this guy till touched
		bprint("***  the \bGOD Particle\b has spawned \b!\n");
	}
	else
	if (gsf > 4) // 5,6
	{
		setmodel (self,"progs/nodule11.mdl");
		if (time > 180) self.archon = 120 + crandom() * 40;
//		if ((time > 160) && random() > 0.5)
//		{
			setmodel (self,"progs/nodule011.bsp");
			self.scale = 0.5;
			self.archon = 180 + crandom() * 80;
//		}
		if (random() < 0.3) self.modelflags = self.modelflags | 128; // purple light

// the portable comes with the most valuable 011 nodule
#ifdef testset
		if ((time > 60) && random() < 0.1) // TEST--
#else
		if ((time > 60) && random() < 0.03)
#endifdef
		{
			self.netname = "Portable power point";
			self.mask_x = MORPH_ALL;
			setmodel (self,"progs/arc_pp.bsp");
			self.scale = 0.2;
			self.x_items = X_PP;
		}
	}
	else 
	if (gsf < 3) // 0, 1, 2
	{
		setmodel (self,"progs/nodule10.mdl");
		if (time > 120) self.archon = 50 + crandom() * 25;
//		if ((time > 120) && random() > 0.5)
//		{
			setmodel (self,"progs/nodule010.bsp");
			self.scale = 0.5;
			self.archon = 80 + crandom() * 40;
//		}
	}
	else // 3, 4
	{
//		if ((time > 60) && random() > 0.5)
//		{
			setmodel (self,"progs/nodule001.bsp");
			self.scale = 0.5;
			self.archon = 30 + crandom() * 10;
//		}		
	}
	setsize (self,'-16 -16 -24','16 16 24');

	if (self != god_particle)
	if (random() < 0.4)
	{
		gsf = floor(random() * 5);
		if (gsf == 1) self.noise = "items/r_item1.wav";
		else if (gsf == 2) self.noise = "items/health1.wav"; // 25 q health
		else if (gsf == 3) self.noise = "misc/runekey.wav";
		else if (gsf == 4) self.noise = "misc/basekey.wav";
		else if (gsf == 5) self.noise = "misc/medkey.wav";
	}
};


// archon varmpire power & other power drains

// spawnflags & 1 - no test for end of vampire, just take pts

// .archon - pts to take every rel
// .owner - give pts to this ent
// .enemy - take pts from this ent

void() archon_drain_thk =
{
	self.aflag = 0;
	if (self.count <= 0) self.aflag = 1;
	if (self.enemy.archon <= 0) self.aflag = 1;
	if (self.enemy.solid == SOLID_NOT) self.aflag = 1;
	if (self.enemy.takedamage == DAMAGE_NO) self.aflag = 1;

	if (self.spawnflags & 1) // for vampire
	{
		if (self.enemy.bolt_target) self.aflag = 1;
		if (!((self.enemy.rune_flag & RUNE_FLG_RS) && (self.enemy.mask_x & MORPH_ARCHON))) self.aflag = 1;
		if (! self.owner.rune_flag & RUNE_VAMPIRE) self.aflag = 1;

		if (self.aflag)
		{
			stuffcmd(self.owner, "hud_vampire_target \"");
			stuffcmd(self.owner, "\"\n");
			remove(self);
			return;
		}
	}

	if (self.aflag)
	{
		if (self._alt_fire) self._alt_fire(self.enemy); // special cases
		remove(self);
		return;
	}

	self.nextthink = time + self.wait;

	self.owner.archon = self.owner.archon + self.archon;
	self.enemy.archon = self.enemy.archon - self.archon;
	self.count = self.count - self.archon;
};

// power drain - take ents archon pts

void(entity e) power_drain =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.enemy = e;
	newmis.think = archon_drain_thk;
	newmis.nextthink = time + 1;

	newmis.wait = 1;
	newmis.lefty = 0.2 + random() * 0.4; // percent to drain this time
	newmis.count = e.archon * newmis.lefty;
	newmis.archon = 1 + random() * 5; // points drained per sec
	newmis.netname = e.netname;
	if (newmis.netname == null_string) newmis.netname = "Unknown target";
};

// teleport to random selected location via beacon code

void() uni_teleport;

void(entity e) archon_bouncer =
{
	trace_ent = self;
	self = e;
	self.bolt_target = newmis = spawn();
	newmis.classname = "beacon";

	newmis.angles_x = 270; // stuck straight into ground
	newmis.goalentity = find_tdest(0, null_string);
	newmis.origin = newmis.goalentity.origin;
	if (newmis.goalentity.flags & FL_ITEM) newmis.origin_z = newmis.origin_z + 24;
	newmis.think = SUB_Remove;
	self.AIRG_Timeout = 0;
	uni_teleport();
	self = trace_ent;
};
// archon arena block think ops

void() th_arcarn =
{
	local float f;

	self.nextthink = time + self.wait + self.cnt * random();

	if (self.alpha == 0)
	{
		v1_x = self.distance * random();
		v1_y = self.distance * random();
		if (self.lip)
		if (random() < self.lip)
			v1_z = self.oldorigin_z + crandom() * self.height;

		setorigin(self, self.oldorigin + v1);
		setmodel(self, self.mdl);
		self.nextthink = time + 0.1 + 0.2 * random();
		self.aflag = 0.1;
	}
	if (self.alpha < 1)
	{
		self.alpha = self.alpha + self.aflag;
		self.nextthink = time + 0.1 + 0.2 * random();

		if (self.alpha > 0.6 && self.aflag == 0.1)
		{
			self.solid = SOLID_BSP;
			if (self.flags)
			if (random() < 0.33)
			{
				self.effects = rnd_bit_mask(self.flags);
			}
		}
		else if (self.alpha < 0.6 && self.aflag == -0.1)
		{
			self.solid = SOLID_NOT;
			self.effects = 0;
		}

		if (self.alpha > 1)
		{
			self.nextthink = time + self.delay + self.count * random();
			if (random() < self.style) 
				self.nextthink = time + (self.delay / 0.6) + (self.count / 0.5) * random();
			self.alpha = 1;
		}
		else if (self.alpha < 0.05)
		{
			f = 0;
			if (self.lefty)
			if (random() < 0.1)
				f = self.lefty;
			self.nextthink = time + self.wait + self.cnt * random() + f;
			self.alpha = 0;
			self.model = null_string;
			self.solid = 0;
		}
	}
	else
	{
		self.nextthink = time + 0.1 + 0.2 * random();
		self.aflag = -0.1;		
		self.alpha = self.alpha + self.aflag;
	}
	
};


// func_arcarn - archon arena blocks

// mdl = model to use
// following all have defaults (*)
// distance (64) - randomizing dist around center
// height (32) - possible height randomizer
// lip (0.25) - chance of variable height

// wait (20) - time to appear
// cnt (30) - randomizer on appear time
// lefty (rnd) - start time pause, random pauses

// delay (30) - time to hang
// count (40) - randomizer on hang time
// style (0) - chance of very short hangs

// flags (12) - bit map of allowed effects - EF_*

void() func_arcarn =
{
	local float f;

	if (!DARKPLACES)
	{
		precache_model("maps/aarn1.bsp");
		precache_model("maps/aarn2.bsp");
		precache_model("maps/aarn3.bsp");
	}

	f = random();
	if (self.mdl == null_string)
	if (f < 0.33)
		self.mdl = "maps/aarn1.bsp";
	else if (f < 0.66)
		self.mdl = "maps/aarn2.bsp";
	else
		self.mdl = "maps/aarn3.bsp";

	if (self.wait < 1) self.wait = 20; // appear time
	if (self.cnt < 1) self.cnt = 30;
	if (random() < 0.2)
	{
		f = random();
		if (f < 0.25) self.lefty = 30;
		else if (f < 0.5) self.lefty = 60;
		else if (f < 0.6) self.lefty = 80;
	}

	if (self.delay < 1) self.delay = 30; // hang time
	if (self.count < 1) self.count = 40;

	self.think = th_arcarn;
	self.nextthink = time + self.wait + self.cnt * random() + self.lefty;

	if (self.lefty) // small chance of fast starts
	if (random() < 0.1)
		self.nextthink = time + self.wait * random();

	self.oldorigin = self.origin;
	if (self.distance < 1) self.distance = 64;
	if (self.height< 1) self.height = 32;
	if (!self.lip) self.lip = 0.24;

	self.alpha = 0;
	if (self.flags < 1) self.flags = 12;
};

// archon_fader - fade archon colors for floor

void() archon_fader =
{
	local entity t;

	t = find (world, targetname, self.target);

	if (self.delay <= 0) self.delay = 0.05; // default - 20 steps - note: really all need to be the same
	if (self.wait <= 0) self.wait = 10; // default - 60 rels per color
	if (self.cnt <= 0) self.cnt = 0.1; // default - tenth per alpha seq

	if (t.delay <= 0) t.delay = 0.05;
	if (t.wait <= 0) t.wait = 10;
	if (t.cnt <= 0) t.cnt = 0.1;

	if ((self.alpha >= 1) && !t) // cycle 1 color
	{
		self.alpha = 0.98;
		self.nextthink = time + self.wait;
		self.delay = 0 - self.delay;
	}
	else
	if (self.alpha < 0.01)
	{
//		self.alpha = 0.001; // cant set alpha at 0 - engine displays full tex

		if (t)
		{
			self.alpha = 0;
			self.mdl = self.model;
			self.model = null_string;

			t.model = t.mdl;
			t.alpha = 1;
			t.nextthink = time + t.wait;
			t.think = archon_fader;
		}
		else // no targets - cycle this color
		{
			self.alpha = 0.01;
			self.nextthink = time + self.wait;
			self.delay = 0 - self.delay;
		}
	}
	else
	{
		if (t)
		{
			if (t.model == null_string)
			{
				t.alpha = 0.01;
				t.model = t.mdl;
			}
			t.alpha = t.alpha + self.delay;
		}
		self.alpha = self.alpha - self.delay;
		self.nextthink = time + self.cnt;
	}
};


// was cause the map load wouldnt set alpha correctly
// changed because near 0 alpha was mega slowdown

void() archon_fadeinit =
{
	self.mdl = self.model;
	self.model = null_string;
};


/*

 archon power point code

power points must consist of -

1. a map loaded physical model, either brushes, .mdl or .bsp  (must be non blocking | non solid),
2. an "archon_power" entity (map loaded) that is origin for the power color spray and item creation
3. a "trigger_multiple"  for players touching the point
4. an "archon_power_act" entity (map loaded) that gets used when trigger (3) is fired

*/

// display archon power level for player, at request
void(entity e) archon_pprint =
{
	sprint(e, "-\n\bArchon power\b: ");
	sprint(e, ftos(floor(e.archon)));
	sprint(e, "\n");
}

// move power points - called once per frame from pre think by player(s)

void() PowerPointMove =
{
	local entity e;

	e= find (world,classname,"archon_power");
	if (e) // found a point
	{
		if (e.target) // follow this target
		{
			e.enemy = find (world,targetname,e.target);
			if (e.enemy)
			{
				if (e.target2)
				e.goalentity = find (world,target2,e.target2); // find the trigger that pairs with this pp
				if (e.goalentity && !e.ip_orgOrigin) e.ip_orgOrigin = e.goalentity.origin - e.origin; // calculate origin sync for the paired trigger field position

				v1 = e.origin;
				if (e.target1 == "_z") v1_z = e.enemy.origin_z + e.height; // height adjust from target (could be a mover)
				else if (e.target1 == "mins_z") v1_z = e.enemy.mins_z + e.height;
				else if (e.target1 == "_both_z") v1_z = e.enemy.origin_z + e.enemy.mins_z + e.height;
				else if (e.target1 == "_dest") v1 = e.enemy.origin + e.dest;
				else v1 = e.enemy.origin;
				if (e.origin != v1) setorigin(e, v1);
				if (e.goalentity) setorigin(e.goalentity, v1 + e.ip_orgOrigin); // sync the paired trigger field
			}
		}
		e = find (e,classname,"archon_power");
	}
};

// spawn flag values - moved for other fn
//float NOITEM = 1;
//float NOHEAL = 1;
//float NOSPRAY = 2;
//float P_RELOAD = 4;


float arc_pwr_item; // unique id for each power point

// change points spray color
// make items for points
// called by .th_die()

// IDEA: other "color" effect besides particle spray - glowing globe ?
// IDEA: link to item so we know when to make a new one

void() archon_power_fn =
{
	local float f;
	local entity e;

		if (self.spawnflags & P_RELOAD) // reload model
		if (self.super_time < time)
		{
			setmodel(self, self.mdl);
			self.super_time = time + self.wait;
		}

	if (self.attack_finished < time) // spray color
	{
		self.attack_finished = time + 10 + random() * 5;
		f = rint(random() * 4.3);
		if (!f) self.cnt = 74;
		else if (f == 1) self.cnt = 210;
		else if (f == 2) self.cnt = 146;
		else if (f == 3) self.cnt = 194;
		else if (f == 4) 
		{
			f = rint(random() * 31.4);
			self.cnt = 2 + (f * 8);
		}
	}

	f  = (self.search_time < time);
	if (f)
	{
		self.search_time = time + 5 + random() * 5;
		if (random() < 0.1) self.search_time = self.search_time + 10 + random() * 20; // some times longer
	}

	e = findradius(self.origin, 64);
	while (e && f)
	{
		if (e.flags & FL_CLIENT) f = FALSE;
		if (e.flags & FL_ITEM)
		if (e.button14 == self.button14) f = FALSE;
		e = e.chain;
	}

	if (f) // no players & we dont have an item here - make one
	{
		e = self;
		self = spawn(); // temp ent
		self.origin = e.origin;
		self.delay = self.count = 0;
		self.wait = MC_SUPER_SHOTGUN + rint(random() * 6.4); // weps & poss quad
		if (random() < 0.4) self.wait = -3;
		else
		if (random() < 0.2) self.wait = -1;

		self.spawnflags = 2 | 8; // respawn on item - + spawnflag for old dynamic remove
		self.button4 = -666; // dont catch melee mode yet...
		func_make();
		self.goalentity = newmis;
		newmis.velocity = v0; // stop eject
		newmis.button14 = e.button14;
		self.button4 = 0;

// make ammo for weps - can only be gotten one time
		if (newmis.items & IT_SUPER_SHOTGUN)
		{
			self.wait = MC_ASHELLS_LG;
			if (random() < 0.22)
				self.wait = MC_AEXPLSH;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
		}
		else if (newmis.items & (IT_SUPER_NAILGUN | IT_NAILGUN))
		{
			self.wait = MC_ANAILS_LG;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
	}
		else if (newmis.items & (IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER))
		{
			self.wait = MC_AROCKETS_LG;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
		}
		else if (newmis.items & IT_LIGHTNING || newmis.pk_currentitem == PK_IT_CLIGHT)
		{
			self.wait = MC_ACELLS_LG;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
			func_make();
			newmis.punchangle = MED_BOUNCE_NOW;
		}

// dont make  non melee items under this rule
		if (TR_ALL == FL_TR_MELEE) item_translate(self.goalentity, TR_ALL);

		remove(self);
		self = e;
	}
};

// spawn for archon power point color spray & create think
// power point id is used to detect point created items


/*QUAKED archon_power (.8 .1 .8) (-8 -8 -8) (8 8 8) NOITEM NOSPRAY P_RELOAD
*/

void() archon_power =
{
	if (self.alpha <= 0) self.alpha = 0.7;
	if (self.scale <= 0) self.scale = 0.6;
	if (self.wait <= 0) self.wait = 10;
	self.cnt = 74;

	if (self.mdl == null_string) self.mdl = "progs/arc_pp.bsp";
	setmodel(self, self.mdl);

	self.nextthink = time + 3;
	self.think = q2_teleport_particles;
	self.th_die = archon_power_fn;

	if (self.spawnflags & NOITEM) self.search_time = MAXFL;
	else
// dont always make items instantly
	if (random() < 0.4)
		self.search_time = time + 3 + random() * 5;

// unique id for each point
	if (!arc_pwr_item) arc_pwr_item = 4000 + rint(10 * random());
	self.button14 = arc_pwr_item;
	arc_pwr_item = arc_pwr_item + 1 + rint(random() * 6);

// IMP: sounds, powers
};

// touching a point when it activates

// touching ent does not have a healtype - set one at random

void(entity e) archon_point_heal =
{
// heal level
	e.health_modifier = 0.6;
	e.healtype = 2;
	if (random() < 0.5)
	{
		e.health_modifier = 0.8;
		e.healtype = 3 + rint(0.33 + random());
	}
	else
	if (random() < 0.15)
	{
		e.health_modifier = 1;
		e.healtype = 4 + rint(0.33 + random());
	}
	
};

// IMP: other effects - proof against magic spell attack too - this touch will have to be detected live

// when touch fired by trigger - heal ent that touched, add points
// trigger timing controls freq. of touch

void() archon_power_touch =
{
	if (self.wad == "archon_power") // archon made points need debounced
	{
		if (activator.mask_x & MORPH_ARCHON) return;
		if (self.rad_time > time) return;
		self.rad_time = time + 1;
		activator = other; // because this was a regular touch
	}

	if (self.goalentity) // made by an Archon, he gets some every usage
	{
		if (self.goalentity == other) return; // this might be a redundant check, as Archons are sent back above
		self.goalentity.archon = self.goalentity.archon + 0.333;
	}

	if (! self.spawnflags & NOHEAL)
	{
		if (!activator.healtype) archon_point_heal(activator);

		if (activator.health < (activator.max_health * activator.health_modifier * activator.health_modifier)) // health < points mod
			T_Heal(activator,activator.healtype + rint(0.33 + random()), 0);
	}

	if (! self.archon) self.archon = ARCHON_POINT;

	if (activator.mask_x & MORPH_ARCHON)
		activator.archon = activator.archon + (self.archon) * 5;

	activator.archon = activator.archon + self.archon;

	if (activator.mask_x & MORPH_ARCHON) return;

// magic protection
	if (activator.bolt_target)
	{
		if (activator.bolt_target == self)
		{
			activator.bolt_targetTimeout = time + 10;
			return;
		}
		if (activator.bolt_target.classname == "gfx/reticle.spr") // was targeted - clear it
		{
			archon_target_clear(activator);
		}
	}

	if (!activator.bolt_target) // set protection
	{
		activator.bolt_target = self;
		activator.bolt_targetTimeout = time + 10;		
	}
};

// power point activator - must be targeted by multi trigger
// calls *_touch when trigger is fired

/*QUAKED archon_power_act (.8 .1 .8) (-8 -8 -8) (8 8 8) NOHEAL
*/

void() archon_power_act =
{
	self.model = null_string;
	self.solid = SOLID_NOT;
	self.use = archon_power_touch;
};


















