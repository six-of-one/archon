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
	precache_model (null_model); // Cataboligne 8.8.9 purify - chase cam

// sounds
	precache_sound ("reggun/fire4.wav");

//	precache_model ("progs/bit.mdl"); - not used
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
	precache_model ("progs/lzrbm_seg.mdl");
	precache_model ("progs/g_flamer2.mdl");
	precache_model ("progs/g_gas.mdl");
	precache_model ("progs/vw_flamer2.mdl");
	precache_model ("progs/vw_gascyl.mdl");
	precache_model ("progs/vw_qgun.mdl");
	precache_model ("progs/g_deepsleep.mdl");
	precache_model ("progs/vw_deepsleep.mdl");
	precache_model ("progs/steam.mdl");
//	precache_model ("progs/snowball.mdl"); // lavaball with no rocket trail
	precache_model ("progs/gib_m.mdl");

// map repair - block hollow brush effect
	precache_model ("progs/abclip.bsp");

// cubes & crates

	precache_model ("progs/pk_cube.bsp");
	precache_model ("progs/8ray_arc.bsp"); // chaos archon morph device
	precache_model ("progs/crate.bsp");
	precache_model ("progs/crate_lg.bsp");
	precache_model ("progs/crate_lg_o1.bsp");
	precache_model ("progs/crate_o1.bsp");
	precache_model ("progs/crate_o2.bsp");
	precache_model ("progs/crate_o3.bsp");
	precache_model ("progs/morph_cube.bsp");
	precache_sound ("sound/chaos/crate1a.wav");
	precache_sound ("sound/chaos/crate1b.wav");
	precache_sound ("sound/chaos/crate1c.wav");
	precache_sound ("sound/chaos/crate1o.wav");

// chaos x weps
	precache_sound ("sound/flm/ft_hum.wav");
	precache_sound ("sound/flm/ft_fire.wav");
	precache_sound ("sound/flm/burning.wav");
	precache_sound ("sound/flm/airhiss1.wav");
	precache_sound ("sound/reggun/fire.wav");
	precache_sound ("sound/reggun/fire4.wav");
	precache_sound ("sound/deepsleep/fire.wav");
	precache_sound ("sound/deepsleep/hit.wav");

// shovel test
	precache_model ("progs/m_shovel.mdl");
	precache_model ("progs/shovel.md3");
	precache_model ("progs/vw_shovel.mdl");

// Quantum tunnel apparatus 
	precache_model ("progs/quantum.mdl");
	precache_model ("progs/v_quantum.mdl");
	precache_model ("progs/m_quantum.mdl");
	precache_model ("progs/vw_quantum.mdl");
	precache_sound ("sound/quantum/qntfire.wav");
	precache_sound ("sound/quantum/qntfail.wav");
	precache_sound ("sound/quantum/chargeup.wav");
	precache_sound ("sound/quantum/shdoff.wav");

// spheres (tele / annihilate)

	precache_model ("progs/sphere_annihilation.mdl");
	precache_sound ("alt_ambience/hum1.wav");

// Alien infestation
	precache_model ("progs/clinger2.mdl");
	precache_model ("progs/young.mdl");

	precache_model ("progs/tall_ball.mdl");

// map hack

// base map
	precache_model ("maps/x4_1.bsp");
// room segs
	precache_model ("maps/x4_2.bsp");
	precache_model ("maps/x4_3.bsp");
	precache_model ("maps/x4_4.bsp");
	precache_model ("maps/x4_5.bsp");
	precache_model ("maps/x4_6.bsp");

//	flamer_precache();
};

string() creg_killmsg =
{
#ifdef enhanced
//	if (ENHANCED)
		return(rnd_string('90.0 60.0 60.0'," got 4 loads of 00 buck from "," was just like a little troll for ",null_string,null_string," was blown away by "));
#endifdef

	return " was blown away by ";
};

