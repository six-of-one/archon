/*
==============================================================================

DOG

==============================================================================
*/
$cd id1/models/dog
$origin 0 0 24
$base base
$skin skin

// dog - woof woof
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame sleep1 sleep2 sleep3 sleep4

// two headed dog - woof woof - woof woof

$frame thattack1 thattack2 thattack3 thattack4 thattack5 thattack6 thattack7 thattack8

$frame thdeath1 thdeath2 thdeath3 thdeath4 thdeath5 thdeath6 thdeath7 thdeath8 thdeath9

// placeholder for addative
$frame dummyb1 dummyb2 dummyb3 dummyb4 dummyb5 dummyb6 dummyb7 dummyb8
$frame dummyb9

$frame thpain1 thpain2 thpain3 thpain4 thpain5 thpain6

// placeholder for addative
$frame fakeb1 fakeb2 fakeb3 fakeb4 fakeb5 fakeb6 fakeb7 fakeb8 fakeb9 fakeb10
$frame fakeb11 fakeb12 fakeb13 fakeb14 fakeb15 fakeb16

$frame thrun1 thrun2 thrun3 thrun4 thrun5 thrun6 thrun7 thrun8 thrun9 thrun10 thrun11 thrun12

$frame thleap1 thleap2 thleap3 thleap4 thleap5 thleap6 thleap7 thleap8 thleap9

$frame thstand1 thstand2 thstand3 thstand4 thstand5 thstand6 thstand7 thstand8 thstand9

$frame thwalk1 thwalk2 thwalk3 thwalk4 thwalk5 thwalk6 thwalk7 thwalk8

$frame thsleep1 thsleep2 thsleep3 thsleep4

// Fluffy - WOOF WOOF - WOOF WOOF - WOOF WOOF!

$frame rxattack1 rxattack2 rxattack3 rxattack4 rxattack5 rxattack6 rxattack7 rxattack8

$frame rxdeath1 rxdeath2 rxdeath3 rxdeath4 rxdeath5 rxdeath6 rxdeath7 rxdeath8 rxdeath9

// placeholder for addative
$frame dummyc1 dummyc2 dummyc3 dummyc4 dummyc5 dummyc6 dummyc7 dummyc8
$frame dummyc9

$frame fakepc1 fakepc2 fakepc3 fakepc4 fakepc5 fakepc6

$frame faked1 faked2 faked3 faked4 faked5 faked6 faked7 faked8 faked9 faked10
$frame faked11 faked12 faked13 faked14 faked15 faked16


$frame rxrun1 rxrun2 rxrun3 rxrun4 rxrun5 rxrun6 rxrun7 rxrun8 rxrun9 rxrun10 rxrun11 rxrun12

$frame rxleap1 rxleap2 rxleap3 rxleap4 rxleap5 rxleap6 rxleap7 rxleap8 rxleap9

$frame rxstand1 rxstand2 rxstand3 rxstand4 rxstand5 rxstand6 rxstand7 rxstand8 rxstand9

$frame rxwalk1 rxwalk2 rxwalk3 rxwalk4 rxwalk5 rxwalk6 rxwalk7 rxwalk8

$frame rxsleep1 rxsleep2 rxsleep3 rxsleep4

$frame rxlaydown1 rxlaydown2 rxlaydown3 rxlaydown4 rxlaydown5

$frame rxlaytorun1

// end dog framing


void() dog_leap1;
void() dog_run1;

/*
================
dog_bite

================
*/
void() dog_bite =
{
	if (!self.enemy)
		return;

	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	self.dest = self.enemy.origin - self.origin;

	if (vlen(self.dest) > 100)
		return;

	self.dmg = (random() + random() + random()) * 8;
	if (self.spawnflags & 4) self.dmg = self.dmg * 1.8;
	T_Damage (self.enemy, self, self, self.dmg);
};


/*
deprecated to Monster_JumpTouch

void()	Dog_JumpTouch =
{
	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if (vlen(self.velocity) > 300)
		{
			self.dmg = 10 + 10*random();
			T_Damage (other, self, self, self.dmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = dog_leap1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = dog_run1;
	self.nextthink = time + 0.1;
};
*/


void() dog_stand1	=[	$stand1,	dog_stand2	] {ai_stand();};
void() dog_stand2	=[	$stand2,	dog_stand3	] {ai_stand();};
void() dog_stand3	=[	$stand3,	dog_stand4	] {ai_stand();};
void() dog_stand4	=[	$stand4,	dog_stand5	] {ai_stand();};
void() dog_stand5	=[	$stand5,	dog_stand6	] {ai_stand();};
void() dog_stand6	=[	$stand6,	dog_stand7	] {ai_stand();};
void() dog_stand7	=[	$stand7,	dog_stand8	] {ai_stand();};
void() dog_stand8	=[	$stand8,	dog_stand9	] {ai_stand();};
void() dog_stand9	=[	$stand9,	dog_stand1	] {ai_stand();};

