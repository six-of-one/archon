/* ::-::
 *
 * Cataboligne
 *
 * file: m-scourge.qc
 *
 * date: 9/14/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/

$cd hipwork\models\scourge
$origin 0 0 23
$base scorbase.asc

$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6
$frame stand7 stand8 stand9 stand10 stand11 stand12

//$frame walk1 walk2 walk3 walk4 walk5 walk6
$frame walk1 walk2 walk3 walk4 walk5 walk6

$frame shoot1 shoot2

$frame sting1 sting2 sting3 sting4 sting5 sting6
$frame sting7 sting8 sting9 sting10 sting11

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };


/*
		+---------------------------------------+
		|  world code                           | SEC-HEAD
		+---------------------------------------+
*/

void() m_precache_scourge =
{
// Scourge morph - if it looks like a scourge...
	precache_model ("progs/scor2.mdl");
	precache_model ("progs/h_scourg.mdl");
	precache_model ("progs/proxbomb.mdl");

	precache_sound ("misc/null.wav");
	precache_sound ("scrg/idle.wav");
	precache_sound ("scrg/pain.wav");
	precache_sound ("scrg/pain2.wav");
	precache_sound ("scrg/sight.wav");
	precache_sound ("scrg/tailswng.wav");
	precache_sound ("scrg/walk.wav");
//	precache_sound ("shambler/smack.wav");
//	precache_sound ("weapons/rocket1i.wav");
	precache_sound ("chaos/proxbomb.wav");
	precache_sound ("chaos/proxwarn.wav");
};

/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

//Morph scourge movement

void() player_scourge_stand = [ $stand1, player_stand1 ] {
	if(self.walkframe >= 12)	
		self.walkframe = 0;
	if (WALKSOUND) sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);  // scourge stopped turn off sound
	if (self.walkframe == 3) morph_sound(0.08, "scrg/idle.wav", 3);
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};


void() player_scourge_run = [ $walk1, player_run ] 
{
	if (self.walkframe >= 6)
		self.walkframe = 0;
	if (self.walkframe == 1) morph_walksound("scrg/walk.wav",0.9);
	if (self.walkframe == 3) morph_sound(0.05, "scrg/idle.wav", 3);
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

// 5 frames of player_scourge pain to stand1

void() player_scourge_pain1  =[ $pain1, player_scourge_pain2  ] { };
void() player_scourge_pain2  =[ $pain2, player_scourge_pain3  ] 
{
	morph_sound (0.5, rnd_string(' 70.0 70.0 70.0',"scrg/pain2.wav",null_string,null_string,null_string,"scrg/pain.wav"), 1);
};
void() player_scourge_pain3  =[ $pain3, player_scourge_pain4  ] { };
void() player_scourge_pain4  =[ $pain4, player_scourge_pain5  ] { };
void() player_scourge_pain5  =[ $pain5, player_stand1 ] { };

void() player_scourge_pain =
{
	if (self.attack_finished > time) return;

	self.pain_finished = time + 2 + random() * 1;
	player_scourge_pain1();
};

void()   player_scourge_die1 =[ $death1, player_scourge_die2 ] {};
void()   player_scourge_die2 =[ $death2, player_scourge_die3 ] {};
void()   player_scourge_die3 =[ $death3, player_scourge_die4 ] {self.solid = SOLID_NOT;};
void()   player_scourge_die4 =[ $death4, player_scourge_die5 ] {};
void()   player_scourge_die5 =[ $death5, SUB_Nop ] {};

// fn (player_scourge_die) - handle morph scourge death - chance to throw ammo boxes if not gibbed

void() player_scourge_die =
{
	local entity e;

	if ( GibMorph ("progs/h_scourg.mdl", 0, FL_HEADGIB | FL_NONHUMGIB | FL_NOSND, 0, -95, 9, 0, null_string) ) return;

// regular death
   sound (self, CHAN_VOICE, "scrg/pain2.wav", 1, ATTN_NORM);
   player_scourge_die1 ();

// scourge can drop stuff if not gibbed

	if (random() < 0.4)
	{
		e = drop_item(0, "item_spikes", self, v0);
	}
	if ((self.ammo_rockets > 0) && (random() < ((100 - self.ammo_rockets) * 0.01) ))
	{
		e = drop_item(0, "item_rockets", self, v0);
		e.aflag = self.ammo_rockets;
	}
	if ((self.ammo_cells > 0) && (random() < ((120 - self.ammo_rockets) * 0.01) ))
	{
		e = drop_item(0, "item_cells", self, v0);
		e.aflag = self.ammo_cells;
	}

};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/

// scourge with runes really hoses out some freaking nails
// quad & dmg runes increase nail fire (6 slots for runes, 8 slots for quad)
// having both rune & tech damage is same as quad

void(float ox) player_scourge_FireSpikes =
{
	local vector   src;
	local float am, f;
	local string s1, s2;

	if (rune_haste(0.1))
		self.attack_finished = time + 0.2;

// dont make extra sounds for extra fire
	if (fabs(ox) == 40) s1 = "enforcer/enfire.wav";
	if (fabs(ox) != 45 && fabs(ox) != 47) s2 = "weapons/rocket1i.wav";

	f = 0;
	if (ox == -45 || ox == 45) f = 4; // quad & rune affects
	if (ox == -47 || ox == 47) f = -4;

	if (ox > 0) ox = ox - 16; // move shooting position in 16 qu, and I dont know why this needs done
	else ox = ox + 16;
	src = self.origin - '0 0 11' + v_right * ox + v_forward * 18;
	src_z = src_z + f;	
	
	if (self.weapon == IT_LIGHTNING && (self.ammo_cells > 0))
	{
		self.currentammo = self.ammo_cells;
		am = 0;
//		if (fabs(ox) == 24)
//			if (self.currentammo > 0)
//				am = FL_USEAMMO;

		fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, am, RM_SKY | PF_LAVA, src, ' 0 0 0', "laser", "progs/laser_m.mdl", s1, Laser_Blast, 6, SUB_Remove, Laser_Blast);

		if (s1 == "enforcer/enfire.wav") // if no sound, no ammo use
		if (self.currentammo > 0)
			self.currentammo = self.ammo_cells = self.ammo_cells - 1;

		newmis.skin = 8; // white / blue shift
		newmis.frame = 5; // small slope trap
		newmis.effects = newmis.effects | EF_FULLBRIGHT;
		newmis.dmg = 18;
		newmis.morphy = self.morphy;
//		newmis.effects = EF_DIMLIGHT;
	}
	else
	{
		fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, src, ' 0 0 0', "spike", "progs/spike.mdl", s2, spike_touch, 6, SUB_Remove, spike_touch);
// dmg default is 9 - idea super spikes with sng touch
		newmis.frame = 5;
		newmis.skin = 2;
		newmis.morphy = self.morphy;
//		newmis.touch = superspike_touch;				//for when we upgrade nail shooters!
//		setmodel (newmis, "progs/s_spike.mdl");
	}
};

