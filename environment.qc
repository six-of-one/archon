/* ::-::
 *
 * Cataboligne
 *
 * file: environment.qc
 *
 * date: 9/16/11
 *
 * qc - support chaos mod environment
 *
 */


// TDO: remove - placeholder - might want the actual meltthink code from cmod

void() meltthink =
{
	SUB_Remove();
};

// NOTE: came from chaos_env.qc

// fn(move_stop) halt a moving entity, play looped sound ns

void (entity e, string ns) move_stop =
{
	e.velocity = '0 0 0';
	e.movetype = MOVETYPE_NONE; // fails blast_move - removing fails shell casings in lava
	if (ns != null_string) sound(e, CHAN_WEAPON, ns, 1, ATTN_NORM);
};


// relocation code - called by ip_checkForMovement & from splash.qc

// could move anything, effect should prob be client sided

void() fade_relocate =
{
	if (!self.alpha) self.alpha = 1.03; // make sure the fade doesnt hit 0 and fire this again

	self.think = fade_relocate;
	self.nextthink = time + 0.1;

	if (self.alpha < 0.6) self.touch = SUB_Null;
	else self.touch = painkeep_touch;

	self.alpha = self.alpha + self.lip;

	if (self.lip < 0)
	if (self.alpha < 0.05)
	{
		self.lip = 0.05;
		setorigin(self, self.ip_orgOrigin);
		item_eject(self, MED_BOUNCE);		
	}

	if (self.lip > 0)
	if (self.alpha > 1)
	{
		self.alpha = 1.03;
		self.lip = 0;
		self.revotemsg = 0;
		if (self.event == "dynamic_item")
			self.ip_orgOrigin = v0; // clear for out of bounds ***
		self.think = self.th_stand; // done - back to the usual
		self.th_stand = SUB_Null;
		self.nextthink = self.lefty;
	}
};

// fade relocate anything

void(entity e) set_relocate =
{
	if (!e) e = self;
	e.enemy = dyn_rndloc();
	if (!e.enemy) e.enemy = findradius(world.origin, 256000); // if nothing, it wont move

	e.th_stand = e.think;
	e.lefty = e.nextthink;
	e.think = fade_relocate;
	e.nextthink = time + 0.1;
	e.lip = -0.05;
	e.ip_orgOrigin = e.origin; // if no location found it will bounce here
	if (e.enemy) e.ip_orgOrigin = e.enemy.origin + '0 0 4'; // something found - move item / rune here
	e.enemy = world;

#ifdef warning
						if (WARNING & 2)
						{
							bprint("*** warning: fade relocate - ");
							bprint(item_ident(e));
							bprint ("\n");
						}
#endifdef

};



// fn(sv_decor) - test decor for server control

// e - ent to test
// returns:
//		1 - ent deleted, no further action
//		0 - ent not deleted, process init

float (entity e) sv_decor =
{
	local float f;

	f = 0;
	if (!NODECOR) return(0);
	else if (NODECOR == 3) f = 1;
	else if (NODECOR == 2 && deathmatch) f = 1;
	else if (NODECOR == 1 && deathmatch && e.solid == SOLID_BSP) f = 1;

	if (f == 1) remove(e);
	return(f);
};




// ENV
// use wrappers for engines these break (like fte)

// surface stuff

float(entity e, float s) getsurfacenumpoints =
{
	if (DARKPLACES) // || chaos
		return(getsurfacenumpoints_wrap(e, s));

	return(0);// Cataboligne - 8.7.13 - compiler warning
};
vector(entity e, float s, float n) getsurfacepoint =
{
	if (DARKPLACES)
		return(getsurfacepoint_wrap(e, s, n));

	return(v0);// Cataboligne - 8.7.13 - compiler warning
};
vector(entity e, float s) getsurfacenormal =
{
	if (DARKPLACES)
		return(getsurfacenormal_wrap(e, s));

	return(v0);// Cataboligne - 8.7.13 - compiler warning
};
string(entity e, float s) getsurfacetexture =
{
	if (DARKPLACES)
		return(getsurfacetexture_wrap(e, s));

	return(null_string);// Cataboligne - 8.7.13 - compiler warning
};
float(entity e, vector p) getsurfacenearpoint =
{
	if (DARKPLACES)
		return(getsurfacenearpoint_wrap(e, p));

	return(0);// Cataboligne - 8.7.13 - compiler warning
};
vector(entity e, float s, vector p) getsurfaceclippedpoint =
{
	if (DARKPLACES)
		return(getsurfaceclippedpoint_wrap(e, s, p));

	return(v0);// Cataboligne - 8.7.13 - compiler warning
};



/*QUAKED func_fallingwater (0 .5 .8) ?
now just a fancy door

moving water illusion - only vertical for now
appx moving liquid from q2
Toggle - if targetname set, wait at each end for trigger
normal - cycle is to move distance then move back in speed time each way

"speed" is how long in rels it to complete move
"height" is dist to move - if 0 size_z of model is used (+ lip)
"lip" added to move distance (height)
"cnt" - units to move in one time segment - default 1, -1 reverses dir (down)
"ltime" - time segment to move cnt - calculated from speed & dist if not set
"delay" - time before triggered move takes place
"wait" - if not toggled time till return starts, -1 stops, default 1
"target" - if set gets fired at end of travel
"killtarget" - hurt trigger will be moved with fallingwater model
*/

/*
void() fallingwater_fire;

void() fallingwater_think =
{
	if (self.state == self.count)
	{
		SUB_UseTargets (); // anything we targeted

		if (self.wait < 0) return;
		if (self.use != fallingwater_fire)
		{
			self.nextthink = time + self.wait;
		}
		self.state = 0;
		self.cnt = 0 - self.cnt; // reverse dir
//		if (self.style >= 1)
//		{
//			self.style = self.style - 1;
//			self.nextthink = time  + self.delay + self.ltime; // fire again - got triggered while moving
//		}
		return;
	}
	v1 = v0;
	v1_z = self.cnt;
	setorigin(self, self.origin + v1);
//	if (self.killtarget != null_string) self.enemy = find (world, targetname, self.killtarget);
//	if (self.enemy) setorigin(self.enemy, self.origin); // move sibling hurt trigger - .enemy should be vetted
	self.state = self.state  + 1;
	self.nextthink = time + self.ltime;
};

void() fallingwater_fire =
{
	if (self.state) // dont fire when moving
	{
//		if (self.style < 1) self.style = 0;
//		self.style = self.style + 1; // we want to fire again when done
		return;
	}
	if (self.delay)
		self.nextthink = time + self.delay;
	else
 		fallingwater_think();
};
*/

void() func_door;

