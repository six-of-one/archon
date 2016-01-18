/* ::-::
 *
 * Cataboligne
 *
 * file: q3items.qc
 *
 * date: 10/16/08
 *
 * qc - support q3 stuff so darkplaces can run q3 maps for painkeep
 *
 */

// q3 values

float Q3_DEFW					= 123;
float Q3_DEFA					= 100;

float Q3_MAX					= 200;
float Q3_HA_MAX				= 100;

// ammo skins in mdl
float q3_bfg_amsk				= 0;
float q3_rail_amsk			= 1;
float q3_plasma_amsk			= 2;
float q3_lightn_amsk			= 3;
float q3_rocket_amsk			= 4;
float q3_grenade_amsk		= 5;
float q3_shot_amsk			= 6;
float q3_mach_amsk			= 7;

// artifact frames / skins in mdl
float q3_quad_fsk				= 0;
float q3_regn_fsk				= 1;
float q3_env_fsk				= 2;
float q3_hst_fsk				= 3;
float q3_flt_fsk				= 4;
float q3_inv_fsk				= 5;

float Q3_BFG_AMMO				= 150; // 15 - adj =10 cells per shot -- using cell ammo for now
float Q3_SLUG_AMMO			= 10;
float Q3_CELL_AMMO			= 30;
float Q3_ELEX_AMMO			= 60;
float Q3_ROCK_AMMO			= 5;
float Q3_GREN_AMMO			= 5;
float Q3_SHOT_AMMO			= 10;
float Q3_BULLET_AMMO			= 50;

float Q3_MAX_BULLETS			= 200;	// max val without pack / rune
float Q3_MAX_SHELLS			= 200;
float Q3_MAX_ROCKETS			= 200;
float Q3_MAX_CELLS			= 200;
//float Q3_MAX_BFG				= 200;
//float Q3_MAX_LIGHTNING		= 200;
float Q3_MAX_SLUGS			= 200;
float Q3_MAX_GRENADES		= 200;

float Q3_ARM_RED				= 100;
float Q3_ARM_YEL				= 50;
float Q3_ARM_SHARD			= 5;
float Q3_ARM_MAX				= 200;

float Q3_WEP_WAIT				= 5;
float Q3_AMMO_WAIT			= 40;
float Q3_HEAL_WAIT			= 35;
float Q3_ARM_WAIT				= 25;

float Q3_HEALLG				= 0; // skin ? - not needed for now
float Q3_HEALMD				= 1;
float Q3_HEAL5					= 2;
float Q3_HEALM					= 3;

float Q3_HEALLG_A				= 50;
float Q3_HEALMD_A				= 25;
float Q3_HEAL5_A				= 5;
float Q3_HEALM_A				= 100;

float Q3_BARREL_BLAST		= 120;


vector Q3_LIFT					= ' 0 0 20'; // q3 models sit too "low" - lift them by this on spawn

//string Q3_BOBHOFF				= "cl_itembobheight 0\n"; // q3 item bob height off setting
string Q3_BOBH					= "cl_itembobheight 8\n"; // q3 item bob height default - compile as 0 to disable (server cfg parm?)
string Q3_BOBHALIAS			= "q3bobheight\n"; // q3 item bob height alias to run

float q3_bob_on; // server cfg this to 1 for total disable
// for q3 maps
// = 0, q3 bob is off
// = 1, q3 bob is activated
// = -1 q3 bob is waiting activation by player stuff - items cant stuff

