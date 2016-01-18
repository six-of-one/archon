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

	if (fl)
	if	(fent.morphy == IMP_MWIZARD
		|| fent.morphy == IMP_MCHAOS
		|| fent.morphy == IMP_MWRAITH
		|| fent.morphy == IMP_MGREMLIN
		|| fent.classname == "deadcam"
//		|| (fent.model == "progs/gremlin-fly.mdl" && fent._stand == gremlin_hover)
		)
	{
		fent.movetype = MOVETYPE_FLY;
	}
};


// fn(flyer_mode) - switch between ground & flight if flight is an option

// called by impulse 155

void(entity fent) flyer_mode =
{
	if (fent.morphy == IMP_MGREMLIN)
	{
//		if (fent == self) gremlin_takeoff(); // gremlin must switch modes here
		return;
	}

	if (fent.movetype == MOVETYPE_FLY) // landing - best be close to ground
	{
		flyer_check(fent, FALSE);
	}
	else
	{
		flyer_check(fent, TRUE);
//		fent.velocity = self.velocity * v_up * 50; // some upward motion
	}
};

void() flyer_move =
{
	local float vel1, yaw_diff, up_z;
	local vector dir, dir2;

//allows up/down move when pointing that way
	makevectors (self.v_angle);

	self.flags = self.flags | FL_ONGROUND; // for flight at speed?

	if (self.velocity_x || self.velocity_y)
	{
		vel1 = vlen (self.velocity); // its current speed
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

		if (up_z)
		{
			if (vlen (self.velocity) > 10)
			{
				vel1 = cvar ("sv_maxspeed");
				self.velocity = normalize (dir) * vel1;
			}
		}
	}
};
