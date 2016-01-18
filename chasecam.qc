/* ::-::
 *
 * Cataboligne
 *
 * file: chasecam.qc
 *
 * date: unknwn - pk_ccc - 1st cam for pk
 * date: 8.29.03 - chaos mod mkI
 * date: 3.25.08 - pk 2.x
 * date: 3.29.10 - chaos mod mkII
 * date: 9.29.13 - dp cam - removed albins code
 *
 * qc - support chaos mod archon being
 *
 */


/*
now not used - strictly dpcam mod

void( entity m_e, entity v_e) set_viewport =
{
	if (m_e.class_select == "class_bot") return; // no bots

	msg_entity = m_e;                         // target of message
	WriteByte (MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity (MSG_ONE, v_e);           // view port
};
*/

// (moved to defs.qc)
// changed to player.cam_y (distance)
// player.cam_z (zmult)

// hack - handles cl_bob deal - Cataboligne 1.8.8
// IDEA: save bob value

// fn(cam_setbob) - handle bob settings

void(string bcm) cam_setbob =
{
	if (self.class_select == "class_bot") return; // no bots

	if (bcm == null_string)
	{
		if (cvar("cl_bob")) stuffcmd( self, "cl_bob 0\n" ); // dont bob view
	}
	else if (bcm == CL_BOBSET)
	{
		if (cvar("cl_bob") != CL_BOBVAL) stuffcmd( self, bcm ); // bob view setting
	}
	else
	{
		stuffcmd( self, bcm );
	}
};

// Resets weapon model after changing view

void( entity player_ent ) Chase_cam_setweapon =
{
	local entity e;

	e = self;
	self = player_ent;
	if ( (self.cam_x & CHSCAM_ON) )
	{
		self.weaponmodel = null_string;
		cam_setbob(null_string);
		stuffcmd( self, CAM_FOV );
	}
	else
	{
		PK_SetCurrentAmmo();
		cam_setbob(CL_BOBSET);
		stuffcmd( self, STD_FOV );
	}
	self = e;
};




void () dcam_respawnthink =
{
	self.nextthink = time + 0.2;

// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return ;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;

	if (!intermission_running) 
		respawn ();
};
// fn(cam_deathmove) - enable death move

void () cam_deathmove =
{
	self.nextthink = time + 1;

	if (self.owner.solid != SOLID_NOT) // respawned
	{
		remove( self);
		return;
	}
	else if ( self.owner.button2 || self.owner.button1 || self.owner.button0 || intermission_running ) // respawn
	{
		self.owner.health = -1;
		self.owner.deadflag = DEAD_RESPAWNABLE; // really die & respawn

		self.think = SUB_Remove;

		setorigin(self.owner, self.oldorigin);
		self.owner.velocity = '0 0 0';
		if (!intermission_running) 
		{
			self.owner.think = respawn;
			self.owner.nextthink = time + 0.5;
		}

		crosshair_con(self.owner, -1);
		return;
	}
	else if (DCAMTO && (self.delay < time))
	{
		if (DCAMTOACT)
		{
			stuffcmd( self.owner, "disconnect\n" );
			remove(self);
		}
		else
		{
			self.owner.think = respawn;
			self.owner.nextthink = time + 0.5;
		}
		return;
	}
	else // fix issue where admin->observer gets "killed" by splash damage
	{
		self.owner.movetype = MOVETYPE_FLY; // set camera flight pattern delta
		self.owner.takedamage = DAMAGE_NO;
		self.owner.health = 1; // hack so engine will let you move cam
		if (self.owner.think != dcam_respawnthink)
		{
			self.owner.think = dcam_respawnthink;
			self.owner.nextthink = time + 0.2;

			stuffcmd(self, "con_notify 4\n");
			stuffcmd(self, "con_notifytime 3\n");
			stuffcmd(self, "con_notify_alias\n"); // for notify default
		}
		if (self.owner.crosshair_sv > 0) crosshair_off(self.owner);

// pbserver status bar - time spent observing in rels + "high score"
		stuffcmd(self.owner, "infobar 2 \"");
		stuffcmd(self.owner, self.owner.netname);
/*
deprecated - doesnt work this way and admin is moving to the client side

		if (self.admin)
		{
			stuffcmd(self.owner, " : * admin (");
			stuffcmd(self.owner, ftos(rint(time - self.ltime)));
			stuffcmd(self.owner, " rels)");
		}
*/
		stuffcmd(self.owner, " -- Chaos mod: Archon - high score: ");
		stuffcmd(self.owner, ftos(high_score));
		stuffcmd(self.owner, " - map: ");
//		if (world.message != null_string)
//			stuffcmd(self.owner, world.message); // some world messages fsck the info bar because they have \n in them
//		else
		stuffcmd(self.owner, world.model);
		stuffcmd(self.owner, "\"\n");

// start botmatch in observer

		if (self.owner.impulse  == 255)
		if (cvar("saved1") == 256) // Cataboligne - 5.21.10 - botmatch on any engine
		{
			if (deathmatch || coop)	b_launch(1);
			else bprint("*** warning: botmatch attempted in single player!\n");
		}

	}

// observers are very poor - no possesions

	if (self.owner.model != null_model)
	{
		morph_clearparms(self.owner, TRUE);
		PK_SetCurrentAmmoOnly(self.owner); // note: is this needed in loop?
		self.ltime = time;
		setmodel(self.owner, null_model);
		setsize (self.owner,'-4 -4 -4', ' 4 4 4');
		self.owner.wait = 0;
		self.owner.view_ofs_z = 1;
		self.owner.water_notify = null_string; // Cataboligne - 6.13.10 - deadcam splash issue
		self.oldorigin = self.owner.origin;
//		setorigin(self.owner, self.origin);
//		set_viewport(self.owner, self.owner); // back to moving players own ent, cams off

		stuffcmd(self.owner, "hud_message \"your spirit is free!\"\n");
	}

	if (cvar("fov") != DCAM_FOV) stuffcmd( self.owner, DCAM_SET_FOV ); // I see short dead dudes - enforce crow vision
};

