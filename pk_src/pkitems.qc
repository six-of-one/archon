/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: pkitems.qc
 *
 * date: Fri Apr  4 04:31:44 UTC 2008
 *
 * final qc
 *
 */



/*
 * New weapons and items. These are not functional. -- Cataboligne - huh? what does this mean??
 *
 * weapon_airfist
 * weapon_grapgun
 * weapon_rmine
 * weapon_chainlg
 * item_painkeep_gwell
 * item_painkeep_turret
 * item_painkeep_lantern
 * item_painkeep_can
 * item_painkeep_beartrap
 * light_painkeep_candle
 * item_painkeep_expshells
 *
 pkplus
 *  item_pkplus_ego
 *  item_pkplus_tomb
 *  item_pkplus_actor
 *  item_pkplus_phone
 */


void () SUB_regen =
{
	if (Q_100)
	{
		q100_SUB_regen();
		return;
	}

	if (self.event == "dynamic_item") // just in case catch - cubes prob. come here
	{
		if (WARNING)
			bprint("*** - WARNING - Removed a dyn item in SUB_regen!\n");
		pk_ditems = pk_ditems - 1; // havent verified this in some time, likely its totally borked re: map crates that dont respawn use this
		remove(self);
		return;
	}

	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	if (self.touch == SUB_Null) self.touch = painkeep_touch; // reset from sphere of A
	if (self.noise4 != "")
		sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);	// play respawn sound - doom / other resp sounds
	else
		sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	pk_item_position();  // *pk - reposition moved items (horn & harp effects) on respawn
};

void() thinkpr =
{
bprint(self.netname);

remove(self);	
};

void(string g) tbprint =
{
	local entity e;
	
	e = spawn();
	e.netname = g;
	e.think = thinkpr;
	e.nextthink = time + 10; // FIX: for actuall use in server runes
};

void () PlaceItem =
{
	local float f;

	if (notmod(self)) // not mod for items - note: this removes the ent
	{
		return;
	}

	bot_item_linx(self); // *bot - item tie in

// used for translate - if *_100 on
	self.mcode = pk_mcode("", self); // put map code on ent
	self.sscode = sid_code[(int)(self.mcode - 100) * %4];
	if (!self.scode) self.scode = self.mcode;

	if (Q_100 || PK_100) // || !XMOD)
	{
		f = 0;
		if (TR_Q1QRY > 0)
		{
			TR_Q1QRY = 0;
			if (world.worldtype == IT0_WQ1) TR_Q1QRY = -1;
			else if (world.worldtype == IT1_WQ1) TR_Q1QRY = -1; // map was designed for dual items - remove only
			else if (world.worldtype == IT3_WQ1) TR_Q1QRY = -1;
			else if (world.worldtype == IT4_WQ1) TR_Q1QRY = -1;
			else
			if (find(world,wad,"q1")) TR_Q1QRY = -1; // map was designed for dual items - remove only
		}
		if (TR_Q1DEF && (TR_Q1QRY == 0)) f = FL_TR_QUAKE;
		if (self.class_select == "wolf_item") master_item_control(self, f);
		else if (self.class_select == "doom_item") master_item_control(self, f);
		else if (self.class_select == "q2_item") master_item_control(self, f);
		else if (self.class_select == "q3_item") master_item_control(self, f);
		else if (self.class_select == "hip_item") master_item_control(self, f);
		else if (self.class_select == "x_item") master_item_control(self, f);
		else if (self.mcode == MC_AXE) master_item_control(self, f);
		else if (self.mcode == MC_SHOTGUN) master_item_control(self, f);
		if (self.think == PlaceItem) self.think = SUB_Null; // create calls start item - fix infinite loop because item_call sub regen not used in *100
	}

	if (self.scode == MC_Q2_BARREL || self.scode == MC_D_BARREL || self.scode == MC_Q3_BARREL || self.scode == MC_EXPLOD1 || self.scode == MC_EXPLOD1){
		return;

if (WARNING)
bprint("placeitem barrel return\n");


}

	if (Q_100)
	{
		q100_PlaceItem(); // always encoding now
		return;
	}

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
//	oldz = self.origin_z;
	if (!droptofloor(0,0)) // Cataboligne 9.17.3 - fix compiler warning
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		if (PK_100)
		{
			remove (self);
			return ;
		}
		else
			dtf_handle();
	}
	pk_placeitem(); // *pk - set item details

	pic_test();
};


// New weapons

void () painkeep_weapon_touch =
// The touch func for our new items
{
	local	float best, new;
	local	entity	stm2;
	local float leave;

	if (other.classname != "player") // *bot
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return ;
	}

// if the player was using his best weapon, change up to the new one if better
	stm2 = self;
	self = other;
	best = W_BestWeapon ();
	self = stm2;

	if (deathmatch == 2 || deathmatch == 3 || coop)
		leave = 1;
	else
		leave = 0;

	if (self.pk_currentitem == PK_IT_GRAPGUN)
	{
		if (leave && (other.pk_items & PK_IT_GRAPGUN))
			return ;
		new = PK_IT_GRAPGUN;
	}
	else if (self.pk_currentitem == PK_IT_AIRGUN)
	{
		if (leave && (other.pk_items & PK_IT_AIRGUN))
				return ;
			new = PK_IT_AIRGUN;
	}
	else if (self.pk_currentitem == PK_IT_CLIGHT)
	{
		if (leave && (other.pk_items & PK_IT_CLIGHT))
			return ;

		other.ammo_cells = other.ammo_cells + 30;
		new = PK_IT_CLIGHT;
	}
	else if (self.classname == "weapon_pulsenail" || self.mcode == MC_PULSE_NAILGUN || self.classname == "weapon_nailgun_q1")
	{
		if (leave && (other.items & IT_NAILGUN))
			return ;
		new = 0;
		other.items = other.items | IT_NAILGUN; // special for this
		other.ammo_nails = other.ammo_nails + 30;
		PK_Deathmatch_Weapon (IT_AXE, IT_NAILGUN);
	}
	else
	{
		if (PK_100 && PK_100_OBJERR) objerror("painkeep_weapon_touch: unknown classname");
		else
		{
			if (WARNING)
			{
			bprint("\n*** warning:\npainkeep_weapon_touch: unknown classname (");
			bprint(self.classname);
			bprint(") - ignoring\n\n");
			}
			self.touch = SUB_Null;
			return;
		}
	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other,"bf\n");

	bound_other_ammo ();

// change to the weapon
	other.pk_items = other.pk_items | new;

	stm2 = self;
	self = other;

// PAINKEEP_START
	/*
	if (!deathmatch)
	{
		self.weapon = IT_AXE;
		self.pk_currentitem = new;
	}
	else
	*/
	PK_Deathmatch_Weapon (IT_AXE, new);
// PAINKEEP_END

	W_SetCurrentAmmo ();

	self = stm2;

	if (leave)
		return ;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_airfist (0 .5 .8) (-16 -16 0) (16 16 32)