void() func_fallingwater =
{
	self.spawnflags = self.spawnflags - (self.spawnflags & 24); // strip key door codes
	
	func_door();
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.solid = SOLID_TRIGGER;

// deadflag & 2 makes this envcide & env damage ent
// this default saves setting all this on map ents
	if (self.deadflag & 2)
	{
		if (!self.dmg)
			self.dmg = 5;

		if (!self.frags)
			self.frags = 1;
	}

	if (!self.delay)
		self.delay = 1;

	if (self.dmg)
	{
		self.touch = hurt_touch;
		self.aflag = -666; // so hurt_touch handles this
	}

// custom message handle from hurt_switch
// setup msg - done in map ent
// this selects amongst the possible messages when first loading on map
	if (self.stack2 != null_string && self.stack3 != null_string)
	{
		if (self.button1 <= 0) self.button1 = 0.5;
		if (self.button2 <= 0) self.button2 = 0.1;
		if (random() < self.button1)
			self.stack16 = self.stack2; //" turned into hot slag";
		else
			self.stack16 = self.stack3; // " visits the Volcano God";
		if (self.stack4 != null_string)
		if (random() < self.button2)
			self.stack16 = self.stack4; // " is playing geologist again";
	}
	else
	if (self.stack16 == null_string && self.stack2 != null_string || self.stack3 != null_string)
	{
		if (self.stack2 != null_string) self.stack16 = self.stack2;
		if (self.stack3 != null_string) self.stack16 = self.stack3;
	}
	if (self.stack16 != null_string)
		self.class_select = "CDM"; // custom death msg

/*
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self,self.model);
	self.think = fallingwater_think;
	self.nextthink = -1;

	if (self.targetname != null_string)
		self.use = fallingwater_fire;

	if ( !self.height ) self.height = self.size_z;
	self.height = fabs(self.height);
	self.distance = fabs(self.height + self.lip); // actual move dist
	self.speed = fabs(self.speed);
	if ( !self.cnt ) self.cnt = 1;
	if (self.wait < 1) self.wait = 1;
	self.style = self.state = 0; // state - track actual move units
	self.count = floor(self.distance / fabs(self.cnt)); // total movement units
	if (!self.ltime)
	{
		self.ltime = self.speed / self.count; // time for each move
	}

	if (self.use != fallingwater_fire)
	{
		self.nextthink = time + 2 * random();
	}
*/
};




// fn(beam4) - special lightning beam - reverts to beam mdl 2 if special engine not present, doesnt do damage
// fn(multi_beam) - wrap beam shot in fresh self - can only fire 1 beam on a self per frame
// org - start vector, end - end vector
// fr - model frame =
//		0 - white / blue
//		1 - white / yellow
//		2 - white / purple / pink
//		3 - red / yellow
//		4 - black / blue / purple
//		5 - black
//		6 - lava tex
//		7 - chaos beam tube - pink / purple
//		8 - 2 spheres - multi gray - (smoke experiment)

void(vector org, vector end, float fr) beam4 =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2); //TE_LIGHTNING4);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, end_x);
	WriteCoord (MSG_BROADCAST, end_y);
	WriteCoord (MSG_BROADCAST, end_z);
//	if (chaos) WriteCoord (MSG_BROADCAST, fr); // IMP: color dp bolts?
};

void(vector org, vector end, float fr) multi_beam =
{
	local entity sv, s2;
//	local	vector cf;

	sv = self;

//	cf_x = E_ORG | E_OWNER | E_VELOCITY | E_SIZE | E_MOVETYPE | E_SOLID | E_FLAGS | E_morphy | E_ITEMS | E_FRAME | E_AANGLES;
//	s2 = ent_copy(cf, self, world);
	s2 = spawn();
	if (s2)
	{
		self = s2;

		beam4(org, end, fr);
		self = sv;
		remove(s2);
	}
	// else ERROR cond - no ent for beam
};



// make a bolt between 2 points, play sound at origin vec v1 if passed in snd

// "weapons/lstart.wav"

void(vector pv1, vector pv2, float typ, string snd) lightning_bolt =
{
	local entity e;
	local float te;

	e = spawn();
	e.think = SUB_Remove;
	e.nextthink = time + 0.5;
	te = typ;
	if (!te) te = TE_LIGHTNING2;
	
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, te);
	WriteEntity (MSG_BROADCAST, e);
	WriteCoord (MSG_BROADCAST, pv1_x);
	WriteCoord (MSG_BROADCAST, pv1_y);
	WriteCoord (MSG_BROADCAST, pv1_z);
	WriteCoord (MSG_BROADCAST, pv2_x);
	WriteCoord (MSG_BROADCAST, pv2_y);
	WriteCoord (MSG_BROADCAST, pv2_z);

	if (snd)
	{
		e.origin = pv1;
		sound (e, CHAN_WEAPON, snd, 1, ATTN_NORM);
//		e.orign = pv2;
//		sound (e, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	}
};

// fn(seq_bolt) - sequence a lightning bolt into the world,, no damage yet

// lorg1 - start
// lorg2 - end

void(vector lorg1, vector lorg2) seq_bolt =
{
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST,self);
	WriteCoord (MSG_BROADCAST,lorg1_x);
	WriteCoord (MSG_BROADCAST,lorg1_y);
	WriteCoord (MSG_BROADCAST,lorg1_z);
	WriteCoord (MSG_BROADCAST,lorg2_x);
	WriteCoord (MSG_BROADCAST,lorg2_y);
	WriteCoord (MSG_BROADCAST,lorg2_z);	
};




// fn(particle_burst) - throw off a burst of particles of a given color set
// org - burst origin
// ofs - offset around origin (gives - (ofs / 2) to + (ofs / 2)
// vp - vector pointer							\__ direction
// vr - vector randomizer					/
// dur - duration											particle duration / #
// amt - burst amount							\__ particle launch counter
// rmt - burst random amount			/
// cl* - color 1,2,n									\
// cr* - random incr to color 1,2,n	+- color control
// per - color percentage					/

// flg - flag controls
/*
float FL_RND			= 1; // pick a random color
float FL_COL1		= 2; // use this color
float FL_COL2		= 4;
float FL_COL3		= 8;
float FL_ALLCL			= 16; // fire particles of all colors
float FL_PERC		= 32; // percentage determins how much of each to throw if more than 1 used, usage always rand() < per_x < _y < _z
float FL_RNDUR	= 64; // randomize duration
*/

void(vector org, float ofs, vector vp, vector vr, float dur, float amt, float rmt, float flg, vector clm, vector crm, vector per) particle_burst =
{
	local float r1, r2, cl, dr;
	local vector of, pr;

	r2 = amt + rint(random() * rmt);
	while (r2 > 0) // particle burst, red & yellow
		{
		dr = dur;
		if (flg & FL_RNDUR) dr = dr + (random() * 10);
		of = pr = '0 0 0';

		pr_x = vp_x + (random() * vr_x) - (vr_x / 2.0); // dir + velo
		pr_y = vp_y + (random() * vr_y) - (vr_y / 2.0);
		pr_z = vp_z + (random() * vr_z) - (vr_z / 2.0);

		of_x = (random() * ofs) - (ofs / 2.0); // offset from origin
		of_y = (random() * ofs) - (ofs / 2.0);
		of_z = (random() * ofs) - (ofs / 2.0);

		r1 = random();
		cl = clm_x + random() * crm_x;
		if (flg & (FL_ALLCL | FL_COL1))
			{
			if (!(flg & FL_PERC) || (r1 < per_x))
				particle (org + of, pr, cl, dr);
			}
		cl = clm_y + random() * crm_y;
		if (flg & (FL_ALLCL | FL_COL2))
			{
			if (!(flg & FL_PERC) || (r1 < per_y))
				particle (org + of, pr, cl, dr);
			}
		cl = clm_z + random() * crm_z;
		if (flg & (FL_ALLCL | FL_COL3))
			{
			if (!(flg & FL_PERC) || (r1 < per_z))
				particle (org + of, pr, cl, dr);
			}

		r2 = r2 - 1;
		}

};


