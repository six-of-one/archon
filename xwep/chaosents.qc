/* ::-::
 *
 * Cataboligne
 *
 * file: chaosents.qc
 *
 * date: 7/6/10
 *
 * qc - support chaos stuff
 *
 */

void() chaos_precache =
{
	precache_model ("progs/laser_m.mdl");

	precache_model ("progs/m_reggun.mdl");
	precache_model ("progs/v_reggun.mdl");
	precache_model ("progs/vw_reggun.mdl");

	precache_model ("progs/null.mdl"); // Cataboligne 8.8.9 purify - chase cam

// sounds
	precache_sound ("reggun/fire4.wav");

	flamer_precache();
};

void() c_weapon_reggun =
{
	q100_weapon_supershotgun();
	self.netname = "Quad shotgun";

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = 33;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.attack_finished = 1.8;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 4;
	self.dmg_take = 42; // shot cnt
	self.punchangle = ' 0.20 0.06 0'; // bullet spread out

	setmodel (self, "progs/m_reggun.mdl");
	self.weaponmodel = "progs/v_reggun.mdl";
	self.vwepmdl = "progs/vw_reggun.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "reggun/fire4.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};



// from chaos mod

float Q_MEGA_MAX = 250;

//float() health_touch =
void() health_touch =
{
	local	float amount;
	local	string	s1;

	if (Q_100 || PK_100)
	{
		q100_health_touch();
		return;
	}

	amount = 0;

//	if (other.state == IMP_MWRAITH) return(TRUE); // wraith never get health

	if (self.healtype > HEAL_NORM) // Soul, Mega, health bottle  Ignore max_health...
	{
		if (self.volume > 0)
		if (other.health >= self.volume * 1)
			return;
/*
		if (self.healtype == HEAL_MEGA) // Megahealth
		if (other.health >= Q_MEGA_MAX * 1)
			return;
	
		if (self.healtype == HEAL_SOUL)
		if (other.health >= D_SOUL_MAX * 1) return;
*/
		if (!T_Heal(other, self.healamount, 1))
			return; //(TRUE);

		if (self.volume > 0)
		if (other.health >= self.volume * 1)
			other.health = self.volume * 1;
/*
		if (self.healtype == HEAL_MEGA) // Megahealth
		if (other.health >= Q_MEGA_MAX * 1)
			other.health = Q_MEGA_MAX * 1;

		if (self.healtype == HEAL_SOUL)
		if (other.health >= D_SOUL_MAX * 1) // CHECK - this is a 2 * max limiter
			other.health = D_SOUL_MAX * 1;
*/
//		if (other.health >= D_SOUL_MAX * other.health_modifier) // CHECK - this is a 2 * max limiter
//			other.health = D_SOUL_MAX * other.health_modifier;
	}
	else
	{
		amount = 0; //morph_heal(other, self.healamount); // Cataboligne - check max - 100 rule for morphs

																							if (WARNING)
																							if (FALSE & amount) {
																								bprint("health boost scale: ");
																								bprint(ftos(amount));
																								bprint(", total: ");
																								bprint(ftos(self.healamount + amount));
																								newline(world);}

		if (!T_Heal(other, self.healamount + amount, 0))
			return; //(TRUE);
	}

	if (self.noise4 == Q3_DET)
	{
		q3_ha_rot(other, other.health);
	}
//		if (other.flags & FL_ONFIRE)
//		{
//			if (self.healamount > 99) other.flags = other.flags - (other.flags & FL_ONFIRE); // any mega heal over 99 puts out fire
//		}
	other.healtype = self.healtype; // fire, plague & continous health rot stop - Cataboligne 1.15.8

	if (self.netname != "Mega Sphere")
	{
		sprint(other, "You receive ");
		s1 = ftos(self.healamount + amount);
		sprint(other, s1);
		sprint(other, " health\n");
	}
	
// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");
	
	self.model = string_null;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.healtype == HEAL_MEGA)
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
		
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
		return; //(-1); // dont respawn this yet - need to rot down health
	}
	else
	{
//	set_respawn();

		if (deathmatch == 1 || deathmatch == 3)		// deathmatch 2 is the silly old rules
		{
			self.nextthink = time + 20;
			self.think = SUB_regen;
		}
	}
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
//	return(FALSE);
};	


