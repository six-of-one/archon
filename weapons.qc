/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: weapons.qc
 *
 * date: Fri Apr  4 04:31:45 UTC 2008
 *
 * final qc
 *
 */
 
// Cataboligne 9.11.3 purify proto - chase cam
void () ccb_impulse_check;

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void (entity e, vector org, vector vel, float damage) SpawnBlood;
void () SuperDamageSound;


// called by worldspawn
void () W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void () W_FireAxe =
{
	local vector source;
	local vector org;

	ax_dmg = 0; // Cataboligne - 10.11.11 - bot endless axe war preventative deal

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	if (self.classname == "pk*bot")
	{
		source = botaim ();
	}
	traceline (source, source + v_forward*64, FALSE, self);

#ifdef warning
/*
							if (WARNING & 32)
							{
								bprint("*** warning: fireaxe hit = ");
								bprint(item_ident(trace_ent));
								bprint(" - trace frac: ");
								bprint(ftos(trace_fraction));
								bprint(" - endp: ");
								bprint(vtos(trace_endpos));
								bprint("\n");
							}
							*/
#endifdef

	if (trace_fraction == 1.0)
	{
		if (self.class_select == "class_bot") Bot_Melee();
		return;
	}

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		self.tomb_time = 20; // axe dmg - mod vector
		if (self.eweapon.grap_state == 666000)
			self.tomb_time = ceil(10 * random()) + ceil(10 * random()); // fist damage
		trace_ent.axhitme = 1;
//		if (trace_ent.netname != "Crate") // ick: hack - handle in spawnblood, recode to pass ent
		SpawnBlood (trace_ent, org, '0 0 0', 20);
		T_Damage (trace_ent,self,self,self.tomb_time);
	}
	else
	if (self.eweapon.grap_state == 666000)
	{
		sound (self, CHAN_WEAPON, "player/axhit1.wav", 1, ATTN_NORM);
		SpawnBlood (world, org, '0 0 0', 10);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}

// if no axe damage happen in attack, call up special bot melee routine
	if (!ax_dmg)
	if (self.class_select == "class_bot")
		Bot_Melee();
};


//============================================================================


