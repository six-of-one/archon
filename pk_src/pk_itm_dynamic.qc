/* ::-::
 *
 * Cataboligne
 *
 * file: pk_itm_dynamic.qc
 *
 * date: 
 *
 * qc - support painkeep 2.0 dynamic items
 *
 */


// these fn are used by most item control code

// fn(item_repm) - replace / remove all items matching with a new item
// fn(item_bit) - provide item classname string by bit
// fn(item_call) - make item call based on string
// fn(item_down) - item (self) is removed from play for this map till admin overrides removal or new map is loaded
// fn(item_loop) - run loop making changes per pk_itemovr
// rep - item classname to replace
// cls - new classname
// op - save original classname in .wad so we can restore if mode is turned off

// NO_PI - global, if non zero and not a dyn-item, pk_placeitem will not be called for this ent

string (float bt) item_by_bit =
{
	if (bt == WEP_SSHOT) return("weapon_supershotgun");
	if (bt == WEP_NAILGUN) return("weapon_nailgun");
	if (bt == WEP_PERF) return("weapon_supernailgun");
	if (bt == WEP_GREN) return("weapon_grenadelauncher");
	if (bt == WEP_ROCKET) return("weapon_rocketlauncher");
	if (bt == WEP_THUNDER) return("weapon_lightning");
	if (bt == WEP_PKI) return("pki");
	if (bt == ART_INV) return("item_artifact_invulnerability");
	if (bt == ART_RAD) return("item_artifact_envirosuit");
	if (bt == ART_RING) return("item_artifact_invisibility");
	if (bt == ART_QUAD) return("item_artifact_super_damage");
	if (bt == ARM_GRN) return("item_armor1");
	if (bt == ARM_YEL) return("item_armor2");
	if (bt == ARM_RED) return("item_armorInv");
	if (bt == HEAL_15) return("item_health_15");
	if (bt == HEAL_25) return("item_health");
	if (bt == HEAL_100) return("item_health_mega");

	return(null_string);
};

// ammo for a given wep - used for replacements & pk items subs

string (float bt) ammo_by_bit =
{
// wep ammo by bit
	if (bt == WEP_SSHOT) return("item_shells");
	if (bt == WEP_NAILGUN) return("item_spikes");
	if (bt == WEP_PERF) return("item_spikes");
	if (bt == WEP_GREN) return("item_rockets");
	if (bt == WEP_ROCKET) return("item_rockets");
	if (bt == WEP_THUNDER) return("item_cells");
	if (bt == WEP_PKI) return("pki");
	
// pk item subs by special bits
	if (bt == WEP_GWELL) return("item_painkeep_gwell");
	if (bt == WEP_TURRET) return("item_painkeep_turret");
	if (bt == WEP_BTRAP) return("item_painkeep_beartrap");
	if (bt == WEP_EXPSH) return("item_painkeep_expshells");
	if (bt == WEP_GRAP) return("weapon_grapgun");
	if (bt == WEP_AIRG) return("weapon_airfist");
	if (bt == WEP_CPNB) return("item_painkeep_can");

// pk art item subs by special bits
	if (bt == WEP_EGO) return("item_pkplus_ego");
	if (bt == WEP_TOMB) return("item_pkplus_tomb");
	if (bt == WEP_ACTOR) return("item_pkplus_actor");
	if (bt == WEP_PHONE) return("item_pkplus_phone");

	return(null_string);
};