void()   player_scourge_atk1 =[ $shoot1,   player_scourge_atk2 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(40);

	if (ENHANCED)
	if ((self.rune_flag & RUNE_FLG_DM) || (self.super_damage_finished))// quad or damage rune - extra nails
		player_scourge_FireSpikes(-45);
//   player_scourge_FireSpikes(-40);
};
void()   player_scourge_atk2 =[ $shoot2,   player_scourge_atk3 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(56);
   player_scourge_FireSpikes(-52);  // moving outside shots in 4 units

	if (ENHANCED)
	if ((self.rune_flag & TECH_AMP) || self.super_damage_finished)// quad or damage rune - extra nails
		player_scourge_FireSpikes(47);
};
void()   player_scourge_atk3 =[ $shoot1,   player_scourge_atk4 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(40);
   player_scourge_FireSpikes(-40);

	if (ENHANCED)
	{
		if ((self.rune_flag & RUNE_FLG_DM) || (self.super_damage_finished))// quad or damage rune - extra nails
			player_scourge_FireSpikes(45);

		if ((self.rune_flag & TECH_TEIM) || (self.rune_flag & RUNE_FLG_HS))// haste rune - more extra nails
			player_scourge_FireSpikes(-47);
	}

};
void()   player_scourge_atk4 =[ $shoot2,   player_scourge_atk5 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(52);
//   player_scourge_FireSpikes(-56);

	if (ENHANCED)
	if ((self.rune_flag & TECH_AMP) || self.super_damage_finished)// quad or damage rune - extra nails
		player_scourge_FireSpikes(-47);
};
void()   player_scourge_atk5 =[ $shoot1,   player_scourge_atk6 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(40);

	if (ENHANCED)
	if ((self.rune_flag & RUNE_FLG_DM) || (self.super_damage_finished))// quad or damage rune - extra nails
		player_scourge_FireSpikes(-45);
//   player_scourge_FireSpikes(-40);
};
void()   player_scourge_atk6 =[ $shoot2,   player_scourge_atk7 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(56);
   player_scourge_FireSpikes(-52);

	if (ENHANCED)
	{
		if ((self.rune_flag & TECH_AMP) || self.super_damage_finished)// quad or damage rune - extra nails
			player_scourge_FireSpikes(-47);

		if ((self.rune_flag & TECH_TEIM) || (self.rune_flag & RUNE_FLG_HS))// haste rune - extra nails
			player_scourge_FireSpikes(45);
	}
};
void()   player_scourge_atk7 =[ $shoot1,   player_scourge_atk8 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(40);
   player_scourge_FireSpikes(-40);

	if (ENHANCED)
	if ((self.rune_flag & RUNE_FLG_DM) || (self.super_damage_finished))// quad or damage rune - extra nails
		player_scourge_FireSpikes(45);

};
void()   player_scourge_atk8 =[ $shoot2,   player_stand1 ]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(52);
//   player_scourge_FireSpikes(-56);
//   SUB_AttackFinished (4*random());
	if (ENHANCED)
	if ((self.rune_flag & TECH_AMP) || self.super_damage_finished)// quad or damage rune - extra nails
		player_scourge_FireSpikes(-47);

	if (self.currentammo < 1 )  // firing lasers, out of ammo
	{
//		bprint("switch from lasers\n");
//		W_SetWeapon(IT_SHOTGUN); // best wep cant select internals!
		self.weapon = IT_SHOTGUN;
		self.currentammo = 1;
	}

};

