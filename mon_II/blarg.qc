/*
==============================================================================

BLARG

==============================================================================
*/
$cd /raid/quake/id1/models/blarg
$origin 0 0 24
$base base
$skin skin

$frame kikwalk01 kikwalk02 kikwalk03 kikwalk04 kikwalk05 kikwalk06 

$frame kikatt01 kikatt02 kikatt03 kikatt04 kikatt05 kikatt06 kikatt07 kikatt08 kikatt09 kikatt10
$frame kikatt11 kikatt12 kikatt13 kikatt14 kikatt15 kikatt16 kikatt17 kikatt18 kikatt19 kikatt20 kikatt21
$frame kikatt22 kikatt23 kikatt24

$frame kikdie01 kikdie02 kikdie03 kikdie04 kikdie05 kikdie06 kikdie08
$frame kikdib01 kikdib02 kikdib03 kikdib04 kikdib05

$frame kikidl01 kikidl02 kikidl03 kikidl04 kikidl05

void() blarg_leap1;
void() blarg_run8;
void() blarg_stop1;
void() blarg_bstop1;


void() blarg_bite =
{
	local vector delta;
	local float  ldmg;

	if (!self.enemy)
		return;

	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = (random() + random() + random()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
};

void()  Blarg_JumpTouch =
{
	local   float   ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 300 )
		{
			ldmg = 5 + 10*random();
			T_Damage (other, self, self, ldmg);     
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{       // jump randomly to not get hung up
			self.touch = SUB_Null;
			self.think = blarg_leap1;
			self.nextthink = time;
		}
		return; // not on ground yet
	}

	self.touch = SUB_Null;
	self.think = blarg_run8;
	self.nextthink = time;
};

//void(entity attacker, float damage)  blarg_pain =
void()  blarg_pain =
{
	if (self.touch == Blarg_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 3;
	sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);

	return;         // never flinches
};

void() blarg_stop =
{
	if (self.health < -100)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	if (random() > 0.4)
	{
		blarg_stop1 ();
		return;
	}
	else
	{
		self.movetype = MOVETYPE_BOUNCE;
		self.velocity_x = -50 + 100*random();
		self.velocity_y = -50 + 100*random();
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		blarg_bstop1 ();
	}
};

void() blarg_stand1     =[      $kikidl01,      blarg_stand2    ] {
	ai_stand();
	if (random() < 0.05)
		sound (self, CHAN_VOICE, "mon_II/blarg/bidle.wav", 1, ATTN_NORM);
	else if (random() < 0.1)
		sound (self, CHAN_VOICE, "mon_II/blarg/bidle2.wav", 1, ATTN_NORM);
};
void() blarg_stand2     =[      $kikidl02,      blarg_stand3    ] {ai_stand();};
void() blarg_stand3     =[      $kikidl03,      blarg_stand4    ] {ai_stand();};
void() blarg_stand4     =[      $kikidl04,      blarg_stand5    ] {ai_stand();};
void() blarg_stand5     =[      $kikidl05,      blarg_stand6    ] {ai_stand();};
void() blarg_stand6     =[      $kikidl04,      blarg_stand7    ] {ai_stand();};
void() blarg_stand7     =[      $kikidl03,      blarg_stand8    ] {ai_stand();};
void() blarg_stand8     =[      $kikidl02,      blarg_stand1    ] {ai_stand();};

void() blarg_stop1      =[      $kikdie01,      blarg_stop2     ] 
{
	sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
};
void() blarg_stop2      =[      $kikdie02,      blarg_stop3     ] {};
void() blarg_stop3      =[      $kikdie03,      blarg_stop4     ] {};
void() blarg_stop4      =[      $kikdie04,      blarg_stop5     ] {};
void() blarg_stop5      =[      $kikdie05,      blarg_stop6     ] {self.solid = SOLID_NOT;};
void() blarg_stop6      =[      $kikdie06,      blarg_stop7     ] {};
void() blarg_stop7      =[      $kikdie08,      blarg_stop7     ] {};

void() blarg_bstop1     =[      $kikdib01,      blarg_bstop2    ] 
{
	sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
	ai_forward(16);
};
void() blarg_bstop2     =[      $kikdib02,      blarg_bstop3    ] {ai_forward(14);};
void() blarg_bstop3     =[      $kikdib03,      blarg_bstop4    ] {ai_forward(10);};
void() blarg_bstop4     =[      $kikdib04,      blarg_bstop5    ] {ai_forward(5);};
void() blarg_bstop5     =[      $kikdib05,      blarg_bstop6    ] {self.solid = SOLID_NOT;};
void() blarg_bstop6     =[      $kikdib05,      blarg_bstop7    ] {};
void() blarg_bstop7     =[      $kikdib05,      blarg_bstop7    ] {};


void() blarg_walk1      =[      $kikwalk01 ,    blarg_walk2     ] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "mon_II/blarg/bidle.wav", 1, ATTN_IDLE);
	ai_walk(8);
};
void() blarg_walk2      =[      $kikwalk02 ,    blarg_walk3     ] {ai_walk(16);};
void() blarg_walk3      =[      $kikwalk03 ,    blarg_walk4     ] {ai_walk(16);};
void() blarg_walk4      =[      $kikwalk04 ,    blarg_walk6     ] {ai_walk(8);};
void() blarg_walk6      =[      $kikwalk05 ,    blarg_walk7     ] {ai_walk(16);};
void() blarg_walk7      =[      $kikwalk06 ,    blarg_walk1     ] {ai_walk(16);};

