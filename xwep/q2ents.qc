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
// weps
// view models
// viswep
// ammo
// heal
// armor
// items
// keys
	precache_model ("progs/q2_adrenaline.mdl");
	precache_model ("progs/q2_armorbody.mdl");
	precache_model ("progs/q2_armorcombat.mdl");
	precache_model ("progs/q2_armorjacket.mdl");
	precache_model ("progs/q2_armorpower.mdl");
	precache_model ("progs/q2_armorscreen.mdl");
	precache_model ("progs/q2_armorshard.mdl");
	precache_model ("progs/q2_bando.mdl");
	precache_model ("progs/q2_barrel.mdl");
	precache_model ("progs/q2_bfg.mdl");
	precache_model ("progs/q2_blaster.mdl");
	precache_model ("progs/q2_breather.mdl");
	precache_model ("progs/q2_bullets.mdl");
	precache_model ("progs/q2_cellbox.mdl");
	precache_model ("progs/q2_chain.mdl");
	precache_model ("progs/q2_dblshot.mdl");
	precache_model ("progs/q2_envirosuit.mdl");
	precache_model ("progs/q2_gl.mdl");
	precache_model ("progs/q2_grenades.mdl");
	precache_model ("progs/q2_heal_large.mdl");
	precache_model ("progs/q2_heal_medium.mdl");
	precache_model ("progs/q2_heal_mega.mdl");
	precache_model ("progs/q2_heal_stimpak.mdl");
	precache_model ("progs/q2_hyperb.mdl");
	precache_model ("progs/q2_inv.mdl");
	precache_model ("progs/q2_keycd.mdl");
	precache_model ("progs/q2_key_cmd_head.mdl");
	precache_model ("progs/q2_keypass.mdl");
	precache_model ("progs/q2_keypower.mdl");
	precache_model ("progs/q2_keypyramid.mdl");
	precache_model ("progs/q2_keyrb.mdl");
	precache_model ("progs/q2_keyspinner.mdl");
	precache_model ("progs/q2_keytarget.mdl");
	precache_model ("progs/q2_m_berserk.mdl");
	precache_model ("progs/q2_m_boss2_flyer.mdl");
	precache_model ("progs/q2_m_brain.mdl");
	precache_model ("progs/q2_m_flipper.mdl");
	precache_model ("progs/q2_m_float.mdl");
	precache_model ("progs/q2_m_flyer.mdl");
	precache_model ("progs/q2_m_glad.mdl");
	precache_model ("progs/q2_mgun.mdl");
	precache_model ("progs/q2_m_gunner.mdl");
	precache_model ("progs/q2_m_hover.mdl");
	precache_model ("progs/q2_m_infantry.mdl");
	precache_model ("progs/q2_m_jorg.mdl");
	precache_model ("progs/q2_m_jorg_rider.mdl");
	precache_model ("progs/q2_m_medic.mdl");
	precache_model ("progs/q2_m_mutant.mdl");
	precache_model ("progs/q2_m_paras.mdl");
	precache_model ("progs/q2_m_rbtch.mdl");
	precache_model ("progs/q2_m_soldier.mdl");
	precache_model ("progs/q2_m_tank.mdl");
	precache_model ("progs/q2_pack.mdl");
	precache_model ("progs/q2_quad.mdl");
	precache_model ("progs/q2_rail.mdl");
	precache_model ("progs/q2_rocketl.mdl");
	precache_model ("progs/q2_rockets.mdl");
	precache_model ("progs/q2_shells.mdl");
	precache_model ("progs/q2_shotgun.mdl");
	precache_model ("progs/q2_silencer.mdl");
	precache_model ("progs/q2_slugs.mdl");
	precache_model ("progs/v_q2_bfg.mdl");
	precache_model ("progs/v_q2_blst.mdl");
	precache_model ("progs/v_q2_chg.mdl");
	precache_model ("progs/v_q2_gl.mdl");
	precache_model ("progs/v_q2_hbl.mdl");
	precache_model ("progs/v_q2_mg.mdl");
	precache_model ("progs/v_q2_rail.mdl");
	precache_model ("progs/v_q2_rl.mdl");
	precache_model ("progs/v_q2_shot2.mdl");
	precache_model ("progs/v_q2_shot.mdl");
	precache_model ("progs/vw_q2_bfg.mdl");
	precache_model ("progs/vw_q2_blst.mdl");
	precache_model ("progs/vw_q2_chg.mdl");
	precache_model ("progs/vw_q2_dblshot.mdl");
	precache_model ("progs/vw_q2_gl.mdl");
	precache_model ("progs/vw_q2_hbl.mdl");
	precache_model ("progs/vw_q2_hgr.mdl");
	precache_model ("progs/vw_q2_mg.mdl");
	precache_model ("progs/vw_q2_rail.mdl");
	precache_model ("progs/vw_q2_rock2.mdl");
	precache_model ("progs/vw_q2_rock.mdl");
	precache_model ("progs/vw_q2_shot.mdl");
	precache_model ("progs/q2_grap.mdl");
	precache_model ("progs/vw_q2_grap.mdl");