// fn(fire_burst) - fire off a burst of stuff

// fr - fire fn, will just shoot out if SUB_Null, not weaponized
// org - origin
// mvt - movetype - overrides newmis.movetype if defined
// velm - velocity multiplier - overrides newmis.velocity if defined
// cln - classname
// md - model to use
// ct - content control
// amt - amount to burst
// rmt - random amount
// vp - vector pointer							\__ direction
// vr - vector randomizer					/
// cb - call back function for adding stuff (particle bursts, etc)
// s - entity to use, world indicates spawn new ent
/* flg - flags 
FL_VELRND		- randomize velocity * random()
FL_VELRND2		- randomize 1/2 velocity + 1/2 vel * random()
FL_NEWSELF	- new self ent every iter
FL_ANGADD		- angles are additive every iter - vp_x = vp_x + vr_x
FL_ANGADR		- angles added randomly / iter - vp_x = vp_x + vr_x * random()
*/

void(void() fr, vector org, float mvt, float velm, string cln, string md, float ct, float amt, float rmt, vector vp, vector vr, void() cb, float flg, entity s) fire_burst =
{
	local float r1, v;
//	local entity sv, s2;
	local entity sv;
//	local vector cf;

	sv = self;
	self = s;
	if (s == world) self = spawn();
	if (self == world) { self = sv; return; }
	newmis = world;

	r1 = amt + rint(random() * rmt);

	while (r1 > 0)
		{
		self.origin = org; // ISSUE: causes origin drift if org != self.origin
		self.owner = sv;
		if (flg & FL_ANGADS)
			{
			v = vr_x;
			if (flg & FL_ANGADR) v = vr_x * random();
			self.v_angle_x = vp_x = vp_x + v;
			v = vr_y;
			if (flg & FL_ANGADR) v = vr_y * random();
			self.v_angle_y = vp_y = vp_y + v;
			v = vr_z;
			if (flg & FL_ANGADR) v = vr_z * random();
			self.v_angle_z = vp_z = vp_z + v;
			}
		else
			{
			self.v_angle_x = vp_x + (random() * vr_x) - (vr_x / 2.0);
			self.v_angle_y = vp_y + (random() * vr_y) - (vr_y / 2.0);
			self.v_angle_z = vp_z + (random() * vr_z) - (vr_z / 2.0);
			}
		makevectors(self.v_angle); // for the v_forward things
		v = velm;
		if (flg & FL_VELRND) v = velm * random();
		if (flg & FL_VELRND2) v = velm + random() * velm;//(velm * 0.5) + (velm * 0.5 *random());

		if (fr != SUB_Null)
			{
			fr();

// FIX - imp content control for ct
			if (newmis)
				{
				if (flg & FL_FRCORG) newmis.origin = org;
				if (flg & FL_OWNOWN)
				{
					if (sv.owner) newmis.owner = sv.owner; // owner of the launching platform
				}
				else
					newmis.owner = sv;

				if (mvt) newmis.movetype = mvt;
				if (v) newmis.velocity = normalize(newmis.velocity) * v;
				if (flg & FL_VELRND) newmis.velocity = newmis.velocity * random();
				if (flg & FL_VELRND2) newmis.velocity = newmis.velocity + random() * newmis.velocity;//(newmis.velocity * 0.5) + (newmis.velocity * 0.5 *random());
				}
			}
		else if (md != null_string)
			fire_missile(v, mvt, 0, ct, self.origin, '0 0 0', cln, md, null_string, SUB_Null, 5 + (random() * 10), meltthink, SUB_Null);
		else
		{
#ifdef warning
			if (WARNING & 128) bprint("\n------------------- ** fire_burst (environment.qc, 491) called with bad parms\n");
#endifdef
			return; // no fn, no model, nothing to do
		}

		if (cb != SUB_Null) cb();

/* IMP: maybe later - (seems to be for making a lightning bolt burst)
		if (flg & FL_NEWSELF) // because of engine lightning bolt code...
			{ // just some stuff we might want
			cf_x = E_ORG | E_OWNER | E_VELOCITY | E_SIZE | E_MOVETYPE | E_SOLID | E_FLAGS | E_morphy | E_ITEMS | E_FRAME | E_AANGLES;
			s2 = ent_copy(cf, self, world);
			if (self != sv && self != s) remove(self); // dont remove entry self, or parm ent s
			self = s2;
			}
*/
		r1 = r1 - 1;
		}
	if (self != sv && self != s) remove(self);
	self = sv;
};

/*
vector(vector src, float lbper, vector lbvec, float lcnt) lava_shot =
{
	return(v0);
	// IMP: finish - see same cmod code
};
*/

void () fire_fly_touch =
{
	if (other == self.owner)
		return;

	if (other.touch == self.touch) // fireball wep fix for lava scrag
		return;

	if (sky_touch(null_string, v0, self))
	{
		SUB_Remove();
		return;
	}

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (other.mask_x != CB_CTHON) // Cataboligne - 9.22.11 - only here till we get chaos_ff done IMP: remove
	T_Damage (other,self,self,self.dmg);
	remove (self);
};

// fn(effect_item_fall) - rain of something

// fn(firefall) - make rain of fire happen
void() firefall =
{
//	setmodel(self, "progs/lavaball.mdl"); --- done in effect_ * map code
	self.frame = floor(2 + 2.4 * random());
//	chaos_mdlsize(self);
//	if (random() < 0.2) sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM); --- done in effect_* map code
	if (random() < 0.08) // act like regular fire fly - sort of
	{
		self.solid = SOLID_TRIGGER;
		self.classname = "fireball";
		self.touch = fire_fly_touch;
		self.think = meltthink;
		self.nextthink = time + 5 + (random() * 4);
		self.view_ofs = '0 0 2';
		self.dmg = 1 + random(); // stings a bit
//		self.dest_y = 16;
//		self.grab_callback = grab_lavaball;
//		self.th_walk = fire_fly_adj;
//		self.th_stand = floaterPointer;
//		if (self.frame == 5) self.th_stand = fire_splitter;
//		else 
//		content_cycle(self, RM_SKY | FLT_IMM | FLT_LAVA | MLT_LAVA | PF_LAVA | SF_CHK | PF_WATER | PF_SLIME | PF_EMPTY | CK_EARTHQUAKE, CONTENT_CHKTM);
	}
};

