//====================================================================
//====================================================================
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

Cataboligne - 9.8.11 - adapted control cfg files -

exec hook_control.cfg = give mouse wheel control of reel in / out
exec hook_release.cfg = return mouse wheel to weap select up / down

if these are in the mod dir they will be run when starting / releasing the hook if it is a standard hook

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

float CHAIN_FRAME_ADJ = 18; // adjust frame to new mdl - 7.1.13 - did not match model, re-aligned

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

	if (!self.morphy) 
	if (self.lefty == SEL_S_HOOK )
		stuffcmd(self.owner, "exec hook_release.cfg\n");

	sound (self.owner, CHAN_AUTO, self.noise1, 1, ATTN_NORM);

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

// drop hook given a hooked ent, e

void (entity e) DropHook_ent =
{
	local entity linkptr, nextptr, f;

	f = find(world, classname, "hook_ball");
	while (f && (e != f.owner))
	{
		f = find(f, classname, "hook_ball");
	}

	if (!f) return;

	// remove all hook flags
	f.owner.hook = 0;

	if (!f.morphy) 
	if (f.lefty == SEL_S_HOOK )
		stuffcmd(f.owner, "exec hook_release.cfg\n");

	sound (f.owner, CHAN_AUTO, f.noise1, 1, ATTN_NORM);

	// removes hook and chain
	linkptr = f.goalentity;
	while (linkptr != world)
	{
		nextptr = linkptr.goalentity;
		remove (linkptr);
		linkptr = nextptr;
	}
	remove( f );
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

	if (self.super_time < time) // super time - to run a couple hook effects
	{
		self.super_time = time + 0.2;
		if (self.lefty == SEL_LTN_HOOK)
		{
			ominous_hum(self.noise2, self.endtime);
			seq_bolt((self.owner.origin + '0 0 16'), self.aiment.origin);
		}
	}

	if (self.lefty == SEL_LASER_HOOK) // laser repose
	{
		chainlen = floor(chainlen / 32);
		if (chainlen > 63) chainlen = 63;
		self.frame = chainlen;
	}

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
	if ( (self.cam_x & CHSCAM_ON) )
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
			newlink = spawn();
			newlink.movetype = MOVETYPE_NOCLIP;
			newlink.solid = SOLID_NOT;
			setmodel (newlink, "progs/spike.mdl");
			setsize (newlink, '0 0 0', '0 0 0');
			newlink.goalentity = world;
			currlink.goalentity = newlink;

			if (self.morphy == IMP_MCTHON) newlink.skin = 1;
			else if (self.morphy == IMP_MZOMBIE) newlink.skin = 2; // IDEA: diff mdl added to spike looks like bones & ligaments
			else if (self.morphy == IMP_MCHAOS) newlink.skin = floor(random() * 3.4);
			
			if (self.lefty != SEL_S_HOOK )
			{
				newlink.owner = self.owner;
				newlink.aiment = self; // note: aiment from link points at hook ent
				newlink.lefty = self.lefty;  // NOTE: does not detect standard hook in think fn above

				newlink.angles = vectoangles(chainvec);

				// fixes vectoangles round off error
				if ((newlink.angles_y > 0) && (newlink.angles_y < 180))
					newlink.angles = newlink.angles + '0 1 0';
//				linkstart = (currpos - 1) * CHAIN_LINK_LEN;
//				setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
				setorigin (newlink, chainvec);

				newlink.think = hook_laser_thk;
				newlink.nextthink = time + 0.05;

				if (self.lefty == SEL_LASER_HOOK)
				{
					newlink.classname = "laser_hook_beam";
					setmodel (newlink, "progs/lzrbm_seg.mdl");
					chainlen = vlen(chainvec);
					chainlen = floor(chainlen / 32);
					if (chainlen > 63) chainlen = 63;
					newlink.frame = chainlen;
				}
				else
				if (self.lefty == SEL_LTN_HOOK)
				{
					newlink.classname = "lightning_hook_beam";
					newlink.noise2 = self.targetname; // special
					newlink.model = "";
					sound (newlink, CHAN_AUTO, newlink.noise2, 1, ATTN_NORM);
					newlink.endtime = 1.99; 
					newlink.chaosweptime = time + newlink.endtime;
					newlink.super_time = time + 0.2;
					seq_bolt(self.owner.origin, p_self_origin);
				}
				else
					remove(newlink);

				return;
			}
		}
		else
		if (self.lefty != SEL_S_HOOK) return;

		currlink = currlink.goalentity;
		currpos = currpos + 1;

		// set angles
		currlink.angles = vectoangles(chainvec);

		// fixes vectoangles round off error
		if ((currlink.angles_y > 0) && (currlink.angles_y < 180))
			currlink.angles = currlink.angles + '0 1 0';

		// vibrates chain links on the z axis
		currlink.angles_z = currlink.angles_z + crandom() * 30;

		// set position and frames
		linkstart = (currpos - 1) * CHAIN_LINK_LEN;
		if (currpos < linknum)
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
			currlink.frame = 9 + CHAIN_FRAME_ADJ;
			if (self.model ==  "progs/v_spike.mdl") currlink.frame = 0;
		}
		else
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + (chainlen - linkstart) / 2 ));
			currlink.frame = floor((chainlen - linkstart) / CHAIN_LINK_LEN * 10) + CHAIN_FRAME_ADJ;
			if (self.model ==  "progs/v_spike.mdl") currlink.frame = 0;
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
	if (HOOK_DMG || self.dmg)
	if (self.lefty == SEL_S_HOOK)
	if (!self.morphy)
	if (time > self.wait)
	{
		if (HOOK_DMG)
			T_Damage (self.enemy, self, self.owner, HOOK_DMG);
		else
			T_Damage (self.enemy, self, self.owner, self.dmg);

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
	{
		gs = gs + 2;
		if (gs > GROW_RATE) gs = GROW_RATE;
		if (self.movetarget)
		{
			self.movetarget.nextthink = time + HOOK_TIME;
			self.movetarget.classname ="";
		}
	}
//	else if ( (self.owner.hook & SHRINK_ON) ) 
	else if ( (self.owner.hook & SHRINK_ON) || (self.owner.hook & MODE2)) // Cataboligne MOD 9.10.3
	{
		gs = gs - 4;
		if (gs < SHRINK_RATE) gs = SHRINK_RATE;
		if (self.movetarget)
		{
			self.movetarget.nextthink = time + HOOK_TIME;
			self.movetarget.classname ="";
		}
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
				sound (self.owner, CHAN_AUTO, self.target1, f1, ATTN_NORM);

				self.delay = time + 0.2;
			}
		}
		if ( self.armorvalue > self.armortype )
			self.armorvalue = self.armortype;
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

				sound (self.owner, CHAN_AUTO, self.target2, f1, ATTN_NORM);

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

	f1 = HOOK_SPEED;
	if (self.speed) f1 = self.speed;
	if (self.owner.rune_flag & RUNE_FLG_HS) f1 = f1 * 2;