new QUAKED weapon_airfist (0 .5 .8) (-15 -9 25) (17 9 43)
*/

void () weapon_airfist =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	if (PK_100)
	{
		precache_model ("progs/g_airgun.mdl");
		setmodel (self,"progs/g_airgun.mdl");
	}
	else
	{
		precache_model ("progs/g_airgun2.mdl");
		setmodel (self,"progs/g_airgun2.mdl");
	}
	self.pk_currentitem = PK_IT_AIRGUN;
	self.netname = "AirFist";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	//setsize (self, '-15 -9 25', '17 9 43');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};

/*QUAKED weapon_rmine (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_rmine =
{
	remove (self);
};

/*QUAKED weapon_chainlg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_chainlg =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		if (Q_100) remove(self);
		else
		{
			q100_weapon_lightning();
			self.classname = "weapon_lightning";
		}
		return;
	}

	precache_model ("progs/g_clight.mdl");
	setmodel (self,"progs/g_clight.mdl");
	self.pk_currentitem = PK_IT_CLIGHT;
	self.netname = "Chain Thunderbolt";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;
};


/*QUAKED weapon_grapgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_grapgun =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_weapon_touch;

	precache_model ("progs/g_harp.mdl");
	setmodel (self,"progs/g_harp.mdl");
	self.pk_currentitem = PK_IT_GRAPGUN;
	self.netname = "Harpoon Gun";
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};

// dynamic items go away when touched

void() pk_dyn_touch =
{
	if (self.event != "dynamic_item") return;
	if (self.netname != "cells") pk_ditems = pk_ditems - 1;
	remove(self);
};
// called from below - handle ammo touch extras

void() pk_ammo_touch =
{
	local entity	sv;
	local float best, bestpk, sk, MAX; // *pk - best pk wep

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better
	sv = self;
	self = other;
	best = W_BestWeapon();
	bestpk = W_BestPKWeapon(); // *pk - best pk wep
	self = sv;

	sk = TRUE; // skip old method if false

// Cataboligne - 7.19.10 - pack & ammo runes mod
	MAX = bound_ammo_pack(self.lip);

	if (self.lip == AMMO_SLUGS) // slugs
	{
		if (other.ammo_slug >= MAX) //PK_SLUGAMMO_MAX)
			return;
		other.ammo_slug = other.ammo_slug + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_BULLETS) // any bullets
	{
		if (other.ammo_bullet >= MAX) // PK_BULLETAMMO_MAX)
			return;
		other.ammo_bullet = other.ammo_bullet + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_CELLS)
	{
		if (other.ammo_cells >= MAX) // Q1_CELLAMMO_MAX)
			return;
		other.ammo_cells = other.ammo_cells + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_NAILS)
	{
		if (other.ammo_cells >= MAX) // Q1_NAILAMMO_MAX)
			return;
		other.ammo_nails = other.ammo_nails + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_ROCKETS)
	{
		if (other.ammo_rockets >= MAX) // Q1_ROCKETAMMO_MAX)
			return;
		other.ammo_rockets = other.ammo_rockets + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_GRENADES) // IDEA: decide if this will be separate ammo (from rockets) for q2 & q3 - add max & cvar
	{
		if (other.ammo_rockets >= MAX) // Q1_ROCKETAMMO_MAX)
			return;
		other.ammo_rockets = other.ammo_rockets + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_SHELLS)
	{
		if (other.ammo_shells >= MAX) // Q1_SHELLAMMO_MAX)
			return;
		other.ammo_shells = other.ammo_shells + self.currentammo;
		sk = FALSE;
	}	

	if (self.lip == AMMO_GAS)
	{
		if (other.ammo_gaspr >= MAX) // Q1_GASAMMO_MAX)
			return;
		other.ammo_gaspr = other.ammo_gaspr + self.currentammo;
		sk = FALSE;
	}	

	if (sk)
	{
// shotgun
		if (self.weapon == 1)
		{
			if (other.ammo_shells >= Q1_SHELLAMMO_MAX)
				return;
			other.ammo_shells = other.ammo_shells + self.aflag;
		}

// spikes
		if (self.weapon == 2)
		{
			if (other.ammo_nails >= Q1_NAILAMMO_MAX)
				return;
			other.ammo_nails = other.ammo_nails + self.aflag;
		}

//	rockets
		if (self.weapon == 3)
		{
			if (other.ammo_rockets >= Q1_ROCKETAMMO_MAX)
				return;
			other.ammo_rockets = other.ammo_rockets + self.aflag;
		}

//	cells
		if (self.weapon == 4)
		{
			if (other.ammo_cells >= Q1_CELLAMMO_MAX)
				return;
			other.ammo_cells = other.ammo_cells + self.aflag;
		}

		if (self.weapon == 5) // *pk exploding shells
		{
			if (other.pk_explode_ammo >= PK_EXPLODEAMMO_MAX)
				return;
			if (!other.mask_x & CB_HUMAN)
			{
				if (!shotgun_check(other)) // morph has to have a gun to get this
					return;
			}
			other.pk_explode_ammo = other.pk_explode_ammo + self.aflag;
		}	
	}

	pk_bound_ammo ();

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
	if (self.noise != "")
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	else
// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// change to a better weapon if appropriate

	if (other.weapon == best)
		if (best != IT_AXE || bestpk == other.pk_currentitem) // *pk best pk wep checks
	{
		sv = self;
		self = other;
		self.weapon = W_BestWeapon();
		self.pk_currentitem = W_BestPKWeapon(); // *pk - best pk wep
		W_SetCurrentAmmo ();
		self = sv;
	}

// if changed current ammo, update it
	sv = self;
	self = other;
	W_SetCurrentAmmo();
	self = sv;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1 || deathmatch == 3)
	{
//		if (self.wait)
//			self.nextthink = time + self.wait;
//		else
	  self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	if (pk_flags & PK_DYNAMIC) pk_dyn_touch();
};


// The touch func for our new items

void() painkeep_touch =
{
	local entity stm2;
	local float f, cube;
	local entity e;

	if (other.admin)
	if (other.admin != LIVE_ADMIN)
	if (other.admin != USER_MENU)
		return; // *pk - admin - no collecting stuff

// note: the only thing this really does is prevent running the entire touch code for things that are not picked up on the first touch more than once per sec for players / bots
	if (other.duration > time) return; // note: snything that sets player duration could fsck here

	if (other.eweapon)
	if (other.eweapon.wad == "pk_cube" || other.eweapon.wad == "morph_cube")
		cube = TRUE;

	e = world;

	if (!cube) // should not happen for bots - but here just in case
	if (other.health > 0)
	if (other.classname == "pk*bot") // *bot - looks like player for touch
	{
		if (self.state == BOT_TOUCHED || self.state == BOT_TOUCHED_CACHE_ROUTE_TOUCH) // *bot code - patch in bot_toucheditem for bots - routes here because this is PK master touch fn()
		{
			bot_toucheditem ();
		}

		e = other;
		e.wad = e.classname;
		e.classname = "player";
	}

	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return;
	}

	if (other.health <= 0)
		return;

// cubic - because anything that sets eweap fsck's cube op
	if (cube)
	{
		if (other.eweapon.duration > time) return;
		other.eweapon.duration = time + 3;
		sprint(other, "You cannot collect items while linked to a cube - change weapons or activate cube.\n");
		return;
	}
	
	other.duration = time + 1; // only hit touch 1 per sec for uncollected items - only set for players



if (!self.mask_x)
{
	bprint("------------------- ** WARNING - item with no mask x = ");
	bprint(self.model);
	bprint("\n");
}


// morphic
	f = FALSE; // dont exit

	if (!self.mask_x & other.mask_x) f = TRUE; // morph cant collect
	if ((other.mask_x & CB_GREMLIN) &&  (other.builtin & self.items)) f = TRUE; // gremlin trying to replace builtin, even if he can collect
	if (self.pk_currentitem & PK_IT_CARY)  f = FALSE; // all can get pki (but cthon)
	if (other.mask_x & CB_HUMAN) f = FALSE; // humans are ignoring the test - TDO: remove this
	if (other.model == "progs/cthon.mdl") f = TRUE; // cthon get nada
	if (self.wad == "morph_cube") f = FALSE; // all can get cube

	if (f) // make sure morph can collect this
	{
		if (e) e.classname = e.wad;

		if (!other.mask_x & CB_HUMAN)
		if (!other.mask_x & CB_GREMLIN)
		if (self.items & other.builtin) // touch activated special morph builtin
		if (!self.items & other.items)
		{
			other.items = other.items | self.items;
			sprint(other, "* Special morph powers activated - check your status bar\n");
		}

		return;
	}

	if (other.classname == "player") // *bot
//	if (self.pk_touch != painkeep_touch)
	if (self.state == CACHE_ROUTE_TOUCH || self.state == BOT_TOUCHED_CACHE_ROUTE_TOUCH) // *bot code - patch in cacheRoute for bot code - routes here because this is PK master touch fn()
	{
		if (other.movetarget.movetarget)
			cacheRoute (other.movetarget,other.movetarget.movetarget,0,self);
	}

	if (self.pk_touch == SUB_Null) // deactivated
	{
		if (e) e.classname = e.wad;
		return;
	}

	if (self.pk_touch == (void()) 0)
	{
		if (WARNING)
		{
		bprint("\b *** warning: in painkeep_touch for: ");
		bprint(self.classname);
		bprint(" and pk_touch is (void) 0 - reloading\n");
		}
		if (self.event != "dynamic_item") item_call(self.classname);
		else if (self.wad != "") item_call(self.wad);
		else if (self.scode) item_call(item_by_mcode(self.scode));
		if (e) e.classname = e.wad;
		return;
	}
	else
	if (self.pk_touch != painkeep_touch) // all items route through here - handle special cases, other touch fns & return
	{
		armorsave_rev(other); // get armor if power on
		if (self.pk_touch == ammo_touch) self.pk_touch = pk_ammo_touch; // new fn for ammo collections



if (self.classname == "")
{
	bprint("*** - blank classname in touch fn = ");
	bprint(self.model);
	bprint("\n");
}



		stack_touch(self, other); // save some items model string for drop codes
//		if (self.event == "dynamic_item")
//		{
//			f = TRUE;
//			self.classname = self.wad; // this should always be classname
//		}
		self.pk_touch();

//		if (f) self.event = "dynamic_item"; // restore

		if (other.mask_x & CB_SCOURGE) // scourge has to select x_wep so they look / sound right
		if (self.items & (IT_GRENADE_LAUNCHER | IT_LIGHTNING))
		{
			stm2 = self;
			self = other;
			player_scourge_impulse();
			self = stm2;
		}

		if (self.solid == SOLID_NOT)
		if (self.think == SUB_regen)
		if (deathmatch == 1 || deathmatch == 3)
		{
			if (self.wait)
				self.nextthink = time + self.wait;

			if (deathmatch == 3) // *pk - new dm mode settings - NOTE: this overrides genre ".wait" respawn times on all ents routed via armor & ammo touch listed below
			{
				if (self.pk_touch == pk_ammo_touch)
					self.nextthink = time + RSP_TIME * 0.5; //15;
				else if (self.pk_touch == armor_touch)
					self.nextthink = time + RSP_TIME * 0.666; //20;
			}



if (WARNING)
{
bprint("\b *** respawn: time set in painkeep_touch for: ");
bprint(item_ident(self));
bprint(", time = (");
bprint(ftos(self.nextthink - time));
bprint(")\n");
}



		}

		if (e)
		{
			e.classname = e.wad;
			if (e.think == player_run) e.think = e.th_run;
			if (e.think == player_stand1) e.think = e.th_stand;
		}

		if (pk_flags & PK_DYNAMIC) pk_dyn_touch();
// special codes - for things that are touchable but dont disappear
		if (self.aflag <= NO_REMOVE_TCH)
		{
			self.model = self.mdl;
			self.solid = SOLID_NOT; // cant touch till respawn
		}
		if (self.aflag == NO_REMOVE_NORET) self.nextthink = -1;
		other.duration = 0;
		return;
	}

	if (e) e.classname = e.wad;


	if (other.builtin)
	if (!other.builtin & IT_AXE) // no axe, cant use pki
		return;

	// check if it can be picked up
	if (self.pk_items == PK_IT_BEARTRAP)
	{
		// check ammo
		if (other.pk_beartrapammo >= PK_BEARTRAPAMMO_MAX)
		{
			return;
		}
		other.pk_beartrapammo = other.pk_beartrapammo + 1;
	}
	else if (self.pk_items == PK_IT_TURRET)
	{
		// check ammo
		if (other.pk_turretammo >= PK_TURRETAMMO_MAX)
		{
			return;
		}
		other.pk_turretammo = other.pk_turretammo + 1;
	}
	if (self.pk_items == PK_IT_GRAVITYWELL)
	{
		// check ammo
		if (other.pk_gravitywellammo == -1) // has a super well
			return;

		if (other.pk_gravitywellammo >= PK_GRAVITYWELLAMMO_MAX)
		{
			return;
		}
		if (self.frame == 1) // super cube
			other.pk_gravitywellammo = -1; // heh - override any cube inventory
		else
		other.pk_gravitywellammo = other.pk_gravitywellammo + 1;
	}
	else if (self.pk_items == PK_IT_CANPAB)
	{
		e = vchk(IT_AXE, PK_IT_CANPAB, other.vwepent);
		if (e.eweapon) return; // holdable medkit
		// check ammo
		if (other.pk_canpabammo >= PK_CANPABAMMO_MAX)
		{
			return;
		}
		other.pk_canpabammo = other.pk_canpabammo + 1;
	}


	// print message of what you picked up
	/*
	sprint(other, "You now have a ");
	sprint(other, self.netname);
	sprint(other, " to unleash on your enemy's\n");
	*/
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");

