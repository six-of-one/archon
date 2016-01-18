/*-
	+---------------------------------------+
	|  Weapon effects code                  | SEC-HEAD
	+---------------------------------------+
*/

// x weapon inventory store fn

// used from touch functions

// other - must be touching ent (player / bot) recv goody
// self - goodie
// e - viswep ent slot
// nw - new weap item bits
// camcc - current ammo count

entity(entity e, float nw, float camcc) x_wep_store =
{


#ifdef warning
			pkvl = 1;
#endifdef


	if (camcc >= 0) // code from xwep_fakeload so it can use loader
	{
		if (e) // replacing the basics - remove vw ent
		{
			remove(e);
			e = world;
			vw_chain(other);
		}
		e = vload(other, nw);
	}

	e.eweapon = e;
	e._attack = self._attack;
	e._fr_attack = self._fr_attack;
	e.vv_draw = self.vv_draw;
	e.vv_holster = self.vv_holster;
	e.vwepmdl = self.vwepmdl; // for pack / dthrow weps
//		e.touch = self.touch;
//	if (e.vv_draw != (void()) 0) e.movetype = 0; // for now these cant movetype follow - that will come later
	if (e.vv_draw) e.movetype = 0; // for now these cant movetype follow - that will come later

	e.weapon = e.items = self.items;
	if (self.items == IT_AXE) e.pk_currentitem = self.pk_currentitem; // a x item with pk bits - q3 holdables
	e.x_items = self.x_items;
	e.currentammo = self.currentammo;
	e.lip = self.lip;
	e.attack_finished = self.attack_finished;
	e.dmg = self.dmg;
	e.dodmg = self.dodmg;
	e.dmg_save = self.dmg_save;
	e.dmg_take = self.dmg_take;
	e.bulletspread = self.bulletspread;
	if (fabs(camcc) >= 1) e.aflag = fabs(camcc);
	e.style = self.style; // melee flag
	e.lefty = self.lefty; // misc data
	if (self.mcode) e.mcode = self.mcode; // for pack touch deal
//		e.cnt = self.cnt; // vw skinnage
	e.th_melee = SUB_Null;
//	if (self.th_melee != (void ()) 0) e.th_melee = self.th_melee; // multi modes
	if (self.th_melee) e.th_melee = self.th_melee; // multi modes

// alt fire modes
//	if (self._alt_fire != (void ()) 0) e._alt_fire = self._alt_fire; // multi modes
	if (self._alt_fire) e._alt_fire = self._alt_fire; // multi modes
	else self._alt_fire = e._alt_fire = SUB_Null;

//	if (self._killmsg != (void ()) 0) e._killmsg = self._killmsg; // kill messages
	if (self._killmsg) e._killmsg = self._killmsg; // kill messages
	else self._killmsg = e._killmsg = SUB_Null;
//	if (self._killmsg2 != (void ()) 0) e._killmsg2 = self._killmsg2;
	if (self._killmsg2) e._killmsg2 = self._killmsg2;
	else self._killmsg2 = e._killmsg2 = SUB_Null;

	e.netname = self.netname;
	e.mask_x = self.mask_x; // for bp touch & such

	setmodel (e, self.vwepmdl);
	e.modelindex_morph = e.modelindex; // saved only for fists / doom pistol deal

	if (!VW)
	{
		if (!(e.weapon == IT_AXE && e.pk_currentitem == PK_IT_AXE)) // any axe replacement
		if (e.mdl != "progs/vw_q2_hgr.mdl")
		if (e.mdl != "progs/vw_axe.mdl" && e.mdl != "progs/vw_mjolnir.mdl")
			setmodel (e, VW_DEFGUN);
	}
	e.mdl = e.model; // get the assigned model for dead threws
	if (self.skin) e.skin = self.skin;
	e.weaponmodel = self.weaponmodel;
	e.chaosweptime = self.chaosweptime;
	e.endtime = self.endtime;
	e.duration = self.duration;
	e.noise = self.noise; // grabbed
	e.noise1 = self.noise1; // holdable tele
	e.noise2 = self.noise2;
	e.noise3 = self.noise3;
	e.noise4 = self.noise4;
	e.target = self.target; // missile strike snd
	e.target1 = self.target1; // missile models
// hook added
	e.target2 = self.target2;
	e.targetname = self.targetname;
	e.killtarget = self.killtarget;


#ifdef warning
		if (WARNING & 16384)
		{
			bprint(" - md: ");
			bprint(e.vwepmdl);
			bprint(" - mc: ");
			bprint(ftos(e.mcode));
			bprint(" - slot: ");
			bprint(ftos(e.weapon));
			bprint("\n");
		}
		pkvl = 0;
#endifdef


	return(e);
};


// x weapon touch fn

void() x_weapon_touch =
{
	local	float best, new, camc, ign;
	local	entity e, sv;
	local float leave;
	local string cls;

	if (other.classname != "player") // *bot - done in master touch fn
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return ;
	}

	new = self.items; // what weap slot does it go in, by bit - ie, the old q1 IT_* weapon bits, which control the slot position

	if (deathmatch == 2 || deathmatch == 3 || coop)
		leave = 1; // if we are ignoring, dont leave
	else
		leave = 0;

	ign = FALSE;
	e = vchk(new, self.pk_currentitem, other.vwepent); // see if we have this item / slot filled
	if (self.aflag == IGN_INV) // flag says we can ignore existing weps - this will replace current weapon held in indicated slot - NOTE: check if any ammo can differ here ***
	{
		if (e)
		if (e.mdl != self.vwepmdl)
		{
			ign = TRUE; // not the same vwep and replaceable - load a diff vwep
			leave = 0; // this overrides because its a diff wep than what we have
		}
	}

// NOTE: this almost has to be done by ammo type (x wep .lip) with exception of  q1 weps
	if (e)
	if (e.mdl == self.vwepmdl) ign = ! leave; // same wep - can get ammo, if not leaving

	if (e && !ign)
	{
		if (self.classname == "q2_ammo_grenades") // can still get q2 gren as ammo
			pk_ammo_touch();
		return; // cant replace -> cant get this, not compatible
	}

	if (leave && (other.items & self.items))	return;

// if the player was using his best weapon, change up to the new one if better
	sv = self;
	self = other;
	best = W_BestWeapon ();
	self = sv;

	cls = self.classname;
//	if (cls == "dyn_item")
//		cls = self.wad;
//	if (self.mcode)
//		cls = item_by_mcode(self.mcode);


// ammo added is based on classname detection
// 	if a q3 weapon is touched (detect via .noise4) the q3 special case of only adding 1 unit of ammo is handled

/// classname indicates a rocket | blast damage type weapon

	if (cls == "q2_weapon_rocketlauncher" || cls == "q3_weapon_rocketlauncher" ||
		cls == "q3_weapon_grenadelauncher" || cls == "q2_weapon_grenadelauncher" ||
		cls == "q2_ammo_grenades" ||
		cls == "weapon_grenadelauncher" || cls == "weapon_rocketlauncher" ||
		cls == "d_weapon_rocketlauncher" || cls == "w_weapon_mortar" ||
		cls == "weapon_proximity_gun")
	{
	if (self.noise4 == Q3_DET)
	{
		if (other.ammo_rockets > self.currentammo)
			other.ammo_rockets = other.ammo_rockets + 1;
		else
			other.ammo_rockets = self.currentammo;
	}
	else
	other.ammo_rockets = other.ammo_rockets + self.currentammo;
	camc = other.ammo_rockets;
	}

/// classname indicates a shotgun | mass pellet hitscan type weapon

	else if (cls == "d_weapon_shotgun" || cls == "d_weapon_supershotgun" ||
		cls == "q2_weapon_shotgun" || cls == "q2_weapon_supershotgun" ||
		cls == "weapon_shotgun" || cls == "weapon_supershotgun" ||
		cls == "c_weapon_reggun" ||
		cls == "q3_weapon_shotgun")
	{
	if (self.noise4 == Q3_DET)
	{
		if (other.ammo_shells > self.currentammo)
			other.ammo_shells = other.ammo_shells + 1;
		else
			other.ammo_shells = self.currentammo;
	}
	else
	other.ammo_shells = other.ammo_shells + self.currentammo;
	camc = other.ammo_shells;
	}

/// classname indicates a bullet | hitscan type weaon

	else if (cls == "d_weapon_pistol" || cls == "d_weapon_chaingun"
					|| cls == "q3_weapon_machinegun" || cls == "q2_weapon_machinegun"
					|| cls == "w_weapon_machinegun" || cls == "w_weapon_chaingun"
					|| cls == "weapon_chaingun" || cls == "weapon_machinegun"
					|| cls == "w_weapon_pistol")
	{
	if (self.noise4 == Q3_DET)
	{
		if (other.ammo_bullet > self.currentammo)
			other.ammo_bullet = other.ammo_bullet + 1;
		else
			other.ammo_bullet = self.currentammo;
	}
	else
	other.ammo_bullet = other.ammo_bullet + self.currentammo;
	camc = other.ammo_bullet;
	}

