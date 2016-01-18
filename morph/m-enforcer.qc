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
	precache_model ("progs/enforcer.mdl");
	precache_model ("progs/h_mega.mdl");
	precache_model ("progs/g_enflaser.mdl"); // 3 following not used directly by enforcer - but for tossed gun when dead
	precache_model ("progs/v_enflaser.mdl");
	precache_model ("progs/vw_enflaser.mdl");

	precache_sound ("enforcer/death1.wav");
	precache_sound ("enforcer/enfire.wav");
	precache_sound ("enforcer/enfstop.wav");
	precache_sound ("enforcer/idle1.wav");
	precache_sound ("enforcer/pain1.wav");
	precache_sound ("enforcer/pain2.wav");
	precache_sound ("enforcer/sight1.wav");
	precache_sound ("enforcer/sight2.wav");
	precache_sound ("enforcer/sight3.wav");
	precache_sound ("enforcer/sight4.wav");
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/
void()	player_enf_atk;
void()	player_enf_atk4;
void()	player_enf_atk7;
void()	player_enf_atk11;

void(float stat) player_enforcer_fire =
{
	local float fr;
	self.effects = self.effects | EF_MUZZLEFLASH;
	fr = 0;

	if (self.eweapon) fr = self.frame;
	else
	if (self.weapon != IT_AXE) fr = self.frame; // any non builtin
/*
	if (self.weapon == IT_LIGHTNING) fr = self.frame; // W_FireLightning();
	else if (self.weapon == IT_ROCKET_LAUNCHER) fr = self.frame; // W_FireRocket();
	else if (self.weapon == IT_GRENADE_LAUNCHER) fr = self.frame; // W_FireGrenade();
	else if (self.weapon == IT_SUPER_SHOTGUN) fr = self.frame; // W_FireSuperShotgun();
	else if (self.weapon == IT_SHOTGUN) fr = self.frame; // W_FireShotgun();
*/
	if (fr) // NOT a builtin wep
	{
		if (!self.eweapon)
		{
			if (self.weapon == IT_LIGHTNING) // fire ltn
			{
				if (self.ammo_cells > 1)
				{
					W_FireLightning();
					self.currentammo = self.ammo_cells = self.ammo_cells - 1;
					if (self.button0) player_enf_atk4();
				}
				else self.weapon = IT_AXE;
			}
			else
//			if (self.weapon != IT_AXE) // use non ewep
			{
				self._attack = SUB_Null; // block infinite loop
				W_Attack();
				self._attack = player_enf_atk;
			}
			if (self.cam_x & CHSCAM_ON) self.punchangle_x = 0;
			self.frame = fr;
			return;
		}
		else
		{
			if (self.eweapon.mcode == MC_HIP_LASERCAN) HIP_FireLaser(stat);
			else
			if (self.eweapon)
			{
				e_weap_Attack();

// this will fix framing issues when enforcer fires some eweaps - it also breaks those weps
//				if (self.eweapon._fr_attack)
//				if (stat == 2) self.think = player_enf_atk7;
//				else self.think = player_enf_atk11;
			}
			else fr = FALSE;

			if (fr)
			{
				self.frame = fr;
				return;
			}
		}
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

/* - 4 & 7 have internal calls
framer($attack1, $attack8, player_enf_atk1, player_enf_atk9, 0.1,

	frame_arb($attack1, if (rune_haste(0.15)) self.attack_finished = 0.3;);	
	frame_arb($attack6, player_enforcer_fire(2););	
	frame_arb($attack7, 

		if (self.weapon) 
		if (self.weapon == IT_LIGHTNING
			|| self.weapon == IT_ROCKET_LAUNCHER
			|| self.weapon == IT_GRENADE_LAUNCHER
			|| self.weapon == IT_SUPER_SHOTGUN || self.weapon == IT_SHOTGUN
			)
			self.think = player_enf_atk12; // only shoot these weps once
	);	
);
*/

void() player_enf_atk =
{
	if ((self.frame < $attack1) || (self.frame > $attack10)) player_enf_atk1();
}

/*
void()	player_enf_paina1	=[	$paina1,	player_enf_paina2	] {};
void()	player_enf_paina2	=[	$paina2,	player_enf_paina3	] {};
void()	player_enf_paina3	=[	$paina3,	player_enf_paina4	] {};
void()	player_enf_paina4	=[	$paina4,	player_stand1	] {};
*/

framer($paina1, $paina4, player_enf_paina1, player_stand1, 0.1,SUB_Null());

/*
void()	player_enf_painb1	=[	$painb1,	player_enf_painb2	] {};
void()	player_enf_painb2	=[	$painb2,	player_enf_painb3	] {};
void()	player_enf_painb3	=[	$painb3,	player_enf_painb4	] {};
void()	player_enf_painb4	=[	$painb4,	player_enf_painb5	] {};
void()	player_enf_painb5	=[	$painb5,	player_stand1	] {};
*/

framer($painb1, $painb5, player_enf_painb1, player_stand1, 0.1,SUB_Null());

/*
void()	player_enf_painc1	=[	$painc1,	player_enf_painc2	] {};
void()	player_enf_painc2	=[	$painc2,	player_enf_painc3	] {};
void()	player_enf_painc3	=[	$painc3,	player_enf_painc4	] {};
void()	player_enf_painc4	=[	$painc4,	player_enf_painc5	] {};
void()	player_enf_painc5	=[	$painc5,	player_enf_painc6	] {};
void()	player_enf_painc6	=[	$painc6,	player_enf_painc7	] {};
void()	player_enf_painc7	=[	$painc7,	player_enf_painc8	] {};
void()	player_enf_painc8	=[	$painc8,	player_stand1	] {};
*/

framer($painc1, $painc8, player_enf_painc1, player_stand1, 0.1,SUB_Null());

/*
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
*/

framer($paind1, $paind19, player_enf_paind1, player_stand1, 0.1,SUB_Null());

//void(entity attacker, float damage)	player_enf_pain =
void()	player_enf_pain =
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

// have to wrap for dead throw

void() player_enf_die =
{
	local float gib;

	if (self.health < -35 || (!XENV && pointcontents(self.origin) == CONTENT_LAVA)) gib = TRUE;

// enforcer morphs need to dead throw
	if (DEAD_THROW)
	if ((DEAD_THROW & 16) || !gib)
		DeadThrowWeps(self, self.origin); // dont have a pack - take ammo from self

	enf_die();
};

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
//		sprint(self, "Enforcer using ( Laser )\n");
		self.items = self.items | IT_CELLS;
		self.eweapon = world;
		self.weaponmodel = null_string;
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
		self.msight = rnd_string('70.0 50.0 30.0',"enforcer/sight4.wav","enforcer/sight3.wav", "enforcer/sight2.wav","enforcer/sight1.wav",null_string);
		}
};

