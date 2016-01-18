/* ::-::
 *
 * Cataboligne
 *
 * file: m-enforcer.qc
 *
 * date: 9/18/11
 *
 * qc - support chaos mod morph ability
 *
 */

/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/
 
$cd id1/models/enforcer
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

/*
		+---------------------------------------+
		|  world code                           | SEC-HEAD
		+---------------------------------------+
*/

void() m_precache_enforcer =
{
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model ("progs/g_enflaser.mdl"); // 3 following not used directly by enforcer - but for tossed gun when dead
	precache_model ("progs/v_enflaser.mdl");
	precache_model ("progs/vw_enflaser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float stat) player_enforcer_fire =
{
	local float fr;
	self.effects = self.effects | EF_MUZZLEFLASH;
	fr = TRUE;
	if (!self.eweapon)
	{
		if (self.weapon == IT_LIGHTNING) W_FireLightning();
		else if (self.weapon == IT_ROCKET_LAUNCHER) W_FireRocket();
		else if (self.weapon == IT_GRENADE_LAUNCHER) W_FireGrenade();
		else if (self.weapon == IT_SUPER_SHOTGUN) W_FireSuperShotgun();
		else if (self.weapon == IT_SHOTGUN) W_FireShotgun();
		else fr = FALSE;
		if (self.cam_x & CHSCAM_ON) self.punchangle_x = 0;
		if (fr) return;
	}
	else
	{
		if (self.eweapon.mcode == MC_HIP_LASERCAN) HIP_FireLaser(stat);
		else if (self.eweapon._attack != SUB_Null) self.eweapon._attack();
		else fr = FALSE;
		if (fr) return;	
	}

	fire_enflaser();
};

/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

 void() player_enf_sight;
 
 void() player_enf_stand = [ $stand1, player_stand1 ]
{
	if(self.walkframe >= 7)	
		self.walkframe = 0;
	if (self.walkframe == 2) morph_sound (0.08, "enforcer/idle1.wav", 2);
	if (self.walkframe == 5) player_enf_sight();
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

// enforcer has walk and run frames, walking is designated as avg player speeds < 250, calculated with z = 0

void() player_enf_run = [ $run1, player_run ] 
{
	vector sp;
	float walk, frm;

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 16) self.walkframe = 0;
		}
	else
		{
		frm = $run1;
		if (self.walkframe >= 8) self.walkframe = 0;
		}

	if (self.walkframe == 2) morph_sound (0.2, "enforcer/idle1.wav", 2);
	if (self.walkframe == 5) player_enf_sight();
	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void()	player_enf_atk12;

void()	player_enf_atk1	=[	$attack1,	player_enf_atk2	] { if (rune_haste(0.15)) self.attack_finished = 0.3; };
void()	player_enf_atk2	=[	$attack2,	player_enf_atk3	] {};
void()	player_enf_atk3	=[	$attack3,	player_enf_atk4	] {};
void()	player_enf_atk4	=[	$attack4,	player_enf_atk5	] {};
void()	player_enf_atk5	=[	$attack5,	player_enf_atk6	] {};
void()	player_enf_atk6	=[	$attack6,	player_enf_atk7	] {player_enforcer_fire(2);};
void()	player_enf_atk7	=[	$attack7,	player_enf_atk8	]
{
	if (self.weapon) 
	if (self.weapon == IT_LIGHTNING
		|| self.weapon == IT_ROCKET_LAUNCHER
		|| self.weapon == IT_GRENADE_LAUNCHER
		|| self.weapon == IT_SUPER_SHOTGUN || self.weapon == IT_SHOTGUN
		)
		self.think = player_enf_atk12; // only shoot these weps once
};
void()	player_enf_atk8	=[	$attack8,	player_enf_atk9	] {};
void()	player_enf_atk9	=[	$attack5,	player_enf_atk10	] {};
void()	player_enf_atk10	=[	$attack6,	player_enf_atk11	] {player_enforcer_fire(3);};
void()	player_enf_atk11	=[	$attack7,	player_enf_atk12	] {};
void()	player_enf_atk12	=[	$attack8,	player_enf_atk13	] {};
void()	player_enf_atk13	=[	$attack9,	player_enf_atk14	] {};
void()	player_enf_atk14	=[	$attack10,	player_stand1	] {};

void()	player_enf_paina1	=[	$paina1,	player_enf_paina2	] {};
void()	player_enf_paina2	=[	$paina2,	player_enf_paina3	] {};
void()	player_enf_paina3	=[	$paina3,	player_enf_paina4	] {};
void()	player_enf_paina4	=[	$paina4,	player_stand1	] {};

void()	player_enf_painb1	=[	$painb1,	player_enf_painb2	] {};
void()	player_enf_painb2	=[	$painb2,	player_enf_painb3	] {};
void()	player_enf_painb3	=[	$painb3,	player_enf_painb4	] {};
void()	player_enf_painb4	=[	$painb4,	player_enf_painb5	] {};
void()	player_enf_painb5	=[	$painb5,	player_stand1	] {};

void()	player_enf_painc1	=[	$painc1,	player_enf_painc2	] {};
void()	player_enf_painc2	=[	$painc2,	player_enf_painc3	] {};
void()	player_enf_painc3	=[	$painc3,	player_enf_painc4	] {};
void()	player_enf_painc4	=[	$painc4,	player_enf_painc5	] {};
void()	player_enf_painc5	=[	$painc5,	player_enf_painc6	] {};
void()	player_enf_painc6	=[	$painc6,	player_enf_painc7	] {};
void()	player_enf_painc7	=[	$painc7,	player_enf_painc8	] {};
void()	player_enf_painc8	=[	$painc8,	player_stand1	] {};

void()	player_enf_paind1		=[	$paind1,		player_enf_paind2	] {};
void()	player_enf_paind2		=[	$paind2,		player_enf_paind3	] {};
void()	player_enf_paind3		=[	$paind3,		player_enf_paind4	] {};
void()	player_enf_paind4		=[	$paind4,		player_enf_paind5	] {};
void()	player_enf_paind5		=[	$paind5,		player_enf_paind6	] {};
void()	player_enf_paind6		=[	$paind6,		player_enf_paind7	] {};
void()	player_enf_paind7		=[	$paind7,		player_enf_paind8	] {};
void()	player_enf_paind8		=[	$paind8,		player_enf_paind9	] {};
void()	player_enf_paind9		=[	$paind9,		player_enf_paind10] {};
void()	player_enf_paind10	=[	$paind10,	player_enf_paind11] {};
void()	player_enf_paind11	=[	$paind11,	player_enf_paind12] {};
void()	player_enf_paind12	=[	$paind12,	player_enf_paind13] {};
void()	player_enf_paind13	=[	$paind13,	player_enf_paind14] {};
void()	player_enf_paind14	=[	$paind14,	player_enf_paind15] {};
void()	player_enf_paind15	=[	$paind15,	player_enf_paind16] {};
void()	player_enf_paind16	=[	$paind16,	player_enf_paind17] {};
void()	player_enf_paind17	=[	$paind17,	player_enf_paind18] {};
void()	player_enf_paind18	=[	$paind18,	player_enf_paind19] {};
void()	player_enf_paind19	=[	$paind19,	player_stand1	] {};

void(entity attacker, float damage)	player_enf_pain =
{
	local float r;

	r = random ();
//	if (self.pain_finished > time)
//		return;

	if (r < 0.5)
		morph_sound (1, "enforcer/pain1.wav", 1);
	else
		morph_sound (1, "enforcer/pain2.wav", 1);

	if (r < 0.2)
	{
		self.pain_finished = time + 1;
		player_enf_paina1 ();
	}
	else if (r < 0.4)
	{
		self.pain_finished = time + 1;
		player_enf_painb1 ();
	}
	else if (r < 0.7)
	{
		self.pain_finished = time + 1;
		player_enf_painc1 ();
	}
	else
	{
		self.pain_finished = time + 2;
		player_enf_paind1 ();
	}
};

// void() enf_die = using this fn

/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/
void() player_enf_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	split_morph_impulse();

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		sprint(self, "Enforcer using ( Laser )\n");
		self.items = self.items | IT_CELLS;
		self.eweapon = world;
		self.weaponmodel = "";
	}
};
/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/