vector () wall_velocity =
{
	local vector vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void (vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;
//	local	vector	org; // Cataboligne 9.17.3 - fix compiler warning

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile,"progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile,org);
	pk_missile_splash(missile); // *pk - splash & message setup
};

/*
================
SpawnBlood
================

10.20.13 - added ent refer so we can do hacks like Archons do not bleed & only have to change this
*/
void (entity e, vector org, vector vel, float damage) SpawnBlood =
{
	if (e.solid == SOLID_SLIDEBOX || !e) // BLOODCHECK
	if (e.netname != "Crate")
	if (!e.mask_x & MORPH_ARCHON) // dont let them see you bleed
		particle (org, vel*0.1, spawn_particle, damage*2);

	spawn_particle = 73; // always default - dp makes this blood
};

/*
================
spawn_touchblood
================

in the case of every call for this fn(), other is the ent
this will have to be maintained, or change this code

*/
void (float damage) spawn_touchblood =
{
	local vector vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (other, self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void (vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity multi_ent;
float multi_damage;

void () ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void () ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent,self,self,multi_damage);
};

void (entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return ;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void (float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		AddMultiDamage (trace_ent,damage);
//		if (trace_ent.netname != "Crate") // ick: hack - handle in spawnblood, recode to pass ent, include doors & triggers
		if (trace_ent.solid == SOLID_SLIDEBOX) // BLOODCHECK
		{
			SpawnBlood (trace_ent, org, vel*0.2, damage);
			return;
		}
	}
//	else
//	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
//	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void (float shotcount, vector dir, vector spread) FireBullets =
{
	local vector direction;
	local vector src;

	makevectors (self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
W_FireShotgun
================
*/
void () W_FireShotgun =
{
	local vector dir;

	if (!self.pk_explode_ammo)
		sound (self,CHAN_WEAPON,"weapons/guncock.wav",1 ,ATTN_NORM);
	else
	{
		W_FireShotgunExploder(1);
		return;
	}

	self.punchangle_x = -2;

		self.currentammo =self.ammo_shells = self.ammo_shells - ammo_con(1, self, null_string);
		if (self.classname == "pk*bot")
			dir = botaim ();
		else
		dir = aim (self,100000);
		FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void () W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return ;
	}

	if (!self.pk_explode_ammo)
		sound (self,CHAN_WEAPON,"weapons/shotgn2.wav",1 ,ATTN_NORM);
	else
	{
		W_FireShotgunExploder(2);
		return;
	}

	self.punchangle_x = -4;
	
		self.currentammo = self.ammo_shells = self.ammo_shells - ammo_con(2, self, null_string);
		if (self.classname == "pk*bot")
			dir = botaim ();
		else
		dir = aim (self,100000);
		FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void () s_explode1 = [ 0, s_explode2 ] { };
void () s_explode2 = [ 1, s_explode3 ] { };
void () s_explode3 = [ 2, s_explode4 ] { };
void () s_explode4 = [ 3, s_explode5 ] { };
void () s_explode5 = [ 4, s_explode6 ] { };
void () s_explode6 = [ 5, SUB_Remove ] { };

void () BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self,"progs/s_explod.spr");
	self.solid = SOLID_NOT;
	self.class_select = null_string; // stop ops on this
	s_explode1 ();
};

void () T_MissileTouch =
{
	local float damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (self.wad == "BIG") // note - special, becuase 2 rockets SHOULD hose each other
	if (other.touch == self.touch) // explosive wep fix for scrag
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

	if (self.dmg) damg = self.dmg; // Cataboligne - 12.2.12 - mod for variable damage rockets
	else
	damg = 100 + random()*20;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other,self,self.owner,damg);
	}

	if (self.dmg) damg = self.dmg;
	else
		damg = 120;

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, damg, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);

	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void () W_FireRocket =
{
	vector bfwd;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_con(1, self, null_string);

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "missile";
	newmis.weapon = IT_ROCKET_LAUNCHER; // Cataboligne - 2.19.11 - correct obit in pk_clientobit

// set missile speed

	if (self.class_select == "class_monster") // enhanced - monster firing a rocket
	{
		bfwd = self.enemy.origin - self.enemy.velocity*0.2;
		newmis.velocity = normalize (bfwd - self.origin);
		newmis.dmg = 80; // not as strong as player unless set that way
	}
	else
	{
		makevectors (self.v_angle);

		if (self.classname == "pk*bot")
		{
			newmis.velocity = botaim ();
			bfwd = botaim ();
			bfwd_z = 0;
		}
		else
		newmis.velocity = aim (self,1000);
	}
	newmis.velocity = newmis.velocity * 1000;
	newmis.angles = vectoangles (newmis.velocity);

	if (!rune_haste(0.4))
		newmis.velocity = newmis.velocity * 2;

	newmis.touch = T_MissileTouch;

// set missile duration
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;

	setmodel (newmis,"progs/missile.mdl");
	setsize (newmis, '0 0 0', '0 0 0');
	if (self.classname == "pk*bot")
	{
		if (autocvar_sv_centerwep)
			setorigin (newmis,((self.origin + (bfwd * 8)) + '0 0 16'));
		else
			setorigin (newmis,self.origin + bfwd * VWX_ROCKETL + v_right * VWY_ROCKETL + v_up * VWZ_ROCKETL); // Cataboligne - 9.30.9 - true position fire point
	}
	else
	{
		if (autocvar_sv_centerwep)
			setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
		else
			setorigin (newmis,self.origin + v_forward * VWX_ROCKETL + v_right * VWY_ROCKETL + v_up * VWZ_ROCKETL); // Cataboligne - 9.30.9 - true position fire point
	}
	pk_missile_splash(newmis); // *pk - splash & message setup
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void (vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);

// hit nothing - spark it & go - this looks pretty cool
	if (!trace_ent && pointcontents(p2) == CONTENT_SOLID)
	{
			WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST,TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST,trace_endpos_x);
			WriteCoord (MSG_BROADCAST,trace_endpos_y);
			WriteCoord (MSG_BROADCAST,trace_endpos_z);
			return;		
	}

	if (trace_ent.takedamage && ! (trace_ent.wetsuit_finished && (trace_ent.items & IT_SUIT)) )
	{
		if (trace_ent.solid == SOLID_SLIDEBOX) // BLOODCHECK - 7.29.13 - because dp makes this blood
//			particle (trace_endpos, '0 0 100', 225, damage*4);
		{
			spawn_particle = 225;
			SpawnBlood (trace_ent, trace_endpos, '0 0 100' * 10, damage * 2);
		}
		else
		{
			WriteByte (MSG_BROADCAST,SVC_TEMPENTITY); // sparks - but we might want better (see what HD does)
			WriteByte (MSG_BROADCAST,TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST,trace_endpos_x);
			WriteCoord (MSG_BROADCAST,trace_endpos_y);
			WriteCoord (MSG_BROADCAST,trace_endpos_z);
		}
		T_Damage (trace_ent,from,from,damage);
		if ((self.classname == "player") || (self.classname == "pk*bot"))
		{
			if ((other.classname == "player") || (other.classname == "pk*bot"))
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage && ! (trace_ent.wetsuit_finished && (trace_ent.items & IT_SUIT)) )
	{
		if (trace_ent.solid == SOLID_SLIDEBOX) // BLOODCHECK - 7.29.13
//			particle (trace_endpos, '0 0 100', 225, damage*4);
		{
			spawn_particle = 225;
			SpawnBlood (trace_ent, trace_endpos, '0 0 100' * 10, damage * 2);
		}
		else
		{
			WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST,TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST,trace_endpos_x);
			WriteCoord (MSG_BROADCAST,trace_endpos_y);
			WriteCoord (MSG_BROADCAST,trace_endpos_z);
		}
		T_Damage (trace_ent,from,from,damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage && ! (trace_ent.wetsuit_finished && (trace_ent.items & IT_SUIT)) )
	{
		if (trace_ent.solid == SOLID_SLIDEBOX) // BLOODCHECK - 7.29.13
//			particle (trace_endpos, '0 0 100', 225, damage*4);
			{
				spawn_particle = 225;
				SpawnBlood (trace_ent, trace_endpos, '0 0 100' * 10, damage * 2);
			}
	else
		{
			WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST,TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST,trace_endpos_x);
			WriteCoord (MSG_BROADCAST,trace_endpos_y);
			WriteCoord (MSG_BROADCAST,trace_endpos_z);
		}
		T_Damage (trace_ent,from,from,damage);
	}
};


