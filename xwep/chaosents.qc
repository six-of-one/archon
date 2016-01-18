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
	precache_model ("progs/null.mdl"); // Cataboligne 8.8.9 purify - chase cam

// sounds
	precache_sound ("reggun/fire4.wav");

	precache_model ("progs/bit.mdl");
	precache_model ("progs/g_axe.mdl");
	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/vw_axe.1.mdl");
	precache_model ("progs/vw_axe.mdl");
	precache_model ("progs/shotgun.mdl");
	precache_model ("progs/vw_shot.mdl");
	precache_model ("progs/smoke.mdl");
	precache_model ("progs/m_reggun.mdl");
	precache_model ("progs/v_reggun.mdl");
	precache_model ("progs/vw_reggun.mdl");
	precache_model ("progs/pt_beam.mdl");
	precache_model ("progs/g_flamer2.mdl");
	precache_model ("progs/g_gas.mdl");
	precache_model ("progs/vw_flamer2.mdl");
	precache_model ("progs/vw_gascyl.mdl");
	precache_model ("progs/vw_qgun.mdl");
	precache_model ("progs/g_deepsleep.mdl");
	precache_model ("progs/vw_deepsleep.mdl");
	precache_model ("progs/steam.mdl");
	precache_model ("progs/pk_cube.bsp");
	precache_model ("progs/morph_cube.bsp");

	precache_sound ("sound/flm/ft_hum.wav");
	precache_sound ("sound/flm/ft_fire.wav");
	precache_sound ("sound/flm/burning.wav");
	precache_sound ("sound/flm/airhiss1.wav");
	precache_sound ("sound/reggun/fire.wav");
	precache_sound ("sound/reggun/fire4.wav");

// shovel test
	precache_model ("progs/m_shovel.mdl");
	precache_model ("progs/vw_shovel.mdl");

// poral 1
	precache_model ("progs/portal.mdl");
	precache_model ("progs/v_portal.mdl");
	precache_sound ("sound/portal/portfire.wav");
	precache_sound ("sound/portal/portfail.wav");
	precache_sound ("sound/portal/chargeup.wav");
	precache_sound ("sound/portal/shdoff.wav");

// spheres (tele / annihilate)

	precache_model ("progs/sphere_annihilation.mdl");
	precache_sound ("alt_ambience/hum1.wav");

//	flamer_precache();
};

void() c_weapon_reggun =
{
	q100_weapon_supershotgun();
	self.netname = "Quad shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = 33;
	self.aflag = IGN_INV;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.attack_finished = 1.8;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 4;
	self.dmg_take = 42; // shot cnt
	self.bulletspread = ' 0.20 0.06 0'; // bullet spread out

	setmodel (self, "progs/m_reggun.mdl");
	self.weaponmodel = "progs/v_reggun.mdl";
	self.vwepmdl = "progs/vw_reggun.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "reggun/fire4.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "x_item";
};

void() c_weapon_shovel =
{
	weapon_axe();
	self.netname = "Shovel";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = fire_axe;

	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = AMMO_NONE;
	self.attack_finished = 0.5;
	self.dmg = 15;
	self.dmg_save = 0;
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	setmodel (self, "progs/m_shovel.mdl");
	if (DARKPLACES) setmodel (self, "progs/shovel.md3"); // TESTING
	self.weaponmodel = "progs/v_axe.mdl";
	self.vwepmdl = "progs/vw_shovel.mdl";
	self.vv_draw = vw_melee_base;

//	self.noise1 = "weapons/ax1.wav"; // missed
	self.noise3 = "player/axhit2.wav"; // hit wall &| solid
//	self.noise4 = "zombie/z_hit.wav"; // hit flesh

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "x_item";
};

void () c_weapon_deepsleep =
{
	q100_weapon_supershotgun();

	self.netname = "Deepsleep gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_pistol1;

	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = AMMO_NONE;
	self.attack_finished = 0.7;
	self.dmg = 30;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	self.vv_draw = vw_melee_base;

	setmodel (self, "progs/g_deepsleep.mdl");
	self.weaponmodel = "progs/v_q2_blst.mdl";
	self.vwepmdl = "progs/vw_deepsleep.mdl";
	self.noise3 = "q2_snd/blastf1a.wav";
	self.target = "q2_snd/lashit.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "x_item";
};


// fn(xwep_fakeload) - extra weapon fake load - carried something between levels and it doesnt exist on new level

// self - map weapon ent (fake loaded) NOTE: code does not load for self! 
//...or 1 of these 2... --- what code really does
// mcd - map code - overrides spf
// spf - spawn func, in either case this code handles load up
// islot - inventory slot (weapon bit 1 - 128, 4096)