//	precache_model ("progs/q2_ctf_tech.mdl");
	precache_model ("progs/q2_ctf_haste.mdl");
	precache_model ("progs/q2_ctf_regen.mdl");
	precache_model ("progs/q2_ctf_resist.mdl");
	precache_model ("progs/q2_ctf_stren.mdl");


// sounds
// heal
// arm
// weps
	precache_sound ("sound/q2_snd/telehum.wav");
	precache_sound ("sound/q2_snd/telep1.wav");
	precache_sound ("sound/q2_snd/rg_hum.wav");
	precache_sound ("sound/q2_snd/pwr_arm_off.wav");
	precache_sound ("sound/q2_snd/pwr_arm_on.wav");
	precache_sound ("sound/q2_snd/airout.wav");
	precache_sound ("sound/q2_snd/protect.wav");
	precache_sound ("sound/q2_snd/damage.wav");
	precache_sound ("sound/q2_snd/pkup.wav");
	precache_sound ("sound/q2_snd/bfg_x1b.wav");
	precache_sound ("sound/q2_snd/bfg_l1a.wav");
	precache_sound ("sound/q2_snd/bfg_f1y.wav");
	precache_sound ("sound/q2_snd/bfg_hum.wav");
	precache_sound ("sound/q2_snd/machgf5b.wav");
	precache_sound ("sound/q2_snd/machgf4b.wav");
	precache_sound ("sound/q2_snd/machgf3b.wav");
	precache_sound ("sound/q2_snd/machgf2b.wav");
	precache_sound ("sound/q2_snd/chngnu1a.wav");
	precache_sound ("sound/q2_snd/chngnl1a.wav");
	precache_sound ("sound/q2_snd/chngnd1a.wav");
	precache_sound ("sound/q2_snd/ar3_pkup.wav");
	precache_sound ("sound/q2_snd/ar2_pkup.wav");
	precache_sound ("sound/q2_snd/ar1_pkup.wav");
	precache_sound ("sound/q2_snd/hgrent1a.wav");
	precache_sound ("sound/q2_snd/hgrenc1b.wav");
	precache_sound ("sound/q2_snd/hgrena1b.wav");
	precache_sound ("sound/q2_snd/hgrenb1a.wav");
	precache_sound ("sound/q2_snd/grenlb1b.wav");
	precache_sound ("sound/q2_snd/hyprbf1a.wav");
	precache_sound ("sound/q2_snd/machgf1b.wav");
	precache_sound ("sound/q2_snd/hyprbu1a.wav");
	precache_sound ("sound/q2_snd/hyprbd1a.wav");
	precache_sound ("sound/q2_snd/lashit.wav");
	precache_sound ("sound/q2_snd/laser2.wav");
	precache_sound ("sound/q2_snd/hyprbl1a.wav");
	precache_sound ("sound/q2_snd/blastf1a.wav");
	precache_sound ("sound/q2_snd/s_health.wav");
	precache_sound ("sound/q2_snd/n_health.wav");
	precache_sound ("sound/q2_snd/m_health.wav");
	precache_sound ("sound/q2_snd/l_health.wav");
	precache_sound ("sound/q2_snd/rocklx1a.wav");
	precache_sound ("sound/q2_snd/railf_mx.wav");
	precache_sound ("sound/q2_snd/shtf_mx.wav");
	precache_sound ("sound/q2_snd/sshotf1b.wav");
	precache_sound ("sound/q2_snd/grnf_mx.wav");
	precache_sound ("sound/q2_snd/rktf_mx.wav");
	precache_sound ("sound/q2_snd/respawn1.wav");
	precache_sound ("sound/q2_snd/w_pkup.wav");
	precache_sound ("sound/q2_snd/am_pkup.wav");
	precache_sound ("sound/q2_snd/q2_chg_fire.wav");
	precache_sound ("sound/q2_snd/dr1_end.wav");
	precache_sound ("sound/q2_snd/dr1_mid.wav");
	precache_sound ("sound/q2_snd/dr1_strt.wav");
	precache_sound ("sound/q2_snd/pt1_end.wav");
	precache_sound ("sound/q2_snd/pt1_mid.wav");
	precache_sound ("sound/q2_snd/pt1_strt.wav");
	precache_sound ("sound/q2_snd/butn2.wav");