// pickup souond
	sound (other, CHAN_ITEM, "misc/pickup/tone2.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// if changed current ammo, update it
	stm2 = self;
	self = other;
	W_SetCurrentAmmo();
	self = stm2;

	// remove object until it is time to respawn
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch)
	if (deathmatch == 1 || deathmatch == 3)
	{
//		if (self.wait) // NOTE: this is q3 code and q3 items should never come through here as of now
//			self.nextthink = time + self.wait;
//		else
		if (self.pk_items == PK_IT_GRAVITYWELL)
		{
			if (PK_GRV_RSP > 0)
				self.nextthink = time + PK_GRV_RSP;
			else
			self.nextthink = time + RSP_TIME * 4;
		}
		else
			self.nextthink = time + RSP_TIME * 2;
		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
	if (pk_flags & PK_DYNAMIC) pk_dyn_touch();
	other.duration = 0;
};


/*QUAKED item_painkeep_gwell (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_gwell =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	self.noise = "items/protect.wav";
	precache_model ("progs/cubsmall.mdl");
	setmodel (self,"progs/cubsmall.mdl");
	self.netname = "Gravity Well";
	self.pk_items = PK_IT_GRAVITYWELL;
	//setsize (self, '-32 -32 -32', '32 32 32');
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL; // everyone can have pk specials
	StartItem ();
};

/*QUAKED item_painkeep_turret (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_turret =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	precache_model ("progs/tpower.mdl");
	setmodel (self,"progs/tpower.mdl");
	self.netname = "AutoSentry";
	self.pk_items = PK_IT_TURRET;

	setsize (self,'-7 -7 -7','4 7 21');
	self.mask_x = MORPH_ALL;
	StartItem ();
};

/*QUAKED item_painkeep_lantern (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_lantern =
{
	remove (self);
};


/*QUAKED item_painkeep_can(0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_can =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	precache_model ("progs/beans.mdl");
	setmodel (self,"progs/beans.mdl");
	self.netname = "Can of pork and beans";
	self.pk_items = PK_IT_CANPAB;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;
	StartItem ();
};

/*QUAKED item_painkeep_beartrap(0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_beartrap =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	precache_model ("progs/bearpick.mdl");
	setmodel (self,"progs/bearpick.mdl");
	self.netname = "Bear Trap";
	self.pk_items = PK_IT_BEARTRAP;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL;
	StartItem ();
};



/*QUAKED light_painkeep_candle (0 .5 0) (-10 -10 -20) (10 10 20)
Currently exactly the same as a small wall torch
*/
void () light_painkeep_candle =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	precache_model("progs/candle.mdl");
	setmodel (self,"progs/candle.mdl");
	FireAmbient ();
	makestatic (self);
};