void(string cls) item_call =
{
	local string scls;
	local float rd, t_monsters;
	local entity f;

	t_monsters = total_monsters;

	f = world;
	rd = random();
	if (self.event != "dyn_monster")
	if (self.event != "dynamic_item") // because explod box translantions & randomizes need faked
	{
		rd = 1;

		if (self.enemy)
		if (self.enemy.wad == "item_call_fake")
			remove(self.enemy);

// restore boom boxes by regen
		if (cls == "misc_explobox" || cls == "misc_explobox2" || cls == "d_barrel" || cls == "q2_misc_explobox" || cls == "q3_misc_explobox")
		if (self.scode == MC_EXPLOD1 || self.scode == MC_EXPLOD2 || self.scode == MC_D_BARREL || self.scode == MC_Q2_BARREL || self.scode == MC_Q3_BARREL)
		{
			self.mcode = self.scode;
			self.think = barrel_regen;
			self.nextthink = time + 1 + 3 * random();
			return;
		}

// to turn a boom box into something or something into a boom box, we need a fake item, hiding the real item with no model | touch
		if (self.scode)
		if (cls == "misc_explobox" || cls == "misc_explobox2" || cls == "d_barrel" || cls == "q2_misc_explobox" || cls == "q3_misc_explobox")
		if (self.scode != MC_EXPLOD1 && self.scode != MC_EXPLOD2 && self.scode != MC_D_BARREL && self.scode != MC_Q2_BARREL && self.scode != MC_Q3_BARREL) f = spawn();

		if (cls != "misc_explobox" && cls != "misc_explobox2" && cls != "d_barrel" && cls != "q2_misc_explobox" && cls != "q3_misc_explobox")
		if (self.scode == MC_EXPLOD1 || self.scode == MC_EXPLOD2 || self.scode == MC_D_BARREL || self.scode == MC_Q2_BARREL || self.scode == MC_Q3_BARREL) f = spawn();

		if (f)
		{
			self.model = null_string;
//			self.touch = SUB_Null;
			self.solid = SOLID_NOT;
			self.takedamage = DAMAGE_NO;
			newmis = self.enemy = f; // so dyn can be set on barrels

			f.wad = "item_call_fake";
			f.ip_orgOrigin = self.ip_orgOrigin;
			f.origin = self.origin;
			self = f;
			self.classname = cls;
		}
// clears for xwep features
		self.style = 0; // so we dont get range weps using melee frames
		self.dodmg = 0; // might give some things extra blast dmg
		self.wait = 0; // RSP_TIME; // damn q3 respawn time rules - hope this doesnt fxk rndize
		self.msgcount = 0; // -888 lock in splash.qc
		self.dmgtime = POW_TIME;
		self.x_items = 0;
		self.pk_currentitem = 0;
		self.weaponframe = 0;
		self.weaponmodel = null_string;

		self.frame = 0;
		self.skin = 0;
		self.noise = null_string; // grab sound items
		self.noise1 = null_string;
		self.noise2 = null_string;
		self.noise3 = null_string;
		self.noise4 = null_string; // respawn sound
	}

	scls = cls;
	if (cls == "weapon_axe") weapon_axe();
	else if (cls == "weapon_shotgun") q100_weapon_shotgun();
	else if (cls == "weapon_supershotgun") q100_weapon_supershotgun();
	else if (cls == "weapon_nailgun") weapon_nailgun();
	else if (cls == "weapon_nailgun_q1") weapon_nailgun_q1();
	else if (cls == "weapon_supernailgun") weapon_supernailgun();
	else if (cls == "weapon_grenadelauncher") q100_weapon_grenadelauncher();
	else if (cls == "weapon_rocketlauncher") q100_weapon_rocketlauncher();
	else if (self.event == "dynamic_item" && cls == "weapon_lightning")
	{
		if (PK) weapon_chainlg();
		else q100_weapon_lightning();
	}
	else if (cls == "weapon_lightning") q100_weapon_lightning();
	else if (cls == "item_shells") { if (rd < 0.5) self.spawnflags = WEAPON_BIG2; item_shells(); } // IDEA: split rd < off to dyn-item only
	else if (cls == "item_spikes") { if (rd < 0.4) self.spawnflags = WEAPON_BIG2; item_spikes(); }
	else if (cls == "item_rockets") { if (rd < 0.2) self.spawnflags = WEAPON_BIG2; item_rockets(); }
	else if (cls == "item_cells") { if (rd < 0.8) self.spawnflags = WEAPON_BIG2; item_cells(); }

	else if (cls == "item_shells_lg") { self.spawnflags = WEAPON_BIG2; item_shells(); scls = "item_shells"; }
	else if (cls == "item_spikes_lg") { self.spawnflags = WEAPON_BIG2; item_spikes(); scls = "item_spikes"; }
	else if (cls == "item_rockets_lg") { self.spawnflags = WEAPON_BIG2; item_rockets(); scls = "item_rockets"; }
	else if (cls == "item_cells_lg") { self.spawnflags = WEAPON_BIG2; item_cells(); scls = "item_cells"; }

	else if (cls == "item_artifact_invulnerability") item_artifact_invulnerability();
	else if (cls == "item_artifact_super_damage") item_artifact_super_damage();
	else if (cls == "item_artifact_envirosuit") item_artifact_envirosuit();
	else if (cls == "item_artifact_invisibility") item_artifact_invisibility();
	else if (cls == "item_armor1") item_armor1();
	else if (cls == "item_armor2") item_armor2();
	else if (cls == "item_armorInv") item_armorInv();
	else if (cls == "item_health_15") { self.spawnflags = H_ROTTEN; q100_item_health(); scls = "item_health";}
	else if (cls == "item_health") q100_item_health();
	else if (cls == "item_health_mega") { self.spawnflags = H_MEGA; q100_item_health(); scls = "item_health"; }

	else if (cls == "item_key1") item_key1();
	else if (cls == "item_key2") item_key2();
// keys special
	else if (cls == "item_key1_0") {self.cnt = 0; item_keyX(10);} // key num * 10 + wolrd num
	else if (cls == "item_key1_1") {self.cnt = 0; item_keyX(11);}
	else if (cls == "item_key1_2") {self.cnt = 0; item_keyX(12);}
	else if (cls == "item_key2_0") {self.cnt = 0; item_keyX(20);}
	else if (cls == "item_key2_1") {self.cnt = 0; item_keyX(21);}
	else if (cls == "item_key2_2") {self.cnt = 0; item_keyX(22);}
// random pack
	else if (cls == "fn_backpack") fn_backpack();

	else if (cls == "misc_explobox")
	{
		misc_explobox();
		return;
	}
	else if (cls == "misc_explobox2")
	{
		misc_explobox2();
		return;
	}

	else if (cls == "item_sigil") { item_sigil(); } // NOTE: things can translate to this
	else if (cls == "item_sigil1") { self.spawnflags = rune_bit_code(MC_SIGIL1, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil2") { self.spawnflags = rune_bit_code(MC_SIGIL2, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil4") { self.spawnflags = rune_bit_code(MC_SIGIL4, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil8") { self.spawnflags = rune_bit_code(MC_SIGIL8, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil64") { self.spawnflags = rune_bit_code(MC_SIGIL64, 0); item_sigil(); scls = "item_sigil"; }

//	else if (cls == "item_") item_();

// painkeep
	else if (cls == "item_painkeep_gwell") item_painkeep_gwell();
	else if (cls == "item_painkeep_turret") item_painkeep_turret();
	else if (cls == "item_painkeep_beartrap") item_painkeep_beartrap();
	else if (cls == "item_painkeep_expshells") item_painkeep_expshells();
	else if (cls == "weapon_chainlg") weapon_chainlg();
	else if (cls == "weapon_pulsenail") weapon_pulsenail();
	else if (cls == "weapon_grapgun") weapon_grapgun();
	else if (cls == "weapon_airfist") weapon_airfist();
	else if (cls == "item_painkeep_can") item_painkeep_can();

	else if (cls == "item_pkplus_ego") item_pkplus_ego();
	else if (cls == "item_pkplus_tomb") item_pkplus_tomb();
	else if (cls == "item_pkplus_actor") item_pkplus_actor();
	else if (cls == "item_pkplus_phone") item_pkplus_phone();

	else if (cls == "pk_crate") pk_crate();
	else if (cls == "pk_cube") pk_cube();
	else if (cls == "morph_cube") morph_cube();
	else if (cls == "archon_nodule") archon_nodule_rnd();

// ctf
	else if (cls == "weapon_hook") weapon_hook();

// hipnotic
	else if (cls == "weapon_mjolnir") weapon_mjolnir();
	else if (cls == "weapon_laser_gun")	weapon_laser_gun();
	else if (cls == "weapon_proximity_gun") weapon_proximity_gun();

	else if (cls == "item_artifact_wetsuit") item_artifact_wetsuit();
	else if (cls == "item_artifact_empathy_shields") item_artifact_empathy_shields();
	else if (cls == "item_hornofconjuring") item_hornofconjuring();
	else if (cls == "trap_spike_mine") { trap_spike_mine(A_MONSTER); self.dmg = 20 + (random() * 20); }

// doom
	else if (cls == "d_weapon_shotgun") d_weapon_shotgun();
	else if (cls == "d_weapon_supershotgun") d_weapon_supershotgun();
	else if (cls == "d_weapon_chaingun") d_weapon_chaingun();
	else if (cls == "d_weapon_rocketlauncher") d_weapon_rocketlauncher();
	else if (cls == "d_weapon_plasma") d_weapon_plasma();
	else if (cls == "d_weapon_bfg") d_weapon_bfg();
	else if (cls == "d_weapon_saw") d_weapon_saw();
	else if (cls == "d_weapon_pistol") d_weapon_pistol();

	else if (cls == "d_art_berserker") d_art_berserker();
	else if (cls == "d_art_invulnerable") d_art_invulnerable();
	else if (cls == "d_art_invisible") d_art_invisible();
	else if (cls == "d_art_radsuit") d_art_radsuit();
	else if (cls == "d_art_soulsphere") d_art_soulsphere();
	else if (cls == "d_art_megasphere") d_art_megasphere();

	else if (cls == "d_item_spiritarmor") d_item_spiritarmor();
	else if (cls == "d_item_armorgreen") d_item_armorgreen();
	else if (cls == "d_item_armorblue") d_item_armorblue();

	else if (cls == "d_item_healthbottle") d_item_healthbottle();
	else if (cls == "d_item_healthstimpak") d_item_healthstimpak();
	else if (cls == "d_item_healthmedkit") d_item_healthmedkit();

	else if (cls == "d_key_redskull") d_key_redskull();
	else if (cls == "d_key_blueskull") d_key_blueskull();
	else if (cls == "d_key_yellowskull") d_key_yellowskull();
	else if (cls == "d_key_redcard") d_key_redcard();
	else if (cls == "d_key_bluecard") d_key_bluecard();
	else if (cls == "d_key_yellowcard") d_key_yellowcard();

	else if (cls == "d_ammo_4shell") d_ammo_4shell();
	else if (cls == "d_ammo_shellbox") d_ammo_shellbox();
	else if (cls == "d_ammo_clip") d_ammo_clip();
	else if (cls == "d_ammo_ammobox") d_ammo_ammobox();
	else if (cls == "d_ammo_1rocket") d_ammo_1rocket();
	else if (cls == "d_ammo_rockbox") d_ammo_rockbox();
	else if (cls == "d_ammo_cellbox") d_ammo_cellbox();
	else if (cls == "d_ammo_cellpack") d_ammo_cellpack();

	else if (cls == "d_item_pack") d_item_pack();
	else if (cls == "d_item_nightvis") d_item_nightvis();
	else if (cls == "d_item_automap") d_item_automap();

	else if (cls == "d_barrel")
	{
		d_barrel();
		return;
	}

// wolf
	else if (cls == "w_weapon_knife") w_weapon_knife();
	else if (cls == "w_weapon_pistol") w_weapon_pistol();
	else if (cls == "w_weapon_machinegun") w_weapon_machinegun();
	else if (cls == "w_weapon_chaingun") w_weapon_chaingun();
	else if (cls == "w_weapon_mortar") w_weapon_mortar();
	else if (cls == "w_weapon_flamer") w_weapon_flamer();

	else if (cls == "w_ammo_gas") w_ammo_gas();
	else if (cls == "w_ammo_clip") w_ammo_clip();
	else if (cls == "w_ammo_rock") w_ammo_rock();
	else if (cls == "w_item_pack") w_item_pack();

	else if (cls == "w_art_facesphere") w_art_facesphere();
	else if (cls == "w_heal_medkit") w_heal_medkit();
	else if (cls == "w_heal_food") w_heal_food();
	else if (cls == "w_heal_dogfood") w_heal_dogfood();

	else if (cls == "w_key_g") w_key_g();
	else if (cls == "w_key_b") w_key_b();

	else if (cls == "w_item_cross") w_item_cross();
	else if (cls == "w_item_chalice") w_item_chalice();
	else if (cls == "w_item_chest") w_item_chest();
	else if (cls == "w_item_crown") w_item_crown();


// q2
	else if (cls == "q2_weapon_blaster") q2_weapon_blaster();
	else if (cls == "q2_weapon_shotgun") q2_weapon_shotgun();
	else if (cls == "q2_weapon_supershotgun") q2_weapon_supershotgun();
	else if (cls == "q2_weapon_machinegun") q2_weapon_machinegun();
	else if (cls == "weapon_chaingun") weapon_chaingun();
	else if (cls == "q2_weapon_grenadelauncher") q2_weapon_grenadelauncher();
	else if (cls == "q2_weapon_rocketlauncher") q2_weapon_rocketlauncher();
	else if (cls == "weapon_hyperblaster") weapon_hyperblaster();
	else if (cls == "q2_weapon_railgun") q2_weapon_railgun();
	else if (cls == "q2_weapon_bfg") q2_weapon_bfg();
	else if (cls == "q2_weapon_grapple") q2_weapon_grapple();

	else if (cls == "q2_item_quad") q2_item_quad();
	else if (cls == "item_invulnerability") item_invulnerability();
	else if (cls == "q2_item_enviro") q2_item_enviro();
	else if (cls == "item_silencer") item_silencer();

	else if (cls == "q2_item_armor_shard") q2_item_armor_shard();
	else if (cls == "item_armor_jacket") item_armor_jacket();
	else if (cls == "q2_item_armor_combat") q2_item_armor_combat();
	else if (cls == "q2_item_armor_body") q2_item_armor_body();
	else if (cls == "item_power_shield") item_power_shield();
	else if (cls == "item_power_screen") item_power_screen();

	else if (cls == "q2_item_health_small") q2_item_health_small();
	else if (cls == "q2_item_health") q2_item_health();
	else if (cls == "q2_item_health_large") q2_item_health_large();
	else if (cls == "q2_item_health_mega") q2_item_health_mega();

	else if (cls == "key_red_key") key_red_key();
	else if (cls == "key_blue_key") key_blue_key();
	else if (cls == "key_commander_head") key_commander_head();
	else if (cls == "key_airstrike_target") key_airstrike_target();
	else if (cls == "key_data_cd") key_data_cd();
	else if (cls == "key_data_spinner") key_data_spinner();
	else if (cls == "key_pass") key_pass();
	else if (cls == "key_power_cube") key_power_cube();
	else if (cls == "key_pyramid") key_pyramid();

	else if (cls == "q2_ctf_haste" && !RUNES) q2_ctf_haste(); // note: dont really know what these are
	else if (cls == "q2_ctf_regen" && !RUNES) q2_ctf_regen();
	else if (cls == "q2_ctf_resist" && !RUNES) q2_ctf_resist();
	else if (cls == "q2_ctf_stren" && !RUNES) q2_ctf_stren();

	else if (cls == "q2_ammo_shells") q2_ammo_shells();
	else if (cls == "q2_ammo_bullets") q2_ammo_bullets();
	else if (cls == "q2_ammo_rockets") q2_ammo_rockets();
	else if (cls == "q2_ammo_grenades") q2_ammo_grenades();
	else if (cls == "q2_ammo_cells") q2_ammo_cells();
	else if (cls == "q2_ammo_slugs") q2_ammo_slugs();

	else if (cls == "item_pack") item_pack();
	else if (cls == "item_adrenaline") item_adrenaline();
	else if (cls == "item_bandolier") item_bandolier();
	else if (cls == "item_breather") item_breather();

	else if (cls == "q2_misc_explobox")
	{
		q2_misc_explobox();
		return;
	}
/*
	else if (cls == "q2_ctf_resist") q2_ctf_resist();
	else if (cls == "q2_ctf_regen") q2_ctf_regen();
	else if (cls == "q2_ctf_stren") q2_ctf_stren();
	else if (cls == "q2_ctf_haste") q2_ctf_haste();
*/

	else if (cls == "q2_ctf_resist") { self.spawnflags = rune_bit_code(MC_Q2_TECH_RES, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "q2_ctf_regen") { self.spawnflags = rune_bit_code(MC_Q2_TECH_DOC, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "q2_ctf_stren") { self.spawnflags = rune_bit_code(MC_Q2_TECH_AMP, 0); item_sigil(); scls = "item_sigil"; }
	else if (cls == "q2_ctf_haste") { self.spawnflags = rune_bit_code(MC_Q2_TECH_TM, 0); item_sigil(); scls = "item_sigil"; }

// q3
	else if (cls == "weapon_gauntlet") weapon_gauntlet();
	else if (cls == "weapon_grapplinghook") weapon_grapplinghook();
	else if (cls == "q3_weapon_machinegun") q3_weapon_machinegun();
	else if (cls == "q3_weapon_shotgun") q3_weapon_shotgun();
	else if (cls == "q3_weapon_grenadelauncher") q3_weapon_grenadelauncher();
	else if (cls == "q3_weapon_rocketlauncher") q3_weapon_rocketlauncher();
	else if (cls == "weapon_plasmagun") weapon_plasmagun();
	else if (cls == "q3_weapon_lightning") q3_weapon_lightning();
	else if (cls == "q3_weapon_railgun") q3_weapon_railgun();
	else if (cls == "q3_weapon_bfg") q3_weapon_bfg();

	else if (cls == "q3_item_quad") q3_item_quad();
	else if (cls == "item_regen") item_regen();
	else if (cls == "q3_item_enviro") q3_item_enviro();
	else if (cls == "item_invis") item_invis();
	else if (cls == "item_haste") item_haste();
	else if (cls == "item_flight") item_flight();

	else if (cls == "q3_item_armor_shard") q3_item_armor_shard();
	else if (cls == "q3_item_armor_combat") q3_item_armor_combat();
	else if (cls == "q3_item_armor_body") q3_item_armor_body();

	else if (cls == "q3_item_health_small") q3_item_health_small();
	else if (cls == "q3_item_health") q3_item_health();
	else if (cls == "q3_item_health_large") q3_item_health_large();
	else if (cls == "q3_item_health_mega") q3_item_health_mega();

	else if (cls == "q3_ammo_shells") q3_ammo_shells();
	else if (cls == "q3_ammo_bullets") q3_ammo_bullets();
	else if (cls == "q3_ammo_rockets") q3_ammo_rockets();
	else if (cls == "q3_ammo_grenades") q3_ammo_grenades();
	else if (cls == "q3_ammo_cells") q3_ammo_cells();
	else if (cls == "q3_ammo_slugs") q3_ammo_slugs();
	else if (cls == "ammo_lightning") ammo_lightning();
	else if (cls == "ammo_bfg") ammo_bfg();

	else if (cls == "holdable_medkit") holdable_medkit();
	else if (cls == "holdable_teleporter") holdable_teleporter();

	else if (cls == "q3_misc_explobox")
	{
		q3_misc_explobox();
		return;
	}

// chaos
	else if (cls == "c_weapon_reggun") c_weapon_reggun();
	else if (cls == "c_weapon_deepsleep") c_weapon_deepsleep();
	else if (cls == "c_weapon_tallball") c_weapon_tallball();
	else if (cls == "weapon_quantum") weapon_quantum();
	else if (cls == "weapon_flamer") weapon_flamer();
	else if (cls == "ammo_gas") ammo_gas();
	else if (cls == "ammo_gas_lg") ammo_gas_lg();

// monsters - random spawns
	else if (cls == "monster_army") monster_army(A_MONSTER);
	else if (cls == "monster_boss") monster_boss(A_MONSTER);
	else if (cls == "monster_demon1") monster_demon1(A_MONSTER);
	else if (cls == "monster_dog") monster_dog(A_MONSTER);
	else if (cls == "monster_enforcer") monster_enforcer(A_MONSTER);
	else if (cls == "monster_fish") monster_fish(A_MONSTER);
	else if (cls == "monster_fish") monster_fish(A_MONSTER);
	else if (cls == "monster_hell_knight") monster_hell_knight(A_MONSTER);
	else if (cls == "monster_knight") monster_knight(A_MONSTER);
	else if (cls == "monster_ogre") monster_ogre(A_MONSTER);
	else if (cls == "monster_oldone") monster_oldone(A_MONSTER);
	else if (cls == "monster_shalrath") monster_shalrath(A_MONSTER);
	else if (cls == "monster_supervore") monster_supervore(A_MONSTER);
	else if (cls == "monster_shambler") monster_shambler(A_MONSTER);
//	else if (cls == "monster_tarbaby") monster_tarbaby(A_MONSTER);
//	else if (cls == "monster_tarbaby_rnd") {self.spawnflags = TB_RANDOM; monster_tarbaby(A_MONSTER); }
// just make randomly spawned spawns random select
	else if (cls == "monster_tarbaby") {self.spawnflags = TB_RANDOM; monster_tarbaby(A_MONSTER); }
	else if (cls == "monster_wizard") monster_wizard(A_MONSTER);
	else if (cls == "monster_zombie") monster_zombie(A_MONSTER);
	else if (cls == "monster_scourge") monster_scourge(A_MONSTER);
	else if (cls == "monster_gremlin") monster_gremlin(A_MONSTER);
	else if (cls == "monster_vomit") monster_vomit(A_MONSTER);

// monster set II
	else if (cls == "monster_blarg") monster_blarg(A_MONSTER);
	else if (cls == "monster_raptor") monster_raptor(A_MONSTER);
	else if (cls == "monster_spider") monster_spider(A_MONSTER);
	else if (cls == "monster_manga") monster_manga(A_MONSTER);
	else if (cls == "monster_bossman") monster_bossman(A_MONSTER);
	else if (cls == "monster_clinger") monster_clinger(A_MONSTER);
	else if (cls == "monster_young") monster_young(A_MONSTER);
	else if (cls == "monster_lavabomb") monster_lavabomb(A_MONSTER);
	else if (cls == "monster_heximp") monster_heximp(A_MONSTER);

	else // fail - not valid
	{
		if (f) remove(f); // IDEA: restore what was hidden?
		return;
	}
	self.mdl = self.model;
	self.classname = scls;

	if (self.event == "dyn_monster" || self.class_select == "class_monster")
	{
		if (self.stack1 != "no_monster_wakey")
		chaos_spawn(0, 0, 0, 0,  v0, v0, v0, v0, v0, "monster_wakey", null_string, SUB_Null, 2 + random(), random_monster_wakey, SUB_Null, self, world);
		self.pausetime = 0;

		total_monsters = t_monsters  + 1;
  	
		WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
		WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
		WriteLong (MSG_BROADCAST, total_monsters);

		return;		
	}

	self.flags = FL_ITEM;
	self.movetype = MOVETYPE_TOSS;
	if (self.event != "dynamic_item") // dont do these for dyn items
	{
		if (!NO_PI) pk_placeitem();
		{
			self.think = SUB_regen; // dont go thru place_item - use regen method
			self.nextthink = time + 1 + 3 * random(); // spread em out
			self.model = string_null;
		}
	}
	else
		pk_ditems = pk_ditems + 1;
	self.solid = SOLID_NOT;
	NO_PI = 0;
//	bot_item_linx(self); // *bot - item tie in - needs checked for use here -- ??? does anything need done here?
};

// save self, item call e

void(entity e, string cl) item_call_save =
{
	local entity sv;

	sv = self;
	self = e;
	item_call(cl);
	self = sv;
}


// this section implements admin override of map items, remove (& replace), cycle & inf ammo

void() item_down =
{
	self.model = null_string;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
};

void(string cls, string rep, string am, string ram) item_repm =
{
	local entity e;
	local string pam;
	local float f;

	if (!find(world,wad,rep))
	{
		e = find(world,classname,rep);
		if (!e) return;
		while (e)
		{
			if (e.wad == null_string) e.wad = e.classname;
			e = find(e,classname,rep);
		}
	}
	pam = am;
	if (pk_itemovr & CON_INF) pam = "rem"; // inf ammo
	if (pk_itemovr & WEP_PKI)
	{
		f = WEP_STOP * ceil(2 * random()) * ceil(2 * random()) * ceil(2 * random());
		if (pk_itemovr & CON_INF) pam = "pki"; // inf ammo - pk item subs
	}
	e = find(world,wad,rep);
	while (e)
	{
		if (cls == "rest")
		{
			item_call_save(e, rep);
			if (ram != null_string)
			{
				if (pam == "rem" || pam == "pki") item_repm(pam, ram, null_string, null_string);
				else item_repm("rest", ram, null_string, null_string);
			}
		}
		else if (cls == null_string || cls == "pki" || cls == "rem")
		{
			if ((pk_itemovr & WEP_PKI) && PK && cls == "pki")
			{
				f = f * 2;
				if (f > WEP_CPNB) f = WEP_GWELL;
				item_call_save(e, ammo_by_bit(f));
			}
			else
				item_down();
			if (ram != null_string)
			if (ram != pam) item_repm(pam, ram, null_string, null_string);
		}
		else
		{
			item_call_save(e, cls);
			if (ram != null_string)
			if (ram != pam) item_repm(pam, ram, null_string, null_string);
		}
		e = find(e,wad,rep);
	}
};

// main loop handles admin item override

void() item_loop =
{
	local float f, e, pko, pks, sf, lvl, lvls, msk;
	local string cl;

	pks = 0;
	lvls = f = 1;
	e = lvl = WEP_STOP;

	while (f != CON_STOP)
	{
		pko = pk_itemovr;
		if (pko & CON_CYC)
		{
			sf = 2;
			msk = (lvl - 1) - (lvls - 1);
			f = self.cnt = self.count & msk;
			if (!f) f = self.cnt = lvls;
			else f = self.cnt = self.cnt * 2;
			if (f == lvl) f = self.cnt = lvls;
			while (sf > 0 && !(f & pk_itemovr))
			{
				f = self.cnt = self.cnt * 2;
				if (f == lvl) // loop once
				{
					f = self.cnt = lvls;
					sf = sf - 1;
				}
			}
			if (sf < 1) f = lvl;
			else
			{
				pko = f | CON_ONLY | CON_CYC;// | pko - (pko & (CON_NONE | CON_SUBS));
				pks = pks | f;
			}
		}
		else if (pko & CON_SUBS) // find a valid substitute code
		{
			e = floor(e / 2);
			if (e < lvls) e = lvl / 2;
			sf = 7;
			while ((e & pko) && e >= lvls && sf > 0)
			{
				e = floor(e / 2);
				sf = sf - 1;
			}
			if (e < lvls || sf < 1) pko = pko - (pko & CON_SUBS); // cant sub if no sub item - can this happen?
		}

	if (f != lvl)
	{
		if (! (pko & CON_RUN))
		{
			item_repm("rest", item_by_bit(f), null_string, ammo_by_bit(f)); // restore
//			return;
		}
		else if (f & pko) // bit active
		{
			if (pko & CON_ONLY)
			{
				for (e = lvls;e < lvl; e = e * 2)
				{
					cl = item_by_bit(f);
//					if (e != f)//{
					item_repm(cl, item_by_bit(e), ammo_by_bit(f), ammo_by_bit(e));

				}
			}
			else if (pko & CON_NONE)
			{
				cl = item_by_bit(e);
			if (pko & CON_SUBS) item_repm(cl, item_by_bit(f), ammo_by_bit(e), ammo_by_bit(f));
				else item_repm(null_string, item_by_bit(f), null_string, ammo_by_bit(f));
			}
			else if (pko & CON_INF) { bprint("repm: restore on rest - con_inf\n");

				item_repm("rest", item_by_bit(f), null_string, ammo_by_bit(f)); }
		}
		if (pko & CON_CYC) f = lvl;
		else f = f * 2;
	}
		if (f == lvl)
		{
//			if (lvl < CON_STOP)
//			{
//				e = lvl = CON_STOP;
//				f = lvls = ART_QUAD;
//			}

			if (lvl < ART_STOP)
			{
				e = lvl = ART_STOP;
				f = lvls = ART_QUAD;
			}
			else if (lvl < ARM_STOP)
			{
				e = lvl = ARM_STOP;
				f = lvls = ARM_GRN;
			}
			else if (lvl < HEAL_STOP)
			{
				e = lvl = HEAL_STOP;
				f = lvls = HEAL_15;
			}
		}
	}
	if (pk_itemovr & CON_CYC) // next item cycle
	{
		self.nextthink = time + CYC_TIME + crandom() * CYC_TIME;
		self.count = pks; // next cycle starts at these items
	}
	else
		remove(self);
};

// fn(ammo_con) - handle admin infinite flag, runes, chaos, etc

// cn - ammo count needing approval or weap id for "wpck" op mode
// e - gun carrier tested (player / bot)
// op - for load check, "wpck"

// returns -

// null_string in op
// 	f - return ammo count to use up
//		0 - return for inf ammo weapon or use no ammo wep

// wpck mode
//		0 - check ammo
//		1 - dont check ammo

float(float cn, entity e, string op) ammo_con =
{
	local float f;
	local entity tr;

	f = cn;

	if (op == null_string) // operation not specced - assume 0 cn if inf or ...
	{
		if (e.weapon & e.builtin) // ins never use ammo
			return(0);

		if (pk_itemovr & CON_INF)
		{
		if (e.weapon == IT_AXE && e.pk_currentitem == PK_IT_CLIGHT)
		if (pk_itemovr & WEP_THUNDER) return(0);

		if (e.weapon == IT_LIGHTNING)
		if (pk_itemovr & WEP_THUNDER) return(0);

		if (e.weapon == IT_ROCKET_LAUNCHER)
		if (pk_itemovr & WEP_ROCKET) return(0);

		if (e.weapon == IT_GRENADE_LAUNCHER)
		if (pk_itemovr & WEP_GREN) return(0);

		if (e.weapon == IT_SUPER_NAILGUN)
		if (pk_itemovr & WEP_PERF) return(0);

		if (e.weapon == IT_NAILGUN)
		if (pk_itemovr & WEP_NAILGUN) return(0);

		if (e.weapon == IT_SUPER_SHOTGUN)
		if (pk_itemovr & WEP_SSHOT) return(0);

		if (e.weapon == IT_MJOLNIR) // Cataboligne - 2.14.11 - hipnotic support special wep
		if (pk_itemovr & WEP_THUNDER) return(0);
		}
	}
	else if (op == "wpck") // wep check - allow auto sw to inf ammo wep
	{
		f = 0;
		if (cn & e.builtin) return(1); // can always select morph builtins
	
		if (cn == IT_MJOLNIR)
		{
			if (e) tr = e.vwepent;
			while (tr)
			{
				if (tr.mdl == "progs/vw_mjolnir.mdl") return(1); // Cataboligne - 2.13.11 - hipnotic support special wep
				tr = tr.vwepent;
			}
		}

		if (pk_itemovr & CON_INF)
		{
			if (cn == PK_IT_CLIGHT)
			if (pk_itemovr & WEP_THUNDER) return(1);

			if (cn == IT_EXTRA_WEAPON)
			if (pk_itemovr & WEP_THUNDER) return(1);

			if (cn == IT_LIGHTNING)
			if (pk_itemovr & WEP_THUNDER) return(1);

			if (cn == IT_ROCKET_LAUNCHER)
			if (pk_itemovr & WEP_ROCKET) return(1);

			if (cn == IT_GRENADE_LAUNCHER)
			if (pk_itemovr & WEP_GREN) return(1);

			if (cn == IT_SUPER_NAILGUN)
			if (pk_itemovr & WEP_PERF) return(1);

			if (cn == IT_NAILGUN)
			if (pk_itemovr & WEP_NAILGUN) return(1);

			if (cn == IT_SUPER_SHOTGUN)
			if (pk_itemovr & WEP_SSHOT) return(1);
		}

		if(e.eweapon.noise == "q3_snd/holdable.wav") return(1);
	}

	return(f);
};

// this section makes dynamic items by admin or map fn

// fn(dyn_spawn) - create an item
// fn(dyn_rem) - remove a dynamic item after a timeout
// fn(dyn_rndloc) - get a random location to spawn an item dynamically

// really should be client side coding

void() remove_fade =
{
	self.touch = SUB_Null;

	if (!self.alpha) self.alpha = 1.03; // make sure the fade doesnt hit 0 and fire this again

	if (self.solid)
	if (self.alpha < 0.6)
		self.solid = SOLID_NOT;

	self.think = remove_fade;

	self.alpha = self.alpha - 0.05;
	if (self.alpha < 0.05) remove(self);
	else self.nextthink = time + 0.15;
};

// note: this has very few qualifications for a selected ent - not anymore - protected by hash code

// kept for the old style remove on cubes and anything with a think

void() dyn_rem =
{
	if (self.enemy)
	{
		if (self.enemy.button13 == -666) // relocate special - like god particle
		{
			if (!self.wait) self.wait = PK_CUBE_TIME + random() * 66;
			self.nextthink = time + self.wait + random() * 6;
			self.wait = self.wait - random() * 6; // relocates faster every time
			if (self.wait < 10) self.wait = 15 + random() * 30; // till this

			newmis = dyn_rndloc();
			if (!newmis) newmis= findradius(world.origin, 256000);
			if (!newmis) return; // nothing found!
			self.dest = stdv_rndloc(newmis.origin, 50, 124);
			setorigin(self.enemy, self.dest + '0 0 2');
			return;
		}
		else
		if (self.button13 == self.enemy.button13)
		{
			if (self.wait) // new ops - set sub rem & exit
			{
				if (self.enemy.model != null_string)
					self.enemy.think = remove_fade;
				else
					self.enemy.think = SUB_Remove;
				self.enemy.nextthink = time + self.wait;
			}
			else // old ops
			{
				if (self.enemy.wad == "pk_cube" || self.enemy.wad == "morph_cube") // dont just remove an active cube
				if (self.enemy.owner)
				{
					self.nextthink = time + (PK_CUBE_TIME + MORPH_CUBE_TIME) / 4;
					return;
				}
				if (self.enemy.model != null_string) // not touched yet
				{
					self.enemy.think = remove_fade; //SUB_Remove;
					self.enemy.nextthink = time + 0.1;
				}
				else
					remove(self.enemy);
	//			pk_ditems = pk_ditems - 1; // this is really meaningless - and its done in item_call
			}
		}
		else
		{
			if ((MONSTER_TRANSPARENT) && (self.enemy.class_select == "class_monster")) // NOTE: these might have issues!
			{
				self.enemy.alpha = 0.6 + (random() * 0.42);
				self.enemy.netname = "I might have issues!"; // TEST - remove
			}
			else
			if (WARNING)
			{
				bprint(" *** WARNING: dynamic remove hash fail: ");
				bprint(item_ident(self.enemy));
				bprint(" - supposed 2B: ");
				bprint(self.target1);
				bprint(" - ");
				bprint(self.netname);
				bprint(" - hash: ");
				bprint(ftos(self.enemy.button13));
				bprint(" - dr hash: ");
				bprint(ftos(self.button13));
				bprint("\n");
			}
		}
	}
	remove(self);
}

// setup an item for removal

// e - remove this ent
// tm - time to live
// rmv - alternate remve fn - for any ent that has think for something

//float REMOVE_DV = 30; // some deviation to spread things out

float DYN_REM_TIME = 6; // 6 secs then set sub_remove

float system_hash;

void(entity e, float tm, void() rmv) dyn_remove =
{
	local entity f;
	local float dv;

	if (!system_hash) system_hash = 10000 + rint(random() * 3000);

	f = spawn();
	f.classname = "dyn_removal";
	f.think = dyn_rem;
	f.nextthink = time + DYN_REM_TIME; // 6 secs

	f.netname = e.netname; // in case of hash fail
	f.target1 = e.classname;
	f.enemy = e;

	f.button13 = e.button13 = system_hash;
	system_hash = system_hash + 1 + rint(random() * 5);

	dv = REMOVE_DV;

	if (tm)
	if (dv > tm) dv = tm * 0.2;

	if (tm)
		f.wait = tm + crandom() * dv;
	else if (e.wad == "morph_cube")
		f.wait = MORPH_CUBE_TIME + crandom() * MORPH_CUBE_DV;
	else if (e.wad == "pk_cube")
		f.wait = PK_CUBE_TIME + crandom() * PK_CUBE_DV;
	else
	f.wait = PK_DYNTO + crandom() * 55;

	if (f.wait < 1) {f.wait = 5 + random() * 10; // why ?


bprint(" *** dyn_remove f.wait failed\n");
}


	if (rmv != SUB_Null) // old style or something else = direct think
	{
		f.think = rmv;
		f.nextthink = time + f.wait;
		f.wait = 0;
	}
};

entity rseu; // random spawn ent origin used

// returns a "near" entity to use its origin - this is really the only safe way to pick a random location within a map

entity() dyn_rndloc =
{
	local float ri, sf;
	local entity e, sv;

	ri = sf = 0;
	sv = e = find(world,classname,"player");
	while (e)
	{
		sv = e;
		e = find(e,classname,"player");
	}
	e = findradius(sv.origin, PK_DYNRAD);
	if (!e) return(world); // nothing found!
	sv = e;
	while (e.chain) // count stuff for a random location selection from all these items found in range
	{
		if (!e.chain) e = world;
		else if (e.chain.flags & FL_ITEM) { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "info_player_deathmatch") { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "info_teleport_destination") { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "waypoint") { ri = ri + 1; e = e.chain; } // Cataboligne - 9.19.11 - added bot waypoints - ton of these, might skew stats, and dynamics will nearly always be along bot paths
		else if (e.chain.classname == "path_corner") { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "hub_custom") { ri = ri + 1; e = e.chain; }
//		else if (e.chain.classname == null_string) { ri = ri + 1; e = e.chain; }
		else e.chain = e.chain.chain; // skipper!
	}
	e = sv;
	sf = ri * random(); // pick a random ent from list - idea: prioritize away from weps?
	while (sf > 0 && e)
	{
		if (rseu == e && ri > 2) { sf = sf - 1; e = e.chain; } // skipper!
		if (e) sv = e;
		e = e.chain;
		sf = sf - 1;
	}
	rseu = sv;
	return(sv);
};

// some deviation around a random loc, rule out solid areas

// pv1 - org
// d1 - min radius away
// r1 - dist to rnd past min

vector(vector pv1, float d1, float r1) stdv_rndloc =
{
	local vector v2; // NOT v1 !!!
	local float sf, pco, f, k;

	v2 = pv1;
	sf = 100; // NOT gsf
	pco = CONTENT_SOLID;

	while (sf > 0 && pco == CONTENT_SOLID)
	{
		f = crandom() * r1;
		k = d1;
		if (f < 0) k = 0 - d1;
		v2_x = pv1_x + k + f;
		f = crandom() * r1;
		k = d1;
		if (f < 0) k = 0 - d1;
		v2_y = pv1_y + k + f;
		pco = pointcontents(v2);
		sf = sf - 1;
		if (sf < 1) v2 = pv1;
	}
	return(v2);
};

void() dyn_spawn =
{
	local entity sv;

// get a random origin
  if (self.origin == v0)
  {
		sv = dyn_rndloc();
		if (!sv) sv = findradius(world.origin, 256000);
		if (!sv) return; // nothing found!
		setorigin(self, sv.origin + ' 0 0 16');
  }
  else
  {
		sv = findradius(self.origin, PK_DYNRAD);
  }
// give players notice
  if (DYN_SHOW)
  {
		if (self.wad == "pk_cube") bprint("\n"); // space cubes so the notes are easier to see
		else if (self.wad == "morph_cube") bprint("\n");
		else if (self.wad == "pk_crate") bprint("\n");
		bprint("*** Dynamic item spawned: ");
		bprint(self.wad);
		if (sv)
		{
			bprint(" near: ");
			bprint(sv.classname);
		}
		else
			bprint(" on the map");
		if (self.wad == "pk_cube") bprint("\n");
		else if (self.wad == "morph_cube") bprint("\n");
		else if (self.wad == "pk_crate") bprint("\n");
		bprint("\n");

		drop_inv_check(); // check for anyone in drop inventory menu - residplay menu
	}

	if (self.wad != "pk_crate") // pk_crates get removed by ops code - because they can leave an open box
	{
		if (self.wad == "morph_cube" || self.wad == "pk_cube") // cubes think & need old op
			dyn_remove(self, 0, dyn_rem); // changes how remove happens, see this fn & dyn_rem ops - because of owners on cubes
		else
			dyn_remove(self, 0, SUB_Null); // uses dyn rem new opts, where wait is a t/o on the remove
	}

	item_call(self.wad); // make item
};

// think to handle dynamic item spawns if enabled by admin - pk_items only

void() dyn_item =
{
	float cd, f, b;
	entity e;

	if (!pk_flags & (PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR)) // dynamic items - this sort turned off - pki
	{
		remove(self);
		return;
	}

	if (self.classname != "dyn_spawner")
	{
		self.classname = "dyn_spawner";
		self.nextthink = time + 40 + 20 * crandom(); // PIC_TO
		self.count = 4 + 4 * random();
		if (DYN_FORCE || DYN_ARTFR_ONLY) self.count = pk_ditems + DYN_FORCE_CNT;
		if (!DYN_FORCE && !DYN_ARTFR && pk_ditems > 6)
		{	
			if (WARNING)
				bprint("*** Warning - dynamic items: no force flags and pk items > 6, dyn_spawner going away\n");
			remove(self);
		}
		else
		{
			if ((pk_flags & PK_DYNAMIC) || DYN_OVR)
			if (DYN_FORCE || DYN_ARTFR_ONLY)
			{
				bprint("*** Warning - dynamic items: force flags overlap normal flags, items may not spawn!\n");
				return;
			}
			bprint("***   Dynamic items will spawn on this map - keep an eye out\n");
		}
	}
	else
	{
	if (pk_ditems < 0) pk_ditems = 0;
	if (pk_ditems < self.count)
	 {
		cd = 1 + 2 * random();
		while (cd > 0.2)
		{
			e = spawn();
			e.origin = v0; // use random locator
			if (e)
			{
				e.think = dyn_spawn;
				e.nextthink = 3 + 12 * random(); // time spread
				e.event = "dynamic_item";
				b = 7;
				f = 6.4; // painkeep items bits (7 - 13) = 128 - 8192
				if (PK_ART && (DYN_ART || DYN_ARTFR)) f = 10.4; // add in (14 - 17) 16384 - 131072
				if (DYN_ARTFR_ONLY) // only (14 - 17) 16384 - 131072
				{
					b = 14;
					f = 3.4;
				}
				e.cnt = AdminBitFlag(floor(b + f * random())); // item to spawn
				e.wad = ammo_by_bit(e.cnt); // classname to spawn
				if (random() < 0.027)  // small chance of clg + ammo
				{
					e.wad = "weapon_lightning";
					e = world;
					e = spawn();
					if (e)
					{
						e.think = dyn_spawn;
						e.nextthink = 1 + 4 * random();
						e.event = "dynamic_item";
						e.wad = "item_cells";
					}
					e = spawn();
					if (e)
					{
						e.think = dyn_spawn;
						e.nextthink = 1 + 4 * random();
						e.event = "dynamic_item";
						e.wad = "item_cells";
					}
				}
//				pk_ditems = pk_ditems + 1; // done in item_call
			}
			cd = cd - 1;
		}
	 }
	self.nextthink = time + 40 + 20 * crandom();
	}
};

// implemented for cvar control on server

void() item_control_menu =
{
	local float f, k;
	local string m;
	local entity e;

	k = cvar("it_tog_mcode") - MC_SHOTGUN;
	if (k == -2) k = 7; // pki menu code = 99 or 2 less than MC_SHOTGUN (1 less than axe)
	else if (k < 1 || k > 16) k = cvar("it_tog_itemmenu");
	else if (k  > 6) k = k + 1;

	if (k > 0)
	{
		if (k > 31)
		{
bprint(" *** Specials:\n");
bprint(" - last q1 item +1: ");
bprint(ftos(MC_Q1));
bprint("\n");
bprint(" - q1 rnditems cnt: ");
bprint(ftos(MC_RNDITM));
bprint("\n");
bprint(" - q1 no runes rnditems cnt: ");
bprint(ftos(MC_NR_RNDITM));
bprint("\n");
bprint(" - last pk item: +1 ");
bprint(ftos(MC_PK));
bprint("\n");
bprint(" - pk rnditems cnt: ");
bprint(ftos(MC_PK_RNDITM));
bprint("\n");
bprint(" - pk+ rnditems cnt: ");
bprint(ftos(MC_PKP_RNDITM));
bprint("\n");
bprint(" - tot base rnditems cnt: ");
bprint(ftos(MC_T_RNDITM));
bprint("\n");
bprint("\n");
if (ULOKD)
{
	bprint(" - last doom item +1: ");
	bprint(ftos(MC_DOOM));
	bprint("\n");
	bprint(" - doom items tot: ");
	bprint(ftos(MC_D_RNDITM));
	bprint("\n");
}
if (ULOKW)
{
	bprint(" - last wolf item +1: ");
	bprint(ftos(MC_WOLF));
	bprint("\n");
	bprint(" - wolf items tot: ");
	bprint(ftos(MC_W_RNDITM));
	bprint("\n");
}
if (ULOK2)
{
	bprint(" - last q2 item +1: ");
	bprint(ftos(MC_Q2));
	bprint("\n");
	bprint(" - q2 items tot: ");
	bprint(ftos(MC_Q2_RNDITM));
	bprint("\n");
}
if (ULOK3)
{
	bprint(" - last q3 item +1: ");
	bprint(ftos(MC_Q3));
	bprint("\n");
	bprint(" - q3 items tot: ");
	bprint(ftos(MC_Q3_RNDITM));
	bprint("\n");
	bprint("\n");
}
bprint(" - total items tot: ");
bprint(ftos(MC_TOT));
bprint("\n");
bprint("\n");

			bprint(" *** Use map code (");
			bprint(ftos(MC_SHOTGUN - 2));
			bprint(") for 07 painkeep items with pk_tog_mcode\n\n");
			m = build_itemmenu();
			bprint(m);
bprint("\n");
		}
		else if (k ==  31)
		{
			e = spawn();
			if (e)
			{
				e.think = item_loop;
				e.nextthink = time + 0.1;
			}
		}
		else if (k == 30)
			Admin_itembits();
		else if (k == 29)
		{
			pk_itemovr = 0;
			admin_sv_cfg();
		}
		else if (k < 23)
		{
				f = AdminBitFlag(k - 1);
				if (pk_itemovr & f)
					pk_itemovr = pk_itemovr - (pk_itemovr & f);
				else
					pk_itemovr = pk_itemovr | f;
				if (pk_itemovr != pk_itemovr_ck)
				{
					if (pk_itemovr & f)
						m = "\nBit toggled on for selected item: ";
					else
						m = "\nBit toggled off for selected item: ";
					bprint (m);
					bprint(ftos(f));
					bprint("\n");
				}
				admin_sv_cfg();
		}
	}

	cvar_set("it_tog_mcode", "0");
	cvar_set("it_tog_itemmenu", "0");
};


// fn(func_dynitem) - map load dynamic item ent maker

// wait - time between spawns in secs
// delay - random deviation, neg (-) number uses crandom, randomize spawn time of item
// lip - range from origin to spawn items in quake units
// spawnflags & 1 - uses func_dyn location, if 0, randomize
// spawnflags & 2 - spawn random ammo for weps loaded by fn - uses dyn_spawn locator code

// NOTE: these use the admin menu bit values, not mapcode bits
//       item is randomly selected from bits available

// dest1 - weapon & q item admin bit codes to select from
// dest2 - ammo & pk item admin bit codes to select from

// pk_dyn_func_stop - stop func_dynitem processing

// CHECK: what happens here when pk_art gets turned off on a live server

void() func_dynitem =
{
	local float rv, sb;
	local entity e;

// clear any of this
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.model = null_string;

// loop
	if (self.delay < 0) rv = crandom() * fabs(self.delay);
	else rv = random() * self.delay;

	self.think = func_dynitem;
	self.nextthink = time + self.wait + rv;

// stop item spawn when set true - leaves func_ ents on map
	if (cvar("pk_dyn_func_stop")) return;

// dont make dyn while place item control handles map items
	if (time < (PIC_TO + 2)) return;

	self.dest1_x = self.dest1_x - (self.dest1_x & WEP_PKI); // because dyn_spawn cant make this - pk items are made by bits in dest2

// spawn an item
	e = spawn();
	if (e)
	{
		e.think = dyn_spawn;
		e.nextthink = 1 + self.delay * random(); // time spread -- IDEA: get rid of neg number
		e.event = "dynamic_item";

		if (self.spawnflags & 1)
			setorigin(e, v0);
		else
		{
			v1 = stdv_rndloc(self.origin, 0, self.lip);
			setorigin(e, v1);
		}
		if (self.netname == "pk_crate_maker") // makin crates
		{
			e.wad = "pk_crate";
			self.wait = PK_CUBE_TIME;
			self.delay = PK_CUBE_DV;
		}
		else
		if (self.netname == "pk_cube_maker") // makin cubes
		{
			e.wad = "pk_cube";
			self.wait = PK_CUBE_TIME;
			self.delay = PK_CUBE_DV;
		}
		else
		if (self.netname == "morph_cube_maker") // makin cubes
		{
			e.wad = "morph_cube";
			self.wait = fabs(MORPH_CUBE_TIME);
			self.delay = fabs(MORPH_CUBE_DV);
		}
		else
		if (self.netname == "sv_nodule_maker") // makin cubes
		{
			e.wad = "archon_nodule";
			self.wait = PK_CUBE_TIME;
			self.delay = PK_CUBE_DV;
		}
		else
		if (self.dest1_x) // weapon + q items admin bit codes here
		{
			sb = e.cnt = bit_cnt(self.dest1_x, TRUE);
			e.wad = item_by_bit(e.cnt); // classname to spawn
			if ((self.spawnflags & 2) && (e.cnt & WEP_WEPSQ)) // make ammo for weps if spawnflags bit 2 set
			{
				rv = 1 + floor(random() * 3);
				while (rv > 0)
				{
					rv = rv - 1;
					e = world;
					e = spawn();
					if (e)
					{
						e.think = dyn_spawn;
						e.nextthink = 1 + 4 * random();
						e.event = "dynamic_item";
						e.cnt = sb;
						e.wad = ammo_by_bit(sb);
						e.origin = v0; // these can be anywhere
					}
				}
			}
		}
		else if (self.dest2_x) // ammo + pk items admin bit codes
		{
			e.cnt = bit_cnt(self.dest2_x, TRUE);
			e.wad = ammo_by_bit(e.cnt); // classname to spawn
		}
	}
};

// cube handler fn - called from server var loop

// fires off - pk_cubes, morphic cubes, crates

void(string cb) cube_handle =
{
	local entity e, p;
	local float f, cbv, cbt, cbd, cv;
	local string cbnet, cn;

	if (cb == "pk_cubes")
	{
		cv = cvar(cb);
		cbnet = "pk_cube_maker";
		cn = "Painkeep Cubes";
		cbv = PK_CUBE;
		cbt = PK_CUBE_TIME;
		cbd = PK_CUBE_DV;
	}
	else
	if (cb == "sv_morph")
	{
		cv = cvar(cb) - 1;
		cbnet = "morph_cube_maker";
		cn = "Morphic Cubes";
		cbv = MORPHIC;
		cbt = MORPH_CUBE_TIME;
		cbd = MORPH_CUBE_DV;
	}
	else
	if (cb == "it_crates")
	{
		cv = cvar(cb);
		cbnet = "pk_crate_maker";
		cn = "Crates";
		cbv = PK_CRATE;
		cbt = PK_CUBE_TIME;
		cbd = PK_CUBE_DV;
	}
	else
	if (cb == "sv_nodule")
	{
		cv = cvar(cb);
		cbnet = "sv_nodule_maker";
		cn = "Nodules";
		cbv = ARCHON_NODULES;
		cbt = PK_CUBE_TIME;
		cbd = PK_CUBE_DV;
	}
	else
	{
		if (WARNING)
		{
			bprint("*** Warning - ");
			bprint(cb);
			bprint(": invalid in cube handler!\n");
		}
		
		return;
	}

	if (cv > cbv && cv > 0)
	{
		f =  cv - cbv; //cvar("pk_cubes"); // adding some spawners
		if (WARNING)
		if (f > 10)
		{
			bprint("*** Warning - ");
			bprint(cb);
			bprint(": making more than 10 cubes | crates!\n");
		}

		while (f > 0)
		{
			e = spawn();

			e.classname = "func_dynitem";
			e.netname = cbnet; //"pk_cube_maker";
			e.wait = cbt; // PK_CUBE_TIME
			e.delay = cbd;
			e.think = func_dynitem;
			e.nextthink = time + e.wait * 0.1 + random() * 10;
			
			f = f - 1;
		}
		bprint("***  ");
		bprint(cn);
		bprint(" will spawn on this map");
		bprint(world.group);
		world.group = "\n";

	}
	if (cv <= 0) // turned off - remove them all
	{
		e = find(world,netname, cbnet);
		while (e)
		{
			p = e;
			e = find(e,netname, cbnet);
			remove (p);
		}
	}
	else
	if (cv < cbv && cbv > 0) // taking away some spawners but not turned off
	{
		f = cbv - cv;
		e = find(world,netname, cbnet);
		while (e && f > 0)
		{
			p = e;
			e = find(e,netname, cbnet);
			remove (p);
			f = f - 1;
		}
	}

};

// randomize any item

void() rndize_item;
void() place_item_control;

// rndize with no loop & need restore checks on active items

void() rndize_restore =
{
	self.nextthink = time + 10 + random() * 10;
	if (cvar("it_place_item") < 2)
	{
		self.nextthink = time + 0.1;
		self.think = rndize_item;
	}
};

// IDEA: rndize once should make a better effort of providing a good set of items (rndize inside type, weps health, etc, or some kind of item counts?)

// pk_place_item = 2 - rndize in genre
// pk_place_item = 3 - rndize across all genre

void() rndize_item =
{
//	local entity e;
	local float d, f;

	f = MC_RNDITM - 2;
	if (RUNES) f = MC_NR_RNDITM - 2; // dont rndize runes if server on
	d = MC_PK_RNDITM;
	if (PK_ART) d = MC_PKP_RNDITM;

	if (self.owner.mcode && cvar("it_place_item") == 3) // total rndize across all map items! - not recommend except for total chaos
	{
		f = MC_TOT - 2;
		self.owner.mcode = MC_SUPER_SHOTGUN + rint(random() * f);
	}
	else if (self.owner.mcode >= MC_AXE && self.owner.mcode < MC_Q1) // NOTE: doesnt make q1 axe or shotgun
	{
		self.owner.mcode = MC_SUPER_SHOTGUN + rint(random() * f);
	}
	else if (self.owner.mcode >= MC_PULSE_NAILGUN && self.owner.mcode < MC_PK)
	{
		self.owner.mcode = MC_PULSE_NAILGUN + rint(random() * d);
		if (self.owner.mcode >= MC_TOMB)
		if (PK_ART)
		{
			self.owner.event = "pkpitem"; // so we can reset if art turned off - these may not be native pkarts
		}
	}
	else if (self.owner.mcode >= MC_D_SAW && self.owner.mcode < MC_DOOM)
	{
		self.owner.mcode = MC_D_SAW + rint(random() * MC_D_RNDITM);
	}
	else if (self.owner.mcode >= MC_W_KNIFE && self.owner.mcode < MC_WOLF)
	{
		self.owner.mcode = MC_W_KNIFE + rint(random() * MC_W_RNDITM);
	}
	else if (self.owner.mcode >= MC_Q2_BLASTER && self.owner.mcode < MC_Q2)
	{
		self.owner.mcode = MC_Q2_BLASTER + rint(random() * MC_Q2_RNDITM);
	}
	else if (self.owner.mcode >= MC_Q3_GAUNTLET && self.owner.mcode < MC_Q3)
	{
		self.owner.mcode = MC_Q3_GAUNTLET + rint(random() * MC_Q3_RNDITM);
	}
	else if (self.owner.mcode >= MC_D_SAW && self.owner.mcode < MC_DOOM)
	{
		self.owner.mcode = MC_D_SAW + rint(random() * MC_D_RNDITM);
	}
	else if (self.owner.mcode >= MC_HIP_MJOLNIR && self.owner.mcode < MC_HIP)
	{
		self.owner.mcode = MC_HIP_MJOLNIR + rint(random() * MC_HIP_RNDITM);
	}
	else
	{
		if (WARNING)
		{
			bprint("*** Warning - rndize items: unlnown map code:");
			bprint(ftos(self.owner.mcode));
			bprint(" - no change\n");
		}
		if (cvar("it_place_item") == 2 || cvar("it_place_item") == 3)
		{
			self.nextthink = time + 10 + random() * 10;
			self.think = rndize_restore;
			return;
		}
	}

	self.owner.wad = item_by_mcode(self.owner.mcode);
//	self.owner.pk_touch = (void()) 0; // so we can touch the new things
	self.owner.pk_touch = SUB_Void; // so we can touch the new things

// IDEA: could have a chaos mod vector go thru here for chaos effects

	self.cnt = cvar("it_place_item_reload"); // randomize every so often

//	bprint("*** rndize item: ");
	if (cvar("it_place_item") == 0)
	{
//		bprint("admin turned off & exiting randomize items & restoring\n");
		self.owner.wad = item_by_mcode(self.owner.scode);
		remove(self);
		pic_tsk = 0;
	}
	else
	if (cvar("it_place_item") == 1)
	{
		place_item_control();
		remove(self);
		return;
	}
	else
	{
		if (!self.cnt)
		{
			self.nextthink = time + 10 + random() * 10;
			self.think = rndize_restore;
		}
		else
			self.nextthink = time + fabs(self.cnt) + random() * self.cnt;
	}
//	bprint(self.owner.classname);
//	bprint(" is now: ");
//	bprint(self.owner.wad);
//	bprint("\n");

	item_call_save(self.owner, self.owner.wad);

};

void() pic_restore_item =
{
	self.nextthink = time + 10 + random() * 10;
	if (cvar("it_place_item") == 0)
	{
		pic_tsk = 0;
		self.wad = item_by_mcode(self.scode);
		item_call(self.wad);
	}
	else
	if (cvar("it_place_item") == 2 || cvar("it_place_item") == 3)
	{
		place_item_control();
	}
};

// Called by place item under specific conditions for map load

void() place_item_control =
{
	if (self.event == "dynamic_item")
		return;

	if(self.map == null_string) self.map = "pic_item";

// have to make sure these got loaded
	if (!self.mcode) self.mcode = pk_mcode(null_string, self); // put map code on ent
	if (!self.scode) self.scode = self.mcode;

	if (cvar("it_place_item") == 1) // NOTE: something chaos will not be in control of
	{
		pic_tsk = 1;
		setmodel(self, null_string);
		self.touch = SUB_Null;
		if (self.takedamage) // barrels & other exploders
		{
			self.solid = SOLID_NOT;
			self.takedamage = DAMAGE_NO;
		}
		self.think = pic_restore_item;
		self.nextthink = time + 10 + random() * 10;
		return;
	}
	else if (cvar("it_place_item") == 2 || cvar("it_place_item") == 3)
	{
		local entity e;
		e = spawn();
		if (e)
		{
			e.owner = self;
			e.think = rndize_item;
			e.nextthink = time + 3 + random() * 5;
			e.classname = "rndize_item";
		}
		pic_tsk = 2;
	}
};

// twiddled after map load

void() place_item_control_loop =
{
	local entity e, sv;

	sv = self;
	e = find(world,map,"pic_item");
	while (e)
	{
		self = e;
		place_item_control();
		e = find(e,map,"pic_item");
	}
	self = sv;
};

// give best ident of an item possible

string(entity e) item_ident =
{
	local string f;

	f = "item has no identity!";
	if (e.netname != null_string) f = e.netname;
	else if (e.classname != null_string) f = e.classname;
	else if (e.class_select != null_string) f = e.class_select;

	return(f);
};

void() pic_test =
{
	if (chaos || DARKPLACES)
	if (time < PIC_TO)
	if (self.map != "nopic")
		place_item_control();
};