// laser hook
	precache_sound ("q2_snd/lhook_h.wav");
	precache_sound ("q2_snd/lhook_l.wav");
// grapple gun q2 style
	precache_sound ("q2_snd/grfire.wav");
	precache_sound ("q2_snd/grhang.wav");
	precache_sound ("q2_snd/grhit.wav");
	precache_sound ("q2_snd/grpull.wav");
	precache_sound ("q2_snd/grreset.wav");

// runes
	precache_sound ("q2_snd/force2.wav");
	precache_sound ("q2_snd/damage3.wav");
	precache_sound ("q2_snd/x_light.wav");
	precache_sound ("q2_snd/s_health.wav");
	precache_sound ("q2_snd/makr_pain2.wav");
	precache_sound ("q2_snd/tech4.wav");
	precache_sound ("q2_snd/tech2.wav"); // tech2x - comb with quad
	precache_sound ("q2_snd/tech2x.wav");
	precache_sound ("q2_snd/tech1.wav");
	precache_sound ("q2_snd/tech3.wav");

//	precache_sound ("q2_snd/.wav");
	rail_precache();
};



void() q2_ammo_bullets =
{
	item_spikes();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q2_DEF_BULLETS_BOX;
		return;
	}

	self.netname = "Bullets";
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = Q2_DEF_BULLETS_BOX;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_BULLETS;

	setmodel (self, "progs/q2_bullets.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void() q2_ammo_rockets =
{
	item_rockets();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q2_DEF_ROCKETS_LG;
		return;
	}

	self.netname = "Rockets";
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = Q2_DEF_ROCKETS_LG;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_ROCKETS;

	setmodel (self, "progs/q2_rockets.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
};


void() q2_ammo_shells =
{
	item_shells();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q2_DEF_SHELLS;
		return;
	}

	self.netname = "Shells";
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = Q2_DEF_SHELLS;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_SHELLS;

	setmodel (self, "progs/q2_shells.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void() q2_ammo_cells =
{
	item_cells();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q2_DEF_CELLPAK;
		return;
	}

	self.netname = "Cells";
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = Q2_DEF_CELLPAK;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_CELLS;

	setmodel (self, "progs/q2_cellbox.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
};

void() q2_ammo_slugs =
{
	item_cells();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q2_DEF_CELLPAK;
		return;
	}

	self.netname = "Slugs";
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SLUGS;
	self.currentammo = Q2_DEF_SLUGS;
	self.wait = RSP_TIME;
	self.volume = Q2_MAX_SLUGS;

	setmodel (self, "progs/q2_slugs.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};


// kill messages

// bfg
string(entity targ, entity attacker) q2bfg_killmsg =
{
	if (targ == attacker) return " should have used a smaller gun.\n";
		
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was disintegrated by ";
};

string(entity targ, entity attacker) q2bfg_killmsg2 =
{
	if (targ == attacker) return "";
	return "'s BFG blast\n";
};

// rail
//string(entity targ, entity attacker) q2rail_killmsg =
string() q2rail_killmsg =
{
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was railed by ";
};

//string(entity targ, entity attacker) q2rail_killmsg2 =
string() q2rail_killmsg2 =
{
	return "\n";
};


// lightning
string() q2hbl_killmsg =
{
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was melted by ";
};

string() q2hbl_killmsg2 =
{
	return "'s hyperblaster\n";
};

// rocket
string(entity targ, entity attacker) q2rock_killmsg =
{
	if (targ == attacker) return " blew himself up.\n";
		
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " ate ";
};

string(entity targ, entity attacker) q2rock_killmsg2 =
{
	if (targ == attacker) return "";
	return "'s rocket\n";
};

// grenade
string(entity targ, entity attacker) q2gren_killmsg =
{
	if (targ == attacker) return " tripped on his own grenade.\n";
		
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was popped by ";
};

string(entity targ, entity attacker) q2gren_killmsg2 =
{
	if (targ == attacker) return "";
	return "'s grenade\n";
};

// hand grenade
string(entity targ, entity attacker) q2hgren_killmsg =
{
	if (targ == attacker) return " tripped on his own grenade.\n";
		
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " caught ";
};

string(entity targ, entity attacker) q2hgren_killmsg2 =
{
	if (targ == attacker) return "";
	return "'s hand grenade\n";
};

// super shotgun
string() q2ssg_killmsg =
{
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was blown away by ";
};

string() q2ssg_killmsg2 =
{
	return "'s super shotgun\n";
};

// shotgun
string() q2sg_killmsg =
{
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was gunned down by ";
};

string() q2sg_killmsg2 =
{
	return "\n";
};

// mg
//string(entity targ, entity attacker) q2cg_killmsg =
string() q2cg_killmsg =
{
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was cut in half by ";
};

//string(entity targ, entity attacker) q2cg_killmsg2 =
string() q2cg_killmsg2 =
{
	return "'s chaingun\n";
};


// mg
//string(entity targ, entity attacker) q2mg_killmsg =
string() q2mg_killmsg =
{
//	if (ENHANCED)
//		bprint(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was machinegunned by ";
};

//string(entity targ, entity attacker) q2mg_killmsg2 =
string() q2mg_killmsg2 =
{
	return "\n";
};

// melee
//string(entity targ, entity attacker) q2blst_killmsg =
string() q2blst_killmsg =
{
//	if (ENHANCED)
//		return(rnd_string(' 90.0 60.0 60.0'," "," ","",""," "));

	return " was blasted by ";
};

//string(entity targ, entity attacker) q2blst_killmsg2 =
string() q2blst_killmsg2 =
{
	return "\n";
};


/*
q2 wep inventory slots

slot		weapon
1				blaster *
2				shotgun *
3				doublebarrel
4				machine gun
5				chain gun
6				grenade launcher / hand grenades / railgun #
7				rocket launcher
8				bfg / hyperblaster #

* = touch fn will replace other slot 1 & 2 weps with these
# = items are currently exclusive in touch - you can only get one

*/

void() q2_ammo_grenades =
{
	item_rockets();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.aflag = Q2_DEF_BLAST;
		return;
	}

	self.netname = "Hand Grenades";

// fn
	self.touch = x_weapon_touch;
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

	self._killmsg = q2hgren_killmsg;
	self._killmsg2 = q2hgren_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};

// anything with another genre classname (weapon_bfg - q3) has q2_ prepended

/*QUAKED q2_weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q2_weapon_bfg =
{
	q100_weapon_lightning();

	if (!ULOK2)
//	if (!XMOD)
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

	self.netname = "BFG 10000";

// fn
	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_bfg1;
// stats
	self.currentammo = 50;
	self.items = IT_EXTRA_WEAPON;
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

	self._killmsg = q2bfg_killmsg;
	self._killmsg2 = q2bfg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () q2_weapon_railgun =
{
	q100_weapon_lightning();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

	self.netname = "Rail Gun";

	self.touch = x_weapon_touch;
	self._attack = X_FireRailgun;
	self._fr_attack = player_rocket1;

	self.currentammo = Q2_DEF_SLUGS;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_SLUGS;
	self.volume = Q2_MAX_SLUGS;
	self.aflag = IGN_INV; // swap with gl | grenades
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
	self.noise2 = "q2_snd/rg_hum.wav"; // gun hum
	self.chaosweptime = 1.16;
	self.endtime = 2.33;

	self._killmsg = q2rail_killmsg;
	self._killmsg2 = q2rail_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () weapon_hyperblaster =
{
	q100_weapon_lightning();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

	self.netname = "Hyper Blaster";

	self.touch = x_weapon_touch;
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

	self._killmsg = q2hbl_killmsg;
	self._killmsg2 = q2hbl_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;// + CB_SCOURGE;
};

void() q2_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();

	if (!ULOK2)
//	if (!XMOD)
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

	self._killmsg = q2rock_killmsg;
	self._killmsg2 = q2rock_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () q2_weapon_grenadelauncher =
{
	q100_weapon_grenadelauncher();

	if (!ULOK2)
//	if (!XMOD)
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

	self._killmsg = q2gren_killmsg;
	self._killmsg2 = q2gren_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;// + CB_SCOURGE;
};


void () weapon_chaingun =
{
	weapon_supernailgun();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_supernailgun";
		return;
	}

	self.netname = "Chain Gun";

	self.touch = x_weapon_touch;
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
	self.bulletspread = ' 0.03 0.03 0';
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

	self._killmsg = q2cg_killmsg;
	self._killmsg2 = q2cg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

// doing the same way even tho q2 doesnt offer a dbl yet
void() q2_mg_base =
{
	self.netname = "Machine Gun";

// stats
	self.items = IT_NAILGUN;
	self.currentammo = 50;
	self.lip = AMMO_BULLETS;
	self.volume = Q2_MAX_BULLETS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 8;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.bulletspread = ' 0.025 0.025 0';
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_mgun.mdl");
	self.weaponmodel = "progs/v_q2_mg.mdl";
	self.vwepmdl = "progs/vw_q2_mg.mdl";
};

void() q2_weapon_machinegun =
{
	weapon_nailgun();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_nailgun";
		return;
	}

	q2_mg_base();
	self.touch = x_weapon_touch;//wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_bullet_5";

	self._killmsg = q2mg_killmsg;
	self._killmsg2 = q2mg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () q2_weapon_supershotgun =
{
	q100_weapon_supershotgun();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_supershotgun";
		return;
	}

	self.netname = "Super Shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q2_DEF_SHOTG;
	self.aflag = IGN_INV;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = Q2_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = 6;
	self.dmg_save = 2;
	self.dmg_take = 20; // shot cnt
	self.bulletspread = ' 0.10 0.05 0'; // bullet spread out -- guestimate from q2 code below
/*
	r = crandom()*hspread; 1000 (500 for shotgun)
   u = crandom()*vspread; 500
   VectorMA (start, 8192, forward, end);
   VectorMA (end, r, right, end);
   VectorMA (end, u, up, end);
*/
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_dblshot.mdl");
	self.weaponmodel = "progs/v_q2_shot2.mdl";
	self.vwepmdl = "progs/vw_q2_dblshot.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/sshotf1b.wav";
	self.duration = SND_OVER;

	self._killmsg = q2ssg_killmsg;
	self._killmsg2 = q2ssg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () q2_weapon_shotgun =
{
	q100_weapon_shotgun();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = x_weapon_touch;
		self.classname = "weapon_shotgun";
		return;
	}

	self.netname = "Shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q2_DEF_SHOTG;
	self.aflag = IGN_INV;
	self.items = IT_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = Q2_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = 4;
	self.dmg_save = 1;
	self.dmg_take = 12; // shot cnt
	self.bulletspread = ' 0.05 0.05 0'; // bullet spread out -- guestimate from q2 code
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_shotgun.mdl");
	self.weaponmodel = "progs/v_q2_shot.mdl";
	self.vwepmdl = "progs/vw_q2_shot.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/shtf_mx.wav";
	self.duration = SND_OVER;

	self._killmsg = q2sg_killmsg;
	self._killmsg2 = q2sg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () q2_weapon_blaster =
{
	q100_weapon_shotgun();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = x_weapon_touch;
		self.classname = "weapon_axe";
		return;
	}

	self.netname = "Blaster";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_pistol1;

	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
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

	self._killmsg = q2blst_killmsg;
	self._killmsg2 = q2blst_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};

void () q2_weapon_grapple =
{
	weapon_grapgun();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = painkeep_weapon_touch;
		self.classname = "weapon_grapgun";
		return;
	}

	self.netname = "Grappling hook";

	self.touch = x_weapon_touch;
	self._attack = player_q3grap;
	self._fr_attack = SUB_Null;

	self.currentammo = 0;
	self.lip = 0;
	self.attack_finished = 0.5;
	self.lefty = SEL_S_HOOK;
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_GRAPGUN; // grap replacement

	self.dmg = 5;

	self.style = FL_MELEE_WEP;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.vv_draw = vw_q1_grap;

	setmodel (self, "progs/q2_grap.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
	self.vwepmdl = "progs/vw_q2_grap.mdl";

	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/grpull.wav";

// grap specials

	self.killtarget =  "progs/vw_q2_grap.mdl";
	self.dmg_save = 7; // hook frame internal

	self.target = "q2_snd/grhit.wav"; // hook hit a solid - not damaged
	self.noise1 = "q2_snd/grreset.wav"; // drop
	self.target1 = "q2_snd/grhang.wav"; // in + out
	self.target2 = "q2_snd/grhang.wav"; // in + out
	self.targetname = "q2_snd/grfire.wav"; // launch snd
	self.bulletspread_x = 0.75; // damp

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};

void() q2_item_health_small =
{
	q100_item_health();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.healamount = Q2_DEF_HBOTTLE;
		return;
	}

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
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() q2_item_health =
{
	q100_item_health();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.healamount = Q2_DEF_HFIRSTAID;
		return;
	}

	setmodel(self, "progs/q2_heal_medium.mdl");
	self.noise = "q2_snd/n_health.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "First Aid";
	self.healamount = Q2_DEF_HFIRSTAID;
	self.healtype = HEAL_NORM;
	self.volume = Q_NORM_MAX; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() q2_item_health_large =
{
	q100_item_health();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.healamount = Q2_DEF_HMEDKIT;
		return;
	}

	setmodel(self, "progs/q2_heal_large.mdl");
	self.noise = "q2_snd/l_health.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Medkit";
	self.healamount = Q2_DEF_HMEDKIT;
	self.healtype = HEAL_NORM;
	self.volume = Q_NORM_MAX; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() q2_item_health_mega =
{
	self.spawnflags = self.spawnflags | 2;
	q100_item_health();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_health_mega"))
	{
		return;
	}

	setmodel(self, "progs/q2_heal_mega.mdl");
	self.noise = "q2_snd/m_health.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Mega health";
	self.items = IT_SUPERHEALTH;
	self.healamount = Q2_DEF_HMEGATUBE;
	self.healtype = HEAL_MEGA;
	self.volume = Q_MEGA_MAX;
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() q2_misc_explobox =
{
	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "misc_explobox"))
	{
		return;
	}

	self.netname = "Barrel";
	if (self.class_select == "") self.class_select = "q2_item";
	misc_explodbox_set(self, "progs/q2_barrel.mdl", Q2_BARREL_BLAST, 80, MOVETYPE_NONE);
	setsize (self, '-14 -14 0', '14 14 42');
	self.frame = 0;
//	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.wait = RSP_TIME;
//	self.effects = self.effects | EF_FULLBRIGHT;
};