/*QUAKED item_painkeep_expshells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_painkeep_expshells =
{
	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = pk_ammo_touch;

	precache_model ("maps/b_eshel0.bsp");
	setmodel (self,"maps/b_eshel0.bsp");
	self.aflag = 10;

	self.weapon = 5;
	self.netname = "Exploding Shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
	self.mask_x = MORPH_ALL;
};

// called from bound_ammo - bounds for pk ammo

// Cataboligne - 7.19.10 - added ammo pack bounding

void() pk_bound_ammo =
{
// st ammo pack code
	if (other.rune_flag & RUNE_AMMO) // ammo packs & ammo rune increase carry capy
	{
		bound_ammo_pack(0);
	}
	else
	{
// end ammo pack code

	if (other.ammo_shells > Q1_SHELLAMMO_MAX)
		other.ammo_shells = Q1_SHELLAMMO_MAX;
	if (other.ammo_nails > Q1_NAILAMMO_MAX)
		other.ammo_nails = Q1_NAILAMMO_MAX;
	if (other.ammo_rockets > Q1_ROCKETAMMO_MAX)
		other.ammo_rockets = Q1_ROCKETAMMO_MAX;
	if (other.ammo_cells > Q1_CELLAMMO_MAX)
		other.ammo_cells = Q1_CELLAMMO_MAX;
// new ammo
	if (other.ammo_bullet > PK_BULLETAMMO_MAX)
		other.ammo_bullet = PK_BULLETAMMO_MAX;
	if (other.ammo_slug > PK_SLUGAMMO_MAX)
		other.ammo_slug = PK_SLUGAMMO_MAX;
	if (other.ammo_gaspr > PK_GASAMMO_MAX)
		other.ammo_gaspr = PK_GASAMMO_MAX;
	}

	if (other.pk_gravitywellammo > PK_GRAVITYWELLAMMO_MAX)
		other.pk_gravitywellammo = PK_GRAVITYWELLAMMO_MAX;
	if (other.pk_turretammo > PK_TURRETAMMO_MAX)
		other.pk_turretammo = PK_TURRETAMMO_MAX;
	if (other.pk_canpabammo > PK_CANPABAMMO_MAX)
		other.pk_canpabammo = PK_CANPABAMMO_MAX;
	if (other.pk_beartrapammo > PK_BEARTRAPAMMO_MAX)
		other.pk_beartrapammo = PK_BEARTRAPAMMO_MAX;

	if (other.pk_explode_ammo > PK_EXPLODEAMMO_MAX)
		other.pk_explode_ammo = PK_EXPLODEAMMO_MAX;

// Cataboligne 8.12.9 purify - pk artifacts
	if (other.pkplus_egoammo > PKPLUS_EGOAMMO_MAX)
		other.pkplus_egoammo = PKPLUS_EGOAMMO_MAX;
	if (other.pkplus_tombammo > PKPLUS_TOMBAMMO_MAX)
		other.pkplus_tombammo = PKPLUS_TOMBAMMO_MAX;
	if (other.pkplus_actorammo > PKPLUS_ACTORAMMO_MAX)
		other.pkplus_actorammo = PKPLUS_ACTORAMMO_MAX;
	if (other.pkplus_phoneammo > PKPLUS_PHONEAMMO_MAX)
		other.pkplus_phoneammo = PKPLUS_PHONEAMMO_MAX;
// end pk_art

};

// called from below - replacement for RankForWeapon - provides rank for some pk stuff

/// Cataboligne - 7.10.10 - expanded range for xweap ranking system

float(float w, float w2) PK_RankForWeapon =
{
	if (w == IT_AXE && w2 == PK_IT_CLIGHT)
		return 10;
	if (w == IT_LIGHTNING)
		return 20;
	if (w == IT_ROCKET_LAUNCHER)
		return 30;
	if (w == IT_SUPER_NAILGUN)
		return 40;
	if (w == IT_GRENADE_LAUNCHER)
		return 50;
	if (w == IT_SUPER_SHOTGUN)
		return 60;
	if (w == IT_NAILGUN)
		return 70;
	if (w == IT_SHOTGUN)
		return 80;
	if (w == IT_AXE && w2 == PK_IT_AIRGUN)
		return 90;
	return 100;
};

// replacement for Deathmatch_Weapon - handles high risk wep switch

void(float new, float new2) PK_Deathmatch_Weapon =
{
	local float or, nr;

	// Never change to the rl or gl
	if (new == IT_ROCKET_LAUNCHER || new == IT_GRENADE_LAUNCHER)
		return;

	// If your in water don't change to the lightning gun
	if (new == IT_LIGHTNING && self.waterlevel > 1)
		return;


// change self.weapon if desired
	or = PK_RankForWeapon (self.weapon, self.pk_currentitem);
	nr = PK_RankForWeapon (new, new2);
	if (nr < or)
	{
		self.weapon = new;
		self.pk_currentitem = new2;
	}
};

// refered from below

void() BackpackTouch =
{
	local string	bs;
	local float best, new;
	local entity e;
	local float acount;

	if (Q_100)
	{
		q100_BackpackTouch();
		return;
	}

	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return;
	}

	if (other.health <= 0)
		return;

	acount = 0; // this is just for commas - first entry has none

// st ammo pack code
	if (self.netname == "Ammo Pack") sprint (other, "an Ammo Pack with ");
	else
// end ammo pack code

	if (self.eweapon) // pack has an xweap
	{
		acount = 1;
//		sprint (other, "the ");

		e = self;
		self = self.eweapon;
//		sprint (other, self.netname);

		x_weapon_touch(); // prints "you got the" - this puts the eweapon in SUB_regen !!
		self = other;
		best = W_BestWeapon();
		self = e;
//		if (self.eweapon.stack1 == "threw")
			remove(self.eweapon); // pack native have a dyn_remove - but we need to take away the threw weps left eweapons
	}
	else // ? may want
	if (self.items)
	{
		sprint (other, "You get ");
// PAINKEEP_START
		if ((other.items & self.items) == 0 || (self.items == IT_AXE && (other.pk_items & self.pk_items) == 0 || self.pk_items == PK_IT_AXE))
// PAINKEEP_END
		{
			acount = 1;
			sprint (other, "the ");
			sprint (other, self.netname);
		}

// if the player was using his best weapon, change up to the new one if better
	e = self;
	self = other;
	best = W_BestWeapon();
	self = e;
	}

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
// new ammo
	other.ammo_bullet = other.ammo_bullet + self.ammo_bullet;
	other.ammo_slug = other.ammo_slug + self.ammo_slug;
	other.ammo_gaspr = other.ammo_gaspr + self.ammo_gaspr;

	other.pk_gravitywellammo = other.pk_gravitywellammo + self.pk_gravitywellammo;
	other.pk_turretammo = other.pk_turretammo + self.pk_turretammo;
	other.pk_canpabammo = other.pk_canpabammo + self.pk_canpabammo;
	other.pk_beartrapammo = other.pk_beartrapammo + self.pk_beartrapammo;
 	other.pk_explode_ammo = other.pk_explode_ammo + self.pk_explode_ammo;

// Cataboligne 8.12.9 purify - pk artifacts
	other.pkplus_egoammo = (other.pkplus_egoammo + self.pkplus_egoammo);
	other.pkplus_tombammo = (other.pkplus_tombammo + self.pkplus_tombammo);
	other.pkplus_actorammo = (other.pkplus_actorammo + self.pkplus_actorammo);
	other.pkplus_phoneammo = (other.pkplus_phoneammo + self.pkplus_phoneammo);

	if ( self.pkplus_egoammo )
	{
		if ( acount )
			sprint (other,", ");
		acount = 1;
		bs = ftos (self.pkplus_egoammo);
		sprint (other,bs);
		sprint (other," EGOs");
	}
	if ( self.pkplus_tombammo )
	{
		if ( acount )
			sprint (other,", ");
		acount = 1;
		bs = ftos (self.pkplus_tombammo);
		sprint (other,bs);
		sprint (other," Tombs");
	}
	if ( self.pkplus_actorammo )
	{
		if ( acount )
			sprint (other,", ");
		acount = 1;
		bs = ftos (self.pkplus_actorammo);
		sprint (other,bs);
		sprint (other," Actors");
	}
	if ( self.pkplus_phoneammo )
	{
		if ( acount )
			sprint (other,", ");
		acount = 1;
		bs = ftos (self.pkplus_phoneammo);
		sprint (other,bs);
		sprint (other," Cell Phones");
	}
// end pk_art

	new = self.items;
	if (!new)
		new = other.weapon;
	other.items = other.items | new;

	other.pk_items = other.pk_items | self.pk_items;

	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_shells);
		sprint (other, bs);
		sprint (other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_nails);
		sprint (other, bs);
		sprint (other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_rockets);
		sprint (other, bs);
		sprint (other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_cells);
		sprint (other, bs);
		sprint (other, " cells");
	}
// st x weap ammo annc
	if (self.ammo_bullet)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_bullet);
		sprint (other, bs);
		sprint (other, " bullets");
	}
	if (self.ammo_slug)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_slug);
		sprint (other, bs);
		sprint (other, " slugs");
	}
	if (self.ammo_gaspr)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_gaspr);
		sprint (other, bs);
		sprint (other, " lbs gas pressure");
	}
// end x weap ammo
	if (self.pk_gravitywellammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_gravitywellammo);
		sprint (other, bs);
		sprint (other, " Gravity Wells");
	}
	if (self.pk_turretammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_turretammo);
		sprint (other, bs);
		sprint (other, " AutoSentrys");
	}
	if (self.pk_canpabammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_canpabammo);
		sprint (other, bs);
		sprint (other, " Can's");
	}
	if (self.pk_beartrapammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_beartrapammo);
		sprint (other, bs);
		sprint (other, " Bear Traps");
	}
	if (self.pk_explode_ammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_explode_ammo);
		sprint (other, bs);
		sprint (other, " Exploding Shells");
	}

	sprint (other, "\n");
// backpack touch sound
	if (self.noise)
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	else
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// st ammo pack code
	if (self.netname != "Bandolier" && self.netname != "Ammo Pack") // handled a pack load up - dont want remove or wep chg
	{

// remove the backpack, change self to the player
//	remove(self); - deprecated because of bot seq touch code via painkeep_touch does some stuff to self after return
// this change may have fixed some issues with bots
		self.solid = SOLID_NOT;
		self.model = "";
		self.think = SUB_Remove;
		self.nextthink = time + 0.25;
	}
	else
		return;
// end ammo pack code

	e = self;
	self = other;

// change to the weapon
	if (!deathmatch)
		self.weapon = new;
	else
	PK_Deathmatch_Weapon (new, 0); // *pk - new wep switch rule for higher risk weps

	W_SetCurrentAmmo ();
	self = e;
};

// fn(xwep_ammo) - handel xweapon & pki ammo issues when they go in the pack
// also called prior to dead drop

// p - pack / player
// e - wepent

void(entity e, entity p) xwep_ammo =
{
	float ca;

	if (!p) return;

	ca = e.currentammo;
	if (ca < 1) ca = 1; // for pki tests

// pki
	if (e.pk_currentitem == PK_IT_GRAVITYWELL)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pk_gravitywellammo = p.pk_gravitywellammo - ca;
		if (p.pk_gravitywellammo < 1) p.pk_gravitywellammo = 0;		
	}
	else
	if (e.pk_currentitem == PK_IT_TURRET)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pk_turretammo = p.pk_turretammo - ca;
		if (p.pk_turretammo < 1) p.pk_turretammo = 0;		
	}
	if (e.pk_currentitem == PK_IT_CANPAB)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pk_canpabammo = p.pk_canpabammo - ca;
		if (p.pk_canpabammo < 1) p.pk_canpabammo = 0;		
	}
	if (e.pk_currentitem == PK_IT_BEARTRAP)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pk_beartrapammo = p.pk_beartrapammo - ca;
		if (p.pk_beartrapammo < 1) p.pk_beartrapammo = 0;		
	}

// pk plus
	if (e.pk_currentitem == PKPLUS_IT_EGO)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pkplus_egoammo = p.pkplus_egoammo - ca;
		if (p.pkplus_egoammo < 1) p.pkplus_egoammo = 0;		
	}
	else
	if (e.pk_currentitem == PKPLUS_IT_TOMB)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pkplus_tombammo = p.pkplus_tombammo - ca;
		if (p.pkplus_tombammo < 1) p.pkplus_tombammo = 0;		
	}
	if (e.pk_currentitem == PKPLUS_IT_ACTOR)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pkplus_actorammo = p.pkplus_actorammo - ca;
		if (p.pkplus_actorammo < 1) p.pkplus_actorammo = 0;		
	}
	if (e.pk_currentitem == PKPLUS_IT_PHONE)
	{
//		if (ca > p.pkplus_egoammo) { ca = p.pkplus_egoammo;		p.ammo_shells = 0; }
//		else
		p.pkplus_phoneammo = p.pkplus_phoneammo - ca;
		if (p.pkplus_phoneammo < 1) p.pkplus_phoneammo = 0;		
	}

// ammo
	if (e.lip == AMMO_SHELLS)
	{
		if (e.currentammo > p.ammo_shells) { e.currentammo = p.ammo_shells;		p.ammo_shells = 0; }
		else
		p.ammo_shells = p.ammo_shells - e.currentammo;
	}

	if (e.lip == AMMO_NAILS)
	{
		if (e.currentammo > p.ammo_nails) { e.currentammo = p.ammo_nails;		p.ammo_nails = 0; }
		else
		p.ammo_nails = p.ammo_nails - e.currentammo;
	}

	if (e.lip == AMMO_ROCKETS)
	{
		if (e.currentammo > p.ammo_rockets) { e.currentammo = p.ammo_rockets;		p.ammo_rockets = 0; }
		else
		p.ammo_rockets = p.ammo_rockets - e.currentammo;
	}

	if (e.lip == AMMO_CELLS)
	{
		if (e.currentammo > p.ammo_cells) { e.currentammo = p.ammo_cells;		p.ammo_cells = 0; }
		else
		p.ammo_cells = p.ammo_cells - e.currentammo;
	}

	if (e.lip == AMMO_BULLETS)
	{
		if (e.currentammo > p.ammo_bullet) { e.currentammo = p.ammo_bullet;		p.ammo_bullet = 0; }
		else
		p.ammo_bullet = p.ammo_bullet - e.currentammo;
	}

	if (e.lip == AMMO_SLUGS)
	{
		if (e.currentammo > p.ammo_slug) { e.currentammo = p.ammo_slug;		p.ammo_slug = 0; }
		else
		p.ammo_slug = p.ammo_slug - e.currentammo;
	}

	if (e.lip == AMMO_GAS)
	{
		if (e.currentammo > p.ammo_gaspr) { e.currentammo = p.ammo_gaspr;		p.ammo_gaspr = 0; }
		else
		p.ammo_gaspr = p.ammo_gaspr - e.currentammo;
	}

/* later
	if (e.lip == AMMO_GRENADES)
	{
		if (e.currentammo > p.ammo_hgrenade) { e.currentammo = p.ammo_hgrenade;		p.ammo_hgrenade = 0; }
		else
		p.ammo_hgrenade = p.ammo_hgrenade - e.currentammo;
	}
*/
};

