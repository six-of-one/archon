//====================================================================
//
// SWINGING GRAPPLING HOOK			by: Perecli Manole AKA Bort
//
//====================================================================
//--------------------------------------------------------------------
// *** Mode 2 hook - Cataboligne MOD 9.10.3
// Fires hook & reels in to min then goes to mode 1
//--------------------------------------------------------------------

/*
********************************************************************

Cataboligne 9.11.3 - hook easy merge code

following notes detail quake-c v106 files that need modified to use this code:

********************************************************************


=============
hook code
=============

Cataboligne 9.11.3

(*) client
********************************************************************

*** place this code at the beginning of client.qc:

// Cataboligne 9.11.3 purify proto
void() hook_dmg_check;


*** place this code:

// Cataboligne 9.11.3 purify
	if (!(self.hook & HOOK_ON))
	{

*** after this code:
 
	W_WeaponFrame ();

// check to see if player landed and play landing sound

*** and:

// Cataboligne 9.11.3 purify
	}
	else
		{
//		hook_dmg_check(); make a server option
		self.finaldest = self.velocity;
		}

*** after this code:

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

*** in fn(PlayerPostThink) of client.qc:


====================================================================

(*) player
********************************************************************

*** replace this code:

		self.walkframe=0;
		player_run();
		return;

*** with:

// Cataboligne 9.11.3 purify
		if ( (self.hook & HOOK_IN) )
		{
			if ( (self.flags & FL_ONGROUND) )
			{
				self.walkframe=0;
				player_run();
				return;
			}
		}
		else
		{
			self.walkframe=0;
			player_run();
			return;
		}

*** in fn(player_stand1) of player.qc:

====================================================================

*** place this code:

// Cataboligne 9.11.3 purify
	if ( (self.hook & HOOK_IN) )
	{
		if (!(self.flags & FL_ONGROUND) )
		{
			self.walkframe=0;
			player_stand1();
			return;
		}
	}

*** after this code:

	self.weaponframe=0;

*** in fn(player_run) of player.qc:

====================================================================

(*) weapons
********************************************************************

*** place this code:

// Cataboligne 9.11.3 purify
	if (self.button2)
		CheckGrapHookJump ();


*** after this code:

void() W_WeaponFrame =
{

*** in fn(W_WeaponFrame) of weapons.qc:

====================================================================

*** place this code at the beginning of weapons.qc:

// Cataboligne 9.11.3 purify proto
void () hook_impulse_check;

*** place this code:

// Cataboligne 9.11.3 purify
hook_impulse_check();

*** after this code:

	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

*** in fn(ImpulseCommands) of weapons.qc:

====================================================================

(*) world
********************************************************************

*** place this code: --- handled by precache fn

// Cataboligne 9.11.3 purify
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	// Bort's swinging hook
	precache_model ("progs/hook.mdl");
//	precache_model ("progs/chain.mdl");

*** after this code:

	lightstyle(63, "a");

*** in fn(worldspawn) of world.qc:

====================================================================

*** and comment out:

	//teamplay = cvar("teamplay");
	//skill = cvar("skill");

*** in fn(StartFrame) of world.qc:

====================================================================


*** place this code at the beginning of world.qc: --- handled by precache fn

// Cataboligne 9.11.3 purify proto
void () hook_sounds;

*** place this code:

// Cataboligne 9.11.3 purify
	hook_sounds();

*** after this code:
 
// player precaches
	W_Precache ();			// get weapon precaches

*** in fn(worldspawn) of world.qc:

====================================================================

r(*) defs
********************************************************************

*** place this code: --- handled by hook.defs.qc

// Cataboligne 9.11.3 purify
// Bort's swinging hook
.float hook;

*** at the end of defs.qc

====================================================================

*/

/*
Rob;
<hook>.ammo_shells: grading raise/lower
<hook>.ammo_nails:  damageable entity flag
*/

// TEST_VER = testing, all morphs can use hook
// CHAOS_VER = final version, limited hook

float CHAOS_VER =	1;
float TEST_VER =	2;
float hook_ver = 2;

float CHAIN_FRAME_ADJ = 15; // adjust frame to new mdl

