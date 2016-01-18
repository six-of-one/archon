/*
==============================================================================

DEMON

==============================================================================
*/

$cd id1/models/demon3
$scale	0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

// dbl demon / black orange beast w/ skin + tail

$frame dblstand1 dblstand2 dblstand3 dblstand4 dblstand5 dblstand6 dblstand7 dblstand8 dblstand9
$frame dblstand10 dblstand11 dblstand12 dblstand13

$frame dblwalk1 dblwalk2 dblwalk3 dblwalk4 dblwalk5 dblwalk6 dblwalk7 dblwalk8

$frame dblrun1 dblrun2 dblrun3 dblrun4 dblrun5 dblrun6

$frame dblleap1 dblleap2 dblleap3 dblleap4 dblleap5 dblleap6 dblleap7 dblleap8 dblleap9 dblleap10
$frame dblleap11 dblleap12

$frame dblpain1 dblpain2 dblpain3 dblpain4 dblpain5 dblpain6

$frame dbldeath1 dbldeath2 dbldeath3 dbldeath4 dbldeath5 dbldeath6 dbldeath7 dbldeath8 dbldeath9

$frame dblattacka1 dblattacka2 dblattacka3 dblattacka4 dblattacka5 dblattacka6 dblattacka7 dblattacka8
$frame dblattacka9 dblattacka10 dblattacka11 dblattacka12 dblattacka13 dblattacka14 dblattacka15

// super demon
$frame superstand1 superstand2 superstand3 superstand4 superstand5 superstand6 superstand7 superstand8 superstand9
$frame superstand10 superstand11 superstand12 superstand13

$frame superwalk1 superwalk2 superwalk3 superwalk4 superwalk5 superwalk6 superwalk7 superwalk8

$frame superrun1 superrun2 superrun3 superrun4 superrun5 superrun6

$frame superleap1 superleap2 superleap3 superleap4 superleap5 superleap6 superleap7 superleap8 superleap9 superleap10
$frame superleap11 superleap12

$frame superpain1 superpain2 superpain3 superpain4 superpain5 superpain6

$frame superdeath1 superdeath2 superdeath3 superdeath4 superdeath5 superdeath6 superdeath7 superdeath8 superdeath9

$frame superattacka1 superattacka2 superattacka3 superattacka4 superattacka5 superattacka6 superattacka7 superattacka8
$frame superattacka9 superattacka10 superattacka11 superattacka12 superattacka13 superattacka14 superattacka15

// extra mad

$frame semstand1 semstand2 semstand3 semstand4 semstand5 semstand6 semstand7 semstand8 semstand9
$frame semstand10 semstand11 semstand12 semstand13

$frame semwalk1 semwalk2 semwalk3 semwalk4 semwalk5 semwalk6 semwalk7 semwalk8

$frame semrun1 semrun2 semrun3 semrun4 semrun5 semrun6

$frame semleap1 semleap2 semleap3 semleap4 semleap5 semleap6 semleap7 semleap8 semleap9 semleap10
$frame semleap11 semleap12

$frame sempain1 sempain2 sempain3 sempain4 sempain5 sempain6

$frame semdeath1 semdeath2 semdeath3 semdeath4 semdeath5 semdeath6 semdeath7 semdeath8 semdeath9

$frame semattacka1 semattacka2 semattacka3 semattacka4 semattacka5 semattacka6 semattacka7 semattacka8
$frame semattacka9 semattacka10 semattacka11 semattacka12 semattacka13 semattacka14 semattacka15

//============================================================================

float	DEMON_DBL	= 2;
float	DEMON_SUPER	= 4;
float	DEMON_BOB	= 8;
float	DEMON_SUPER_MAD	= 16; // got extra mad
float DEMON_BOOM = 32; // raged and exploding

//float super_demon_chance = 0.08;
//float dbl_demon_chance = 0.25;
//float super_demon_emheal = 100; // how much a super demon thats extra mad could heal in a pain frame
//float super_demon_emheal_chn = 0.33; // chance to heal