// fn(swep_id) - identify standard weps (give netname for deadthrew)

// itm - item code to read (usually from .weapon)
// e - ent to check pk_currentitem

// moved from dropbackpack so deadthrew can use

string(float itm, entity e) swep_id =
{
	if (itm == IT_AXE)
	{
		if (e.pk_currentitem == PK_IT_AXE)
			return("Axe");
		else if (e.pk_currentitem == PK_IT_GRAVITYWELL)
			return("Gravity Well");
		else if (e.pk_currentitem == PK_IT_TURRET)
			return("AutoSentry");
		else if (e.pk_currentitem == PK_IT_GRAPGUN)
			return("Harpoon Gun");
		else if (e.pk_currentitem == PK_IT_BEARTRAP)
			return("Bear Trap");
		else if (e.pk_currentitem == PK_IT_AIRGUN)
			return("AirFist");
		else if (e.pk_currentitem == PK_IT_CLIGHT)
			return("Chain Thunderbolt");
// Cataboligne 8.12.9 purify - pk artifacts
		else if (e.pk_currentitem == PKPLUS_IT_EGO)
			return("EGO");
		else if (e.pk_currentitem == PKPLUS_IT_TOMB)
			return("Tomb");
		else if (e.pk_currentitem == PKPLUS_IT_ACTOR)
			return("Actor");
		else if (e.pk_currentitem == PKPLUS_IT_PHONE)
			return("Cell Phone");
// end pk_art
	}
	else if (itm == IT_SHOTGUN)
		return("Shotgun");
	else if (itm == IT_SUPER_SHOTGUN)
		return("Double-barrelled Shotgun");
	else if (itm == IT_NAILGUN)
		return("Pulse Rifle");
	else if (itm == IT_SUPER_NAILGUN)
		return("Super Nailgun");
	else if (itm == IT_GRENADE_LAUNCHER)
		return("Grenade Launcher");
	else if (itm == IT_ROCKET_LAUNCHER)
		return("Rocket Launcher");
	else if (itm == IT_LIGHTNING)
		return("Thunderbolt");
	else
		return("Pack of ammo");
};