void() dog_walk1	=[	$walk1 ,	dog_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_walk(8);};
void() dog_walk2	=[	$walk2 ,	dog_walk3	] {ai_walk(8 + self.waitmax);};
void() dog_walk3	=[	$walk3 ,	dog_walk4	] {ai_walk(8 + self.waitmax);};
void() dog_walk4	=[	$walk4 ,	dog_walk5	] {ai_walk(8 + self.waitmax);};
void() dog_walk5	=[	$walk5 ,	dog_walk6	] {ai_walk(8 + self.waitmax);};
void() dog_walk6	=[	$walk6 ,	dog_walk7	] {ai_walk(8 + self.waitmax);};
void() dog_walk7	=[	$walk7 ,	dog_walk8	] {ai_walk(8 + self.waitmax);};
void() dog_walk8	=[	$walk8 ,	dog_walk1	] {ai_walk(8 + self.waitmax);};

void() dog_run1		=[	$run1  ,	dog_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_run(16);};
void() dog_run2		=[	$run2  ,	dog_run3	] {ai_run(32 + self.waitmax);};
void() dog_run3		=[	$run3  ,	dog_run4	] {ai_run(32 + self.waitmax);};
void() dog_run4		=[	$run4  ,	dog_run5	] {ai_run(20 + self.waitmax);};
void() dog_run5		=[	$run5  ,	dog_run6	]
{
	ai_run(64);

// fluffy can summon more dogs

//	if (self.frame == $run5)
	if (self.spawnflags & 4)
	if ((time & SV_CKTIME) == SV_CKTIME)
	if (random() < 0.25)
		SummonMonster("monster_dog");
};
void() dog_run6		=[	$run6  ,	dog_run7	] {ai_run(32 + self.waitmax);};
void() dog_run7		=[	$run7  ,	dog_run8	] {ai_run(16 + self.waitmax);};
void() dog_run8		=[	$run8  ,	dog_run9	] {ai_run(32 + self.waitmax);};
void() dog_run9		=[	$run9  ,	dog_run10	] {ai_run(32 + self.waitmax);};
void() dog_run10	=[	$run10  ,	dog_run11	] {ai_run(20 + self.waitmax);};
void() dog_run11	=[	$run11  ,	dog_run12	] {ai_run(64);};
void() dog_run12	=[	$run12  ,	dog_run1	] {ai_run(32 + self.waitmax);};

void() dog_atta1	=[	$attack1,	dog_atta2	] {ai_charge(10 + self.waitmax); ai_frame(self.walkframe);};
void() dog_atta2	=[	$attack2,	dog_atta3	] {ai_charge(10 + self.waitmax); ai_frame(self.walkframe);};
void() dog_atta3	=[	$attack3,	dog_atta4	] {ai_charge(10 + self.waitmax); ai_frame(self.walkframe);};
void() dog_atta4	=[	$attack4,	dog_atta5	]
{
	ai_frame(self.walkframe);
	sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);
	dog_bite();
};
void() dog_atta5	=[	$attack5,	dog_atta6	]
{
	ai_charge(10 + self.waitmax);
	ai_frame(self.walkframe);
	if (self.spawnflags & 6) dog_bite(); // 2 or 3 head - 2nd bite
};
void() dog_atta6	=[	$attack6,	dog_atta7	]
{
	ai_charge(10 + self.waitmax);
	ai_frame(self.walkframe);
	if (self.spawnflags & 4) // fluffy sometimes gets 3rd bite
	if (random() < 0.3)
		dog_bite();
};
void() dog_atta7	=[	$attack7,	dog_atta8	] {ai_charge(10 + self.waitmax); ai_frame(self.walkframe);};
void() dog_atta8	=[	$attack8,	dog_run1	] {ai_charge(10 + self.waitmax); ai_frame(self.walkframe);};