//--------------------------------------------------------------------
// Vector dot product function
//--------------------------------------------------------------------
float (vector from, vector onto) Dot =
{
	return from_x * onto_x + from_y * onto_y + from_z * onto_z;
};


//--------------------------------------------------------------------
// Removes hook and detaches player
//--------------------------------------------------------------------
void () DropHook =
{
	local entity linkptr, nextptr;

	// remove all hook flags
	self.owner.hook = 0;
/*
	if (hook_ver == CHAOS_VER)
	{
		if (self.owner.morphnum == IMP_MCTHON) sound (self.owner, CHAN_AUTO, "boss1/throw.wav", 1, ATTN_NORM);
		else if (self.owner.morphnum == IMP_MZOMBIE) sound (self.owner, CHAN_AUTO, "zombie/z_shot1.wav", 1, ATTN_NORM);
//		else if (self.owner.morphnum == IMP_MCHAOS) newlink.skin = floor(random() * 3.4); // randomize here
		else
			sound (self.owner, CHAN_AUTO, "hook/retract.wav", 1, ATTN_NORM);
	}
	else
*/
	if (!LTN_HOOK)
	if (!LASER_HOOK)
	sound (self.owner, CHAN_AUTO, "hook/retract.wav", 1, ATTN_NORM);

	// removes hook and chain
	linkptr = self.goalentity;
	while (linkptr != world)
	{
		nextptr = linkptr.goalentity;
		remove (linkptr);
		linkptr = nextptr;
	}
	remove( self );

};

// think to set laser hook beam len (and lightning hook)

void() hook_laser_thk =
{
	local float chainlen;
	local vector chainvec;

	if (!self.owner.hook)
	{
		remove(self);
		return;
	}
	
	chainvec = (self.aiment.origin - (self.owner.origin + '0 0 16')); // player to hook
	chainlen = vlen(chainvec);
	chainvec = normalize(chainvec);

	self.angles = vectoangles(chainvec);

	// fixes vectoangles round off error
	if ((self.angles_y > 0) && (self.angles_y < 180))
		self.angles = self.angles + '0 1 0';

	setorigin (self, (self.owner.origin + '0 0 16'));

	chainlen = floor(chainlen / 32);
	if (chainlen > 63) chainlen = 63;
	self.frame = chainlen;

	self.nextthink = time + 0.05;	
};