/// classname indicates a plasma | BFG | energy shot type weapon

	else if (cls == "d_weapon_plasma" ||
		cls == "q3_weapon_lightning" || cls == "weapon_lightning" ||
		cls == "q3_weapon_bfg" || cls == "weapon_hyperblaster" ||
		cls == "d_weapon_bfg" || cls == "q2_weapon_bfg" ||
		cls == "weapon_bfg" || 
		cls == "weapon_plasmagun" ||
		cls == "weapon_mjolnir" || cls == "weapon_laser_gun")
	{
	if (self.noise4 == Q3_DET)
	{
		if (other.ammo_cells > self.currentammo)
			other.ammo_cells = other.ammo_cells + 1;
		else
			other.ammo_cells = self.currentammo;
	}
	else
	other.ammo_cells = other.ammo_cells + self.currentammo;
	camc = other.ammo_cells;
	}

/// classname indicates a rail slug type weaon

	else if (cls == "q2_weapon_railgun" || cls == "q3_weapon_railgun" ||
		cls == "weapon_railgun")
	{
	if (self.noise4 == Q3_DET)
	{
		if (other.ammo_slug > self.currentammo)
			other.ammo_slug = other.ammo_slug + 1;
		else
			other.ammo_slug = self.currentammo;
	}
	else
	other.ammo_slug = other.ammo_slug + self.currentammo;
	camc = other.ammo_slug;
	}

/// classname indicates a flame fuel type weapon

	else if (cls == "weapon_flamer" || 
		cls == "w_weapon_flamer")
	{
	other.ammo_gaspr = other.ammo_gaspr + self.currentammo;
	camc = other.ammo_gaspr;
	}

/// classname indicates a melee | infinite ammo | non ammo addative type weapon

	else if (cls == "d_weapon_saw" ||
		cls == "c_weapon_shovel" ||
		cls == "q2_weapon_blaster" ||
		cls == "c_weapon_deepsleep" ||
		cls == "weapon_gauntlet" ||
		cls == "weapon_grapplinghook" ||
		cls == "q2_weapon_grapple" ||
		cls == "weapon_hook" ||
		cls == "weapon_quantum" ||
		cls == "c_weapon_tallball" ||
		cls == "w_weapon_knife")
	{
	camc = 1;
	}
	else

/// classname not detected - code needs updated

	{
#ifdef warning
		if (WARNING & 32)
		{
			bprint("\n*** warning:\nx_weapon_touch: unknown classname (");
			bprint(self.classname);
			if (self.event == "dynamic_item")
			{
				bprint(" - ");
				bprint(self.wad);
			}
			bprint(") - ignoring\n\n");
		}
#endifdef
		self.touch = SUB_Null;
		return;
	}

	if (cls == "weapon_hook" || cls == "q2_weapon_grapple" || cls == "weapon_grapplinghook")
	{
		if (! other.pk_items & self.pk_currentitem)
			other.pk_items = other.pk_items | self.pk_currentitem; // NOTE: could set multiple bits
 // NOTE: no other weapons avoid extra pickup - this next bit does block it
//		else
//			return;
	}

	e = x_wep_store(e, new, camc);

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");
// weapon touch sound - stored in .noise by default
	if (self.noise != null_string)
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	else
		sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

//	oldw = other.items;
	other.items = other.items | new;

	e = self;
	self = other;

	PK_Deathmatch_Weapon (new, 0); // *pk - new wep switch rule for higher risk weps

	W_SetCurrentAmmo ();

	xw_parm(other);

	self = e;

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

// players collect x item inventory here

// keys, power armor, etc

void() x_item_touch =
{

	if (other.classname != "player") // *bot - done in master touch fn
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return ;
	}
	if (other.health <= 0)
		return;

	if (other.x_items & self.x_items) return; // already got one

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	other.x_items = other.x_items | self.x_items;

	if (self.netname == "Portable power point")
		archon_ppp_thk();
// nodule special
	else if (self.classname == "archon_nodule") // non Archon only get xp for nodules that arent a god particle
	{
		if (self == god_particle)
		{
			god_particle = world;
			if (! other.mask_x & MORPH_ARCHON) other.archon = other.archon + (self.archon / 2);
		}
		if (other.mask_x & MORPH_ARCHON) other.archon = other.archon + self.archon;
	}

	if (self.noise != null_string)
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

// remove it in single player, or setup for respawning in deathmatch
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

// fn(fire_missle) - generic missile (flying projectile object weapon - FPOW) code, because so much stuff hijacked W_FireRocket

// velmul - velocity multiplier
// mvt - movetype
// cname - classname
// md - model
// sd - weapon sound
// flg - flags = use ammo, morph special fire
// 	FL_PUNCH			// use punchangle for weapon fire
// 	FL_2PUNCH		// double punch
// 	FL_MPUNCH		// mega punch?
// 	FL_MSL				// set missile velocity via aim()
// 	FL_GRN				// set grenade type velocitys
// 	FL_USEAMMO	// for generic fire fns
// 	FL_CTHONF		// cthon fire balls
// 	FL_AIM1K			// aim fn, val 1000
// 	FL_AIM10K			// aim fn, val 10000
// 	FL_AIM100K		// aim fn, val 100000
//		FL_SNDMIS		// sound on missile channel
// ct - content check flags
// org - firing origin, uses self.origin if '0 0 0'
// vdr - firing direction, uses self.v_angle if '0 0 0'
// tch - touch fn
// thk - think fn
// tht - think time
// thd - die, content chk fn

// no_sound (global) dont play sound for this ent

void(float velmul, float mvt, float flg, float ct, vector fmorg, vector vdr, string cname, string md, string sd, void() tch, float tht, void() thk, void() thd) fire_missile =
{
	local float aimer, vmul, rvel;
	local vector vdir, vfw;
	local entity e;

	aimer = 0;
	rvel = 1;

	e = world;					// set eweapon ref
	if (EWEAP) e = EWEAP;
	else if (self.eweapon) e = self.eweapon;

	if (flg) // flag only section
		{
			if (flg & FL_USEAMMO) // fired from wep using ammo
				if (e)
			{
					if (e.lip == AMMO_ROCKETS)
						self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_con(e.dmg_save, self, null_string); // use ammo
					else if (e.lip == AMMO_CELLS)
						self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(e.dmg_save, self, null_string); // use ammo
					else if (e.lip == AMMO_SLUGS)
						self.currentammo = self.ammo_slug = self.ammo_slug - ammo_con(e.dmg_save, self, null_string); // use ammo
					else if (e.lip == AMMO_GRENADES)
						self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_con(e.dmg_save, self, null_string); // use ammo
					else if (e.lip == AMMO_GAS)
						self.currentammo = self.ammo_gaspr = self.ammo_gaspr - ammo_con(e.dmg_save, self, null_string); // use ammo
					else if (e.lip == AMMO_NAILS)
						self.currentammo = self.ammo_nails = self.ammo_nails - ammo_con(e.dmg_save, self, null_string); // use ammo
			}
			if (flg & FL_MPUNCH)
			{
	//			if (!(self.cam_x & CHSCAM_ON))
				self.punchangle_x = 0 - (flg & FL_MPUNCH); // weapon kick in 1pv
//				cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
			}
			if (flg & FL_RUNEHST)
				if (e)
			if (!rune_haste(e.attack_finished / 2))
				rvel = 2; // rune velo multi

		if (flg & FL_AIM1K) aimer = 1000;
		else if (flg & FL_AIM10K) aimer = 10000;
		else if (flg & FL_AIM100K) aimer = 100000;
		}

	newmis = chaos_spawn(mvt, SOLID_BBOX, 0, ct, fmorg, v0, v0, v0, v0, cname, md, tch, tht, thk, thd, self, world);
	if (!newmis) return; // fail

	if (e) newmis.weapon = e.weapon; // obit ident
	if (IS_MISSILE(newmis)) newmis.class_select = "class_missile"; // heh heh - short cut

	vdir = vdr;
	if (vdr == v0)
	{
		if (self.classname == "pk*bot")
			vdir = botaim ();
		else
		vdir = self.v_angle; // fire dir & speeds
	}
	makevectors (vdir);
	vfw = v_forward;
	if (flg & FL_CTHONF)
	{
		vdir = v0;
		vfw = vdr;
	}

	vmul = velmul; // set velocitys
	if (flg & FL_GRN) // set grenade velocity
		{
		if (vdir_x)
			newmis.velocity = vfw * vmul + v_up * (vmul / 3.0) + crandom()*v_right*10 + crandom()*v_up*10;
		else
			{
			if (aimer) newmis.velocity = aim(self, aimer);
			else newmis.velocity = normalize(vfw);
			newmis.velocity = newmis.velocity * vmul;
			newmis.velocity_z = vmul / 3.0; // calculated from grenades velmul to match org settings, scales up
			}
		newmis.avelocity_x = vmul / 2.0; // grenade avelocity - in flight turn
		newmis.avelocity_y = vmul / 2.0;
		newmis.avelocity_z = vmul / 2.0;
		vmul = 1.0;
		}
	else if ((flg & FL_MSL) && aimer) // missile velocity
		{
		if (aimer) newmis.velocity = aim(self, aimer);
		}
	else
		{
		newmis.velocity = normalize(vfw); // default velocity - fired in look dir v_forward or vdr if not '0 0 0'
		}

	newmis.velocity = newmis.velocity * vmul * rvel;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.pos1 = normalize(newmis.velocity);

//	if (no_sound != self)
	if (sd != null_string)
		{
		if (flg & FL_SNDMIS) sound (newmis, CHAN_WEAPON, sd, 1, ATTN_NORM);
		else sound (self, CHAN_WEAPON, sd, 1, ATTN_NORM);
		}

//	newmis.frags = NOFAKE; // no missile fakeloads by default - need to change if this ever fires weapons out
	AddToSplash(newmis);
};



