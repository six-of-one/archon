/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight2
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

float HK_STATUE = 2; // rogue
float DK = 4; // death knight - based on mod by Patrick Martin : cimartin@flash.net

//float dk_rnd = 0.8; // total chance for a better random hknight
//float dk_imp = 0.2; // total chance for a better map hknight
//float dk_track = 0.4; // chance a straight shot will be trackers
//float dk_track_dmg = 20; // damage done by tracker
float DK_FIRE_TRACK = -62346; // fire tracking flares this attack

void() hknight_char_a1;
void() hknight_run1;
void() hk_idle_sound;
//-------------------------------------------------------- Martin Code -----
void() hknight_char_b1;
void() DK_SwordSwing;
void() DK_CheckForSwing;
void() DK_HellKnight_ChooseMagic;
void(float offset) DK_Vertical;
void(float tr) DK_Straight;
void() DK_DeathBlow;
//--------------------------------------------------------------------------

void(float offset) hknight_shot =
{
	local	vector	org, vec;
	
	self.dest = vectoangles (self.enemy.origin - self.origin);
	self.dest_y = self.dest_y + offset * 6;
	
	makevectors (self.dest);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	
	launch_spike (org, vec);
	newmis.classname = "knightspike";
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec*300;

	if (self.spawnflags & DK)
	{
//-------------------------------------------------------- Martin Code -----
//  Faster flares on higher skill levels.
        if (skill > 2)          newmis.velocity = vec * 500;
        else if (skill > 1)     newmis.velocity = vec * 400;
//--------------------------------------------------------------------------
	}
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

void() CheckForCharge =
{
// check for mad charge
if (!enemy_vis)
	return;
if (time < self.attack_finished)
	return;	
if (fabs(self.origin_z - self.enemy.origin_z) > 20)
	return;		// too much height change
if (vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

//-------------------------------------------------------- Martin Code -----
//  This lets the death knight break the charge on Nightmare.
	if (self.spawnflags & DK)
	if (skill > 2)
	if (random() < 0.5) 
		return;
//--------------------------------------------------------------------------

// charge		
	SUB_AttackFinished (2);
	hknight_char_a1 ();

//-------------------------------------------------------- Martin Code -----
	if (self.spawnflags & DK)
	if (random() < 0.5)
		 hknight_char_b1 ();
//--------------------------------------------------------------------------
};

void() CheckContinueCharge =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (3);
		hknight_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

//===========================================================================


void()	hknight_stand1	=[	$stand1,	hknight_stand1	]
{
	if ((self.duration < $stand1) || (self.duration > $stand8))
	{
		self.duration = $stand1;
	}
	else self.duration = self.duration + 1;

	self.frame = self.duration;

	if (self.frame == $stand5)
	if (SV_MINEALLOW & CB_M_HKNIGHT)
	if (self.spawnflags & DK)
	if ((time & SV_CKTIME) == SV_CKTIME)
	if (random() < 0.25)
		SummonMonster(null_string);

	ai_stand();
};

/*
void()	hknight_stand1	=[	$stand1,	hknight_stand2	] {ai_stand();};
void()	hknight_stand2	=[	$stand2,	hknight_stand3	] {ai_stand();};
void()	hknight_stand3	=[	$stand3,	hknight_stand4	] {ai_stand();};
void()	hknight_stand4	=[	$stand4,	hknight_stand5	] {ai_stand();};
void()	hknight_stand5	=[	$stand5,	hknight_stand6	]
{
	ai_stand();

	if (SV_MINEALLOW & CB_M_HKNIGHT)
	if (self.spawnflags & DK)
	if ((time & SV_CKTIME) == SV_CKTIME)
	if (random() < 0.5)
		SummonMonster(null_string);
};
void()	hknight_stand6	=[	$stand6,	hknight_stand7	] {ai_stand();};
void()	hknight_stand7	=[	$stand7,	hknight_stand8	] {ai_stand();};
void()	hknight_stand8	=[	$stand8,	hknight_stand9	] {ai_stand();};
void()	hknight_stand9	=[	$stand9,	hknight_stand1	] {ai_stand();};
*/

//===========================================================================

void()	hknight_walk1	=[	$walk1,		hknight_walk2	] {
hk_idle_sound();
ai_walk(2);};
void()	hknight_walk2	=[	$walk2,		hknight_walk3	] {ai_walk(5);};
void()	hknight_walk3	=[	$walk3,		hknight_walk4	] {ai_walk(5);};
void()	hknight_walk4	=[	$walk4,		hknight_walk5	] {ai_walk(4);};
void()	hknight_walk5	=[	$walk5,		hknight_walk6	] {ai_walk(4);};
void()	hknight_walk6	=[	$walk6,		hknight_walk7	]
{
	ai_walk(2);

	if (SV_MINEALLOW & CB_M_HKNIGHT)
	if (self.spawnflags & DK)
	if ((time & SV_CKTIME) == SV_CKTIME)
		SummonMonster(null_string);
};
void()	hknight_walk7	=[	$walk7,		hknight_walk8	] {ai_walk(2);};
void()	hknight_walk8	=[	$walk8,		hknight_walk9	] {ai_walk(3);};
void()	hknight_walk9	=[	$walk9,		hknight_walk10	] {ai_walk(3);};
void()	hknight_walk10	=[	$walk10,	hknight_walk11	] {ai_walk(4);};
void()	hknight_walk11	=[	$walk11,	hknight_walk12	] {ai_walk(3);};
void()	hknight_walk12	=[	$walk12,	hknight_walk13	] {ai_walk(4);};
void()	hknight_walk13	=[	$walk13,	hknight_walk14	] {ai_walk(6);};
void()	hknight_walk14	=[	$walk14,	hknight_walk15	] {ai_walk(2);};
void()	hknight_walk15	=[	$walk15,	hknight_walk16	] {ai_walk(2);};
void()	hknight_walk16	=[	$walk16,	hknight_walk17	] {ai_walk(4);};
void()	hknight_walk17	=[	$walk17,	hknight_walk18	] {ai_walk(3);};
void()	hknight_walk18	=[	$walk18,	hknight_walk19	] {ai_walk(3);};
void()	hknight_walk19	=[	$walk19,	hknight_walk20	] {ai_walk(3);};
void()	hknight_walk20	=[	$walk20,	hknight_walk1	] {ai_walk(2);};

//===========================================================================

void()	hknight_run1	=[	$run1,		hknight_run2	] {
hk_idle_sound();
ai_run (20); CheckForCharge (); };
void()	hknight_run2	=[	$run2,		hknight_run3	] {ai_run(25);};
void()	hknight_run3	=[	$run3,		hknight_run4	] {ai_run(18);};
void()	hknight_run4	=[	$run4,		hknight_run5	] {ai_run(16);};
void()	hknight_run5	=[	$run5,		hknight_run6	]
{
	if (self.spawnflags & DK)
	if ((time & SV_CKTIME) == SV_CKTIME)
	{
		self.count = cnt_ent(world, "owner",  "monster_knight");
		if (self.count < 4 + skill)
		if (random() < 0.15) SummonMonster("monster_knight");
	}
	ai_run(14);
};
void()	hknight_run6	=[	$run6,		hknight_run7	] {ai_run(25);};
void()	hknight_run7	=[	$run7,		hknight_run8	] {ai_run(21);};
void()	hknight_run8	=[	$run8,		hknight_run1	] {ai_run(13);};

//============================================================================

void()	hknight_pain1	=[	$pain1,		hknight_pain2	] {sound (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);};
void()	hknight_pain2	=[	$pain2,		hknight_pain3	] {};
void()	hknight_pain3	=[	$pain3,		hknight_pain4	] {};
void()	hknight_pain4	=[	$pain4,		hknight_pain5	] {};
void()	hknight_pain5	=[	$pain5,		hknight_run1	] {};

//============================================================================

void()	hknight_die1	=[	$death1,	hknight_die2	] {ai_forward(10);};
void()	hknight_die2	=[	$death2,	hknight_die3	] {ai_forward(8);};
void()	hknight_die3	=[	$death3,	hknight_die4	]
{self.solid = SOLID_NOT; ai_forward(7);};
void()	hknight_die4	=[	$death4,	hknight_die5	] {};
void()	hknight_die5	=[	$death5,	hknight_die6	] {};
void()	hknight_die6	=[	$death6,	hknight_die7	] {};
void()	hknight_die7	=[	$death7,	hknight_die8	] {};
void()	hknight_die8	=[	$death8,	hknight_die9	] {ai_forward(10);};
void()	hknight_die9	=[	$death9,	hknight_die10	] {ai_forward(11);};
void()	hknight_die10	=[	$death10,	hknight_die11	] {};
void()	hknight_die11	=[	$death11,	hknight_die12	] {};
void()	hknight_die12	=[	$death12,	hknight_die12	] {};

void()	hknight_dieb1	=[	$deathb1,	hknight_dieb2	] {};
void()	hknight_dieb2	=[	$deathb2,	hknight_dieb3	] {};
void()	hknight_dieb3	=[	$deathb3,	hknight_dieb4	]
{self.solid = SOLID_NOT;};
void()	hknight_dieb4	=[	$deathb4,	hknight_dieb5	] {};
void()	hknight_dieb5	=[	$deathb5,	hknight_dieb6	] {};
void()	hknight_dieb6	=[	$deathb6,	hknight_dieb7	] {};
void()	hknight_dieb7	=[	$deathb7,	hknight_dieb8	] {};
void()	hknight_dieb8	=[	$deathb8,	hknight_dieb9	] {};
void()	hknight_dieb9	=[	$deathb9,	hknight_dieb9	] {};

void() hknight_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_hellkn.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "hknight/death1.wav", 1, ATTN_NORM);
	if (random() > 0.5)
		hknight_die1 ();
	else
		hknight_dieb1 ();
};