//--------------------------------------------------------------------
// Spawn and removes and refreshes chain links
//--------------------------------------------------------------------
void () MaintainLinks =
{
	local vector chainvec,		// vector of the chain
					 p_self_origin,	// predicted future hook origin
					 chainunit; 	// vector of chain with distance of 1
	local entity newlink,		// pointer to chain link being added
					 currlink,		// pointer to current link being traversed
					 nextlink;		// pointer to next link after current link
	local float chainlen,		// length of chain
					currpos,		// numeric position of currlink
					linknum,		// number of links that should exist
					linkstart;		// length from hook at which currlink starts

	// predicts hook's future position since chain links fall behind
	currpos = vlen(self.velocity) / 22;   // currpos used here just as an intermediate value
	p_self_origin = self.origin + normalize(self.velocity) * currpos;

		// get info about chain

	// Rob; put 8 units back for appearances in cam view
	if ( (self.dest2_x & CHSCAM_ON) )
	{
		makevectors( self.owner.v_angle );
		chainvec = (((self.owner.origin + '0 0 16') - v_forward * 8) - p_self_origin);
	}
	else
		chainvec = ((self.owner.origin + '0 0 16') - p_self_origin);

	chainunit = normalize(chainvec);
	chainvec = chainvec - chainunit * 18;
	chainlen = vlen(chainvec);

	currlink = self;
	currpos = 0;

	// generate and refresh links
	linknum = ceil(chainlen / CHAIN_LINK_LEN);
	while (currpos < linknum)
	{
		// add entities if chain's length grows
		if (currlink.goalentity == world)
		{
			newlink = spawn(); //
			newlink.movetype = MOVETYPE_NOCLIP;
			newlink.solid = SOLID_NOT;
			setmodel (newlink, "progs/spike.mdl");
			setsize (newlink, '0 0 0', '0 0 0');
			newlink.goalentity = world;
			currlink.goalentity = newlink;
/*
			if (hook_ver == CHAOS_VER)
			{
				if (self.owner.morphnum == IMP_MCTHON) newlink.skin = 1;
				else if (self.owner.morphnum == IMP_MZOMBIE) newlink.skin = 2; // IDEA: diff mdl added to spike looks like bones & ligaments
				else if (self.owner.morphnum == IMP_MCHAOS) newlink.skin = floor(random() * 3.4);
			}
*/
//			if (LASER_HOOK) newlink.skin = 1; // NOTE: used by laser hook - old, uses beam now
			if (LASER_HOOK || LTN_HOOK)
			{
				newlink.classname = "laser_hook_beam";
				setmodel (newlink, "progs/lzrbm_seg.mdl");
				newlink.owner = self.owner;
				newlink.aiment = self;

				newlink.angles = vectoangles(chainvec);

				// fixes vectoangles round off error
				if ((newlink.angles_y > 0) && (newlink.angles_y < 180))
					newlink.angles = newlink.angles + '0 1 0';
//				linkstart = (currpos - 1) * CHAIN_LINK_LEN;
//				setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
				setorigin (newlink, chainvec);

				chainlen = vlen(chainvec);
				chainlen = floor(chainlen / 32);
				if (chainlen > 63) chainlen = 63;
				newlink.frame = chainlen;

				newlink.think = hook_laser_thk;
				newlink.nextthink = time + 0.05;
				return;
			}
		}
		else
		if (LASER_HOOK) return;

		currlink = currlink.goalentity;
		currpos = currpos + 1;

		// set angles
		currlink.angles = vectoangles(chainvec);

		// fixes vectoangles round off error
		if ((currlink.angles_y > 0) && (currlink.angles_y < 180))
			currlink.angles = currlink.angles + '0 1 0';

		if (LASER_HOOK)
		{
			currlink.classname = "laser_hook_beam";
			setmodel (currlink, "progs/lzrbm_seg.mdl");
			linkstart = (currpos - 1) * CHAIN_LINK_LEN;
			setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
			chainlen = vlen(p_self_origin - chainvec);
			chainlen = ceil(chainlen / 32) - 2;
			if (chainlen < 0) chainlen  = 0;
			if (chainlen > 63) chainlen = 63;
			currlink.frame = chainlen;
			return;
		}
		else
		{
			// vibrates chain links on the z axis
			currlink.angles_z = currlink.angles_z + crandom() * 30;

			// set position and frames
			linkstart = (currpos - 1) * CHAIN_LINK_LEN;
			if (currpos < linknum)
			{
				setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
				currlink.frame = 9 + CHAIN_FRAME_ADJ;
			}
			else
			{
				setorigin (currlink, p_self_origin + chainunit * (linkstart + (chainlen - linkstart) / 2 ));
				currlink.frame = floor((chainlen - linkstart) / CHAIN_LINK_LEN * 10) + CHAIN_FRAME_ADJ;
			}
		}
	}

	// remove remaining entities if chain's length shrinks
	nextlink = currlink.goalentity;
	currlink.goalentity = world;
	currlink = nextlink;
	while (currlink != world)
	{
		nextlink = currlink.goalentity;
		remove (currlink);
		currlink = nextlink;
	}
};