void () item_health =
{
	if (world.wad == "q2.wad")
	{
		q2_item_health();
		return;
	}
	else if (world.wad == "")
	{
		q3_item_health(); 
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

// x powerup touch

void() x_pwr_touch =
{
	local float t;

	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

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

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

	t = self.dmgtime;
	if (!t) t = POW_TIME;

	if (self.items == IT_SUIT)
	{
		other.rad_time = 1;
		if (other.radsuit_finished < time)
			other.radsuit_finished = time + t;
		else
			other.radsuit_finished = other.radsuit_finished + t;
	}

	if (self.items == IT_INVISIBILITY)
	{
		other.invisible_time = 1;
		if (other.invisible_finished < time)
			other.invisible_finished = time + t;
		else
			other.invisible_finished = other.invisible_finished + t;
	}

	if (self.items == IT_INVULNERABILITY)
	{
		other.invincible_time = 1;
		if (other.invincible_finished < time)
			other.invincible_finished = time + t;
		else
			other.invincible_finished = other.invincible_finished + t;
	}

	if (self.items == IT_QUAD)
	{
		if (self.mdl == "progs/d_berzerk.mdl") // special - doom berserk - TDO: even more special - 4x only for fists, red haze
			health_touch();

		other.super_time = 1;
		if (other.super_damage_finished < time)
			other.super_damage_finished = time + t;
		else
			other.super_damage_finished = other.super_damage_finished + t;
	}

	if (self.netname == "Mega Sphere")
	{
		health_touch();
		armor_touch();
	}

	if (self.netname == "Re-breather")
	{
		other.rad_time = 1;
		if (other.wetsuit_finished < time)
			other.wetsuit_finished = time + t;
		else
			other.wetsuit_finished = other.wetsuit_finished + t;
	}

	if (self.netname == "Silencer")
	{
		if (other.silencer_finished < time)
			other.silencer_finished = time + t;
		else
			other.silencer_finished = other.silencer_finished + t;
	}
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// x ammo pack touch & bounds

void() x_pack_touch =
{
	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		grap_checkIfGrap();
		return;
	}
	if (other.health <= 0)
		return;

// detect pack type
	other.target1 = self.model; // cant use noise4 DET_ because of bandolier in q2
	if (self.model == "progs/d_pack.mdl")
	if (self.skin == 1)
		other.target1 = "progs/w_pack.mdl"; // id wolf pack

	other.rune_flag = other.rune_flag | self.rune_flag; // RUNE_AMMO show pack bounds - will default to doom op if no .target1 value

	BackpackTouch();

	if (self.noise != "")
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM); // default is q1 pack grab snd - in bp code

	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1 || deathmatch == 3)
	{
		self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets

};

/*

other - must be player !!
self - ammo box if am > 0

am > 0 = return boundary for a given ammo type

bound according to .target1 val

 - progs/d_pack.mdl - or blank - doom values
 - progs/q2_bando.mdl - q2 banodlier values
 - progs/q2_pack.mdl - q2 pack values

q1 defs
	SHELLAMMO_MAX				= 100;
	NAILAMMO_MAX					= 200;
	ROCKETAMMO_MAX			= 100;
	CELLAMMO_MAX					= 200; // pk amount - q1 = 100

	BULLETAMMO_MAX			= 200;
	SLUGAMMO_MAX					= 50;
	GASAMMO_MAX						= 400;
*/

float(float am) bound_ammo_pack =
{
	local float sh_mx, nl_mx, rk_mx, cl_mx, bl_mx, sl_mx, gs_mx;

// defaults set by server op
	bl_mx	= PK_BULLETAMMO_MAX;
	sh_mx	= Q1_SHELLAMMO_MAX;
	rk_mx	= Q1_ROCKETAMMO_MAX;
	cl_mx	= Q1_CELLAMMO_MAX;
	sl_mx	= PK_SLUGAMMO_MAX;
	nl_mx	= Q1_NAILAMMO_MAX;
	gs_mx	= PK_GASAMMO_MAX;

	if (SV_AMMO_MAX != 2) // master override check - turns off all ammo limit bounds increases, even the ammo rune
	if (other.rune_flag & RUNE_AMMO)
	{
// defaults - doom if no other settings - TDO: default to rune values once determined
		bl_mx	= 400;
		sh_mx	= 100;
		rk_mx	= 100;
		cl_mx	= 600;

		if (other.target1 == "progs/w_pack.mdl")
		{
			bl_mx	= 299;



if (WARNING)
{
bprint("\b *** warning: wolf pack values set\n");
}



		}
		else if (other.target1 == "progs/q2_pack.mdl")
		{
			bl_mx	= 300;
			sh_mx	= 200;
			rk_mx	= 100;
			cl_mx	= 300;
			sl_mx	= 100;



if (WARNING)
{
bprint("\b *** warning: q2 pack values set\n");
}



		}
		else if (other.target1 == "progs/q2_bando.mdl")
		{
			bl_mx	= 250;
			sh_mx	= 150;
			rk_mx	= 50;
			cl_mx	= 250;
			sl_mx	= 75;



if (WARNING)
{
bprint("\b *** warning: q2 band values set\n");
}



		}
		else



if (WARNING)
{
bprint("\b *** warning: doom pack values set\n");
}




	}


// return value for ammo type - ammo touch fn needs this
	if (am)
	{
		if (! (other.rune_flag & RUNE_AMMO))
		if (!SV_AMMO_MAX)
		{
// genre limits - set by spawn fn
			if (self.volume) return(self.volume);
		}
//		if (SV_AMMO_MAX != 2) // because inf ammo is going to be a chaos thing for the most part
		if (self.volume == -1) return(MAX_AMMO); // inifinte volume item
// standard limits + rune / pack effect
		if (am == AMMO_BULLETS) return(bl_mx);
		if (am == AMMO_SHELLS) return(sh_mx);
		if (am == AMMO_CELLS) return(cl_mx);
		if (am == AMMO_ROCKETS) return(rk_mx);
		if (am == AMMO_GRENADES) return(rk_mx);
		if (am == AMMO_SLUGS) return(sl_mx);
		if (am == AMMO_GAS) return(gs_mx);
		if (am == AMMO_NAILS) return(nl_mx);
		return(DEF_AMMO); // oops - couldnt figure type
	}

// do bounds
	if (other.ammo_shells > sh_mx)
		other.ammo_shells = sh_mx;
	if (other.ammo_nails > nl_mx)
		other.ammo_nails = nl_mx;
	if (other.ammo_rockets > rk_mx)
		other.ammo_rockets = rk_mx;
	if (other.ammo_cells > cl_mx)
		other.ammo_cells = cl_mx;
// new ammo
	if (other.ammo_bullet > bl_mx)
		other.ammo_bullet = bl_mx;
	if (other.ammo_slug > sl_mx)
		other.ammo_slug = sl_mx;
	if (other.ammo_gaspr > gs_mx)
		other.ammo_gaspr = gs_mx;

	return(0);
};

// inventory display & control

float IT_BULLETS = 4096;
float IT_SLUGS = 8192;
float IT_GAS = 16384;

float am_type;
string pk_pr;

void(entity e, float am, string pr) eweap_am =
{
//	if (am_type == am) return;
//	am_type = am;


	if (am == AMMO_BULLETS && !(am_type & IT_BULLETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_bullet));
		sprint(e, " bullets");
		am_type = am_type | IT_BULLETS;
	}
	else if (am == AMMO_SHELLS && !(am_type & IT_SHELLS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_shells));
		sprint(e, " shells");
		am_type = am_type | IT_SHELLS;
	}
	else if (am == AMMO_CELLS && !(am_type & IT_CELLS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_cells));
		sprint(e, " cells");
		am_type = am_type | IT_CELLS;
	}
	else if (am == AMMO_ROCKETS && !(am_type & IT_ROCKETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_rockets));
		sprint(e, " rockets");
		am_type = am_type | IT_ROCKETS;
	}
	else if (am == AMMO_GRENADES && !(am_type & IT_ROCKETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_rockets));
		sprint(e, " grenades");