// upgrade any missile to smart missile tracker

// e - missile ent
// tch - touch function for contact
// dmg - damage assigned to missile
// self - ent firing missile

void(entity e, void () tch, float dm) Track_Missile =
{
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1) flytime = 0.1;

//	self.effects = self.effects | EF_MUZZLEFLASH;
//	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	e.owner = self;

	e.solid = SOLID_BBOX;
	e.movetype = MOVETYPE_FLYMISSILE;
//	setmodel (e, "progs/k_spike.mdl");

	setsize (e, v0, v0);

	e.dmg = dm;
//	e.origin = self.origin + '0 0 10';
	e.velocity = dir * 400;
//	e.avelocity = '300 300 300';
	e.nextthink = flytime + time;
	e.think = ShalHome;
	e.enemy = self.enemy;
	e.touch = tch;
	AddToSplash(e); // *pk - Make this entity splash
};


void() melee_hit =
{
	local vector source, org;
	local float dm;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	if (self.classname == "pk*bot")
	{
		source = botaim ();
	}
	
	dm = EWEAP.dmg_save;
	if (!dm) dm = 64;
	traceline (source, source + v_forward * dm, FALSE, self);


	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		self.chaosweptime = 0;
		ominous_hum(EWEAP.target, EWEAP.endtime);
		trace_ent.axhitme = 1;

		dm = EWEAP.dmg;
		if (!dm) dm = 20;
		else if (dm == DOOM_ML_DMG) dm = 10 * ceil(random() * 2);
		SpawnBlood (trace_ent, org, '0 0 0', dm);
		T_Damage (trace_ent,self,self,dm);
	}
	else
	{	// hit wall
		sound (self, CHAN_ITEM, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}
};

// new nail touch - does "stuff"

void() pulse_rebound;

void() spike_touch =
{
	local vector off;

	if (other) // exclude world - need to impact walls
	if (other == self.owner)
		return;

	if (other.touch == self.touch) // fix for mystery disappearing missiles when a shit ton of stuff is launched
		return;

// note - above fix replaces this
//	if (other.classname == self.classname) // super scourges hose out a ton of spikes
//		return;

	if (sky_touch(null_string, v0, self))
	{
		SUB_Remove();
		return;
	}

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing
		
	if (other.classname == "monster_scourge") // scourge dont kill scourge
	if (self.netname == "monster_scourge")
	{
		SUB_Remove();
		return;
	}

	if (!self.dmg) self.dmg = 9;
	
	off = v0;

// hit something that bleeds
	if (other.takedamage)
	{
		if (self.classname == "pulse_spike") 
		{
			self.wad = self.classname;
			self.classname = "spike"; // reflective gets removed
			self.owner = self.theowner; // restore owner - was set to world after bounce
		}
		spawn_touchblood (self.dmg);
		T_Damage (other, self, self.owner, self.dmg);
	}
	if (!other.takedamage
#ifdef enhanced
//		|| (other.solid != SOLID_SLIDEBOX && ENHANCED)
		|| (other.solid != SOLID_SLIDEBOX)
#endifdef
		)
	{
		local float rn;
		if (self.frame != 5) rn = 0.07;

		makevectors(self.angles);

		if (self.classname == "pulse_spike") // pulse spikes reflect off solids
		{
//			if (!(Q-100 || PK-100))

			v_forward = normalize(self.velocity);
//				off = lava_shot(self.origin, LAVA_SHOT, v0, self.dmg / 9);
			if (off != v0 && random() > SPIKE_STICK)
			{
				SUB_Remove();
				return;
			}

		// play ricochet sound
			rn = random() * 100;
			if (rn < 33)		sound (self, CHAN_AUTO, "pulse/ric_1.wav", 1, ATTN_NORM);
			else if (rn < 66)	sound (self, CHAN_AUTO, "pulse/ric_2.wav", 1, ATTN_NORM);
			else					sound (self, CHAN_AUTO, "pulse/ric_3.wav", 1, ATTN_NORM);

		// rebound
			self.movetype = MOVETYPE_BOUNCE;
			self.think = pulse_rebound; //spike_pulse_rebound; - this clears owner
			self.ltime = self.nextthink;
//		self.upgrade_time = self.nextthink;
			self.nextthink = time + 0.1;
		}
// code sticks spikes in solids
		else
		{
			v_forward = normalize(self.velocity);
//			off = lava_shot(self.origin, LAVA_SHOT, v0, self.dmg / 9);
			if (off != v0)
				self.origin = off;
			else
			if (self.model == "progs/spike.mdl")// && self.frame == 5) // any spike for now
			if (pointcontents (self.origin + v_forward * 16) == CONTENT_SOLID)
			if (random() < SPIKE_STICK)
			{
				move_stop(self, null_string);
				setorigin(self, self.origin + v_forward * -1 * (2 + 8 * random()));  // backup abit
				if (!deathmatch)
					self.nextthink = time + 20 + random() * 100; // max 2 mins - sp | coop
				else
				self.nextthink = time + 6 + random() * 4;
				self.think = SUB_Remove; //SUB_FadeRemove;
				self.dmg = 0; // get rid of nail on touch - dont do dmg
				return;
			}
		}

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else if (self.model == "progs/s_spike.mdl" || self.classname == "pulse_spike")
			WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	if (self.classname != "pulse_spike") SUB_Remove();
};


// moved from viswep.qc - belongs here, its home now - YAY

// run full viswep frames for super nailgun / nailgun

void() player_nail3   =[$lightfatt3, player_nail4  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (4);
//	self.attack_finished = time + 0.2;
};
void() player_nail4   =[$lightfatt4, player_nail1  ] // *pk - viswep - Cataboligne - 9.29.9
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (-4);
//	self.attack_finished = time + 0.2;
};

// run full viswep frames for chain thunderbolt

void() player_bolt3	 =[$lightfatt3, player_bolt4  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	bolt_fire();
	if (rune_haste(0.1))
	self.attack_finished = time + 0.2;

	if (self.morphy == IMP_MENF) self.frame = 33;
};

void() player_bolt4	 =[$lightfatt4, player_bolt1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	bolt_fire();
	if (rune_haste(0.1))
	self.attack_finished = time + 0.2;

	if (self.morphy == IMP_MENF) self.frame = 35;
};


// eweapon missiles

void () X_MissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

	if (!self.dmg) self.dmg = 100 + random() * 20;
	else if (self.dmg == DOOM_ROCK_DMG) self.dmg = 20 * ceil(random() * 8);
	if (!self.dodmg) self.dodmg = 120;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			self.dmg = self.dmg * 0.5;	// mostly immune
		T_Damage (other,self,self.owner,self.dmg);
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self,self.owner,self.dodmg,other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);

	BecomeExplosion ();

	if (self.target != null_string) sound (self, CHAN_WEAPON, self.target, 1, ATTN_NORM);
};

// handle eweapon hitscan bullet shooters
float tdmg;