// called as DropBackpack

void() DropBackpack =
{
	local entity e;
	local float bkt;

	if (Q_100)
	{
		q100_DropBackpack();
		return;
	}

	newmis = world;

// toss limits Q, PK, q / pk guy code
// CHECK: what d, q2, q3 guy drop in dm when dead

	if (!PK_100)
	if ((MAP_MODE != "Q") && (MAP_MODE != "PK"))
	if (self.class_select != "class_monster")
	if (self.morphy != CHAR_Q)
	if (self.morphy != CHAR_PK)
	{
		if (self.morphy == CHAR_W) return;
		if (self.morphy == CHAR_D) return;
		if (self.morphy == CHAR_Q2) return;
		if (self.morphy == CHAR_Q3) return;
	}

	if (DEAD_THROW_NOWAY)
	if (noway_below)
	if (self.origin_z < noway_below) return;
	if (noway_above)
	if (self.origin_z > noway_above) return;

	if (!self.flags & FL_MONSTER) // monsters always get to throw down
	if (DEAD_XPACK == 3) return; // code for no packs at all

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells + self.ammo_bullet + self.ammo_slug + self.ammo_gaspr + self.ammo_hgrenade + self.pk_explode_ammo))
		return;	// nothing in it - IDEA: randomize some stuff?

	newmis = spawn();
	newmis.origin = self.origin - '0 0 24';

	newmis.items = self.weapon;
	newmis.pk_items = 0;
	newmis.classname = "backpack";

	bkt = BACKPACK_TIME + crandom() * BACKPACK_TIME_DV;

	if (self.eweapon && (DEAD_XPACK == 1)) // xweap was unholstered - see if it goes in pack
	{
		newmis.eweapon = self.eweapon;
		newmis.eweapon.wad = "packwep";
		newmis.eweapon.classname = item_by_mcode(newmis.eweapon.mcode); // for touch
		newmis.eweapon.model = "";
		newmis.eweapon.owner = newmis;
		newmis.netname = newmis.eweapon.netname;
		newmis.eweapon.items = self.weapon; // newmis.eweapon.items & WEP_ITEM_MASK; // ARG: now all vwep xwep all have to have proper weapon bit code to go to items
																						  // had to do this because laser cannon was getting wrong weapon value & not selectable
		xwep_ammo(newmis.eweapon, self);
		dyn_remove(newmis.eweapon, bkt + REMOVE_DV + 1, SUB_Null); // set up an eventual remove if pack uncollected
	}
	else

	if (DEAD_XPACK == 2)
	{
		newmis.items = 0;
		newmis.pk_items = 0;
		newmis.netname = "Pack of ammo";
	}
	else // standard weapon
	{
		if (newmis.items == IT_AXE)
			newmis.pk_items = self.pk_currentitem; // Cataboligne - 9.6.11 - fix a bug in the pk1.1 source!
		newmis.netname = swep_id(newmis.items, self);
	}

	newmis.ammo_shells = self.ammo_shells;
	newmis.ammo_nails = self.ammo_nails;
	newmis.ammo_rockets = self.ammo_rockets;
	newmis.ammo_cells = self.ammo_cells;