void() blarg_run1       =[      $kikatt12 ,     blarg_run2      ] {ai_run(0); ai_face();};
void() blarg_run2       =[      $kikatt13 ,     blarg_run3      ] {ai_run(0); ai_face();};
void() blarg_run3       =[      $kikatt14 ,     blarg_run4      ] {ai_run(10); ai_face();};
void() blarg_run4       =[      $kikatt15 ,     blarg_run5      ] 
{
	ai_face();
	
	self.touch = Blarg_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 400 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	sound (self, CHAN_VOICE, "mon_II/blarg/bjump.wav", 1, ATTN_NORM);
	return;
};
void() blarg_run5       =[      $kikatt08 ,     blarg_run6      ] {};
void() blarg_run6       =[      $kikatt09 ,     blarg_run7      ] {};
void() blarg_run7       =[      $kikatt10 ,     blarg_run8      ] {};
void() blarg_run8       =[      $kikatt11 ,     blarg_run1      ] {};

void() blarg_atta1      =[      $kikatt13,      blarg_atta2     ] {ai_charge(10); ai_face();};
void() blarg_atta2      =[      $kikatt14,      blarg_atta3     ] {ai_charge(10); ai_face();};
void() blarg_atta3      =[      $kikatt15,      blarg_atta4     ] {ai_charge(10); blarg_bite();};
void() blarg_atta4      =[      $kikatt16,      blarg_atta5     ] 
{
	sound (self, CHAN_VOICE, "mon_II/blarg/bjump2.wav", 1, ATTN_NORM);
	blarg_bite();
};
void() blarg_atta5      =[      $kikatt17,      blarg_atta6     ] {ai_charge(10); blarg_bite();};
void() blarg_atta6      =[      $kikatt18,      blarg_atta7     ] {ai_charge(10);};
void() blarg_atta7      =[      $kikatt19,      blarg_atta8     ] {ai_charge(10);};
void() blarg_atta8      =[      $kikatt20,      blarg_run1      ] {ai_charge(10);};

void() blarg_leap1      =[      $kikatt20,              blarg_leap2     ] {ai_face();};
void() blarg_leap2      =[      $kikatt21,              blarg_leap3     ] {ai_face();};
void() blarg_leap3      =[      $kikatt22,              blarg_leap4     ]
{
	ai_face();
	
	self.touch = Blarg_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
	self.flags = self.flags - FL_ONGROUND;
	sound (self, CHAN_VOICE, "mon_II/blarg/bjump.wav", 1, ATTN_NORM);
};

void() blarg_leap4      =[      $kikatt23,              blarg_leap5     ] {};
void() blarg_leap5      =[      $kikatt24,              blarg_leap6     ] {};
void() blarg_leap6      =[      $kikatt08,              blarg_run1      ] {};



//============================================================================

/*
==============
CheckBlargMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float() CheckBlargMelee =
{
	if (enemy_range == RANGE_MELEE)
	{       // FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};


float() CheckBlargJump =
{
	local   vector  dist;
	local   float   d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + 
	    self.enemy.mins_z + 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + 
	    self.enemy.mins_z + 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 80)
		return FALSE;
		
	if (d > 150)
		return FALSE;
		
	return TRUE;
};

float() BlargCheckAttack =
{
//	local   vector  vec;
	
	// if close enough for slashing, go for it
	if (CheckBlargMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckBlargJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};


//string(entity targ, entity attacker) blarg_killmsg =
string() blarg_killmsg =
{
	if (random() < 0.5 || !ENHANCED)
		return " was ripped apart by a  ";
	else if (random() < 0.8)
		return " bot viscerally mauled a ";
	else
	{
		return(" found out Blargs dont make good pets.\n");
	}
};

//===========================================================================

/*QUAKED monster_blarg (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void(float ign) monster_blarg =
{

if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (!M_MONSTER_II & CB_M_ARMY)
	if (deathmatch)
//		if (deathmatch != 4)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}	

	precache_model ("progs/blarg.mdl");

	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/sight2.wav");
	precache_sound ("mon_II/blarg/bidle.wav");
	precache_sound ("mon_II/blarg/bidle2.wav");
	precache_sound ("mon_II/blarg/bjump.wav");
	precache_sound ("mon_II/blarg/bjump2.wav");
	precache_sound ("demon/ddeath.wav");
}

// Cataboligne - 11.14.12 - fast / slow code
	if (self.speed <= 0) self.speed = MON_NORM;
	self.lip = 1; // local speed divisor
// map specced
	if (self.netname == CFAST) self.speed = MON_FAST;
	else if (self.netname == CSLOW) self.speed = MON_SLOW;

	self.netname = "Blarg";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/blarg.mdl");

	setsize (self, '-16 -35 -24', '16 35 20');
	self.health = 180;

	self.th_stand = blarg_stand1;
	self.th_walk = blarg_walk1;
	self.th_run = blarg_run1;
	self.th_melee = blarg_atta1;
	self.th_missile = blarg_leap1;
	self.th_pain = blarg_pain;
	self.th_die = blarg_stop;
	self.pain_finished = time + 3;
	self._killmsg = blarg_killmsg;

	walkmonster_start();
};