void() q3_precache =
{
// all ammo
// weps
// 1pv
// carry
	precache_model ("progs/q3_ammobox.mdl");
	precache_model ("progs/q3_arm.mdl");
	precache_model ("progs/q3_arm_shard.mdl");
	precache_model ("progs/q3_art.mdl");
	precache_model ("progs/q3_bfg.mdl");
	precache_model ("progs/q3_gauntlet.mdl");
	precache_model ("progs/q3_gl.mdl");
	precache_model ("progs/q3_grapple.mdl");
	precache_model ("progs/q3_health.mdl");
	precache_model ("progs/q3_hld_med.mdl");
	precache_model ("progs/q3_hld_tel.mdl");
	precache_model ("progs/q3_lg.mdl");
	precache_model ("progs/q3_mgun.mdl");
	precache_model ("progs/q3_plg.mdl");
	precache_model ("progs/q3_rail.mdl");
	precache_model ("progs/q3_rl.mdl");
	precache_model ("progs/q3_shot.mdl");
	precache_model ("progs/v_q3_bfg.mdl");
	precache_model ("progs/v_q3_gl.mdl");
	precache_model ("progs/v_q3_hawk.mdl");
	precache_model ("progs/v_q3_lg.mdl");
	precache_model ("progs/v_q3_mgun.mdl");
	precache_model ("progs/v_q3_mini.mdl");
	precache_model ("progs/v_q3_plg.mdl");
	precache_model ("progs/v_q3_rail.mdl");
	precache_model ("progs/v_q3_rl.mdl");
	precache_model ("progs/v_q3_shot.mdl");
	precache_model ("progs/vw_q3_bfg.mdl");
	precache_model ("progs/vw_q3_gl.mdl");
	precache_model ("progs/vw_q3_lg.mdl");
	precache_model ("progs/vw_q3_mg.mdl");
	precache_model ("progs/vw_q3_plg.mdl");
	precache_model ("progs/vw_q3_rail.mdl");
	precache_model ("progs/vw_q3_rl.mdl");
	precache_model ("progs/vw_q3_ssg.mdl");
	precache_model ("progs/vw_q3_gauntlet.mdl");

// hear it
// art
// fire
	precache_sound ("sound/q3_snd/plasmx1a.wav");
	precache_sound ("sound/q3_snd/hyprbf1a.wav");
	precache_sound ("sound/q3_snd/ar3_pkup.wav");
	precache_sound ("sound/q3_snd/ar2_pkup.wav");
	precache_sound ("sound/q3_snd/ar1_pkup.wav");
	precache_sound ("sound/q3_snd/airout.wav");
	precache_sound ("sound/q3_snd/use_medkit.wav");
	precache_sound ("sound/q3_snd/regeneration.wav");
	precache_sound ("sound/q3_snd/regen.wav");
	precache_sound ("sound/q3_snd/quaddamage.wav");
	precache_sound ("sound/q3_snd/poweruprespawn.wav");
	precache_sound ("sound/q3_snd/invisibility.wav");
	precache_sound ("sound/q3_snd/holdable.wav");
	precache_sound ("sound/q3_snd/haste.wav");
	precache_sound ("sound/q3_snd/flight.wav");
	precache_sound ("sound/q3_snd/s_health.wav");
	precache_sound ("sound/q3_snd/n_health.wav");
	precache_sound ("sound/q3_snd/m_health.wav");
	precache_sound ("sound/q3_snd/l_health.wav");
	precache_sound ("sound/q3_snd/hgrenb1a.wav");
	precache_sound ("sound/q3_snd/rocklx1a.wav");
	precache_sound ("sound/q3_snd/lg_hum.wav");
	precache_sound ("sound/q3_snd/bfg_hum.wav");
	precache_sound ("sound/q3_snd/rg_hum.wav");
	precache_sound ("sound/q3_snd/gaunthum.wav");
	precache_sound ("sound/q3_snd/gauntrun.wav");
	precache_sound ("sound/q3_snd/lg_fire.wav");
	precache_sound ("sound/q3_snd/railgf1a.wav");
	precache_sound ("sound/q3_snd/bfg_fire.wav");
	precache_sound ("sound/q3_snd/grenlf1a.wav");
	precache_sound ("sound/q3_snd/machgf1b.wav");
	precache_sound ("sound/q3_snd/rocklf1a.wav");
	precache_sound ("sound/q3_snd/sshotf1b.wav");
	precache_sound ("sound/q3_snd/w_pkup.wav");
	precache_sound ("sound/q3_snd/am_pkup.wav");
	precache_sound ("sound/q3_snd/respawn1.wav");
	precache_sound ("sound/q3_snd/dr1_end.wav");
	precache_sound ("sound/q3_snd/dr1_strt.wav");
	precache_sound ("sound/q3_snd/pt1_end.wav");
	precache_sound ("sound/q3_snd/pt1_mid.wav");
	precache_sound ("sound/q3_snd/pt1_strt.wav");

};

// bob em - needs called from client capable of stuff cmd

// IDEA: consider recrafted q3 maps with wad == "q3.wad"

void() q3_bob_height =
{
//	if (q3_bob_on > 0) return;
//	if (q3_bob_on == 0) q3_bob_on = -1;

	if (!self.flags & FL_CLIENT) return;
	if (!self.ishuman) return; // already tested, but just in case

	if (TR_Q3 > 0)
	{
		if (TR_Q3 != FL_TR_Q3) // dont bob if translating all q3 items
		{
			stuffcmd(self, Q3_BOBHOFF);
			q3_bob_on = 0;
			return;
		}
	}

	q3_bob_on = 1;
	stuffcmd(self, Q3_BOBH); // bob q3 items, heh heh
	stuffcmd(self, Q3_BOBHALIAS); // alias override
};

/*
deprecating for full support - need this in translate

q3 support via translation

*/

float SUSPENDED = 1; // some q3 items "float" in the air - hope this works

// fn(q3_suspend) - make q3 items suspended as per q3 map spawnflag SUSPEND

// NOTE: possible issue if pk grap interacts with these - IDEA: mod grap to temp change movetype & restore with ip repos

void() q3_suspend =
{
	self.map = "Q3";
	self.movetype = MOVETYPE_NONE;
};

// fn(X_FireGauntlet) - fire gauntlet & maybe other x weps

void () X_FireGauntlet =
{
	local vector source;
	local vector org;
	local float gdmg;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16'; // TWEAK: adjust for actual gauntlet blade pos!
	if (self.classname == "pk*bot")
	{
		source = botaim ();
	}

	gdmg = 25;
	if (EWEAP)
	{
		if (EWEAP.dmg > 0) gdmg = EWEAP.dmg;
		if (EWEAP.noise3) sound (self, CHAN_BODY, EWEAP.noise3, 1, ATTN_NORM);
	}

	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', gdmg);
		T_Damage (trace_ent,self,self,gdmg);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}
};

// fn(player_gauntlet1) - fire q3 gaunglet melee weapon (an possibly other xwep melee devices

// axatt1 axatt2 axatt3 axatt4 axatt5 axatt6
// fire frames
// 84 - main - axatt2 - wait here
// 85 - slice frame - axatt3
// 86 - slice down frame - axatt4
// 83 - release, hold .4