// new ammo
	newmis.ammo_bullet = self.ammo_bullet;
	newmis.ammo_slug = self.ammo_slug;
	newmis.ammo_gaspr = self.ammo_gaspr;
	newmis.ammo_hgrenade = self.ammo_hgrenade;

	if (DEAD_THROW_PKI != 2)
	{
		self.pk_gravitywellammo = fabs(self.pk_gravitywellammo); // knob of supers
		newmis.pk_gravitywellammo = self.pk_gravitywellammo;
		newmis.pk_turretammo = self.pk_turretammo;
		newmis.pk_canpabammo = self.pk_canpabammo;
		newmis.pk_beartrapammo = self.pk_beartrapammo;
		newmis.pk_explode_ammo = self.pk_explode_ammo;

// Cataboligne 8.12.9 purify - pk artifacts
		newmis.pkplus_egoammo = self.pkplus_egoammo;
		newmis.pkplus_tombammo = self.pkplus_tombammo;
		newmis.pkplus_actorammo = self.pkplus_actorammo;
		newmis.pkplus_phoneammo = self.pkplus_phoneammo;
// end pk_art
	}

	newmis.velocity_z = 300;
	newmis.velocity_x = -100 + (random() * 200);
	newmis.velocity_y = -100 + (random() * 200);

	newmis.flags = FL_ITEM;
	newmis.solid = SOLID_TRIGGER;
	newmis.movetype = MOVETYPE_TOSS;
	setmodel (newmis, "progs/backpack.mdl");
	setsize (newmis, '-16 -16 0', '16 16 56');
	newmis.touch = BackpackTouch;

	newmis.nextthink = time + bkt;
	newmis.think = SUB_Remove; // poss. chaos vector
	AddToSplash(newmis); // *pk - splash tossed items

	bot_BackpackSetup(newmis); // *bot
	newmis.mask_x = CB_HUMAN + CB_GREMLIN; // IMP: rest of morph bp touch
};


// moved from items.qc - Cataboligne - 3.27.8

// think to reset to SUB_regen after item moved & timeout

void() ip_regen =
{
	self.model = string_null;
	self.solid = SOLID_NOT;

	self.nextthink = time + 1;
	self.think = SUB_regen;
};

// think to check for item movement, set respawn think if moved
// chaos mod vector

void() ip_checkForMovement =
{

	if (self.solid != SOLID_NOT)
	{
		if (self.map == "rune" && RUNES && self.classname == "item_sigil")// && self.delay > -1)  // !chaos
		{
			rune_relocate();
			if (self.think == fade_relocate) return; // its gone
		}
		else
		if (self.ip_orgOrigin != v0)
		if (self.ip_orgOrigin != self.origin)
		{ // position has changed... repawn after x minutes..
			if (self.mcode != self.scode) // item was changed by rndize
			{
				self.nextthink = time + CFM_TIME;
				if (self.ip_orgOrigin_x == self.origin_x)
				if (self.ip_orgOrigin_y == self.origin_y) return;
			}

			self.think = ip_regen;
			self.nextthink = time + (ip_timeout * (RSP_TIME * 2));
			return;
		}
	}
	self.nextthink = time + CFM_TIME;
};

// called from SUB_regen - restors position, rethinks

void() pk_item_position =
{
	self.owner = world;

// Cataboligne - 10.25.11 - special so we can bounce some regular things once - here cause item_call on non dyn goes thru sub_regen
	if (self.punchangle == MED_BOUNCE_NOW)  // bounce it now
	{
		item_eject(self, MED_BOUNCE);
		self.punchangle = anti_bounce;
		return;
	}

	self.think = ip_checkForMovement;
	self.nextthink = time + CFM_TIME;

	if (self.mcode != self.scode) // item was changed by rndize
	{
		if (self.ip_orgOrigin_x == self.origin_x)
		if (self.ip_orgOrigin_y == self.origin_y) return;
	}

	if (self.ip_orgOrigin != self.origin)
	if (self.ip_orgOrigin != v0) // Cataboligne - tweak: in case this doesnt get set, we dont want to put any item like this at 0, 0, 0
		setorigin (self, self.ip_orgOrigin);
	else
		setorigin (self, self.origin);

	rune_bounce();
};

// give tossed items eject velocity