// ve - viswep ent
// camct - current ammo cnt

void(entity ve, float camct, float mcd, string spf, float islot) xwep_fakeload =
{
	local string spt; // spawn this temp
	local entity sv;
	local float camctp; // value to pass - sending negative as code

	if (!ve) return;

	sv = self;
	spt = spf;

	if (mcd)
	{
		spt = item_by_mcode(mcd);
	}
	if (spt) // spawn this
	{
		self = spawn();
		self.classname = "dyn_item"; // stop item_call from doing a bunch of stuff - if not removed this will spawn the item somewhere
		item_call(spt);
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}

	if (camct < 1) camctp = -0.5;
	else camctp = 0 - camct;

	x_wep_store(ve, islot, camctp);
/*
TEST: more testing before removeal
		ve.eweapon = ve;
		ve._attack = self._attack;
		ve._fr_attack = self._fr_attack;
		ve.vv_draw = self.vv_draw;
		ve.vv_holster = self.vv_holster;
		ve.vwepmdl = self.vwepmdl; // for pack / dthrow weps
//		ve.touch = self.touch;

		ve.weapon = ve.items = self.items;
		if (self.items == IT_AXE) ve.pk_currentitem = self.pk_currentitem; // replacing the axe
		ve.x_items = self.x_items;
		ve.currentammo = self.currentammo;
		ve.lip = self.lip;
		ve.attack_finished = self.attack_finished;
		ve.dmg = self.dmg;
		ve.dodmg = self.dodmg;
		ve.dmg_save = self.dmg_save;
		ve.dmg_take = self.dmg_take;
		ve.bulletspread = self.bulletspread;
		ve.aflag = camct;
		ve.style = self.style; // melee flag
		ve.lefty = self.lefty; // misc data
//		ve.cnt = self.cnt; // vw skinnage
		if (self.mcode) ve.mcode = self.mcode; // for pack touch deal

		ve.netname = self.netname;
//		ve.mdl = self.mdl; - invisible
		setmodel (ve, self.vwepmdl);
		ve.mdl = ve.model;
		if (!VW)
		{
			if (!(ve.weapon == IT_AXE && ve.pk_currentitem == PK_IT_AXE)) // any axe replacement
			if (ve.mdl != "progs/vw_q2_hgr.mdl")
			if (ve.mdl != "progs/vw_axe.mdl" && ve.mdl != "progs/vw_mjolnir.mdl")
				setmodel (ve, VW_DEFGUN);
		}
		if (self.skin) ve.skin = self.skin;
		ve.weaponmodel = self.weaponmodel;
		ve.chaosweptime = self.chaosweptime;
		ve.endtime = self.endtime;
		ve.duration = self.duration;
		ve.noise = self.noise;
		ve.noise2 = self.noise2;
		ve.noise3 = self.noise3;
		ve.noise4 = self.noise4;
		ve.target = self.target; // missile strike snd
		ve.target1 = self.target1; // missile models
// hooks
		ve.target2 = self.target2;
		ve.targetname = self.targetname;
		ve.killtarget = self.killtarget;
*/
	self = sv;
}

// from chaos mod

// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount6, float ignore) T_Heal =
{
	local float heala, f;

	if (Q_100 || PK_100)
	{
		return(q100_T_Heal(e, healamount6, ignore));
	}

	if (e.health <= 0)
		return 0;

//	if ((!ignore) && (e.health >= other.max_health)) .. moved to test below
//		return 0;

	heala = ceil (healamount6);
	f = e.health; // for healable armor creatures where health > max due to bonuses & bottles

	if (player_scourge_armor(e,heala,ignore)) // armor healed
	{
		if (f >= (e.max_health * e.health_modifier) )
		{
			e.health = f; // because heal armor bumps health down to compensate for part of heal being dedicated to armor
			return 1;
		}
	}
	else
		if ( (!ignore) && (e.health >= e.max_health * e.health_modifier)) return 0;

	e.health = e.health + heala;
//	if ((!ignore) && (e.health >= e.max_health))
//		e.health = e.max_health;
	if ((!ignore) && (e.health >= e.max_health * e.health_modifier))
		e.health = e.max_health * e.health_modifier;

// Cant hard cap here because of q2 bottles
//	if (e.health > 250)
//		e.health = 250;

// global morph max - 999 to keep display bar good
//	if (e.health > MAX_HEALTH) e.health = MAX_HEALTH;

// NOTE: q2 deal will bork display bar if anyone can collect enough (and its pretty easy with a tank...)

	if (!Q_100)
	if (e.model == "progs/player.mdl") // TDO: morph dmg skins
		pk_setDamageSkin(e); // *pk damage skins code

	return 1;
};