//--------------------------------------------------------------------
// Hook behavior function
//--------------------------------------------------------------------
void () HookBehavior =
{
	local vector spray;		// for blood
	local vector chainvec;		// chain vector
	local vector velpart;		// player's velocity component moving to or away from hook
	local float chainlen;		// length of extended chain
	//local float framestep;		// grow or shrink step per frame
	local float f1, f2;		// restrainment forces
	local float i1, i2;		// intermediate values

	local float gs; // Rob

	self.nextthink = time + 0.01;

	// decide when to disconnect hook
	if (  !(self.owner.hook & HOOK_ON) ||	// if hook has been retracted
			self.owner.teleport_time > time || 	// if player goes through teleport
			self.owner.solid == SOLID_NOT	||	// if player dies
			self.enemy.solid == SOLID_NOT	)	// if target dies
	{
		DropHook();
		return;
	}

	// give some damage to entities that take damage
	if (self.enemy.takedamage)
	if (HOOK_DMG)
	if (time > self.wait)
	{
			T_Damage (self.enemy, self, self.owner, HOOK_DMG);

			// when hook hits live entity add blood and sounds
			if (self.enemy.solid == SOLID_SLIDEBOX)
			{
				// .ammo_nails flag used only here
				if (! self.ammo_nails)
				{
					sound (self, CHAN_AUTO, "shambler/smack.wav", 1, ATTN_NORM);
					self.ammo_nails = TRUE;
				}
				else
					sound (self, CHAN_AUTO, "blob/land1.wav", 0.8, ATTN_NORM);
				spray_x = 100 * crandom();
				spray_y = 100 * crandom();
				spray_z = 100 * crandom() + 50;
				SpawnBlood (self.origin, spray, 20);
				setorigin (self, self.enemy.origin + self.enemy.mins + self.enemy.size * 0.5);
			}

			self.wait = time + 0.3;
	}

	self.velocity = self.enemy.velocity;

	chainvec = self.origin - (self.owner.origin + '0 0 16');
	chainlen = vlen (chainvec);

// .ammo_shells = +- amount to size
	gs = self.ammo_shells;
	////////////////////////////////////////////////
	if ( (self.owner.hook & GROW_ON) )	
	{  gs = gs + 2;
		if (gs > GROW_RATE) gs = GROW_RATE;
	}
//	else if ( (self.owner.hook & SHRINK_ON) ) 
	else if ( (self.owner.hook & SHRINK_ON) || (self.owner.hook & MODE2)) // Cataboligne MOD 9.10.3
	{	gs = gs - 4;
		if (gs < SHRINK_RATE) gs = SHRINK_RATE;
	}
	else
	{
		if (gs > 0)
		{	gs = gs - 2; // fade from grow
			if (gs < 0) gs = 0;
		}
		if (gs < 0)
		{	gs = gs + 4; // fade from shrink
			if (gs > 0) gs = 0;
		}
	}
	self.armorvalue = self.armorvalue + gs;

	if (gs > 0)
	{
		if ( (self.owner.flags & FL_ONGROUND) )
			self.armorvalue = chainlen;
		else
		{
			if (self.delay < time)
			{
				f1 = gs / GROW_RATE;
				if (!LASER_HOOK)
				if (hook_ver == CHAOS_VER)
				{
/*
					if (self.owner.morphnum == IMP_MCTHON) sound (self.owner, CHAN_AUTO, "boss1/throw.wav", 1, ATTN_NORM);
					else if (self.owner.morphnum == IMP_MZOMBIE) sound (self.owner, CHAN_AUTO, "zombie/z_fall.wav", 1, ATTN_NORM);
//		else if (self.owner.morphnum == IMP_MCHAOS) newlink.skin = floor(random() * 3.4); // randomize here
				else
*/
					sound (self.owner, CHAN_AUTO, "hook/chain1.wav", f1, ATTN_NORM);
				}
				else
					sound (self.owner, CHAN_AUTO, "hook/chain1.wav", f1, ATTN_NORM);
				self.delay = time + 0.2;
			}
		}
		if ( self.armorvalue > MAX_CHAIN_LEN )
			self.armorvalue = MAX_CHAIN_LEN;
	}
	if (gs < 0)
	{
		// fixes not raising when directly under the hook
		if ( (self.owner.flags & FL_ONGROUND) )
			self.owner.flags = self.owner.flags - FL_ONGROUND;

		if (self.armorvalue < MIN_CHAIN_LEN) {
			self.armorvalue = MIN_CHAIN_LEN;
			self.owner.hook = self.owner.hook - (self.owner.hook & MODE2); // Cataboligne MOD 9.10.3
			}
		else
		{
			if (self.delay < time)
			{
				i1 = fabs(gs);
				i2 = fabs(SHRINK_RATE);
				f1 = i1 / i2;
				if (!LASER_HOOK)
				if (hook_ver == CHAOS_VER)
				{
/*
					if (self.owner.morphnum == IMP_MCTHON) sound (self.owner, CHAN_AUTO, "boss1/throw.wav", 1, ATTN_NORM);
					else if (self.owner.morphnum == IMP_MZOMBIE) sound (self.owner, CHAN_AUTO, "zombie/z_fall.wav", 1, ATTN_NORM);
//		else if (self.owner.morphnum == IMP_MCHAOS) newlink.skin = floor(random() * 3.4); // randomize here
					else
*/
						sound (self.owner, CHAN_AUTO, "hook/chain2.wav", f1, ATTN_NORM);
				}
				else
					sound (self.owner, CHAN_AUTO, "hook/chain2.wav", f1, ATTN_NORM);
				self.delay = time + 0.2;
			}
		}
	}
	///////////////////////////////////////////////
	self.ammo_shells = gs;


// chain physics

	// if player's location is beyond the chain's reach
	if (chainlen > self.armorvalue)
	{
		// determine player's velocity component of chain vector
		i1 = Dot(self.owner.velocity,chainvec);
		i2 = Dot(chainvec,chainvec);
		velpart = chainvec * (i1 / i2);

		// restrainment default force
		f2 = (chainlen - self.armorvalue) * 5;

		// if player's velocity heading is away from the hook
		if (Dot(self.owner.velocity,chainvec) < 0)
		{
			if (chainlen > self.armorvalue)
			{
				self.owner.velocity = self.owner.velocity - (velpart * 0.4);
			}
			// if chain has streched for 25 units
			if (chainlen > self.armorvalue + 25)
				// remove player's velocity component moving away from hook
				self.owner.velocity = self.owner.velocity - velpart;
			f1 = f2;
		}
		else  // if player's velocity heading is towards the hook
		{
			if (vlen(velpart) < f2)
				f1 = f2 - vlen(velpart);
			else
				f1 = 0;
		}
	}
	else
		f1 = 0;

	// applys chain restrainment
	self.owner.velocity = self.owner.velocity + normalize(chainvec) * f1;

	MaintainLinks ();
};