void() m_Attack_With_Tail =
{
	if (self.weapon == IT_GRENADE_LAUNCHER && (self.ammo_rockets > 0))  // we got modded to fire prox mines if we have rockets
	{
		self.currentammo = self.ammo_rockets;
		W_Fire_Proxmine();
		newmis.morphy = self.morphy;
//		if (!self.eweapon) 
			self.ammo_rockets = self.ammo_rockets - 1;
		self.punchangle_x = 0;
	}
	else
		W_FireAxe();
//	melee_damage(self.origin + '0 0 4', self.origin + '0 0 4' + v_forward*48, (random() + random() + random()) * 40, 20, crandom() * 50, 0, null_string, "weapons/bounce.wav", "shambler/smack.wav");
};
	
void()   player_scourge_melee1 =[ $sting1,   player_scourge_melee2 ] { };
void()   player_scourge_melee2 =[ $sting2,   player_scourge_melee3 ] { };
void()   player_scourge_melee3 =[ $sting3,   player_scourge_melee4 ] { };
void()   player_scourge_melee4 =[ $sting4,   player_scourge_melee5 ] { };
void()   player_scourge_melee5 =[ $sting5,   player_scourge_melee6 ]
   {
   sound (self, CHAN_WEAPON, "scrg/tailswng.wav", 1, ATTN_NORM);
   };
void()   player_scourge_melee6 =[ $sting6,   player_scourge_melee7 ] { };
void()   player_scourge_melee7   =[ $sting7,   player_scourge_melee8   ]
   {
   m_Attack_With_Tail();
   };
void()   player_scourge_melee8   =[ $sting8,   player_scourge_melee9   ] { };
void()   player_scourge_melee9   =[ $sting9,   player_scourge_melee10   ] { };
void()   player_scourge_melee10   =[ $sting10,   player_scourge_melee11   ] { };
void()   player_scourge_melee11   =[ $sting11,  player_stand1 ] { };

void() player_scourge_attack =
{
	if (random() < 0.07) morph_sound(2, self.msight, 3);

	if ( self.weapon == IT_AXE || (self.weapon == IT_GRENADE_LAUNCHER))
	{
		if (rune_haste(0.5))
		self.attack_finished = time + 1.0;
		player_scourge_melee1();
	}
	else
	{
		player_scourge_atk1();
		if (rune_haste(0.4))
		self.attack_finished = time + 0.8;
	}
};

/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/

void() player_scourge_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

//	split_morph_impulse();
	morph_impulse();

// IMP: alt fire (for what?)

	if (self.weapon == IT_ROCKET_LAUNCHER) // touched a rocket - set normal mode
	{
		self.items = self.items - (self.items & IT_ROCKET_LAUNCHER);
		self.items = self.items | IT_GRENADE_LAUNCHER;
		self.builtin = self.builtin - (self.builtin & IT_ROCKET_LAUNCHER);
		self.weapon = IT_GRENADE_LAUNCHER;
	}

	if (self.weapon == IT_LIGHTNING)
	{
		self.items = self.items | IT_CELLS;
//		sprint(self, "Scourge firing ( lazers )\n"); 
		self.weaponmodel = 	null_string;
		self.forcewchange = 0;
	}
	if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.items = self.items | IT_ROCKETS;