/*QUAKED effect_item_fall (.7 0 .7) ?
--------  CAT  -------
"th_stand" - function call to create item - MUST return handle in "newmis" pointer!
(most default iD functions [fire_fly] will need wrapped or re-written...)
"touch" - touch function (defaults to SUB_Remove if not set)

Fields to set (usually not using th_stand, but can operate in parallel)
"mdl" - model of item - defaults to "progs/s_rain.spr"
"noise" - noise to play on fall start
"noise1" - noise to play on impact
"noise2" - loop sound played at brush origin - operates in sync
"pos1" - pos1_x - chance to play noise, pos1_y - chance to play noise1 per event
- pos1_z - length of noise2
"frame" - frame of model, negative number randomizes set of frames
"dmg" - damage to do on touch if coded

"wait" - density - default 2 (2 per rel)
"speed" - initial falling speed (velocity_z) default 20
"t_width" - horizontal drift (velocity_x)
"t_length" - horizontal drift (velocity_y)
"style" - random horizontal drift - any direction - overrides fixed (t_*) above
"lip" - random spawn distance around origin (horizontal x - y)
"delay" ("mean", "stdev") - time to run fall, if all 0, toggles by targetname

"targetname" - targeted by any entitiy - starts / toggles fall sequence
 - if no target effect starts on map load and runs according to delays
-------- NOTES --------
cause items to rain down from trigger brush
items will spawn randomly across space of brush and fall at set velocity
*/

void() item_fall_toggle =
{
	if (time < self.rad_time) return;

	if (self.state)
	{
		self.state = FALSE;
		self.nextthink = -1;
		if (self.enemy) remove(self.enemy);
		self.enemy = world;
	}
	else
	{
		if (self.mean || self.stdev) // expiriy time
			self.state = time + meantime(self.mean, self.stdev);
		else if (self.delay) // expiriy time
			self.state = time + self.delay;
		else
			self.state = TRUE;

		self.enemy = world;
		if (self.noise2)
			self.enemy = loop_sound(self, CHAN_WEAPON,self.noise2, 1, ATTN_NORM, self.pos1_z, self.origin, 0, LOOPFOREVER);

		self.nextthink = time  + 1;
	}
	self.rad_time = time + 5; // debounce
};

void() item_fall_touch =
{
	local float f;
	// remove rain when it hits ground or any other object
	// IDEA: make puddles on flat surfaces?

	f = 1;
	if (self.pos1_y) f = self.pos1_y;
	if (self.noise1)
	if (random() < f)
		sound (self, CHAN_AUTO, self.noise1, 1, ATTN_NORM); // impact noise

	remove(self);
};

void() item_fall_think =
{
	local entity drop;
	local float f;

	if (self.mean || self.stdev || self.delay) // an expiry time was set
	if (self.state < time)
	{
		item_fall_toggle();
		return;
	}

	v1 = self.origin;
	if (self.lip)
	{
		if (random() < 0.5)
			v1_x = v1_x - self.lip * random();
		else
			v1_x = v1_x + self.lip * random();
		if (random() < 0.5)
			v1_y = v1_y - self.lip * random();
		else
			v1_y = v1_y + self.lip * random();
		v1_z = v1_z - 8 * random();
	}

	if (self.maxs)
	{
		v1_x = self.mins_x + self.size_x * random();
		v1_y = self.mins_y + self.size_y * random();
		v1_z = self.mins_z + self.size_z * random();
	}

	drop = chaos_spawn(MOVETYPE_TOSS, SOLID_BBOX, 0, 0,  v1 , v0, v0, v0, v0, "itemdrop", self.mdl, item_fall_touch, 5, SUB_Remove, SUB_Null, self, world);
	drop.velocity_z = 0 - self.speed - (self.speed * 0.1 * crandom());

	if (self.t_width) drop.velocity_x = self.t_width;
	if (self.t_length) drop.velocity_y = self.t_length;

	if (self.style)
	{
		drop.velocity_x = self.style * crandom();
		drop.velocity_y = self.style * crandom();
	}

	drop.dmg = self.dmg;
	drop.frame = self.frame;
	drop.noise1 = self.noise1;
	drop.pos1 = self.pos1;

	f = 1;
	if (self.pos1_x) f = self.pos1_x;
	if (self.noise)
	if (random() < f)
		sound (drop, CHAN_AUTO, self.noise, 1, ATTN_NORM);

	if (self.th_stand != SUB_Null) // callback after create
	{
		drop.enemy = self;
		self = drop;
		self.enemy.th_stand();
		self = self.enemy;
		drop.enemy = world;
	}

	self.nextthink = time + (1 / self.wait); // more density = shorter time
};

void() effect_item_fall =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.model = null_string;

	if (!self.mdl) self.mdl = "progs/s_rain.spr";

	if (!DARKPLACES)
	if (time < 2)
	{
		if (self.mdl) precache_model(self.mdl);
		precache_sound("ambience/rain.wav");
		precache_sound("ambience/thunder1.wav");
		if (self.noise) precache_sound(self.noise);
		if (self.noise1) precache_sound(self.noise1);
		if (self.noise2) precache_sound(self.noise2);
	}

	self.think = item_fall_think;
	if (!self.targetname)
	{
		self.nextthink = time + 1;
		self.state = FALSE;
		item_fall_toggle();
	}
	else
	{
		self.use = item_fall_toggle;
		self.state = FALSE;
		if (self.spawnflags & TRUE) item_fall_toggle();
	}

	if (!self.speed) self.speed = 20;
	if (self.maxs == v0 && self.mins == v0)
	if (!self.lip) self.lip = 64;
	if (!self.wait) self.wait = 2;

	if (self.netname == "firefall") self.th_stand = firefall;
	else
//	if (self.th_stand == (void()) 0)
		self.th_stand = SUB_Null;
};

// rain & snow in open hack maps

void() make_it_rain =
{
	self.nextthink = time + 0.1;

// locate player spot - cloud follows him, heh heh

	self.pos2_x = self.owner.origin_x + 512;
	self.pos1_x = self.owner.origin_x - 512;

	self.pos2_y = self.owner.origin_y + 512;
	self.pos1_y = self.owner.origin_y - 512;

	self.pos2_z = self.owner.origin_z + 256;
	self.pos1_z = self.owner.origin_z - 64;

	if (self.spawnflags & 3) // snow / ash
		te_particlesnow(self.pos1, self.pos2, self.dest, self.count, self.cnt);
	else
		te_particlerain(self.pos1, self.pos2, self.dest, self.count, self.cnt); // rain

	self.origin = self.owner.origin; // where he is

// moved too far - reset
	if (!self.spawnflags & 3) // snow / ash does not thunder or piddle
	{
		if (vlen(self.oldorigin - self.origin) > 200) self.t_length = 0;

		if (self.t_length < time)
		{
			self.t_length = time + 8.254; // len of rain sample
			sound (self, CHAN_VOICE, "ambience/rain.wav", 1, ATTN_NORM);
			self.oldorigin = self.origin;
		}

		if (random() < 0.3)
		if (self.t_width == MAXFL)
			self.t_width = time + 40 * random(); // make it go boom

		if (self.t_width < time)
		{
			self.t_width = time + 40 * random();
			sound (self, CHAN_BODY, "ambience/thunder1.wav", 1, ATTN_NORM);
//		if (random() < 0.1) self.t_width = MAXFL; // boom over
		}
	}
};