// exit set - holds gauntlet up for 0.4 - which happens to be att fin as well

void() player_gauntlet4 = [$axatt1, player_gauntlet5] { };
void() player_gauntlet5 = [$axatt1, player_gauntlet6] { };
void() player_gauntlet6 = [$axatt1, player_gauntlet7] { };
void() player_gauntlet7 = [$axatt1, player_gauntlet8] { };
void() player_gauntlet8 = [$axstnd12, player_stand1] { };

void() player_gauntlet1 =
{
	self.nextthink = time + 0.1;
	self.think = player_gauntlet1;

	if (self.tomb_time > GUN_BASE)
	{
		if (self.weaponframe > 1)
			self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe >= 6)
			self.weaponframe = 1;
		self.frame = $axatt2;
		self.tomb_time = self.tomb_time - 1;
		if (self.tomb_time <= GUN_BASE) // done - go back
		{
			self.tomb_time = 0;
			player_gauntlet4();
		}
		if (!self.button0)
		{
			if (self.velocity_x || self.velocity_y)
			{
				self.tomb_time = 0;
				player_run();
			}
			return;
		}
		else
		{
			self.tomb_time = 0;
			self.weaponframe = 0;
//			if (self.eweapon)
//				setorigin(self.eweapon, self.eweapon.origin + ' 0 0 1.33');  // kicked gun up - not using for now
		}
	}

	if (self.weaponframe > 3)
		self.weaponframe = 0;

// NOTE: need to take gauntlet vw model thru blade rotate frames & little elex bolts

	if (self.weaponframe == 3) // fire!
	{
		self.frame = $axatt3;
		EWEAP = self.eweapon;
		SuperDamageSound();
		if (EWEAP.mdl == "progs/vw_q3_gauntlet.mdl")
			X_FireGauntlet();
		else
		W_FireAxe();

		self.nextthink = time + EWEAP.attack_finished;
		if (!rune_haste(EWEAP.attack_finished / 2))
			self.nextthink = time + EWEAP.attack_finished / 2;

		EWEAP = world;
		self.tomb_time = GUN_WAIT;
		return;
	}

	self.weaponframe = self.weaponframe + 1;

	if (self.weaponframe <= 1) // bring pistol up to fire
	{
		if (self.frame < $axatt2)
			self.frame = $axstnd8;
		return;
	}
	else
	{
		self.frame = $axatt2;		
	}

};

/*
q3 wep inventory slots

slot		weapon
1				gauntlet / grapple (when done) *
2				shotgun *
3				machine gun
4				plasma gun
5				railgun
6				grenade launcher
7				rocket launcher
8				bfg / lightning #

* = touch fn will replace other slot 1 & 2 weps with these
# = items are currently exclusive in touch - you can only get one

*/


