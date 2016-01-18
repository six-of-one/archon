/* ::-::
 *
 * Cataboligne
 *
 * file: q2ents.qc
 *
 * date: 6/27/10
 *
 * qc - support q2 stuff, converted maps
 *
 */

// q2 values
float Q2_DEF_HBOTTLE			= 2;
float Q2_DEF_HFIRSTAID		= 10;
float Q2_DEF_HMEDKIT			= 25;
float Q2_DEF_HMEGATUBE		= 100;

float Q2_ARM_TFLK				= 0.333;
float Q2_ARM_TCMB				= 0.6;
float Q2_ARM_TBDY				= 0.8;
float Q2_ARM_SHRD				= 2;
float Q2_ARM_FLAK				= 25;
float Q2_ARM_CMBT				= 50;
float Q2_ARM_BODY				= 100;

float Q2_DEF_SHELLS			= 10;		// small box
//float Q2_DEF_SHELLBOX		= 20;		// large box
float Q2_DEF_SHOTG			= 10;		// weapon def
//float Q2_DEF_BULLETS_CLIP	= 10;
float Q2_DEF_BULLETS_BOX	= 50;
float Q2_DEF_CHAING			= 50;
//float Q2_DEF_CELLBOX			= 100;
float Q2_DEF_CELLPAK			= 50;
float Q2_DEF_SLUGS			= 10;
float Q2_DEF_HYBERB			= 100;
float Q2_DEF_BFG				= 40;
float Q2_DEF_ROCKETS_LG		= 5;
float Q2_DEF_HGRN				= 5;
//float Q2_DEF_ROCKETS_SM		= 5;
float Q2_DEF_BLAST			= 5;

float Q2_MAX_BULLETS			= 200;	// max val without pack / rune
float Q2_MAX_SHELLS			= 100;
float Q2_MAX_ROCKETS			= 50;
float Q2_MAX_CELLS			= 200;
float Q2_MAX_SLUGS			= 50;
float Q2_MAX_GRENADES		= 50;

float Q2_BARREL_BLAST		= 150;