void() rain_use =
{
// toggle - rain stops
	if (self.owner)
	{
		self.owner = world;
		self.nextthink = -1;
		sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
		return;
	}

	self.owner = activator; // should be ent touching trigger

//	self.t_width = MAXFL;  // no boom to start

	self.cnt = 11; //off white rain
	self.dest_z = 0 - 200 - 200 * random(); // fall rate

	if (self.spawnflags & 1) // snow / ash
	{
		self.dest_z = 0 - 100 - 100 * random(); // fall rate
		self.cnt = 12;
	}

/*
	if (fnc == snow_think)
	{
		self.dest_x = 3 * crandom(); // windage
		self.dest_y = 3 * crandom();
	}
	else
	{
*/

// taking break from gusts & changes - seems to be an issue
//	c.rad_time = time + 20 + random() * 45; // gusts for snow
//	c.pos1 = '-10000 -10000 -10000';
//	c.pos2 = ' 10000 10000 10000';
/*
// former cmod I box check version
	traceline (self.origin, self.origin + ' 3000 0 0', TRUE, self); // x dist to nearest obstacle (wall) in + dir on axis
	c.pos2_x = trace_endpos_x - 5;

	traceline (self.origin, self.origin + '-3000 0 0', TRUE, self); // - dir on axis
	c.pos1_x = trace_endpos_x + 5;

	traceline (self.origin, self.origin + ' 0 3000 0', TRUE, self);
	c.pos2_y = trace_endpos_y - 5;

	traceline (self.origin, self.origin + ' 0 -3000 0', TRUE, self);
	c.pos1_y = trace_endpos_y + 5;

	traceline (self.origin, self.origin + ' 0 0 3000', TRUE, self);
	c.pos2_z = trace_endpos_z - 10;

	traceline (self.origin, self.origin + ' 0 0 -3000', TRUE, self);
	c.pos1_z = trace_endpos_z + 5;
*/
	self.count = 10;
	make_it_rain(); // pre-calc
	
	self.count = (self.pos2_x - self.pos1_x)*(self.pos2_y - self.pos1_y)/4096;

#ifdef warning
if (WARNING)
{
bprint("*** warning: \bprec min: ");
bprint(vtos(self.pos1));
bprint("prec max: ");
bprint(vtos(self.pos2));
bprint("cnt: ");
bprint(ftos(self.count));
bprint("\n");
}
#endifdef

	if (self.count < 1)
	{
		self.owner = world;
		return;
	}
	// convert from per second to per 0.1 sec,
	self.count = ceil(self.count * 0.1);

	self.nextthink = time + 0.1;
	self.think = make_it_rain;
};

// note: could possibly use a brush to set parms above for a specific area rain

void() func_rain =
{
	self.use = rain_use;
	
};

// returns entity for target - behavior:

// cls - if non null look for this classname and pick a random one
// fl - flags that control fn
// FL_ITEM		include items - if FL_RSEVEN is not set, code will favor item dests 10 %
// FL_RSTELE	include teleports - if FL_RSEVEN is not set, code will favor teleport destinations 60%
// FL_RSSTART	include all player starts - if FL_RSEVEN is not set code will favor these only 30%
// FL_NOTARGET	include only classname specified in fn call
// FL_RSRNG		find_tdest - find closest range among selections - IDEA - FL_ZPREF - prefer near z level to closer up / down
// FL_RSEVEN	chances are equal for any destination
// FL_RSALL		select tele, start, & items evenly
// 0				try teleport dest, if none try starts

entity(float rd, entity e) find_tselect =
{
	local float r;
	r = floor(random() * rd);

#ifdef warning
																								if (WARNING & 128)
																								if (FALSE)
																								{
																									bprint("find_dest random: ");
																									bprint(ftos(r));
																									bprint(" unit selected - ent: ");
																									bprint(e.classname);
																									bprint(" \n");
																								}
#endifdef

	while (r > 0)
	{
		r = r - 1;
		if (e.chain) e = e.chain;
	}
	return(e);
};


entity(float fl, string clsn) find_tdest =
{
	local entity p, tl, st, it, cl;
	local float rng, sf, ctl, cst, cit, ccl;

	if (!self) return(world); // CHECK: is this needed?

	p =  tl = st = it = cl = world;
	ctl = cst = cit = ccl = 0;
	rng = (fl & FL_RSEVEN) | (fl & FL_RSRNG); // closest or even chance - make one big chain

	if ((fl & FL_RSTELE) || (fl < 1))
	{
		tl = self;
		ctl = cnt_ent(tl, "classname",  "info_teleport_destination");
		if (rng) while (tl.chain) tl = tl.chain;
		else tl = self.chain;
	}

	if ((fl & FL_RSSTART) || ( fl < 1))
	{
		if (rng && tl != world) st = tl;
		else st = self;
		cst = cnt_ent(st, "classname",  "info_player_start");
		while (st.chain) st = st.chain;
		cst = cst + cnt_ent(st, "classname",  "info_player_coop");
		while (st.chain) st = st.chain;
		cst = cst + cnt_ent(st, "classname",  "info_player_deathmatch");
		if (rng) while (st.chain) st = st.chain;
		else st = self.chain;
	}

	if (fl & FL_ITEM)
	{
		if (rng && st != world) it = st;
		else it = self;
		cit = cnt_ent(it, "class_select", "class_ammo"); // chain all this up if found
		while (it.chain) it = it.chain;
		cit = cit + cnt_ent(it, "classname", "item_armor1");
		while (it.chain) it = it.chain;
		cit = cit + cnt_ent(it, "classname", "weapon_supershotgun");
		while (it.chain) it = it.chain;
		cit = cit + cnt_ent(it, "classname", "weapon_nailgun");
		while (it.chain) it = it.chain;
		cit = cit + cnt_ent(it, "class_select", "class_health");
		it = self.chain;
	}

	if (clsn != null_string)
	{
		if (rng && it != world) cl = it;
		else cl = self;
		if (clsn ==  "class_monster")
			ccl = cnt_ent(cl, "class_select", clsn);
		else
			ccl = cnt_ent(cl, "classname", clsn);
		cl = self.chain;
	}
//																																								if (FALSE) print_chain(self.chain);

	if (fl & FL_RSRNG)
	{
		sf = (ctl + cst + cit + ccl) * 2;
		tl = p = self.chain;
		rng = MAXFL;
		while (p && sf > 0)
			{
				sf = sf - 1;
				if (vlen(self.origin - p.origin) < rng)
				{
					rng = vlen(self.origin - p.origin) ;
					tl = p;
				}
				p = p.chain;
			}
		if (tl) return(tl); // select close range - takes priority over even flag
	}

	if (fl & FL_RSEVEN)
	{
		p = find_tselect(ctl + cst + cit + ccl, self.chain); // select among all things randomly
		if (p) return(p);
	}

	rng = random();

	p = world;
	if (ctl)
	if (rng < 0.6 || fl < 1 || !(cst + cit)) // select a teleport dest
	{
		p = find_tselect(ctl, tl);
		if (p) return(p);
	}

	if (cst)
	if (rng < 0.9 || fl < 1 || !cit) // select a player start
	{
		p = find_tselect(cst, st);
		if (p) return(p);
	}

	if (ccl)
	{
		p = find_tselect(ccl, cl); // select among classname clsn
		if (p) return(p);
	}

	if (cit)
		p = find_tselect(cit, it); // select an item from approved list

#ifdef warning
// note - does not catch returns above
																								if (WARNING & 128)
																								{
																									bprint("find_dest selected: ");
																									bprint(p.classname);
																									bprint(", ");
																									bprint(vtos(p.origin));
																									bprint("\n");
																								}
#endifdef

	return(p);


};