void (float shotcount, float pdmg, vector dir, vector spread) X_FireBullets =
{
	local vector direction;
	local vector src;
	local float ddmg;

	makevectors (self.v_angle);

	ddmg = pdmg;

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		if (pdmg == DOOM_SHOT_DMG) ddmg = 5 * ceil(random() * 3);

		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (ddmg, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
X_FireHitscan - fire eweapon hit scan weps
================
*/
void () X_FireHitscan =
{
	local vector dir;
	local float f, d, t;

	self.punchangle_x = -2 * EWEAP.dmg_save;
//	cam_punch(); // Cataboligne - 6.26.10 - because of fire from frames call

	if (EWEAP.lip == AMMO_SHELLS)
		f = self.ammo_shells;
	else if (EWEAP.lip == AMMO_BULLETS)
		f = self.ammo_bullet;
	d = EWEAP.dmg_save; // ammo to fire
	t = EWEAP.dmg_take; // shots to fire

	if (EWEAP.lip != AMMO_NONE)
	{
		f = f - ammo_con(d, self, null_string); // use ammo
		if (f < 0)
		{
			d = d + f; // only can fire this many
			f = 0;
			t = EWEAP.dmg_take * (d / EWEAP.dmg_save); // pellets or bullets we get to shoot due to reduced ammo
		}

		if (!ammo_con(EWEAP.weapon, self, "wpck"))
		if (d < 1) // NOTE: can this ever happen?
		{
			self.weapon = W_BestWeapon ();
			self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
			W_SetCurrentAmmo ();
			if (self.classname == "pk*bot")
				self.think = self.th_run;
			return ;
		}
	}

	if (EWEAP.lip == AMMO_SHELLS)
		self.currentammo = self.ammo_shells = f;
	else if (EWEAP.lip == AMMO_BULLETS)
		self.currentammo = self.ammo_bullet = f;

	if (self.classname == "pk*bot")
		dir = botaim ();
	else
		dir = aim (self,100000);

	X_FireBullets (t, EWEAP.dmg, dir, EWEAP.bulletspread);

// deepsleep hack - NOTE: uses v_up & v_right set by previous call
	if (EWEAP.mdl == "progs/vw_deepsleep.mdl") X_DeepSleepBlst(dir, trace_endpos, '0.2 0.2 0', EWEAP.target);
};


// fire machine guns & chain guns

void(float ns) mgchg_shot =
{
	local string fsnd;

	EWEAP = self.eweapon;
	if (EWEAP)
	{
		X_FireHitscan();
		if (rune_haste(EWEAP.attack_finished / 2))
			self.attack_finished = time + EWEAP.attack_finished;
		if (ns)
		if (EWEAP.noise3 != null_string)
		{
			fsnd = EWEAP.noise3;
			if (fsnd == "q2_bullet_5")
				fsnd = rnd_string(v0, "q2_snd/machgf1b.wav", "q2_snd/machgf2b.wav", "q2_snd/machgf3b.wav", "q2_snd/machgf4b.wav", "q2_snd/machgf5b.wav");
			sound (self, CHAN_WEAPON, fsnd, 1, ATTN_NORM);
		}
		EWEAP = world;
	}
	else
	{
#ifdef warning
		if (WARNING & 32) bprint("*** Warning -  EWEAP fn() call and eweapon is NULL!\n");
#endifdef
		self.weapon = W_BestWeapon ();
		self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
		W_SetCurrentAmmo ();
		if (self.classname == "pk*bot") self.think = self.th_run;
	}
};

void() player_mgchg1   =[$lightfatt1, player_mgchg2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	mgchg_shot(1);
	if (self.eweapon)
	{
		self.nextthink = time + self.eweapon.attack_finished;
		if (!rune_haste(self.eweapon.attack_finished / 2))
			self.nextthink = time + self.eweapon.attack_finished / 2;
	}
};

void() player_mgchg2   =[$lightfatt2, player_mgchg3  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	mgchg_shot(1);
	if (self.eweapon)
	{
		self.nextthink = time + self.eweapon.attack_finished;
		if (!rune_haste(self.eweapon.attack_finished / 2))
			self.nextthink = time + self.eweapon.attack_finished / 2;
	}
};

void() player_mgchg3   =[$lightfatt3, player_mgchg4  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	mgchg_shot(1);
	if (self.eweapon)
	{
		self.nextthink = time + self.eweapon.attack_finished;
		if (!rune_haste(self.eweapon.attack_finished / 2))
			self.nextthink = time + self.eweapon.attack_finished / 2;
	}
};

void() player_mgchg4   =[$lightfatt4, player_mgchg1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	mgchg_shot(1);
	if (self.eweapon)
	{
		self.nextthink = time + self.eweapon.attack_finished;
		if (!rune_haste(self.eweapon.attack_finished / 2))
			self.nextthink = time + self.eweapon.attack_finished / 2;
	}
};

// fire pistols & other items that use axe frames

// uses a few axe frames & a hack to create the appearance of holding up and firing a pistol type weapon
// this saved buku work making an entire new frameset and animating through its positions
// it looks midly believable - very acceptable for q1 level appearances anyway
// and now we bring you..."how not to be seen"

float GUN_WAIT  = 666020;
float GUN_BASE  = 666000;

void() player_pistol4 = [$axatt6, player_pistol5] { };
void() player_pistol5 = [$axstnd11, player_pistol6] { };
void() player_pistol6 = [$axstnd12, player_stand1] { };

void() player_pistol1 =
{
	self.nextthink = time + 0.1;
	self.think = player_pistol1;

	if (self.eweapon)
	{
		if (self.eweapon.tag_entity)
		if (self.eweapon.origin_z > 0)
			self.eweapon.origin_z = 0;

 // set fists if no doom pistol ammo
		if (self.eweapon.mcode == MC_D_PISTOL)
		if (self.ammo_bullet <= 0)
		{
			self.eweapon.grap_state = 666000;
			self.eweapon.modelindex = 0;
			self.eweapon.noise3 = "weapons/ax1.wav";
		}

		if (self.eweapon.grap_state == 666000) // use fists
		{
//			sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
			self.eweapon.tomb_time = random();

			if (self.eweapon.tomb_time < 0.5)
				player_axe1 ();
			else if (self.eweapon.tomb_time <0.7)
				player_axeb1 ();
			else if (self.eweapon.tomb_time <0.8)
				player_axec1 ();
			else
				player_axed1 ();
			if (rune_haste(0.25))
			self.attack_finished = time + 0.5;
			return;
		}
	}

	if (self.tomb_time > GUN_BASE)
	{
		if (self.weaponframe > 1)
			self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe >= 6)
			self.weaponframe = 1;
		self.frame = $axatt2;
		self.tomb_time = self.tomb_time - 1;
		if (self.tomb_time <= GUN_BASE) // done - go back
		{
			self.tomb_time = 0;
			player_pistol4();
		}
		if (!self.button0)
		{
			if (self.velocity_x || self.velocity_y)
			{
				self.tomb_time = 0;
				player_run();
			}
			return;
		}
		else
		{
			self.tomb_time = 0;
			self.weaponframe = 0;
			if (self.eweapon)
				setorigin(self.eweapon, self.eweapon.origin + '0 0 1.33'); 
		}
	}

	if (self.weaponframe > 3)
		self.weaponframe = 0;

	if (self.weaponframe == 3) // fire!
	{
		self.frame = $axatt2;
		EWEAP = self.eweapon;
		SuperDamageSound();
		if (EWEAP.mdl == "progs/vw_deepsleep.mdl")
			sound (self, CHAN_WEAPON, EWEAP.noise3, 1, ATTN_NORM); // should done by fire code below - why do we need this?

		if (EWEAP.mdl == "progs/vw_q2_blst.mdl")
			X_FireBlaster();
		else
		X_FireHitscan();

		self.nextthink = time + EWEAP.attack_finished;
		if (!rune_haste(EWEAP.attack_finished / 2))
			self.nextthink = time + EWEAP.attack_finished / 2;

		EWEAP = world;
		self.tomb_time = GUN_WAIT;
		return;
	}

	self.weaponframe = self.weaponframe + 1;

	if (self.weaponframe <= 1) // bring pistol up to fire
	{
		if (self.frame != $axatt2)
			self.frame = $axstnd8;
		return;
	}

	if (self.weaponframe == 2)
	{
		if (self.frame != $axatt2)
			self.frame = $axatt6;
		return;
	}

	if (self.weaponframe == 3) // ready
	{
		if (self.frame != $axatt2)
			self.frame = $axatt2;
		return;
	}

};


// fire plasma & guns

void() plspg_fade =
{
	if (self.model == "progs/s_plspg.spr")
	{
		self.alpha = self.alpha - 0.1;
		self.enemy.alpha = self.enemy.alpha + 0.1;
		if (self.alpha < 0) remove(self);
		else self.nextthink = time + 0.2;
	}
	if (self.model == "progs/s_plspg2.spr")
	{
		self.alpha = self.alpha - 0.1;
		if (self.alpha < 0) remove(self);
		else self.nextthink = time + 0.2;
	}
};

// fn(plasmaexplode1) - wash plasma bolt out of world
// fn(Plasma_MissileTouch) - blow a plasma bolt - handles monster stuff if eweapon not set
// fn(X_FireOnePlasma) - fire a single plasma bolt, handles weapon stuff

void() plasma_stain =
{
	if (self.mcode == MC_Q3_PLASMA)
	if (!XENV)
	{
		setmodel(self.aiment.aiment, "progs/s_plspg.spr");
		setmodel(self.aiment, "progs/s_plspg2.spr");
		self.aiment.aiment.enemy = self.aiment;
		self.aiment.aiment.scale = 8;
		self.aiment.scale = 8;
		self.aiment.aiment.alpha = 1;
		self.aiment.alpha = 0.1;
		self.aiment.aiment.nextthink = time  + 2;
		self.aiment.nextthink = time  + 27;
	}
};

void () plasmaexplode5 = [ 7, plasmaexplode6 ] { self.alpha = 0.3; };
void () plasmaexplode6 = [ 8, SUB_Remove    ]
{
	self.alpha = 0.1;
	plasma_stain(); // chaos vector
};

void () plasmaexplode1 = [ 3, plasmaexplode2 ] { self.alpha = 0.7; };
void () plasmaexplode2 = [ 4, plasmaexplode3 ] 
{
	if (random() < 0.5) self.think = plasmaexplode5;
	self.alpha = 0.5;
};
void () plasmaexplode3 = [ 5, plasmaexplode4 ] { self.alpha = 0.3; };
void () plasmaexplode4 = [ 6, SUB_Remove    ]
{
	self.alpha = 0.1;
	plasma_stain();
};

void () Plasma_MissileTouch =
{
	local vector org;
	local string mon;
	local float bdm;

	if (other == self.owner)
	{
		return;
	}

	if (sky_touch(null_string, org, world))
	{
		if (self.enemy) remove (self.enemy);
		remove(self);
		return;
	}

	if (self.noise3 == null_string) self.noise3 = "doom/dsfirxpl.wav";

	sound (self, CHAN_ITEM, self.noise3, TRUE, ATTN_NORM);

	if (!self.dmg)
	{
#ifdef warning
																			if (WARNING & 32) bprint("plasma missle touch set def damage\n");
#endifdef
//		if (self.frame == 1) self.dmg = 75;
//		else 
			self.dmg = 15;
	}

	org = v0;
	v_forward = normalize(self.velocity);
//	if (!XENV)
//	org = lava_shot(self.origin, LAVA_SHOT * 2.4, v0, self.dmg / 10);
//	if (org != v0)
//		self.origin = org;

// explosive plasma - bigger bolt
/*
	if (self.frame == 1)
	{																		if (WARNING & 32) bprint("plasma explosive\n");
		if ((org != v0) && (random() < LAVA_PLASMA_MLT))
		{ 																if (WARNING & 32) bprint("plasma bomb failed in lava\n");
			content_clear(self);
			self.th_stand = self.touch = SUB_Null;
			move_stop(self, "misc/null.wav");
			self.think = meltthink;
			self.nextthink = time + random() * 3;
			return;
		}
		Explode(0, self.dmg + random() * (self.dmg * 0.375), other, TE_EXPLOSION, 0, BecomeExplosion);
		return;
	}
*/
	org = (self.origin - (8 * normalize (self.velocity)));

	if (other.health)
	{
		SpawnBlood (other, org, (self.velocity * 0.2), 15);
		T_Damage (other, self, self.owner, self.dmg);
	}

// some plasma may splash
// don't do radius damage to the other, because all the damage was done in the impact
	bdm = self.dodmg;
	if (!deathmatch)
	if (self.delay == Q2_BFG) bdm = self.dmg; // because in SP dodmg is 500 for trace dmg - did this way in case values are modded

	if (bdm)
		T_RadiusDamage (self, self.owner, bdm, other);

	if (self.enemy) // bfg shot - handle trace damages
	{
		if (self.delay == DOOM_BFG) // activate trace dmg
			self.enemy.nextthink = time + 0.2;
		else if (self.delay == Q2_BFG)
		{
			self.enemy.nextthink = time + 0.01;
			self.enemy.flags = Q2_BFG; // stop lasers & do blast rays
		}
	}

	self.velocity = '0 0 0';
//	move_stop(self, null_string);
	self.th_stand = self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	plasmaexplode1 ();
};

// because q3 map skys dont touch bfg balls - they fuse out, and q2 leaves laser trace thinks
void() bfg_trace_thk;

void() Plasma_MissileFuseOut =
{

// dont want q2 bfg blast rays if ball fuses out, because something went wrong, or it died after a long flight
// fxnote - get rid of q2 bfg trace think on fuse out - otherwise it hangs around doing wierd shit - NOTE: chaos mod vector?
	if (self.enemy)
	if (self.enemy.think == bfg_trace_thk)
		remove(self.enemy);
	self.enemy = world;

	Plasma_MissileTouch();
};

void () X_FireOnePlasma =
{
//	local vector org;
	local string snd, pls, expl;
	local float dm, dbfg;
	vector org, bfwd;

	dbfg = 0; // detect bfgs
	dm = 15;
	pls = "progs/d_plasma_sht.mdl";
	expl = "doom/dsfirxpl.wav";
	snd = "doom/dsplasma.wav"; // TWEAK - different generic, chaos will come here
//	org = self.origin; // self.origin + (v_forward * 30) + '0 0 11' - arach ref
	if (EWEAP) 
	{
//		self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(EWEAP.dmg_save, self, null_string); // use ammo
		dm = EWEAP.dmg;
		snd = EWEAP.noise3;
		if (EWEAP.mdl == "progs/vw_d_bfg.mdl" || EWEAP.mdl == "progs/vw_q2_bfg.mdl") snd = null_string;
		if (dm == DOOM_SHOT_DMG) dm = 5 * ceil(random() * 8);
		else if (dm == DOOM_BFG_DMG)
		{
			dm = 100 * ceil(random() * 8);
			dbfg = DOOM_BFG;
		}
		if (EWEAP.noise4 == Q2_DET) dbfg = Q2_BFG; // splash detect
		if (EWEAP.target1 != null_string) pls = EWEAP.target1;
		if (EWEAP.target != null_string) expl = EWEAP.target;
	}

	makevectors (self.v_angle);
	if (self.classname == "pk*bot")
	{
		bfwd = botaim ();
		bfwd_z = 0;
		org = self.origin + bfwd * VWX_PLASMA + v_right * VWY_PLASMA + v_up * VWZ_PLASMA; // Cataboligne - 9.30.9 - true position fire point
	}
	else
	{
		org = self.origin + v_forward * VWX_PLASMA + v_right * VWY_PLASMA + v_up * VWZ_PLASMA; // Cataboligne - 9.30.9 - true position fire point
	}

	fire_missile(PLASMA_VEL, MOVETYPE_FLYMISSILE, FL_MSL | FL_PUNCH | FL_USEAMMO | FL_AIM1K | FL_RUNEHST, RM_SKY | PF_LAVA, org, '0 0 0', "plasma", pls, snd, Plasma_MissileTouch, ROCKET_FUSE * 3,  Plasma_MissileFuseOut, plasmaexplode1);

	if (newmis)
	{
		newmis.noise3 = expl;
	
		pk_missile_splash(newmis); // *pk - splash & message setup

		newmis.dmg = dm;
		newmis.delay = dbfg; // tell missile its a bfg blast for init of trace dmg
		newmis.effects = newmis.effects | EF_FULLBRIGHT;

		if (EWEAP)
		{
			newmis.eweapon = EWEAP;
			newmis.dodmg = EWEAP.dodmg;
			newmis.mcode = EWEAP.mcode;
			traceline (org, org + v_forward*4096, TRUE, self);
			if (!XENV)
			{
				newmis.aiment = placestain(trace_endpos, null_model, plspg_fade, 60);
				newmis.aiment.aiment = placestain(trace_endpos, null_model, plspg_fade, 60);
			}
		}
	}
//	sound (self, CHAN_WEAPON, snd, 1, ATTN_NORM);

};

// doom plasma gun finish fire frames - gun comes way up - vw uses shot frames!
void() player_plasma2   = [$shotatt1, player_plasma3] {self.weaponframe = 8; };
void() player_plasma3   = [$shotatt1, player_plasma4] {self.weaponframe = 8; };
void() player_plasma4   = [$shotatt2, player_plasma5] {self.weaponframe = 8; };
void() player_plasma5   = [$shotatt3, player_plasma6] {self.weaponframe = 9; };
void() player_plasma6   = [$shotatt4, player_plasma7] {self.weaponframe = 9; };
void() player_plasma7   = [$shotatt5, player_plasma8] {self.weaponframe = 9; };
void() player_plasma8   = [$shotatt6, player_run] {self.weaponframe = 0; };

void() player_plasma1b   = [$lightfatt2, player_plasma1]
{
	if (!self.button0)
	{
		player_plasma2();
		return;
	}

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 6)
		self.weaponframe = 1;

	if (self.eweapon)
	{
		self.nextthink = time + self.eweapon.attack_finished;
		if (!rune_haste(self.eweapon.attack_finished / 2))
			self.nextthink = time + self.eweapon.attack_finished / 2;
	}
	else
		self.nextthink = time + 0.2;

};	

