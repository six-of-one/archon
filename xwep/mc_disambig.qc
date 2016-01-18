/* ::-::
 *
 * Cataboligne
 *
 * file: mc_disambig.qc
 *
 * date: 7/26/10
 *
 * qc - support native map ambiguous spawn fns
 *
 */

// handle spawn functions that have the same descriptor but make different things on different maps
// classnames have to be set (HERE) if they wont match the generated map code - all advanced fns need this
// dont ever set classname in spawn call because of rndize, translate & cycle

// if map is not detectable ->	between q2 & q3 default to q3 (since darkplaces cant load q2 native, q2 maps should always be detectable)
// 															between q1 & q2 & q3 default to q1 (this might bufu any q3 map that has .wad set - none should)

// map detection theory ...

// q1 maps have a "wad" entry - q3 maps do not
// q2 maps MUST be translated for dp & q1/3 -> set "wad" to "q2.wad"
// doom maps MUST be translated for dp & q1/3 -> use d_* spawn fn

/// ambiguous weapons

void() weapon_bfg =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_bfg";
		q2_weapon_bfg();
	}
	else
	{
		self.classname = "q3_weapon_bfg";
		q3_weapon_bfg();
	}
}

void() weapon_railgun =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_railgun";
		q2_weapon_railgun();
	}
	else //if (world.wad == "")
	{
		self.classname = "q3_weapon_railgun";
		q3_weapon_railgun(); 
	}
};

void() weapon_lightning =
{
	if (!pk_map) // not a pk map (some hubX maps have no .wad!)
	if (world.wad == "")
	{
		self.classname = "q3_weapon_lightning";
		q3_weapon_lightning();
		return;
	}

	q100_weapon_lightning(); 
};

void () weapon_rocketlauncher =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_rocketlauncher";
		q2_weapon_rocketlauncher();
		return;
	}
	else if (world.wad == "" && !pk_map)
	{
		self.classname = "q3_weapon_rocketlauncher";
		q3_weapon_rocketlauncher(); 
		return;
	}

	q100_weapon_rocketlauncher();
};

void () weapon_grenadelauncher =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_grenadelauncher";
		q2_weapon_grenadelauncher();
		return;
	}
	else if (world.wad == "" && !pk_map)
	{
		self.classname = "q3_weapon_grenadelauncher";
		q3_weapon_grenadelauncher(); 
		return;
	}

	q100_weapon_grenadelauncher();
};

void() weapon_machinegun =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_machinegun";
		q2_weapon_machinegun();
	}
	else
	{
		self.classname = "q3_weapon_machinegun";
		q3_weapon_machinegun();
	}
}

void () weapon_supershotgun =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_supershotgun";
		q2_weapon_supershotgun();
		return;
	}

	q100_weapon_supershotgun();
};

void () weapon_shotgun =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_weapon_shotgun";
		q2_weapon_shotgun();
		return;
	}
	else if (world.wad == "" && !pk_map)
	{
		self.classname = "q3_weapon_shotgun"; // for item translates, map code controls, etc
		q3_weapon_shotgun(); 
		return;
	}

	q100_weapon_shotgun();
};

/// ambiguous ammos

void() ammo_slugs =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_ammo_slugs";
		q2_ammo_slugs();
	}
	else
	{
		self.classname = "q3_ammo_slugs";
		q3_ammo_slugs();
	}
};

void() spawnfunc_ammo_cells =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_ammo_cells";
		q2_ammo_cells();
	}
	else
	{
		self.classname = "q3_ammo_cells";
		q3_ammo_cells();
	}
};

void() spawnfunc_ammo_rockets =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_ammo_rockets";
		q2_ammo_rockets();
	}
	else
	{
		self.classname = "q3_ammo_rockets";
		q3_ammo_rockets();
	}
};

void() ammo_grenades =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_ammo_grenades";
		q2_ammo_grenades();
	}
	else
	{
		self.classname = "q3_ammo_grenades";
		q3_ammo_grenades();
	}
}

void() ammo_bullets =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_ammo_bullets";
		q2_ammo_bullets();
	}
	else
	{
		self.classname = "q3_ammo_bullets";
		q3_ammo_bullets();
	}
};

void() spawnfunc_ammo_shells =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_ammo_shells";
		q2_ammo_shells();
	}
	else
	{
		self.classname = "q3_ammo_shells";
		q3_ammo_shells();
	}
};

/// ambiguous armor

void () item_armor_combat =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_item_armor_combat";
		q2_item_armor_combat();
	}
	else
	{
		self.classname = "q3_item_armor_combat";
		q3_item_armor_combat(); 
	}
};


void () item_armor_body =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_item_armor_body";
		q2_item_armor_body();
	}
	else
	{
		self.classname = "q3_item_armor_body";
		q3_item_armor_body(); 
	}
};


void () item_armor_shard =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_item_armor_shard";
		q2_item_armor_shard();
	}
	else
	{
		self.classname = "q3_item_armor_shard";
		q3_item_armor_shard(); 
	}
};

/// ambiguous health


void () item_health =
{
	if (world.wad == "q2.wad")
	{
		q2_item_health();
		self.classname = "q2_item_health";
		return;
	}
	else if (world.wad == "" && !pk_map)
	{
		q3_item_health(); 
		self.classname = "q3_item_health";
		return;
	}

	q100_item_health();
	if (!Q_100)
	{
		self.healtype = self.healtype + 1;
		self.volume = 100;
		if (self.spawnflags & 2)
			self.volume = Q_MEGA_MAX;
	}
};

void () item_health_small =
{
	if (world.wad == "q2.wad")
	{
		q2_item_health_small();
		self.classname = "q2_item_health_small";
	}
	else
	{
		q3_item_health_small(); 
		self.classname = "q3_item_health_small";
	}
};

void () item_health_large =
{
	if (world.wad == "q2.wad")
	{
		q2_item_health_large();
		self.classname = "q2_item_health_large";
	}
	else
	{
		q3_item_health_large(); 
		self.classname = "q3_item_health_large";
	}
};

void () item_health_mega =
{
	if (world.wad == "q2.wad")
	{
		q2_item_health_mega();
		self.classname = "q2_item_health_mega";
	}
	else
	{
		q3_item_health_mega(); 
		self.classname = "q3_item_health_mega";
	}
};

/// ambiguous artifacts


void () item_quad =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_item_quad";
		q2_item_quad();
	}
	else
	{
		self.classname = "q3_item_quad";
		q3_item_quad(); 
	}
};

void () item_enviro =
{
	if (world.wad == "q2.wad")
	{
		self.classname = "q2_item_enviro";
		q2_item_enviro();
	}
	else
	{
		self.classname = "q3_item_enviro";
		q3_item_enviro(); 
	}
};