//		am_type = am_type | IT_ROCKETS;
	}
	else if (am == AMMO_NAILS && !(am_type & IT_NAILS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_nails));
		sprint(e, " nails");
		am_type = am_type | IT_NAILS;
	}
	else if (am == AMMO_SLUGS && !(am_type & IT_SLUGS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_slug));
		sprint(e, " slugs");
		am_type = am_type | IT_SLUGS;
	}
	else if (am == AMMO_GAS && !(am_type & IT_GAS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.ammo_gaspr));
		sprint(e, " lbs gas pressure");
		am_type = am_type | IT_GAS;
	}
	else if (am == PK_IT_GRAPGUN && e.pk_items & am)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, "Harpoon gun\n");
		pk_pr = "";
	}
	else if (am == PK_IT_AIRGUN && e.pk_items & am)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, "Air cannon\n");
		pk_pr = "";
	}
	else if (am == PK_IT_CLIGHT && e.pk_items & am)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, "Chain Thunderbolt cannon");
		eweap_am(self, AMMO_CELLS, "   -> ");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_GRAVITYWELL && e.pk_gravitywellammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_gravitywellammo));
		sprint(e, " gravity well");
		if (e.pk_gravitywellammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_TURRET && e.pk_turretammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_turretammo));
		sprint(e, " turret");
		if (e.pk_turretammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_CANPAB && e.pk_canpabammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_canpabammo));
		sprint(e, " pork and beans can");
		if (e.pk_canpabammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_BEARTRAP && e.pk_beartrapammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_beartrapammo));
		sprint(e, " bear trap");
		if (e.pk_beartrapammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == 4096 && e.pk_explode_ammo > 0) // shells dont have a PK_IT # - jacking this one for the inventory fn
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_explode_ammo));
		sprint(e, " explode shell");
		if (e.pk_explode_ammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_EGO && e.pkplus_egoammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_egoammo));
		sprint(e, " ego");
		if (e.pkplus_egoammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_TOMB && e.pkplus_tombammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_tombammo));
		sprint(e, " tomb");
		if (e.pkplus_tombammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_ACTOR && e.pkplus_actorammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_actorammo));
		sprint(e, " actors mask");
		if (e.pkplus_actorammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_PHONE && e.pkplus_phoneammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_phoneammo));
		sprint(e, " cellular phone tele-hack");
		if (e.pkplus_phoneammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
/*	else if (am == )
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.));
		sprint(e, " t");
		if (e. > 1) sprint(e, "s");
	}*/
};