void() q2_item_armor_body =
{
	item_armorInv();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armorInv";
		return;
	}

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
	self.mask_x = CB_HUMAN + CB_ENF;
};

void() q2_item_armor_combat =
{
	item_armor2();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armor2";
		return;
	}

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
	self.mask_x = CB_HUMAN + CB_ENF;
};

void() item_armor_jacket =
{
	item_armor1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armor1";
		return;
	}

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
	self.mask_x = CB_HUMAN + CB_ENF;
};

void() q2_item_armor_shard =
{
	item_armor1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, FALSE, ""))
	{
		self.classname = "item_armor1";
		self.wad = "armor_toss"; // for alt value
		self.noise = "items/armor1.wav";
		self.items = IT_ARMOR1;
		self.volume = 200; // max add
		self.currentammo = Q2_ARM_SHRD; // 2 units
		return;
	}

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
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() item_power_shield =
{
	item_armor1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armor2";
		return;
	}

	self.netname = "Energy armor";

	self.touch = x_item_touch;
	self.x_items = X_PWR_ARMOR;
	self.volume = -1;
	self.style = 0;
	self.currentammo = 0;
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_armorpower.mdl");
	self.noise = "q2_snd/ar1_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;
};

void() item_power_screen =
{
	item_armor1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armor1";
		return;
	}

	self.netname = "Power screen";

	self.touch = x_item_touch;
	self.x_items = X_PWR_SCREEN;
	self.volume = -1;
	self.style = 0;
	self.currentammo = 0;
	self.wait = RSP_TIME;

	setmodel (self, "progs/q2_armorscreen.mdl");
	self.noise = "q2_snd/ar1_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;
};

