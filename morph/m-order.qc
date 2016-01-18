/* ::-::
 *
 * Cataboligne
 *
 * file: m-order.qc
 *
 * date: 10/4/13
 *
 * qc - support chaos mod morph ability
 *
 */
 
/*
Archon: Order

"the Story"

Order...

The ultimate Arbiter.

A single Icon manifest of justice.

The seasons are so, time procededs from moment to moment.
Planets orbit suns, and all things come to death in time.
This...is...Order!

Order has always been and will always be.

Defy chaos.  Defeat the demons.

*/

$frame tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10 tmp11 tmp12 tmp13 tmp14  tmp15 tmp16 tmp17 tmp18 order1 tmp20
$frame tmpb1 tmpb2 tmpb3 tmpb4 tmpb5 tmpb6 tmpb7 tmpb8 orderfade1 orderfade2 orderfade3 orderfade4 orderfade5



/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

void() player_order_stand = [ $order1, player_stand1 ]
{
	local float rdir;
	self.nextthink = time + 0.2;
	rdir = 0;
 
	if (self.archon < 0)
	{
		de_archon(self);
		return;
	}

	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;

	self.frame = $order1;

	self.volume = self.volume + 2;
};

void() player_order_run = [ $order1, player_run ]
{
	local float rdir;
	self.nextthink = time + 0.1;
	rdir = 0;

	if (self.archon < 0)
	{
		de_archon(self);
		return;
	}

	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;

	self.frame = $order1;

	self.volume = self.volume + 4;
};


void() player_order_attack =
{
	if (self.impulse == ALT_FIRE_IMP)
	{
		if (self.weapon != IT_AXE) // in spell casting mode
		{
			if (self.pkplus_actorammo & 2) // swap able targets - alt fire main fn in spell mode
			if (self.bolt_target)
			if (self.enemy)
			{
				self.th_missile();
				archon_target_clear(self.bolt_target);
				self.bolt_target = self.enemy;
				self.stack1 = self.stack2;
				self.bolt_target.bolt_target.scale = self.bolt_target.bolt_target.scale * 1.2;
				self.enemy = world;
				self.stack2 = null_string;
				stuffcmd(self, "hud_target1 \"");
				stuffcmd(self, self.stack1);
				stuffcmd(self, "\"\n");
				stuffcmd(self, "hud_target2 \"");
				stuffcmd(self, "\"\n");
			}
		}
//		else
//			chaos_beam();
		return;
	}

// fire pressed with spell selected
	if (self.weapon != IT_AXE)
	{
		if (self.pkplus_actorammo & 65536) // spell needs reset
		{
			self.attack_finished = time + 1;
			self.th_missile();
			return;
		}
		if (self.pkplus_actorammo & 2) // spell needs target
		if (!self.bolt_target) return;

		if (self.pkplus_actorammo & 4) // spell needs 2nd target
		if (!self.enemy) return;

//		if ((self.ammo_nails > 3) && self.bolt_target == self) return; // cant target self w/ this spell

		self.th_melee(); // cast spell
		return;
	}

	if (self.archon < -9) return;

	fire_missile(LASERCAN_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + ' 0 0 4', ' 0 0 0', "laser", "progs/laser_m.mdl", "enforcer/enfire.wav", Laser_Blast, 6, SUB_Remove, Laser_Blast);
	newmis.skin = 13;
	newmis.frame = 6;
	self.attack_finished = time + 0.3;		

	self.archon = self.archon - 1;
};

/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/


void() player_order_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

