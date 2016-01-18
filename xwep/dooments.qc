/*
		+---------------------------------------+
		|  Doom specific code                   | SEC-HEAD
		+---------------------------------------+
*/
// map item indiv reposition codes

float ARM_SPIRIT				= 1; // doom spirit armor

// doom values
float D_DEF_HBOTTLE			= 1;
float D_DEF_HSTIMPAK			= 10;
float D_DEF_HMEDKIT			= 25;
float D_DEF_SOULSPH			= 100;
float D_SOUL_MAX				= 200; // soul, mega max health

float D_ARM_TGRN				= 0.333;
float D_ARM_GRN				= 100;
float D_ARM_TBLU				= 0.5;
float D_ARM_BLUE				= 200;

float D_DEF_SHELLS			= 4;		// small box
float D_DEF_SHELLBOX			= 20;		// large box
float D_DEF_SHOTG				= 8;		// weapon def
float D_DEF_BULLETS_CLIP	= 10;
float D_DEF_BULLETS_BOX		= 50;
float D_DEF_CHAING			= 20;
float D_DEF_CELLBOX			= 100;
float D_DEF_CELLPAK			= 20;
float D_DEF_PLASMAG			= 40;
float D_DEF_BFG				= 40;
float D_DEF_ROCKETS_LG		= 5;
float D_DEF_ROCKETS_SM		= 1;
float D_DEF_BLAST				= 2;

float D_MAX_BULLETS			= 200;	// max val without pack / rune
float D_MAX_SHELLS			= 50;
float D_MAX_ROCKETS			= 50;
float D_MAX_CELLS				= 300;

float D_BARREL_BLAST			= 128;

// should be RSP_TIME

float DOOM_ML_DMG				= -1666665; // tell code to calculate doom melee damage - d2 * 10 per hit
float DOOM_SHOT_DMG			= -1666666; // tell code to calculate doom bullet damage - d3 * 5 per shot
float DOOM_ROCK_DMG			= -1666667; // tell code to calculate doom rocket damage - 
float DOOM_BFG_DMG			= -1666669; // tell code to calculate doom bfg damage -  d8 * 100 + traces + ??

float W_DEF_BULLETS_CLIP	= 8;

float W_MAX_BULLETS			= 199;	// max val without pack / rune
float W_MAX_ROCKETS			= 99;
float W_MAX_GAS				= 99;

float SAWLEN					= 80; // lenght saw can attack