void() player_plasma1   = [$lightfatt1, player_plasma1b] 
{
	if (!self.button0)
	{
//		if (self.weaponmodel == "progs/v_d_plasma.mdl") // all guns for now - q3 plasma coded same way
//		if (!self.velocity_x && !self.velocity_y) // only standing still - ice skates model for a few frames if run firing
//		{
			player_plasma2();
			return;
//		}
	}
	EWEAP = self.eweapon;

	self.effects = self.effects | EF_MUZZLEFLASH;

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 6)
		self.weaponframe = 1;

	if (EWEAP)
	{
		self.nextthink = time + EWEAP.attack_finished;
		if (!rune_haste(EWEAP.attack_finished / 2))
			self.nextthink = time + EWEAP.attack_finished / 2;
	}
	else
		self.nextthink = time + 0.2;

	SuperDamageSound();
	X_FireOnePlasma();

	EWEAP = world;
};

// q2 hyper gun

void() hyper_fire_fr =
{
	local float vl;
	EWEAP = self.eweapon;

	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();
	
	laser_sel = laser_sk = 3;
	laser_fr = 4;
	fire_laser1(FL_PUNCH | FL_USEAMMO);
	newmis.effects = EF_DIMLIGHT;
	vl = 1;
	if (self.silencer_finished)
	{
		if (self.silencer_finished > time)
		{
			vl =  Q2_SILENCE;
		}
		else
		{
			self.silencer_finished = 0;
//			sprint (self, "Silencer used up\n");
			stuffcmd(self, "hud_message \"Silencer used up\"\n");
		}
	}

	sound (self, CHAN_ITEM, "q2_snd/hyprbf1a.wav", vl, ATTN_NORM);

	EWEAP = world;
};