//	morph_impulse();

	if (self.aflag & 16) // no morph during star bursts
	{
		self.items = self.items - (self.items & IT_SUPER_SHOTGUN);
	}
	else
		self.items = self.items | IT_SUPER_SHOTGUN;	

	if (self.impulse == 1)
		self.weapon = IT_AXE;
	else if (self.impulse == 10)
		morph_CycleWeaponCommand(1);
	else if (self.impulse == 12)
		morph_CycleWeaponCommand(-1);
	else if (self.impulse == 14) // slot loops
	{
		if (self.weapon == IT_SHOTGUN) self.impulse = 2;
		if (self.weapon == IT_SUPER_SHOTGUN) self.impulse = 3;
		if (self.weapon == IT_NAILGUN) self.impulse = 4;
		if (self.weapon == IT_LIGHTNING) self.impulse = 8;
	}
	else if (self.impulse == 16) // aux spell loops
	{
		if (self.weapon == IT_SUPER_SHOTGUN)
		{
			if (self.ammo_nails == 5) aux_bits(421887);
			else if (self.ammo_nails == 7) aux_bits(421887);
			else if (self.ammo_nails == 11) aux_bits(1023);
		}
		if (self.weapon == IT_NAILGUN)
		{
			if (self.rune_flag) self.AIRG_Flags = 4194375;
			else self.AIRG_Flags = 71;
			if (self.ammo_rockets == 3) aux_bits(self.AIRG_Flags);
			if (self.ammo_rockets == 7) aux_bits(3);
		}
		if (self.weapon == IT_LIGHTNING)
		{
			if (self.ammo_rockets == 3) aux_bits(3);
			if (self.ammo_rockets == 5) aux_bits(3);
		}
	}

	if (self.weapon == IT_AXE)
	{
//		sprint(self, "Chaos firing random bolts\n");
		clear_spell(); // timeout any spell in selection
	}

	if (!self.pk_beartrapammo) self.pk_beartrapammo = 1;

	if (self.impulse == 2) // spell list 1 - teleports
	{
		if (self.weapon == IT_SHOTGUN) // loop thru spell set
		{
			if (self.ammo_shells == 3) self.ammo_shells = 5; // tele swap
			else if (self.ammo_shells == 5) self.ammo_shells = 7;
			else if (self.ammo_shells == 7) self.ammo_shells = 11;
			else if (self.ammo_shells == 11) self.ammo_shells = 3;
		}
		self.weapon = IT_SHOTGUN;
	}
	if (self.impulse == 3) // spell list 2 - polymorph, transmogrify
	{
		if (self.weapon == IT_SUPER_SHOTGUN) // loop thru spell set
		{
			if (self.ammo_nails == 3) self.ammo_nails = 5;
			else if (self.ammo_nails == 5)
			{
				if (self.pk_beartrapammo & 421887) // skip if no valid bit
					self.ammo_nails = 7;
				else
					self.ammo_nails = 11;
			}
			else if (self.ammo_nails == 7) self.ammo_nails = 3;
//			else if (self.ammo_nails == 11) self.ammo_nails = 13; - order CAN NOT tranmogrify
		}
		self.weapon = IT_SUPER_SHOTGUN;
	}
	if (self.impulse == 4) // spell list 3
	{
		if (self.weapon == IT_NAILGUN) // loop thru spell set
		{
			if (self.ammo_rockets == 3) self.ammo_rockets = 5;
			else if (self.ammo_rockets == 5) self.ammo_rockets = 7;
			else if (self.ammo_rockets == 7) self.ammo_rockets = 3;
		}
//		if ((self.archon < 1500) && self.ammo_rockets == 3) self.ammo_rockets = 5;
		self.weapon = IT_NAILGUN;
	}
	if (self.impulse == 8) // spell list archon
	{
		if (self.weapon == IT_LIGHTNING) // loop thru spell set
		{
			if (self.ammo_cells == 3) self.ammo_cells = 5;
			else if (self.ammo_cells == 5) self.ammo_cells = 7;
			else if (self.ammo_cells == 7) self.ammo_cells = 3;
		}
		self.weapon = IT_LIGHTNING;
	}
	else if (self.impulse == IMP_MSIGHT)
		morph_sound(2, self.msight, 3);							// let player morphs "talk"

	if (self.weapon != IT_AXE)
		spell_target(); // turn on targeter
};

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/


string() player_order_killmsg =
{
	return(rnd_string(' 60.0 50.0 40.0'," was meted justice by ",null_string," got his reward from "," submitted to "," felt the wrath of Order "));
};
string() player_order_killmsg2 =
{
	return "\n";
};

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_order_become = 
{
	local float tc;

	self._stand=player_order_stand;
	self._run=player_order_run;
	self._pain=SUB_False;//player_order_pain; do something different
	self._die=chaos_fade;
	self._jump=SUB_Null;
	self._jump2= SUB_Null;
	self._attack=player_order_attack;
	self._impulse=player_order_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_order_killmsg;
	self._killmsg2=player_order_killmsg2;

	if (self.height != IMP_MORDER) self.state = self.height; // save previous form for de-archon
	self.height = IMP_MORDER;

	self.cam_z = 10 / 100;
	self.cam_y = 36;

	stuffcmd(self, "exec cfg/morph/m-chaos.cfg\n");

	self.builtin = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_LIGHTNING;
	self.items = self.items | self.builtin;
	self.weapon = IT_AXE;
	self.pk_currentitem = PK_IT_AXE;

// spell init
	self.ammo_shells = 7;
	self.ammo_nails = 3;
	self.ammo_rockets = 3;
	self.ammo_cells = 3;

	self.pk_explode_ammo = 0; // spell cost
	self.th_missile = SUB_Null; // spell target
	clear_spell();

	setmodel(self,"progs/chaos_b2.mdl"); // oh the irony
	self.skin = 4;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.msight = "ambience/thunder1.wav";
	self.noise2 = "boss2/idle.wav";
	self.noise3 = null_string;
	self.movetype = MOVETYPE_FLY;
	self.view_ofs = ' 0 0 4';

	self.health = 100 * MCHAOS_HEALMOD;
	self.health_modifier = MCHAOS_HEALMOD;

	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!silent) // silent for starting new level as this beasty
	{
		bprint(self.netname);
		bprint(" has become ");
		bprint(polymorph_id(self.morphy));
		bprint(".\n");
//		morph_impulse();
	}
};