// Cataboligne - 9.9.11 - tweak to prevent multiple health rots on 1 avatar
float Test, Smd;

// special max calc for morphs

// ehm - ents .health_modifier
// hv - healh .volume

float(float ehm, float hv) morph_healmax =
{
	local	float smd, smax;

	if (ehm > 1.0)
		Smd = smd = 1 + (SPC_HEAL_MOD * ehm); // we dont just let morphs get mega heal volumes * health mod, which would be a max of 2000 for a super tank
	if (smd < 1) smd = 1;
	smax = hv - Q_NORM_MAX; // what can be added by a healer - maximum
//			if (smax < 100) smax = 100;
	Test = smax = (Q_NORM_MAX * ehm) + (smax * smd); // morph adjusted max
	return (smax);
}

//float() health_touch =
void() health_touch =
{
	local	float amount, smax;
	local	string	s1;

	if (Q_100 || PK_100)
	{
		q100_health_touch();
		return;
	}

	amount = 0;

	if (other.state == IMP_MWRAITH) return; //(TRUE); // wraith never get health -- TDO: check state field for wraiths

	Q3_HAH_TMP = other.health;
	Q3_HAA_TMP = other.armorvalue;

	if (self.healtype > HEAL_NORM) // Soul, Mega, health bottle  Ignore max_health...
	{
		if (self.volume > 0)
		{
			smax = morph_healmax(other.health_modifier, self.volume);
			if (other.health >= smax) //self.volume * smd) //other.health_modifier)
				return;
		}

		if (!T_Heal(other, self.healamount, 1))
			return; //(TRUE);

		if (self.volume > 0) // cap here because we cant in T_heal
		if (other.health >= smax) 
			other.health = smax;
	}
	else
	{
		amount = morph_heal(other, self.healamount); // Cataboligne - check max - 100 rule for morphs

																							if (WARNING)
																							if (amount) {
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
	else if (self.healtype > HEAL_MEGA) // above mega because q3 rot handles other megas rot too
	{
		Q3_HAH_TMP = self.healamount;
		Q3_HAA_TMP = 0;
		q3_ha_rot(other, -1);
	}

//	if (other.flags & FL_ONFIRE)
//	{
//		if (self.healamount > 99) other.flags = other.flags - (other.flags & FL_ONFIRE); // any mega heal over 99 puts out fire
//	}

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
		if (!other.items & IT_SUPERHEALTH) // not already rotting - start it up
		{
			self.nextthink = time + 5;
			self.think = item_megahealth_rot;
			self.owner = other;
		}
		other.items = other.items | IT_SUPERHEALTH; // shows rot

		if (self.noise4 == Q3_DET)
		{
			if (newmis) newmis.enemy = self; // so real q3 rot can regen this when done
			if (self.wait)
				self.nextthink = time + self.wait * 2;
			else
				self.nextthink = time + 80;
			self.think = q3_megahealth_restore; // just in case q3 rot gets lost
			return;
		}
		
//		return; //(-1); // dont respawn this yet - need to rot down health
	}
	
	if (self.think != item_megahealth_rot)
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


// x powerup touch

void() x_pwr_touch =
{
	local float t;
	local entity e2;

	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

	if (self.netname == "Mega Sphere")
	if ( (other.health > morph_healmax(other.health_modifier, self.volume)) || (other.armorvalue > self.currentammo) )
		return;

	if (self.class_select == "q3_item") // for holdables - since they use pk slots, tho the corollary of collecting a pk item is not tested
	if (self.pk_currentitem) // 'es already got one...wot?  'e sais 'yve already got one.  already got a Grail?
	{
bprint("holdable: ");
		if (other.pk_canpabammo && self.pk_currentitem == PK_IT_CANPAB) return;
		if (other.pkplus_phoneammo && self.pk_currentitem == PKPLUS_IT_PHONE) return;
		e2 = vchk(self.items, self.pk_currentitem, other.vwepent);


if (!e2) bprint("no ent found");
else bprint("*** ent found!");
bprint("\n");


		if (!e2)
			e2 = x_wep_store(world, self.items, 1);
		else
			return;


bprint("xwep own: ");
bprint(e2.owner.netname);
bprint("\n");


	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	if (Q_99 || (deathmatch != 4)) // *pk - my new rule, logical extrapolation
	if (deathmatch)
	{
		self.mdl = self.model;
		if (self.wait && self.class_select == "q3_item") // q3 wait code react
			self.nextthink = time + self.wait;
		else
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

	if (other.mask_x & CB_HUMAN)
	if (self.mdl == "progs/q3_art.mdl")
	if (self.items == IT_SUIT || self.items == IT_QUAD)
	{
		local entity e;
		e = spawn();
		e.owner = other;
		e.enemy = vload(other, -1);
		setmodel(e.enemy, "progs/player_sh.mdl");
		e.enemy.mdl = e.enemy.model;
		e.enemy.skin = Q3_SH_QUAD;
		e.think = q3_art_shell;
		e.nextthink = time + t - 1; //POW_TIME - 1;
		if (self.items == IT_SUIT)
			e.enemy.skin = Q3_SH_ENV;
		if (self.items == IT_QUAD)
			e.enemy.skin = Q3_SH_QUAD;
		e.items = self.items;
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

		if (other.target1 == "progs/w_pack.mdl")
		{
			bl_mx	= 299;



if (WARNING)
{
bprint("\b *** warning: wolf pack values set\n");
}



		}
		else if (other.target1 == "progs/d_pack.mdl")
		{
			bl_mx	= 400;
			sh_mx	= 100;
			rk_mx	= 100;
			cl_mx	= 600;



if (WARNING)
{
bprint("\b *** warning: doom pack values set\n");
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
		{
// defaults - rune power 2x all carried ammo if no other settings
			bl_mx	= PK_BULLETAMMO_MAX * 2;
			sh_mx	= Q1_SHELLAMMO_MAX * 2;
			rk_mx	= Q1_ROCKETAMMO_MAX * 2;
			cl_mx	= Q1_CELLAMMO_MAX * 2;
			sl_mx	= PK_SLUGAMMO_MAX * 2;
			nl_mx	= Q1_NAILAMMO_MAX * 2;
			gs_mx	= PK_GASAMMO_MAX * 2;


if (WARNING)
{
bprint("\b *** warning: default -- ammo rune 2x server limit values set\n");
}


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

// fn(set_q1w_defammo) if new q1 defs are set by bit and no ammo is added for that wep, set base amount

void(float wb, entity e) set_q1w_defammo =
{
	if (wb & (IT_SHOTGUN | IT_SUPER_SHOTGUN)) if (e.ammo_shells < 1) e.ammo_shells = DEF_AMMO_BASE;	// 25
	if (wb & IT_MJOLNIR) if (e.ammo_cells < 1) e.ammo_cells = DEF_AMMO_BASE * 3;
	if (wb & IT_LIGHTNING) if (e.ammo_cells < 1) e.ammo_cells = DEF_AMMO_BASE * 2;	
	if (wb & (IT_ROCKET_LAUNCHER | IT_GRENADE_LAUNCHER)) if (e.ammo_rockets < 1) e.ammo_rockets = DEF_AMMO_BASE / 2.5;	
	if (wb & (IT_NAILGUN | IT_SUPER_NAILGUN)) if (e.ammo_nails < 1) e.ammo_nails = DEF_AMMO_BASE * 2;	
};

// fn(new_q1w_defammo) see if more q1 weps got set after set_xweap, if so check def ammo

void(float wb, float ic, entity e) new_q1w_defammo =
{
	local float f;

	if (!wb) return;
	if (!e) return;
	f = 1;
	while (f != 256)
	{
		if ((wb & f) && !(ic & f))
			set_q1w_defammo(f, e);
		f = f * 2;
	}
};

void(entity xw, entity e) set_xw_defammo =
{
	if (xw.lip == AMMO_BULLETS) if (e.ammo_bullet < 1) e.ammo_bullet = DEF_AMMO_BASE * 2;	
	if (xw.lip == AMMO_SHELLS) if (e.ammo_shells < 1) e.ammo_shells = DEF_AMMO_BASE;	// 25
	if (xw.lip == AMMO_CELLS) if (e.ammo_cells < 1) e.ammo_cells = DEF_AMMO_BASE * 2;	
	if (xw.lip == AMMO_NAILS) if (e.ammo_nails < 1) e.ammo_nails = DEF_AMMO_BASE * 2;	
	if (xw.lip == AMMO_ROCKETS) if (e.ammo_rockets < 1) e.ammo_rockets = DEF_AMMO_BASE / 2.5;	
	if (xw.lip == AMMO_GRENADES) if (e.ammo_rockets < 1) e.ammo_rockets = DEF_AMMO_BASE / 2.5;	
	if (xw.lip == AMMO_SLUGS) if (e.ammo_slug < 1) e.ammo_slug = DEF_AMMO_BASE / 2.5;	
};

// fn(set_defaults) - server control of player/bot load defaults
// fn(set_xweap) - attemp to load an xweap or q1 wep by map code
// fn(xw_bit_loop) - given a bit set loop thru getting map codes and calling set_xweap for a give map mode

// e - ent to load (player or bot)
// smc - set map code

void(entity e, float smc) set_xweap =
{
	local float wbt;
	local entity tr;
	local string ssc;

	if (!e) return;
	wbt = valid_wep_mcode(smc); // make sure this is a valid weapon & get inv. bit


// TESTING
spawn_infot(2, "set bits = ", "",  "",  "",  " -- items: ", wbt, 0, 0, 0, v0, e.items);


	if (!wbt || wbt & e.items) return; // no bit or already got one - IDEA: code an axe swap ??

	if ((smc >= MC_AXE && smc <= MC_THUNDER) || smc == MC_HIP_MJOLNIR) // NOTE: q1 weapon map codes MUST be sequential for condition here
	{
		e.items = e.items | wbt;
		set_q1w_defammo(wbt, e);
		return;
	}
	ssc = item_by_mcode(smc);
	if (ssc) tr = vload(e, wbt);
	if (tr)
	{
		xwep_fakeload (tr, 0, 0, ssc, wbt);
		e.items = e.items | tr.items;
		set_xw_defammo(tr, e); // make sure we have ammo



// TESTING
spawn_infot(2, "x item bits = ", " -- x wep = ",  "",  "",  " -- items: ", tr.items, tr.weapon, 0, 0, v0, e.items);
spawn_infot(1, "vwepent:  ", tr.netname,  "\nmapcode: ",  "",  "", 0, 0, smc, 0, v0, 0);
zz=3;



	}

};

// fn(xw_parm) - handle xweps for level chg

// e - player / bot to handle

// bit information is continuously maintained in player / bot .mcode & .scode
// scode - bits to remove from items so xweap are not converted into regular weps
// mcode - map code of unholstered xweap to reload after level change

void (entity e) xw_parm =
{
	local entity tr;

	tr = e.vwepent;
	e.scode = 0;

	if (X_CHGLVL)
	if (e.eweapon)
		e.mcode = e.eweapon.mcode;

	while (tr)
	{
		if (tr != e.eweapon)
		{			
			if (tr.netname == "Grappling hook") e.scode = e.scode | 512; // special - grapples
			else
			if (tr.mcode) e.scode = e.scode | (tr.weapon & 254); // only clear std weps - must have axe & shotgun on new level
		}
		tr = tr.vwepent;
	}
};

void(entity e, float bl) xw_bit_loop =
{
	local float f, b, mc;

	if (!bl) return;
	if (!e) return;
	f = 1;
	while (f != 8192)
	{
		b = bl & f;
		mc = wepbit_mcode(b, MAP_MODE);
//spawn_infot(-2, "xwbitloop bit call = ", "mask  = ",  " -- map code: ",  "",  "bits sent = ", b, f, mc, 0, v0, bl);
		if (mc)
			set_xweap(e, mc);
		f = f * 2;
		if (f == 256) f = IT_AXE;
	}
}

// e - ent to set (player or bot)
// defaults read from server var *

// return numeric (morphic) char code for a given map mode
float(string mm) set_char_num =
{
	local float cn;
	
	cn = CHAR_Q;
	if (mm == "W") cn = CHAR_W;
	if (mm == "D") cn = CHAR_D;
	if (mm == "Q") cn = CHAR_Q;
	if (mm == "PK") cn = CHAR_PK;
	if (mm == "Q2") cn = CHAR_Q2;
	if (mm == "Q3") cn = CHAR_Q3;
	return(cn);
};

// NOTE: q1 & pk mode wep add can be without ammo

void(entity e) set_defaults =
{
	local float ic, i0;

// here in case chase cam code doesnt get run - setnewparms may not hit these
	e.eweapon = world;
	e.pkprevweapon = e.pklastweapon = e.prevweapon = e.lastweapon = 0;

	e.x_items = x_item_dm_giveaway; // for door keys in dm - only set by doors in dm

	e.ammo_bullet = e.ammo_slug = e.ammo_gaspr = e.ammo_hgrenade = 0;
	e.pkplus_egoammo = e.pkplus_tombammo = e.pkplus_actorammo = e.pkplus_phoneammo = 0;
	e.pk_gravitywellammo = e.pk_turretammo = e.pk_canpabammo = e.pk_beartrapammo = e.pk_explode_ammo = 0;

	if (Q_100 || PK_100) return;

// NOTE: muddy area for morphs.  how to handle all this - maybe convert health by modifier?
//					check to see if morph can use any of the give away eweaps?
	if (!self.mask_x & CB_HUMAN) return;


	if (DEF_HEALTH) e.health = fabs(DEF_HEALTH);
	if (DEF_ARMOR)
	{
		e.armorvalue = fabs(DEF_ARMOR);
		e.armortype = DEF_ATYPE;
		if (e.armorvalue > 100)
		{
			e.armortype = DEF_ATYPE * 2;
			e.items = e.items | IT_ARMOR2;
		}
		else
			e.items = e.items | IT_ARMOR1;
	}

	if (DEF_WEAPON & DEF_REMWEP) // remove any default weps set by code
	{
		e.items = e.items - (e.items & WEP_MASK);
		e.weapon = 0; 
	}

	if (DEF_WEAPON & DEF_REMAMMO) // remove any default ammo set by code
	{
		e.ammo_shells = 0;
		e.ammo_nails = 0;
		e.ammo_rockets = 0;
		e.ammo_cells = 0;
		e.ammo_nails = 0;
		e.ammo_slug = 0;
		e.ammo_gaspr = 0;
	}

	if (DEF_AMMO_BULLETS) e.ammo_bullet = fabs(DEF_AMMO_BULLETS);
	if (DEF_AMMO_SHELLS) e.ammo_shells = fabs(DEF_AMMO_SHELLS);
	if (DEF_AMMO_CELLS) e.ammo_cells = fabs(DEF_AMMO_CELLS);
	if (DEF_AMMO_ROCKETS) e.ammo_rockets = fabs(DEF_AMMO_ROCKETS);
	if (DEF_AMMO_NAILS) e.ammo_nails = fabs(DEF_AMMO_NAILS);
	if (DEF_AMMO_SLUGS) e.ammo_slug = fabs(DEF_AMMO_SLUGS);
	if (DEF_AMMO_GAS) e.ammo_gaspr = fabs(DEF_AMMO_GAS);

	DEF_WEAPON = DEF_WEAPON & WEP_MASK; // mask off remove bits

// char init

	if (CHAR_CON)
	{
		if (!e.morphy)
		if (CHAR_CON >= CHAR_W && CHAR_CON  <= CHAR_Q3) e.morphy = CHAR_CON;
		else e.morphy = set_char_num(MAP_MODE);
// TDO: set model, mdl, etc - done in morph call
	}

// x weapon inits

	if (INIT_CON)
	{
		i0 = e.items & WEP_MASK; // if init changes def weps we need to allow for a default it_axe
		if (INIT_CON & FL_INIT_ARB_MC)
		{
			if (INIT_0_W > 0) set_xweap(e, INIT_0_W);
			if (INIT_1_D > 0) set_xweap(e, INIT_1_D);
			if (INIT_2_Q > 0) set_xweap(e, INIT_2_Q);
			if (INIT_3_PK > 0) set_xweap(e, INIT_3_PK);
			if (INIT_4_Q2 > 0) set_xweap(e, INIT_4_Q2);
			if (INIT_5_Q3 > 0) set_xweap(e, INIT_5_Q3);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP);
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_MGEN_BIT) // genre by map using bits
		{
			if (MAP_MODE == "W") xw_bit_loop(e, INIT_0_W);
			if (MAP_MODE == "D") xw_bit_loop(e, INIT_1_D);
			if (MAP_MODE == "Q") xw_bit_loop(e, INIT_2_Q);
			if (MAP_MODE == "PK") xw_bit_loop(e, INIT_3_PK); // really same weps as q1, but allows setting other weps for pk maps
			if (MAP_MODE == "Q2") xw_bit_loop(e, INIT_4_Q2);
			if (MAP_MODE == "Q3") xw_bit_loop(e, INIT_5_Q3);
	//		if (MAP_MODE == "HP") xw_bit_loop(INIT_6_HP);
	//		if (MAP_MODE == "") xw_bit_loop(INIT_7);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); // 2 extra map code weps
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_MGEN_MC) // genre by map using code - 1 per + 2 for all
		{
			if (INIT_0_W > 0 && MAP_MODE == "W") set_xweap(e, INIT_0_W);
			if (INIT_1_D > 0 && MAP_MODE == "D") set_xweap(e, INIT_1_D);
			if (INIT_2_Q > 0 && MAP_MODE == "Q")set_xweap(e, INIT_2_Q);
			if (INIT_3_PK > 0 && MAP_MODE == "PK") set_xweap(e, INIT_3_PK);
			if (INIT_4_Q2 > 0 && MAP_MODE == "Q2") set_xweap(e, INIT_4_Q2);
			if (INIT_5_Q3 > 0 && MAP_MODE == "Q3") set_xweap(e, INIT_5_Q3);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); //  && MAP_MODE == "HP") set_xweap(e, INIT_6_HP); // goes to all for now
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_CGEN_BIT) // genre by char using bits
		{
			if (e.morphy == CHAR_W) xw_bit_loop(e, INIT_0_W);
			if (e.morphy == CHAR_D) xw_bit_loop(e, INIT_1_D);
			if (e.morphy == CHAR_Q) xw_bit_loop(e, INIT_2_Q);
//			if (e.morphy == CHAR_PK) xw_bit_loop(e, INIT_3_PK); // not going to have pk char mode - maybe some other morph class
			if (INIT_3_PK > 0) set_xweap(e, INIT_3_PK);
			if (e.morphy == CHAR_Q2) xw_bit_loop(e, INIT_4_Q2);
			if (e.morphy == CHAR_Q3) xw_bit_loop(e, INIT_5_Q3);
	//		if (e.morphy == "") xw_bit_loop(INIT_7);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); // 2 extra map code weps
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_CGEN_MC) // genre by char using code - 1 per + 2 for all
		{
			if (INIT_0_W > 0 && e.morphy == CHAR_W) set_xweap(e, INIT_0_W);
			if (INIT_1_D > 0 && e.morphy == CHAR_D) set_xweap(e, INIT_1_D);
			if (INIT_2_Q > 0 && e.morphy == CHAR_Q)set_xweap(e, INIT_2_Q);
//			if (INIT_3_PK > 0 && e.morphy == CHAR_PK) set_xweap(e, INIT_3_PK);
			if (INIT_3_PK > 0) set_xweap(e, INIT_3_PK);
			if (INIT_4_Q2 > 0 && e.morphy == CHAR_Q2) set_xweap(e, INIT_4_Q2);
			if (INIT_5_Q3 > 0 && e.morphy == CHAR_Q3) set_xweap(e, INIT_5_Q3);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); //  && e.morphy == "HP") set_xweap(e, INIT_6_HP); // goes to all for now
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}

		ic = e.items & WEP_MASK; // weps set by init - have to see q1 weps added outside of set_xweap
		if (ic != i0)
		if (!DEF_WEAPON)
		if (ic & IT_AXE) DEF_WEAPON = IT_AXE; // allow replacement x weps to default axe bit if present - otherwise we add a q1 shotgun
	}

	if (DEF_ITEMS) e.items = e.items | DEF_ITEMS; // NOTE: this is an add in, might need vw coding later

	if (DEF_WEAPON) // NOTE: happens after weapons inits to be coded
	{
		if (! e.items & DEF_WEAPON) // see if item bit is set
			e.items = e.items | DEF_WEAPON;
		e.weapon = return_bit(DEF_WEAPON, 255, BIT_HIGH, 0); // pick 1 bit - highest
		if (!e.weapon && (e.items & IT_AXE) && (DEF_WEAPON & IT_AXE)) e.weapon = IT_AXE; // can init & def weapon axe as only weapon
	}
	new_q1w_defammo(e.items & WEP_MASK, ic, e);

	if (DEF_X_ITEMS) e.x_items = e.x_items | DEF_X_ITEMS; // NOTE: this might entail vw adds later

	if (!(INIT_CON & FL_INIT_PKO) || (MAP_MODE == "PK")) // can restrict pk items to pk mode only with flag in init_con
	if (DEF_PK_ITEMS & PK_ITEM_MASK) // pk items works differently
	{
		if (DEF_PK_ITEMS & PK_IT_BEARTRAP) e.pk_beartrapammo = 2;
		if (DEF_PK_ITEMS & PK_IT_TURRET) e.pk_turretammo = 2;
		if (DEF_PK_ITEMS & PK_IT_GRAVITYWELL) e.pk_gravitywellammo = 1;
		if (DEF_PK_ITEMS & PK_IT_CANPAB) e.pk_canpabammo = 1;
		if (DEF_PK_ITEMS & PKPLUS_IT_EGO) e.pkplus_egoammo = 1;
		if (DEF_PK_ITEMS & PKPLUS_IT_TOMB) e.pkplus_tombammo =2;
		if (DEF_PK_ITEMS & PKPLUS_IT_ACTOR) e.pkplus_actorammo = 1;
		if (DEF_PK_ITEMS & PKPLUS_IT_PHONE) e.pkplus_phoneammo = 1;
		e.pk_items = e.pk_items | (DEF_PK_ITEMS & (PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT));
	}

	if(! e.items & IT_AXE) e.items = e.items | IT_AXE; // MUST have an axe slot item for pk items & wep cycles!

	if (! e.weapon) // didnt set a default 
	{
		if (e.pk_items & PK_IT_CLIGHT) // have clg - default it
		{
			e.weapon = IT_AXE;
			e.pk_currentitem = PK_IT_CLIGHT;
			set_q1w_defammo(IT_LIGHTNING, e); // check ammo
			return;
		}
		e.weapon = return_bit(e.items, 255, BIT_HIGH, 0);
		if (!e.weapon) // for now no one is without a range weapon def if DEF_WEAPON doesnt say otherwise
		{
			e.weapon = 1;
			e.items = e.items | 1;
			set_q1w_defammo(IT_SHOTGUN, e);
			if (!(INIT_CON & 15)) // no genre controls, pick a shotgun at random - TEST: effects of ULOK* on this code set
			{
				if (random() < 0.3) set_xweap(e, MC_D_SHOTGUN);
				else if (random() < 0.2) set_xweap(e, MC_Q2_SHOTGUN);
				else if (random() < 0.45) set_xweap(e, MC_Q3_SHOTGUN);
			}
		}
	}
	e.eweapon = vchk(e.weapon, e.pk_currentitem, e.vwepent);

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
		sprint(e, ftos(rint(e.ammo_bullet)));
		sprint(e, " bullets");
		am_type = am_type | IT_BULLETS;
	}
	else if (am == AMMO_SHELLS && !(am_type & IT_SHELLS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_shells)));
		sprint(e, " shells");
		am_type = am_type | IT_SHELLS;
	}
	else if (am == AMMO_CELLS && !(am_type & IT_CELLS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_cells)));
		sprint(e, " cells");
		am_type = am_type | IT_CELLS;
	}
	else if (am == AMMO_ROCKETS && !(am_type & IT_ROCKETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_rockets)));
		sprint(e, " rockets");
		am_type = am_type | IT_ROCKETS;
	}
	else if (am == AMMO_GRENADES && !(am_type & IT_ROCKETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_rockets)));
		sprint(e, " grenades");