void() player_hyper0   = [$lightfatt1, player_hyper0]
{
	if (!self.button0)
	{
		self.chaosweptime = 0;
		ominous_hum("q2_snd/hyprbd1a.wav", 1.02);
		player_run();
		return;
	}

	if (self.weaponframe == 0)
	{
		self.chaosweptime = 0;
		ominous_hum("q2_snd/hyprbu1a.wav", 0.373);
	}
	else
		ominous_hum(self.eweapon.noise3, self.eweapon.chaosweptime);

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 6)
		self.weaponframe = 1;

	self.frame = self.frame + (self.tomb_time & 3);
	self.tomb_time = self.tomb_time + 1;

	if (self.eweapon)
	{
		self.nextthink = time + self.eweapon.attack_finished;
		if (!rune_haste(self.eweapon.attack_finished / 2))
			self.nextthink = time + self.eweapon.attack_finished / 2;
	}
	else
		self.nextthink = time + 0.2;

	if (self.tomb_time & 1) hyper_fire_fr();
};


// q2 chain gun

void() chain_fire_fr =
{
	EWEAP = self.eweapon;

	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();
	
	mgchg_shot(1);

	EWEAP = world;
};

void() player_chain0   = [$lightfatt1, player_chain0]
{
	local float div;

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 9)
		self.weaponframe = 1;

	if (self.tomb_time < -600)
	{
		self.frame = self.frame + (self.weaponframe & 3);
		self.tomb_time = self.tomb_time + 1;
		self.nextthink = time + 0.2;
//		if (self.attack_finished > time) return;
		if (self.tomb_time < -656) return;
		self.tomb_time = 0;
		player_run();
		return;
	}

	if (!self.button0)
	{
		self.tomb_time = -666;
		self.chaosweptime = 0;
		ominous_hum("q2_snd/chngnd1a.wav", 1.71);
		self.attack_finished = time + 2;
		return;
	}

	div = 1;
	hum_chan = CHAN_ITEM;
	if (self.weaponframe == 0)
	{
		self.chaosweptime = 0;
		self.tomb_time = 0;
		ominous_hum("q2_snd/chngnu1a.wav", 0.945);
	}
	else
		ominous_hum("q2_snd/chngnl1a.wav", self.eweapon.chaosweptime);

	self.frame = self.frame + (self.tomb_time & 3);
	self.tomb_time = self.tomb_time + 1;

	if (self.tomb_time & 1) chain_fire_fr();

	if (self.tomb_time > 40) div = 2.25; // double fire rate after 20 shots (in 1 rel)

	if (self.eweapon)
	{
		self.nextthink = time + (self.eweapon.attack_finished / div);
		if (!rune_haste((self.eweapon.attack_finished / div) / 2))
			self.nextthink = time + (self.eweapon.attack_finished / div) / 2;
	}
	else
		self.nextthink = time + 0.2;
};


// target flags - in general dont allow targeting if the flag ind. test fails

// assign line - cut / paste & remove unwanted flags
// = TFL_SELF | TFL_FENT | TFL_HEAL | TFL_TKDMG | TFL_TRACE | TFL_CONT | TFL_RANGE | TFL_INVIS | TFL_INFR | TFL_PKLV | TFL_PLY | TFL_MON | TFL_TR_IGM | TFL_IFR_NOZ | TFL_INV;

float TFL_SELF			= 1;				// allow target self ent = actual self (projectiles / effects that could potentially target player / owner dont want to target self		 - allow self to be targeted
float TFL_FENT			= 2;				// allow target f ent in fn call, should be player / owner																																						 - allow ent f  to be targeted
float TFL_HEAL			= 4;				// check target ents for health > 0, (fail FALSE)																																										 - dont allow no health ents to be targeted
float TFL_TKDMG		= 8;				// check target for takedamage set allowed, (fail FALSE)																																					 - dont allow non takedamage to be targeted
float TFL_TRACE		= 16;			// check target for trace fraction < 1 (no line of site), (fail TRUE)																																	 - dont allow if no direct LOS
float TFL_CONT			= 32;			// check to see if target is across a content boundary (empty to liquid trace), (fail TRUE)																				 - dont allow LOS to cross contents
float TFL_RANGE		= 64;			// check target for range > r, (fail TRUE)																																													 - dont allow out of range to be targeted
float TFL_INVIS			= 128;			// check to see if target is visible (player / ent invisibility via IT_INVIS & .items), (fail TRUE)																		 - dont allow invisibles to be targeted
float TFL_INFR			= 256;			// check to see if target meets in front test with cht_if value, (fail FALSE)																													 - dont allow ents out of view cone to be targeted
float TFL_PKLV			= 512;			// check to see if target is a pk live ent - fail if true (individualized by pk_livent_brk var below as shown if set), (fail TRUE)		 - dont allow pk live ents to be targeted
float TFL_PLY				= 1024;		// check to see if target is a player / bot, (fail TRUE)																																								 - dont allow players to be targeted				(invertable)
float TFL_MON			= 2048;		// check to see if target is a monster, (fail TRUE)																																									 - dont allow monsters to be targeted			(invertable)

float TFL_TR_IGM		= 1048576; // trace ignores monsters in LOS test
float TFL_IFR_NOZ	= 2097152; // in front ignores z components
float TFL_INV				= 4194304; // invert certain tests - only players or monsters, etc.																																							 - invert certain flags to return the opposite result

float cht_if; // in front range 0 - 1 fraction, believed to be radius cone around vector of self.v_angle
float pk_livent_brk; // painkeep live ent breakdown according to item flags as follows:
//float PK_IT_GRAVITYWELL		= 2;
//float PK_IT_TURRET			= 4;
//float PK_IT_BEARTRAP			= 128;
//float PKPLUS_IT_EGO			= 256;
//float PKPLUS_IT_TOMB			= 512;
float PKPLUS_IT_CORPSE			= 1024; // special - (tomb genned) corpse has health, can takedmg, can be targeted

//  ========= ========= ========= ========= ========= ========= =========

// targeting fn - IDEA: move?
// 		- tests to see if an ent can be targeted by an attack / effect under various conditions - maybe chaos vector

// self - MUST be targeting entity (for v_angle & origin if not supplied) - MUST MUST MUST!

// e - test ent
// f - self ent, firing ent / projectile, or player / owner
// r - range to test if flag set
// flg - flags control tests