void() dog_leap1	=[	$leap1,		dog_leap2	] {ai_face(); ai_frame(self.walkframe);};
void() dog_leap2	=[	$leap2,		dog_leap3	]
{
	ai_frame(self.walkframe);
	ai_face();
	
	self.touch = Monster_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() dog_leap3	=[	$leap3,		dog_leap4	] {ai_frame(self.walkframe);};
void() dog_leap4	=[	$leap4,		dog_leap5	] {ai_frame(self.walkframe);};
void() dog_leap5	=[	$leap5,		dog_leap6	] {ai_frame(self.walkframe);};
void() dog_leap6	=[	$leap6,		dog_leap7	] {ai_frame(self.walkframe);};
void() dog_leap7	=[	$leap7,		dog_leap8	] {ai_frame(self.walkframe);};
void() dog_leap8	=[	$leap8,		dog_leap9	] {ai_frame(self.walkframe);};
void() dog_leap9	=[	$leap9,		dog_leap9	] {ai_frame(self.walkframe);};

void() dog_pain1	=[	$pain1 ,	dog_pain2	] {ai_frame(self.walkframe);};
void() dog_pain2	=[	$pain2 ,	dog_pain3	] {ai_frame(self.walkframe);};
void() dog_pain3	=[	$pain3 ,	dog_pain4	] {ai_frame(self.walkframe);};
void() dog_pain4	=[	$pain4 ,	dog_pain5	] {ai_frame(self.walkframe);};
void() dog_pain5	=[	$pain5 ,	dog_pain6	] {ai_frame(self.walkframe);};
void() dog_pain6	=[	$pain6 ,	dog_run1	] {ai_frame(self.walkframe);};

// b pain frames do not exist for two head or fluffy

void() dog_painb1	=[	$painb1 ,	dog_painb2	] {};
void() dog_painb2	=[	$painb2 ,	dog_painb3	] {};
void() dog_painb3	=[	$painb3 ,	dog_painb4	] {ai_pain(4);};
void() dog_painb4	=[	$painb4 ,	dog_painb5	] {ai_pain(12);};
void() dog_painb5	=[	$painb5 ,	dog_painb6	] {ai_pain(12);};
void() dog_painb6	=[	$painb6 ,	dog_painb7	] {ai_pain(2);};
void() dog_painb7	=[	$painb7 ,	dog_painb8	] {};
void() dog_painb8	=[	$painb8 ,	dog_painb9	] {ai_pain(4);};
void() dog_painb9	=[	$painb9 ,	dog_painb10	] {};
void() dog_painb10	=[	$painb10 ,	dog_painb11	] {ai_pain(10);};
void() dog_painb11	=[	$painb11 ,	dog_painb12	] {};
void() dog_painb12	=[	$painb12 ,	dog_painb13	] {};
void() dog_painb13	=[	$painb13 ,	dog_painb14	] {};
void() dog_painb14	=[	$painb14 ,	dog_painb15	] {};
void() dog_painb15	=[	$painb15 ,	dog_painb16	] {};
void() dog_painb16	=[	$painb16 ,	dog_run1	] {};

void() dog_pain =
{
	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);

	if (self.spawnflags & 4) // FLUFFY
	{
		if ((random() < 0.1) || (self.health < 60))
			self.health = self.health + (30 * random());
		if (random() < 0.05)
			self.health = self.health + (30 * random());
//		self.max_health = self.health;
		dog_walk4(); // has no pain frames
		return;
	}

	if ((random() > 0.5) || (self.walkframe > 0))
		dog_pain1 ();
	else
		dog_painb1 ();
};

void() dog_die1		=[	$death1,	dog_die2	] {ai_frame(self.walkframe);};
void() dog_die2		=[	$death2,	dog_die3	] {ai_frame(self.walkframe);};
void() dog_die3		=[	$death3,	dog_die4	] {ai_frame(self.walkframe);};
void() dog_die4		=[	$death4,	dog_die5	] {ai_frame(self.walkframe);};
void() dog_die5		=[	$death5,	dog_die6	] {ai_frame(self.walkframe);};
void() dog_die6		=[	$death6,	dog_die7	] {ai_frame(self.walkframe);};
void() dog_die7		=[	$death7,	dog_die8	] {ai_frame(self.walkframe);};
void() dog_die8		=[	$death8,	dog_die9	] {ai_frame(self.walkframe);};
void() dog_die9		=[	$death9,	dog_die9	] {ai_frame(self.walkframe);};

void() dog_dieb1		=[	$deathb1,	dog_dieb2	] {ai_frame(self.walkframe);};
void() dog_dieb2		=[	$deathb2,	dog_dieb3	] {ai_frame(self.walkframe);};
void() dog_dieb3		=[	$deathb3,	dog_dieb4	] {ai_frame(self.walkframe);};
void() dog_dieb4		=[	$deathb4,	dog_dieb5	] {ai_frame(self.walkframe);};
void() dog_dieb5		=[	$deathb5,	dog_dieb6	] {ai_frame(self.walkframe);};
void() dog_dieb6		=[	$deathb6,	dog_dieb7	] {ai_frame(self.walkframe);};
void() dog_dieb7		=[	$deathb7,	dog_dieb8	] {ai_frame(self.walkframe);};
void() dog_dieb8		=[	$deathb8,	dog_dieb9	] {ai_frame(self.walkframe);};
void() dog_dieb9		=[	$deathb9,	dog_dieb9	] {ai_frame(self.walkframe);};