//============================================================================

void()	hknight_magica1 =[	$magica1,	hknight_magica2	] {ai_face();};
void()	hknight_magica2 =[	$magica2,	hknight_magica3	] {ai_face();};
void()	hknight_magica3 =[	$magica3,	hknight_magica4	] {ai_face();};
void()	hknight_magica4 =[	$magica4,	hknight_magica5	] {ai_face();};
void()	hknight_magica5 =[	$magica5,	hknight_magica6	] {ai_face();};
void()	hknight_magica6 =[	$magica6,	hknight_magica7	] {ai_face();};
//-------------------------------------------------------- Martin Code -----
//  Start of vertical spread code.
void()  hknight_magica7 =[      $magica7,       hknight_magica8 ] {DK_Vertical(3);};
void()  hknight_magica8 =[      $magica8,       hknight_magica9 ] {DK_Vertical(2);};
void()  hknight_magica9 =[      $magica9,       hknight_magica10] {DK_Vertical(1);};
void()  hknight_magica10 =[     $magica10,      hknight_magica11] {DK_Vertical(0);};
void()  hknight_magica11 =[     $magica11,      hknight_magica12] {DK_Vertical(-1);};
void()  hknight_magica12 =[     $magica12,      hknight_magica13] {DK_Vertical(-2);};
//--------------------------------------------------------------------------
void()	hknight_magica13 =[	$magica13,	hknight_magica14] {ai_face();};
void()	hknight_magica14 =[	$magica14,	hknight_run1	] {ai_face();};