void() item_silencer =
{
	item_spikes();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}
	else
		item_artifact_invisibility();

	self.netname = "Silencer";
	self.group = "Stealth mission is nearly complete\n";

	self.touch = x_pwr_touch;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_silencer.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};


void() item_invulnerability =
{
	item_artifact_invulnerability();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	self.netname = "Invulnerability";
	self.group = "Invulnerability is almost bunred out\n";

	self.touch = x_pwr_touch;
	self.items = IT_INVULNERABILITY;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_inv.mdl");
	self.noise = "q2_snd/protect.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() q2_item_enviro =
{
	item_artifact_envirosuit();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	self.netname = "Environmental Suit";
	self.group = "Environmental Suit is near expiration date\n";

	self.touch = x_pwr_touch;
	self.items = IT_SUIT;
	self.delay = POW_TIME;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;

	setmodel (self, "progs/q2_envirosuit.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise3 = "q2_snd/airout.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL - (MORPH_ALL & CB_CTHON); // everyone can get arts - no bio for lava boy tho
};

void() q2_item_quad =
{
	item_artifact_super_damage();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	self.netname = "Quad Damage";
//	self.group = "\n"; // same message

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
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() adrenaline_touch =
{
	other.max_health = other.max_health + 1;
	health_touch();
	other.healtype = HEALT_CURE; // fire, plague & continous health rot stop
};

void() item_adrenaline =
{
	q100_item_health();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_health_mega"))
	{
		return;
	}

	self.netname = "Adrenaline";

	self.touch = adrenaline_touch;
	self.healamount = Q2_DEF_HMEGATUBE;
	self.healtype = HEAL_NORM;
	self.volume = Q_NORM_MAX; // max add
	self.wait = Q2_POWER_WAIT;

	setmodel(self, "progs/q2_adrenaline.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() item_bandolier =
{
	item_spikes();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_armor2"))
	{
		return;
	}

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
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF; // everyone can get arts
};

void() item_pack =
{
	item_spikes();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_artifact_envirosuit"))
	{
		return;
	}

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
	self.mask_x = CB_HUMAN + CB_GREMLIN; // everyone can get arts
};

void() item_breather =
{
	item_artifact_envirosuit();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		self.classname = "item_artifact_envirosuit";
		return;
	}

	self.netname = "Re-breather";
	self.group = "Air supply in Re-breather expiring\n";

	self.touch = x_pwr_touch;
	self.delay = POW_TIME;
	self.wait = Q2_POWER_WAIT;
	self.dmgtime = Q2_POWER_TIME;
	self.items = 0; //clear flag from init

	setmodel(self, "progs/q2_breather.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise3 = "q2_snd/airout.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL - (MORPH_ALL & CB_CTHON); // everyone can get arts - no bio for lava boy tho
};

void() key_pyramid =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keypyramid.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Pyramid Key";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_PYRAMID;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_power_cube =
{
	item_key2();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keypower.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power Cube";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_CUBE;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_pass =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keypass.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Pass Key";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_PASS;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_data_cd =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keycd.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Data CD";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_DATACD;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_data_spinner =
{
	item_key2();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keyspinner.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Data Spinner";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_CDSPIN;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_airstrike_target =
{
	item_key2();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keytarget.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Airstrike Target";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_AIRSTRK;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_blue_key =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keyrb.mdl");
	self.skin = 1;
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Blue Key";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_BLUE;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_red_key =
{
	item_key2();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_keyrb.mdl");
	self.skin = 0;
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Red Key";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_RED;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

void() key_commander_head =
{
	item_key2();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_key_cmd_head.mdl");
	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Commanders Head";
	self.touch = x_item_touch;
	self.x_items = X_Q2_KEY_CHEAD;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

// ctf lithium tech runes - map item spawn code
//		display for test map - dont operate as runes even if rune server is on, no rune bits get set here

// ---: tech implement - needs to be controlled by rune server if active - override these settings - REMOVE comment
//		dont need this - these are not active runes - REMOVE comment

/*QUAKED q2_ctf_haste (0 .5 .8) (-16 -16 -16) (16 16 16)
*/

// NOTE: glow shell is gone for now...remove this code if it is not ever restored
float CTF_TECH_SHELL = 0; // set to 5 for a glow shell around techs

void() q2_ctf_haste =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_ctf_haste.mdl");
	self.frame = 0 + CTF_TECH_SHELL;
	self.skin = 0;

	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Time Accelerator";
	self.touch = x_item_touch;
//	self.x_items = X_Q2_KEY_PYRAMID;
	self.wait = RSP_TIME;
// override
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

/*QUAKED q2_ctf_regen (0 .5 .8) (-16 -16 -16) (16 16 16)
*/

void() q2_ctf_regen =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_ctf_regen.mdl");
	self.frame = 1 + CTF_TECH_SHELL;
	self.skin = 1;

	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Auto Doctor";
	self.touch = x_item_touch;
//	self.x_items = X_Q2_KEY_PYRAMID;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

/*QUAKED q2_ctf_resist (0 .5 .8) (-16 -16 -16) (16 16 16)
*/

void() q2_ctf_resist =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_ctf_resist.mdl");
	self.frame = 2 + CTF_TECH_SHELL;
	self.skin = 2;

	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Disruptor Shield";
	self.touch = x_item_touch;
//	self.x_items = X_Q2_KEY_PYRAMID;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
};

/*QUAKED q2_ctf_stren (0 .5 .8) (-16 -16 -16) (16 16 16)
*/

void() q2_ctf_stren =
{
	item_key1();

	if (!ULOK2)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, ""))
	{
		return;
	}

	setmodel(self, "progs/q2_ctf_stren.mdl");
	self.frame = 3 + CTF_TECH_SHELL;
	self.skin = 3;

	self.noise = "q2_snd/pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power Amplifier";
	self.touch = x_item_touch;
//	self.x_items = X_Q2_KEY_PYRAMID;
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
	self.mask_x = MORPH_ALL; // everyone can get goody
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
		player_q2hgr1();
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

// IMP: if an ent is targeted, reload origin

void() q2_teleport_particles =
{
	local vector v1;
	local float f, z;

	self.nextthink = time + 0.2;

	if (self.th_die != SUB_Null) // really power point sub call
   if (self.th_die != (void()) 0)
		self.th_die();

	if (self.classname == "archon_power")
	{
		if (self.spawnflags & NOSPRAY) return; // no particles - still have to think for other fns
		z = 20; // particle fountain origin needs a boost up
		}

	if (!self.cnt)
		self.cnt = 192;

	f = 4;
	while (f > 0)
	{
		v1_x = crandom() * 18;
		v1_y = crandom() * 18;
		v1_z = z + crandom() * 6;
		self.velocity_z = 200 + crandom() * 50;
		particle (self.origin + v1, self.velocity, self.cnt, 4);

		v1_x = crandom() * 18;
		v1_y = crandom() * 18;
		v1_z = z + 16 + crandom() * 6;
		self.velocity_z = 200 + crandom() * 50;
		particle (self.origin + v1, self.velocity, self.cnt, 4);

		v1_x = crandom() * 18;
		v1_y = crandom() * 18;
		v1_z = z + 32 + crandom() * 6;
		self.velocity_z = 200 + crandom() * 50;
		particle (self.origin + v1, self.velocity, self.cnt, 4);

		f = f - 1;
	}
};

// allow map compile particle fountain / sound  because regular q2 one requires q2.wad for map

void() func_q2_telepart =
{
	chaos_spawn(0, 0, 0, 0,  self.origin, v0, v0, v0, v0, "", "", SUB_Null, 1, q2_teleport_particles, SUB_Null, self, world);
	ambientsound (self.origin + ' 0 0 32', "q2_snd/telehum.wav", 1, ATTN_STATIC);
	remove(self); // IDEA: when chaos mod, leave this for changes?
};

// fn() - reverse armorsave value so real armor can be manipulated

void(entity e) armorsave_rev =
{
	if (!e) return;

	if (e.armorsave)
	{
		if (e.armorsave < 1) e.armorvalue = 0;
		else e.armorvalue = e.armorsave;
		e.armorsave = 0;
	}
};

// return damage saved based on power armor settings and damage done

float(entity e, entity f, float dm) power_armor =
{
	float save, pdmg, pwr, pwr_use, dpc;

	pdmg = dm;
	pwr = e.ammo_cells;

	armorsave_rev(e);

	if (e.health < 0) return 0;
	if (pwr < 1) return 0;

	if (e.x_items & X_PWR_ARMOR_ON)
	{
		dpc = 2; // damage handled per cell
		pdmg = (2 * pdmg) / 3; // can only cover this much of total damage
	}
	else if (e.x_items & X_PWR_SCREEN_ON)
	{
		cht_if = 0.3; // in front test
		if (!can_has_target(e, world, f.origin, 0, TFL_INFR | TFL_IFR_NOZ)) return 0;
		dpc = 1;
		pdmg = pdmg / 3;
	}
	else
		return 0; // no armor or armor off line

	save = pwr * dpc; // can stop this much damage

	if (!save) return 0;

	if (save > pdmg) save = pdmg;

	pwr_use = save / dpc; // used this many cells

	e.ammo_cells = e.ammo_cells - pwr_use;

	if (e.ammo_cells <= 0)
	{
		e.ammo_cells = 0;
// not doing this - if armor was on & more cells are gotten its stays on till turned off
//		e.x_items = e.x_items - (e.x_items & X_PWR_ARM_MASK); // turn off armor - out of cells
	}

	return(save);
};

void() power_armor_impulse =
{
	if (self.health < 0) return;
	if (! self.flags & FL_CLIENT) return;

	if (! self.x_items & X_PWR_ARM_INV) // no power armor
	{
		if (random() < 0.4) sprint(self, "You must collect power armor first to activate it\n");
		return;
	}

	if (! self.x_items & X_PWR_ARM_MASK) // none on
	{
		if (self.x_items & X_PWR_ARMOR) self.x_items = self.x_items | X_PWR_ARMOR_ON;
		else
		if (self.x_items & X_PWR_SCREEN) self.x_items = self.x_items | X_PWR_SCREEN_ON;
	}
	else
	if (self.x_items & X_PWR_ARMOR_ON) // power armor on
	{
		if (self.x_items & X_PWR_SCREEN) self.x_items = self.x_items | X_PWR_SCREEN_ON - (self.x_items & X_PWR_ARMOR_ON); // switch to screen if we have it
		else self.x_items = self.x_items - (self.x_items & X_PWR_ARMOR_ON);
	}
	else
	if (self.x_items & X_PWR_SCREEN_ON) // power screen on
		self.x_items = self.x_items - (self.x_items & X_PWR_SCREEN_ON); // turn it off

	if ((self.x_items & X_PWR_ARM_INV) == X_PWR_ARM_INV) // tell which is on if both in inventory
	{
		if (self.x_items & X_PWR_ARMOR_ON)
			sprint(self, "Energy Armor turned on.\n");
		else
		if (self.x_items & X_PWR_SCREEN_ON)
			sprint(self, "Power Screen turned on.\n");
		else
			sprint(self, "Power Armors turned off.\n");
	}

	if (! self.x_items & X_PWR_ARM_MASK) // turned off
	{
		if (self.ammo_cells > 0)
			sound (self, CHAN_ITEM, "q2_snd/pwr_arm_off.wav", 1, ATTN_NORM);
	}
	else if (self.ammo_cells < 1)
		sprint(self, "Power armor protection will activate when you get some cells.\n");
	else
		sound (self, CHAN_ITEM, "q2_snd/pwr_arm_on.wav", 1, ATTN_NORM);

}
