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
		else
		{
// display the beam
			self.dest1 = self.origin;
			traceline (self.dest1, self.dest1 + v_forward * 910, TRUE, self); // note - can sometimes appear sticking out the back of the archon model
			v1 = self.dest1 - trace_endpos;
			newmis = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, trace_endpos, v0, v0, vectoangles(v1), v0, null_string, "progs/lzrbm_seg.mdl", SUB_Remove, 0.2, SUB_Remove, SUB_Null, self, world);
			newmis.cnt = vlen(v1);
			newmis.cnt = floor(newmis.cnt / 32);
			if (newmis.cnt > 63) newmis.cnt = 63;
			newmis.frame = newmis.cnt + 64;
			newmis.skin = 2;
			newmis.effects = newmis.effects | EF_FULLBRIGHT;
			self.volume = self.volume - 10;
		}
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
		{
			if (!self.bolt_target) return;

			if (self.bolt_target != self)
			if (self.bolt_target.bolt_target == self.bolt_target) // arc ppp protect on
				return;
		}

		if (self.pkplus_actorammo & 4) // spell needs 2nd target
		if (!self.enemy) return;

//		if ((self.ammo_nails > 3) && self.bolt_target == self) return; // cant target self w/ this spell

		self.th_melee(); // cast spell
		return;
	}

	if (self.archon < -9) return;

	if ((self.pk_beartrapammo == 1) || (self.pk_beartrapammo == 2))
	{
		self.stack5 = "enforcer/enfire.wav";
		if (self.pk_beartrapammo == 2) self.stack5 = "weapons/sgun1.wav";
		fire_missile(LASERCAN_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + ' 0 0 4', ' 0 0 0', "laser", "progs/laser_m.mdl", self.stack5, Laser_Blast, 6, SUB_Remove, Laser_Blast);
		newmis.skin = 13;
		newmis.frame = 6;
		newmis.effects = newmis.effects | EF_FULLBRIGHT;
		if (self.pk_beartrapammo == 2)
		{
//			newmis.classname = "missile";
			newmis.scale = 2;
			newmis.th_die = SUB_Remove;
			newmis.touch = T_MissileTouch;
			newmis.dmg = 50;
			self.attack_finished = time + 0.8;
			self.archon = self.archon - 4;
		}
		else
		{
			self.attack_finished = time + 0.3;		
		}
		self.archon = self.archon - 1;
	}
	else if (self.pk_beartrapammo == 4)
	{
		self.button4 = 0;
		self.enemy = findradius(self.origin, 120);
		self.attack_finished = time + 1;
		while (self.enemy)
		{
			if (self.enemy != self)
			if (self.enemy.takedamage)
			{
				T_Damage(self.enemy, self, self, 35);
				self.button4 = self.button4 + 1;
			}
			self.enemy = self.enemy.chain;
		}
		if (self.button4)
		{
			newmis = chaos_spawn(0, 0, 0, 0, self.origin, v0, v0, v0, v0, null_string, "progs/sphere_annihilation.mdl", SUB_Null, 0.2, remove_fade, SUB_Null, self, world);
			newmis.scale = 14;
			newmis.skin = 3;
			newmis = chaos_spawn(0, 0, 0, 0, self.origin, v0, v0, v0, v0, null_string, "progs/sphere_annihilation.mdl", SUB_Null, 0.6, remove_fade, SUB_Null, self, world);
			newmis.scale = 7;
			newmis.skin = 3;
			self.archon = self.archon - 10;
			if (self.button4 > 2) self.archon = self.archon - 10;
			sound (self, CHAN_WEAPON, "hipitems/empathy.wav", 1, ATTN_NORM);
			self.attack_finished = time + 3;
		}
	}

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

	if (self.impulse == 10)
		morph_CycleWeaponCommand(1);
	else if (self.impulse == 12)
		morph_CycleWeaponCommand(-1);
	else if (self.impulse == 14) // slot loops
	{
		if (self.weapon == IT_AXE) self.impulse = 1;
		if (self.weapon == IT_SHOTGUN) self.impulse = 2;
		if (self.weapon == IT_SUPER_SHOTGUN) self.impulse = 3;
		if (self.weapon == IT_NAILGUN) self.impulse = 4;
		if (self.weapon == IT_SUPER_NAILGUN) self.impulse = 5;
		if (self.weapon == IT_LIGHTNING) self.impulse = 8;
	}
	else if (self.impulse == 16) // aux spell loops
	{
		if (self.weapon == IT_SUPER_SHOTGUN)
		{
			if (self.ammo_nails == 5) aux_bits(421887); // monster set
			else if (self.ammo_nails == 7) aux_bits(421887); // monster set
//			else if (self.ammo_nails == 11) aux_bits(1023);
		}
		if (self.weapon == IT_NAILGUN)
		{
			if (self.rune_flag) self.AIRG_Flags = 4194375;
			else self.AIRG_Flags = 71;
			if (self.ammo_rockets == 3) aux_bits(self.AIRG_Flags);
			if (self.ammo_rockets == 7) aux_bits(3);
		}
		if (self.weapon == IT_SUPER_NAILGUN)
		{
			if (self.ammo_bullet == 7) aux_bits(6377471);
			if (self.ammo_bullet == 11) aux_bits(196480);
		}
		if (self.weapon == IT_LIGHTNING)
		{
			if (self.ammo_cells == 3) aux_bits(3);
//			if (self.ammo_cells == 5) aux_bits(3);
			if (self.ammo_cells == 7) next_imprisoned();
			if (self.ammo_cells == 11) aux_bits(421887); // monster set
			if (self.ammo_cells == 17) aux_bits(7);
		}
	}

	if (self.impulse == 1) // spell list - attacks
	{
		if (self.weapon == IT_AXE)
		{
			self.pk_beartrapammo = self.aflag;
			aux_bits(7);
			self.aflag = self.pk_beartrapammo;
		}
		self.weapon = IT_AXE;
	}

	if (self.weapon == IT_AXE) clear_spell(); // timeout any spell in selection


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
			else if (self.ammo_nails == 5) self.ammo_nails = 7;
			else if (self.ammo_nails == 7) self.ammo_nails = 3;