//============================================================================

void()	hknight_magicb1 =[	$magicb1,	hknight_magicb2	] {ai_face();};
void()	hknight_magicb2 =[	$magicb2,	hknight_magicb3	] {ai_face();};
void()	hknight_magicb3 =[	$magicb3,	hknight_magicb4	] {ai_face();};
void()	hknight_magicb4 =[	$magicb4,	hknight_magicb5	] {ai_face();};
void()	hknight_magicb5 =[	$magicb5,	hknight_magicb6	] {ai_face();};
void()	hknight_magicb6 =[	$magicb6,	hknight_magicb7	] {ai_face();};
//-------------------------------------------------------- Martin Code -----
//  Start of straight blast code.
void()  hknight_magicb7 =[      $magicb7,       hknight_magicb8 ]
{
	if (random() < 0.4) self.aflag = DK_FIRE_TRACK; // dk_track
	DK_Straight(self.aflag);
};
void()  hknight_magicb8 =[      $magicb8,       hknight_magicb9 ] {DK_Straight(self.aflag);};
void()  hknight_magicb9 =[      $magicb9,       hknight_magicb10] {DK_Straight(self.aflag);};
void()  hknight_magicb10 =[     $magicb10,      hknight_magicb11] {DK_Straight(self.aflag);};
void()  hknight_magicb11 =[     $magicb11,      hknight_magicb12] {DK_Straight(self.aflag);};
void()  hknight_magicb12 =[     $magicb12,      hknight_magicb13]
{
	DK_Straight(self.aflag);
	self.aflag = 0;
};
//--------------------------------------------------------------------------
void()	hknight_magicb13 =[	$magicb13,	hknight_run1] {ai_face();};