// enforce the speed limit - the greatest grievance against the hook since its inception
	if (f1 > 100)
	while (vlen(self.owner.velocity) > (f1 + 1))
		self.owner.velocity = self.owner.velocity * 0.98;



	if (self.super_time < time) // super time - to run a couple hook effects
	{
		f1 = 0;
		self.super_time = time + 0.2;
		if (HOOK_DAMP > 0) f1 = HOOK_DAMPING;
		else if (self.bulletspread_x) f1 = self.bulletspread_x;

		if (f1 > 0)
		if (chainlen < 160)
			self.owner.velocity = self.owner.velocity * f1; // damping for wild swings borts hook tends to do - which these hooks dont really do			
	}

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
		sound (self, CHAN_AUTO, self.target, 1, ATTN_NORM);

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
			self.armorvalue > self.armortype	||
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


// implement hook timeouts

void() hook_timeout =
{
	if ( !(self.owner.hook & HOOK_ON) ||
			self.owner.solid == SOLID_NOT	)
	{
		remove(self);
	}
	else if (self.classname == "hook_no_urto") // no urto, but there is a hook timeout
	{
		self.nextthink = time + HOOK_TIME;
	}
	else
	{
		self = self.enemy;
		DropHook();
		remove(self.movetarget); // rid of timeout self
	}
};

// e - entity launching hook

