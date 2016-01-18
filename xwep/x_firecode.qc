/*-
	+---------------------------------------+
	|  Weapon effects code                  | SEC-HEAD
	+---------------------------------------+
*/

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
						self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_con(e.dmg_save, self, ""); // use ammo
					else if (e.lip == AMMO_CELLS)
						self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(e.dmg_save, self, ""); // use ammo
					else if (e.lip == AMMO_SLUGS)
						self.currentammo = self.ammo_slug = self.ammo_slug - ammo_con(e.dmg_save, self, ""); // use ammo
					else if (e.lip == AMMO_GRENADES)
						self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_con(e.dmg_save, self, ""); // use ammo
					else if (e.lip == AMMO_NAILS)
						self.currentammo = self.ammo_nails = self.ammo_nails - ammo_con(e.dmg_save, self, ""); // use ammo
			}
			if (flg & FL_MPUNCH)
			{
	//			if (!(self.cam_x & CHSCAM_ON))
				self.punchangle_x = 0 - (flg & FL_MPUNCH); // weapon kick in 1pv
				cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
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
		newmis.velocity = normalize(vfw); // default velocity - fired in look dir v_forward or vdr if not ' 0 0 0'
		}

	newmis.velocity = newmis.velocity * vmul * rvel;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.pos1 = normalize(newmis.velocity);

//	if (no_sound != self)
	if (sd != "")
		{
		if (flg & FL_SNDMIS) sound (newmis, CHAN_WEAPON, sd, 1, ATTN_NORM);
		else sound (self, CHAN_WEAPON, sd, 1, ATTN_NORM);
		}

//	newmis.frags = NOFAKE; // no missile fakeloads by default - need to change if this ever fires weapons out
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
	self.attack_finished = time + 0.2;
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
	self.attack_finished = time + 0.2;
};


// eweapon missiles

entity fts; // fire test

void () X_MissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}
if (self.eweapon) {
bprint(" *** eweap ");
bprint(self.eweapon.netname);
}
else
bprint(" *** missile (?) ");

	if (!self.dmg) self.dmg = 100 + random() * 20;
	else if (self.dmg == DOOM_ROCK_DMG) self.dmg = 20 * ceil(random() * 8);
	if (!self.dodmg) self.dodmg = 120;



bprint(", hit dmg = ");
bprint(ftos(self.dmg));
bprint(", splash dmg = ");
bprint(ftos(self.dodmg));
fts.dmg_take = fts.dmg_take + self.dmg;
fts.dmg_save = fts.dmg_save + 1;



	if (other.health)
	{
		if (other.classname == "monster_shambler")
			self.dmg = self.dmg * 0.5;	// mostly immune
		T_Damage (other,self,self.owner,self.dmg);
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self,self.owner,self.dodmg,other);




bprint(", tot dmg = ");
bprint(ftos(self.dmg+self.dodmg));
bprint(".\n");
fts.dmg = fts.dmg + self.dmg+self.dodmg;



//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);

	BecomeExplosion ();

	if (self.target != "") sound (self, CHAN_WEAPON, self.target, 1, ATTN_NORM);
};

// handle eweapon hitscan bullet shooters
float tdmg;

void (float shotcount, float pdmg, vector dir, vector spread) X_FireBullets =
{
	local vector direction;
	local vector src;
	local float ddmg

	makevectors (self.v_angle);

	ddmg = pdmg;

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		if (pdmg == DOOM_SHOT_DMG) {ddmg = 5 * ceil(random() * 3);



bprint(", bdmg = ");
bprint(ftos(ddmg));

}
tdmg = tdmg + ddmg;
fts.dmg_take = fts.dmg_take + ddmg;
fts.dmg_save = fts.dmg_save + 1;




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



bprint(" *** eweap ");
bprint(EWEAP.netname);
tdmg = 0;



	self.punchangle_x = -2 * EWEAP.dmg_save;
	cam_punch(); // Cataboligne - 6.26.10 - because of fire from frames call

	if (EWEAP.lip == AMMO_SHELLS)
		f = self.ammo_shells;
	else if (EWEAP.lip == AMMO_BULLETS)
		f = self.ammo_bullet;
	d = EWEAP.dmg_save; // ammo to fire
	t = EWEAP.dmg_take; // shots to fire

	f = f - ammo_con(d, self, ""); // use ammo
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
		if (!Q_100 && !Q_99) self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
		W_SetCurrentAmmo ();
		if (self.classname == "pk*bot")
			self.think = self.th_run;
		return ;
	}

	if (EWEAP.lip == AMMO_SHELLS)
		self.currentammo = self.ammo_shells = f;
	else if (EWEAP.lip == AMMO_BULLETS)
		self.currentammo = self.ammo_bullet = f;

	if (self.classname == "pk*bot")
		dir = botaim ();
	else
		dir = aim (self,100000);

	X_FireBullets (t, EWEAP.dmg, dir, EWEAP.punchangle);




