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

void() blarg_stand1    = 
{
	self.frame =      $kikidl01;	self.nextthink = time + 0.1;	self.think =     blarg_stand2;	
	ai_stand();
	if (random() < 0.05)
		sound (self, CHAN_VOICE, "mon_II/blarg/bidle.wav", 1, ATTN_NORM);
	else if (random() < 0.1)
		sound (self, CHAN_VOICE, "mon_II/blarg/bidle2.wav", 1, ATTN_NORM);
};

void() blarg_stand2    = 
{
	self.frame =      $kikidl02;	self.nextthink = time + 0.1;	self.think =     blarg_stand3;	ai_stand();};
void() blarg_stand3    = 
{
	self.frame =      $kikidl03;	self.nextthink = time + 0.1;	self.think =     blarg_stand4;	ai_stand();};
void() blarg_stand4    = 
{
	self.frame =      $kikidl04;	self.nextthink = time + 0.1;	self.think =     blarg_stand5;	ai_stand();};
void() blarg_stand5    = 
{
	self.frame =      $kikidl05;	self.nextthink = time + 0.1;	self.think =     blarg_stand6;	ai_stand();};
void() blarg_stand6    = 
{
	self.frame =      $kikidl04;	self.nextthink = time + 0.1;	self.think =     blarg_stand7;	ai_stand();};
void() blarg_stand7    = 
{
	self.frame =      $kikidl03;	self.nextthink = time + 0.1;	self.think =     blarg_stand8;	ai_stand();};
void() blarg_stand8    = 
{
	self.frame =      $kikidl02;	self.nextthink = time + 0.1;	self.think =     blarg_stand1;	ai_stand();};

void() blarg_stop1     = 
{
	self.frame =      $kikdie01;	self.nextthink = time + 0.1;	self.think =     blarg_stop2     ] 
{
	sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
};
void() blarg_stop2     = 
{
	self.frame =      $kikdie02;	self.nextthink = time + 0.1;	self.think =     blarg_stop3;	};
void() blarg_stop3     = 
{
	self.frame =      $kikdie03;	self.nextthink = time + 0.1;	self.think =     blarg_stop4;	};
void() blarg_stop4     = 
{
	self.frame =      $kikdie04;	self.nextthink = time + 0.1;	self.think =     blarg_stop5;	};
void() blarg_stop5     = 
{
	self.frame =      $kikdie05;	self.nextthink = time + 0.1;	self.think =     blarg_stop6;	self.solid = SOLID_NOT;};
void() blarg_stop6     = 
{
	self.frame =      $kikdie06;	self.nextthink = time + 0.1;	self.think =     blarg_stop7;	};
void() blarg_stop7     = 
{
	self.frame =      $kikdie08;	self.nextthink = time + 0.1;	self.think =     blarg_stop7;	};

void() blarg_bstop1    = 
{
	self.frame =      $kikdib01;	self.nextthink = time + 0.1;	self.think =     blarg_bstop2    ] 
{
	sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
	ai_forward(16);
};
void() blarg_bstop2    = 
{
	self.frame =      $kikdib02;	self.nextthink = time + 0.1;	self.think =     blarg_bstop3;	ai_forward(14);};
void() blarg_bstop3    = 
{
	self.frame =      $kikdib03;	self.nextthink = time + 0.1;	self.think =     blarg_bstop4;	ai_forward(10);};
void() blarg_bstop4    = 
{
	self.frame =      $kikdib04;	self.nextthink = time + 0.1;	self.think =     blarg_bstop5;	ai_forward(5);};
void() blarg_bstop5    = 
{
	self.frame =      $kikdib05;	self.nextthink = time + 0.1;	self.think =     blarg_bstop6;	self.solid = SOLID_NOT;};
void() blarg_bstop6    = 
{
	self.frame =      $kikdib05;	self.nextthink = time + 0.1;	self.think =     blarg_bstop7;	};
void() blarg_bstop7    = 
{
	self.frame =      $kikdib05;	self.nextthink = time + 0.1;	self.think =     blarg_bstop7;	};


void() blarg_walk1     = 
{
	self.frame =      $kikwalk01;	self.nextthink = time + 0.1;	self.think =   blarg_walk2     ] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "mon_II/blarg/bidle.wav", 1, ATTN_IDLE);
	ai_walk(8);
};
void() blarg_walk2     = 
{
	self.frame =      $kikwalk02;	self.nextthink = time + 0.1;	self.think =   blarg_walk3;	ai_walk(16);};