void () W_FireLightning =
{
	local vector org;
	local float cells;
	local float wlevel;
	local vector dir;

	if (self.class_select == "class_monster") // enhanced - monster firing lightning
	{
		v_forward = normalize (self.enemy.origin - self.origin);
//		makevectors(v_forward);
		wlevel = CheckWaterLevel ();
		cells = 10 + random() * 10;
	}
	else
	{
		if (self.ammo_cells < 1)
		{
			self.weapon = W_BestWeapon ();
			self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
			W_SetCurrentAmmo ();
			if (self.classname == "pk*bot")
			{
				self.think = self.th_run;
			}
			return ;
		}

	// explode if under water
		cells = self.ammo_cells;
		if (self.classname == "pk*bot")
			wlevel = CheckWaterLevel ();
		else
			wlevel = self.waterlevel;

		if (self.eweapon)
		if (self.eweapon.mcode == MC_Q3_LIGHTNING) // cause q3 lg doesnt blow under water
			wlevel = 0;
	}

	if (wlevel > 1)
	{
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		discharged = 1;
		T_RadiusDamage (self, self, (35 * cells), world);
		discharged = 0;
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}

	if (self.class_select != "class_monster")
	{
		self.punchangle_x = -2;
//		cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view

		self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(1, self, null_string);
	}

/* not needed with lg
	if (autocvar_sv_centerwep)
		org = self.origin + '0 0 16';
	else
	*/
	org = self.origin + v_right * VWY_THUNDER + v_forward * VWX_THUNDER + v_up * VWZ_THUNDER;

	if (self.classname == "pk*bot")
	{
		dir = botaim ();
		traceline (org,(org + (dir * 600)),TRUE,self);
	}
	else
	{
		traceline (org, org + v_forward*600, TRUE, self);
	}

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST,self);
	WriteCoord (MSG_BROADCAST,org_x);
	WriteCoord (MSG_BROADCAST,org_y);
	WriteCoord (MSG_BROADCAST,org_z);
	WriteCoord (MSG_BROADCAST,trace_endpos_x);
	WriteCoord (MSG_BROADCAST,trace_endpos_y);
	WriteCoord (MSG_BROADCAST,trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void () GrenadeExplode =
{
	if (self.dodmg)
		T_RadiusDamage (self,self.owner,self.dodmg,world);
	else
	T_RadiusDamage (self,self.owner,120,world);

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);

	BecomeExplosion ();
};