string() creg_killmsg2 =
{
#ifdef enhanced
//	if (ENHANCED && random() < 0.23)
	if (random() < 0.23)
		return "'s Reggie Bannister special\n";
	else
#endifdef
	return "'s quad shotgun\n";
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
	self.bulletspread = '0.20 0.06 0'; // bullet spread out

	setmodel (self, "progs/m_reggun.mdl");
	self.weaponmodel = "progs/v_reggun.mdl";
	self.vwepmdl = "progs/vw_reggun.mdl";
	self.noise3 = "reggun/fire4.wav";
	if (ULOKD)
	{
		self.noise = "doom/dswpnup.wav";
		self.noise4 = "doom/dsitembk.wav";
	}
	else
	{
		self.noise = "weapons/pkup.wav";
		self.noise4 = "items/itembk2.wav";
	}

	self.duration = SND_OVER;

	self._killmsg = creg_killmsg;
	self._killmsg2 = creg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "x_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;

	self.archon = ARCHON_WEP_EXT;
};

string() csh_killmsg =
{
#ifdef enhanced
//	if (ENHANCED)
		return(rnd_string('90.0 60.0 60.0'," got a splitting head ache from "," was comparing his gun with ",null_string,null_string," was dug a grave by "));
#endifdef

	return " was dug a grave by ";
};

string() csh_killmsg2 =
{
	return "'s shovel\n";
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
	if (DARKPLACES) setmodel (self, "progs/shovel.md3"); // TESTING - remove
	self.weaponmodel = "progs/v_axe.mdl";
	self.vwepmdl = "progs/vw_shovel.mdl";
	self.vv_draw = vw_melee_base;

//	self.noise1 = "weapons/ax1.wav"; // missed
	self.noise3 = "player/axhit2.wav"; // hit wall &| solid
//	self.noise4 = "zombie/z_hit.wav"; // hit flesh

	self._killmsg = csh_killmsg;
	self._killmsg2 = csh_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "x_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN;

	self.archon = ARCHON_WEP_EXT;
};

string() cds_killmsg =
{
#ifdef enhanced
//	if (ENHANCED)
		return(rnd_string('90.0 60.0 60.0'," didnt find sanctuary because of "," should have went to carosel instead of running from ",null_string,null_string," stopped running for "));
#endifdef

	return " stopped running for ";
};

string() cds_killmsg2 =
{
	return "\n";
};

// deepsleep blast effect at target point
void() DeepSleepBlst_tht =
{
	local float k; // , f;

//	f = rint(2 + random());

//	while (f > 0)
//	{
	k = 2 + random() * 4; // some depth
	self.finaldest = (self.origin + crandom() * self.bulletspread_x * self.pos2 + crandom() * self.bulletspread_y * self.pos1) - self.movedir * k;


#ifdef warning
if (WARNING & 2)
{
bprint("\b *** deepsleep blast org: ");
bprint(vtos(self.finaldest));
bprint("\n");
}
#endifdef


	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST,self.finaldest_x);
	WriteCoord (MSG_BROADCAST,self.finaldest_y);
	WriteCoord (MSG_BROADCAST,self.finaldest_z);
//		f = f - 1;
//	}

	if (self.noise)
	{
		sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM);
		self.noise = null_string;
	}

	self.cnt = self.cnt - 1;
	if (self.cnt < 0) remove(self);
	else
	self.nextthink = time + 0.03;
};

void(vector dir1, vector end1, vector bspread, string snd1) X_DeepSleepBlst =
{
	newmis = spawn();
	newmis.think = DeepSleepBlst_tht;
	newmis.nextthink = time + 0.03;
	newmis.cnt = 5 + 5 * random();
	newmis.owner = EWEAP;
// located
	newmis.origin = end1;
	newmis.movedir = dir1;
	newmis.bulletspread = bspread;
	newmis.pos1 = v_up;
	newmis.pos2 = v_right;
	newmis.noise = snd1;
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
	self.bulletspread = '0.03 0.03 0';
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	self.vv_draw = vw_melee_base;

	setmodel (self, "progs/g_deepsleep.mdl");
	self.weaponmodel = "progs/v_deepsleep.mdl";
	self.vwepmdl = "progs/vw_deepsleep.mdl";
	self.noise3 = "sound/deepsleep/fire.wav";
	self.target = "sound/deepsleep/hit.wav";

	self._killmsg = cds_killmsg;
	self._killmsg2 = cds_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "x_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN;

	self.archon = ARCHON_WEP_EXT;
};


string() tsphere_killmsg =
{
#ifdef enhanced
//	if (ENHANCED)
		return(rnd_string('90.0 60.0 60.0'," joined the Tall Man because of "," was given a mind altering experience by ",null_string,null_string," was drilled by "));
#endifdef

	return " joined the Tall Man because of ";
};