//============================================================================

void()	hknight_magicc1 =[	$magicc1,	hknight_magicc2	] {ai_face();};
void()	hknight_magicc2 =[	$magicc2,	hknight_magicc3	] {ai_face();};
void()	hknight_magicc3 =[	$magicc3,	hknight_magicc4	] {ai_face();};
void()	hknight_magicc4 =[	$magicc4,	hknight_magicc5	] {ai_face();};
void()	hknight_magicc5 =[	$magicc5,	hknight_magicc6	] {ai_face();};
void()	hknight_magicc6 =[	$magicc6,	hknight_magicc7	] {hknight_shot(-2);};
void()	hknight_magicc7 =[	$magicc7,	hknight_magicc8	] {hknight_shot(-1);};
void()	hknight_magicc8 =[	$magicc8,	hknight_magicc9	] {hknight_shot(0);};
void()	hknight_magicc9 =[	$magicc9,	hknight_magicc10] {hknight_shot(1);};
void()	hknight_magicc10 =[	$magicc10,	hknight_magicc11] {hknight_shot(2);};
void()	hknight_magicc11 =[	$magicc11,	hknight_run1] {hknight_shot(3);};

//===========================================================================

void()  hknight_char_a1 =[      $char_a1,       hknight_char_a2 ]
{       ai_charge(20);
//-------------------------------------------------------- Martin Code -----
        sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);  };
//--------------------------------------------------------------------------
void()	hknight_char_a2	=[	$char_a2,	hknight_char_a3	] {ai_charge(25);};
void()	hknight_char_a3	=[	$char_a3,	hknight_char_a4	] {ai_charge(18);};
void()	hknight_char_a4	=[	$char_a4,	hknight_char_a5	] {ai_charge(16);};
void()	hknight_char_a5	=[	$char_a5,	hknight_char_a6	] {ai_charge(14);};
void()	hknight_char_a6	=[	$char_a6,	hknight_char_a7	] {ai_charge(20); ai_melee();};
void()	hknight_char_a7	=[	$char_a7,	hknight_char_a8	] {ai_charge(21); ai_melee();};
void()	hknight_char_a8	=[	$char_a8,	hknight_char_a9	] {ai_charge(13); ai_melee();};
void()	hknight_char_a9	=[	$char_a9,	hknight_char_a10	] {ai_charge(20); ai_melee();};
void()	hknight_char_a10=[	$char_a10,	hknight_char_a11	] {ai_charge(20); ai_melee();};
void()	hknight_char_a11=[	$char_a11,	hknight_char_a12	] {ai_charge(18); ai_melee();};
void()  hknight_char_a12=[      $char_a12,      hknight_char_a13        ]
{       ai_charge(16);
//-------------------------------------------------------- Martin Code -----
        sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
};
//--------------------------------------------------------------------------
void()	hknight_char_a13=[	$char_a13,	hknight_char_a14	] {ai_charge(14);};
void()	hknight_char_a14=[	$char_a14,	hknight_char_a15	] {ai_charge(25);};
void()	hknight_char_a15=[	$char_a15,	hknight_char_a16	] {ai_charge(21);};
void()	hknight_char_a16=[	$char_a16,	hknight_run1	] {ai_charge(13);};

//===========================================================================