void () PortalTouch;

void () GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode ();
		return ;
	}

	if (other.classname == "portal_entrance" || other.classname == "portal_exit")
	{
		self.enemy = other;
		other = self;
		self = other.enemy;
		other.enemy = world;
		PortalTouch();
		return;
	}

	if (self.noise != null_string)
		sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM);	// bounce sound
	else
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void () W_FireGrenade =
{
	self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_con(1, self, null_string);

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
	newmis.weapon = IT_GRENADE_LAUNCHER; // Cataboligne - 2.19.11 - correct obit in pk_clientobit
	
// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		if (self.classname == "pk*bot")
		{
			newmis.velocity = botaim ();
			newmis.velocity = (newmis.velocity * 600);
			newmis.velocity_z = (newmis.velocity_z + 200);
		}
		else
		{
		newmis.velocity = aim (self,10000);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;
		}
	}

	if (!rune_haste(0.3))
		newmis.velocity = newmis.velocity * 2;

	newmis.avelocity = '300 300 300';

	newmis.angles = vectoangles (newmis.velocity);

	newmis.touch = GrenadeTouch;

// set missile duration
	newmis.nextthink = time + 2.5;
	newmis.think = GrenadeExplode;

	setmodel (newmis,"progs/grenade.mdl");
	setsize (newmis, '0 0 0', '0 0 0');
	if (autocvar_sv_centerwep)
		setorigin (newmis,self.origin);
	else
		setorigin (newmis, self.origin + v_forward * VWX_GRENADEL + v_right * VWY_GRENADEL + v_up * VWZ_GRENADEL); // Cataboligne - 9.30.9 - true position fire point
	pk_missile_splash(newmis); // *pk - splash & message setup
};


//=============================================================================

void () spike_touch;

#ifndef enhanced
void () superspike_touch;
#endifdef

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void (vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles (dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis,"progs/spike.mdl");
	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
	setorigin (newmis,org);

	newmis.velocity = dir * 1000;
	if (!rune_haste(0.1))
		newmis.velocity = dir * 1000 * 2;

	pk_missile_splash(newmis); // *pk - splash & message setup
};