// IDEA - nemesis of sphere annihilation | something similar to sphere bomb

float chaos_tele_total;

// to auto remove random teles (ones from cubes)

void() chaos_tele_expire =
{
	if (self.enemy)
	{
		if (self.button13 == self.enemy.button13)
		{
			self.enemy.think = remove_fade;
			self.enemy.nextthink = time + 0.1;
			if (self.enemy.aiment) 
			{
				sound (self.enemy.aiment, self.enemy.aiment.cnt,"misc/null.wav",1,ATTN_NORM);
//				self.enemy.aiment.search_time = 0;
				remove(self.enemy.aiment); // Cat - 12.31.10 - now removing these
			}
			self.enemy.aiment = world;
			remove(self.enemy.trigger_field);
// now counting - 11.8.12
			chaos_tele_total = chaos_tele_total - 1;
			if (chaos_tele_total < 0) chaos_tele_total = 0;
		}
	}
	remove(self);
}

// self is player, gr is telesphere
void() teleport_touch;

/*
float(entity gr) chaos_teleport_grab =
{
	if (!gr) return(FALSE);
	if (random() < CHAOS_GRAB_TELE) return (FALSE); // got it...heh heh, or it has you

	gr.enemy = self;
	other = self;
	self = gr;
	teleport_touch(); // got teleported
	self = self.enemy; // back to us
	return(TRUE);
};
*/

void() chaos_trigger_teleport =
{
	InitTrigger ();
	self.touch = teleport_touch;
	self.model = null_string;
	setsize(self, '-16 -16 -16', '16 16 16'); // getting bonked somehow
};

void(vector torg, string trgname, entity trgent) chaos_teleport =
{
//	local entity tel;
	local entity s;

	if (self.classname == "player") s = self; // only players own these

// IDEA - get trigger field size from model sizes
	// physical ent - because trigger has no mdl
	newmis = chaos_spawn(MOVETYPE_FLY, SOLID_BBOX, 0, 0,  torg, '-12 -12 -12', '12 12 12', v0, v0, "chaos_teleport_icon", "progs/sphere_annihilation.mdl", SUB_Null, 2, sphere_annihilation_move, SUB_Null, s, world);
	newmis.oldorigin = torg;
	newmis.aflag = -1; //stable
	newmis.mdl = newmis.model;
//	newmis.grab_callback = chaos_teleport_grab;

// trigger
	newmis.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  torg , '-16 -16 -16', '16 16 16', v0, v0, "chaos_teleport", "progs/sphere_annihilation.mdl", SUB_Null, 4, chaos_trigger_teleport, SUB_Null, s, world);

//	newmis.frame = needs think fn
	newmis.skin = 1; //animated skin group

// locate target
	newmis.trigger_field.movetarget = world;
	if (trgname) newmis.trigger_field.movetarget = find (world, targetname, trgname);
	else if (trgent) newmis.trigger_field.movetarget = trgent;

	if (!newmis.trigger_field.movetarget) newmis.trigger_field.movetarget = find_tdest(0, null_string);

	newmis.aiment = loop_sound(newmis, CHAN_WEAPON,"alt_ambience/hum1.wav", 0.9, ATTN_NORM, 3.62, torg, 0, LOOPFOREVER);
};

/*QUAKED func_chaos_teleport (.7 0 .7) (-8 -8 -8) (8 8 8) NOMOVE
--------  CAT  -------
Chaos Mod MK II

Make a chaos teleport point on the map

NOMOVE - dont allow teleport to move

-------- NOTES --------
"model" - use custom models and skins for chaos teleport
"skin"
"target" - teleport destination
"aflag" -666 - do not change from selected target
 - if selected target does not exist, a random one is chosen and aflag does not apply
*/

// map load a chaos teleport

void() func_chaos_teleport =
{
	chaos_teleport(self.origin, self.target, world);

// custom model
	if (self.model != null_string)
	{
		setmodel(newmis, self.model);
		newmis.skin  = self.skin;
		self.model = null_string;
	}

// never moves
	if (self.spawnflags & 1) newmis.movetype = MOVETYPE_NONE;

	if (self.target != null_string)
	if ( find (world, targetname, self.target))
	if (self.aflag == -666) newmis.trigger_field.aflag = -666; // do not retarget
	remove(self);
};


// fn(item_throwGib) - for stuff that needs to toss gibs
/*
void(string gibname, float dm, string cls, float tm, float fr) item_throwGib =
{
	
};
*/

// goes back in volcano

// temp

void () fire_fly;

void(string md) chaos_fire_fly =
{
	local void() e;
	float f;

	e = self.think;
	f = self.nextthink;
	fire_fly();
	self.think = e;
	self.nextthink = f;
};

float(entity ent, float flg) content =
{

	if (ent != world) return(pointcontents (ent.origin + ent.view_ofs));

	if (self == world)
	{
		return FALSE;
	}
	else
		return(pointcontents (self.origin + self.view_ofs));
};


// fn(T_FireDamage) - damage from fires & hot stuff, will heal lavablobs!

void (entity targ, entity inflictor, entity attacker, float damage) T_FireDamage =
{
//	if ((targ.morphy == IMP_MCTHON) || (targ.morphy == IMP_MCHAOS) || (targ.classname == "monster_tarbaby" || targ.classname == "monster_lavabomb")) // lava capable ents wont get burned...often
	if (IS_LAVA(targ)) 
	{

#ifdef warning
if (! WARNING & 262144) // block this warning
if (WARNING & 128)
{
bprint("*** warning: T_FireDamage ( ");
item_ident(targ);
bprint(" ) - possible heal: ");
bprint(ftos(damage));
bprint("\n");
}
#endifdef

		if (targ.morphy == IMP_MCTHON) T_Heal(targ, damage, 0); // LOL - lava is "healed" by fire - such a horta situation...
/*

 deprecate - Archons take no damage or healing
//
		else if (targ.morphy == IMP_MCHAOS) // chaos here
		{
			if (targ.watertype == CONTENT_LAVA)
			{
				if (random() < 0.05) T_Heal(targ, damage * random(), 0); // CHAOS_LEVEL ph
				else if (random() < 0.015) T_Damage (targ, inflictor, attacker, damage * random()); // even less chance of damage
			}
			else
				if (random() < 0.02) T_Damage (targ, inflictor, attacker, damage * random());
		}
*/
		else //if (targ.classname == "monster_tarbaby" || targ.classname == "monster_lavabomb") 
		{
			if (random() < 0.2) T_Heal(targ, damage, 0);  // tarbabys too...
		}
	}
	else T_Damage (targ, inflictor, attacker, damage);
};

