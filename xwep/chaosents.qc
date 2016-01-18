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

	sprint(other, "You receive ");
	s1 = ftos(self.healamount + amount);
	sprint(other, s1);
	sprint(other, " health\n");
	
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

// oh what dorky code below
		if (deathmatch != 2)		// deathmatch 2 is the silly old rules
		{
			if (deathmatch)
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