float(entity e, entity f, vector cht_org, float r, float flg) can_has_target =
{
	local float k;
	local vector v, corg;

	if (!e) return(FALSE); // cant target world
	if (e.classname == "turret_base") return(FALSE); // never target these - not valide
//	if (e.classname == "chase_cam") return(FALSE); // nope - no more cam ents

	if ((e == self) && ! (flg & TFL_SELF)) return(FALSE);
	if ((e == f) && ! (flg & TFL_FENT)) return(FALSE);
	if ((floor(e.health) < 1) && (flg & TFL_HEAL)) return(FALSE);
	if ((!e.takedamage) && (flg & TFL_TKDMG)) return(FALSE);

	corg = cht_org;
	if (cht_org == v0)
	{
		if (f) corg = f.origin;
		else corg = self.origin;
	}

	if ((flg & TFL_TRACE) || (flg & TFL_CONT))
	{
		if (flg & TFL_TR_IGM) k = TRUE; // ignore (see thru) monsters
		traceline(corg, e.origin, k, self); // LOS and content boundary
		if (flg & TFL_TRACE)
		{


#ifdef warning
if (WARNING & 32)
if (trace_fraction < 1)
{
bprint(" *** CHT: trace fail ent (");
bprint(item_ident(e));
bprint(") - frac = ");
bprint(ftos(trace_fraction));
bprint(".\n");
}
#endifdef


			if (trace_fraction < 1) return(FALSE);
		}
		if (flg & TFL_CONT)
		{
			if (trace_inopen && trace_inwater) return(FALSE);
		}
	}

	if (flg & TFL_RANGE)
	{
		k = vlen(e.origin - corg);
		if (k > r) return(FALSE);
	}

	if ((e.items & IT_INVISIBILITY) && (flg & TFL_INVIS)) return(FALSE);

	if ((flg & TFL_INFR) && (cht_if > 0))
	{
		if (self.classname == "player" || self.class_select == "class_bot")
			makevectors (self.v_angle);
		else if (e.classname == "player" || e.class_select == "class_bot")
			makevectors (e.v_angle);
		else if (f.classname == "player" || f.class_select == "class_bot")
			makevectors (f.v_angle);
		else
			makevectors (self.v_angle);

		v = e.origin - corg;

		if (flg & TFL_IFR_NOZ) // ignore z value of height (doom eh...) - use a circular check (ceil to floor) instead of cone
		{
			v_forward_z = 0;
			v_z = 0;
		}

		v_forward = normalize(v_forward);
		v = normalize(v);

		k = v * v_forward;

		if (k <= cht_if)
		{


/*
bprint(" *** cht_if fail ent (");
bprint(item_ident(e));
bprint(") = ");
bprint(ftos(k));
bprint(" <= ");
bprint(ftos(cht_if));
bprint(" (check val), ");
bprint(vtos(self.v_angle));
bprint(" - shot v_ang, ");
bprint(vtos(v_forward));
bprint(" - v_fwd, ");
bprint(vtos(v));
bprint(" - v, ");
//bprint(vtos(self.owner.v_angle));
//bprint(" - owner v_ang, ");
bprint(".\n");
*/


			cht_if = 0; // always cleared - always needs set
		  return(FALSE);
		}


/*
bprint(" *** cht_if sucess ent (");
bprint(item_ident(e));
bprint(") = ");
bprint(ftos(k));
bprint(" > ");
bprint(ftos(cht_if));
bprint(" (check val), ");
bprint(vtos(self.v_angle));
bprint(" - shot v_ang, ");
bprint(vtos(v_forward));
bprint(" - v_fwd, ");
bprint(vtos(v));
bprint(" - v, ");
bprint(".\n");
*/


	}
	cht_if = 0; // always cleared - always needs set

	if (flg & TFL_PKLV) // check live ents for pk
	{
		if (!pk_livent_brk || (pk_livent_brk & PK_IT_GRAVITYWELL) && e.classname == "gravity") return(FALSE);
		if (!pk_livent_brk || (pk_livent_brk & PK_IT_TURRET) && e.classname == "turret") return(FALSE);
		if (!pk_livent_brk || (pk_livent_brk & PK_IT_BEARTRAP) && e.classname == "beartrap") return(FALSE);
		if (!pk_livent_brk || (pk_livent_brk & PKPLUS_IT_EGO) && e.classname == "ego") return(FALSE);
		if (!pk_livent_brk || (pk_livent_brk & PKPLUS_IT_TOMB) && e.classname == "tomb") return(FALSE);
		if (!pk_livent_brk || (pk_livent_brk & PKPLUS_IT_CORPSE) && e.classname == "corpse") return(FALSE); // from tomb - hounding some ent
//		if (!pk_livent_brk || (pk_livent_brk & ) && e.classname == null_string) return(FALSE);
	}

// IDEA: allow targeting of rockets, etc. - put in fail test

// NOTE: if pk*bot loses FL_CLIENT flag, we need more test here

	if (flg & TFL_INV) // inverted player / monster test - only those allowed
	{
		if ((e.flags & FL_CLIENT) && (flg & TFL_PLY)) return(TRUE);
		if ((e.flags & FL_MONSTER) && (flg & TFL_MON)) return(TRUE);
		return(FALSE);
	}

	if ((e.flags & FL_CLIENT) && (flg & TFL_PLY)) return(FALSE);
	if ((e.flags & FL_MONSTER) && (flg & TFL_MON)) return(FALSE);

	return(TRUE);
};

// bfg doom & q2

// sequence targets

// returns count targ, self.theowner = ent list chained by .theowner

float(vector sorg, float srd, float sfl, float sifr) bfg_targ_seq =
{
	local float k;
	local entity e, tl;

	k = 0;
	e = findradius(sorg, srd); // find things to dmg in fire cone

	while (e)
	{
		cht_if = sifr;
		if (can_has_target(e, self.owner, sorg, 0, sfl))
		{
			k = k + 1;
			if (!self.theowner) self.theowner = tl = e;
			else { tl.theowner = e; tl = e; }
		}
		e = e.chain;
	}

	return(k);
};

// traces for bfg weaps - q2 is different

void() bfg_trace_thk =
{
	local float f, j, k, kl, tr, bfl, sf, ifr;
	local entity e, tl;

	if (self.flags == 0.768) // doom bfg
	{
		self.nextthink = time + (self.flags / 2) - 0.2;
		self.flags = DOOM_BFG;
		return;
	}
	else if (self.flags == 0.87)
	{
		self.flags = Q2_BFG_LASER;
	}

	if (self.flags == Q2_BFG) // ball struck, do ray damage at end of travel
	{

		bfl = TFL_HEAL | TFL_TKDMG | TFL_TRACE | TFL_INVIS | TFL_TR_IGM ;		// all hittable things
		k = bfg_targ_seq(self.enemy.origin, Q2_BFG_TRACE, bfl, 0); // find things to dmg in beam radius
		e = self.theowner;
		sf = 500;
		while (e && sf > 0)
		{
			if (can_has_target(e, self.owner, self.owner.origin, 0, bfl)) // check LOS to owner
			{
				f = self.eweapon.dodmg;
				k = vlen(e.origin - self.enemy.origin);
				if (k > Q2_BFG_LASER)
				{
					f = f * (Q2_BFG_LASER / k);
				}

local float i;
local entity g;

				T_Damage (e,self,self.owner,f);
			}
			e = e.theowner;
			sf = sf - 1;
		}

	}
	if (self.flags == Q2_BFG_LASER)
	{
		if (!self.enemy) self.flags = 0;
		else if (self.enemy.classname != "bfg_ball") self.flags = 0;
		if (!self.flags) // something has gone wrong - bfg ball is gone, need to remove laser shot think
		{
			remove(self);
			return;
		}
	
		self.cnt = self.cnt + 1;
		e = findradius(self.enemy.origin, Q2_BFG_LASER); // find things to laser dmg in fire radius
		bfl = TFL_HEAL | TFL_TKDMG | TFL_TRACE | TFL_INVIS | TFL_TR_IGM;
		sf = 600;
		while (e && sf > 0)
		{
			if (can_has_target(e, self.owner, self.enemy.origin, 0, bfl)) 
			{
				T_Damage (e,self,self.owner,Q2_BFG_LASER_DMG);

				v1 = e.origin - self.enemy.origin;

				g = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, self.enemy.origin, v0, v0, vectoangles(v1), v0, null_string, "progs/lzrbm_seg.mdl", SUB_Remove, 0.2, SUB_Remove, SUB_Null, self, world);
				i = vlen(v1);
				i = floor(i / 32);
				if (i > 63) i = 63;
				g.frame = i;
				g.skin = 1;

			}
			e = e.chain;
			sf = sf - 1;
		}
		self.nextthink = time + 0.1;
		return;
	}