void()	demon1_stand1	=[	$stand1,	demon1_stand1	]
{
	if ((self.duration < $stand1) || (self.duration > $stand12))
	{
		self.duration = $stand1;
	}
	else self.duration = self.duration + 1;

	self.frame = self.duration;

// demon summons aid
/*

decided not too - super demon is one bad mofo, and would NOT ask for any help

	if (self.frame == $stand5)
	if (self.spawnflags & SUPER)
	if ((time & SV_CKTIME) == SV_CKTIME)
	if (random() < 0.25)
		SummonMonster("monster_dog");
*/

	ai_stand();
};

/*

deprecated for loop code

void()	demon1_stand1	=[	$stand1,	demon1_stand2	]
{
	self.spawnflags = self.spawnflags - (self.spawnflags & DEMON_SUPER_MAD);

	ai_stand();
};
void()	demon1_stand2	=[	$stand2,	demon1_stand3	] {ai_stand();};
void()	demon1_stand3	=[	$stand3,	demon1_stand4	] {ai_stand();};
void()	demon1_stand4	=[	$stand4,	demon1_stand5	] {ai_stand();};
void()	demon1_stand5	=[	$stand5,	demon1_stand6	] {ai_stand();};
void()	demon1_stand6	=[	$stand6,	demon1_stand7	] {ai_stand();};
void()	demon1_stand7	=[	$stand7,	demon1_stand8	] {ai_stand();};
void()	demon1_stand8	=[	$stand8,	demon1_stand9	] {ai_stand();};
void()	demon1_stand9	=[	$stand9,	demon1_stand10	] {ai_stand();};
void()	demon1_stand10	=[	$stand10,	demon1_stand11	] {ai_stand();};
void()	demon1_stand11	=[	$stand11,	demon1_stand12	] {ai_stand();};
void()	demon1_stand12	=[	$stand12,	demon1_stand13	] {ai_stand();};
void()	demon1_stand13	=[	$stand13,	demon1_stand1	] {ai_stand();};
*/

void()	demon1_walk1	=[	$walk1,		demon1_walk2	] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_walk(8);
};
void()	demon1_walk2	=[	$walk2,		demon1_walk3	] {ai_walk(6 + self.waitmax);};
void()	demon1_walk3	=[	$walk3,		demon1_walk4	] {ai_walk(6 + self.waitmax);};
void()	demon1_walk4	=[	$walk4,		demon1_walk5	] {ai_walk(7 + self.waitmax);};
void()	demon1_walk5	=[	$walk5,		demon1_walk6	] {ai_walk(4 + self.waitmax);};
void()	demon1_walk6	=[	$walk6,		demon1_walk7	] {ai_walk(6 + self.waitmax);};
void()	demon1_walk7	=[	$walk7,		demon1_walk8	] {ai_walk(10 + self.waitmax);};
void()	demon1_walk8	=[	$walk8,		demon1_walk1	] {ai_walk(10 + self.waitmax);};

void()	demon1_run1	=[	$run1,		demon1_run2	] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_run(20);};
void()	demon1_run2	=[	$run2,		demon1_run3	] {ai_run(15 + self.waitmax * 1.2);};
void()	demon1_run3	=[	$run3,		demon1_run4	] {ai_run(36 + self.waitmax * 1.2);};
void()	demon1_run4	=[	$run4,		demon1_run5	] {ai_run(20 + self.waitmax * 1.2);};
void()	demon1_run5	=[	$run5,		demon1_run6	] {ai_run(15 + self.waitmax * 1.2);};
void()	demon1_run6	=[	$run6,		demon1_run1	] {ai_run(36 + self.waitmax * 1.2);};