/*QUAKED weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q3_weapon_bfg =
{
	q100_weapon_lightning();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		if (!Q_100 & !Q_99)
		{
			weapon_chainlg();
			self.pk_touch = painkeep_weapon_touch;
			self.classname = "weapon_chainlg";
		}
		return;
	}

	self.netname = "BFG";

	self.touch = x_weapon_touch;
	self._attack = X_Fire3BFG;
	self._fr_attack = player_shot1;

	self.items = IT_EXTRA_WEAPON;
	self.currentammo = 200; // 20 - adj =10 cells per shot -- using cell ammo for now
	self.lip = AMMO_BFG; // cells
	self.volume = Q3_MAX_CELLS;
	self.aflag = IGN_INV; // swap with *
	self.attack_finished = 0.2;
	self.dmg = 100;
	self.dodmg = 120;
	self.dmg_save = 10;
	self.dmg_take = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_bfg.mdl");
	self.weaponmodel = "progs/v_q3_bfg.mdl";
	self.vwepmdl = "progs/vw_q3_bfg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/bfg_fire.wav";
	self.noise2 = "q3_snd/bfg_hum.wav";
	self.target = "q3_snd/plasmx1a.wav"; // TDO: get right snd - CHECK: this
	self.chaosweptime = 0.93;
	self.duration = SND_OVER;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_plasmagun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_plasmagun =
{
	q100_weapon_lightning();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

	self.netname = "Plasma Gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_plasma1;

	self.items = IT_SUPER_NAILGUN;
	self.currentammo = 50;
	self.lip = AMMO_CELLS;
	self.volume = Q3_MAX_CELLS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 20;
	self.dodmg = 15;
	self.dmg_save = 1;
	self.dmg_take = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_plg.mdl");
	self.weaponmodel = "progs/v_q3_plg.mdl";
	self.vwepmdl = "progs/vw_q3_plg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.target = "q3_snd/plasmx1a.wav";
	self.duration = SND_OVER;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_machinegun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

// doing the same way even tho q3 doesnt offer a dbl yet
void() q3_mg_base =
{
// stats
	self.items = IT_NAILGUN;
	self.currentammo = 100;
	self.lip = AMMO_BULLETS;
	self.volume = Q3_MAX_BULLETS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 7;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.025 0.025 0';
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.netname = "Machine Gun";

	setmodel (self, "progs/q3_mgun.mdl");
	self.weaponmodel = "progs/v_q3_mgun.mdl";
	self.vwepmdl = "progs/vw_q3_mg.mdl";
};

void() q3_weapon_machinegun =
{
	weapon_supernailgun();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_supernailgun";
		return;
	}

	q3_mg_base();
	self.touch = x_weapon_touch;//wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/machgf1b.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() q3_weapon_shotgun =
{
	q100_weapon_supershotgun();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_supershotgun";
		return;
	}

	self.netname = "Shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q3_SHOT_AMMO;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = Q3_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = 10;
	self.dmg_save = 2;
	self.dmg_take = 11; // shot cnt
	self.punchangle = ' 0.14 0.08 0'; // bullet spread out -- TDO: get q3 value, this is q1
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_shot.mdl");
	self.weaponmodel = "progs/v_q3_shot.mdl";
	self.vwepmdl = "progs/vw_q3_ssg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/sshotf1b.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_rocketlauncher";
		return;
	}

	self.netname = "Rocket Launcher";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 10;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.volume = Q3_MAX_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 100;
	self.dodmg = 120; // splash
	self.dmg_save = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

// appearances
	setmodel (self, "progs/q3_rl.mdl");
	self.weaponmodel = "progs/v_q3_rl.mdl";
	self.vwepmdl = "progs/vw_q3_rl.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/rocklf1a.wav";
	self.target = "q3_snd/rocklx1a.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () q3_weapon_grenadelauncher =
{
	q100_weapon_grenadelauncher();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_grenadelauncher";
		return;
	}

	self.netname = "Grenade Launcher";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireGrenade;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 10;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_GRENADES;
	self.volume = Q3_MAX_GRENADES;
	self.attack_finished = 0.8;
	self.dmg = 100;
	self.dodmg = 150; // splash
	self.dmg_save = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

// appearances
	setmodel (self, "progs/q3_gl.mdl");
	self.weaponmodel = "progs/v_q3_gl.mdl";
	self.vwepmdl = "progs/vw_q3_gl.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/grenlf1a.wav";
	self.target = "q3_snd/hgrenb1a.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};


void () weapon_gauntlet =
{
	weapon_axe();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = x_weapon_touch;
		self.classname = "weapon_axe";
		return;
	}

	self.netname = "Gauntlet";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_gauntlet1;

	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = 0;
	self.attack_finished = 0.4;
	self.dmg = 50;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.vv_draw = vw_q3_gaunt;

	setmodel (self, "progs/q3_gauntlet.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
	self.vwepmdl = "progs/vw_q3_gauntlet.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/gauntrun.wav";
	self.noise2 = "q3_snd/gaunthum.wav"; // gun hum
	self.chaosweptime = 1.99;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};


/*QUAKED weapon_grapplinghook (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void () weapon_grapgun;

void () weapon_grapplinghook =
{
	weapon_grapgun();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = painkeep_weapon_touch;
		self.classname = "weapon_grapgun";
		return;
	}

	self.netname = "Grappling hook";

/*
	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_;

	self.currentammo = 0;
//	self.items = IT_AXE; // using grap gun
	self.lip = 0;
	self.attack_finished = 0.5;
	self.dmg = 5;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
*/
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_grapple.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
//	self.vwepmdl = "progs/vw_q3_.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/gauntrun.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () q3_weapon_lightning =
{
	q100_weapon_lightning();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

	self.netname = "Lightning Gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_light1;

	self.currentammo = 100;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_LIGHTNING; // really cells
	self.volume = Q3_MAX_CELLS;
	self.attack_finished = 0.1; // TDO: separate from q1 lg fire ??
	self.dmg = 8;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_lg.mdl");
	self.weaponmodel = "progs/v_q3_lg.mdl";
	self.vwepmdl = "progs/vw_q3_lg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/lg_fire.wav";
//	self.noise2 = "q3_snd/lg_hum.wav"; // ? - could have been 1 lg used to use - CHECK
	self.chaosweptime = 0.964;
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () q3_weapon_railgun =
{
	q100_weapon_lightning();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		if (!Q_100 & !Q_99)
		{
			weapon_chainlg();
			self.pk_touch = painkeep_weapon_touch;
			self.classname = "weapon_chainlg";
		}
		return;
	}

	self.netname = "Rail Gun";

	self.touch = x_weapon_touch;
	self._attack = X_FireRailgun;
	self._fr_attack = player_rocket1;

	self.currentammo = Q3_SLUG_AMMO;
	self.aflag = IGN_INV; // swap with sgs
	self.items = IT_SHOTGUN;
	self.lip = AMMO_SLUGS;
	self.volume = Q3_MAX_SLUGS;
	self.attack_finished = 1.5;
	self.dmg = 100;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	if (!self.wait) self.wait = RSP_TIME * 0.1666;
	self.lefty = Q3_RAILBEAM;

	setmodel (self, "progs/q3_rail.mdl");
	self.weaponmodel = "progs/v_q3_rail.mdl";
	self.vwepmdl = "progs/vw_q3_rail.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/railgf1a.wav"; // TDO: impact site snd
	self.noise2 = "q3_snd/rg_hum.wav"; // gun hum
	self.chaosweptime = 1.16;
	self.endtime = 1.55;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_ammo_bullets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_spikes();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_BULLET_AMMO;
		return;
	}

	self.netname = "Bullets";

	self.lip = AMMO_BULLETS;
	self.volume = Q3_MAX_BULLETS;
	self.currentammo = Q3_BULLET_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_mach_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() q3_ammo_grenades =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_rockets();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_GREN_AMMO;
		return;
	}

	self.netname = "Grenades";

	self.lip = AMMO_GRENADES;
	self.volume = Q3_MAX_GRENADES;
	self.currentammo = Q3_GREN_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_grenade_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() ammo_lightning =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Cells";

	self.lip = AMMO_LIGHTNING; // cells
	self.volume = Q3_MAX_CELLS;
	self.currentammo = Q3_ELEX_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_lightn_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() ammo_bfg =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Cells";

	self.lip = AMMO_BFG; // cells - amount adjusted to fire proper count of bfg shots
	self.volume = Q3_MAX_CELLS;
	self.currentammo = Q3_BFG_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_bfg_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