string() tsphere_killmsg2 =
{
	return "\n";
};

// Tall Mans killing ball - as you know it and love it, the silver (and gold) sphere(s) from Phantasm

void () c_weapon_tallball =
{
	q100_weapon_supershotgun();

	self.netname = "Phantasm Sphere";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_pistol1;

	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = AMMO_NONE;
	self.attack_finished = 1;
	self.dmg = 3;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;

	self.vv_draw = vw_melee_base;

	setmodel (self, "progs/tall_ball.mdl");
	self.weaponmodel = "progs/tall_ball.mdl";
	self.vwepmdl = "progs/tall_ball.mdl";
//	self.noise3 = "q2_snd/blastf1a.wav";
//	self.target = "q2_snd/lashit.wav";

	self._killmsg = tsphere_killmsg;
	self._killmsg2 = tsphere_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "x_item";
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_WEP_EXT;
};

// from chaos mod

// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount6, float ignore) T_Heal =
{
	local float heala, f;

//		return(q10-_T_Heal(e, healamount6, ignore));

	if (e.mask_x & MORPH_ARCHON)
		return 0;

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

	return 1;
};

// Cataboligne - 9.9.11 - tweak to prevent multiple health rots on 1 avatar
float Smd;

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
	smax = (Q_NORM_MAX * ehm) + (smax * smd); // morph adjusted max
	return (smax);
}