void() doom_precache =
{
// items
	precache_model ("progs/barrel.mdl");
	precache_model ("progs/barrel2.mdl");
	precache_model ("progs/d_bottle.mdl");
	precache_model ("progs/heal_medkit.mdl");
	precache_model ("progs/d_stimpack04.mdl");
	precache_model ("progs/spiritarmor.mdl");
	precache_model ("progs/d_spheres.mdl");
	precache_model ("progs/d_berzerk.mdl");
	precache_model ("progs/d_radsuit.mdl");
	precache_model ("progs/d_skullkey.mdl");
	precache_model ("progs/d_cardkey.mdl");
	precache_model ("progs/d_armor.mdl");
	precache_model ("progs/d_map.mdl");
	precache_model ("progs/d_vis.mdl");
// ammo
	precache_model ("progs/d_4shell.mdl");
	precache_model ("progs/d_ammobox.mdl");
	precache_model ("progs/d_clip.mdl");
	precache_model ("progs/d_rockbox.mdl");
	precache_model ("progs/d_1rocket.mdl");
	precache_model ("progs/d_shellbox.mdl");
	precache_model ("progs/d_cellbox.mdl");
	precache_model ("progs/d_cellpack.mdl");
	precache_model ("progs/d_pack.mdl");
// doom weps
	precache_model ("progs/d_saw.mdl");
	precache_model ("progs/d_pistol.mdl");
	precache_model ("progs/d_bfg.mdl");
	precache_model ("progs/d_rock.mdl");
	precache_model ("progs/d_plasma.mdl");
	precache_model ("progs/d_chaingun.mdl");
	precache_model ("progs/d_shotgun.mdl");
	precache_model ("progs/d_dblshot.mdl");
// shots
	precache_model ("progs/d_plasma_sht.mdl");
	precache_model ("progs/bfgbit.spr");

// view models
	precache_model ("progs/v_d_pistol.mdl");
	precache_model ("progs/v_d_bfg.mdl");
	precache_model ("progs/v_d_shot.mdl");
	precache_model ("progs/v_d_dblshot.mdl");
	precache_model ("progs/v_d_chg.mdl");
	precache_model ("progs/v_d_plasma.mdl");
	precache_model ("progs/v_d_rock.mdl");
	precache_model ("progs/v_d_saw.mdl");
// viswep
	precache_model ("progs/vw_d_saw.mdl");
	precache_model ("progs/vw_d_pistol.mdl");
	precache_model ("progs/vw_d_shot.mdl");
	precache_model ("progs/vw_d_dblshot.mdl");
	precache_model ("progs/vw_d_chaing.mdl");
	precache_model ("progs/vw_d_rock.mdl");
	precache_model ("progs/vw_d_plasma.mdl");
	precache_model ("progs/vw_d_bfg.mdl");
// wolfenstien
	precache_model ("progs/w_armor.mdl");
	precache_model ("progs/w_knife.mdl");
	precache_model ("progs/w_pistol.mdl");
	precache_model ("progs/w_mgun.mdl");
	precache_model ("progs/w_chaing.mdl");
	precache_model ("progs/w_mortar.mdl");
	precache_model ("progs/w_flamer.mdl");
	precache_model ("progs/w_clip.mdl");
	precache_model ("progs/w_key.mdl");

	precache_model ("progs/vw_w_knife.mdl");
	precache_model ("progs/vw_w_pistol.mdl");
	precache_model ("progs/vw_w_mgun.mdl");
	precache_model ("progs/vw_w_chaing.mdl");
	precache_model ("progs/vw_w_2chaing.mdl");
	precache_model ("progs/vw_w_mortar.mdl");
	precache_model ("progs/vw_w_flamer.mdl");

	precache_model ("progs/v_w_knife.mdl");
	precache_model ("progs/v_w_pistol.mdl");
	precache_model ("progs/v_w_mgun.mdl");
	precache_model ("progs/v_w_chg.mdl");
	precache_model ("progs/v_w_2chg.mdl");
	precache_model ("progs/v_w_mortar.mdl");
	precache_model ("progs/v_w_flamer.mdl");

// sounds
	precache_sound ("doom/dsbarexp.wav");
	precache_sound ("doom/dsitemup.wav");
	precache_sound ("doom/dsitembk.wav");
	precache_sound ("doom/dswpnup.wav");
	precache_sound ("doom/dsgetpow.wav");
	precache_sound ("doom/dsdorcls.wav");
	precache_sound ("doom/dsdoropn.wav");
	precache_sound ("doom/dsbdcls.wav");
	precache_sound ("doom/dsbdopn.wav");
	precache_sound ("doom/dspstart.wav");
	precache_sound ("doom/dspstop.wav");
	precache_sound ("doom/gibs.wav");
// weps
	precache_sound ("doom/dsrlaunc.wav");
	precache_sound ("doom/dsbfg.wav");
	precache_sound ("doom/dspistol.wav");
	precache_sound ("doom/dsshotgn.wav");
	precache_sound ("doom/dsdshtgn.wav");
	precache_sound ("doom/dsplasma.wav");
	precache_sound ("doom/dssawup.wav");
	precache_sound ("doom/dssawidl.wav");
	precache_sound ("doom/dssawhit.wav");
	precache_sound ("doom/dssawful.wav");
	precache_sound ("doom/dsfirxpl.wav");
//	precache_sound ("doom/d_f_chg.wav");
// wolf
	precache_sound ("wolf/w_knife.wav");
	precache_sound ("wolf/w_pistol.wav");
	precache_sound ("wolf/w_mg.wav");
	precache_sound ("wolf/w_chg.wav");
	precache_sound ("wolf/w_mortar.wav");
	precache_sound ("wolf/pickup_am.wav");
	precache_sound ("wolf/pickup_gn.wav");
	precache_sound ("wolf/pickup_gdy.wav");
	precache_sound ("wolf/w_resp.wav");
	precache_sound ("wolf/door_opn.wav");
	precache_sound ("wolf/door_cls.wav");


};

/*
		+---------------------------------------+
		|  Map code - Doom                     | SEC-HEAD
		+---------------------------------------+
*/

/*
NOTE: this code assumes the translation of doom map entites to quake style definitions in the map file by some device or code...

 uses ypod models for now - may recraft many of these...at least the easy ones

*/