bprint(", tot dmg = ");
bprint(ftos(tdmg));
bprint(".\n");
fts.dmg = fts.dmg + tdmg;
if (fts.eweapon._attack == SUB_Null) fts.cnt = fts.cnt + 1;




};


// fire machine guns & chain guns

void(float ns) mgchg_shot =
{
	EWEAP = self.eweapon;
	if (EWEAP)
	{
		X_FireHitscan();
		if (rune_haste(EWEAP.attack_finished / 2))
			self.attack_finished = time + EWEAP.attack_finished;
		if (ns)
		if (EWEAP.noise3 != "")
			sound (self, CHAN_WEAPON, EWEAP.noise3, 1, ATTN_NORM);
		EWEAP = world;
	}
	else
	{
		if (WARNING) bprint("*** Warning -  EWEAP fn() call and eweapon is NULL!\n");
			self.weapon = W_BestWeapon ();
			if (!Q_100 && !Q_99) self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
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
	mgchg_shot(0);
	if (self.eweapon) self.nextthink = time + self.eweapon.attack_finished;
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
	if (self.eweapon) self.nextthink = time + self.eweapon.attack_finished;
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
	mgchg_shot(0);
	if (self.eweapon) self.nextthink = time + self.eweapon.attack_finished;
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
	if (self.eweapon) self.nextthink = time + self.eweapon.attack_finished;
};


// fire plasma & guns

// fn(plasmaexplode1) - wash plasma bolt out of world
// fn(Plasma_MissileTouch) - blow a plasma bolt - handles monster stuff if eweapon not set
// fn(X_FireOnePlasma) - fire a single plasma bolt, handles weapon stuff


void () plasmaexplode5 = [ 7, plasmaexplode6 ] { self.alpha = 0.3; };
void () plasmaexplode6 = [ 8, SUB_Remove    ] { self.alpha = 0.1; };

void () plasmaexplode1 = [ 3, plasmaexplode2 ] { self.alpha = 0.7; };
void () plasmaexplode2 = [ 4, plasmaexplode3 ] 
{
	if (random() < 0.5) self.think = plasmaexplode5;
	self.alpha = 0.5;
};
void () plasmaexplode3 = [ 5, plasmaexplode4 ] { self.alpha = 0.3; };
void () plasmaexplode4 = [ 6, SUB_Remove    ] { self.alpha = 0.1; };

void () Plasma_MissileTouch =
{
	local vector org;
	local string mon, snd;

	if (other == self.owner)
	{
		return;
	}

	if (sky_touch("", org, world)) return;

	if (self.noise3 == "") self.noise3 = "doom/dsfirxpl.wav";

	sound (self, CHAN_ITEM, self.noise3, TRUE, ATTN_NORM);

	if (!self.dmg)
	{																		if (WARNING) bprint("plasma missle touch set def damage\n");
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
	{																		if (WARNING) bprint("plasma explosive\n");
		if ((org != v0) && (random() < LAVA_PLASMA_MLT))
		{ 																if (WARNING) bprint("plasma bomb failed in lava\n");
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
		if (other.solid == SOLID_SLIDEBOX)  // BLOODCHECK - in case some other bit of gib / dead body can make blood
			SpawnBlood (org, (self.velocity * 0.2), 15);
		T_Damage (other, self, self.owner, self.dmg);
	}

// some plasma may splash
// don't do radius damage to the other, because all the damage was done in the impact
	if (self.dodmg)
		T_RadiusDamage (self, self.owner, self.dodmg, other);

	self.velocity = '0 0 0';
//	move_stop(self, "");
	self.th_stand = self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	plasmaexplode1 ();
};


void () X_FireOnePlasma =
{
//	local vector org;
	local string snd, pls, expl;
	local float dm;
	vector org, bfwd;




bprint(" *** eweap ");
bprint(EWEAP.netname);



	dm = 15;
	pls = "progs/d_plasma_sht.mdl";
	expl = "doom/dsfirxpl.wav";
//	org = self.origin; // self.origin + (v_forward * 30) + '0 0 11' - arach ref
	if (EWEAP) 
	{
//		self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(EWEAP.dmg_save, self, ""); // use ammo
		dm = EWEAP.dmg;
		if (dm == DOOM_SHOT_DMG) dm = 5 * ceil(random() * 8);
		snd = EWEAP.noise3;
		pls = "progs/d_plasma_sht.mdl";
		if (EWEAP.target != "") expl = EWEAP.target;
	}
	if (snd == "") snd = "doom/dsplasma.wav"; // FIX - different generic, chaos will come here

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

	fire_missile(PLASMA_VEL, MOVETYPE_FLYMISSILE, FL_MSL | FL_PUNCH | FL_USEAMMO | FL_AIM1K | FL_RUNEHST, RM_SKY | PF_LAVA, org, ' 0 0 0', "missile", pls, snd, Plasma_MissileTouch, ROCKET_FUSE,  plasmaexplode1, Plasma_MissileTouch);

	if (newmis)
	{
		newmis.noise3 = expl;
	
		pk_missile_splash(newmis); // *pk - splash & message setup

		newmis.dmg = dm;

		if (EWEAP)
		{
			newmis.eweapon = EWEAP;
			newmis.dodmg = EWEAP.dodmg;
		}
	}
//	sound (self, CHAN_WEAPON, snd, 1, ATTN_NORM);





bprint(", hit dmg = ");
bprint(ftos(dm));
bprint(", splash dmg = ");
bprint(ftos(EWEAP.dodmg));
fts.dmg_take = fts.dmg_take + dm;
fts.dmg_save = fts.dmg_save + 1;


bprint(", tot dmg = ");
bprint(ftos(dm+EWEAP.dodmg));
bprint(".\n");
fts.dmg = fts.dmg + dm+EWEAP.dodmg;
fts.cnt = fts.cnt + 1;


};

// doom plasma gun finish fire frames - gun comes way up - vw uses shot frames!
void() player_plasma2   = [$shotatt1, player_plasma3] {self.weaponframe = 8; };
void() player_plasma3   = [$shotatt1, player_plasma4] {self.weaponframe = 8; };
void() player_plasma4   = [$shotatt2, player_plasma5] {self.weaponframe = 8; };
void() player_plasma5   = [$shotatt3, player_plasma6] {self.weaponframe = 9; };
void() player_plasma6   = [$shotatt4, player_plasma7] {self.weaponframe = 9; };
void() player_plasma7   = [$shotatt5, player_plasma8] {self.weaponframe = 9; };
void() player_plasma8   = [$shotatt6, player_run] {self.weaponframe = 1; };

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
		self.nextthink = time + self.eweapon.attack_finished; // every other frame is fire frame
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
		self.nextthink = time + self.eweapon.attack_finished; // every other frame is fire frame
	else
		self.nextthink = time + 0.2;

	SuperDamageSound();
	X_FireOnePlasma();

	EWEAP = world;
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



void() f_rmv =
{
bprint(".\n");
bprint("fire counter reset.\n");
bprint(".\n");
	fts = world;
	remove(self);
};

void() f_test =
{
bprint(".\n");
bprint(".\n");
bprint(".\n");
bprint(self.message);
bprint(self.eweapon.netname);
bprint(", rpm = ");
bprint(ftos(self.cnt));
bprint(", tot dmg = ");
bprint(ftos(self.dmg));
bprint(", hit dmg = ");
bprint(ftos(self.dmg_take));
bprint(", avg dmg per = ");
bprint(ftos(self.dmg_take / self.dmg_save));
bprint(".\n");
bprint(".\n");
bprint(".\n");
bprint(".\n");
self.nextthink = time + 20;
self.think = f_rmv;
};

// fire any eweapon

void() e_weap_Attack =
{
	local entity e;

	EWEAP = e = self.eweapon;

	if (!fts) // testing - rpm
	{
		fts = spawn();
		if (fts)
		{
			fts.think = f_test;
			fts.nextthink = time + 60;
		}
		fts.message = "*** Weapon: ";
		fts.eweapon = EWEAP;
		fts.dmg = fts.cnt = 0;
	}

	if (rune_haste(e.attack_finished / 2))
		self.attack_finished = time + e.attack_finished;

	if (e._attack != SUB_Null) {e._attack();

fts.cnt = fts.cnt + 1;
}

	if (e._fr_attack != SUB_Null) e._fr_attack();
	if (e.noise3 != "")
		sound (self, CHAN_WEAPON, e.noise3, 1, ATTN_NORM);
//	e.aflag = self.currentammo;

// rocket wep specials
	if (e._attack == W_FireRocket)
	if (newmis.classname == "missile")
	{
		newmis.touch = X_MissileTouch;
		newmis.dmg = e.dmg;
		newmis.dodmg = e.dodmg;
		newmis.eweapon = e;
		newmis.target = e.target;
	}

	EWEAP = world;

	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};