void()	hknight_char_b1	=[	$char_b1,	hknight_char_b2	]
{
	if (self.spawnflags & DK)
		DK_SwordSwing();
	else
		CheckContinueCharge();
	ai_charge(23);
	ai_melee();
};
void()	hknight_char_b2	=[	$char_b2,	hknight_char_b3	] {ai_charge(17); ai_melee();};
void()	hknight_char_b3	=[	$char_b3,	hknight_char_b4	] {ai_charge(12); ai_melee();};
void()	hknight_char_b4	=[	$char_b4,	hknight_char_b5	] {ai_charge(22); ai_melee();};
void()	hknight_char_b5	=[	$char_b5,	hknight_char_b6	] {ai_charge(18); ai_melee();};
void()	hknight_char_b6	=[	$char_b6,	hknight_char_b1	]
{
	if (self.spawnflags & DK)
		DK_CheckForSwing();
	ai_charge(8);
	ai_melee();
};

//===========================================================================

void()	hknight_slice1	=[	$slice1,	hknight_slice2	] {ai_charge(9);};
void()	hknight_slice2	=[	$slice2,	hknight_slice3	] {ai_charge(6);};
void()	hknight_slice3	=[	$slice3,	hknight_slice4	] {ai_charge(13);};
void()	hknight_slice4	=[	$slice4,	hknight_slice5	] {ai_charge(4);};
void()	hknight_slice5	=[	$slice5,	hknight_slice6	] {ai_charge(7); ai_melee();};
void()	hknight_slice6	=[	$slice6,	hknight_slice7	] {ai_charge(15); ai_melee();};
void()	hknight_slice7	=[	$slice7,	hknight_slice8	] {ai_charge(8); ai_melee();};
void()	hknight_slice8	=[	$slice8,	hknight_slice9	] {ai_charge(2); ai_melee();};
void()	hknight_slice9	=[	$slice9,	hknight_slice10	] {ai_melee();};
void()	hknight_slice10	=[	$slice10,	hknight_run1	] {ai_charge(3);};

//===========================================================================

void()	hknight_smash1	=[	$smash1,	hknight_smash2	] {ai_charge(1);};
void()	hknight_smash2	=[	$smash2,	hknight_smash3	] {ai_charge(13);};
void()	hknight_smash3	=[	$smash3,	hknight_smash4	] {ai_charge(9);};
void()	hknight_smash4	=[	$smash4,	hknight_smash5	] {ai_charge(11);};
void()	hknight_smash5	=[	$smash5,	hknight_smash6	] {ai_charge(10); ai_melee();};
void()	hknight_smash6	=[	$smash6,	hknight_smash7	] {ai_charge(7); ai_melee();};
void()	hknight_smash7	=[	$smash7,	hknight_smash8	] {ai_charge(12); ai_melee();};
void()	hknight_smash8	=[	$smash8,	hknight_smash9	] {ai_charge(2); ai_melee();};
void()	hknight_smash9	=[	$smash9,	hknight_smash10	] {ai_charge(3); ai_melee();};
void()	hknight_smash10	=[	$smash10,	hknight_smash11	] {ai_charge(0);};
void()	hknight_smash11	=[	$smash11,	hknight_run1	] {ai_charge(0);};

//============================================================================

