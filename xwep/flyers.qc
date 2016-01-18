/*
		+---------------------------------------+
		|  Flyer code                           | SEC-HEAD
		+---------------------------------------+
*/

// code for flying morphs - controlled via movetype

// fn(flyer_check) - check to see if player has flight capabilities

// set MOVETYPE_FLY if we can fly
// so far these can fly - chaos as plasma bolt ball, scragg, deadcam, flying gremlin when launched


void(entity fent, float fl) flyer_check =
{
	if (!fent.movetype) return; // froze by something

	fent.movetype = MOVETYPE_WALK;

	if (!self.admin)
	{
		self.wad = "";
		centerprint(self,  self.wad);
	}
	if (fl)
	if	(fent.morphy == IMP_MWIZARD
		|| fent.morphy == IMP_MCHAOS
		|| fent.morphy == IMP_MWRAITH
		|| (fent.model == "progs/gremlin-fly.mdl" && fent._stand == gremlin_hover)
		|| fent.classname == "deadcam"
		|| (fent.rune_flag & RUNE_FLG_FLY)
		)
	{
		fent.movetype = MOVETYPE_FLY;
	}
};


// fn(flyer_mode) - switch between ground & flight if flight is an option

// called by impulse 15

void(entity fent) flyer_mode =
{
	if (fent.mask_x & CB_GREMLIN)
	{
		if (fent == self)
		if (fent ._stand != gremlin_hover)
		{
			gremlin_takeoff(); // gremlin must switch modes here
			return;
		}
	}

	if (fent.movetype == MOVETYPE_FLY) // landing - best be close to ground
	{
		traceline (fent.origin, fent.origin + ' 0 0 -8000', TRUE, fent);
		if (fent.wad == "flyerfreefall")
			flyer_check(fent, FALSE);
		else
		if (vlen(fent.origin - trace_endpos) > 128)
		{
			fent.wad = "flyerfreefall";
			centerprint(fent,  "Flying at height, use caution landing, hit impulse again to free fall.\n");
		}
		else
		flyer_check(fent, FALSE);
	}
	else
	{
		flyer_check(fent, TRUE);
//		fent.velocity = self.velocity * v_up * 50; // some upward motion
	}

	if (fent.mask_x & CB_GREMLIN)
	if (fent.movetype != MOVETYPE_FLY)
	{
		fent._stand=SUB_Null;
		fent._run=SUB_Null;
	}

};

void() flyer_move =
{
	local float vel1, ms;
	local vector v1;

/*
//	self.flags = self.flags | FL_ONGROUND; // for flight at speed?

	local vector dir, dir2;
	local float vel1, yaw_diff, up_z;

	vel1 = vlen (self.velocity); // its current speed

	makevectors (self.v_angle);

	if (!DARKPLACES)
	if (self.velocity_x || self.velocity_y)
	{
		dir = self.velocity;
		dir2 = vectoangles (dir);
// This corrects an ID mistake.  They had the pitch angle in
// reverse.
		dir2_x = dir2_x * -1;
		yaw_diff = dir2_y - self.v_angle_y;
		if (yaw_diff > 180)
			yaw_diff = yaw_diff - 360;
		if (fabs (self.v_angle_x) > 24)
		{
			up_z = TRUE;  // movement in z direction (up/down)
			if (fabs (fabs (yaw_diff) - 180) < 2)
			{
				dir = v_forward * -1;
			}
			else if (fabs (yaw_diff) < 2)
			{
				dir = v_forward;
			}
			else
			{
				up_z = FALSE;
			}
		}
		self.velocity = normalize (dir) * vel1;
/*
		if (up_z)
		{
			if (vlen (self.velocity) > 10)
			{
				vel1 = cvar ("sv_maxspeed");
				self.velocity = normalize (dir) * vel1;
			}
		}
	}
*/



// TEST: flyer speed
if (cvar("saved1") == -888)
if (vlen(self.velocity) > 50)
//if (vlen(self.velocity) > cvar("sv_maxspeed") + 2)
//if (time & 3 == 0)
{
bprint("fly --- speedlimit: ");
bprint(ftos(cvar("sv_maxspeed")));
bprint("  - movecode: ");
bprint(vtos(self.movement));

bprint("  - haste speed: ");
bprint(ftos(vlen(self.velocity)));
bprint("\n");
}

	v1 = self.velocity;
	v1_z = 0;
	vel1 = vlen (v1); // current speed - not z
	ms = cvar("sv_maxspeed");

	if (self.classname == OBSERVER) ms = ms * 2;

	if (!self.movement_x && !self.movement_y)
	{
		if (vel1 > 0)
		{
			self.velocity_x = self.velocity_x * 0.97;
			self.velocity_y = self.velocity_y * 0.97;
		}
		if (fabs(self.velocity_x) < 30) // these are capped so we actually stop in hover mode
			self.velocity_x = 0;
		if (fabs(self.velocity_y) < 30)
			self.velocity_y = 0;
	}
	else
	if (self.movement)
	if (vel1 < ms)
	{
		if (self.movement_x > 0)
		{
			self.velocity = self.velocity * 1.08;
			if (!self.movement_z)
			if (fabs (self.v_angle_x) > 20) // looking up or down - move up & down
				self.velocity_z = 2 * (0 - self.v_angle_x);
			else
				self.velocity_z = self.velocity_z * 0.8;
		}

		else if ( (fabs(self.movement_y) > 0) ||  (self.movement_x < 0) )
		{
			if (vel1 < (ms * 0.8))
				self.velocity = self.velocity * 1.04;

			if (self.movement_x < 0)
			if (!self.movement_z)
			if (fabs (self.v_angle_x) > 20) // looking up or down - move up & down
				self.velocity_z = 2 * self.v_angle_x;
			else
				self.velocity_z = self.velocity_z * 0.8;
		}
	}

	if (self.movement_z)
	{
		if (fabs(self.velocity_z) < ms)
			self.velocity_z = self.velocity_z * 1.04;
	}
	else
	if (!self.movement_x)
	{
		self.velocity_z = self.velocity_z * 0.95;
		if (fabs(self.velocity_z) < 30)
			self.velocity_z = 0;
	}
};