void () W_FireSuperSpikes =
{
	local vector dir;
	local entity old;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - ammo_con(2, self, null_string);
	if (self.classname == "pk*bot")
		dir = botaim ();
	else
	dir = aim (self,1000);
	
	if (autocvar_sv_centerwep)
		launch_spike (self.origin + '0 0 16', dir);
	else
		launch_spike (self.origin + v_up * VWZ_SNAILG + v_right * VWY_SNAILG + v_forward * VWX_SNAILG, dir);
#ifdef enhanced
//	if (ENHANCED)
	newmis.touch = spike_touch;
//	else
#else
	newmis.touch = superspike_touch;
#endifdef
	newmis.weapon = IT_SUPER_NAILGUN; // Cataboligne - 2.19.11 - correct obit in pk_clientobit
	newmis.dmg = 18;
	setmodel (newmis,"progs/s_spike.mdl");
	setsize (newmis, v0, v0);
	self.punchangle_x = -2;
//	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};

void(float ox) W_FireSpikes =
{
	local vector dir;
	local entity old;

	makevectors (self.v_angle);

	if (self.ammo_nails >= 2 || ammo_con(IT_SUPER_NAILGUN, self, "wpck") && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return ;
	}

	if (!ammo_con(IT_NAILGUN, self, "wpck"))
	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
		W_SetCurrentAmmo ();
		if (self.classname == "pk*bot")
		{
			self.think = self.th_run;
		}
		return ;
	}

	if (PK)
	{
		W_FirePulseSpikes (ox);
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - ammo_con(1, self, null_string);
	if (self.classname == "pk*bot")
		dir = botaim ();
	else
	dir = aim (self, 1000);

	if (autocvar_sv_centerwep)
		launch_spike (self.origin + '0 0 16' + v_right*ox, dir);
	else
		launch_spike (self.origin + v_up * VWZ_NAILG + v_right * ox + v_right * VWY_NAILG + v_forward * VWX_NAILG, dir);

	newmis.weapon = IT_NAILGUN; // Cataboligne - 2.19.11 - correct obit in pk_clientobit
	self.punchangle_x = -2;
//	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};


/*
.float hit_z;
void () spike_touch =
{
	local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other,self,self.owner,9);
	}
	else
	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST,TE_WIZSPIKE);
		else if (self.classname == "knightspike")
				WriteByte (MSG_BROADCAST,TE_KNIGHTSPIKE);
			else
				WriteByte (MSG_BROADCAST,TE_SPIKE);
		WriteCoord (MSG_BROADCAST,self.origin_x);
		WriteCoord (MSG_BROADCAST,self.origin_y);
		WriteCoord (MSG_BROADCAST,self.origin_z);
	}

	remove (self);

};
*/

#ifndef enhanced
void () superspike_touch =
{
//	local float rand;
	if (other == self.owner)
		return ;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other,self,self.owner,18);
	}
	else
	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST,self.origin_x);
		WriteCoord (MSG_BROADCAST,self.origin_y);
		WriteCoord (MSG_BROADCAST,self.origin_z);
	}

	remove (self);

};
#endifdef


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void () W_SetCurrentAmmo =
{
	PK_SetCurrentAmmoOnly(self);
/*
//	if (PK || custom_hub_loaded || (self.cam_x & CHSCAM_ON)) // Cataboligne 8.8.9 purify - cc thru pk code - chase cam
	if (!Q-100)
	{
		if (PK-100)// || !VW)
			PK_SetCurrentAmmo(); // *pk - handle ammo for all pk items & cam
		else
			PK_SetCurrentAmmoOnly(self);
		return;
	}
	if (self.classname == "player") // *bot
	player_run ();		// get out of any weapon firing states

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	signalnoise (self,self); // *bot
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
			self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
			self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
			self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
			self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = null_string;
		self.weaponframe = 0;
	}
*/
};

float () W_BestWeapon =
{
	return(PK_BestWeapon());  // *pk - best wep including pk items
/*
	local float it;
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING))
			return IT_LIGHTNING;
	if (self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN))
		return IT_SUPER_NAILGUN;
	if (self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN))
		return IT_SUPER_SHOTGUN;
	if (self.ammo_nails >= 1 && (it & IT_NAILGUN))
		return IT_NAILGUN;
	if (self.ammo_shells >= 1 && (it & IT_SHOTGUN))
		return IT_SHOTGUN;
	return IT_AXE;
*/
};