void()	hknight_watk1	=[	$w_attack1,	hknight_watk2	] {ai_charge(2);};
void()	hknight_watk2	=[	$w_attack2,	hknight_watk3	] {ai_charge(0);};
void()	hknight_watk3	=[	$w_attack3,	hknight_watk4	] {ai_charge(0);};
void()	hknight_watk4	=[	$w_attack4,	hknight_watk5	] {ai_melee();};
void()	hknight_watk5	=[	$w_attack5,	hknight_watk6	] {ai_melee();};
void()	hknight_watk6	=[	$w_attack6,	hknight_watk7	] {ai_melee();};
void()	hknight_watk7	=[	$w_attack7,	hknight_watk8	] {ai_charge(1);};
void()	hknight_watk8	=[	$w_attack8,	hknight_watk9	] {ai_charge(4);};
void()	hknight_watk9	=[	$w_attack9,	hknight_watk10	] {ai_charge(5);};
void()	hknight_watk10	=[	$w_attack10,	hknight_watk11	] {ai_charge(3); ai_melee();};
void()	hknight_watk11	=[	$w_attack11,	hknight_watk12	] {ai_charge(2); ai_melee();};
void()	hknight_watk12	=[	$w_attack12,	hknight_watk13	] {ai_charge(2); ai_melee();};
void()	hknight_watk13	=[	$w_attack13,	hknight_watk14	] {ai_charge(0);};
void()	hknight_watk14	=[	$w_attack14,	hknight_watk15	] {ai_charge(0);};
void()  hknight_watk15  =[      $w_attack15,    hknight_watk16  ]
{       ai_charge(0);
//-------------------------------------------------------- Martin Code -----
        sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
};
//--------------------------------------------------------------------------
void()	hknight_watk16	=[	$w_attack16,	hknight_watk17	] {ai_charge(1);};
void()	hknight_watk17	=[	$w_attack17,	hknight_watk18	] {ai_charge(1); ai_melee();};
void()	hknight_watk18	=[	$w_attack18,	hknight_watk19	] {ai_charge(3); ai_melee();};
void()	hknight_watk19	=[	$w_attack19,	hknight_watk20	] {ai_charge(4); ai_melee();};
void()	hknight_watk20	=[	$w_attack20,	hknight_watk21	] {ai_charge(6);};
void()	hknight_watk21	=[	$w_attack21,	hknight_watk22	] {ai_charge(7);};
void()	hknight_watk22	=[	$w_attack22,	hknight_run1	] {ai_charge(3);};


// Cataboligne - 12.4.12 - tracking flares

void() MiniGrenadeExplode;

// blow tracking flares on damage taking ents

void() dk_track_touch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.classname != "monster_hell_knight") // dont blow on hell knights - smart missile tech
	if (other.morphy != CB_HKNIGHT)
	if (other.takedamage == DAMAGE_AIM)
	{
		MiniGrenadeExplode();
		return;
	}

	remove(self);
};



//============================================================================
// start Martin big chunk
// mod by Patrick Martin : cimartin@flash.net - the "death knight", an improved hell knight

//-------------------------------------------------------- New Code --------
//  This gives the death knight a new melee attack which lets him
//  do an overhead smash on his opponent.  Unlike all his other
//  melee attacks, all the damage is done in a single frame, rather
//  than spread out in many frames.  Hence, the attack is a bit slow,
//  but if it connects, it can (and usually does) inflict major damage.
//--------------------------------------------------------------------------
void()  hknight_berserk1  =[ $magica1,   hknight_berserk2 ] {ai_charge(3);};
void()  hknight_berserk2  =[ $magica2,   hknight_berserk3 ] {ai_charge(2);};
void()  hknight_berserk3  =[ $magica3,   hknight_berserk4 ] {ai_charge(1);};
void()  hknight_berserk4  =[ $magica4,   hknight_berserk5 ] {ai_charge(0);};
void()  hknight_berserk5  =[ $magica5,   hknight_berserk6 ] {ai_charge(0);};
void()  hknight_berserk6  =[ $magica6,   hknight_berserk7 ] {ai_charge(0);};
void()  hknight_berserk7  =[ $magica7,   hknight_berserk8 ] {ai_charge(0);};
void()  hknight_berserk8  =[ $magica8,   hknight_berserk9 ] {ai_charge(1);};
void()  hknight_berserk9  =[ $magica9,   hknight_berserk10] {ai_charge(3);};
void()  hknight_berserk10 =[ $magica10,  hknight_berserk11]
{  ai_charge(6); DK_DeathBlow();  };
void()  hknight_berserk11 =[ $magica11,  hknight_berserk12] {ai_charge(3);};
void()  hknight_berserk12 =[ $magica12,  hknight_berserk13] {ai_charge(2);};
void()  hknight_berserk13 =[ $magica13,  hknight_berserk14] {ai_charge(0);};
void()  hknight_berserk14 =[ $magica14,  hknight_run1     ] {ai_charge(0);};

//============================================================================

//-------------------------------------------------------- New Code --------
//  The sword makes noise as it swings.
//--------------------------------------------------------------------------
void() DK_SwordSwing =
{
        if (random() < 0.5)
            sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
	else
            sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
};