void() player_enf_sight =
{
	if (random() < 0.45)
		{
		 // halt!, you there, freeze, stop...sheesh sounds like a cop
		self.msight = rnd_string('70.0 50.0 30.0',"enforcer/sight4.wav","enforcer/sight3.wav", "enforcer/sight2.wav","enforcer/sight1.wav","");
		}
};

string() player_enf_killmsg = { return rnd_string(' 60.0 50.0 40.0'," was blasted by an Enforcer ","",""," got pulled over - permanently by "," was arrested by an Enforcer "); };
string() player_enf_killmsg2 = { return "\n"; };

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_enforcer_become = 
{
	self._stand = player_enf_stand;
	self._run = player_enf_run;
	self._pain = player_enf_pain;
	self._die = enf_die;
	self._jump = SUB_Null;
	self._jump2 = SUB_Null;
	self._attack = player_enf_atk1;
	self._impulse = player_enf_impulse;
//	self._can_get_p = SUB_False;
	self._killmsg = player_enf_killmsg;
	self._killmsg2 = player_enf_killmsg2;

	self.cam_z = 22 / 100;
	self.cam_y = 26;
	stuffcmd(self, "chase_up 22\n");
	stuffcmd(self, "chase_back 26\n");
	stuffcmd(self, "exec m-enforcer.cfg\n");

	setmodel(self,"progs/enforcer.mdl");

	self.builtin = self.items = self.items | IT_AXE;
	self.weapon = IT_AXE;

	self.msight = "enforcer/sight1.wav";
	self.noise2 = "enforcer/pain1.wav";
	self.noise3 = "";
	self.view_ofs = ' 0 0 24';
	self.cam_z = 0.1;
//	if(!deathmatch)
//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
	setsize (self, '-16 -16 -24', ' 16 16 40');
	self.health = self.health * MENF_HEALMOD / self.health_modifier;
	self.health_modifier = MENF_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);



	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become an enforcer.\n");
		morph_impulse();
		}
};