void()	demon1_jump1	=[	$leap1,		demon1_jump2	] 
{
	ai_frame(self.walkframe);
	ai_face();
};
void()	demon1_jump2	=[	$leap2,		demon1_jump3	] {ai_frame(self.walkframe);ai_face();};
void()	demon1_jump3	=[	$leap3,		demon1_jump4	] {ai_frame(self.walkframe);ai_face();};
void()	demon1_jump4	=[	$leap4,		demon1_jump5	]
{
	ai_frame(self.walkframe);
	ai_face();
	
	self.touch = Monster_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	demon1_jump5	=[	$leap5,		demon1_jump6	] {ai_frame(self.walkframe);};
void()	demon1_jump6	=[	$leap6,		demon1_jump7	] {ai_frame(self.walkframe);};
void()	demon1_jump7	=[	$leap7,		demon1_jump8	] {ai_frame(self.walkframe);};
void()	demon1_jump8	=[ 	$leap8,		demon1_jump9	] {ai_frame(self.walkframe);};
void()	demon1_jump9	=[ 	$leap9,		demon1_jump10	] {ai_frame(self.walkframe);};
void()	demon1_jump10	=[ 	$leap10,	demon1_jump1	]
{
	ai_frame(self.walkframe);
	self.nextthink = time + 3;
// if three rels pass, assume demon is stuck and jump again
};

void()	demon1_jump11	=[ 	$leap11,	demon1_jump12	] {ai_frame(self.walkframe);};
void()	demon1_jump12	=[ 	$leap12,	demon1_run1	] {ai_frame(self.walkframe);};


void()	demon1_atta1	=[	$attacka1,		demon1_atta2	] {ai_frame(self.walkframe);ai_charge(4 + self.waitmax * 0.3);};
void()	demon1_atta2	=[	$attacka2,		demon1_atta3	] {ai_frame(self.walkframe);ai_charge(0);};
void()	demon1_atta3	=[	$attacka3,		demon1_atta4	] {ai_frame(self.walkframe);ai_charge(0);};
void()	demon1_atta4	=[	$attacka4,		demon1_atta5	] {ai_frame(self.walkframe);ai_charge(1 + self.waitmax * 0.3);};
void()	demon1_atta5	=[	$attacka5,		demon1_atta6	] {ai_frame(self.walkframe);ai_charge(2 + self.waitmax * 0.3); Demon_Melee(200); if (self.spawnflags & 6) Demon_Melee(200);};
void()	demon1_atta6	=[	$attacka6,		demon1_atta7	] {ai_frame(self.walkframe);ai_charge(1 + self.waitmax * 0.3);};
void()	demon1_atta7	=[	$attacka7,		demon1_atta8	] {ai_frame(self.walkframe);ai_charge(6 + self.waitmax * 0.3);};
void()	demon1_atta8	=[	$attacka8,		demon1_atta9	] {ai_frame(self.walkframe);ai_charge(8 + self.waitmax * 0.3);};
void()	demon1_atta9	=[	$attacka9,		demon1_atta10] {ai_frame(self.walkframe);ai_charge(4 + self.waitmax * 0.3);};
void()	demon1_atta10	=[	$attacka10,		demon1_atta11] {ai_frame(self.walkframe);ai_charge(2 + self.waitmax * 0.3);};
void()	demon1_atta11	=[	$attacka11,		demon1_atta12] {ai_frame(self.walkframe);Demon_Melee(-200); if (self.spawnflags & 6) Demon_Melee(-200);};
void()	demon1_atta12	=[	$attacka12,		demon1_atta13] {ai_frame(self.walkframe);ai_charge(5 + self.waitmax * 0.3);};
void()	demon1_atta13	=[	$attacka13,		demon1_atta14] {ai_frame(self.walkframe);ai_charge(8 + self.waitmax * 0.3);};
void()	demon1_atta14	=[	$attacka14,		demon1_atta15] {ai_frame(self.walkframe);ai_charge(4 + self.waitmax * 0.3);};
void()	demon1_atta15	=[	$attacka15,		demon1_run1] {ai_frame(self.walkframe);ai_charge(4 + self.waitmax * 0.3);};

void()	demon1_pain1	=[	$pain1,		demon1_pain2	] {ai_frame(self.walkframe);};
void()	demon1_pain2	=[	$pain2,		demon1_pain3	] {ai_frame(self.walkframe);};
void()	demon1_pain3	=[	$pain3,		demon1_pain4	] {ai_frame(self.walkframe);};
void()	demon1_pain4	=[	$pain4,		demon1_pain5	] {ai_frame(self.walkframe);};
void()	demon1_pain5	=[	$pain5,		demon1_pain6	] {ai_frame(self.walkframe);};
void()	demon1_pain6	=[	$pain6,		demon1_run1	] {ai_frame(self.walkframe);};


void(entity attacker, float damage)	demon1_pain =
{
	if (self.touch == Monster_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;

	self.cnt = 1;
	if (self.spawnflags & DEMON_SUPER)
	{
// check to see if super demon gets EXTRA mad
		if (!self.spawnflags & DEMON_SUPER_MAD)
		{
			if (self.health < 250)
			if (random() < 0.5)
				self.spawnflags = self.spawnflags | DEMON_SUPER_MAD;

			if (self.health < 50)
				self.spawnflags = self.spawnflags | DEMON_SUPER_MAD;

// just like the hulk - super ogre gets bigger & a health boost when going to extra mad
			if (self.spawnflags & DEMON_SUPER_MAD)
			{
				self.wad = "SUPER_XMAD";
				if ((random() < 0.25) || (self.health < 20))
					self.health = 800 + (200 * random()) + (200 * random());
				else
					self.health = self.health + 200 + (100 * random());
				self.max_health = self.health;

				self.waitmax = 6;
				self.walkframe = $semstand1;
			}
		}
// could make this one dangerous brute
		else
		if (random() < 0.33) // super_demon_emheal_chn)
			self.health = self.health + (100 * random()); // super_demon_emheal

		if (self.speed > mon_superspeedup_max)
		if (random() < mon_superspeed_chn)
		{
			self.speed  = self.speed - mon_superspeed_fact;
			if (self.speed < mon_superspeedup_max) self.speed = mon_superspeedup_max;
		}

		self.pain_finished = time + 1.5; // set a default

		if (self.spawnflags & DEMON_SUPER_MAD) return; // has frames, just not using

		if (random() > 0.75) return;

		self.cnt = 3;
	}

	self.pain_finished = time + self.cnt;
    sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);

	if (random()*200 > damage)
		return;		// didn't flinch

	demon1_pain1 ();
};

void()	demon1_die1		=[	$death1,		demon1_die2	] {ai_frame(self.walkframe);
sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);};
void()	demon1_die2		=[	$death2,		demon1_die3	] {ai_frame(self.walkframe);};
void()	demon1_die3		=[	$death3,		demon1_die4	] {ai_frame(self.walkframe);};
void()	demon1_die4		=[	$death4,		demon1_die5	] {ai_frame(self.walkframe);};
void()	demon1_die5		=[	$death5,		demon1_die6	] {ai_frame(self.walkframe);};
void()	demon1_die6		=[	$death6,		demon1_die7	]
{ai_frame(self.walkframe);self.solid = SOLID_NOT;};
void()	demon1_die7		=[	$death7,		demon1_die8	] {ai_frame(self.walkframe);};
void()	demon1_die8		=[	$death8,		demon1_die9	] {ai_frame(self.walkframe);};
void()	demon1_die9		=[	$death9,		demon1_die9 ] {ai_frame(self.walkframe);};
	