//-------------------------------------------------------- New Code --------
//  The death knight may swing his sword repeatedly like helicopter blades.
//--------------------------------------------------------------------------
void() DK_CheckForSwing =
{
        if ( (!enemy_vis) || (random() < 0.5) ||
             (fabs(self.origin_z - self.enemy.origin_z) > 20) ||
             (vlen (self.origin - self.enemy.origin) < 80) )
                hknight_run1();
        else
                hknight_char_b1 ();
};

//-------------------------------------------------------- New Code --------
//  The death knight has three different attack patterns to choose from.
//  #1)  Vertical spread of flares.       20%
//  #2)  All flares aimed at target.      30%
//  #3)  Normal horizontal flare spread.  50%
//--------------------------------------------------------------------------
void() DK_HellKnight_ChooseMagic =
{
        local   float   r;

	if (!self.spawnflags & DK) // not a death knight
	{
		hknight_magicc1();
		return;
	}

        r = random();
        if (r < 0.2)
                hknight_magica1();      // vertical spread
        else if (r < 0.5)
                hknight_magicb1();      // straight blast - can turn into tracers
	else
                hknight_magicc1();      // regular spread
};

//-------------------------------------------------------- New Code --------
//  This is similar to the id's hknight_shot except it is modified
//  so that the shot's 'offset' determines how high or low it will
//  go.  Aside from elevation, it is shot forward.
//--------------------------------------------------------------------------
void(float offset) DK_Vertical =
{
	local	vector	org, vec;

	self.dest = vectoangles (self.enemy.origin - self.origin);

	makevectors (self.dest);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

	// set missile speed
	vec = normalize (v_forward);
	vec_z = offset*0.1 - vec_z + (random() - 0.5)*0.1;

	launch_spike (org, vec);
	newmis.classname = "knightspike";
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	if (skill > 2)          newmis.velocity = vec * 500;
	else if (skill > 1)     newmis.velocity = vec * 400;
	else                    newmis.velocity = vec * 300;
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

//-------------------------------------------------------- New Code --------
//  This is similar to the id's hknight_shot except it is modified so
//  that any shot is directed forward at the target.  These flares
//  usually travel faster than those in the flare spread functions.
//--------------------------------------------------------------------------
void(float tr) DK_Straight =
{
	local	vector	org, vec;
	
	self.dest = vectoangles (self.enemy.origin - self.origin);

	makevectors (self.dest);

	org = self.origin + '0 0 20'; 

	// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z;

	launch_spike (org, vec);
	newmis.classname = "knightspike";
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (skill > 2)       newmis.velocity = vec * 900;
	else if (skill > 1)  newmis.velocity = vec * 600;
	else if (skill > 0)  newmis.velocity = vec * 450;
	else                 newmis.velocity = vec * 300;
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);

	if (tr == DK_FIRE_TRACK) Track_Missile(newmis, dk_track_touch, 20); // dk_track_dmg);
};

//-------------------------------------------------------- New Code --------
//  The death knights' berserk attack inflicts 15-90 points of damage.
//  45 points is the median.  If the death knight is critically injured
//  (i.e. less than 20 hit points left), 15 extra points of damage is
//  added to the total.
//--------------------------------------------------------------------------
void() DK_DeathBlow =
{
//	local   float   d1, d2, d3;     // Random 'dice'.

	if (!self.enemy)  return;

	self.dest = self.enemy.origin - self.origin; // Distance from knight to target

	if (vlen(self.dest) > 90)  return;
	if (!CanDamage (self.enemy, self))  return;

//	d1 = random();  d2 = random();  d3 = random();
	self.dmg = (random() + random() + random()) * 30;
	if (self.dmg < 15)  self.dmg = 15;
	if (self.health < 20)  self.dmg = self.dmg + 15;  // really berserk!
	T_Damage (self.enemy, self, self, self.dmg);
};

// end Martin big chunk
//========================================================================



void() hk_idle_sound =
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
};

void(entity attacker, float damage)	hknight_pain =
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);

	if (!self.spawnflags & DK)
	if (time - self.pain_finished > 5)
	{	// allways go into pain frame if it has been a while
		hknight_pain1 ();
		self.pain_finished = time + 1;
		return;
	}

	if ((random()*30 > damage))
		return;		// didn't flinch

	self.pain_finished = time + 1;
	hknight_pain1 ();
};