void(entity e, vector v1) item_eject =
{
	e.velocity_z = v1_z + 100 * random();
	e.velocity_x = crandom() * v1_x;
	e.velocity_y = crandom() * v1_y;

};

// called from PlaceItem, starts position think checks
// chaos mod vector

float cfm_spread; // spread out think times on items

void() pk_item_position_init =
{
//	if (WARNING) if (!PK) bprint("*** warning: pk_item_position_init called when not in PK mode.\n");

	if (self.ip_orgOrigin == v0 || self.delay == RE_LOC)
		self.ip_orgOrigin = self.origin;

	if (self.delay == RE_LOC) self.delay = 0;

	self.think = ip_checkForMovement;
	self.nextthink = time + CFM_TIME + cfm_spread;
	cfm_spread = cfm_spread + 2;
	if (cfm_spread > 60) cfm_spread = 1;
	

// dynamic items should not end up here
	if (WARNING)  if (self.event == "dynamic_item")
		bprint("*** warning: dynamic item in pk_item_position_init() \n");

};

// called from PlaceItem - sorts many things now - happens 0.2 secs after map load

void() pk_placeitem =
{
	if (self.event != "dynamic_item")
	{
		pk_item_position_init();
	}
	else
	{
		if (self.punchangle != anti_bounce) // no eject code
		if (self.punchangle != v0)
			item_eject(self, self.punchangle);
		else
			item_eject(self, GEN_BOUNCE);
	}

// handle extra item stuff
	if (self.pk_touch == (void()) 0) // dont swamp pointers
	{
		self.pk_touch = self.touch;
	}
	if (self.th_stand != painkeep_touch) // pk100 mask
		self.touch = painkeep_touch; // take over - route everything here
	
// TESTING - see if we can q1 default class select
	if (self.class_select == "") self.class_select = "quake_item";

//	if (XMOD)
	if (!PK_100 && !Q_100)
	{
		if (self.wad == "q1") master_item_control(self, 0); // TEST: comment for q1 item comparison
		else 
					if ((TR_ALL || TR_WOLF) && self.class_select == "wolf_item")  master_item_control(self, TR_WOLF);
		else if ((TR_ALL || TR_DOOM) && self.class_select == "doom_item")  master_item_control(self, TR_DOOM);
		else if ((TR_ALL || TR_QUAKE) && self.class_select == "quake_item")  master_item_control(self, TR_QUAKE);
		else if ((TR_ALL || TR_Q2) && self.class_select == "q2_item")  master_item_control(self, TR_Q2);
		else if ((TR_ALL || TR_Q3) && self.class_select == "q3_item")  master_item_control(self, TR_Q3);
	}


// Cataboligne - added check here because new mode (not permanently PK & loaded a PK map can set PK mode after nailguns get loaded on map
	if (PK) // pulse nail replace
	if (self.wad == "") // not a live spawn - i.e. a map spawn
	if (self.classname != "weapon_nailgun_q1")
	if (self.classname == "weapon_nailgun" || self.weapon == IT_NAILGUN)
	if (self.model == "progs/g_nail.mdl")
	{
		setmodel (self, "progs/g_fnail.mdl");
		self.netname = "Pulse Rifle";
	}

	self.mcode = pk_mcode("", self); // put map code on ent - do we need this? placeitem sets these too
//	self.sscode = ftos(self.mcode);
	self.sscode = sid_code[(int)(self.mcode - 100) * %4];
	if (!self.scode) self.scode = self.mcode;

	AddToSplashBig(self); // Cataboligne - 6.11.10 - items move so they should & restore on fall from grace
};

// handle drop to floor - new style

void() dtf_handle =
{
	local entity e;
	local vector v1;

	e = dyn_rndloc();
	if (!e) e = findradius(world.origin, 256000);
	if (!e) 
	{
		dprint("Bonus item restore could not find a random (or any) location - giving up\n");
		remove(self);
		return;
	}
	v1 = e.origin + ' 0 0 8';
	if (e.flags & FL_ITEM) // randomize away from other map items
		v1 = stdv_rndloc(e.origin + ' 0 0 8', 50, 100);
	setorigin(self, v1);
};


/// items tags

/*
vars used by items

standard:

.model = string descriptor of model for item appearance
.modelindex = numeric index into set of models indicated by model string
.mdl = model string for regen hide
.size = bounding box / model sizing + following 4 vars
.absmin
.absmax
.mins
.maxs
.origin = location in map
.skin = for multi skinned items (armor)

.netname = descriptive string for grab announce
.classname = map spawn func name, sometimes used in item ops
.solid = SOLID_TRIGGER
.movetype = MOVETYPE_TOSS
.flags  = FL_ITEM, FL_ONGROUND
.velocity = used for eject sometimes

.touch = fn for grab
.nextthink = ip move timeout - 60 secs
.think = ip_checkForMovement (mostly under pk)
.items = regular item inventory value

ops values:

.armorvalue = amount of armor prot
.healtype = what health box does (mod affects this)
.aflag = ammo box adds this ammo (not used by xweaps)
,spawnflags = map load control (ammo) rune server flag

pk stuff:

.ip_orgOrigin = return location for moved items
.pk_items = pk item inventory value
.splash_func = fn call to "splash" an item in liquid
.water_notify = if "yes" (for search) check against splash in liq and call fn above

bot stuff:

--- so pk bots understand items
.th_weight
.th_cache
.th_update
.state = status set by bot route handling?

extended mod codes

.pk_touch = holds actual touch call for wrap code
.*code = map codes [s] = original [m, ss] = current, search string
.class_select = genre tag
.wad = map loaded items can have q1 here mode - dual items 
.wad = dynamic items store (new) classname here
.map = pic_item or rune for server runes
.wait = respawn time
.dmgtime = artifact run time

.lip = ammo type for weps / boxes
,currentammo = ammo to add
.volume = max value code for health, armor, ammo
,spawnflags = rune power indicator

.noise = pickup sound
.noise4 = respawn sound

xweps:

.weaponmodel = v_* model for fpv
.vwepmdl = viswep model
.noise2 = ominous hum played while wep is not holstered
.noise3 = wep fired sound
.target = projectile strike sound

.items = inv slot for this wep
.attack_finished = time an attack takes before wep can fire again
.dmg = damage one attack / projectile / pellet does
.dodmg = splash damage for explosions / plasmas
.dmg_save = ammo used per shot
.dmg_take = amount shot (pellets usually)
.duration = indicates melee weap or sound override or ignore inventory bit

_fr_attack = attack frame code to call on fire
_attack = attack code to call on fire
--- it either attack is SUB_Null the other fn does all attack ops - usually for fire by frames

RUNES
--- these 3 run random relocation code
.count = count val till rune gets moved due to non grab
.cnt = counter measured against .cnt
.delay = counter measured against RUNE_MOVE master move - all runes move even if well sought
.duration = original server flag for map runes

NOT DONE YET:

xweps -
.distance = ranking

*/