// fn(cam_deathview) - view of recently deceased
// create new cam, or hijack chasecam to get here

void () cam_deathview =
{
	self.nextthink = time + 0.1;

	if (self.vwepent)
	{
		vw_chain(self);
		viswep_ld(self, -2);
#ifdef warning
		if (WARNING & 1) bprint(" *** WARNING: viswep found in cam_deathview, should not be so.\n");
#endifdef
	}

// wait for fry model to end before cam tests
	if (self.owner.model == "progs/fryguy.mdl") return;

	if (self.owner.solid != SOLID_NOT) // hit respawn already
	{
		remove( self);
		return;
	}
	else
	if (!self.wait && self.owner.model != null_model)
	{
		self.delay = 0;
		self.wait = time + 4;
		if (DCAMTO) self.delay = DCAMTO + time;
	}
	else
	if (self.wait < time) // when timed out go to deathmove code
	{
		self.think = cam_deathmove;
	}
	else
	if (self.wait < time + 3  && self.owner.model != null_string  && self.owner.solid == SOLID_NOT) // once corpse settles, dont let player move it
	{
		CopyToBodyQue (self.owner);
		self.owner.model = null_string;
	}

	self.owner.classname = OBSERVER;
	PK_SetCurrentAmmoOnly(self.owner);

	self.owner.health = 1; //hack so engine doesnt tilt view

//	crosshair_off(self.owner);
};

// fn(cam_startdeathview) - died and didnt have chasecam on
// called only by player ents immediately after being killed, if
// not already in chaseview, and not in water

void() cam_startdeathview =
{
//	local vector goal, ang;

//	ang = self.v_angle;
//	ang_x = 30; // pretend was a slight down aim
	self.weaponmodel = null_string;

	self.oldenemy = newmis = spawn();
	newmis.owner = self;
	newmis.classname = "deadcam";
	newmis.nextthink = time + 0.1;
	newmis.think = cam_deathview;
/*

might want to try this with player ent after copy to bodyque
	
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_FLY;
	newmis.angles = newmis.owner.angles;
	setmodel (e, CAM_MODEL );
	setsize (e, '0 0 0', '0 0 0');
	makevectors( ang );
	goal = (self.origin + '0 0 18') - (v_forward * 120);
	traceline( self.origin + '0 0 18', goal, TRUE, self);
	setorigin( e, trace_endpos + (v_forward * 8));
	newmis.velocity = '0 0 0' - v_forward * 20;
	newmis.dest = '0 0 0' - v_forward; // save forward direction, used in cam_deathview
*/
//	set_viewport( self, e);
};




// called by player only
void() Toggle_chase_cam =
{
//	local float tg;

	if (self.admin) return; // pk mods
	if (self.classname == OBSERVER) return;

	if (self.cam_x & CHSCAM_ON)
		self.cam_x = self.cam_x - CHSCAM_ON;
	else
		self.cam_x = self.cam_x | CHSCAM_ON;

	Chase_cam_setweapon( self );
	stuffcmd(self, "chase_active ");
	stuffcmd(self, ftos(self.cam_x & 1)); // Cataboligne - 8.26.11 - support for dpcam
	stuffcmd(self, "\n");

};