// NOTE: this is not the way doom bfg tracers are really done - they are fanned out over an arc interval:   an = mo->angle - ANG90/2 + ANG90/40*i; where (i=0 ; i<40 ; i++), mo is dir of bfg shot
	if (self.flags == DOOM_BFG)
	{
		k = j = 0;
		ifr = self.origin_x;
		tr = 40;
		self.theowner = tl = world;

		self.v_angle = self.angles;
		self.origin = self.owner.origin; // where ever the player is .38 rels after ball hits or expires

//		bfl = TFL_HEAL | TFL_TKDMG | TFL_TRACE | TFL_INVIS | TFL_INFR | TFL_PLY | TFL_MON | TFL_INV | TFL_TR_IGM | TFL_IFR_NOZ; // only monsters & players
		bfl = TFL_HEAL | TFL_TKDMG | TFL_TRACE | TFL_INVIS | TFL_INFR | TFL_TR_IGM | TFL_IFR_NOZ;		// all hittable things

		k = bfg_targ_seq(self.origin, DOOM_BFG_TRACE, bfl, ifr);
		tl = self.theowner;



// test - list ents




		kl = k; // track killed ents
		sf = 400;
		if (tl)
		while (tr > 0 && sf > 0)
		{
			f = rint(random() * k);
			e = tl;
			while (f > 0 && e.theowner)
			{
				e = e.theowner;
				f = f - 1;
			}
			j = 16;
			f = 0;
			while (j > 0) // new calc based on revised faq - making bfg even more deadly
			{
				f = f + ceil(random() * 8); // add d8 up 16 times
				j = j - 1;
			}
//			f = 49 + ceil(36 * random());
			if (e.health > 0)
			{
				T_Damage (e,self,self.owner,f);
				if (e.health <= 0) kl = kl - 1;
			}
			if (kl < 1) // killed everything on current list - try to retarget
			{
				k = bfg_targ_seq(self.origin, DOOM_BFG_TRACE, bfl, ifr);
				tl = self.theowner;
				if (!tl) sf = 0;
			}
			sf = sf - 1;
		}

	}


	remove(self);
};

/*

NOTES:
- q2 bfg does not obey quad except for direct dmg
- doom bfg may not exclude ents hidden behind larger ents (seems like stuff is killed behind shambler...)
- doom bfg should prob. start with closer ents & work its way out instead of beaming rays to rnd targets
- 1st & 2nd list deal should maybe be 1 list
- in front check is aware of z - doom bfg ignored most vertical diffs
- doom bfg rays are not cast same as in doom

*/

// NOTE: this code may not be obeying haste rune effect - that might be ok

void() player_bfg1   = [$lightfatt1, player_bfg1]
{
	local entity e;
	local float f, v;

	if (self.weaponframe == 0)
	{
		self.tomb_time = time + self.eweapon.endtime;
		v = 1;
		if (self.silencer_finished > time) v = Q2_SILENCE;
		sound (self, CHAN_ITEM, self.eweapon.noise3, v, ATTN_NORM);
	}

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 9)
		self.weaponframe = 1;

	self.frame = self.frame + (self.weaponframe & 3);

	if (self.tomb_time > time)
	{
		if (self.weaponframe >= 2)
			self.weaponframe = 8;
		return;
	}
	else
		self.weaponframe = 1;

	self.effects = self.effects | EF_MUZZLEFLASH; // IMP: special flash

	EWEAP = self.eweapon;

	SuperDamageSound();
	X_FireOnePlasma();

	newmis.classname = "bfg_ball";
	newmis.frame = 0;
	newmis.skin = 1;
	newmis.effects = EF_BRIGHTLIGHT | EF_BRIGHTFIELD;

	f = 0.2;
	if (EWEAP.noise4 == DOOM_DET) f = ROCKET_FUSE; // ball flight time max - doom starts think here to get data but it gets activated by plasma hit logic
	e = chaos_spawn(0, 0, EWEAP.endtime, 0, EWEAP.bulletspread, v0, v0, self.v_angle, v0, "bfg_laser", null_string, SUB_Null, f, bfg_trace_thk, SUB_Null, self, world);
	e.eweapon = EWEAP;
	e.enemy = newmis; // q2 - fires lasers from ball
	newmis.enemy = e; // trace blast

	EWEAP = world;
	player_shot2();
};

// q3 bfg - easy

void() X_Fire3BFG =
{
	if (!self.button0)
	{
		player_run();
		return;
	}
	EWEAP = self.eweapon;

	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();
	X_FireOnePlasma();

	EWEAP = world;
};


// fire any eweapon (= extended weapon code)

void() e_weap_Attack =
{
	local float c;


#ifdef warning
							if (WARNING & 32)
							{
								bprint("*** warning: in e_weap_Attack = ");
								bprint(self.eweapon.netname);
								bprint("\n");
							}
#endifdef


	EWEAP = self.eweapon;
	if (EWEAP._attack == painkeep_cube_use) c = TRUE;

// handle haste effects - if rune_haste() returns TRUE there is no haste & we set time for attack here

	if (rune_haste(EWEAP.attack_finished / 2))
		self.attack_finished = time + EWEAP.attack_finished;

//	if (EWEAP._attack != (void ()) 0)
	if (EWEAP._attack)
	if (EWEAP._attack != SUB_Null) EWEAP._attack();

	if (c) // dont let cube making a weap fire anything
	{
		EWEAP = world;
		return;
	}

//	if (EWEAP._fr_attack != (void ()) 0)
	if (EWEAP._fr_attack)
	if (EWEAP._fr_attack != SUB_Null) EWEAP._fr_attack();

	if (EWEAP.duration == SND_OVER)
	if (EWEAP.model != null_string) // fists hack
	if (EWEAP.noise3 != null_string)
		sound (self, CHAN_WEAPON, EWEAP.noise3, 1, ATTN_NORM);
//	EWEAP.aflag = self.currentammo;

// rocket wep specials
	if (EWEAP._attack == W_FireRocket)
	if (newmis.classname == "missile")
	{
		newmis.touch = X_MissileTouch;
		newmis.dmg = EWEAP.dmg;
		newmis.dodmg = EWEAP.dodmg;
		newmis.eweapon = EWEAP;
		newmis.target = EWEAP.target;
	}
// grenade wep specials
	if (EWEAP._attack == W_FireGrenade)
	if (newmis.classname == "grenade")
	{
		newmis.dmg = EWEAP.dmg;
		newmis.dodmg = EWEAP.dodmg;
		newmis.eweapon = EWEAP;
		newmis.noise = EWEAP.target;
	}

	EWEAP = world;

//	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};


// wrapper for cmod stuffs

void(float recurse, vector p1, vector p2, entity from, float damage) LightningDamage_x =
{
	local float f;
	f = recurse;
	LightningDamage (p1, p2, from, damage);
};

// crosshair controls

// i - increment, if not 0, check sv against cvar
// if i = -1, just reactivate crosshair

void(entity e, float i) crosshair_con =
{
	if (e.class_select == "class_bot") return;

	if (i < 0) // reactivate
	{
		if (	e.crosshair_sv == -666) 	e.crosshair_sv = 0;
		e.crosshair_sv = fabs(e.crosshair_sv);
	}

	if (e.crosshair_sv < 0) return; // no impulse controls while off

	if (i > 0)
	{
		if (e.crosshair_sv != cvar("crosshair")) // note: server / cli issue
			e.crosshair_sv = cvar("crosshair");

		e.crosshair_sv = fabs(e.crosshair_sv) + i;
		if (e.crosshair_sv > 7) e.crosshair_sv = 0;
	}

	stuffcmd(e, "crosshair ");
	stuffcmd(e, ftos(e.crosshair_sv));
	stuffcmd(e, "\n");	
};

void(entity e) crosshair_off =
{
	if (e.class_select == "class_bot") return;

	if (cvar("crosshair"))
	if (e.crosshair_sv != cvar("crosshair"))
		e.crosshair_sv = cvar("crosshair");

	e.crosshair_sv = 0 - fabs(e.crosshair_sv);
	if (!e.crosshair_sv) e.crosshair_sv = -666;

	stuffcmd(e, "crosshair ");
	stuffcmd(e, ftos(e.crosshair_sv)); // save this so if game exists while off, it restores on reentry
	stuffcmd(e, "\n");	
};

// fn(BlastProof) - some things take less blast damage - return percentage for damage calculation


float(entity o) BlastProof =
{
	local float d;

	d = 1;

	if(o.morphy == IMP_MCHAOS)// || o.state == IMP_MCHAOS) // pure chaos
	{
		d = 0.4 + random() * 0.6;
		if (random() < 0.1) d = 0.1 * random();
	}
	else if (o.morphy == IMP_MCYBER || o.morphy == IMP_MSHAMBLR) d = 0.65; // havent quite learned this trick as well
// Cataboligne @12.25.7 - mod for morphs, added monsters
	else if (o.classname == "monster_shambler") d = 0.5;	// mostly immune
	else if (o.classname == "monster_cyber") d = 0.5;	// mostly immune
/* deprecated (already even!) until needed
	else if (o.map == "blastproof_0") d = 0;	// code config blast proofer - 4 levels
	else if (o.map == "blastproof_.25") d = 0.25;
	else if (o.map == "blastproof_.5") d = 0.5;
	else if (o.map == "blastproof_.75") d = 0.75; */
	else if (o.wad == "MEGA") d = 0.8;	// mega monsters take 8o% dmg
	else if (o.wad == "SUPER") d = 0.4;	// super monsters take less dmg
	else if (o.wad == "SUPER_XMAD") d = 0.3 - (random() * 0.2);	// extra nad super monsters take _even_ less dmg

	return(d);
};















