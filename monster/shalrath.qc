/*
==============================================================================

SHAL-RATH

==============================================================================
*/

 /*
"the Upgrade"

The larger cousin of the purple traking bomb throwin vore - also know as the "Super-vore".

Super-vore did not join his smaller cousin in support of Shubs, Armagon, or whoever was in charge in Dissolution.

He stayed home.  Thus the player has not seen him.

Not in the original time line anyway.

But since Chaos has involved itself, he has appeared.

He got concerned about his smaller cousin when he heard stories about how easy Shubs was to poink the first time.

*/
 
 
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12

// super shalrath!
$frame lgattack1 lgattack2 lgattack3 lgattack4 lgattack5 lgattack6 lgattack7 lgattack8
$frame lgattack9 lgattack10 lgattack11

$frame lgpain1 lgpain2 lgpain3 lgpain4 lgpain5

$frame lgdeath1 lgdeath2 lgdeath3 lgdeath4 lgdeath5 lgdeath6 lgdeath7

$frame	lgwalk1 lgwalk2 lgwalk3 lgwalk4 lgwalk5 lgwalk6 lgwalk7 lgwalk8 lgwalk9 lgwalk10
$frame	lgwalk11 lgwalk12

$frame lgattackb1 lgattackb2 lgattackb3 lgattackb4


void() shalrath_pain;
void() ShalMissile;

void() shal_stand     =[      $walk1,       shal_stand    ]
{
	self.count = self.count + 1;

	if (self.wad == "SUPER")
	{
		if (SV_MINEALLOW & CB_M_SVORE)
		if ((time & SV_CKTIME) == SV_CKTIME)
		if (self.count > 5)
		if (random() < 0.35)
		{
			SummonMonster(null_string);
			self.count = 0;
		}

// charge him up - note buku XP if killed while he has this
		if (self.archon < 100) self.archon = self.health + random() * (self.health / 2);
	}

	ai_stand();
};

void() shal_walk1     =[      $walk2,       shal_walk2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_walk(6);};
void() shal_walk2     =[      $walk3,       shal_walk3    ] {ai_walk(4);};
void() shal_walk3     =[      $walk4,       shal_walk4    ] {ai_walk(0);};
void() shal_walk4     =[      $walk5,       shal_walk5    ] {ai_walk(0);};
void() shal_walk5     =[      $walk6,       shal_walk6    ] {ai_walk(0);};
void() shal_walk6     =[      $walk7,       shal_walk7    ]
{
	if (self.wad == "SUPER")
	{
		if (SV_MINEALLOW & CB_M_SVORE)
		if ((time & SV_CKTIME) == SV_CKTIME) SummonMonster(null_string);

		if (self.archon < 100) self.archon = self.health + random() * (self.health / 2);
	}

	ai_walk(0);
};
void() shal_walk7     =[      $walk8,       shal_walk8    ] {ai_walk(5);};
void() shal_walk8     =[      $walk9,       shal_walk9    ] {ai_walk(6);};
void() shal_walk9     =[      $walk10,       shal_walk10    ] {ai_walk(5);};
void() shal_walk10    =[      $walk11,       shal_walk11    ] {ai_walk(0);};
void() shal_walk11    =[      $walk12,       shal_walk12    ] {ai_walk(4);};
void() shal_walk12    =[      $walk1,       shal_walk1    ] {ai_walk(5);};

