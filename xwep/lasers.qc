// fn (Laser_Blast) - laser touch fn, smarter than enforcers code
// from ultimate mod, original code by n-tropy

void() Laser_Blast =
{
	local vector org;
	local float dm;

	if (other)
	if (other == self.owner)
		return;         // don't explode on owner

	if (sky_touch("", v0, self))
	{
		SUB_Remove();
		return;
	}

	dm = 35;
	if (self.dmg) dm = self.dmg;
//	if (IS_CHAOS_PURE(self.owner)) dm = rint(20 + (random() * 40));

	if (self.noise3 == "") self.noise3 = "enforcer/enfstop.wav";

	sound (self, CHAN_ITEM, self.noise3, TRUE, ATTN_NORM);

	org = self.origin - 8*normalize(self.velocity);

	if (other.takedamage)
	{
		if (other.solid == SOLID_SLIDEBOX)  // BLOODCHECK - in case some other bit of gib / dead body can make blood
			SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, dm);
	}
	if (!other.takedamage || other.solid != SOLID_SLIDEBOX)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);

		v_forward = normalize(self.velocity);
//		lava_shot(self.origin, LAVA_SHOT * 2.5, v0, 1 + random());
	}

	SUB_Remove();
};

// fn(fire_laser1) - some generic laser fire code, used by inventory & chaos
// self - firing entity
// returns laser beam created, fired in facing direction (no autoaim bs)

// fn(laser_bolt_select) - select among several lasers for game map load

float laser_fr;
float laser_sk;
float laser_sel;

void() laser_bolt_select =
{
	if (!laser_sel)
	{
		laser_sel = random();
		if (laser_sel < 0.5) { laser_fr = 0; laser_sk = 0; } // usual q1 laser bolt
		else if (laser_sel < 0.7) { laser_fr = 7; laser_sk = 1; } // stylized blue bolt, .75 size cylinder model
		else if (laser_sel < 0.9) { laser_fr = 7; laser_sk = 3; } // pure red bolt, .75 size cylinder model
		else { laser_fr = 4; laser_sk = 2; } // flare bolt, .75 size slope trapezoid model
	}
};

void() fire_laser1 =
{
	local vector org;

	if (!laser_sel) laser_bolt_select();

	org = self.origin; // + v_forward * 4 + v_up * 16; // gen fire ref - really chaos morph, but was screwing up firebursts
	if (EWEAP) org = self.origin + v_right * VWY_LASER + v_forward * VWX_LASER + v_up * VWZ_LASER;

	fire_missile(LASERCAN_VEL, MOVETYPE_FLYMISSILE, FL_USEAMMO, RM_SKY | PF_LAVA, org, ' 0 0 0', "laser", "progs/laser_m.mdl", "", Laser_Blast, 6, SUB_Remove, Laser_Blast);
	newmis.skin = laser_sk;
	newmis.frame = laser_fr;
//		newmis.effects = EF_DIMLIGHT;
	if (EWEAP)
	{
		newmis.dmg = EWEAP.dmg;
		if (EWEAP.dmg == DOOM_SHOT_DMG) newmis.dmg = 5 * ceil(random() * 8);
		if (EWEAP.target != "") newmis.noise3 = EWEAP.target;
	}

};

// fn(fire_enflaser) - where the enforcers gun fires a laser - here because this is an inventory item

void() fire_enflaser =
{
	local float f;
	
	if (self.eweapon) f = FL_USEAMMO; // enf laser retrieved by another player - uses ammo
	fire_missile(LASER_VEL, MOVETYPE_FLYMISSILE, f, RM_SKY | PF_LAVA, self.origin + v_forward * VWX_LASER + v_right * VWY_LASER + v_up * VWZ_LASER, v0, "laser", "progs/laser_m.mdl", "enforcer/enfire.wav", Laser_Blast, 5, SUB_Remove, Laser_Blast);
	newmis.skin = 4;
	newmis.frame = 8; // yellow bolt, small cylinder
	newmis.effects = EF_DIMLIGHT;
};
