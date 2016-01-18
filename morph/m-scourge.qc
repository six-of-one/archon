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
	precache_model ("progs/scor.mdl");
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

float SEL_SCRGNAIL;
float SEL_SCRGTAIL;

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
//	self.walkframe = self.walkframe + 1;
};


void() player_scourge_run = [ $walk1, player_run ] 
{
	if (self.walkframe >= 6)
		self.walkframe = 0;
	if (self.walkframe == 1) morph_walksound("scrg/walk.wav",0.9);
	if (self.walkframe == 3) morph_sound(0.05, "scrg/idle.wav", 3);
	self.frame = $walk1 + self.walkframe;
//	self.walkframe = self.walkframe + 1;
};

// 5 frames of player_scourge pain to stand1

void() player_scourge_pain1  =[ $pain1, player_scourge_pain2  ] { };
void() player_scourge_pain2  =[ $pain2, player_scourge_pain3  ] 
{
	morph_sound (0.5, rnd_string(' 70.0 70.0 70.0',"scrg/pain2.wav","","","","scrg/pain.wav"), 1);
};
void() player_scourge_pain3  =[ $pain3, player_scourge_pain4  ] { };
void() player_scourge_pain4  =[ $pain4, player_scourge_pain5  ] { };
void() player_scourge_pain5  =[ $pain5, player_stand1 ] { };

void() player_scourge_pain =
{
	self.pain_finished = time + 2;
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

//	if ( GibMorph ("progs/h_scourg.mdl", 0, FL_HEADGIB | FL_NONHUMGIB | FL_NOSND, 0, -95, 9, 0, "") ) return;
	GibPlayer(); // TDO:

// regular death
   sound (self, CHAN_VOICE, "scrg/pain2.wav", 1, ATTN_NORM);
   player_scourge_die1 ();

// scourge can drop stuff if not gibbed
/*
	if (random() < 0.4)
		{
		e = drop_item(item_spikes, self, "", 0);
		droprnd(v0, e);
		}
	if ((self.ammo_rockets > 0) && (random() < ((100 - self.ammo_rockets) * 0.01) ))
		{
		e = drop_item(item_rockets, self, "Scourge rockets", 0);
		e.aflag = self.ammo_rockets;
		droprnd(v0, e);
		}
	if ((self.ammo_cells > 0) && (random() < ((120 - self.ammo_rockets) * 0.01) ))
		{
		e = drop_item(item_cells, self, "Scourge batteries!", 0);
		e.aflag = self.ammo_cells;
		droprnd(v0, e);
		}
*/
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float ox) player_scourge_FireSpikes =
{
	local vector   src;
	local float am;

	self.attack_finished = time + 0.2;

	if (ox > 0) ox = ox - 16; // move shooting position in 16 qu, and I dont know why this needs done
	else ox = ox + 16;
	src = self.origin - '0 0 11' + v_right * ox + v_forward * 14;

//	if (wep_ref(WMOD_RDW,self.weapon & 255,0,self,0) == MC_ROTOR)
	if (self.eweapon)
//	if (self.weapon == 0) // fire some laser bolts, maybe add more later
		{
		self.currentammo = self.ammo_cells;//wep_ref(WMOD_RDA,self.weapon & 255,0,self,0);
		am = 0;
		if (fabs(ox) == 24)
			if (self.currentammo > 0)
				am = FL_USEAMMO;

		fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, am, RM_SKY | PF_LAVA, src, ' 0 0 0', "laser", "progs/laser_m.mdl", "enforcer/enfire.wav", Laser_Blast, 6, SUB_Remove, Laser_Blast);
		newmis.skin = 7; // white / blue shift
		newmis.frame = 5; // small slope trap
//		newmis.effects = EF_DIMLIGHT;
		}
	else
		{
		fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, src, ' 0 0 0', "spike", "progs/spike.mdl", "weapons/rocket1i.wav", spike_touch, 6, SUB_Remove, spike_touch);
		newmis.frame = 5;
		newmis.skin = 2;
//		newmis.touch = superspike_touch;				//for when we upgrade nail shooters!
//		setmodel (newmis, "progs/s_spike.mdl");
		}
};

void()   player_scourge_atk1 =[ $shoot1,   player_scourge_atk2 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(40);
//   player_scourge_FireSpikes(-40);
   };
void()   player_scourge_atk2 =[ $shoot2,   player_scourge_atk3 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(56);
   player_scourge_FireSpikes(-52);  // moving outside shots in 4 units
   };
void()   player_scourge_atk3 =[ $shoot1,   player_scourge_atk4 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(40);
   player_scourge_FireSpikes(-40);
   };
void()   player_scourge_atk4 =[ $shoot2,   player_scourge_atk5 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(52);
//   player_scourge_FireSpikes(-56);
   };
void()   player_scourge_atk5 =[ $shoot1,   player_scourge_atk6 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(40);
//   player_scourge_FireSpikes(-40);
   };
void()   player_scourge_atk6 =[ $shoot2,   player_scourge_atk7 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(56);
   player_scourge_FireSpikes(-52);
   };