void() shal_run1     =[      $walk2,       shal_run2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_run(6);};
void() shal_run2     =[      $walk3,       shal_run3    ] {ai_run(4);};
void() shal_run3     =[      $walk4,       shal_run4    ] {ai_run(0);};
void() shal_run4     =[      $walk5,       shal_run5    ]
{
	if (self.wad == "SUPER")
	if (sphere_a.owner != self) // dont summon while we have the sphere
	if ((time & SV_CKTIME) == SV_CKTIME)
	{
		self.count = cnt_ent(world, "owner",  "monster_shalrath");
		self.count = self.count + cnt_ent(world, "owner",  "monster_wizard");
		self.count = self.count + cnt_ent(world, "owner",  "monster_spider");
		self.count = self.count + cnt_ent(world, "owner",  "monster_vomit");
		if (self.count < 4 + skill)
		{
			self.cnt = random();
			if (self.cnt < 0.15) SummonMonster("monster_shalrath");
			else if (self.cnt < 0.3) SummonMonster("monster_wizard");
			else if (self.cnt < 0.4) SummonMonster("monster_spider");
			else if (self.cnt < 0.6) SummonMonster("monster_vomit");
		}
	}

	ai_run(0);
};
void() shal_run5     =[      $walk6,       shal_run6    ] {ai_run(0);};
void() shal_run6     =[      $walk7,       shal_run7    ] {ai_run(0);};
void() shal_run7     =[      $walk8,       shal_run8    ] {ai_run(5);};
void() shal_run8     =[      $walk9,       shal_run9    ] {ai_run(6);};
void() shal_run9     =[      $walk10,       shal_run10    ] {ai_run(5);};
void() shal_run10    =[      $walk11,       shal_run11    ] {ai_run(0);};
void() shal_run11    =[      $walk12,       shal_run12    ] {ai_run(4);};
void() shal_run12    =[      $walk1,       shal_run1    ] {ai_run(5);};

// super shal-rath - Vorerel - Vaareziel

// 2nd attack - lightning, summon sphere, portal, other magics
/*

deprecated - using player vore 2nd attack frames

void() s_shal_attackb1     =[      $lgattackb1,       s_shal_attackb2    ] 
{
	sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM); // IMP: new sounds for super
	ai_frame(self.walkframe);
	ai_face();
};
void() s_shal_attackb2     =[      $lgattackb2,       s_shal_attackb3    ] {ai_face();ai_frame(self.walkframe);};
void() s_shal_attackb3     =[      $lgattackb3,       s_shal_attackb4    ] {ai_face();ai_frame(self.walkframe);};
void() s_shal_attackb4     =[      $lgattackb4,       s_shal_attackb5    ]
{
	ShalMissile(); // IMP: attack 2 - new att
	ai_frame(self.walkframe);
};
void() s_shal_attackb5    =[      $lgattackb3,      s_shal_attackb6   ] {ai_face();ai_frame(self.walkframe);};
void() s_shal_attackb6    =[      $lgattackb2,      shal_run1   ] {ai_frame(self.walkframe);};

*/

void() player_shalrath_lightning1;