void() q2_precache =
{
	Q2_POWER_WAIT = RSP_TIME;
	Q2_POWER_TIME = POW_TIME;

//	precache_model ("");
//	precache_sound ("");

// items
//	precache_model ("progs/.mdl");
// ammo
//	precache_model ("progs/q2_.mdl");
// weps
	precache_model ("progs/q2_bfg.mdl");
	precache_model ("progs/q2_chain.mdl");
	precache_model ("progs/q2_dblshot.mdl");
	precache_model ("progs/q2_gl.mdl");
	precache_model ("progs/q2_hyperb.mdl");
	precache_model ("progs/q2_mgun.mdl");
	precache_model ("progs/q2_rail.mdl");
	precache_model ("progs/q2_rocketl.mdl");
	precache_model ("progs/q2_shotgun.mdl");
	precache_model ("progs/q2_blaster.mdl");
// view models
	precache_model ("progs/v_q2_bfg.mdl");
	precache_model ("progs/v_q2_blst.mdl");
	precache_model ("progs/v_q2_chg.mdl");
	precache_model ("progs/v_q2_gl.mdl");
	precache_model ("progs/v_q2_hbl.mdl");
	precache_model ("progs/v_q2_mg.mdl");
	precache_model ("progs/v_q2_rail.mdl");
	precache_model ("progs/v_q2_rl.mdl");
	precache_model ("progs/v_q2_shot.mdl");
	precache_model ("progs/v_q2_shot2.mdl");
// viswep
	precache_model ("progs/vw_q2_bfg.mdl");
	precache_model ("progs/vw_q2_blst.mdl");
	precache_model ("progs/vw_q2_chg.mdl");
	precache_model ("progs/vw_q2_dblshot.mdl");
	precache_model ("progs/vw_q2_gl.mdl");
	precache_model ("progs/vw_q2_hbl.mdl");
	precache_model ("progs/vw_q2_mg.mdl");
	precache_model ("progs/vw_q2_rail.mdl");
	precache_model ("progs/vw_q2_rock.mdl");
	precache_model ("progs/vw_q2_shot.mdl");
	precache_model ("progs/vw_q2_hgr.mdl");
// ammo
	precache_model ("progs/q2_cellbox.mdl");
	precache_model ("progs/q2_bullets.mdl");
	precache_model ("progs/q2_shells.mdl");
	precache_model ("progs/q2_rockets.mdl");
	precache_model ("progs/q2_slugs.mdl");
	precache_model ("progs/q2_grenades.mdl");
// heal
	precache_model ("progs/q2_heal_stimpak.mdl");
	precache_model ("progs/q2_heal_large.mdl");
	precache_model ("progs/q2_heal_medium.mdl");
	precache_model ("progs/q2_heal_mega.mdl");
//armor
	precache_model ("progs/q2_armorbody.mdl");
	precache_model ("progs/q2_armorcombat.mdl");
	precache_model ("progs/q2_armorjacket.mdl");
	precache_model ("progs/q2_armorshard.mdl");
	precache_model ("progs/q2_armorpower.mdl");
	precache_model ("progs/q2_armorscreen.mdl");
// items
	precache_model ("progs/q2_silencer.mdl");
	precache_model ("progs/q2_adrenaline.mdl");
	precache_model ("progs/q2_envirosuit.mdl");
	precache_model ("progs/q2_quad.mdl");
	precache_model ("progs/q2_inv.mdl");
	precache_model ("progs/q2_bando.mdl");
	precache_model ("progs/q2_pack.mdl");
	precache_model ("progs/q2_breather.mdl");
// keys
	precache_model ("progs/q2_keypyramid.mdl");
	precache_model ("progs/q2_keypower.mdl");
	precache_model ("progs/q2_keypass.mdl");
	precache_model ("progs/q2_keycd.mdl");
	precache_model ("progs/q2_keyspinner.mdl");
	precache_model ("progs/q2_keytarget.mdl");
	precache_model ("progs/q2_keyrb.mdl");
	precache_model ("progs/q2_key_cmd_head.mdl");

	precache_model ("progs/q2_barrel.mdl");

// sounds
	precache_sound ("q2_snd/pkup.wav");
	precache_sound ("q2_snd/w_pkup.wav");
	precache_sound ("q2_snd/am_pkup.wav");
	precache_sound ("q2_snd/respawn1.wav");
	precache_sound ("q2_snd/damage.wav");
	precache_sound ("q2_snd/protect.wav");

// heal
	precache_sound ("q2_snd/s_health.wav");
	precache_sound ("q2_snd/n_health.wav");
	precache_sound ("q2_snd/l_health.wav");
	precache_sound ("q2_snd/m_health.wav");
// arm
	precache_sound ("q2_snd/ar2_pkup.wav");
	precache_sound ("q2_snd/ar1_pkup.wav");
	precache_sound ("q2_snd/ar3_pkup.wav");
// weps
	precache_sound ("q2_snd/bfg_hum.wav");
	precache_sound ("q2_snd/bfg_f1y.wav");
	precache_sound ("q2_snd/bfg_l1a.wav");
	precache_sound ("q2_snd/bfg_x1b.wav");
	precache_sound ("q2_snd/grnf_mx.wav");
	precache_sound ("q2_snd/grenlb1b.wav");
	precache_sound ("q2_snd/hgrena1b.wav");
	precache_sound ("q2_snd/hgrenc1b.wav");
	precache_sound ("q2_snd/hgrenb1a.wav"); // noise
	precache_sound ("q2_snd/hgrent1a.wav"); // toss
	precache_sound ("q2_snd/rktf_mx.wav");
	precache_sound ("q2_snd/rocklx1a.wav");
	precache_sound ("q2_snd/railf_mx.wav");
	precache_sound ("q2_snd/shtf_mx.wav");
	precache_sound ("q2_snd/sshotf1b.wav");
	precache_sound ("q2_snd/machgf1b.wav");
	precache_sound ("q2_snd/machgf2b.wav");
	precache_sound ("q2_snd/machgf3b.wav");
	precache_sound ("q2_snd/machgf4b.wav");
	precache_sound ("q2_snd/machgf5b.wav");
	precache_sound ("q2_snd/blastf1a.wav");
	precache_sound ("q2_snd/chngnl1a.wav");
	precache_sound ("q2_snd/chngnu1a.wav");
	precache_sound ("q2_snd/chngnd1a.wav");
	precache_sound ("q2_snd/hyprbl1a.wav");
	precache_sound ("q2_snd/hyprbu1a.wav");
	precache_sound ("q2_snd/hyprbd1a.wav");
	precache_sound ("q2_snd/hyprbf1a.wav");
	precache_sound ("q2_snd/laser2.wav");
	precache_sound ("q2_snd/lashit.wav");

//	precache_sound ("q2_snd/.wav");
	rail_precache();
};