//		am_type = am_type | IT_ROCKETS;
	}
	else if (am == AMMO_NAILS && !(am_type & IT_NAILS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_nails)));
		sprint(e, " nails");
		am_type = am_type | IT_NAILS;
	}
	else if (am == AMMO_SLUGS && !(am_type & IT_SLUGS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_slug)));
		sprint(e, " slugs");
		am_type = am_type | IT_SLUGS;
	}
	else if (am == AMMO_GAS && !(am_type & IT_GAS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_gaspr)));
		sprint(e, " lbs gas pressure");
		am_type = am_type | IT_GAS;
	}
	else if (am == PK_IT_GRAPGUN && e.pk_items & am)
	{
	local entity f;
	local string nt;

		if (pr != "") sprint(e, pr);
/*
		nt = "Harpoon gun";
		f = vchk(IT_AXE, am, e.vwepent);
		if (f)
		if (f.netname)
		{
			nt = f.netname;
		}

		sprint(e, nt);
		sprint(e, "\n");
*/
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
/*	else if (wp == IT_MJOLNIR)
	{
		sprint(self, "Thor's Hammer");
		eweap_am(self, AMMO_CELLS, "   -> ");
		sprint(self, "\n");
	}*/

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
			if (f <= IT_MJOLNIR || f == IT_AXE)
			{
				k = 0;
				if (f == IT_AXE) k = PK_IT_AXE;
				e = vchk(f, k, self.vwepent);
			}
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

			if (f == IT_MJOLNIR) // skip bits 256 - 2048
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
						e = world;
						e = vchk(IT_AXE, k, self.vwepent);
						if (e)
						{
							if (e.eweapon)
							{
								sprint(self, e.netname);
								eweap_am(self, e.lip, "   -> ");
								sprint(self, "\n");
							}
							else
								eweap_am(self, k, pk_pr);
						}
						else
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
		if (self.x_items & X_INV) sprint(self, "-\nX Items:\n");
		if (self.x_items & X_PWR_ARM_INV)
		{
			sprint(self, "Powered armor\n");
		}
		if (self.x_items & X_Q2_KEY_BIT) // IDEA: bit list or key list (dep on map genre)?
		{
			sprint(self, "extra key(s)\n");
		}
		if (self.x_items & X_D_MAP)
		{
			sprint(self, "an automap\n");
		}
		if (self.x_items & X_D_VIS)
		{
			sprint(self, "night vision goggles\n");
		}
		if (self.rune_flag & RUNE_MASK_ALL) sprint(self, "-\nRunes of power\n");
	}

	am_type = 0;
}