// ammo with no wep

void() loose_ammo =
{
	local string pr;

	pr = "-\nammo:\n";

	if (self.ammo_shells  && !(am_type & IT_SHELLS))
	{
		eweap_am(self, AMMO_SHELLS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_cells  && !(am_type & IT_CELLS))
	{
		eweap_am(self, AMMO_CELLS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_nails  && !(am_type & IT_NAILS))
	{
		eweap_am(self, AMMO_NAILS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_rockets  && !(am_type & IT_ROCKETS))
	{
		eweap_am(self, AMMO_ROCKETS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_bullet  && !(am_type & IT_BULLETS))
	{
		eweap_am(self, AMMO_BULLETS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_slug  && !(am_type & IT_SLUGS))
	{
		eweap_am(self, AMMO_SLUGS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_gaspr  && !(am_type & IT_GAS))
	{
		eweap_am(self, AMMO_GAS, pr);
		sprint(self, "\n");
		pr = "";
	}
};

void(float wp) q1_inv_print =
{
	if (wp == IT_AXE) sprint(self, "War Axe\n");
	else if (wp == IT_SHOTGUN)
	{
		sprint(self, "Pump shotgun");
		eweap_am(self, AMMO_SHELLS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_SUPER_SHOTGUN)
	{
		sprint(self, "Double barrel shotgun");
		eweap_am(self, AMMO_SHELLS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_NAILGUN)
	{
		sprint(self, "Fletchet (nail) gun");
		eweap_am(self, AMMO_NAILS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_SUPER_NAILGUN)
	{
		sprint(self, "High rate Fletchet (nail) gun");
		eweap_am(self, AMMO_NAILS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_GRENADE_LAUNCHER)
	{
		sprint(self, "Grenade launcher");
		eweap_am(self, AMMO_ROCKETS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_ROCKET_LAUNCHER)
	{
		sprint(self, "Rocket launcher");
		eweap_am(self, AMMO_ROCKETS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_LIGHTNING)
	{
		sprint(self, "Thunderbolt cannon");
		eweap_am(self, AMMO_CELLS, "   -> ");
		sprint(self, "\n");
	}

	else if (wp == IT_ARMOR3) sprint(self, "Body armor (code red)\n");
	else if (wp == IT_ARMOR2) sprint(self, "Combat armor (code yellow)\n");
	else if (wp == IT_ARMOR1) sprint(self, "Jacket armor (code green)\n");
	else if (wp == IT_KEY2) sprint(self, "a Gold key\n");
	else if (wp == IT_KEY1) sprint(self, "a Silver key\n");
	else if (wp == IT_SUPERHEALTH) sprint(self, "Mega health!\n");
	else if (wp == IT_QUAD) sprint(self, "Quad damage\n");
	else if (wp == IT_INVULNERABILITY) sprint(self, "Pentagram power\n");
	else if (wp == IT_SUIT) sprint(self, "Hazmat protection suit\n");
	else if (wp == IT_INVISIBILITY) sprint(self, "Ring of shadows\n");
//	else if (wp == IT_) sprint(self, "\n");
};


// handle player inventory impulses

// 52 = list inv + drop item
// 53 = drop mode

void() inventory =
{
	local float f, k, IT_DET;
	local entity e;

// detect items for title header print
	IT_DET = IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3 | IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD | IT_SUPERHEALTH;
	am_type = 0;
	if (self.impulse == 52)
	{
		sprint(self, "\n* Inventory *\n");
		sprint(self, "-\nWeapons:\n");
		f = 1;
		while (f <= IT_QUAD)
		{
			e = world;
			if (f <= IT_LIGHTNING)
				e = vchk(f, 0, self.vwepent);
			if (e)
			{
				if (e.eweapon)
				{
					sprint(self, e.netname);
					eweap_am(self, e.lip, "   -> ");
					sprint(self, "\n");
				}
				else
					if (self.items & f) q1_inv_print(f);
			}
			else
				if (self.items & f) q1_inv_print(f);

			if (f == IT_LIGHTNING) 
				f = IT_AXE;
			else
				f = f * 2;
			if (f == IT_ARMOR1)
			{
				if (PK_INV)
				{
					pk_pr = "-\npainkeep Items:\n";
					k = 2;
					while (k < 8192)
					{
						eweap_am(self, k, pk_pr);
						k = k * 2;
					}
				}
				loose_ammo();
				if (self.rune_flag & RUNE_AMMO)
				if (self.target1 != "ammorune")
					sprint(self, "Ammo Pack\n");
				if (self.items & IT_DET)
					sprint(self, "-\nItems:\n");
			}
		}
		if (self.rune_flag & RUNE_MASK_ALL) sprint(self, "-\nRunes of power\n");
	}

	am_type = 0;
}