// fn(smallent_free) - free edges of smaller non player / monster ents from solids
// sz - size radius to check
// moves ent to clear pos - removes self if not clear within 161 checks

// designed for lava puddles - notorious for the 1/2 puddle in the wall move
// IDEA: z check? (repos?) flag for remove, check lower edge for hanging over drop offs

float smallent_sf; // loop safety - _must_ be set before fn() call

void(float sz) smallent_free =
{
	local vector v2;

	v1 = v0;
	for (v1_x = 0 - sz; v1_x < (sz + 1); v1_x = v1_x + sz)
	for (v1_y = 0 - sz; v1_y < (sz + 1); v1_y = v1_y + sz)
	if (pointcontents(self.origin + v1) == CONTENT_SOLID)
	{
		v2 = v0;
		v2_x = 0 - v1_x;
		v2_y = 0 - v1_y;
		self.origin = self.origin + v2;
		smallent_sf = smallent_sf + 1;
		if (smallent_sf > 160)
		{
			SUB_Remove();
			self = world;
			return;
		}
		smallent_free(sz);  // recursive (ish)
		return;
	}
};



// fn(fire_fly_adj) - adjust fire flys return to lava or entry to other liquids

void() fire_fly_adj =
{
if (self.watertype == CONTENT_LAVA)
	{
	self.flags = self.flags | FL_NOPART;
	self.skin = HTLAVA;
//	content_clear(self);
//	if (self.model == "progs/snowball.mdl") self.skin = HTLAVA;
	if (self.frame >= LAVA_LGFRAME) self.skin = LAVA_LGSKIN; // large balls, also *** FIX turn off exploder if on
	}
else if (self.watertype == CONTENT_WATER || self.watertype == CONTENT_SLIME)
	{
		if (self.frame < LAVA_LGFRAME)// && self.model == "progs/lavaball.mdl")
		{
			if (self.watertype == CONTENT_WATER) self.skin = DKLAVA;
			else if (self.watertype == CONTENT_SLIME && random() < 0.5) self.skin = DKLAVA;
//			if (self.sFloating != "floating") floaterPointer();//Enable(self, self.mins_z / 2);
//			self.bubble_count = NO_BUBBLES;
			if (self.skin == DKLAVA)// && self.model == "progs/lavaball.mdl")
			{
//				setmodel(self, "progs/snowball.mdl");
//				chaos_mdlsize(self);
				self.modelflags = EF_NOMODELFLAGS; // clear rocket trail
				self.movetype = MOVETYPE_BOUNCE;
				sound (self,CHAN_WEAPON,"chaos/freeze.wav",1,ATTN_NORM);
				self.dmg = 0;
			}
		}
	}
/*
else if (self.watertype == CONTENT_EMPTY)
	{
		if (!self.wait) self.wait = time + random();
		if (self.wait < time)
		{
			self.wait = time + random();
			if (self.frame < LAVA_LGFRAME && self.skin != DKLAVA)
			if (self.velocity == v0 && random () < 0.2) // motionless lavaball in 
			{
				self.think = fire_fly_cooled;
				self.nextthink = 2 + random();
			}
		}
	}*/
};

// fn(lavaball_large) - set parms for large lavaball

void(entity lb, float mvt, vector avl, vector vel, string snd) lavaball_large =
{
	if (lb != world) newmis = lb;
	if (newmis == world)
		newmis = chaos_spawn(mvt, SOLID_TRIGGER, 0, RM_SKY | FLT_IMM | FLT_LAVA | MLT_LAVA | PF_LAVA | SF_CHK | PF_EMPTY | CK_EARTHQUAKE, 
									v0, v0, v0, v0, v0, "fireball", "progs/lavaball.mdl", fire_fly_touch, 3 * (FIRE_FLY_TM + random() * FIRE_FLY_TDEV), meltthink, SUB_Null, self, world);

	if (newmis.model != "progs/lavaball.mdl") setmodel(newmis, "progs/lavaball.mdl");
	if (!mvt) mvt = MOVETYPE_TOSS;

	newmis.frame = LAVA_LGFRAME;
	newmis.skin = LAVA_LGSKIN;
	newmis.view_ofs = '0 0 -4';
	setsize(newmis, '-16 -16 -16', '16 16 16');
	newmis.dest_y = 32;
	newmis.dmg = 100;
	newmis.wait = NOFLY; // these wont make launchers
	newmis.movetype = mvt;
	newmis.avelocity = avl;
	newmis.velocity = vel;
	newmis.th_walk = fire_fly_adj;
//	newmis.grab_callback = grab_lavaball;
	newmis.class_select = "class_lavaballbig"; // this guy is special all around
	if (random() < 0.5) // some large lavaballs mirv
		{
//		newmis.th_stand = fire_splitter;
		newmis.oldorigin = newmis.origin;
		}
	if (snd != null_string) sound (newmis, CHAN_WEAPON, snd, 1, ATTN_NORM);
};



// fn(rnd_size) - randomize size when lavaball is newmis
// fn(burst_rnd_size) - randomize size callback for fire_burst

// pr - rnd < percent chance to chg size
// super - rnd < percent added chance of super size fireball
// ts - rnd < percent chance to toss (assumes state is MOVETYPE_FLY*)
// -1.0 is lockout for each chance, 1.1 is always
// sd - super ball launch sound to play

void(float pr, float ts, float super, string sd) rnd_size =
{
	if (newmis == world) return;
	newmis.frame = 0;
	if (random() < ts) newmis.movetype = MOVETYPE_TOSS;
	if (random() < pr)
		{
		newmis.frame = rint(random() * 3.2);
		if (random() < 0.13 && newmis.frame < 5) newmis.frame = newmis.frame + 5;
		if (random() < super) lavaball_large(newmis, 0, '200 0 0', newmis.velocity, sd);
		}
};



$frame lavasm1 lavasm2 lavasm3 lavasm4 lavasm5
$frame lavamd1 lavamd2 lavamd3 lavamd4 lavamd5
$frame lavalg1 lavalg2 lavalg3 lavalg4 lavalg5

float smallent_sf; // loop safety - _must_ be set before fn() call


// fn(lavapud_ground) - attempt to ground floating puddles
// .th_run - original think fn MUST be stored here!