// spawnfunc_ - because quake already has variables ammo_* and the function names cannot be used
//  -- darkplaces has a special call mode for map items that appends spawnfunc_ to cover stuff like this

//ammo_shells
//ammo_rockets
//ammo_cells

void() q3_ammo_shells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_SHOT_AMMO;
		return;
	}

	self.netname = "Shells";

	self.lip = AMMO_SHELLS;
	self.volume = Q3_MAX_SHELLS;
	self.currentammo = Q3_SHOT_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_shot_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() q3_ammo_rockets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_rockets();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_ROCK_AMMO;
		return;
	}

	self.netname = "Rockets";

	self.lip = AMMO_ROCKETS;
	self.volume = Q3_MAX_ROCKETS;
	self.currentammo = Q3_ROCK_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_rocket_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() q3_ammo_cells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Cells";

	self.lip = AMMO_CELLS;
	self.volume = Q3_MAX_CELLS;
	self.currentammo = Q3_CELL_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_plasma_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

//ammo_slugs

void() q3_ammo_slugs =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Slugs";

	self.lip = AMMO_SLUGS;
	self.volume = Q3_MAX_SLUGS;
	self.currentammo = Q3_SLUG_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_rail_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

// armors + healths

void() q3_ha_rot_thk =
{
	local float f;

	f = FALSE;
	if (self.owner.health > Q3_HA_MAX)
	{
		self.owner.health = self.owner.health - 1;
		f = TRUE;
	}
	if (self.owner.rune_flag & RUNE_FLG_RG) // no rot when regen rune is set
		f = TRUE;
	else
	if (self.owner.armorvalue > Q3_HA_MAX)
	{
		armorsave_rev(self.owner);
		self.owner.armorvalue = self.owner.armorvalue - 1;
		f = TRUE;
	}
	if (f)
		self.nextthink = time + 1;
	else
		remove(self);
};

void(entity e, float v) q3_ha_rot =
{
	local entity f;

	if (v > Q3_HA_MAX)
	{
		f = find(world,classname,"q3_rot");
		while (f)
		{
			if (f.owner == e)
			{
				f.nextthink = time + 5; // reset with new acq
				return;
			}
			f = find(f,classname,"q3_rot");
		}
		chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "q3_rot", "", SUB_Null, 5, q3_ha_rot_thk, SUB_Null, e, world);
	}
};