//--------------------------------------------------------------------
// Hook's touch function
//--------------------------------------------------------------------
void() HookTouch =
{
//	if (pointcontents(self.origin) == CONTENT_SKY) {	DropHook();	return;	}

	if (sky_touch("", v0, self))
	{
		DropHook();
		return;
	}
	
	// armorvalue is used to hold current length of chain
	self.armorvalue = vlen(self.origin - (self.owner.origin + '0 0 16'));

	// flags hook as being attached to something
	self.owner.hook = self.owner.hook | HOOK_IN;

	if (other.solid != SOLID_SLIDEBOX)
	{
/*
	if (hook_ver == CHAOS_VER)
	{
		if (self.owner.morphnum == IMP_MCTHON)
		{
			sound (self, CHAN_AUTO, "blob/hit1.wav", 1, ATTN_NORM);
		}
		else if (self.owner.morphnum == IMP_MZOMBIE)
		{
			sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
		}
		else if (self.owner.morphnum == IMP_MCHAOS)
		{
			sound (self, CHAN_AUTO, rnd_string(v0, "player/axhit2.wav","player/pain5.wav","player/teledth1.wav","enforcer/enfstop.wav","chaos/proxwarn.wav"), 1, ATTN_NORM);
		}
		else
			sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
	}
	else
*/
		if (LASER_HOOK)
			sound (self, CHAN_AUTO, "q2_snd/lhook_h.wav", 1, ATTN_NORM);
		else
		sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
		self.avelocity = '0 0 0';
	}

	self.velocity = other.velocity;

	self.enemy = other;
	self.think = HookBehavior;
	self.nextthink = time + 0.01;
	self.touch = SUB_Null;

};


//--------------------------------------------------------------------
// Limit hook length during launch
//--------------------------------------------------------------------
void() LaunchHook =
{
	// armorvalue is used to hold current length of chain
	self.armorvalue = vlen(self.origin - (self.owner.origin + '0 0 16'));

	if ( !(self.owner.hook & HOOK_ON) ||
			self.armorvalue > MAX_CHAIN_LEN	||
			self.owner.solid == SOLID_NOT	)
	{
		DropHook();
		return;
	}

	MaintainLinks ();
	self.nextthink = time + 0.01;
};