string() player_enf_killmsg =
{
#ifdef enhanced
	return(rnd_string(' 60.0 50.0 40.0'," was blasted by Enforcer ",null_string,null_string," got pulled over - permanently by "," was arrested by Enforcer "));
#else
//	if (!ENHANCED)
	return " was blasted by an Enforcer\n";
#endifdef
};

string() player_enf_killmsg2 =
{
#ifdef enhanced
	return "\n";
#else
//	if (!ENHANCED)
	return "noname";
#endifdef
};

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void() player_enforcer_become = 
{
	self._stand = player_enf_stand;
	self._run = player_enf_run;
	self._pain = player_enf_pain;
	self._die = player_enf_die;
	self._jump = SUB_Null;
	self._jump2 = SUB_Null;
	self._attack = player_enf_atk;
	self._impulse = player_enf_impulse;
	self._killmsg = player_enf_killmsg;
	self._killmsg2 = player_enf_killmsg2;

	self.cam_z = 22 / 100;
	self.cam_y = 26;

	stuffcmd(self, "exec cfg/morph/m-enforcer.cfg\n");

	setmodel(self,"progs/enforcer.mdl");

	self.builtin = IT_AXE;
	self.items = self.items | IT_AXE;
	self.weapon = IT_AXE;

	self.msight = "enforcer/sight1.wav";
	self.noise2 = "enforcer/pain1.wav";
	self.noise3 = null_string;
	self.view_ofs = '0 0 24';
//	if(!deathmatch)
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
//	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = self.health * MENF_HEALMOD / self.health_modifier;
	self.health_modifier = MENF_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);
};