void() d_item_healthbottle =
{
	q100_item_health();
	self.netname = "Health potion";


	self.healamount = D_DEF_HBOTTLE;
	self.healtype = HEAL_BOT;
	self.volume = 200; // max add
	self.wait = RSP_TIME;

//	setmodel(self, "progs/d_bottle.mdl");
//	self.frame = 0;
//	self.skin = 0;
	doom_alpha_tran(self, MC_D_HBOTTLE);

//	self.alpha = 0.8;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav"; // doom respawn sound
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_healthmedkit =
{
	q100_item_health();
	setmodel(self, "progs/heal_medkit.mdl");
	self.frame = 0;
	self.skin = 0;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Medkit";
	self.healamount = D_DEF_HMEDKIT;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_healthstimpak =
{
	q100_item_health();
	setmodel(self, "progs/heal_medkit.mdl");
	self.frame = 3;
	self.skin = 3;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Stimpak";
	self.healamount = D_DEF_HSTIMPAK;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_spiritarmor =
{
	item_armor2();
	setmodel (self, "progs/spiritarmor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Spirit armor";
	self.volume = 200; // max add
//	self.skin = 0;
	self.style = D_ARM_TBLU;
	self.currentammo = ARM_SPIRIT;
	self.items = IT_ARMOR2;

	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

// TWEAK - different damage handling than q1 armors
void() d_item_armorgreen =
{
	item_armor1();
	setmodel (self, "progs/d_armor.mdl");
	self.skin = 0;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Security armor";
	self.style = D_ARM_TGRN;
	self.currentammo = D_ARM_GRN; // 100 units
	self.volume = 100; // max add
	self.items = IT_ARMOR1;

	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_armorblue =
{
	item_armor2();
	setmodel (self, "progs/d_armor.mdl");
	self.skin = 1;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Combat armor";
	self.style = D_ARM_TBLU;
	self.currentammo = D_ARM_BLUE; // 200 units
	self.volume = 200; // max add
	self.items = IT_ARMOR2;

	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_ammobox =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = D_DEF_BULLETS_BOX;
	self.wait = RSP_TIME;
	self.volume = D_MAX_BULLETS;

//	setmodel (self, "progs/d_ammobox.mdl");
	doom_alpha_tran(self, MC_D_ABULLETS_LG);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of bullets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_clip =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = D_DEF_BULLETS_CLIP;
	self.wait = RSP_TIME;
	self.volume = D_MAX_BULLETS;

//	setmodel (self, "progs/d_clip.mdl");
	doom_alpha_tran(self, MC_D_ABULLETS);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Clip";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_1rocket =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = D_DEF_ROCKETS_SM;
	self.wait = RSP_TIME;
	self.volume = D_MAX_ROCKETS;

//	setmodel (self, "progs/d_1rocket.mdl");
	doom_alpha_tran(self, MC_D_AROCKET);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Rocket";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_rockbox =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = D_DEF_ROCKETS_LG;
	self.wait = RSP_TIME;
	self.volume = D_MAX_ROCKETS;

//	setmodel (self, "progs/d_rockbox.mdl");
	doom_alpha_tran(self, MC_D_AROCKETS_LG);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Rockets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_4shell =
{
	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = D_DEF_SHELLS;
	self.wait = RSP_TIME;
	self.volume = D_MAX_SHELLS;

//	setmodel (self, "progs/d_4shell.mdl");
	doom_alpha_tran(self, MC_D_ASHELLS);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "4 shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_shellbox =
{
	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = D_DEF_SHELLBOX;
	self.wait = RSP_TIME;
	self.volume = D_MAX_SHELLS;

//	setmodel (self, "progs/d_shellbox.mdl");
	doom_alpha_tran(self, MC_D_ASHELLS_LG);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_cellbox =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = D_DEF_CELLBOX;
	self.wait = RSP_TIME;
	self.volume = D_MAX_CELLS;

	setmodel (self, "progs/d_cellbox.mdl");

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_cellpack =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = D_DEF_CELLPAK;
	self.wait = RSP_TIME;
	self.volume = D_MAX_CELLS;

//	setmodel (self, "progs/d_cellpack.mdl");
	doom_alpha_tran(self, MC_D_ACELLS);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_barrel =
{
	self.netname = "Barrel";
	if (self.class_select == "") self.class_select = "doom_item";
	misc_explodbox_set(self, "progs/barrel.mdl", D_BARREL_BLAST + random() * 8, 20, MOVETYPE_NONE);
	self.health = 20 + random() * 16; // heh heh
	self.wait = RSP_TIME;
	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "doom/dsitembk.wav";
//	self.effects = self.effects | EF_FULLBRIGHT;
};

/*
doom wep inventory slots

slot		weapon
1				pistol *
2				shotgun *
3				boom stick
4				chainsaw
5				chain gun
6				plasma gun
7				rocket launcher
8				bfg

* = touch fn will replace other slot 1 & 2 weps with these

*/
void() d_weapon_bfg =
{
	q100_weapon_lightning();
	self.netname = "BFG 9000";

// fn
	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_bfg1;
// stats
	self.currentammo = D_DEF_BFG;
	self.items = IT_EXTRA_WEAPON;
	self.lip = AMMO_CELLS;
	self.volume = D_MAX_CELLS;
	self.aflag = IGN_INV; // swap with others
	self.attack_finished = 2;
	self.dmg = DOOM_BFG_DMG;
//	self.dodmg = 128; // splash
	self.dmg_save = 40;
	self.punchangle = ' 0.6 0.3 0'; // for traces ?
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/d_bfg.mdl");
	self.weaponmodel = "progs/v_d_bfg.mdl";
	self.vwepmdl = "progs/vw_d_bfg.mdl";
	self.target1 = "progs/d_bfg_boom.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.noise3 = "doom/dsbfg.wav";
	self.target = "doom/dsfirxpl.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	self.endtime = 0.768;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();
	self.netname = "Rocket Launcher";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = D_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.volume = D_MAX_ROCKETS;
	self.attack_finished = 0.6;
	self.dmg = DOOM_ROCK_DMG;
	self.dodmg = 128; // splash
	self.dmg_save = 1;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/d_rock.mdl");
	self.weaponmodel = "progs/v_d_rock.mdl";
	self.vwepmdl = "progs/vw_d_rock.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsrlaunc.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.target = "doom/dsfirxpl.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_chaingun =
{
	d_rep_set();
	weapon_supernailgun();
	self.netname = "Chain Gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

// stats
	self.items = IT_SUPER_NAILGUN;
	self.currentammo = D_DEF_CHAING;
	self.lip = AMMO_BULLETS;
	self.volume = D_MAX_BULLETS;
	self.attack_finished = 0.11;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.065 0.065 0';
	self.wait = RSP_TIME;

	setmodel (self, "progs/d_chaingun.mdl");
	self.weaponmodel = "progs/v_d_chg.mdl";
	self.vwepmdl = "progs/vw_d_chaing.mdl";
	self.noise3 = "doom/d_f_chg.wav";
	self.noise3 = "doom/dspistol.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_pistol =
{
//	d_rep_set();
	weapon_nailgun();
	self.netname = "Pistol";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_pistol1;

// stats
	self.currentammo = 25;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = AMMO_BULLETS;
	self.volume = D_MAX_BULLETS;
	self.attack_finished = 0.4;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.01 0.01 0';
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/d_pistol.mdl");
	self.weaponmodel = "progs/v_d_pistol.mdl";
	self.vwepmdl = "progs/vw_d_pistol.mdl";
	self.noise3 = "doom/dspistol.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_saw =
{
//	d_rep_set();
	weapon_nailgun();
	self.netname = "Chainsaw";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_saw1;

// stats
	self.currentammo = 0;
	self.items = IT_NAILGUN;
	self.lip = AMMO_NONE;
	self.attack_finished = 0.12;
	self.dmg = DOOM_ML_DMG;
	self.dmg_save = SAWLEN;
	self.dmg_take = 1;
//	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/d_saw.mdl");
	self.weaponmodel = "progs/v_d_saw.mdl";
	self.vwepmdl = "progs/vw_d_saw.mdl";
	self.noise3 = "doom/dssawful.wav";
	self.noise2 = "doom/dssawidl.wav";
	self.target = "doom/dssawhit.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.chaosweptime = 0.68;
	self.endtime = 0.715;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};


void() d_weapon_shotgun =
{
	d_rep_set();
	q100_weapon_shotgun();
	self.netname = "Shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = D_DEF_SHOTG;
	self.items = IT_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = D_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_take = 7; // shot cnt
	self.dmg_save = 1;
	self.punchangle = ' 0.04 0.04 0'; // bullet spread out -- TDO: get doom value, this is q1
	self.wait = RSP_TIME;

	setmodel (self, "progs/d_shotgun.mdl");
	self.weaponmodel = "progs/v_d_shot.mdl";
	self.vwepmdl = "progs/vw_d_shot.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsshotgn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_supershotgun =
{
	q100_weapon_supershotgun();
	self.netname = "Super shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = D_DEF_SHOTG;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = D_MAX_SHELLS;
	self.attack_finished = 1.6667;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 2;
	self.dmg_take = 21; // shot cnt
	self.punchangle = ' 0.14 0.08 0'; // bullet spread out -- TDO: get doom value, this is q1
	self.wait = RSP_TIME;

	setmodel (self, "progs/d_dblshot.mdl");
	self.weaponmodel = "progs/v_d_dblshot.mdl";
	self.vwepmdl = "progs/vw_d_dblshot.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsdshtgn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};


void() d_weapon_plasma =
{
	q100_weapon_lightning();
	self.netname = "Plasma Gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_plasma1;

	self.currentammo = D_DEF_PLASMAG;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_CELLS;
	self.volume = D_MAX_CELLS;
	self.attack_finished = 0.083;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	self.wait = RSP_TIME;

	setmodel (self, "progs/d_plasma.mdl");
	self.weaponmodel = "progs/v_d_plasma.mdl";
	self.vwepmdl = "progs/vw_d_plasma.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsplasma.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.target = "doom/dsfirxpl.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_pack =
{
	item_shells();
	self.netname = "Ammo Pack";

	self.touch = x_pack_touch;
	self.pk_items =
	self.items = 0; // must be for bp touch call
	self.rune_flag = RUNE_AMMO;
	self.ammo_bullet = 10;
	self.ammo_shells = 4;
	self.ammo_rockets = 1;
	self.ammo_cells = 20;
	self.wait = RSP_TIME;

	setmodel(self, "progs/d_pack.mdl");
	self.skin = 0;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_automap =
{
	q100_weapon_shotgun();
	self.netname = "Auto Map";

	self.touch = x_item_touch;
	self.x_items = X_D_MAP;

	setmodel(self, "progs/d_map.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_nightvis =
{
	q100_weapon_shotgun();
	self.netname = "Night Vision Goggles";

	self.touch = x_item_touch;
	self.x_items = X_D_VIS;

//	setmodel(self, "progs/d_vis.mdl");
	doom_alpha_tran(self, MC_D_NIGHTVS);

	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_berserker =
{
	q100_item_health();
	self.netname = "Berserker";

	self.touch = x_pwr_touch;
	self.items = IT_QUAD;
	self.healamount = 100;
	self.healtype = HEAL_NORM;
	self.wait = D_POWER_WAIT;
	self.dmgtime = D_POWER_TIME;

//	setmodel(self, "progs/d_berzerk.mdl");
	doom_alpha_tran(self, MC_D_BERS);
	self.noise = "doom/dsitemup.wav"; // CHECK: this
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_soulsphere =
{
	q100_item_health();
	self.netname = "Soul Sphere";

	self.healamount = D_DEF_SOULSPH;
	self.healtype = HEAL_SOUL;
	self.volume = 200; // max add
	self.wait = D_POWER_WAIT;

//	setmodel(self, "progs/d_spheres.mdl");
//	self.frame = 0;
//	self.skin = 0;
	doom_alpha_tran(self, MC_D_SOULSPH);
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_megasphere =
{
// armor
	d_item_armorblue();
	self.netname = "Mega Sphere";

	self.touch = x_pwr_touch;
// heal
	self.healamount = 200;
	self.healtype = HEAL_SOUL;
	self.volume = 200; // max add - done by armor as well, ok they are same max
	self.wait = D_POWER_WAIT;

//	setmodel(self, "progs/d_spheres.mdl");
//	self.frame = 0;
//	self.skin = 1;
	doom_alpha_tran(self, MC_D_MEGASPH);
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_invulnerable =
{
	item_artifact_invulnerability();
	self.netname = "Invulnerability";

	self.touch = x_pwr_touch;
	self.items = IT_INVULNERABILITY;
	self.wait = D_POWER_WAIT;
	self.dmgtime = D_POWER_TIME;

//	setmodel (self, "progs/d_spheres.mdl");
//	self.frame = 0;
//	self.skin = 2;
	doom_alpha_tran(self, MC_D_INVUL);

	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_invisible =
{
	item_artifact_invisibility();
	self.netname = "Invisibilty";

	self.touch = x_pwr_touch;
	self.items = IT_INVISIBILITY;
	self.wait = D_POWER_WAIT;
	self.dmgtime = D_POWER_TIME;

//	setmodel (self, "progs/d_spheres.mdl");
//	self.frame = 0;
//	self.skin = 3;
	doom_alpha_tran(self, MC_D_INVIS);
	
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_radsuit =
{
	item_artifact_envirosuit();
	self.netname = "Radiation Suit";

	self.touch = x_pwr_touch;
	self.items = IT_SUIT;
	self.wait = D_POWER_WAIT;
	self.dmgtime = D_POWER_TIME;

	setmodel (self, "progs/d_radsuit.mdl");
	self.noise = "doom/dsitemup.wav"; // radsuit finish sounds, proper op
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

// use spawnflags to make one of 6 keys...
void() d_key_redskull =
{
	item_key2();
	self.netname = "Red Skull key";

	self.touch = x_item_touch;
	self.x_items = X_D_KEY_SKRED;
	self.wait = RSP_TIME;

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 0;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_blueskull =
{
	item_key1();
	self.netname = "Blue Skull key";

	self.touch = x_item_touch;
	self.x_items = X_D_KEY_SKBLUE;
	self.wait = RSP_TIME;

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 1;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_yellowskull =
{
	item_key2();
	self.netname = "Yellow Skull key";

	self.touch = x_item_touch;
	self.x_items = X_D_KEY_SKYEL;
	self.wait = RSP_TIME;

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 2;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_redcard =
{
	item_key2();
	self.netname = "Red card key";

	self.touch = x_item_touch;
	self.x_items = X_D_KEY_CRED;
	self.wait = RSP_TIME;

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 0;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_bluecard =
{
	item_key1();
	self.netname = "Blue card key";

	self.touch = x_item_touch;
	self.x_items = X_D_KEY_CBLUE;
	self.wait = RSP_TIME;

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 1;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_yellowcard =
{
	item_key2();
	self.netname = "Yellow card key";

	self.touch = x_item_touch;
	self.x_items = X_D_KEY_CYEL;
	self.wait = RSP_TIME;

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 2;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

/*
		+---------------------------------------+
		|  Map code - Wolfenstien               | SEC-HEAD
		+---------------------------------------+
*/

/*
NOTE: this code assumes the translation of wolf map entites to quake style definitions in the map file by some device or code...

wolf wep inventory slots

slot		weapon
1				knife *
2				pistol *
3				--------
4				machine gun
5				chain gun
6				flame thrower
7				mortar
8				dual chain gun

* = touch fn will replace other slot 1 & 2 weps with these

*/

void() w_weapon_machinegun =
{
	weapon_nailgun();

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

// stats
	self.currentammo = 6;
	self.items = IT_NAILGUN;
	self.lip = AMMO_BULLETS;
	self.volume = W_MAX_BULLETS;
	self.attack_finished = 0.16667; // 6 per
	self.dmg = 10;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.02 0.02 0';
	self.wait = RSP_TIME;

	self.netname = "Machine Gun";

	setmodel (self, "progs/w_mgun.mdl");
	self.weaponmodel = "progs/v_w_mgun.mdl";
	self.vwepmdl = "progs/vw_w_mgun.mdl";
	self.noise3 = "wolf/w_mg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_chg_base =
{
// stats
	self.items = IT_SUPER_NAILGUN;
	self.currentammo = 6;
	self.lip = AMMO_BULLETS;
	self.volume = W_MAX_BULLETS;
	self.attack_finished = 0.087; // 11.5 per
	self.dmg = 10;
	self.dmg_save = 1;
	self.dmg_take = 2;
	self.punchangle = ' 0.05 0.05 0';
	self.wait = RSP_TIME;

	self.netname = "Chain Gun";

	setmodel (self, "progs/w_chaing.mdl");
	self.weaponmodel = "progs/v_w_chg.mdl";
	self.vwepmdl = "progs/vw_w_chaing.mdl";
};

void() w_weapon_chaingun =
{
	d_rep_set();
	weapon_nailgun();

	w_chg_base();
	self.touch = wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise3 = "wolf/w_chg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_fire_motar =
{
	W_FireGrenade();

	newmis.touch = T_MissileTouch;
	newmis.velocity = newmis.velocity * 1.8;
};

void() w_weapon_mortar =
{
	q100_weapon_rocketlauncher();
	self.netname = "Mortar";

// fn
	self.touch = x_weapon_touch;
	self._attack = w_fire_motar;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 5; // W_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.volume = W_MAX_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 120;
	self.dodmg = 120;
	self.dmg_save = 1;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/w_mortar.mdl");
	self.weaponmodel = "progs/v_w_mortar.mdl";
	self.vwepmdl = "progs/vw_w_mortar.mdl";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "wolf/w_mortar.wav";
	self.noise4 = "wolf/w_resp.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_flamer =
{
	q100_weapon_lightning();
	self.netname = "Flame thrower";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireFlamer;
	self._fr_attack = player_flamer1;

// stats
	self.currentammo = 20;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_GAS;
	self.volume = W_MAX_GAS;
	self.attack_finished = 0.1;
	self.dmg = 10;
	self.dmg_save = 1;
	self.wait = RSP_TIME;

// appearances
	setmodel (self, "progs/w_flamer.mdl");
	self.weaponmodel = "progs/v_w_flamer.mdl";
	self.vwepmdl = "progs/vw_w_flamer.mdl";
//	self.target1 = "progs/";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "flm/ft_fire.wav";
	self.noise2 = "flm/ft_hum.wav";
	self.noise4 = "wolf/w_resp.wav";
//	self.target = ".wav";
	self.chaosweptime = 1.2;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_pistol =
{
	weapon_nailgun();
	self.netname = "Luger Pistol";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_pistol1;

// stats
	self.currentammo = 6;
	self.items = IT_SHOTGUN;
	self.lip = AMMO_BULLETS;
	self.volume = W_MAX_BULLETS;
	self.attack_finished = 0.465; // 2.15 per
	self.dmg = 10;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.01 0.01 0';
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/w_pistol.mdl");
	self.weaponmodel = "progs/v_w_pistol.mdl";
	self.vwepmdl = "progs/vw_w_pistol.mdl";
	self.noise3 = "wolf/w_pistol.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.duration = SND_OVER;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_knife =
{
	weapon_axe();
	self.netname = "Knife";

	self.touch = x_weapon_touch;
	self._attack = melee_hit;
	self._fr_attack = player_axe1;

// stats
	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = AMMO_NONE;
	self.attack_finished = 0.465; // 2.15 per
	self.dmg = 20;
	self.dmg_save = 48;
	self.dmg_take = 1;
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/w_knife.mdl");
	self.weaponmodel = "progs/v_w_knife.mdl";
	self.vwepmdl = "progs/vw_w_knife.mdl";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "wolf/w_knife.wav";
	self.noise4 = "wolf/w_resp.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};


void() w_ammo_clip =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.volume = W_MAX_BULLETS;
	self.currentammo = W_DEF_BULLETS_CLIP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/w_clip.mdl");
	self.noise = "wolf/pickup_am.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.netname = "Clip";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_ammo_gas =
{
	item_spikes();
	self.touch = pk_ammo_touch;
	self.netname = "Gas can";

	self.lip = AMMO_GAS;
	self.currentammo = 14;
	if (self.spawnflags & 1)
	{
		self.currentammo = 28;
//		self.frame = 1;
//		self.skin = 1;
	}

	setmodel(self, "progs/heal_medkit.mdl"); // why not?
	self.frame = 4;
	self.skin = 4;
//	self.map = " lbs gas cylinder pressure";
//	self.volume = MAX_GAS;
	self.noise = "wolf/pickup_am.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_item_pack =
{
	item_shells();
	self.netname = "Ammo Pack";

	self.touch = x_pack_touch;
	self.pk_items =
	self.items = 0; // must be for bp touch call
	self.rune_flag = RUNE_AMMO;
	self.ammo_bullet = 20;
	self.ammo_rockets = 5;
	self.ammo_gaspr = 96; // 2; - not alot, wolf flamer must have operated diff, used 2 x 48 lbs cylanders
	self.wait = RSP_TIME;

	setmodel(self, "progs/d_pack.mdl");
	self.skin = 1;
	self.noise = "wolf/pickup_am.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_art_facesphere =
{
	q100_item_health();
	setmodel(self, "progs/d_spheres.mdl");
	self.frame = 0;
	self.skin = 4;
	self.noise = "wolf/pickup_gdy.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.netname = "Face Sphere";
	self.healamount = 100;
	self.ammo_bullet = 25; // doh - special
	self.healtype = HEAL_SOUL; // normally max 100, but we need to accomodate +1 life
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_heal_medkit =
{
	q100_item_health();
	setmodel(self, "progs/heal_medkit.mdl");
	self.frame = 1;
	self.skin = 1;
	self.noise = "wolf/pickup_gdy.wav";
	self.noise4 = "wolf/w_resp.wav";
	self.netname = "Medkit";
	self.healamount = D_DEF_HMEDKIT;
	self.healtype = HEAL_NORM;
	self.volume = 100; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_key =
{
	if (self.spawnflags & 1)
		item_key2();
	else //if (self.spawnflags & 2)
		item_key1();

	self.wait = RSP_TIME;

	self.noise = "wolf/pickup_gdy.wav";
	setmodel (self, "progs/w_key.mdl");
	self.noise4 = "wolf/w_resp.wav";

	self.netname = "Blue key";
	if (self.spawnflags & 1) self.netname = "Gold key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_key_g =
{
	self.spawnflags = 1;
	self.skin = 1;
	w_key();
};

void() w_key_b =
{
	self.spawnflags = 2;
	self.skin = 2;
	w_key();
};

void() w_barl_solid =
{
	self.owner.solid = SOLID_BBOX;
	self.owner.pk_touch = SUB_Null;
	remove(self);
};

void() w_barrel =
{
	local entity e;
	e = spawn();
	if (e)
	{
		e.owner = self;
		e.think = w_barl_solid;
		e.nextthink = time  + 1;
	}
	self.wait = RSP_TIME;

	self.netname = "Barrel";
	setmodel (self, "progs/barrel2.mdl");
	self.frame = 1;
	self.noise4 = "wolf/w_resp.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
//	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

// code to run doom ents


//fn(d_thk_reps) - some guns wont appear in map if in correct position - have to load elsewhere and move later

void () d_thk_reps =
{
	local entity t;

	t = find (world, targetname, self.owner.target);
	if (t)
	{
		setorigin(self.owner, t.origin);
		self.owner.oldorigin = t.origin;
		self.owner.ip_orgOrigin = t.origin;
	}
	remove(self);
};

void() d_rep_set =
{
	if (self.delay == d_reps_base)
	{
		local entity e;
		e = spawn();
		e.think = d_thk_reps;
		e.nextthink = time + 2;
		e.classname = "d_reps";
		e.owner = self;
	}
};

void() wchg2_weapon_touch =
{
	local entity e;

	e = vchk(self.items, 0, other.vwepent);
	if (e)
	if (e.eweapon)
	{
		if (deathmatch == 3 || deathmatch == 2 || coop) return; // too easy in dm 2 / 3 / coop - not allowed for now

		if (! (other.items & IT_LIGHTNING))
		if (e.eweapon.mdl == "progs/vw_w_chaing.mdl") // IDEA: do for other akimbos
		{
			self.items = IT_LIGHTNING;
			self.dmg_save = 2;
			self.dmg_take = 4;
			self.punchangle = ' 0.07 0.07 0';

			self.netname = "Dual Chain Gun";

			self.weaponmodel = "progs/v_w_2chg.mdl";
			self.vwepmdl = "progs/vw_w_2chaing.mdl";

			x_weapon_touch();
			w_chg_base();
			self.model = string_null;
			return;
		}
	}

	x_weapon_touch();
};

void() player_saw1 = [$shotatt1, player_saw1]
{
	if (!self.button0)
	{
		self.eweapon.fly_sound = 0;
		player_run ();
		return;
	}

	if (self.weaponframe == 0)
	{
		self.tomb_time = 1;
		self.chaosweptime = 0;
//		ominous_hum(self.eweapon.noise3, 1.64);
		self.weaponframe = 3;
	}
	else
// cyclic weapon frame for 1pf
//	if ((time * 10) & 1)
		self.weaponframe = self.weaponframe + self.tomb_time;

	if (self.weaponframe >= 5)
	{
		self.weaponframe = 5;
		self.tomb_time = -1;
	}
	else if (self.weaponframe <= 1)
	{
		self.weaponframe = 1;
		self.tomb_time = 1;
	}
	self.frame = $shotatt1 + self.weaponframe;

	EWEAP = self.eweapon;
	EWEAP.fly_sound = HUMLOCAL;
	ominous_hum(EWEAP.noise3, 1.64);

	melee_hit(); // look for something to cut

	self.nextthink = time + EWEAP.attack_finished;
	if (!rune_haste(EWEAP.attack_finished / 2))
		self.nextthink = time + EWEAP.attack_finished / 2;
	EWEAP = world;
};

// bring  saw up - has to happen on switch (drop / pull deal)

void() player_sawu1 = [$shotatt1, player_sawu2]
{
	ominous_hum("doom/dssawup.wav", 1.48);
	self.weaponframe = 6;
};
void() player_sawu2 = [$shotatt2, player_sawu3] { self.weaponframe = 7; };
void() player_sawu3 = [$shotatt3, player_sawu4] { self.weaponframe = 8; };
void() player_sawu4 = [$shotatt4, player_sawu5] { self.weaponframe = 7; };
void() player_sawu5 = [$shotatt5, player_sawu6] { self.weaponframe = 6; };
void() player_sawu6 = [$shotatt6, player_stand1] { };


// specials, decor

void() d_bloody_mess =
{
// for now
	if (!DARKPLACES)
	{
		remove(self);
		return;
	}
	precache_model("progs/md2/marine_squished.md2");
	setmodel(self,"progs/md2/marine_squished.md2");
//	setorigin(self, self.origin + ' 0 0 -8');
	self.frame = 9;
	self.movetype = MOVETYPE_TOSS;
};

void() d_dead_player =
{
// for now
	if (!DARKPLACES)
	{
		remove(self);
		return;
	}
	precache_model("progs/md2/marine.md2");
	setmodel(self,"progs/md2/marine.md2");
//	setorigin(self, self.origin + ' 0 0 -8');
	self.frame = 146;
	self.movetype = MOVETYPE_TOSS;
};

void() d_pool_flesh_blood =
{
// for now
	if (!DARKPLACES)
	{
		remove(self);
		return;
	}
	precache_model("progs/md2/blood.md2");
	setmodel(self,"progs/md2/blood.md2");
	self.frame = 9;
	self.movetype = MOVETYPE_TOSS;
};