float () W_CheckNoAmmo =
{
	return(PK_CheckNoAmmo());
/*
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;

	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
*/
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void () player_axe1;
void () player_axeb1;
void () player_axec1;
void () player_axed1;
void () player_shot1;
void () player_nail1;
void () player_light1;
void () player_rocket1;

void () W_Attack =
{
	PK_Attack();
/*
	local float r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
      sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
      r = random();
      if (r < 0.25)
        player_axe1 ();
      else if (r<0.5)
        player_axeb1 ();
      else if (r<0.75)
        player_axec1 ();
      else
        player_axed1 ();
		if (rune_haste(0.28))
      self.attack_finished = time + 0.5;
  	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		if (rune_haste(0.28))
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		if (rune_haste(0.38))
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		if (rune_haste(0.3))
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		if (rune_haste(0.4))
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}

//	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
*/
};

/*
============
W_ChangeWeapon

============
*/
void () W_ChangeWeapon =
{
	PK_ChangeWeapon();
/*
	local	float	it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}		
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}
	
	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = fl;		
	W_SetCurrentAmmo ();
*/
};

/*
============
CheatCommand
============
*/
void () CheatCommand =
{
	if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void () CycleWeaponCommand =
{
	PK_CycleWeaponCommand();
/*
	local	float	it, am, sf;
	sf = 50;
	
	it = self.items;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

// fixed loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;

		if ((it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
*/
};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void () CycleWeaponReverseCommand =
{
	PK_CycleWeaponReverseCommand();
/*
	local	float	it, am, sf;
	sf = 50;
	
	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

// fixed loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;
	
		if ((it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
*/
};

/*
============
ServerflagsCommand

Just for development
============
void () ServerflagsCommand =
{
	if (SERVERFLAGS) serverflags = serverflags * 2 + 1;
};
*/

// left in to run botmatch from non dp servers, if any non dp engine can run this

void () QuadCheat =
{
	if (cvar("saved1") == 256) // Cataboligne - 5.21.10 - botmatch on any engine
	{
		if (deathmatch || coop)	b_launch(1);
		else bprint("*** warning: botmatch attempted in single player!\n");
	}

/*
	if (deathmatch || coop)
		return ;
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
*/
};

/*
============
ImpulseCommands

============
*/
void () ImpulseCommands =
{
// crosshair
	if (self.impulse == IMP_CROSSHAIR)
	{
		crosshair_con(self, 1);
	}

// Archon rune powers are different
// Archons cannot drop or show inventory
	if (! self.mask_x & MORPH_ARCHON)
	{
// runes
		if (self.impulse == IMP_RUNEID)
			rune_id(self, self);
		else if (self.impulse == IMP_RUNEDROP)
			rune_drop(self);

// inventory
		if (self.impulse == IMP_INV)
			inventory();
		else if (self.impulse == IMP_DROPI) // CHECK: *_100
		{
			if (!self.admin)
				self.admin = -1; // USER-MENU
			self.aflag = self.impulse; // this affects Archon Chaos
		}
	}

	if (self.impulse == IMP_PARM)
		power_armor_impulse();
//	if (self.impulse > 98) botImpulseCommand (); // *bot
// Cataboligne 9.11.3 purify - chase cam
	if (self.impulse > 229 && self.impulse < 240) ccb_impulse_check();

	PK_ImpulseCommands();
/*
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
//	if (self.impulse == 11)
//		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	if (self.impulse == 255)
		QuadCheat ();

	self.impulse = 0;
*/
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
.float button3;
.float button4;
.float button5;
.float button6;

void () W_WeaponFrame =
{
	if (self.button2)
		CheckGrapHookJump (); // cataboligne - 8.29.11 - hook check

	if (time < self.attack_finished) // note - q100 code, mod checks before this call
		return;

	if (self.classname == OBSERVER && (self.impulse != 212)) // *bot - no commands when observing except stop observing
		return;

	if (self.impulse)
		ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		if (inHubMap) if (self.hubstartupmessage > time) self.hubstartupmessage = 0; // *pk - clear hub message
		SuperDamageSound ();
		W_Attack ();

// Cataboligne 4.17.11 - saver fn tie in
		if (self.aiment)
		if (self.aiment.classname == "saver")
			self.aiment.button0 = TRUE;
	}

//	doom_pistol_spread(self.button0); // Cataboligne - 9.12.11 - because doom has a burger king pistol with better acurracy on a single shot aspect
// de looping
	if (self.eweapon)
	if (self.eweapon.vwepmdl == "progs/vw_d_pistol.mdl")
	{
		if (!self.button0)
			self.eweapon.bulletspread = '0.0 0.0 0';	
		else
			self.eweapon.bulletspread = '0.02 0.02 0'; // button held down - accuracy level
	}

};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void () SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if ((self.group != "Berserk rage...nearly over...Hulk sad") || (self.eweapon.grap_state == 666000)) // fists only *4 with berserk
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	rune_dmg_sound();
};


