/* ::-::
 *
 * Cataboligne
 *
 * file: laser_cannon.qc
 *
 * date: 2/14/11
 *
 * qc - support hipnotic
 *
 */
 
/*
		+---------------------------------------+
		|  hip lasercannon code                 | SEC-HEAD
		+---------------------------------------+
*/

void() lasercannon_precache =
{
	precache_model ("progs/laser_m.mdl");
	precache_model ("progs/g_lasercannon.mdl");
	precache_model ("progs/v_lasercannon.mdl");
//	precache_model ("progs/vw_lasercannon.mdl");
	precache_model ("progs/vw_qgun.mdl");

	precache_sound ("enforcer/enfstop.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("weapons/lasercannon/laserg.wav");	// laser cannon
	precache_sound ("weapons/lasercannon/laserric.wav");	// laser cannon ricochet
};

// fn(HIP_LaserTouch) - bounce a bolt or do dmg

void() HIP_LaserTouch =
{
	local vector org;
	local vector spot1,spot2;
	local vector oldvel;
	local float mag;
	local float r;

	self.owner = world;
	self.cnt = self.cnt - 1;

//	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return;	}
	if (sky_touch("", v0, self))
	{
		SUB_Remove();
		return;
	}

	oldvel = normalize(self.oldorigin);
	spot1 = self.origin - (16*oldvel);
	spot2 = self.origin + (16*oldvel);
	traceline (spot1, spot2, FALSE, self);  // see through other monsters
	self.origin = trace_endpos;

	org = self.origin;

	if (other.takedamage)
		{
		if (self.lastvictim == other)
			{
			self.dmg = self.dmg / 2;
			}
		if (other.solid == SOLID_SLIDEBOX) spawn_touchblood (self.dmg);
		T_Damage (other, self, self.lastvictim, self.dmg);
		}
	else if ((self.cnt < 0) || (random() < LASER_RND_END)) // no more bouncy - flight also over
		{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		}
	else				// TWEAK: adapt for ric nails?
		{
		v_forward = normalize(self.velocity);
//		lava_shot(self.origin, LAVA_SHOT * 2.5, v0, self.dmg / 9);
//
//		self.dmg = 0.66 * self.dmg;
		self.dmg = 0.9 * self.dmg;
//		self.speed = 0.95 * self.speed;
		self.velocity = oldvel+(2*trace_plane_normal);
		self.velocity = normalize(self.velocity);
		self.velocity = self.speed * self.velocity;
		self.oldorigin = self.velocity;

      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;
		sound (self, CHAN_WEAPON, self.target, 1, ATTN_STATIC);
/*
		r = random();
		if (r<0.33)
			sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
		else if (r<0.66)
			sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
		else
			sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/
		return;
		}
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	remove(self);

};


// fn(HIP_LaserThink) - think for laser cannon bolt - helps with reflective we think

void() HIP_LaserThink =
{
	local float delta;

	if (time>self.attack_finished) // flight over
	{
		remove(self);
		return;
	}

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.velocity = self.oldorigin;
	self.angles = vectoangles(self.velocity);
	self.nextthink = time+0.1;
};

// fn(HIP_LaunchLaser) - send a bolt out

// from org to vec
// play sound sd
// if from laser cannon, only really hot bolts get lit

void(vector org, vector vec, float light1, string sd) HIP_LaunchLaser =
{
	fire_missile(LASERCAN_VEL, MOVETYPE_FLYMISSILE, FL_CTHONF, RM_SKY, org, vec, "laser", "progs/laser_m.mdl", sd, HIP_LaserTouch, 0, HIP_LaserThink, SUB_Null);
// stuff for laser cannon only
	newmis.weapon = -256; // not defined, so this
	newmis.angles = vectoangles(newmis.velocity);
	newmis.oldorigin = newmis.velocity;
	newmis.speed = LASERCAN_VEL;
	newmis.avelocity = '0 0 400';
	newmis.dmg = 18;
	newmis.attack_finished = time + 5; // flight time
	if (EWEAP)
	{
		newmis.dmg = EWEAP.dmg;
		newmis.attack_finished = time + EWEAP.lefty;
	}
	if (LASER_FLY > 0)
		newmis.attack_finished = time + LASER_FLY;
	newmis.lastvictim = self;
	newmis.count = 0;
	newmis.cnt = 2 + random() * 3; 
	if (LASER_BOUNCE > 0)
		newmis.cnt = LASER_BOUNCE + random() * 3; 

	if (light1) newmis.effects = EF_DIMLIGHT;

	if (EWEAP) newmis.target = EWEAP.target; // bouncy sound
	else newmis.target = "weapons/lasercannon/laserric.wav";
// laser cannon bolt selection
	newmis.skin = 3;
	newmis.frame = 4;
};

// fn(HIP_FireLaser) - fire a shot from laser cannon
//		stat - which barrel set is firing

void(float stat) HIP_FireLaser =
{
	local vector org;
   local vector dir;
   local vector out;
   local float ofs;
   local float aofs;

	if (!self.button0)
	{
      player_run ();
      return;
	}

	if (self.ammo_cells < ammo_con(self.eweapon.dmg_save, self, ""))
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
//		eject_batt(1 + random() * 0.8 + crandom() * 1);
		return;
	}

   SuperDamageSound();
   self.effects = self.effects | EF_MUZZLEFLASH;
   makevectors (self.v_angle);

   ofs = 6;
   out = v_forward;
   out_z = 0;
   out = normalize(out);
   org = self.origin + ((VWZ_LASERCAN - ofs) * v_up) + (VWX_LASERCAN * out);
   dir = aim (self, 1000);
   aofs = ofs * 0.707;

   if (stat == 0)
      {
      self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(self.eweapon.dmg_save, self, "");
		org = org + (aofs*v_right);
		org = org - (aofs*v_up);
		HIP_LaunchLaser(org + v_right * VWY_LASERCAN, dir, 0, self.eweapon.noise3);
		org = org - (2*aofs*v_right);
		HIP_LaunchLaser(org + v_right * VWY_LASERCAN, dir, 0, self.eweapon.noise3);
      }
   else if (stat == 1)
      {
      self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(self.eweapon.dmg_save, self, "");
      org = org + (ofs*v_up);
      if (random()<0.1)
         {
			HIP_LaunchLaser(org + v_right * VWY_LASERCAN, dir, 1, self.eweapon.noise3);
         newmis.dmg = newmis.dmg * 1.39; // = 25 if base 18
         }
      else
			HIP_LaunchLaser(org + v_right * VWY_LASERCAN, dir, 0, self.eweapon.noise3);
      }
   self.punchangle_x = -1;
};