float	hknight_type;

void() hknight_melee =
{
	hknight_type = hknight_type + 1;

	sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);

	if (self.spawnflags & DK)
//-------------------------------------------------------- Martin Code -----
//  Use the new attack occasionally (5% per skill) or if:
//  #1)  Enemy is a zombie.  The death knight knows what it takes to kill it.
//  #2)  Death knight is critically injured.  (GIVE ME STRENGTH!)
//  NOTE:  The death knight will never use this attack on Easy.
//--------------------------------------------------------------------------
        if ( (self.health < 20) || (random() < skill*0.05) ||
             (self.enemy.classname == "monster_zombie") && (skill > 0) )
        {
                hknight_berserk1();     // go for the kill!
                hknight_type = hknight_type - 1;        // restore type
        }
	else
//--------------------------------------------------------------------------

	if (hknight_type == 1)
		hknight_slice1 ();
	else if (hknight_type == 2)
		hknight_smash1 ();
	else if (hknight_type == 3)
	{
		hknight_watk1 ();
		hknight_type = 0;
	}
};

/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush Statue Death
*/
void(float ign) monster_hell_knight =
{
if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (!M_MONSTER & CB_M_HKNIGHT)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

// make some more random monsters according to server rules - only do this on map spawned monsters, wont happen with random monsters
	if (R_FAST_MONSTER & CB_M_HKNIGHT)
	if (random() < C_FS_MONSTER)
		speed_monster(CFAST, "monster_hell_knight", self.origin);
		
	if (R_SLOW_MONSTER & CB_M_HKNIGHT)
	if (random() < C_FS_MONSTER)
		speed_monster(CSLOW, "monster_hell_knight", self.origin);

	precache_model ("progs/hknight.mdl");
	precache_model ("progs/k_spike.mdl");
	precache_model ("progs/h_hellkn.mdl");

	
	precache_sound ("hknight/attack1.wav");
	precache_sound ("hknight/death1.wav");
	precache_sound ("hknight/pain1.wav");
	precache_sound ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound ("hknight/slash1.wav");
	precache_sound ("hknight/idle.wav");
	precache_sound ("hknight/grunt.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
}

// Cataboligne - 11.14.12 - fast / slow code
	if (self.speed <= 0) self.speed = MON_NORM;
	self.lip = 1; // local speed divisor
// map specced
	if (self.netname == CFAST) self.speed = MON_FAST;
	else if (self.netname == CSLOW) self.speed = MON_SLOW;

// server controls set all monsters fast or slow if not specced - this includes random monsters
	else if (FAST_MONSTER & CB_M_HKNIGHT) self.speed = MON_FAST;
	else if (SLOW_MONSTER & CB_M_HKNIGHT) self.speed = MON_SLOW;

	self.netname = "Hell Knight";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.walkframe = 0;

	setmodel (self, "progs/hknight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 250;

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
//-------------------------------------------------------- Martin Code -----
	self.th_missile = DK_HellKnight_ChooseMagic;
//--------------------------------------------------------------------------
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;

	enhance = FALSE;

#ifdef enhanced
//	if (ENHANCED)
	if (ENH_Q1_MAP_MONSTERS || (ign == A_MONSTER))
		enhance = TRUE;
#endifdef

#ifdef testset
// REMOVE THIS
self.spawnflags = self.spawnflags | DK;
#endifdef

	if (!self.spawnflags & HK_STATUE)
	if ((enhance) || (self.spawnflags & DK))
	{
		chance = 0.2; // dk_imp;
		if (skill == 3) chance = 0.4; // dk_imp + dk_imp;
		if (ign == A_MONSTER) chance = 0.8; // dk_rnd;

		if (!self.spawnflags & DK) // not map specced - enhance him
		if (random() < chance)
			self.spawnflags = self.spawnflags | DK;

		if (self.spawnflags & DK)
		{
			self.skin = 2;
			if (random() < 0.3) self.skin = 1;
			self.health = 350;
			if ((random() < 0.25) || (self.skin == 1)) self.health = 350 + random() * 100;
			self.wad = "MEGA";
		}
	}

	walkmonster_start ();
};