// opt:
// 0 = minus
// 1 = plus
// (player.cam_y holds cam distance)
void(float opt) Chase_cam_change_dist =
{

	if (!opt)
	{
		self.cam_y = self.cam_y - 2;
		if (self.cam_y < 10)
			self.cam_y = 10;
	}
	else
		self.cam_y = self.cam_y + 2;

	sprint( self, "chasecam distance = " );
	sprint( self, ftos(self.cam_y) );
	sprint( self, "\n" );


};

// opt:
// 0 = minus
// 1 = plus
// (player.cam_z holds zmult)
void(float opt) Chase_cam_change_zmult =
{
	local float f;

	if (!opt)
	{
		self.cam_z = self.cam_z - 0.02;
		if (self.cam_z < 0)
			self.cam_z = 0;
	}
	else
		self.cam_z = self.cam_z + 0.02;


	// convert and strip for display
	// apparantly,
	//	.cam_z = .cam_z +- 0.02;
	// don't _exactly_ add/sub 0.02
	f = self.cam_z * 100;
	f = rint( f );

	sprint( self, "chasecam verticle offset = " );
	sprint( self, ftos(f) );
	sprint( self, "\n" );
};



	// prevent internal C from tilting the view after
	// QC has already initiated all death processes
void () dead_cam_set =
{

// limit on frags from fire & forget implementation

	if (self.flags & FL_CLIENT || self.class_select == "class_bot") // should just be FL_CLIENT
	if (FFW_LIMIT > 0)
	{
		self.search_time = time + FFW_LIMIT;
	}

	if (self.disconnectPlayer) return; // dont set for disconnect frikbots that get splash damage!
	if (self.class_select == "class_bot") return; // no bots past this - they get the code above

// NOTE: wraith option still needs checked once we have chaos mod morph deal
	
	if (self.flags & FL_CLIENT)
	{
		if (self.oldenemy.classname == "deadcam") return; // dont make more than one - just in case

		cam_startdeathview();
	}

// just leave cam on if on, and run this - 0 follow vars
	stuffcmd(self, "exec cfg/morph/dead.cfg\n");
};

// fn(cam_punch) - zero punchangle_x if cam active when firing weps

// self is player ent
/*

deprecate - dp cam does not use this

void() cam_punch =
{
	if (self.cam_x & CHSCAM_ON) self.punchangle_x = 0;
};
*/

void () ccb_impulse_check =
{
	if (self.class_select == "class_bot") return; // no cam for bots - not sure how they would get here...

	if (!autocvar_sv_cam) return; // server turned cam off

//chase cam code
	if (self.impulse == 230) Toggle_chase_cam();

	else if (self.impulse == 232) Chase_cam_change_zmult(0); // minus
	else if (self.impulse == 233) Chase_cam_change_zmult(1); // plus
	else if (self.impulse == 234) Chase_cam_change_dist(0); // minus
	else if (self.impulse == 235) Chase_cam_change_dist(1); // plus

//	else if (self.impulse == 231) LaserTargeterToggle( self );

	stuffcmd(self, "chase_back ");
	stuffcmd(self, ftos(floor(self.cam_y)));
	stuffcmd(self, "\n");
	stuffcmd(self, "chase_up ");
	stuffcmd(self, ftos(floor(self.cam_z * 100)));
	stuffcmd(self, "\n");

};

// Cataboligne - 8.22.9 - fix jump out of water with chasecam

void (vector ts) cam_CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin + ts;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};

void() cam_waterjump =
{
	if (self.class_select == "class_bot") return; // no bots

//	if (! self.flags & FL_WATERJUMP)
	cam_CheckWaterJump ('0 0 -8');
	if (! self.flags & FL_WATERJUMP)
		cam_CheckWaterJump ('0 0 -4');
	if (! self.flags & FL_WATERJUMP)
		cam_CheckWaterJump ('0 0 4');
	if (! self.flags & FL_WATERJUMP)
		cam_CheckWaterJump ('0 0 8');
//		if (! self.flags & FL_WATERJUMP)
//			cam_CheckWaterJump ('0 0 10');
//		if (! self.flags & FL_WATERJUMP)
//			cam_CheckWaterJump ('0 0 12');
};
