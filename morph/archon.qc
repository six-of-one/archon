/* ::-::
 *
 * Cataboligne
 *
 * file: m-cthon.qc
 *
 * date: 9/29/13
 *
 * qc - support chaos mod archon being
 *
 */
 
 // return an archon to its previous form, previous morph or human state if archon power is ever < 0

// fn(de_archon_thk) - keep checking to see when an Archon has enough power to return to archon form, return is automatic

void() de_archon_thk =
{
	if (self.owner.archon > CHAOS_BEAM_MIN)
	{
		if (self.owner.goalentity == self) self.owner.goalentity = world;
		polymorph_check(self.owner.height, 0);
		remove(self);
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
	newmis = self;
	self = e;

	if (self.state == 0) self.state = IMP_MHUMAN;
	if (self.state == IMP_MCHAOS) self.state = IMP_MHUMAN;
	else if (self.state == IMP_MORDER) self.state = IMP_MHUMAN;
	polymorph_check(self.state, 0);

	self.goalentity = chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", null_string, SUB_Null, 10, de_archon_thk, SUB_Null, self, world);
	self = newmis;
};

// archon nodule - map item - gives archon pts

void() archon_nodule =
{
	if (!self.netname) self.netname = "Nodule";
	if (!self.model) setmodel (self,"progs/nodule1.mdl");
	if (!self.noise) 	self.noise = "items/r_item2.wav";
	if (!self.archon) self.archon = 20 + crandom() * 5;

	setmodel (self, self.model);
	setsize (self,'-8 -8 -8','8 8 8');
	self.mins_z = self.mins_z - floor(random() * 4) * 4;
	self.mask_x = MORPH_ALL + MORPH_ARCHON;
	self.class_select = "x_item";
	self.touch = x_item_touch;

	StartItem ();
};

// random nodule maker

void() archon_nodule_rnd =
{
	archon_nodule();
	self.mins_z = self.mins_z - floor(random() * 6) * 4;

// some random rotation
	if (!self.modelflags)
	if (random() < 0.3) self.modelflags = 8;

	gsf = rint(random() * 6);

//	if (gsf == 0) setmodel (self,"progs/nodule1.mdl"); // 3, 4
	if (1 || (time > 240) && (random() < 0.05) && !god_particle) // god particle - only one - TEST!
	{
		god_particle = self;
		self.netname = "\bGod Particle\b";
		setmodel (self,"progs/nodule110110110.bsp");
		setsize (self,'-16 -16 -24','16 16 16');
		self.scale = 0.35;
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
		if (random() < 0.3) self.modelflags = self.modelflags | 128; // purple light
		if (time > 180) self.archon = 120 + crandom() * 40;
	}
	else 
	if (gsf < 3) // 0, 1, 2
	{
		setmodel (self,"progs/nodule10.mdl");
		if (time > 120) self.archon = 50 + crandom() * 25;
	}

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


// archon varmpire power

void() archon_vampire_thk =
{
	self.aflag = 0;
	if (self.enemy.bolt_target) self.aflag = 1;
	if (self.count <= 0) self.aflag = 1;
	if (self.enemy.archon <= 0) self.aflag = 1;
	if (self.enemy.solid == SOLID_NOT) self.aflag = 1;
	if (self.takedamage == DAMAGE_NO) self.aflag = 1;
	if (!((self.enemy.rune_flag & RUNE_FLG_RS) && (self.enemy.mask_x & MORPH_ARCHON))) self.aflag = 1;
	if (! self.owner.rune_flag & RUNE_VAMPIRE) self.aflag = 1;

	if (self.aflag)
	{
		stuffcmd(self.owner, "hud_vampire_target \"");
		stuffcmd(self.owner, "\"\n");
		remove(self);
		return;
	}

	self.nextthink = time + 1;

	self.owner.archon = self.owner.archon + self.archon;
	self.enemy.archon = self.enemy.archon - self.archon;
	self.count = self.count - self.archon;
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
	if (self.wait <= 0) self.wait = 10; // default - 60 secs per color
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

void() archon_power_fn =
{
	local float f;
	local entity e;

		if (self.target) // follow this target
		{
			e = find (world,targetname,self.target);
			if (e)
			{
				v1 = self.origin;
				if (self.target1 == "_z") v1_z = e.origin_z + self.height; // height adjust from target (could be a mover)
				else if (self.target1 == "mins_z") v1_z = e.mins_z + self.height;
				else if (self.target1 == "_both_z") v1_z = e.origin_z + e.mins_z + self.height;
				else if (self.target1 == "_dest") v1 = e.origin + self.dest;
				else v1 = e.origin;
				if (self.origin != v1) setorigin(self, v1);
			}
		}

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
		func_make();
		newmis.velocity = v0; // stop eject
		newmis.button14 = e.button14;

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
	if (! self.spawnflags & NOHEAL)
	{
		if (!other.healtype) archon_point_heal(other);

		if (activator.health < (activator.max_health * activator.health_modifier * other.health_modifier)) // health < points mod
			T_Heal(activator,other.healtype + rint(0.33 + random()), 0);
	}

	if (activator.mask_x & MORPH_ARCHON)
		activator.archon = activator.archon + (self.archon + ARCHON_POINT) * 5;
	if (self.archon)
		activator.archon = activator.archon + self.archon;
	else
		activator.archon = activator.archon + ARCHON_POINT;

// magic protection
	if (activator.bolt_target)
	{
		if (activator.bolt_target == self)
		{
			activator.bolt_targetTimeout = time + 10;
			return;
		}
		if (activator.bolt_target.model == "progs/reticle.mdl") // was targeted - clear it
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


