//--------------------------------------------------------------------
// Initiates the hook
//--------------------------------------------------------------------
void(entity e) InitiateHook =
{
	local entity newhook;
	local string hk;

	makevectors (e.v_angle);

	hk = "progs/hook.mdl";

	if (LASER_HOOK) hk = "progs/null.mdl";

/*
	if (hook_ver == CHAOS_VER)
	{
		if (e.morphnum == IMP_MCTHON)
		{
			hk = "progs/lavaball.mdl";
//			setmodel(newhook, "progs/lavaball.mdl");
//			sound (e, CHAN_AUTO, "blob/hit1.wav", 1, ATTN_NORM);
		}
		else if (e.morphnum == IMP_MZOMBIE)
		{
			hk = "progs/gib_m.mdl";
//			sound (e, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
		}
		else if (e.morphnum == IMP_MCHAOS)
		{
			hk = rnd_string(v0, "progs/v_spike.mdl","progs/hook.mdl","progs/lavaball.mdl","progs/ejbatt.mdl",rnd_string(v0, "progs/k_spike.mdl","progs/g_bomb.mdl","progs/proxbomb.mdl","progs/missile.mdl","progs/grenade.mdl"));
//			sound (e, CHAN_AUTO, "weapons/ax1.wav", 1, ATTN_NORM);
		}
	}
*/

	newhook = chaos_spawn(MOVETYPE_FLY, SOLID_BBOX, 0, 0, e.origin + (v_forward*16) + '0 0 16', ' 0 0 0', ' 0 0 0', vectoangles(v_forward), v_forward*2000, "", hk, HookTouch, 0.01, LaunchHook, SUB_Null, e, world);

	newhook.avelocity = '0 0 500';
	if (LASER_HOOK)
		sound (e, CHAN_AUTO, "q2_snd/lhook_l.wav", 1, ATTN_NORM);
	else
	sound (e, CHAN_AUTO, "weapons/ax1.wav", 1, ATTN_NORM);

	// used as pointer to first chain link
	newhook.goalentity = world;

	// Rob; (reminders 0 init values used)
	// self.wait = 0;  // damage to ents wait cycle
	// self.ammo_shells = 0; // graded shrink/grow variable
	// self.ammo_nails = FALSE;  // initial hit flag for live ents
	// self.delay = 0; // wait cycle for chain raising/lowering sounds

//	if (hook_ver == CHAOS_VER)
//	if (e.morphnum == IMP_MCTHON)
//		newhook.frame = 1;
};


// called by player jump events (weapons.qc: W_WeaponFrame() )
void() CheckGrapHookJump =
{
	if ( (self.hook & HOOK_IN) )
	{
		if ( (self.flags & FL_JUMPRELEASED) &&	// previous jump cycle has finished
			 !(self.flags & FL_ONGROUND) )		// player not on ground
		{
			self.hook = 0; // let hook entity's next think know it's dead
			self.velocity_z = self.velocity_z + 200;
//			sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM); umm sounds dumb?  mebbe FIX?
		}
	}
};

//--------------------------------------------------------------------
// Checks impulse
//--------------------------------------------------------------------
void() CheckGrapHook =
{
	local float cb_msk;
//	cb_msk = CB_CHAOS | CB_GREMLIN | CB_CTHON | CB_SCOURGE | CB_ZOMBY;

/*
	if (hook_ver == CHAOS_VER)
	{
//		if (!self.mask_x & cb_msk) return; // validate hook users
		if (self.model == "progs/cthon.mdl") return; // dont want hook in cthon form
		MAX_CHAIN_LEN = 256; // for escaping liquids & such
	}
	else if (hook_ver == TEST_VER)
		MAX_CHAIN_LEN = 2000; // done in update
	else
		return; // no version disables hook
*/

	if ((!(self.hook & HOOK_ON)) && (self.impulse == I_HOOK))
		{
		// flags hook as being active
		self.hook = HOOK_ON;

		InitiateHook (self);
		return;
		}
	if ((!(self.hook & HOOK_ON)) && (self.impulse == I_HOOK2)) // Cataboligne MOD 9.10.3
		{
		// flags hook as being active
		self.hook = HOOK_ON | MODE2;

		InitiateHook (self);
		return;
		}

	if (self.hook & HOOK_ON)
	{
		// release hook
//		if (self.impulse == I_HOOK)
		if ((self.impulse == I_HOOK) || (self.impulse == I_HOOK2)) // Cataboligne MOD 9.10.3
		{
			self.hook = self.hook - (self.hook & HOOK_ON);
			return;
		}

		if (LASER_HOOK) return; // no reeling with this hook

		// deactivate chain growth or shrink
		if (self.impulse == I_STOP)
		{
			self.hook = self.hook - (self.hook & (GROW_ON | SHRINK_ON));
			return;
		}

		// activate chain growth
		if (self.impulse == I_GROW)
		{
			self.hook = self.hook | GROW_ON;
			self.hook = self.hook - (self.hook & SHRINK_ON);
			return;
		}

		// activate chain shrinking
		if (self.impulse == I_SHRINK)
		{
			self.hook = self.hook | SHRINK_ON;
			self.hook = self.hook - (self.hook & GROW_ON);
		}
	}
};