void() shal_attack1     =[      $attack1,       shal_attack2    ]
{
	if (self.wad == "SUPER")
	{
		self.cnt = random();
		if (self.cnt < 0.05) self.weapon = 0; // got back to explody balls
		else 
		if (self.cnt < 0.12) // change weps
		{
			self.cnt = random();
			if (self.cnt < 0.3) self.weapon = IT_LIGHTNING;
			else if (self.cnt < 0.4) self.weapon = 2;
			else self.weapon = IT_SUPER_NAILGUN;
		}
#ifdef testset
	// REMOVE
//		self.weapon = IT_LIGHTNING;
#endifdef
	}

	if ((sphere_a.owner == self) && self.weapon != 2) shal_run1();
	else
	if (self.weapon) player_shalrath_lightning1(); //s_shal_attackb1();
	else
	sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	
	ai_face();
	ai_frame(self.walkframe);
};
void() shal_attack2     =[      $attack2,       shal_attack3    ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack3     =[      $attack3,       shal_attack4    ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack4     =[      $attack4,       shal_attack5    ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack5     =[      $attack5,       shal_attack6    ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack6     =[      $attack6,       shal_attack7    ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack7     =[      $attack7,       shal_attack8    ]
{
	if (self.wad == "SUPER")
	if (random() < 0.8) ShalMissile();
	ai_face();
	ai_frame(self.walkframe);
};
void() shal_attack8     =[      $attack8,       shal_attack9    ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack9     =[      $attack9,       shal_attack10   ]
{
	ShalMissile();
	ai_frame(self.walkframe);
};
void() shal_attack10    =[      $attack10,      shal_attack11   ] {ai_face();ai_frame(self.walkframe);};
void() shal_attack11    =[      $attack11,      shal_run1   ] {ai_frame(self.walkframe);};

void() shal_pain1       =[      $pain1, shal_pain2      ] {ai_frame(self.walkframe);};
void() shal_pain2       =[      $pain2, shal_pain3      ] {ai_frame(self.walkframe);};
void() shal_pain3       =[      $pain3, shal_pain4      ] {ai_frame(self.walkframe);};
void() shal_pain4       =[      $pain4, shal_pain5      ] {ai_frame(self.walkframe);};
void() shal_pain5       =[      $pain5, shal_run1      ] {ai_frame(self.walkframe);};


void() shal_death1      =[      $death1,        shal_death2     ] {ai_frame(self.walkframe);};
void() shal_death2      =[      $death2,        shal_death3     ] {ai_frame(self.walkframe);};
void() shal_death3      =[      $death3,        shal_death4     ] {ai_frame(self.walkframe);};
void() shal_death4      =[      $death4,        shal_death5     ] {ai_frame(self.walkframe);};
void() shal_death5      =[      $death5,        shal_death6     ] {ai_frame(self.walkframe);};
void() shal_death6      =[      $death6,        shal_death7     ] {ai_frame(self.walkframe);};
void() shal_death7      =[      $death7,        SUB_Null    ] {ai_frame(self.walkframe);};



void() shalrath_pain =
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);

	shal_pain1();
	self.pain_finished = time + 3;
	if (self.wad == "SUPER") self.pain_finished = time + 5;
};

void() shalrath_die =
{
// check for gib
	if (self.health < -90)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_shal.mdl", self.health);
		if (self.walkframe > 0) self.scale = 1.25;
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);

	shal_death1();
	self.solid = SOLID_NOT;
	// insert death sounds here
};

/*
================
ShalMissile
================
*/
void() ShalMissileTouch;
void() ShalHome;
void() ShalMissile =
{
	local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.classname = "vorespike";
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/v_spike.mdl");

	setsize (missile, '0 0 0', '0 0 0');

	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = ShalHome;
	missile.enemy = self.enemy;
	missile.touch = ShalMissileTouch;
	AddToSplash(missile); // *pk - Make this entity splash
};

void() ShalHome =
{
	local vector	dir;
	self.dest1 = self.enemy.origin + '0 0 10';

// fix a bug where morph fired trackers are removed instantly, or strangely track to the world ent
	if (self.morphy) // fired by a morph player
	if (!self.enemy || self.enemy.health < 1) // fired with no target or target died
	{
// look for targets near flight path - idea: forward looking radar with longer range
		other = findradius(self.origin, 480);
		while (other)
		{
			if (other.solid != SOLID_NOT) // only solids
			if (other.health > 1) // can take damage && is not dead
			if (other.takedamage)
			if (other != self)	// not the bomb
			if (other != self.owner)	// not the shotter
			if (other.owner != self.owner)	// not summoned by the owner
			if (other.charmer != self.owner)	// not summoned by horn
			{
				self.lip = vlen(other.origin - self.origin);
				traceline(self.origin, other.origin, TRUE, self);

				if (trace_fraction >= 1) // can see the ent
// note - this targets invisible pk*bots
				if (other.classname != "player" || (!(other.items & IT_INVISIBILITY) && !coop && (other.classname != OBSERVER))) // dont target players / bots in coop
				{
					if (self.lip < self.lefty) // closer thing
					{
						self.enemy = other;
						self.lefty = self.lip;
					}
// but prioritize player or monster further than the closest thing
					if (other.classname == "player") self.enemy = other;
					else if (other.class_select == "class_monster") self.enemy = other;

					if (self.enemy) self.dest1 = self.enemy.origin; // target this
				}
			}
			other = other.chain;
		}
		self.nextthink = time + 0.1;
		self.think = ShalHome;
		return;
	}

	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}
	dir = normalize(self.dest1 - self.origin);
	if (skill == 3)
		self.velocity = dir * 350;
	else
		self.velocity = dir * 250;
	self.nextthink = time + 0.2;
	self.think = ShalHome;

// for homing spikes & such
	if (self.classname != "vorespike")
		self.angles = vectoangles(dir);
};

void() ShalMissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (self.owner.class_select == "class_monster") // not a morphed player or bot
	{
		if (other.owner == self.owner) return; // dont blow on SV summoned monster
		if (other.model == "progs/shalrath.mdl") return; // dont blow on other monster vore / supervore
	}

//	ldmg = 40;
	if (! self.dmg) self.dmg = 40;

	if (other.classname == "monster_zombie")
		T_Damage (other, self, self, 110);

	T_RadiusDamage (self, self.owner, self.dmg, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};
//=================================================================

// new super vore attack while idle - if done while fighting the mine would just attack

// moved to monsters.qc, renamved SummonMonster

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush Super
*/
void(float ign) monster_shalrath =
{

if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (!M_MONSTER & CB_M_SHALR)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

// make some more random monsters according to server rules - only do this on map spawned monsters, wont happen with random monsters
	if (R_FAST_MONSTER & CB_M_SHALR)
	if (random() < C_FS_MONSTER)
		speed_monster(CFAST, "monster_shalrath", self.origin);
		
	if (R_SLOW_MONSTER & CB_M_SHALR)
	if (random() < C_FS_MONSTER)
		speed_monster(CSLOW, "monster_shalrath", self.origin);

	precache_model ("progs/shalrath.mdl");
	precache_model ("progs/h_shal.mdl");
	precache_model ("progs/v_spike.mdl");

	precache_sound ("shalrath/attack.wav");
	precache_sound ("shalrath/attack2.wav");
	precache_sound ("shalrath/death.wav");
	precache_sound ("shalrath/idle.wav");
	precache_sound ("shalrath/pain.wav");
	precache_sound ("shalrath/sight.wav");

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random ()*0.1;
}

// Cataboligne - 11.14.12 - fast / slow code
	if (self.speed <= 0) self.speed = MON_NORM;
	self.lip = 1; // local speed divisor
// map specced
	if (self.netname == CFAST) self.speed = MON_FAST;
	else if (self.netname == CSLOW) self.speed = MON_SLOW;

// server controls set all monsters fast or slow if not specced - this includes random monsters
	else if (FAST_MONSTER & CB_M_SHALR) self.speed = MON_FAST;
	else if (SLOW_MONSTER & CB_M_SHALR) self.speed = MON_SLOW;

	self.netname = "Shalrath";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.walkframe = 0;

	setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 400;

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;

	if (ign == A_MONSTER) walkmonster_start(); // dyns have to call this
};

//=================================================================

/*QUAKED monster_supervore (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void(float ign) monster_supervore =
{

if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		remove(self);
		return;
	}
	
	if (!M_MONSTER & CB_M_SHALR)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

// make some more random monsters according to server rules - only do this on map spawned monsters, wont happen with random monsters
	if (R_FAST_MONSTER & CB_M_SHALR)
	if (random() < C_FS_MONSTER)
		speed_monster(CFAST, "monster_shalrath", self.origin);
		
	if (R_SLOW_MONSTER & CB_M_SHALR)
	if (random() < C_FS_MONSTER)
		speed_monster(CSLOW, "monster_shalrath", self.origin);

	precache_model ("progs/shalrath.mdl");
	precache_model ("progs/h_shal.mdl");
	precache_model ("progs/v_spike.mdl");

	precache_sound ("shalrath/attack.wav");
	precache_sound ("shalrath/attack2.wav");
	precache_sound ("shalrath/death.wav");
	precache_sound ("shalrath/idle.wav");
	precache_sound ("shalrath/pain.wav");
	precache_sound ("shalrath/sight.wav");

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random ()*0.1;
}

// Cataboligne - 11.14.12 - fast / slow code
	if (self.speed <= 0) self.speed = MON_NORM;
	self.lip = 1; // local speed divisor
// map specced
	if (self.netname == CFAST) self.speed = MON_FAST;
	else if (self.netname == CSLOW) self.speed = MON_SLOW;

// server controls set all monsters fast or slow if not specced - this includes random monsters
	else if (FAST_MONSTER & CB_M_SHALR) self.speed = MON_FAST;
	else if (SLOW_MONSTER & CB_M_SHALR) self.speed = MON_SLOW;

	if (random() < 0.3)
		self.netname = "Vorerel";
	else
		self.netname = "Vaareziel";		// from Rothrin

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.walkframe = $lgattack1;

	setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 800; // wowsers - NOTE: might need tweaked down a bit

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;

	self.wad = "SUPER";

	if (ign == A_MONSTER) walkmonster_start(); // dyns have to call this
};