//		sprint(self, "Scourge firing ( bombs )\n"); 
		self.weaponmodel = null_string;
		self.forcewchange = 0;
	}
	if (self.weapon == IT_SHOTGUN)
	{
		if (self.eweapon.pk_touch != cube_touch)
		self.eweapon = world;
		self.items = self.items | IT_NAILS;
//		sprint(self, "Scourge firing ( perforator )\n"); 
	}
	if (self.weapon == IT_AXE)
	{
		if (self.eweapon.pk_touch != cube_touch)
		self.eweapon = world;		
//		if (self.pk_currentitem == PK_IT_AXE)
//		{
//			sprint(self, "Scourge firing ( stinger )\n"); 
//		}
	}
};

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/


// fn(player_scourge_armor) - a scourges built in armor can heal.
// armor can be added to non scourge, but not healed

float (entity p, float heala, float ign) player_scourge_armor =
{
	float armheal;
	
	if (ign != GIVEARMOR)
	if ( (p.armorvalue >= SCOURGE_ARMORMAX) || (! p.mask_x & MORPH_SARMOR) )
			return FALSE;

	if ((ign == GIVEARMOR) || p.health >= ((p.max_health * p.health_modifier) - (p.max_health / 2.0)))
	{
		if (p.armortype == 0) //start armor
		{
			p.armortype = ARM_SCRG; // better armor at higher classes
			p.items = p.items - (p.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR1;

			if (ign == GIVEARMOR) p.armorvalue = ceil(heala);
		}
		if (ign == GIVEARMOR) return TRUE;
// we use the whole thing if health max and its not mega
		armheal = heala * 0.40; //health only 40% effective on scourge armor
// 1/3 of health goes to armor if we still need a heal to max or its a mega
		if ((p.health < (p.max_health * p.health_modifier)) || ign)
		{
// subtract part of health we use for armor - T_Heal is going to heal full amount and we used some
			p.health = p.health - (heala * 0.33);
			armheal = heala * 0.132; // 40% value for 33% of heal amount
			if (heala >= p.max_health) armheal = heala * 0.264; // mega is 80% effective
		}
		p.armorvalue = ceil(p.armorvalue + armheal); 
	}
	else
		return FALSE;
//cap scourge armor at 100, class level may change this
	if (p.armorvalue > SCOURGE_ARMORMAX) p.armorvalue = SCOURGE_ARMORMAX;
	return TRUE;
};


string(entity targ, entity attacker) player_scourge_killmsg =
{
	if (!ENHANCED) return " was stung by a Centroid\n";

	if (attacker.weapon == IT_AXE)
		return " was stung by ";
	else
		return " was hated by ";
};

string(entity targ, entity attacker) player_scourge_killmsg2 =
{
	if (!ENHANCED) return "noname";
	return ".\n";
};


/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_scourge_become = 
{
//	float tr,tc; // swap out cells, rockets

	self._stand = player_scourge_stand;
	self._run = player_scourge_run;
	self._pain = player_scourge_pain;
	self._die = player_scourge_die;
	self._jump = SUB_False;
	self._jump2 = SUB_False;
	self._attack = player_scourge_attack;
	self._impulse = player_scourge_impulse;
//	self._can_get_p=SUB_True; // player_scourge_can_get;
	self._killmsg=player_scourge_killmsg;
	self._killmsg2=player_scourge_killmsg2;

	self.cam_z = 0;
	self.cam_y = 10;

	stuffcmd(self, "exec cfg/morph/m-scourge.cfg\n");

	setmodel(self,"progs/scor2.mdl");

	self.builtin = IT_AXE | IT_SHOTGUN | IT_LIGHTNING | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER;
	self.items = self.items | IT_AXE | IT_SHOTGUN;
	self.weapon = IT_SHOTGUN;
	
	self.msight = "scrg/sight.wav";
	self.noise2 = "scrg/pain2.wav";
	self.noise3 = null_string;
	self.view_ofs = ' 0 0 5'; // lowered to 12 first then 7 more
//	if(!deathmatch)
//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
		setsize (self, '-16 -16 -24', ' 16 16 16'); //scourge height correct, XY dim cant be set bigger

	self.health = self.health * MSCOURGE_HEALMOD / self.health_modifier;
	self.health_modifier = MSCOURGE_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (self.armortype == 0) //scourge has some base armor on create
		{
		player_scourge_armor(self, 50, GIVEARMOR); 
		}
//	else - should not have armor here!
//		self.armortype = ARM_SCRG; // norm armor convert to scourge armor FIX

	if (!silent) // silent for starting new level as this beasty
	{
		bprint(self.netname);
		bprint(" has become "); // scourge
		bprint(polymorph_id(self.morphy));
		bprint(".\n");
//		morph_impulse();
	}
};