void() q2_ammo_bullets =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = Q2_DEF_BULLETS_BOX;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_BULLETS;

//	self.classname = "ammo_bullets";
	setmodel (self, "progs/q2_bullets.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of bullets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_rockets =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = Q2_DEF_ROCKETS_LG;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_ROCKETS;

	setmodel (self, "progs/q2_rockets.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of Rockets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void() q2_ammo_shells =
{
	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = Q2_DEF_SHELLS;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_SHELLS;

	setmodel (self, "progs/q2_shells.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of Shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_cells =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = Q2_DEF_CELLPAK;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_CELLS;

	setmodel (self, "progs/q2_cellbox.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_slugs =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SLUGS;
	self.currentammo = Q2_DEF_SLUGS;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_SLUGS;

	setmodel (self, "progs/q2_slugs.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of slugs";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

/* heh heh
void() q2_ammo_grenades =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_GRENADES;
	self.currentammo = Q2_DEF_HGRN;

	setmodel (self, "progs/q2_grenades.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Grenades";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};
*/
void() q2_ammo_grenades =
{
	item_rockets();
	self.netname = "Hand Grenades";
//	self.classname = "q2_ammo_grenades";

// fn
	self.touch = d_weapon_touch;
	self._attack = X_FireHandGrenade;
	self._fr_attack = SUB_Null;
// stats
//	self.aflag = IGN_INV; // ignore inventory bit
	self.currentammo = Q2_DEF_BLAST;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_GRENADES;
	self.volume = Q2_MAX_GRENADES;
	self.attack_finished = 0.5;
	self.dmg = 125;
	self.dodmg = 165; // splash
	self.dmg_save = 1;
	self.dmg_take = 6; // fuse timer
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/q2_grenades.mdl");
//	self.weaponmodel = "progs/v_q2_hgr.mdl";
	self.vwepmdl = "progs/vw_q2_hgr.mdl";
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/hgrent1a.wav";
	self.target = "q2_snd/hgrenb1a.wav";
	self.chaosweptime = 1;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

// anything with another genre classname (weapon_bfg - q3) has q2_ prepended

/*QUAKED q2_weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q2_weapon_bfg =
{
	q100_weapon_lightning();
	self.netname = "BFG 10000";

// fn
	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_bfg1;
// stats
	self.currentammo = 50;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_CELLS;
	self.volume = Q2_MAX_CELLS;
	self.attack_finished = 2;
	self.dmg = 200;
	self.dodmg = 200; // splash & trace
	if (!deathmatch) self.dodmg = 500; // splash & trace
	self.dmg_save = 50;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/q2_bfg.mdl");
	self.weaponmodel = "progs/v_q2_bfg.mdl";
	self.vwepmdl = "progs/vw_q2_bfg.mdl";
	self.target1 = "progs/d_bfg_boom.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise2 = "q2_snd/bfg_hum.wav";
	self.noise3 = "q2_snd/bfg_f1y.wav";
	self.target = "q2_snd/bfg_x1b.wav";
	self.chaosweptime = 0.932;
	self.endtime = 0.87;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_railgun =
{
	q100_weapon_lightning();
	self.netname = "Rail Gun";

	self.touch = d_weapon_touch;
	self._attack = X_FireRailgun;
	self._fr_attack = player_rocket1;

	self.currentammo = Q2_DEF_SLUGS;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_SLUGS;
	self.volume = Q2_MAX_SLUGS;
	self.attack_finished = 1.5;
	self.dmg = 100;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_rail.mdl");
	self.weaponmodel = "progs/v_q2_rail.mdl";
	self.vwepmdl = "progs/vw_q2_rail.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/railf_mx.wav";
	self.noise2 = "q3_snd/rg_hum.wav"; // gun hum - TDO: q2 snd
	self.chaosweptime = 1.16;
	self.endtime = 2.33;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () weapon_hyperblaster =
{
	q100_weapon_lightning();
	self.netname = "Hyper Blaster";

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_hyper0;

	self.currentammo = Q2_DEF_HYBERB;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_CELLS;
	self.volume = Q2_MAX_CELLS;
	self.attack_finished = 0.1;
	self.dmg = 20;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_hyperb.mdl");
	self.weaponmodel = "progs/v_q2_hbl.mdl";
	self.vwepmdl = "progs/vw_q2_hbl.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/hyprbl1a.wav";
	self.target = "q2_snd/lashit.wav";
	self.chaosweptime = 1.62;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = Q2_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.volume = Q2_MAX_ROCKETS;
	self.attack_finished = 1.25;
	self.dmg = 100;
	self.dodmg = 120; // splash
	self.dmg_save = 1;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/q2_rocketl.mdl");
	self.weaponmodel = "progs/v_q2_rl.mdl";
	self.vwepmdl = "progs/vw_q2_rock.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/rktf_mx.wav";
	self.target = "q2_snd/rocklx1a.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_grenadelauncher =
{
	q100_weapon_grenadelauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireGrenade;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = Q2_DEF_BLAST;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_GRENADES;
	self.attack_finished = 0.9;
	self.dmg = 120;
	self.dodmg = 160; // splash
	self.dmg_save = 1;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/q2_gl.mdl");
	self.weaponmodel = "progs/v_q2_gl.mdl";
	self.vwepmdl = "progs/vw_q2_gl.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/grnf_mx.wav";
	self.target = "q2_snd/grenlb1b.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void () weapon_chaingun =
{
	weapon_supernailgun();
	self.netname = "Chain Gun";

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_chain0;

	self.items = IT_SUPER_NAILGUN;
	self.currentammo = 50;
	self.lip = AMMO_BULLETS;
	self.volume = Q2_MAX_BULLETS;
	self.attack_finished = 0.05; // 20 per then 40 per 1 sec later
	self.dmg = 6;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.03 0.03 0';
	self.wait = RSP_TIME;
 
	setmodel (self, "progs/q2_chain.mdl");
	self.weaponmodel = "progs/v_q2_chg.mdl";
	self.vwepmdl = "progs/vw_q2_chg.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_bullet_5";
//	self.noise2 = "q2_snd/chngnl1a.wav";
//	self.target = "q2_snd/lashit.wav"; // TDO: ricochets - q3 only?
	self.chaosweptime = 2.01;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

// doing the same way even tho q2 doesnt offer a dbl yet
void() q2_mg_base =
{
// stats
	self.items = IT_NAILGUN;
	self.currentammo = 50;
	self.lip = AMMO_BULLETS;
	self.volume = Q2_MAX_BULLETS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 8;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.025 0.025 0';
	self.wait = RSP_TIME;

	self.netname = "Machine Gun";

	setmodel (self, "progs/q2_mgun.mdl");
	self.weaponmodel = "progs/v_q2_mg.mdl";
	self.vwepmdl = "progs/vw_q2_mg.mdl";
};

void() q2_weapon_machinegun =
{
	weapon_nailgun();

	q2_mg_base();
	self.touch = d_weapon_touch;//wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_bullet_5";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_supershotgun =
{
	q100_weapon_supershotgun();
	self.netname = "Super Shotgun";

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q2_DEF_SHOTG	;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = Q2_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = 6;
	self.dmg_save = 2;
	self.dmg_take = 20; // shot cnt
	self.punchangle = ' 0.14 0.08 0'; // bullet spread out -- TDO: get q2 value, this is q1
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_dblshot.mdl");
	self.weaponmodel = "progs/v_q2_shot2.mdl";
	self.vwepmdl = "progs/vw_q2_dblshot.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/sshotf1b.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_shotgun =
{
	q100_weapon_shotgun();
	self.netname = "Shotgun";

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q2_DEF_SHOTG	;
	self.items = IT_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = Q2_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = 4;
	self.dmg_save = 1;
	self.dmg_take = 12; // shot cnt
	self.punchangle = ' 0.04 0.04 0'; // bullet spread out -- TDO: get q2 value, this is q1
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_shotgun.mdl");
	self.weaponmodel = "progs/v_q2_shot.mdl";
	self.vwepmdl = "progs/vw_q2_shot.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/shtf_mx.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_blaster =
{
	q100_weapon_shotgun();
	self.netname = "Blaster";

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_pistol1; // FIX - special

	self.currentammo = 0;
	self.items = IT_NAILGUN; // IT_AXE; // testing
	self.lip = AMMO_NONE;
	self.attack_finished = 0.5;
	self.dmg = 15;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_blaster.mdl");
	self.weaponmodel = "progs/v_q2_blst.mdl";
	self.vwepmdl = "progs/vw_q2_blst.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/blastf1a.wav";
	self.target = "q2_snd/lashit.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void() q2_item_health_small =
{
	q100_item_health();
	setmodel(self, "progs/q2_heal_stimpak.mdl");
	self.noise = "q2_snd/s_health.wav";
	self.noise4 = "q2_snd/respawn1.wav"; // doom respawn sound
	self.netname = "Stimpack";
	self.healamount = Q2_DEF_HBOTTLE;
	self.healtype = HEAL_BOT;
	self.volume = -1; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_health =
{
	q100_item_health();
	setmodel(self, "progs/q2_heal_medium.mdl");
	self.noise = "q2_snd/n_health.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "First Aid";
	self.healamount = Q2_DEF_HFIRSTAID;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_health_large =
{
	q100_item_health();
	setmodel(self, "progs/q2_heal_large.mdl");
	self.noise = "q2_snd/l_health.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Medkit";
	self.healamount = Q2_DEF_HMEDKIT;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_health_mega =
{
	self.spawnflags = self.spawnflags | 2;
	q100_item_health();
	setmodel(self, "progs/q2_heal_mega.mdl");
	self.noise = "q2_snd/m_health.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Mega health";
	self.healamount = Q2_DEF_HMEGATUBE;
	self.healtype = HEAL_MEGA;
	self.volume = -1; // max add
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_misc_explobox =
{
	self.netname = "Barrel";
	misc_explodbox_set(self, "progs/q2_barrel.mdl", Q2_BARREL_BLAST, 80, MOVETYPE_NONE);
//	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.wait = RSP_TIME;
//	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_armor_body =
{
	item_armorInv();
	setmodel (self, "progs/q2_armorbody.mdl");
	self.noise = "q2_snd/ar3_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Body armor";
	self.volume = 200; // max add
	self.style = Q2_ARM_TBDY;
	self.items = IT_ARMOR3;
	self.currentammo = Q2_ARM_BODY; // 100 units
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_armor_combat =
{
	item_armor2();
	setmodel (self, "progs/q2_armorcombat.mdl");
	self.noise = "q2_snd/ar1_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Combat armor";
	self.volume = 100; // max add
	self.style = Q2_ARM_TCMB;
	self.items = IT_ARMOR2;
	self.currentammo = Q2_ARM_CMBT; // 50 units
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_armor_jacket =
{
	item_armor1();
	setmodel (self, "progs/q2_armorjacket.mdl");
	self.noise = "q2_snd/ar1_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Jacket armor";
	self.volume = 50; // max add
	self.style = Q2_ARM_TFLK;
	self.items = IT_ARMOR1;
	self.currentammo = Q2_ARM_FLAK; // 25 units
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_armor_shard =
{
	item_armor1();
	setmodel (self, "progs/q2_armorshard.mdl");
	self.noise = "q2_snd/ar2_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Armor shard";
	self.volume = -1; // max add
	self.style = Q2_ARM_TFLK;
	self.items = IT_ARMOR1;
	self.currentammo = Q2_ARM_SHRD; // 2 units
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_power_shield =
{
	item_armor1();
	setmodel (self, "progs/q2_armorpower.mdl");
	self.noise = "q2_snd/ar1_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Energy armor";
	self.volume = -1;
	self.style = 0;
	self.currentammo = 0;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_power_screen =
{
	item_armor1();
	setmodel (self, "progs/q2_armorscreen.mdl");
	self.noise = "q2_snd/ar1_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power screen";
	self.volume = -1;
	self.style = 0;
	self.currentammo = 0;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_silencer =
{
	q100_weapon_shotgun();
	self.netname = "Silencer";

	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_silencer.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void() item_invulnerability =
{
	item_artifact_invulnerability();
	self.netname = "Invulnerability";

	self.touch = x_pwr_touch;
	self.items = IT_INVULNERABILITY;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_inv.mdl");
	self.noise = "q2_snd/protect.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_enviro =
{
	item_artifact_envirosuit();
	self.netname = "Environmental Suit";

	self.touch = x_pwr_touch;
	self.items = IT_SUIT;
	self.delay = POW_TIME;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_envirosuit.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_quad =
{
	item_artifact_super_damage();
	self.netname = "Quad Damage";

	self.touch = x_pwr_touch;
	self.items = IT_QUAD;
	self.delay = POW_TIME;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_quad.mdl");
	self.noise = "q2_snd/damage.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_adrenaline =
{
	q100_item_health();
	self.netname = "Adrenaline";

	self.healamount = Q2_DEF_HMEGATUBE;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	self.wait = Q2_POWER_WAIT;

	setmodel(self, "progs/q2_adrenaline.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_bandolier =
{
	item_spikes();
	self.netname = "Bandolier";

	self.touch = x_pack_touch;
	self.pk_items =
	self.items = 0; // must be for bp touch call
	self.rune_flag = RUNE_AMMO;
	self.ammo_bullet = 50;
	self.ammo_shells = 10;
	self.wait = RSP_TIME;

	setmodel(self, "progs/q2_bando.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_pack =
{
	item_spikes();
	self.netname = "Ammo Pack";

	self.touch = x_pack_touch;
	self.pk_items =
	self.items = 0; // must be for bp touch call
	self.rune_flag = RUNE_AMMO;
	self.ammo_bullet = 50;
	self.ammo_shells = 10;
	self.ammo_rockets = 10; // 5; // includes 5 grenades
	self.ammo_cells = 50;
	self.ammo_slug = 10;
	self.wait = RSP_TIME;

	setmodel(self, "progs/q2_pack.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_breather =
{
	item_spikes();
	self.netname = "Re-breather";

	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel(self, "progs/q2_breather.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_pyramid =
{
	item_key1();
	setmodel(self, "progs/q2_keypyramid.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Pyramid Key";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_power_cube =
{
	item_key1();
	setmodel(self, "progs/q2_keypower.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power Cube";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_pass =
{
	item_key1();
	setmodel(self, "progs/q2_keypass.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Pass Key";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_data_cd =
{
	item_key1();
	setmodel(self, "progs/q2_keycd.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Data CD";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_data_spinner =
{
	item_key1();
	setmodel(self, "progs/q2_keyspinner.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Data Spinner";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_airstrike_target =
{
	item_key1();
	setmodel(self, "progs/q2_keytarget.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Airstrike Target";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_blue_key =
{
	item_key1();
	setmodel(self, "progs/q2_keyrb.mdl");
	self.skin = 1;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Blue Key";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_red_key =
{
	item_key1();
	setmodel(self, "progs/q2_keyrb.mdl");
	self.skin = 0;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Red Key";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_commander_head =
{
	item_key1();
	setmodel(self, "progs/q2_key_cmd_head.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Commanders Head";
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() hand_grenade_thk =
{
	if (!self.endtime) self.endtime = self.flags + time;
	else if (self.endtime < time) // BOOM!
	{
		setorigin(self, self.owner.origin);
		if (self.owner.flags & FL_CLIENT)
		{
			self.owner.currentammo = self.owner.ammo_rockets = self.owner.ammo_rockets - ammo_con(1, self.owner, ""); // use ammo
			self.owner.eweapon.noise2 = "";
		}
		else
			remove(self.owner); // NOTE: danger - bots that dont have FL_CLIENT!
		if (!self.dodmg) self.dodmg = 120;
		GrenadeExplode(); // its gonna hurt...a lot if we forgot to throw it
	}
	if (self.owner.flags & FL_CLIENT)
	{
		if (!self.owner.eweapon)
		{
			sprint(self.owner, "\n\nHand grenade disarmed.\n");
			centerprint(self.owner, "");
			remove(self);
			return;
		}
		if (self.owner.eweapon.mdl != self.target)
		{
			sprint(self.owner, "\n\nHand grenade disarmed.\n");
			centerprint(self.owner, "");
			remove(self);
			return;
		}
	}
	else
	{
		setorigin(self, self.owner.origin); // for sound
		sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM);
	}

	self.nextthink = time + self.chaosweptime;
};

void() X_FireHandGrenade =
{
	local string snd;
	local float f;

	if (!EWEAP) return; // oops

	if (EWEAP.noise2 == "") // activate
	{
		ominous_hum("q2_snd/hgrena1b.wav", 0.678); // activate
		EWEAP.noise2 = "q2_snd/hgrenc1b.wav";
		f = EWEAP.dmg_take;
		if (f < 1) f = 6;
		if (!EWEAP.chaosweptime) EWEAP.chaosweptime = 1;
		self.enemy = chaos_spawn(0, 0, f, 0, v0, v0, v0, v0, v0, "", "", SUB_Null, EWEAP.chaosweptime, hand_grenade_thk, SUB_Null, self, world);
		self.enemy.dodmg = EWEAP.dodmg;
		self.enemy.target = EWEAP.mdl;
		self.enemy.noise = EWEAP.noise2;
		self.enemy.chaosweptime = EWEAP.chaosweptime;
		centerprint(self, "HAND GRENADE ARMED!");
//		self.attack_finished = time + f;
	}
	else
	{
// TDO: frames!, throw control?
		snd = EWEAP.noise3;
		if (snd == "") snd = "q2_snd/hgrent1a.wav";
		EWEAP.noise2 = "";
// more throw power the longer held
		f = 6 / (self.enemy.endtime - time) * HGREN_VEL;
		if (f > 600) f = 600;
		fire_missile(f, MOVETYPE_BOUNCE, FL_GRN | FL_PUNCH | FL_USEAMMO | FL_RUNEHST, RM_SKY | PF_LAVA, self.origin, ' 0 0 0', "grenade", "progs/vw_q2_hgr.mdl", snd, GrenadeTouch, 10 + 60 * random(),  GrenadeExplode, GrenadeExplode);
		self.enemy.owner = newmis;
		newmis.frame = 107; //169 + floor(random() * 5.3);
		newmis.dodmg = EWEAP.dodmg;
		newmis.noise = EWEAP.target; //"q2_snd/hgrenb1a.wav"; // bounce
		newmis.modelflags = MF_GRENADE;
		newmis.avelocity = '150 150 150';
		setsize(newmis, '-4 -4 -4', '4 4 4');
	}
};

void() q2_blaster_thk =
{
//	if (random() < 0.5) 
		particle (self.origin, self.velocity, 234, 6);
	self.nextthink = time + 0.05;
};

void() X_FireBlaster =
{
	fire_laser1(FL_PUNCH);
	setmodel(newmis, "progs/null.mdl");
	newmis.nextthink = time + 0.1;
	newmis.think = q2_blaster_thk;
	newmis.effects = EF_DIMLIGHT;
};