void() lavapud_ground =
{
//	local float sf;

//	sf = 100;
	if (!self.aflag) self.aflag = 100;
	if (content(world,CKO) != CONTENT_SOLID && content(world,CKO) != CONTENT_LAVA && self.aflag > 0) // try to ground puddles
		{
//		setorigin(self, self.origin + '0 0 -2');
		if (self.velocity_z > -75) self.velocity_z = self.velocity_z - 10;
		self._stand = self.think = lavapud_ground;
		self.aflag = self.aflag - 1;
		if (!self.aflag) self.aflag = -1;
		}
	else
		{
//		while ((content(world,CKO) == CONTENT_SOLID || content(world,CKO) == CONTENT_LAVA) && sf > 0)
//		{
//			sf = sf - 1;
//			setorigin(self, self.origin + '0 0 2');
//		}
		setorigin(self, self.origin + '0 0 1');
		self._stand = self.think = self.th_run;
//		content_clear(world);
//		self.velocity_z = 0;
		}

	self.nextthink = time + 0.05;
};


// fn(lavapdl_touch) - something touched a lava puddle
// dummy = burn em!

void() lavapdl_touch =
{
//bprint("lava pdl touch\n"); // TEST
	local float s1;

	if (other == world)
	{
		s1 = 24;
		if (self.viswframe > $lavamd5) s1 = 36;
		else if (self.viswframe > $lavasm5) s1 = 30;
		smallent_sf = 0;
		smallent_free(s1);  // IDEA - radius frame factor
		return;
	}
	if (other == self.owner) return;

	if (other.health > 0)
	if (other.dmgtime < time)
	{


#ifdef warning
if (WARNING & 128)
{
bprint("doing ");
bprint(ftos(self.dmg));
bprint(" damage\n");
}
#endifdef


		if (other.morphy == IMP_MCTHON) 
		{
			self.dmg = self.dmg * 0.75; // really a heal of another player lava morph at this point
			if (self.dmg < 1)
			{
				self.wait = time; // ran out of heat, freeze it
				self.lefty = -1;
			}
			T_FireDamage (other, self, self.owner, self.dmg); // dont want flame touch for lava
		}
		else 
			FlameTouch();
		other.dmgtime = time + 0.09 + random();
	}
}

// fn(lavapdl_live) - hot puddle flow, handle player spawned launcher
// lava bomb left a messy puddle...cleanup on isle 6 please, bring a radsuit!

//.wait - time to live
//.delay - timer for blobdown
//.viswframe - base frame for puddle size (sm, md, lg)
//.lefty = shots
//.lip - ball size
//.skin - hot or cooled
//.style - set to NO_FLOAT for floater code
//.aflag - used to time out grounder


void() lavapud_live =
{
	local float pco, pcf;

	pco = pointcontents(self.origin + '0 0 1'); // for actual lavapud contain
	pcf = pointcontents(self.origin + '0 0 -4'); // for lavapud floating on lava


#ifdef warning
if (WARNING & 128)
if (FALSE)
{
bprint("lavapud content: ");
bprint(ftos(pco));
bprint(", at float: ");
bprint(ftos(pcf));
bprint("\n");
}
#endifdef
	
	
	if (self.classname != "lavapud") // not initialized, do a setup
		{
//		if (self.model == "progs/snowball.mdl" && self.skin == DKLAVA) self.model = "progs/lavaball.mdl";
		self.mdl = null_string;
		if(self.owner.morphy == IMP_MCHAOS) self.mdl = self.model; // for chaos bizzare launchers
// this call sets all this - takes over self
		newmis = chaos_spawn(MOVETYPE_TOSS, SOLID_TRIGGER, 0, 0, self.origin, v0, v0, v0, v0, "lavapud", "progs/volcano.mdl", lavapdl_touch, 0.3, lavapud_live, SUB_Null, self.owner, self);
		self.content_flag = self.content_flag - (self.content_flag & (MLT_LAVA | PF_LAVA | SF_CHK | PF_EMPTY));
//		self.grab_callback = grab_lavaball;
		self.skin = self.height = 1;
		self.style = NO_FLOAT; // dont float these
		self.lefty = 2 + (random() * 5.1) + (random() * 5.1) + (random() * 5.1); // load up launcher
		self.dmg = 5 * self.lefty;
		self.avelocity = '0 0 0';
		self.angles_y = 360 * random();
		self.view_ofs = '0 0 -2';
		self.aflag = self.walkframe = 0;
		self.viswframe = $lavasm1;
		if (random() < 0.3)
			{
			if (random() < 0.3) self.viswframe = $lavalg1;
			else self.viswframe = $lavamd1;
			}
		self.delay = time + 3 + rint(random() * 2.2);
		if (self.wait <= time) self.wait = time + 20 + random() * 10;
		}

	self.nextthink = time + 0.3;
	self.skin = self.skin + self.height;				// live a little, stops once solidified | cooled

	if (self.skin == LAVA_PUDEND) self.height = -1;
	if (self.skin == LAVA_START) self.height = 1;

	self.lip = 1;
	if (pcf != CONTENT_LAVA)
		{
		if (self.walkframe != 4)
		if (self.delay < time) // blob puddles down
			{
			if (pco == CONTENT_SLIME) lavablob_slimeflare();
			self.delay = time + 3 + rint(random() * 2.2);
			self.walkframe = self.walkframe + 1;
			}
		self.frame = self.viswframe + self.walkframe;
		if (MIRV_RESIZE) self.lip = rint(1 + random() * 2.1);
		}
	else
		if (MIRV_RESIZE) self.lip = rint(0 + random() * 3.1);

	if (self.chaosweptime)
	if (self.chaosweptime < time)
		{
			self.speed = 300 + random() * 100;
			chaos_fire_fly(self.mdl); // fire off a fly - this code reduces .lefty count
			self.dmg = 5 * self.lefty;
			newmis.frame = self.lip;
		}

	if ((self.wait < time) || (pco == CONTENT_WATER) || self.skin == LAVA_DEADSKIN) // cold now
		{
			if (pcf == CONTENT_LAVA && self.skin != LAVA_DEADSKIN)
			if (random() < (0.5 + (self.lefty / 30.0))) // on or in lava
			{
#ifdef warning
																																												if (WARNING & 128) bprint("time extend\n");
#endifdef
				self.wait = time + 5 + random() * 15;
				self.lefty = 5 + random() * 25;
				return;
			}
			if (pcf != CONTENT_LAVA) self.skin = LAVA_DEADSKIN;
			self.dmg = 0;
			self.nextthink = time + 20; // gone in 20 rels, hey who stole my lava puddle?!
			self.dest_y = 16;
			self._stand = self.think = meltthink;
			self.classname = "lavacool";
		}

	if (!self.flags & FL_HELD)
	if (pcf == CONTENT_EMPTY && !self.aflag) // item_held() - try to ground puddles
	{
#ifdef warning
																																									if (WARNING & 128) bprint("adjusting z\n");
#endifdef
		self.th_run = lavapud_live;
		lavapud_ground();
	}

};