void() dog_die =
{
	self.dmg = -35;
	if (self.spawnflags & 4) self.dmg = -100;

// check for gib
	if (self.health < self.dmg)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		if (self.spawnflags & 2)
		{
			ThrowGib ("progs/h_dog.mdl", self.health);
			newmis.nextthink = time + 60 + random()*60;
		}

		ThrowHead ("progs/h_dog.mdl", self.health);
		if (self.spawnflags & 4)
		{
			self.scale = 2;
			ThrowGib ("progs/h_dog.mdl", self.health);
			newmis.scale = 2;
			newmis.nextthink = time + 60 + random()*60;
			ThrowGib ("progs/h_dog.mdl", self.health);
			newmis.scale = 2;
			newmis.nextthink = time + 60 + random()*60;
		}
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	 if ((random() > 0.5) || self.walkframe > 0)
		dog_die1 ();
	else
		dog_dieb1 ();
};

//============================================================================

/*
==============
CheckDogMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDogMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
//		self.attack_state = AS_MELEE; // redundant code
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDogJump

==============
*/
float()	CheckDogJump =
{

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	self.dest = self.enemy.origin - self.origin;
	self.dest_z = 0;
	
	self.cnt = vlen(self.dest);
	
	if (self.cnt < 80)
		return FALSE;
		
	if (self.cnt > 150)
		return FALSE;
		
	return TRUE;
};

float()	DogCheckAttack =
{
//	local	vector	vec;
	
// if close enough for slashing, go for it
	if (CheckDogMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDogJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

/*QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 40) Ambush TWOHEAD FLUFFY

"TwoHead" - two heads are better than one, double health, double attacks
"Fluffy" - oh crap.  Cerebus - 3 heads, large, demon leap attack

*/
void(float ign) monster_dog =
{

if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (!M_MONSTER & CB_M_DOG)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

// make some more random monsters according to server rules - only do this on map spawned monsters, wont happen with random monsters
	if (R_FAST_MONSTER & CB_M_DOG)
	if (random() < C_FS_MONSTER)
		speed_monster(CFAST, "monster_dog", self.origin);
		
	if (R_SLOW_MONSTER & CB_M_DOG)
	if (random() < C_FS_MONSTER)
		speed_monster(CSLOW, "monster_dog", self.origin);

	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog.mdl");

	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");
}

// Cataboligne - 11.14.12 - fast / slow code
	if (self.speed <= 0) self.speed = MON_NORM;
	self.lip = 1; // local speed divisor
// map specced
	if (self.netname == CFAST) self.speed = MON_FAST;
	else if (self.netname == CSLOW) self.speed = MON_SLOW;

// server controls set all monsters fast or slow if not specced - this includes random monsters
	else if (FAST_MONSTER & CB_M_DOG) self.speed = MON_FAST;
	else if (SLOW_MONSTER & CB_M_DOG) self.speed = MON_SLOW;

	self.netname = "Doggy";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.walkframe = 0;

	setmodel (self, "progs/dog.mdl");

	setsize (self, '-32 -32 -24', '32 32 40'); // slight smaller than VEC_HULL2
	self.health = 25;

	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;

// jumptouch multi
	self._jump = dog_leap1;
	self._jump2 = dog_run1;
	self.jump_flag = 300;
	self.dodmg = 10;

//	local float chance;
	enhance = FALSE;

#ifdef enhanced
//	if (ENHANCED)
	if (ENH_Q1_MAP_MONSTERS || (ign == A_MONSTER))
		enhance = TRUE;
#endifdef

	self.waitmax = 0;
	self.walkframe = 0;

	if ((enhance) || (self.spawnflags & 6))
	{
		chance = 0.2;
		if (skill == 3) chance = 0.4;
		if (ign == A_MONSTER) chance = 0.8;

		if (!self.spawnflags & 6) // not map specced - enhance him
		if (random() < chance)
		{
			enhance = 2; // TWOHEAD
			self.spawnflags = self.spawnflags | enhance; // fluffy is NOT an upgrade option
		}

#ifdef testset
		if (random() < 0.1) self.spawnflags = 4; // test a fluffy
#endifdef

		if (self.spawnflags & 4) // FLUFFY
		{
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.health = 300;
			self.walkframe = $rxattack1;
			self.wad = "SUPER";
			self.waitmax = 4;
			self.dodmg = 30; // jump touch damage
		}
		else if (self.spawnflags & 2) // two head
		{
			self.health = 50;
			self.walkframe = $thattack1;
			self.waitmax = 2;
		}
	}

	walkmonster_start();
};
