/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: items.qc
 *
 * date: Fri Apr  4 04:31:44 UTC 2008
 *
 * final qc
 *
 */


/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */

void () W_SetCurrentAmmo;
/*
void () q10-_SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
};
*/


/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void () noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos (self.origin));
	dprint ("\n");
	remove (self);
};



/*
============
PlaceItem

plants the object on the floor
============
*
void () q10-_PlaceItem =
{
	local float oldz;

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor(0,0)) // Cataboligne 9.17.3 - fixed this compiler warning
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
		return ;
	}
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void () StartItem =
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

/*
=========================================================================

HEALTH BOX

=========================================================================
*
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float Thealamount, float ignore) q10-_T_Heal =
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	Thealamount = ceil (Thealamount);

	e.health = e.health + Thealamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;

// Cant hard cap here because of q2 bottles
//	if (e.health > 250)
//		e.health = 250;

	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then
rot you down to your maximum health limit,
one point per rel.
*/

float H_ROTTEN	 = 1;
float H_MEGA	 = 2;
.float	healamount;
void () health_touch;
void () item_megahealth_rot;

void () q100_item_health =
{
	self.touch = health_touch;

	self.archon = ARCHON_ITEM;
	self.netname = "Health";

	if (self.spawnflags & H_ROTTEN)
	{
		precache_model ("maps/b_bh10.bsp");

		precache_sound ("items/r_item1.wav");
		setmodel (self,"maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = HEAL_ROT;
	}
	else
	if (self.spawnflags & H_MEGA)
		{
			precache_model ("maps/b_bh100.bsp");
			precache_sound ("items/r_item2.wav");
			setmodel (self,"maps/b_bh100.bsp");
			self.noise = "items/r_item2.wav";
			self.healamount = 100;
			self.healtype = HEAL_MEGA;
			self.volume = Q_MEGA_MAX; // Cataboligne - 9.20.11 - for chaos mod code
			self.archon = ARCHON_ART;
		}
		else
		{
			precache_model ("maps/b_bh25.bsp");
			precache_sound ("items/health1.wav");
			setmodel (self,"maps/b_bh25.bsp");
			self.noise = "items/health1.wav";
			self.healamount = 25;
			self.healtype = HEAL_NORM;
		}
	setsize (self, '0 0 0', '32 32 56');
	self.mask_x = MORPH_ALL;
	StartItem ();
};


void () q100_health_touch =
{
//	local float amount;
	local string s;

	if (other.classname != "player")
			return;

//	if (self.healtype == 2) // this is different on default health now
	if (self.healtype == HEAL_MEGA) // Megahealth?  Ignore max_health...
	{
		if (other.health >= 250)
			return ;
		if (!T_Heal (other,self.healamount, 1))
			return ;
	}
	else
	{
		if (!T_Heal (other,self.healamount,0))
			return ;
	}

	sprint (other,"You receive ");
	s = ftos (self.healamount);
	sprint (other,s);
	sprint (other," health\n");

// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");

	self.model = null_string;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.healtype == HEAL_MEGA)
	{
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
		if (deathmatch == 1)		// deathmatch 2 is the silly old rules
		{
			self.nextthink = time + 20;
			self.think = SUB_regen;
		}
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void () item_megahealth_rot =
{
	other = self.owner;

// Cataboligne - 10.13.11 - regen / vampire runes
#ifdef enhanced
//	if (!(other.rune_flag & RUNE_VAMPIRE) || !ENHANCED)
//	if (! other.rune_flag & (RUNE_FLG_RG | TECH_ADOC) || !ENHANCED)
	if (! (other.rune_flag & RUNE_VAMPIRE))
	if (! other.rune_flag & (RUNE_FLG_RG | TECH_ADOC))
#endifdef

	if (other.health > other.max_health * other.health_modifier) // Cataboligne - 9.18.11 - morphic
	{
		self.duration = self.duration - 1; // for drop inv
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return ;
	}

// it is possible for a player to die and respawn between rots, so don't
// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);

	if (deathmatch == 1 || deathmatch == 3)	// deathmatch 2 is silly old rules // *pk more dm modes
	{
		self.map = null_string;
		self.owner = world;
		if (self.wait) // because all x item megas use this
			self.nextthink = time + self.wait;
		else
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
};

/*
===============================================================================

ARMOR

===============================================================================
*/

void () armor_touch =
{
	local	float	type, value, bit;

	if (other.health <= 0)
		return;
	if (other.classname != "player")
			return;

#ifdef enhanced
// dont get std armor for absurd large health + armor
	if (self.volume != -1)
	if (other.health + other.armorvalue > 450) // ablrgh - 10.12.14
		return;

// dont get inf armor for absurdly even larger health + armor
	if (other.health_modifier > 2.0)
	if (other.health + other.armorvalue > 650) // ablrgh - 10.12.14
		return;	
#endifdef

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}

	local string snd;
	local float ck;
	ck = TRUE;
	snd = "items/armor1.wav";
	if (self.noise4 == DOOM_DET || self.noise4 == Q2_DET || self.noise4 == Q3_DET || self.wad == "armor_toss")
	{
		if (self.volume != -1)
		if (other.armorvalue >= self.volume) return; // already max

//		other.target2 = self.model; // for dropinv - moved to touch
		ck = FALSE;
		if (self.noise) snd = self.noise; // Cataboligne - 9.23.11 - defaulted a few things if not set
		if (self.items) bit = self.items;
		type = 0.6;
		if (self.style) type = self.style;
		value = self.currentammo + other.armorvalue;
		Q3_HAH_TMP = other.health;
		Q3_HAA_TMP = other.armorvalue;
		if (self.volume > 0) // max only applies to non inf
		{
			if (value > self.volume) value = self.volume;
		}
		if (self.volume == -1 || self.classname == "q3_item_armor_shard" || self.classname == "d_item_spiritarmor") // shard specials
		{
			if (other.armortype > type) type = other.armortype; // shards pick best pl. has
			bit = other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3);
		}
		if (self.noise4 == Q3_DET)
		{
			q3_ha_rot(other, value);
		}
		if (!bit) bit = IT_ARMOR2;
	}

	if (ck)
// end NON q100
	if (other.armortype*other.armorvalue >= type*value)
		return ;

// q3 ha rot conflict fix
	if (self.noise4 != Q3_DET)
	{
		Q3_HAH_TMP = 0;
		Q3_HAA_TMP = self.currentammo;
		q3_ha_rot(other, -1);
	}
// end q3 fix

	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = null_string;
  if (deathmatch == 1 || deathmatch == 3)
  {
		self.nextthink = time + 20;
		self.think = SUB_regen;
  }

	if (self.netname != "Mega Sphere")
	{
	sprint(other, "You got armor\n");
	}
// armor touch sound
	sound(other, CHAN_ITEM, snd, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () item_armor1 =
{
	self.netname = "Armor";
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self,"progs/armor.mdl");
	self.skin = 0;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_HKNIGHT;
	self.volume = 100;

	self.archon = ARCHON_ITEM;
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () item_armor2 =
{
	self.netname = "Armor";
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self,"progs/armor.mdl");
	self.skin = 1;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_HKNIGHT;
	self.volume = 150;

	self.archon = ARCHON_ITEM;
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () item_armorInv =
{
	self.netname = "Armor";
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self,"progs/armor.mdl");
	self.skin = 2;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_HKNIGHT;
	self.volume = 200;

	self.archon = ARCHON_ITEM + 0.1;
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

void () bound_other_ammo =
{
	pk_bound_ammo();  // *pk bound ammo
/*
	if (!Q-100) pk_bound_ammo();  // *pk bound ammo
	else
	{
	if (other.ammo_shells > 100)
		other.ammo_shells = 100;
	if (other.ammo_nails > 200)
		other.ammo_nails = 200;
	if (other.ammo_rockets > 100)
		other.ammo_rockets = 100;
	if (other.ammo_cells > 100)
		other.ammo_cells = 100;
	}
*/
};


float(float w) RankForWeapon =
{
	if (w == IT_LIGHTNING)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_SUPER_NAILGUN)
		return 3;
	if (w == IT_GRENADE_LAUNCHER)
		return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 5;
	if (w == IT_NAILGUN)
		return 6;
	return 7;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
//void(float old, float new) Deathmatch_Weapon =
void(float new) Deathmatch_Weapon =
{
	local float nr;

// change self.weapon if desired
//	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if (nr < RankForWeapon (self.weapon))
		self.weapon = new;
};

/*
=============
weapon_touch
=============
*/
float () W_BestWeapon;

void () weapon_touch =
{
	local	float	hadammo, best, new;
	local entity stemp;
	local float leave;

	if (other.classname != "player") // *bot
			return;

// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon ();
	self = stemp;

	if (deathmatch == 3 || deathmatch == 2 || coop) // *pk - more dm modes
		leave = 1;
	else
		leave = 0;

	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN))
			return ;
		hadammo = other.ammo_nails;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN))
				return ;
		hadammo = other.ammo_rockets;
		new = IT_SUPER_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave && (other.items & IT_SUPER_SHOTGUN))
			return ;
		hadammo = other.ammo_rockets;
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_rocketlauncher")
			{
		if (leave && (other.items & IT_ROCKET_LAUNCHER))
			return ;
		hadammo = other.ammo_rockets;
		new = IT_ROCKET_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER))
			return;
		hadammo = other.ammo_rockets;
		new = IT_GRENADE_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING))
			return;
		hadammo = other.ammo_rockets;
		new = IT_LIGHTNING;
		other.ammo_cells = other.ammo_cells + 15;
	}
	else
	{
#ifdef warning
		if (WARNING & 2)
		{
			bprint("\n*** warning:\nweapon_touch: unknown classname (");
			bprint(self.classname);
			bprint(") - ignoring\n\n");
		}
#endifdef
		self.touch = SUB_Null;
		return;
	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");
// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

// change to the weapon
	other.items = other.items | new;

	stemp = self;
	self = other;

// PK-NOTE: "old" variable above does nothing...what was iD's plan for it?
	PK_Deathmatch_Weapon (new, 0); // *pk - new wep switch rule for higher risk weps

	W_SetCurrentAmmo ();

	self = stemp;

	if (leave)
		return;

// remove it in single player, or setup for respawning in deathmatch
	self.model = null_string;
	self.solid = SOLID_NOT;
  if (deathmatch == 1)
  {
		self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
  }

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q100_weapon_supershotgun =
{
	precache_model ("progs/g_shot.mdl");
	setmodel (self,"progs/g_shot.mdl");
	self.items = // morph builtin upgrade deal - Cataboligne - 10.2.11
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;

	self.archon = ARCHON_WEP_EXT;
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_nailgun =
{
	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.items = // morph builtin upgrade deal - Cataboligne - 10.2.11
	self.weapon = IT_NAILGUN;
	self.netname = "nailgun";
	self.touch = weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN+ CB_GREMLIN + CB_OGRE;

	self.archon = ARCHON_WEP;
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_supernailgun =
{
	precache_model ("progs/g_nail2.mdl");
	setmodel (self,"progs/g_nail2.mdl");
	self.items = // morph builtin upgrade deal - Cataboligne - 10.2.11
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN+ CB_GREMLIN + CB_OGRE;

	self.archon = ARCHON_WEP + 0.05;
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q100_weapon_grenadelauncher =
{
	precache_model ("progs/g_rock.mdl");
	setmodel (self,"progs/g_rock.mdl");
	self.items = IT_GRENADE_LAUNCHER; // morph builtin upgrade deal - Cataboligne - 10.2.11
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;// + CB_SCOURGE;

	self.archon = ARCHON_WEP_EXT;
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q100_weapon_rocketlauncher =
{
	precache_model ("progs/g_rock2.mdl");
	setmodel (self,"progs/g_rock2.mdl");
	self.items = IT_ROCKET_LAUNCHER; // morph builtin upgrade deal - Cataboligne - 10.2.11
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;

	self.archon = ARCHON_WEP_EXT;
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q100_weapon_lightning =
{
	precache_model ("progs/g_light.mdl");
	setmodel (self,"progs/g_light.mdl");
	self.items = IT_LIGHTNING; // morph builtin upgrade deal - Cataboligne - 10.2.11
	self.weapon = 3;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;// + CB_SCOURGE;

	self.archon = ARCHON_WEP_EXT;
};


/*
===============================================================================

AMMO

===============================================================================
*/

void () ammo_touch =
{
	local entity stemp;
	local float best;

	if (other.classname != "player")
			return ;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon ();
	self = stemp;


// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
			return ;
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
			return ;
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

//	rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
			return ;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

//	cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
			return ;
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	bound_other_ammo ();

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");
// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// change to a better weapon if appropriate

	if (other.weapon == best)
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo ();
		self = stemp;
	}

// if changed current ammo, update it
	stemp = self;
	self = other;
	W_SetCurrentAmmo ();
	self = stemp;

// remove it in single player, or setup for respawning in deathmatch
	self.model = null_string;
	self.solid = SOLID_NOT;
  if (deathmatch == 1)
		self.nextthink = time + RSP_TIME;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};




float WEAPON_BIG2	 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_shells =
{
	self.touch = ammo_touch;

	if (!self.aflag) // Cataboligne - 10.22.12 - allow ammo box load map overrides
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self,"maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self,"maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;

	self.archon = ARCHON_AMMO;
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_spikes =
{
	self.touch = ammo_touch;

	if (!self.aflag) // Cataboligne - 10.22.12 - allow ammo box load map overrides
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self,"maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self,"maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_OGRE;

	self.archon = ARCHON_AMMO;
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_rockets =
{
	self.touch = ammo_touch;

	if (!self.aflag) // Cataboligne - 10.22.12 - allow ammo box load map overrides
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self,"maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self,"maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN + CB_SCOURGE;

	self.archon = ARCHON_AMMO_EXP;
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_cells =
{
	self.touch = ammo_touch;

	if (!self.aflag) // Cataboligne - 10.22.12 - allow ammo box load map overrides
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self,"maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self,"maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN + CB_SCOURGE;

	self.archon = ARCHON_AMMO;
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

float WEAPON_SHOTGUN	 = 1;
float WEAPON_ROCKET	 = 2;
float WEAPON_SPIKES	 = 4;
float WEAPON_BIG	 = 8;
void () item_weapon =
{
	self.touch = ammo_touch;
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN + CB_SCOURGE;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self,"maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self,"maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self,"maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self,"maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
		self.mask_x = CB_HUMAN + CB_GREMLIN + CB_OGRE;
	}

	self.archon = ARCHON_AMMO;

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self,"maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self,"maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";

		self.archon = ARCHON_AMMO_EXP;
	}

	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*
===============================================================================

KEYS

===============================================================================
*/

void () key_touch =
{
//	local entity stemp;
//	local float best;

	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;
	if (other.items & self.items)
		return ;

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = other.items | self.items;

	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = null_string;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


void () key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype >= 2)
	{
		precache_sound ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void () item_key1 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (self,"progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (self,"progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype >= 2)
	{
		precache_model ("progs/b_s_key.mdl");
		setmodel (self,"progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds ();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ITEM;

	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void () item_key2 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self,"progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self,"progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype >= 2)
	{
		precache_model ("progs/b_g_key.mdl");
		setmodel (self,"progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds ();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ITEM + 0.5;

	StartItem ();
};



/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void () sigil_touch =
{
//	local entity stemp;
//	local float best;

	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

	centerprint (other,"You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other,"bf\n");
	self.solid = SOLID_NOT;
	self.model = null_string;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = null_string;		// so rune doors won't find it

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*

void () q10-_item_sigil =
{
	if (!self.spawnflags)
		objerror ("no spawnflags");

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self,"progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model ("progs/end2.mdl");
		setmodel (self,"progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model ("progs/end3.mdl");
		setmodel (self,"progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model ("progs/end4.mdl");
		setmodel (self,"progs/end4.mdl");
	}

	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;
	self.archon = ARCHON_ART;
	StartItem ();
};

/*
===============================================================================

POWERUPS

===============================================================================
*/

void () powerup_touch =
{
//	local entity stemp;
//	local float best;

	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	if (deathmatch != 4) // *pk - my new rule, logical extrapolation - everything goes away, none comes back
	if (deathmatch)
	{
		self.mdl = self.model;

		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + RSP_TIME * 10; // * 2 * 5
		else
			self.nextthink = time + RSP_TIME * 2;

		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = null_string;

// do the apropriate action
	if (self.classname == "item_artifact_envirosuit") // note: bio is not coming here!
	{
		other.rad_time = 1;
		other.radsuit_finished = time + POW_TIME;
		if (VW)
		if (other.mask_x & CB_HUMAN)
			other.skin = BIOSUIT;  // set skin for suit
	}

	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + POW_TIME;
		if (other.pkplus_actortype == PKPLUS_ACTORPENT) // Cataboligne 8.12.9 purify - pk artifacts
			other.pkplus_actortype = 0;
	}

	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + POW_TIME;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + POW_TIME;
		if (other.pkplus_actortype == PKPLUS_ACTORQUAD) // Cataboligne 8.12.9 purify - pk artifacts
			other.pkplus_actortype = 0;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};



/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 rels
*/
void () item_artifact_invulnerability =
{
	self.touch = x_pwr_touch; //powerup_touch;

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ART + 0.3;

	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 rels
*/
void () item_artifact_envirosuit =
{
	self.touch = x_pwr_touch; //powerup_touch;

	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self,"progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	self.lip = BIOSUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL - (MORPH_ALL & CB_CTHON);

	self.archon = ARCHON_ART;

	StartItem ();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 rels
*/
void () item_artifact_invisibility =
{
	self.touch = x_pwr_touch; //powerup_touch;

	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self,"progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ART;

	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void () item_artifact_super_damage =
{
	self.touch = x_pwr_touch; //powerup_touch;

	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self,"progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ART + 0.2;

	StartItem ();
};



/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*

void () q10-_BackpackTouch =
{
	local string s;
	local	float	best, old, new;
	local entity stemp;
	local float acount;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return ;

	acount = 0;
	sprint (other,"You get ");

	if (self.items)
	if ((other.items & self.items) == 0)
		{
			acount = 1;
			sprint (other,"the ");
			sprint (other,self.netname);
		}

// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon ();
	self = stemp;

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;

	new = self.items;
	if (!new)
		new = other.weapon;
	old = other.items;
	other.items = other.items | new;

	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_shells);
		sprint (other, s);
		sprint (other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_nails);
		sprint (other, s);
		sprint (other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint (other, s);
		sprint (other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_cells);
		sprint (other, s);
		sprint (other, " cells");
	}

	sprint (other, "\n");
// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// remove the backpack, change self to the player
	remove (self);
	self = other;

// change to the weapon
	if (!deathmatch)
		self.weapon = new;
	else
		Deathmatch_Weapon (new);

	W_SetCurrentAmmo ();
};

/*
===============
DropBackpack
===============
*
void () q10-_DropBackpack =
{
	local entity item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it

	item = spawn ();
	item.origin = self.origin - '0 0 24';

	item.items = self.weapon;
	if (item.items == IT_AXE)
		item.netname = "Axe";
	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";
	else
		item.netname = null_string;

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item,"progs/backpack.mdl");
	setsize (item,'-16 -16 0','16 16 56');
	item.touch = q10-_BackpackTouch;

	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
	bot_BackpackSetup(item); // *bot
};
*/