//			else if (self.ammo_nails == 11) self.ammo_nails = 13; - order CAN NOT tranmogrify

			if (self.ammo_nails == 11)
			{
				if (! self.pk_beartrapammo & 1023) self.pk_beartrapammo = 1;
			}
			else
				if (! self.pk_beartrapammo & 421887) self.pk_beartrapammo = 1;
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

			if (self.ammo_rockets == 7)
			{
				if (! self.pk_beartrapammo & 3) self.pk_beartrapammo = 1;
			}
			else
				if (! self.pk_beartrapammo & 71) self.pk_beartrapammo = 1;
		}
//		if ((self.archon < 1500) && self.ammo_rockets == 3) self.ammo_rockets = 5;
		self.weapon = IT_NAILGUN;
	}
	if (self.impulse == 5) // spell list 4 - create
	{
		if (self.weapon == IT_SUPER_NAILGUN) // loop thru spell set
		{
			if (self.ammo_bullet == 3) self.ammo_bullet = 5;
			else if (self.ammo_bullet == 5) self.ammo_bullet = 7;
			else if (self.ammo_bullet == 7) self.ammo_bullet = 11;
			else if (self.ammo_bullet == 11) self.ammo_bullet = 3;

			if (self.ammo_bullet == 7)
			{
				if (! self.pk_beartrapammo & 6377471) self.pk_beartrapammo = 1;
			}
			if (self.ammo_bullet == 11)
			{
				if (! self.pk_beartrapammo & 196480) self.pk_beartrapammo = 1;
			}
		}
		self.weapon = IT_SUPER_NAILGUN;
	}
	if (self.impulse == 8) // spell list archon legacy
	{
		if (self.weapon == IT_LIGHTNING) // loop thru spell set
		{
			if (self.ammo_cells == 3) self.ammo_cells = 5;
			else if (self.ammo_cells == 5) self.ammo_cells = 7;
			else if (self.ammo_cells == 7) self.ammo_cells = 11;
			else if (self.ammo_cells == 11) self.ammo_cells = 13;
			else if (self.ammo_cells == 13) self.ammo_cells = 17;
			else if (self.ammo_cells == 17) self.ammo_cells = 3;

			if (self.ammo_cells == 3)
			{
				if (! self.pk_beartrapammo & 3) self.pk_beartrapammo = 1;
			}
			else if (self.ammo_cells == 11)
			{
				if (! self.pk_beartrapammo & 421887) self.pk_beartrapammo = 1;
			}
			else if (self.ammo_cells == 17)
			{
				if (! self.pk_beartrapammo & 7) self.pk_beartrapammo = 1;
			}
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

	self.builtin = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_LIGHTNING;
	self.items = self.items | self.builtin;
	self.weapon = IT_AXE;
	self.pk_currentitem = PK_IT_AXE;

// spell init
	self.ammo_shells = 7;
	self.ammo_nails = 3;
	self.ammo_rockets = 3;
	self.ammo_cells = 3;
	self.ammo_bullet = 3;
	if (!self.pk_beartrapammo) self.pk_beartrapammo = 1;

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