//float() health_touch =
void() health_touch =
{
	local	float amount, smax, vmax;
	local	string	s1;

//		q10-_health_touch();

	vmax = amount = 0;

	if (other.state == IMP_MWRAITH) return; //(TRUE); // wraith never get health -- CHECK: check state field for wraiths (when we have them)

	if (other.rune_flag & RUNE_VAMPIRE)
	{
		if (other.health >= (other.max_health * other.health_modifier)) // vampires dont get health above max
			return;
		if (self.healtype > HEAL_NORM) // not for suck heads, even on a bad day
			return;
		vmax = 5;
	}

	Q3_HAH_TMP = other.health;
	Q3_HAA_TMP = other.armorvalue;

	if (self.healtype > HEAL_NORM) // Soul, Mega, health bottle  Ignore max_health...
	{
#ifdef enhanced
// dont get inf or mega health for absurd large health + armor
	if (self.volume != -1)
	if (other.health + other.armorvalue > 450) // ablrgh - 10.12.14
		return;

// dont get inf or mega health for absurdly even larger health + armor
	if (other.health_modifier > 2.0)
	if (other.health + other.armorvalue > 550) // ablrgh - 10.12.14
		return;	
#endifdef

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

#ifdef warning
																							if (WARNING & 2)
																							if (amount)
																							{
																								bprint("health boost scale: ");
																								bprint(ftos(amount));
																								bprint(", total: ");
																								bprint(ftos(self.healamount + amount));
																								bprint("\n");
																							}
#endifdef

		if (vmax)
		{
			if (!T_Heal(other, vmax, 0)) return; //(TRUE);
		}
		else
		if (!T_Heal(other, self.healamount + amount, 0))
			return; //(TRUE);
	}

	if (!other.rune_flag & RUNE_VAMPIRE)
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
	
	self.model = null_string;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health

	if (self.healtype == HEAL_MEGA)
#ifdef enhanced
//	if ((!other.rune_flag & RUNE_FLG_RG) || !ENHANCED)
//	if ((!other.rune_flag & TECH_ADOC) || !ENHANCED)
//	if ((!other.rune_flag & RUNE_VAMPIRE) || !ENHANCED)
	if (!other.rune_flag & RUNE_FLG_RG)
	if (!other.rune_flag & TECH_ADOC)
	if (!other.rune_flag & RUNE_VAMPIRE)
#endifdef
	{
		if (!other.items & IT_SUPERHEALTH) // not already rotting - start it up
		{
			self.nextthink = time + 5;
			self.think = item_megahealth_rot;
			self.owner = other;
			self.duration = self.healamount; // for drop items
			self.map = "mega_health_rot";
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
			if (self.wait)
				self.nextthink = time + self.wait;
			else
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

	if (self.stack1 == "q3_hold") // for holdables - since they use pk slots, tho the corollary of collecting a pk item is not tested
//	if (self.class_select == "q3_item")  // cant test - translation issue
	if (self.pk_currentitem) // 'es already got one...wot?  'e sais 'yve already got one.  already got a Grail?
	{
		if (other.pk_canpabammo && self.pk_currentitem == PK_IT_CANPAB) return;
		if (other.pkplus_phoneammo && self.pk_currentitem == PKPLUS_IT_PHONE) return;
		e2 = vchk(self.items, self.pk_currentitem, other.vwepent);
		other.x_items = other.x_items | self.x_items;

		if (!e2)
			e2 = x_wep_store(world, self.items, 1);
		else
			return;
	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	if (deathmatch != 4) // *pk - my new rule, logical extrapolation
	if (deathmatch)
	{
		self.mdl = self.model;
		if (self.wait && self.class_select == "q3_item") // q3 wait code react
			self.nextthink = time + self.wait;
		else
		self.nextthink = time + RSP_TIME * 2; // = 60 default
		self.think = SUB_regen;
	}

//	other.target2 = self.model; // for inventory toss - moved to touch

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = null_string;

// so we can say what we need to when done
	if (self.group) // NOTE: could already have a .message
	{
		other.group = self.group;
	}

	t = self.dmgtime;
	if (!t) t = POW_TIME;

	if (self.netname == "Wetsuit")
	{
		if (VW)
		if (self.lip > 0) 
		if (other.mask_x & CB_HUMAN)
			other.skin = self.lip;  // set skin for suit
		other.rad_time = 1;
		if (other.wetsuit_finished < time)
			other.wetsuit_finished = time + t;
		else
			other.wetsuit_finished = other.wetsuit_finished + t;
	}
	else // wetsuit has suit items set - cant exec next bit

	if (self.items == IT_SUIT)
	{
		if (VW)
		if (self.lip > 0) 
		if (other.mask_x & CB_HUMAN)
			other.skin = self.lip;  // set skin for suit
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
		if (self.mdl == "progs/d_berzerk.mdl") // special - doom berserk - IMP: red vision haze
		{
			health_touch();
			other.healtype = HEALT_CURE; // fire, plague & continous health rot stop
		}

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
			other.wetsuit_finished = other.wetsuit_finished + t; // note - this can extend wetsuit time
	}

	if (self.netname == "Silencer")
	{
		if (other.silencer_finished < time)
			other.silencer_finished = time + t;
		else
			other.silencer_finished = other.silencer_finished + t;
	}

// handle hip ents
	if (self.netname == "Horn of Conjuring")
	{
		activator = other;
		horn_active = 1;
		horn_charmer = other;
		if (self.target)
			SUB_UseTargets();				// fire all targets / killtargets
		else
		{
			if (!self.movetarget) self.movetarget = spawn(); // make a maker
			setorigin (self.movetarget, self.origin + '0 0 20'); // appears where horn is - adjusted up 9.22.13, some monsters still bury feet in ground
			self.movetarget.classname = "func_make";
			self.movetarget.think = func_make;
			self.movetarget.spawnflags = 0;
			self.movetarget.nextthink = time + 2 + random() * 3;
			self.movetarget.wait = -10; // make a random monster
			self.movetarget.count = self.movetarget.delay = 0; // only make 1
			self.movetarget.charmer = other; // horn conjured monster
			self.movetarget.mask_x = 0; // any q1 -fish -cthon -shubs
			if (random() < 0.9) // hip horn default
				self.movetarget.mask_x =  CB_M_DOG + CB_M_DEMON + CB_M_OGRE + CB_M_SHAMBL + CB_M_ZOMBY;			
		}
		horn_active = 0;
	}

	if (self.netname == "Empathy Shields")
	{
		other.empathy_time = 1;
		if (other.empathy_finished < time)
			other.empathy_finished = time + t;
		else
			other.empathy_finished = other.empathy_finished + t;
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
		e.nextthink = time + 1;//t - 1; //POW_TIME - 1;
		if (self.items == IT_SUIT)
			e.enemy.skin = Q3_SH_ENV;
		if (self.items == IT_QUAD)
			e.enemy.skin = Q3_SH_QUAD;
		e.items = self.items;
		e.teamname = self.classname; // for stack fix
		e.wad = "art_shell";
	}

	activator = other;
	if (self.netname != "Horn of Conjuring")
	SUB_UseTargets();				// fire all targets / killtargets
};

// x ammo pack touch & bounds

void() x_pack_touch =
{
	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
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

	if (self.noise != null_string)
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM); // default is q1 pack grab snd - in bp code

	self.model = null_string;
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
		}
		else if (other.target1 == "progs/d_pack.mdl")
		{
			bl_mx	= 400;
			sh_mx	= 100;
			rk_mx	= 100;
			cl_mx	= 600;
		}
		else if (other.target1 == "progs/q2_pack.mdl")
		{
			bl_mx	= 300;
			sh_mx	= 200;
			rk_mx	= 100;
			cl_mx	= 300;
			sl_mx	= 100;
		}
		else if (other.target1 == "progs/q2_bando.mdl")
		{
			bl_mx	= 250;
			sh_mx	= 150;
			rk_mx	= 50;
			cl_mx	= 250;
			sl_mx	= 75;
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

// target practice dummy

// ideas - think fn to always face player, model &| skin with appr. appearance
// REMOVE from gold / beta
var float autocvar_sv_c_silnores = 0; // turn off respawn

void() silhouette_respawn =
{
	if (autocvar_sv_c_silnores)
	{
		remove(self);
		return;
	}
	setmodel(self, self.mdl);
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = self.max_health;
	self.takedamage = DAMAGE_AIM;
	self.solid = self.lefty;
};

// idea - death frames - fall over

void() silhouette_death =
{
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.model = null_string;
	self.think = silhouette_respawn;
	self.nextthink = time + self.wait;
	self.deadflag = MAXFL; // dont let random mortician remove this guy
};

/*QUAKED monster_silhouette (1 0 0) (-16 -16 -24) (16 16 40) LARGE
Target practice dummy

Takes damage, gets killed - default model is monster_army

"large" - use larger bounding box size
"health" - damage before death
"wait" - respawn time
*/

// note - on making monsters - engine takes one of .th_* and assigns it to think when things (like damage) happen to monster

// REMOVE from gold / beta
// block these for testing
//var float autocvar_sv_c_nosil = 0;

void() monster_silhouette =
{
/*
	if (autocvar_sv_c_nosil)
	{
		remove(self);
		return;
	}
*/
	
	if (!self.model)
	{
		self.model = "progs/soldier.mdl";
		self.skin = 1;
	}
	precache_model (self.model);
	setmodel(self, self.model);
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);

	if (self.count) self.frame = self.count; // hack - for rf6 converted func_models
	if (self.cnt) self.skin = self.cnt;

	if (self.spawnflags & 1)
		setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	if (!self.solid) self.solid = SOLID_SLIDEBOX;
	self.lefty = self.solid;
	if (! self.movetype) self.movetype = MOVETYPE_STEP;
	if (!self.wait) self.wait = 30;

	if (self.health <= 0) self.health = 100;
	self.mdl = self.model;

	self.think = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.th_die = silhouette_death;
// all set in _start
//	self.takedamage = DAMAGE_AIM;
//	self.max_health = self.health;
//	self.flags = self.flags | FL_MONSTER; // for wep targeting, some weps
	
	walkmonster_start();
};


// quantlet things

/*QUAKED monster_generator (1 0 0) (-27 -27 0) (27 27 60) RESPAWN DM
-------- QNTL --------
You must set the key "target" to a sequence of targets that start matching "targetname".

Flags:
spawnflags: 1 = respawn, 2 = appears in DM

"mask"
if more than one bit is set monsters will be selected randomly
default - 2053

mask_x:

ARMY			= 1
FISH			= 2
KNIGHT			= 4
DOG				= 8
DEMON			= 16
ENF				= 32
HKNIGHT			= 64
OGRE			= 128
SHALR			= 256
SHAMBL			= 512
SCRAG			= 1024
ZOMBY			= 2048
CTHON			= 4096 // boss
TARBABY			= 8192
SCOURGE			= 16384
SHUBS			= 32768
SVORE			= 65536 // super vore
GREMLIN			= 131072
VOMIT			= 262144 // guy id left out

mask_y:

BLARG			= 1
RAPTOR			= 2
SPIDER			= 4
MANGA			= 8
BOSSMAN			= 16

Keys:
"target" - should point to a spawn point sequence
"health" - health for generator - defaults to 100, -1 health = can not be shot
"max_health" - if set give any generted monster this health, otherwise default
"targetname" - if set generator will only be fired by a trigger
"speed" - if not targeted, generate a monster every {#} rels
"delay" - if set pause for wait rels after generating for delay rels
 - if negative, slow down generation to count %
"count" - slow down if delay is negative - generate 1 in this many - default 1 in 4
"wait" - length of delay pause, -1 to stop
"volume" - generate this many health pts of monsters then stop
"solid" - make solid, 2 = BBOX, 4 = BSP - recommended
"model" - select a generator image -
"scale" - resize generator, monsters, healths

"progs/generator.bsp"
"progs/generator2.bsp"
"progs/generator3.bsp"
"progs/generator3L.bsp"
"progs/gen2_l1.bsp"
"progs/gen2_l2.bsp"
"progs/gen2_l3.bsp"
*/

// make a monster

void() generator_fire =
{
	if (self.volume < 0) return;

	if (!self.targetname)
		self.nextthink = time + self.speed;

	if (cvar("nomonsters"))
	{
		if (!self.targetname) self.nextthink = time + 120; // check back much later if thinking
		return;
	}

// pausing or slowing
	if (self.super_time > time)
	{
		self.rad_time = 0;
		if (self.delay > 0) return;
		else
		{
			self.aflag = self.aflag + 1;
			if (self.aflag < self.count) return;
			self.aflag = 0;
		}
	}
	else
	if (self.delay)
	{
		if (!self.rad_time) self.rad_time = time + fabs(self.delay);
		if (self.rad_time < time) self.super_time = time + self.wait;
	}

// location
	if (self.target)
		self.cnt = cnt_ent(self, "targetname", self.target);

	self.jump_flag = 66;

	while (self.jump_flag > 0)
	{
		self.dropent = self.chain;
//		if (self.spawnflags & 4) // try spots in sequence
//			self.dmg = self.cnt;
//		else
		self.dmg = rint(random() * self.cnt); // try random spots
		while (self.dmg > 1)
		{
//			if (self.spawnflags & 4) // test all spots in order, take 1st open
//			{
//				trace_ent = findradius(self.dropent.origin + '0 0 16', 20); // try to avoid a telefrag
//				if (!trace_ent) self.dmg = self.jump_flag = -1;
//			}
			self.dmg = self.dmg - 1;
			if (self.dropent.chain) self.dropent = self.dropent.chain;
		}
//		if (!self.spawnflags & 4) // test a randomly selected spot
//		{
			trace_ent = findradius(self.dropent.origin + '0 0 16', 20); // try to avoid a telefrag
			if (!trace_ent) self.jump_flag = -1;
//		}
		self.jump_flag = self.jump_flag - 1;
	}

	if (trace_ent)
	{
//		if (self.spawnflags & 4) return;
// chance a filled spot will result in a spawn-frag, otherwise wait
		if (random() < 0.94) return;
	}

	if (!self.dropent)
		self.dest1 = self.origin + '0 64 0';
	else
		self.dest1 = self.dropent.origin;

// monster id
	self.lefty = MON_FUNC_REG;

	self.cnt = rnd_bit_mask(self.mask_x);
	if (!self.cnt && self.mask_y)
	{
		self.cnt = rnd_bit_mask(self.mask_y);
		self.lefty = MON_FUNC_II;
	}
	else
	if (self.cnt && self.mask_y)
	if (random() < 0.33)
	{
		self.cnt = rnd_bit_mask(self.mask_y);
		self.lefty = MON_FUNC_II;
	}

	if (!self.cnt) self.cnt = 1;

	self.weaponmodel = monster_id(self.cnt, self.lefty);

	if (self.weaponmodel == null_string)
	{
		self.weaponmodel = "monster_army";
#ifdef warning
		if (WARNING & 4)
		{
			bprint("*** WARNING - generator spawn assign fail - making soldier\n");
			bprint("*** Assign bit: ");
			bprint(ftos(self.cnt));
			bprint(" - make mode: ");
			bprint(ftos(self.lefty));
			bprint("\n");
		}
#endifdef
	}

	self.dropent = spawn();

	setorigin(self.dropent, self.dest1 + '0 0 4');
	spawn_tdeath(self.dropent.origin, self.dropent);

	self.dropent.event = "dyn_monster";
	self.dropent.msgcount = 0.2; // wake up faster
	self.dropent.wad = self.weaponmodel;
	self.dropent.owner = self;

// monster speed changed by generator
	if (self.wad == CFAST) self.dropent.netname = CFAST;
	else if (self.wad == CSLOW) self.dropent.netname = CSLOW;
	else if (self.wad != null_string) // any non null will cause random here
	{
		if (random() < 0.3) self.dropent.netname = CSLOW;
		else if (random() < 0.3) self.dropent.netname = CFAST;
	}
	
	item_call_save(self.dropent, self.weaponmodel);

	if (self.max_health) self.dropent.health = self.max_health;
	else self.dropent.health = 10;
	self.dropent.health = self.dropent.health * self.scale;
	self.dropent.scale = self.scale;

	if (self.volume)
	{
		self.volume = self.volume - self.dropent.health;
		if (self.volume < 1) self.volume = -1;
	}
};

// IDEA: pop sound option, or explosion *

void() monster_respawn_fire;

void() gen_killed =
{
	self.use = SUB_Null; // turn off generation
	if (self.bubble_count != -1)
	if (self.spawnflags & 1) // respawn
	{
		if (self.bubble_count) // limit
		{
			self.bubble_count = self.bubble_count - 1;
			if (self.bubble_count < 1) self.bubble_count = -1;
		}
		self.model = null_string; // hide this guy
		self.solid = SOLID_NOT;
		self.oldorigin = self.origin;
		self.health = self.dodmg; // restore any health
		self.think = monster_respawn_fire;
		self.nextthink = time + self.wait + 20 * random();
		return;
	}
	self.think = remove_fade;
	remove_fade();
};

void(float ign) monster_generator =
{
if (ign != A_MONSTER) // map monster has no ign
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (deathmatch)
	if (!self.spawnflags & 2) // apearing in dm
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

	precache_model ("progs/gen2_l1.bsp");
}
// defaults
	if (self.scale < 0.1) self.scale = 1;
	if (!self.health) self.health = 100;
	if (!self.speed) self.speed = 2;
	if (!self.count) self.count = 4;
//	if (!self.delay) self.delay = 120;
	if (!self.wait) self.wait = 20;
	if (!self.mask) self.mask_x = 2053;

	if (!self.model)
	{
		if (self.mdl) setmodel(self, self.mdl);
		else setmodel(self, "progs/gen2_l1.bsp");
		if (!self.solid) self.solid = SOLID_BSP;
	}
	else
		setmodel(self, self.model);

// save for respawn
	self.dodmg = self.health;
	self.mdl = self.model;

	self.health = self.health * self.scale;

	if (self.health > 0)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = gen_killed;
	}

	self.archon = 2 * self.health;

	self.use = generator_fire;	

	self.think = generator_fire;

	if (!self.targetname) // not targeted - think
		self.nextthink = time + self.speed;

// respawn comes here
	self.rad_time = self.super_time = 0;

// fix model fsck up - models do not want to recompile - only on map load gens, and only once
	if (self.class_select != "class_generator") self.origin_z = self.origin_z + 24;

//		speed_monster(CSLOW, "monster_ogre", self.origin);
	self.class_select = "class_generator";
};

// quoth dummys & stuff

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/

void () func_detail =
{
// Cataboligne - 4.11.11 - walls not in mod maps
	if (notmod(self)) return;

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self,self.model);
};

/*QUAKED ambient_generalpurpose (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void () ambient_generalpurpose =
{
	precache_sound (self.noise);
	ambientsound (self.origin, self.noise, 1, ATTN_STATIC);
};


void() monster_defender =
{
};

void() monster_eliminator =
{
};

void() monster_gug =
{
};

void() monster_drole =
{
};

void() monster_bob =
{
};

void() monster_pyro =
{
};

void() monster_sentinel =
{
};

void() monster_edie =
{
};

void() monster_ogre_flak =
{
};

void() monster_voreling =
{
};

void() monster_polyp =
{
};

void() monster_death_knight =
{
};

void() monster_death_guard =
{
};

void() monster_death_lord =
{
};

void() monster_gaunt =
{
};

void() monster_vermis =
{
};

void() monster_army_rocket =
{
	self.spawnflags = self.spawnflags | 8;
	monster_army(0);
};