void() blarg_walk3     = 
{
	self.frame =      $kikwalk03;	self.nextthink = time + 0.1;	self.think =   blarg_walk4;	ai_walk(16);};
void() blarg_walk4     = 
{
	self.frame =      $kikwalk04;	self.nextthink = time + 0.1;	self.think =   blarg_walk6;	ai_walk(8);};
void() blarg_walk6     = 
{
	self.frame =      $kikwalk05;	self.nextthink = time + 0.1;	self.think =   blarg_walk7;	ai_walk(16);};
void() blarg_walk7     = 
{
	self.frame =      $kikwalk06;	self.nextthink = time + 0.1;	self.think =   blarg_walk1;	ai_walk(16);};

void() blarg_run1      = 
{
	self.frame =      $kikatt12;	self.nextthink = time + 0.1;	self.think =    blarg_run2 ;	ai_run(0); ai_face();};
void() blarg_run2      = 
{
	self.frame =      $kikatt13;	self.nextthink = time + 0.1;	self.think =    blarg_run3 ;	ai_run(0); ai_face();};
void() blarg_run3      = 
{
	self.frame =      $kikatt14;	self.nextthink = time + 0.1;	self.think =    blarg_run4 ;	ai_run(10); ai_face();};
void() blarg_run4      = 
{
	self.frame =      $kikatt15;	self.nextthink = time + 0.1;	self.think =    blarg_run5      ] 
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
void() blarg_run5      = 
{
	self.frame =      $kikatt08;	self.nextthink = time + 0.1;	self.think =    blarg_run6 ;	};
void() blarg_run6      = 
{
	self.frame =      $kikatt09;	self.nextthink = time + 0.1;	self.think =    blarg_run7 ;	};
void() blarg_run7      = 
{
	self.frame =      $kikatt10;	self.nextthink = time + 0.1;	self.think =    blarg_run8 ;	};
void() blarg_run8      = 
{
	self.frame =      $kikatt11;	self.nextthink = time + 0.1;	self.think =    blarg_run1 ;	};

void() blarg_atta1     = 
{
	self.frame =      $kikatt13;	self.nextthink = time + 0.1;	self.think =     blarg_atta2;	ai_charge(10); ai_face();};
void() blarg_atta2     = 
{
	self.frame =      $kikatt14;	self.nextthink = time + 0.1;	self.think =     blarg_atta3;	ai_charge(10); ai_face();};
void() blarg_atta3     = 
{
	self.frame =      $kikatt15;	self.nextthink = time + 0.1;	self.think =     blarg_atta4;	ai_charge(10); blarg_bite();};
void() blarg_atta4     = 
{
	self.frame =      $kikatt16;	self.nextthink = time + 0.1;	self.think =     blarg_atta5     ] 
{
	sound (self, CHAN_VOICE, "mon_II/blarg/bjump2.wav", 1, ATTN_NORM);
	blarg_bite();
};
void() blarg_atta5     = 
{
	self.frame =      $kikatt17;	self.nextthink = time + 0.1;	self.think =     blarg_atta6;	ai_charge(10); blarg_bite();};
void() blarg_atta6     = 
{
	self.frame =      $kikatt18;	self.nextthink = time + 0.1;	self.think =     blarg_atta7;	ai_charge(10);};
void() blarg_atta7     = 
{
	self.frame =      $kikatt19;	self.nextthink = time + 0.1;	self.think =     blarg_atta8;	ai_charge(10);};
void() blarg_atta8     = 
{
	self.frame =      $kikatt20;	self.nextthink = time + 0.1;	self.think =     blarg_run1 ;	ai_charge(10);};

void() blarg_leap1     = 
{
	self.frame =      $kikatt20;	self.nextthink = time + 0.1;	self.think =             blarg_leap2;	ai_face();};
void() blarg_leap2     = 
{
	self.frame =      $kikatt21;	self.nextthink = time + 0.1;	self.think =             blarg_leap3;	ai_face();};
void() blarg_leap3     = 
{
	self.frame =      $kikatt22;	self.nextthink = time + 0.1;	self.think =             blarg_leap4     ]
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

void() blarg_leap4     = 
{
	self.frame =      $kikatt23;	self.nextthink = time + 0.1;	self.think =             blarg_leap5;	};
void() blarg_leap5     = 
{
	self.frame =      $kikatt24;	self.nextthink = time + 0.1;	self.think =             blarg_leap6;	};
void() blarg_leap6     = 
{
	self.frame =      $kikatt08;	self.nextthink = time + 0.1;	self.think =             blarg_run1;	};



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