void(entity e) InitiateHook =
{
	local entity newhook;
	local string hk;

	makevectors (e.v_angle);

	hk = "progs/v_spike.mdl";

	newhook = chaos_spawn(MOVETYPE_FLY, SOLID_BBOX, 0, 0, e.origin + (v_forward*16) + '0 0 16', ' 0 0 0', ' 0 0 0', vectoangles(v_forward), v_forward*2000, "hook_ball", hk, HookTouch, 0.01, LaunchHook, SUB_Null, e, world);

	newhook.armortype = MAX_CHAIN_LEN;
	newhook.morphy = 0;


// default sounds
	newhook.target = "player/axhit2.wav"; // hook hit a solid - not damaged
	newhook.noise1 = "hook/retract.wav"; // drop
	newhook.target1 = "hook/chain1.wav"; // out
	newhook.target2 = "hook/chain2.wav"; // in
	newhook.targetname = "weapons/ax1.wav"; // launch snd

	if (e.mask_x & MORPH_HOOK)
	{
		newhook.lefty = SEL_S_HOOK;
		newhook.morphy = e.morphy;
		newhook.armortype = MORPH_CHAIN_LEN; // built in hook is for escape - shorter length
		if (e.morphy == IMP_MCTHON)
		{
			setmodel(newhook, "progs/lavaball.mdl");
			newhook.target = "blob/hit1.wav";
			newhook.targetname = 
			newhook.noise1 = "boss1/throw.wav";
			newhook.target1 = "boss1/throw.wav";
			newhook.target2 = "boss1/throw.wav";
			newhook.frame = 1;
		}
		else if (e.morphy == IMP_MZOMBIE)
		{
			setmodel(newhook, "progs/gib_m.mdl");
			newhook.target = "zombie/z_hit.wav";
			newhook.noise1 = "zombie/z_shot1.wav";
			newhook.targetname = 
			newhook.target1 = "zombie/z_fall.wav";
			newhook.target2 = "zombie/z_fall.wav";
		}
		else if (e.morphy == IMP_MCHAOS)
		{
			hk = rnd_string(v0, "progs/v_spike.mdl","progs/hook.mdl","progs/lavaball.mdl","progs/cubel.mdl",rnd_string(v0, "progs/k_spike.mdl","progs/g_bomb.mdl","progs/proxbomb.mdl","progs/missile.mdl","progs/grenade.mdl"));
			setmodel(newhook, hk);
			newhook.target = "weapons/ax1.wav";
//			newhook.target1 = "hook/chain1.wav"; // IDEA: randomize
//			newhook.target2 = "hook/chain2.wav";
		}
		e.hook = e.hook | MODE2;// Cataboligne - 9.18.11 - morph hook only do one shot, no I_HOOK op
	}


	if (e.eweapon)
	if (e.eweapon.netname == "Grappling hook")
	{
		newhook.eweapon = e.eweapon;
		newhook.lefty = e.eweapon.lefty;
//		newhook.mdl = e.eweapon.killtarget;
		setmodel(newhook, e.eweapon.killtarget);
		newhook.frame = e.eweapon.dmg_save; // frame in mdl for hook
		newhook.dmg = e.eweapon.dmg;
		newhook.noise1 = e.eweapon.noise1; // these override - so they must always be set for eweap
//		newhook.noise3 = e.eweapon.noise3; // continous run sound - ltn hook
		newhook.target = e.eweapon.target;
		newhook.target1 = e.eweapon.target1;
		newhook.target2 = e.eweapon.target2;
		newhook.targetname = e.eweapon.targetname;
		newhook.bulletspread = e.eweapon.bulletspread;
	}

	if (!newhook.lefty) // give away hook behavior
	{
		if (LASER_HOOK) newhook.lefty = SEL_LASER_HOOK;
		else if (LTN_HOOK) newhook.lefty = SEL_LTN_HOOK;
		else newhook.lefty = SEL_S_HOOK;

		if (newhook.lefty == SEL_LASER_HOOK)
		{
			setmodel(newhook, "progs/null.mdl");
			newhook.target = "q2_snd/lhook_h.wav"; // hook hit a solid - not damaged
			newhook.noise1 = ""; // drop
			newhook.target1 = ""; // in + out
			newhook.target2 = ""; // in + out
			newhook.targetname = "q2_snd/lhook_l.wav"; // launch snd			
			newhook.bulletspread_x = 0.5;
			newhook.speed = 650;
			e.hook = e.hook | MODE2;// Cataboligne - 9.8.11 - give away laser & ltn only do one shot, no I_HOOK op
		}
		if (newhook.lefty == SEL_LTN_HOOK)
		{
			setmodel(newhook, "progs/null.mdl");
			newhook.target = "q3_snd/lg_hit3.wav"; // hook hit a solid - not damaged
			newhook.noise1 = ""; // drop
			newhook.target1 = ""; // in + out
			newhook.target2 = ""; // in + out
			newhook.targetname = "q3_snd/gauntrun.wav"; // launch snd
			newhook.noise3 = "q3_snd/gauntrun.wav"; // continous run sound - ltn hook
			newhook.bulletspread_x = 0.5;
			e.hook = e.hook | MODE2;// Cataboligne - 9.8.11 - give away laser & ltn only do one shot, no I_HOOK op
		}
//		if (newhook.lefty == SEL_S_HOOK)
	}

	if (newhook.model != "progs/null.mdl") setsize(newhook, '0 0 0', '0 0 0'); // setsize (newhook,'-4 -4 -4','4 4 4');

	newhook.avelocity = '0 0 500';

	sound (e, CHAN_AUTO, newhook.targetname, 1, ATTN_NORM);

	// used as pointer to first chain link
	newhook.goalentity = world;

	// Rob; (reminders 0 init values used)
	// self.wait = 0;  // damage to ents wait cycle
	// self.ammo_shells = 0; // graded shrink/grow variable
	// self.ammo_nails = FALSE;  // initial hit flag for live ents
	// self.delay = 0; // wait cycle for chain raising/lowering sounds

	if (!newhook.morphy) 
	if (newhook.lefty == SEL_S_HOOK )
		stuffcmd(e, "exec hook_control.cfg\n");

// setup hook timeout
	local float f;
	local string md;
	
	if (e.impulse == I_HOOK) // mode one, fire & wait
	{
		f = HOOK_URTO;
		if (f <= 0 && HOOK_TIME > 0)
		{
			md = "hook_no_urto";
			f = HOOK_TIME; // no urto, but there is a std timeout - set up ent
		}
	}
//	if (e.impulse == I_HOOK2) 
	else f = HOOK_TIME;

	newhook.movetarget = world;
	if (f > 0)
	{
		newhook.movetarget = chaos_spawn(0, 0, 0, 0,  v0, v0, v0, v0, v0, md, "", SUB_Null, f, hook_timeout, SUB_Null, e, world);
		newhook.movetarget.enemy = newhook;
	}
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
	local float ts;

	if (self.model == "progs/cthon.mdl") return; // dont want hook in cthon form

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
		
		if (self.eweapon)
		{
			if (self.eweapon.vwepmdl == "progs/vw_q3_grap.mdl") // cant "reel" q3 hook
				return;

			if (self.eweapon.netname == "Grappling hook") ts = TRUE; // no test if item hook
		}

		if (!ts)
		if (LASER_HOOK || LTN_HOOK) return; // no reeling with these hook
		if (self.mask_x & MORPH_HOOK) return; // morph cant reel either

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
	precache_model ("progs/g_grap.mdl");
	precache_model ("progs/v_grap.mdl");
	precache_model ("progs/vw_grap.mdl");

	precache_sound ("hook/chain1.wav"); // in - out
	precache_sound ("hook/chain2.wav"); // in - out
	precache_sound ("hook/retract.wav"); // drop hook

	precache_sound ("player/axhit2.wav"); // end hit solid
	precache_sound ("weapons/ax1.wav"); // launch sound

	precache_sound ("shambler/smack.wav"); // initial damage hit
	precache_sound ("blob/land1.wav"); // secondary dmg noise
};

// self must be player / bot

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
			if (random() < 0.2) // this happens way too often IDEA: server var?
			if (self.finaldest_z > 500 &&
				 self.velocity_z < 10)
			{
				T_Damage (self, world, world, 10);
				if (self.mask_x & CB_HUMAN)
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
			if (self.mask_x & CB_HUMAN)
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
