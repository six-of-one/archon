/* ::-::
 *
 * Cataboligne
 *
 * file: hlents.qc
 *
 * date: 10/12/12
 *
 * qc - support half life stuff
 *
 */

// for now these only translate to q1 / pk items - no hl support yet


// protos
void() item_painkeep_gwell;
void() item_painkeep_turret;
void() item_painkeep_beartrap;
void() item_painkeep_expshells;
void() weapon_airfist;
void() item_health;


/// weapons

void() weapon_rpg =
{
	q100_weapon_rocketlauncher();

	if (TRUE)
//	if (!ULOKHL)
//	if (!GENERATIONS)
//	if (noxtr_item_control(self, TRUE, "")) // use for converted maps? but uses sv_xtras tag
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_rocketlauncher";
		return;
	}

	self.netname = "RPG";

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
  
void() weapon_9mmhandgun =
{
	d_weapon_pistol();
	if (self.netname == "Pistol") self.classname = "d_weapon_pistol";
};

void() weapon_357 =
{
	d_weapon_pistol();
	if (self.netname == "Pistol") self.classname = "d_weapon_pistol";
};

void() weapon_9mmAR =
{
	weapon_chaingun();
	if (self.netname == "Chain Gun") self.classname = "weapon_chaingun";
};

void() weapon_crowbar =
{
	weapon_grapgun();
	self.classname = "weapon_grapgun";

//	weapon_axe();
//	self.classname = "weapon_axe";
};

void() weapon_gauss =
{
	q100_weapon_lightning();

	if (random() < 0.4)
	{
		weapon_chainlg();
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_chainlg";
	}
	else
	if (TRUE)
//	if (!ULOKHL)
//	if (!GENERATIONS)
//	if (noxtr_item_control(self, TRUE, "")) // use for converted maps? but uses sv_xtras tag
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

};


void() weapon_egon =
{
	float rn;

	q100_weapon_lightning();

	rn = random();
	if (rn < 0.2)
	{
		weapon_hyperblaster();
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
	if (self.netname == "Hyper Blaster") self.classname = "weapon_hyperblaster";
	}
	else
	if (rn < 0.6)
	{
		q2_weapon_bfg();
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
	if (self.netname == "BFG 10000") self.classname = "q2_weapon_bfg";
	}
	else
	if (TRUE)
//	if (!ULOKHL)
//	if (!GENERATIONS)
//	if (noxtr_item_control(self, TRUE, "")) // use for converted maps? but uses sv_xtras tag
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

};


void() weapon_handgrenade =
{
	q100_weapon_grenadelauncher();

	if (TRUE)
//	if (!ULOKHL)
//	if (!GENERATIONS)
//	if (noxtr_item_control(self, TRUE, "")) // use for converted maps? but uses sv_xtras tag
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_grenadelauncher";
		return;
	}

};

void() weapon_tripmine =
{
	item_painkeep_gwell();
};

void() weapon_satchel =
{
	item_painkeep_turret();
};

void() weapon_snark =
{
	item_painkeep_beartrap();
};

void() weapon_hornetgun =
{
	item_painkeep_expshells();
};

void() weapon_crossbow =
{
	weapon_airfist();
};



/// ammos

void() ammo_9mmbox =
{
	d_ammo_ammobox();
//	if (self.netname == "Box of bullets") self.classname = "d_ammo_ammobox";
};

void() ammo_9mmclip =
{
	d_ammo_clip();
//	if (self.netname == "Clip") self.classname = "d_ammo_clip";
};

void() ammo_9mmAR =
{
	d_ammo_clip();
};

void() ammo_gaussclip =
{
	q2_ammo_cells();
};

void() ammo_rpgclip =
{
	item_rockets();
};

void() ammo_ARgrenades =
{
	item_rockets();
};

void() ammo_buckshot =
{
	item_shells();
};

void() ammo_crossbow =
{
	item_painkeep_expshells();
};


/// items

void() item_healthkit =
{
	item_health();
};


void() item_suit =
{
	item_armorInv();
	self.classname = "item_armorInv";
};


void() item_airtank =
{
	item_breather();
	if (self.netname == "Re-breather") self.classname = "item_breather";
};


void() item_longjump =
{
	item_flight();
//	if (self.netname == "Flight") self.classname = "item_flight";
};


void() item_battery =
{
	item_painkeep_can();
};