void () hook_precache =
{
//	precache_model ("progs/cross1.mdl" ); // lasertargeter
	// Bort's swinging hook
	precache_model ("progs/hook.mdl");

	precache_sound ("blob/land1.wav");
	precache_sound ("hook/chain1.wav");
	precache_sound ("hook/chain2.wav");
	precache_sound ("hook/retract.wav");

// laser hook
	precache_sound ("q2_snd/lhook_h.wav");
	precache_sound ("q2_snd/lhook_l.wav");
// lightning hook
	precache_sound ("q3_snd/lg_hit3.wav");
	precache_sound ("q3_snd/gauntrun.wav");
};

void () hook_impulse_check =
{
// ### Swinging hook mod ###

//	if (!self.holdent.flags & FL_HELD) // item_held() - cant hook while holding
//	if (self.firecontrol < FIRE_SPECIAL) //things that directly prevent hook operation
//	if (self.impulse >= 93 && self.impulse <= 98) // Cataboligne MOD 9.10.3 - already check in weapons
	CheckGrapHook ();

	self.impulse = 0;
};

void() hook_dmg_check =
{
	// Rob; added more involved impact check, checks for hard impacts in
	// any given direction, and adds 'skull-cracking' check to here and
	// client obituaries (mainly usefull for hook)
	local float i1, i2;
	if ( vlen(self.velocity - self.finaldest) > 650)
	{
		i1 = fabs(self.velocity_x);
		i1 = i1 + fabs(self.velocity_y);
		i1 = i1 + fabs(self.velocity_z);
		i2 = fabs(self.finaldest_x);
		i2 = i2 + fabs(self.finaldest_y);
		i2 = i2 + fabs(self.finaldest_z);

		// was negative (avoid wind-tunnel accelerations)
		if (i1 < i2)
		{
			// head impacts
			if (self.finaldest_z > 500 &&
				 self.velocity_z < 10)
			{
				T_Damage (self, world, world, 15);
//				if (self.morphnum == IS_HUMAN)
					sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
//				else
//					morph_sound (TRUE, self.noise2, 0.5);
				self.deathtype = "skullcrack";
			}
		}
	}
	else if (self.finaldest_z < -300)
	{
		// normal three-point landing
		if (self.velocity_z > -30)
//			if (self.morphnum == IS_HUMAN)
				sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
	}
};

// Aside from this new file, the following are the modifications
// done to id's original source files:
//--------------------------------------------------------------------
// File: Progs.src
// Location: before the "weapons.qc" line
// Added: hook.qc
//--------------------------------------------------------------------
// File: Client.qc
// Procedure: PlayerPostThink
// Location: before line "W_WeaponFrame ();"
// Added: CheckGrapHook ();
//--------------------------------------------------------------------
// File: World.qc
// Procedure: worldspawn
// Location: after line "precache_model ("progs/s_spike.mdl");"
// Added: precache_model ("progs/hook.mdl");
//        precache_model ("progs/chain.mdl");
//--------------------------------------------------------------------
// File: Weapons.qc
// Procedure: W_Precache
// Location: end of procedure
// Added: precache_sound ("shambler/smack.wav");
//        precache_sound ("blob/land1.wav");
//        precache_sound ("hook/chain1.wav");
//        precache_sound ("hook/chain2.wav");
//        precache_sound ("hook/retract.wav");
//--------------------------------------------------------------------
// File: Defs.qc
// Declaration group: player only fields
// Location: after line ".float pain_finished;"
// Added: .float hook;