void()   player_scourge_atk7 =[ $shoot1,   player_scourge_atk8 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
//   player_scourge_FireSpikes(40);
   player_scourge_FireSpikes(-40);
   };
void()   player_scourge_atk8 =[ $shoot2,   player_stand1 ]
   {
   self.effects = self.effects | EF_MUZZLEFLASH;
   player_scourge_FireSpikes(52);
//   player_scourge_FireSpikes(-56);
//   SUB_AttackFinished (4*random());

	if (self.currentammo < 1 )  // firing lasers, out of ammo - // FIX
		{
//		bprint("switch from lasers\n");
//		W_SetWeapon(SEL_SCRGNAIL); // best wep cant select internals!
		self.weapon = SEL_SCRGNAIL;
		self.currentammo = 1;
		}

	};

void() m_Attack_With_Tail =
{
	if (self.eweapon)  // we got modded to fire prox mines if we have rockets
		{
		W_Fire_Proxmine();
		self.punchangle_x = 0;
		}
	else
		W_FireAxe();
//	melee_damage(self.origin + '0 0 4', self.origin + '0 0 4' + v_forward*48, (random() + random() + random()) * 40, 20, crandom() * 50, 0, "", "weapons/bounce.wav", "shambler/smack.wav");
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

	if ( self.weapon == SEL_SCRGTAIL )
		{
		self.attack_finished = time + 1.0;
		player_scourge_melee1();
		}
	else
		{
		player_scourge_atk1();
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
//	morph_impulse();

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	if (self.impulse == 1)
		self.weapon = SEL_SCRGTAIL;
	else if (self.impulse == 2)
		self.weapon = SEL_SCRGNAIL;
	else if (self.impulse == 10)
		CycleWeaponCommand ();
	else if (self.impulse == 12)
		CycleWeaponReverseCommand ();

// TDO: eweapon checks - can fire lasers & prox bombs
// TDO: alt fire
// TDO: quad & dmg runes increase nail fire (6 slots for runes, 8 slots for quad)

	if (self.weapon == SEL_SCRGNAIL)
	{
		self.items = self.items | IT_NAILS;
		sprint(self, "Scourge firing ( perforator )\n"); 
	}
	if (self.weapon == SEL_SCRGTAIL)
	{
//		self.items = self.items | IT_NAILS;
		sprint(self, "Scourge firing ( stinger )\n"); 
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
		if (p.armorvalue >= SCOURGE_ARMORMAX) // TDO: || !IS_SARMOR(p))
			return FALSE;

	if ((ign == GIVEARMOR) || p.health >= ((p.max_health * p.health_modifier) - (p.max_health / 2.0)))
		{
		if (p.armortype == 0) //start armor
			{
			p.armortype = ARM_SCRG; // better armor at higher classes
			p.items = p.items - (p.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR1;
//			if (self.morphnum != IS_SCOURGE) p.mode_y = p.mode_y - (p.mode_y & (IV_ARM1 | IV_ARM2 | IV_ARM3)) + IV_ARM1;
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

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_scourge_become = 
{
	float tr,tc; // swap out cells, rockets

	self._stand = player_scourge_stand;
	self._run = player_scourge_run;
	self._pain = player_scourge_pain;
	self._die = player_scourge_die;
	self._jump = SUB_False;
	self._jump2 = SUB_False;
	self._attack = player_scourge_attack;
	self._impulse = player_scourge_impulse;
//	self._can_get_p=SUB_True; // player_scourge_can_get;
//	self._killmsg=player_scourge_killmsg;
//	self._killmsg2=player_scourge_killmsg2;

	setmodel(self,"progs/scor.mdl");
//	self.modelindex_morph=self.modelindex;
//	self.mask_x = CB_SCOURGE;
	self.items = IT_AXE | IT_SHOTGUN;
	self.weapon = SEL_SCRGNAIL;
	SEL_SCRGNAIL = IT_SHOTGUN;
	SEL_SCRGTAIL = IT_AXE;
	
//	self.hk_primary = SEL_SCRGNAIL;
//	self.hk_secondary = SEL_SCRGTAIL;
	self.msight = "scrg/sight.wav";
	self.noise2 = "scrg/pain2.wav";
	self.noise3 = "";
	self.view_ofs = ' 0 0 5'; // lowered to 12 first then 7 more
	self.dest2_z = 0; // TDO: what is this?!
//	if(!deathmatch)
//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
		setsize (self, '-16 -16 -24', ' 16 16 16'); //scourge height correct, XY dim cant be set bigger

	self.health = self.health * MSCOURGE_HEALMOD / self.health_modifier;
	self.health_modifier = MSCOURGE_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);


//	fake_load(MC_ROTOR,ST_ROTOR); // FIX wont really be needed

	if (self.armortype == 0) //scourge has some base armor on create
		{
		player_scourge_armor(self, 50, GIVEARMOR); 
		}
//	else - should not have armor here!
//		self.armortype = ARM_SCRG; // norm armor convert to scourge armor FIX

	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become a scourge.\n");
//		player_scourge_impulse();
//		morph_impulse();
		}
};