void() q3_item_armor_combat =
{
	item_armor2();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armor1";
		return;
	}

	self.netname = "Armor";

	self.volume = 200; // max add
	self.currentammo = Q3_ARM_YEL; // 50 units
	self.style = 0.6;
	self.items = IT_ARMOR2;
	if (!self.wait) self.wait = RSP_TIME * 0.8333;

	setmodel (self, "progs/q3_arm.mdl");
	self.noise = "q3_snd/ar2_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = 0;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_armor_body =
{
	item_armorInv();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armorInv";
		return;
	}

	self.netname = "Heavy Armor";

	self.volume = 200; // max add
	self.style = 0.6;
	self.currentammo = Q3_ARM_RED; // 100 units
	self.items = IT_ARMOR3;
	if (!self.wait) self.wait = RSP_TIME * 0.8333;

	setmodel (self, "progs/q3_arm.mdl");
	self.noise = "q3_snd/ar3_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = 1;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_armor_shard =
{
	item_armor1();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, FALSE, ""))
	{
		return;
	}

	self.netname = "Armor shard";

	setmodel (self, "progs/q3_arm_shard.mdl");
	self.volume = 200; // max add
	self.style = 0.3;
	self.items = IT_ARMOR1;
	self.currentammo = Q3_ARM_SHARD; // 2 units
	if (!self.wait) self.wait = RSP_TIME * 0.8333;

	self.noise = "q3_snd/ar1_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;

	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_health_small =
{
	q100_item_health();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.healamount = Q3_HEAL5_A;
		return;
	}

	self.netname = "5 health";

	self.healamount = Q3_HEAL5_A;
	self.healtype = HEAL_BOT; // TDO: special q3 rot - isnt this done ?? CHECK

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/s_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEAL5;
	self.volume = 200; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.1666;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_health =
{
	q100_item_health();
	
	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
		return;

	self.netname = "25 health";

	self.healamount = Q3_HEALMD_A;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.1666;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/n_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEALMD;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_health_large =
{
	q100_item_health();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.healamount = Q3_HEALLG_A;
		return;
	}

	self.netname = "50 health";

	self.healamount = Q3_HEALLG_A;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.1666;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/l_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEALLG;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_health_mega =
{
	self.spawnflags = self.spawnflags | 2;
	q100_item_health();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, "item_health_mega"))
	{
		return;
	}

	self.netname = "Mega health";

	self.healamount = Q3_HEALM_A;
	self.healtype = HEAL_MEGA;
	self.volume = 200; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/m_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEALM;
	self.frame = 1;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_quad =
{
	item_artifact_super_damage();
	
	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	self.netname = "Quad Damage";

	self.touch = x_pwr_touch;
	self.items = IT_QUAD;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/quaddamage.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_quad_fsk;
	self.skin = q3_quad_fsk;
	self.alpha = 0.9;

	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// code for q3 arts that use rune effects

void() q3_pwr_touch =
{
	local entity e;

	if (other.classname != "player") // bot handled by pk_touch
			return;
	if (other.health <= 0)
		return ;

	if (other.rune_flag & self.spawnflags) // already using this rune power - just go back
		return;

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	if (Q_99 || (deathmatch != 4)) // *pk - my new rule, logical extrapolation
	if (deathmatch)
	{
		self.mdl = self.model;
//		if (self.wait)
//			self.nextthink = time + self.wait;
//		else
		self.nextthink = time + RSP_TIME * 2; // = 60 default
		self.think = SUB_regen;
	}

	other.rune_flag = other.rune_flag | (self.spawnflags);// -- flight & mask deal -- & RUNE_MASK_ALL); // still qualify one of the valid runes
	other.target2 = self.model;

	if (self.spawnflags & RUNE_FLG_FLY) other.movetype = MOVETYPE_FLY;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

	e = spawn();
	if (e)
	{
		e.classname = "rune_1_expiry";
		e.netname = self.netname;
		e.rune_flag = self.spawnflags; // & RUNE_MASK_ALL; // NOTE: not really needed as long as bit for inv item is set right
		e.think = rune_1_expire;
		if (self.dmgtime)
			e.nextthink = time + self.dmgtime;
		else
		e.nextthink = time + POW_TIME;
		e.owner = other;
		e.noise4 = self.noise4;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
};

void() item_regen =
{
	if (self.class_select == "") self.class_select = "q3_item";

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, "item_artifact_invulnerability")) // IDEA: random possibilities via str func
	{
		return;
	}

	self.spawnflags = RUNE_FLG_RG;
	self.duration = 0;
//	item_sigil();
	self.netname = "Regeneration";

	self.touch = q3_pwr_touch;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/regeneration.wav";
	self.noise3 = "q3_snd/regen.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_regn_fsk;
	self.skin = q3_regn_fsk;
	self.alpha = 0.9;

	if (self.spawnflags & SUSPENDED) q3_suspend();
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

void() item_invis =
{
	item_artifact_invisibility();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	self.netname = "Invisibility";

	self.touch = x_pwr_touch;
	self.items = IT_INVISIBILITY;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/invisibility.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_inv_fsk;
	self.skin = q3_inv_fsk;
	self.alpha = 0.5;

	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() q3_item_enviro =
{
	item_artifact_envirosuit();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	self.netname = "Battle Suit";

	self.touch = x_pwr_touch;
	self.items = IT_SUIT;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/airout.wav"; // CHK: this doesnt make sense
	self.noise3 = "q3_snd/airout.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
//	self.message = "Battle Suit expiring\n"; //"Environmental protection expiring\n";
	self.frame = q3_env_fsk;
	self.skin = q3_env_fsk;
	self.alpha = 0.9;

	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_haste =
{
	if (self.class_select == "") self.class_select = "q3_item";

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, "item_artifact_invulnerability"))
	{
		return;
	}

	self.spawnflags = RUNE_FLG_HS;
	self.duration = 0;
//	item_sigil();
	self.netname = "Haste";

	self.touch = q3_pwr_touch;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/haste.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_hst_fsk;
	self.skin = q3_hst_fsk;
	self.alpha = 0.9;

	if (self.spawnflags & SUSPENDED) q3_suspend();
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

void() item_flight =
{
	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, "item_artifact_super_damage"))
	{
		return;
	}

	item_spikes();
	self.netname = "Flight";

	self.touch = q3_pwr_touch;
	self.spawnflags = RUNE_FLG_FLY;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/flight.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_flt_fsk;
	self.skin = q3_flt_fsk;
	self.alpha = 0.9;

	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// holdables
void() item_painkeep_can;
void() item_pkplus_phone;

void() holdable_medkit =
{
	item_painkeep_can();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	if (PK_100) return;

	self.netname = "Holdable Medkit";

	if (!self.wait) self.wait = RSP_TIME * 2;

	setmodel(self, "progs/q3_hld_med.mdl");
	self.vwepmdl = "";
	self.noise = "q3_snd/holdable.wav";
	self.noise4 = "q3_snd/respawn1.wav";

	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() holdable_teleporter =
{
	item_pkplus_phone();

	if (!ULOK3)
	if (!GENERATIONS)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	if (PK_100) return;

	self.netname = "Holdable Teleport";

	if (!self.wait) self.wait = RSP_TIME * 2;

	setmodel(self, "progs/q3_hld_tel.mdl");
	self.vwepmdl = "";
	self.noise = "q3_snd/holdable.wav";
	self.noise4 = "q3_snd/respawn1.wav";

	if (time < PIC_TO && self.class_select == "pkplus_item") self.class_select = "q3_item"; // TDO: remove when not needed
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// hack just to match others - q3 has no explode boxes - and appearances can be deceiving

// IDEA: box model or some such

void() q3_misc_explobox =
{
	local float r;
	self.netname = "Barrel";
	if (self.class_select == "") self.class_select = "q3_item";
	misc_explodbox_set(self, "progs/d_barrel.mdl", Q3_BARREL_BLAST, 80, MOVETYPE_NONE);

	r = rint(3 * random());
	if (r == 1)
	{
	setmodel (self, "progs/q3_ammobox.mdl");
	self.frame = 0;
	self.skin = q3_bfg_amsk;
	}
	else if (r == 2)
	{
	setmodel (self, "progs/q3_arm.mdl");
	self.frame = 0;
	self.skin = 1;
	}
	else if (r == 3)
	{
	setmodel(self, "progs/q3_health.mdl");
	self.frame = 1;
	self.skin = Q3_HEALM;
	}
	else //if (r == 0)
	{
	setmodel(self, "progs/q3_art.mdl");
	self.frame = q3_regn_fsk;
	self.skin = q3_regn_fsk;
	}
//	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "q3_snd/respawn1.wav";

	if (!self.wait) self.wait = RSP_TIME;
//	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// enable other q3 map ents

/*		q3 ---
	QUAKED info_player_intermission (1 0 1) (-16 -16 -16) (16 16 16)
Camera for intermission screen between matches. This also automatically generates the podium for bot arena matches (see Notes). Can be aimed by setting the "angles" key or targeting an pointing to an aiming entity. Use only one per level.
-------- KEYS --------
angles: alternate "pitch, yaw, roll" angles method of aiming intermission camera (default 0 0 0).
target : point this to an info_notnull or target_position entity to set the camera's pointing angles.
-------- NOTES --------
In genuine bot arena matches, the podium for the 1st, 2nd and 3rd place players at the end of the match is generated by this entity. The podium's origin will automatically be located 128 units in the direction of the camera's view and 84 units down from the y height of the view line at that point. It will also always be generated on a level plane regardless of the pointing angle of the camera so if that angle is too steep, part of the podium model might not be visible. Make sure you leave at least 106 units of free space in front of where the camera points to otherwise the podium model won't be visible at all.
*/

void() info_player_intermission =
{

};

/*		q3 ---
	QUAKED target_position (0 .5 0) (-8 -8 -8) (8 8 8)
Aiming target for entities like light, misc_portal_camera and trigger_push (jump pads) in particular.
-------- KEYS --------
targetname : the entity that requires an aiming direction points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
To make a jump pad, place this entity at the highest point of the jump and target it with a trigger_push entity.
*/

void() target_position =
{

};


/*		q3 ---
	QUAKED misc_teleporter_dest (1 .5 .25) (-32 -32 -24) (32 32 -16)

Teleport destination location point for trigger_teleporter entities.
-------- KEYS --------
angle : direction in which player will look when teleported.
targetname : make the trigger_teleporter point to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
*/


void() misc_teleporter_dest =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
	{
		if (Q_100 && Q_100_OBJERR) objerror ("no targetname");
		bprint("q3 - misc_teleporter_dest missing name! please repair the map...\n");
		self.targetname = ftos(floor(random() * 65535));
	}

};

// altarbetas teleporter for some reason - works in q3

void() target_teleporter =
{
	misc_teleporter_dest();
};

// some q3 triggers may be like this ??

void() misc_teleporter =
{
	trigger_teleport();
	if (world.wad == "q2.wad")
	{
		chaos_spawn(0, 0, 0, 0,  self.origin, v0, v0, v0, v0, "", "", SUB_Null, 1, q2_teleport_particles, SUB_Null, self, world);
		ambientsound (self.origin + ' 0 0 32', "q2_snd/telehum.wav", 1, ATTN_STATIC);
	}
};

// fn(q3_play_sound) - play a sound for target_speaker, repeating or by activator
// fn(q3_sound_think) - periodic repeating sound for target speaker

float Q3_LOOPON				= 1;
float Q3_LOOPOFF				= 2;
float Q3_GLOBAL				= 4;
float Q3_ACTIVATOR			= 8;

void() q3_play_sound =
{
	sound (self, CHAN_AUTO, self.noise, 1, self.aflag);
};

void() q3_sound_think =
{
	q3_play_sound();
	self.nextthink = time + self.wait + 5 * random();
};

/*		q3 ---
	QUAKED target_speaker (0 .7 .7) (-8 -8 -8) (8 8 8) LOOPED_ON LOOPED_OFF GLOBAL ACTIVATOR
Sound generating entity that plays .wav files. Normal non-looping sounds play each time the target_speaker is triggered. Looping sounds can be set to play by themselves (no activating trigger) or be toggled on/off by a trigger.
-------- KEYS --------
noise : path/name of .wav file to play (eg. sound/world/growl1.wav - see Notes).
wait : delay in seconds between each time the sound is played ("random" key must be set - see Notes).
random : random time variance in seconds added or subtracted from "wait" delay ("wait" key must be set - see Notes).
targetname : the activating button or trigger points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- SPAWNFLAGS --------
LOOPED_ON : sound will loop and initially start on in level (will toggle on/off when triggered).
LOOPED_OFF : sound will loop and initially start off in level (will toggle on/off when triggered).
GLOBAL : sound will play full volume throughout the level.
ACTIVATOR : sound will play only for the player that activated the target.
-------- NOTES --------
The path portion value of the "noise" key can be replaced by the implicit folder character "*" for triggered sounds that belong to a particular player model. For example, if you want to create a "bottomless pit" in which the player screams and dies when he falls into, you would place a trigger_multiple over the floor of the pit and target a target_speaker with it. Then, you would set the "noise" key to "*falling1.wav". The * character means the current player model's sound folder. So if your current player model is Visor, * = sound/player/visor, if your current player model is Sarge, * = sound/player/sarge, etc. This cool feature provides an excellent way to create "player-specific" triggered sounds in your levels.

The combination of the "wait" and "random" keys can be used to play non-looping sounds without requiring an activating trigger but both keys must be used together. The value of the "random" key is used to calculate a minimum and a maximum delay. The final time delay will be a random value anywhere between the minimum and maximum values: (min delay = wait - random) (max delay = wait + random).
*/
void() target_speaker =
{
	precache_sound (self.noise);

	self.aflag = ATTN_NORM;
	if (self.spawnflags & Q3_GLOBAL) self.aflag = ATTN_NONE;

	self.use = q3_play_sound;

	if (self.flags & Q3_LOOPON)
	{
		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER); // FIX - want this for loopoff - problem is we need the sound length
	}
//	else if (self.flags & Q3_LOOPOFF) // finish this
//	{
//		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER);
//	}
	else if (self.wait)
	{
		self.think = q3_sound_think;
		self.nextthink = time + self.wait + 2 * crandom();
	}
};

// fn(q3trap_shooter_target) - finds target for q3 trap shooter if it has one, otherwise returns preset .movedir

vector() q3trap_shooter_target =
{
	local entity t;

// no target string
	if (self.target == "") return (self.movedir);

	t = find (world, targetname, self.target);
// target ent not found
	if (!t) return (self.movedir);
// found and targeted
	return (t.origin - self.origin);
};

// fn(q3_spikeshooter_use) - implement q3 shooters setup below

void() q3_spikeshooter_use =
{
	if (self.noise3 == "") self.noise3 = "weapons/spike2.wav";
	if (self.mdl == "") self.mdl = "progs/spike.mdl";
	if (self.delay < 100) self.delay = 500;

	sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	launch_spike (self.origin, q3trap_shooter_target());
	newmis.velocity = self.movedir * self.delay;
	setmodel (newmis, self.mdl);

	if (self.classname == "shooter_grenade")
	{
		newmis.classname = "grenade";
		newmis.movetype = MOVETYPE_BOUNCE;
		newmis.touch = GrenadeTouch;
		newmis.nextthink = time + 2.5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_rocket")
	{
		newmis.classname = "rocket";
		newmis.touch = T_MissileTouch;
		newmis.nextthink = time + 5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_plasma")
	{
		newmis.classname = "plasma";
		newmis.touch = spike_touch;
		newmis.nextthink = time + 5;
		newmis.think = SUB_Remove;
	}
	else
		newmis.touch = superspike_touch;
	
};

// fn(q3trap_shooter) - implement any of the q3 shooter traps

void() spikeshooter_use;

void() q3trap_shooter =
{
	SetMovedir ();
	self.use = q3_spikeshooter_use;

	precache_model ("progs/spike.mdl");
	precache_sound ("weapons/spike2.wav"); // defaults to a nail shooter trap if its buf'd up
};

/*		q3 ---
	QUAKED shooter_grenade (1 0 .5) (-8 -8 -8) (8 8 8)
This will shoot a grenade each time it's triggered. Aiming is done by setting the "angles" key or by targeting an info_notnull or target_position entity.
-------- KEYS --------
angles: this sets the pitch and yaw aiming angles of shooter (default 0 0). The roll angle does not apply.
targetname : activating trigger points to this.
target : this points to a target_position entity for aiming the grenades.
random : random aiming variance in degrees from the straight line to the targeted entity (default 0 - see Notes).
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
When the random key is set, its value is used to calculate a maximum angle deviation from the normal trajectory formed by a straight line between the shooter and the aiming entity it targets. The final trajectory will be a random value anywhere between no deviation at all (0) to maximum deviation (value of the random key).

Both the setting "angles" key or "targeting a target_position" methods can be used to aim the shooter. However, the target_position method is simpler.*/

// TDO: q3 sounds | models, implement target

void() shooter_grenade =
{
	precache_model ("progs/grenade.mdl");
	precache_sound ("weapons/grenade.wav");
	precache_sound ("weapons/bounce.wav");
	q3trap_shooter();
	self.mdl = "progs/grenade.mdl";
	self.noise2 = "weapons/bounce.wav";
	self.noise3 = "weapons/grenade.wav";
	self.delay = 400;
};

/*QUAKED shooter_plasma (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_plasma =
{
	precache_model ("progs/lavaball.mdl"); // TDO
	precache_sound ("q3_snd/hyprbf1a.wav");
	precache_sound ("q3_snd/plasmx1a.wav");
	q3trap_shooter();
	self.mdl = "progs/lavaball.mdl";
	self.noise2 = "q3_snd/plasmx1a.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.delay = 800;
};

/*QUAKED shooter_rocket (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_rocket =
{
	precache_model ("progs/missile.mdl");
	precache_sound ("weapons/sgun1.wav");
	q3trap_shooter();
	self.mdl = "progs/missile.mdl";
	self.noise3 = "weapons/sgun1.wav";
	self.delay = 1000;
};