void() demon_die =
{
	self.dmg = -80;
	if (self.spawnflags & DEMON_DBL) self.dmg = -100;
	if (self.spawnflags & DEMON_SUPER) self.dmg = -350;

	if (self.flags & FL_DEMONBOOM) // heh heh - little enhancement, mostly for player morph
	{
		self.attack_finished = 0; // make sure we boom
		player_demon_explode();
		return;
	}

// check for gib
	if (self.health < self.dmg)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_demon.mdl", self.health);
		if (self.spawnflags & DEMON_SUPER) self.scale = 1.6;
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		return;
	}

// regular death
	demon1_die1 ();
};


void() Demon_MeleeAttack =
{
	demon1_atta1 ();
};




/*
==============
CheckDemonMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDemonMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDemonJump

==============
*/
float()	CheckDemonJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 100)
		return FALSE;
		
	if (d > 200)
	{
		if (random() < 0.9)
			return FALSE;
	}
		
	return TRUE;
};

float()	DemonCheckAttack =
{
//	local	vector	vec;
	
// if close enough for slashing, go for it
	if (CheckDemonMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDemonJump ())
	{
		self.attack_state = AS_MISSILE;
        sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

void(float side)	Demon_Melee =
{
	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

	self.dest = self.enemy.origin - self.origin;

	if (vlen(self.dest) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);

	if (self.spawnflags & DEMON_SUPER_MAD) self.dmg = 60 + 60*random();
	else
	if (self.spawnflags & DEMON_SUPER) self.dmg = 20 + 20*random();
	else
	self.dmg = 10 + 5*random();
	T_Damage (self.enemy, self, self, self.dmg);	

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
};

// CLEAN: move to monster.qc or fight.qc

void()	Monster_JumpTouch =
{
	if (self.health <= 0)
		return;

	if (self.classname == "monster_young")
	if (other.classname == self.classname)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > self.jump_flag) // 400 - demon, 300 - dog
		{
			if (self.spawnflags & DEMON_SUPER_MAD) self.dmg = 100 + 100*random();
			else
//			if (self.spawnflags & DEMON_SUPER) self.dmg = 80 + 40*random();
//			else
			self.dmg = self.dodmg + 10*random(); // 40 - demon, 10 - dog
			T_Damage (other, self, self, self.dmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = self._jump;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = self._jump2;
	self.nextthink = time + 0.1;
};


//============================================================================

// run double demon - 4 claws for 4x the fun


//============================================================================

// run super demon - 4 super claws for 4x the super fun


//============================================================================

// run extra mad demon stuff - "oh shit son"


//============================================================================

/*QUAKED monster_demon1 (1 0 0) (-32 -32 -24) (32 32 64) Ambush Double Super BOB MAD Boom 

--------  CAT  -------
"netname" - fast = fast ogre, slow = slow ogre
"speed" - 0.1 normal, 0.05 fast, 0.2 slow
"Double": double the demon, double the fun
"Super": mega demon - watch out, use with care
"BOB": use black orange beast

*/
void(float ign) monster_demon1 =
{

if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (!M_MONSTER & CB_M_DEMON)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

// make some more random monsters according to server rules - only do this on map spawned monsters, wont happen with random monsters
	if (R_FAST_MONSTER & CB_M_DEMON)
	if (random() < C_FS_MONSTER)
		speed_monster(CFAST, "monster_demon1", self.origin);
		
	if (R_SLOW_MONSTER & CB_M_DEMON)
	if (random() < C_FS_MONSTER)
		speed_monster(CSLOW, "monster_demon1", self.origin);

	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
}

// Cataboligne - 11.14.12 - fast / slow code
	if (self.speed <= 0) self.speed = MON_NORM;
	self.lip = 1; // local speed divisor
// map specced
	if (self.netname == CFAST) self.speed = MON_FAST;
	else if (self.netname == CSLOW) self.speed = MON_SLOW;

// server controls set all monsters fast or slow if not specced - this includes random monsters
	else if (FAST_MONSTER & CB_M_DEMON) self.speed = MON_FAST;
	else if (SLOW_MONSTER & CB_M_DEMON) self.speed = MON_SLOW;
 
	self.netname = "Fiend";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.walkframe = 0;
	self.waitmax = 0;

	setmodel (self, "progs/demon.mdl");

#ifdef enhanced
//	if (ENHANCED)
	if (ign == A_MONSTER)
	if (random() < 0.08) // super_demon_chance)
		self.spawnflags = self.spawnflags | DEMON_SUPER;
	else
	if (random() < 0.25) // dbl_demon_chance)
		self.spawnflags = self.spawnflags | DEMON_DBL;
#endifdef

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

// Cataboligne - 11.24.12 - super & double code
	if (self.spawnflags & DEMON_SUPER)
	{
		self.health = 600 + (100 * random()) + (100 * random());
		self.wad = "SUPER";

		self.walkframe = $superstand1;
		self.waitmax = 4;
// jumptouch multi
		self.dodmg = 90;
	}
	else
	if (self.spawnflags & DEMON_DBL)
	{
		self.health = 400;
		self.wad = "MEGA";

		self.walkframe = $dblstand1;
		self.waitmax = 2;
// jumptouch multi
		self.dodmg = 60;
	}
	else
	{
		self.health = 300;

// jumptouch multi
		self.dodmg = 40;
	}
	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;		// one of two attacks
	self.th_missile = demon1_jump1;			// jump attack
	self.th_pain = demon1_pain;

// jumptouch multi /b
	self.jump_flag = 400;
	self._jump = demon1_jump1;
	self._jump2 = demon1_jump11;

	walkmonster_start();
};

