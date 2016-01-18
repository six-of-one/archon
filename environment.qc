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


// NOTE: came from chaos_env.qc

// fn(move_stop) halt a moving entity, play looped sound ns

void (entity e, string ns) move_stop =
{
	e.velocity = ' 0 0 0';
	e.movetype = MOVETYPE_NONE; // fails blast_move - removing fails shell casings in lava
	if (ns != "") sound(e, CHAN_WEAPON, ns, 1, ATTN_NORM);
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
};
vector(entity e, float s, float n) getsurfacepoint =
{
	if (DARKPLACES)
		return(getsurfacepoint_wrap(e, s, n));
};
vector(entity e, float s) getsurfacenormal =
{
	if (DARKPLACES)
		return(getsurfacenormal_wrap(e, s));
};
string(entity e, float s) getsurfacetexture =
{
	if (DARKPLACES)
		return(getsurfacetexture_wrap(e, s));
};
float(entity e, vector p) getsurfacenearpoint =
{
	if (DARKPLACES)
		return(getsurfacenearpoint_wrap(e, p));
};
vector(entity e, float s, vector p) getsurfaceclippedpoint =
{
	if (DARKPLACES)
		return(getsurfaceclippedpoint_wrap(e, s, p));
};



/*QUAKED func_fallingwater (0 .5 .8) ?
moving water illusion - only vertical for now
appx moving liquid from q2
Toggle - if targetname set, wait at each end for trigger
normal - cycle is to move distance then move back in speed time each way

"speed" is how long in seconds it to complete move
"height" is dist to move - if 0 size_z of model is used (+ lip)
"lip" added to move distance (height)
"cnt" - units to move in one time segment - default 1, -1 reverses dir (down)
"ltime" - time segment to move cnt - calculated from speed & dist if not set
"delay" - time before triggered move takes place
"wait" - if not toggled time till return starts, -1 stops, default 1
"target" - if set gets fired at end of travel
"killtarget" - hurt trigger will be moved with fallingwater model
*/
void() fallingwater_fire;

void() fallingwater_think =
{
	local vector v1;

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
//	if (self.killtarget != "") self.enemy = find (world, targetname, self.killtarget);
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

void() func_fallingwater =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self,self.model);
	self.think = fallingwater_think;
	self.nextthink = -1;

	if (self.targetname != "")
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
//	if (chaos) WriteCoord (MSG_BROADCAST, fr); // TDO: color dp bolts
};

void(vector org, vector end, float fr) multi_beam =
{
	local entity sv, s2;
	local	vector cf;

	sv = self;

//	cf_x = E_ORG | E_OWNER | E_VELOCITY | E_SIZE | E_MOVETYPE | E_SOLID | E_FLAGS | E_MORPHNUM | E_ITEMS | E_FRAME | E_AANGLES;
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

void(vector v1, vector v2, float typ, string snd) lightning_bolt =
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
	WriteCoord (MSG_BROADCAST, v1_x);
	WriteCoord (MSG_BROADCAST, v1_y);
	WriteCoord (MSG_BROADCAST, v1_z);
	WriteCoord (MSG_BROADCAST, v2_x);
	WriteCoord (MSG_BROADCAST, v2_y);
	WriteCoord (MSG_BROADCAST, v2_z);

	if (snd)
	{
		e.origin = v1;
		sound (e, CHAN_WEAPON, snd, 1, ATTN_NORM);
//		e.orign = v2;
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


// fn(chaos_particle) - chaos particle field effect
// org - origin
// rn - range
// pr - percent chance
// col - fixed color

vector cparticle_lorg;

void(vector org, float rn, float pr, float col) chaos_particle =
{
	local vector p1;
	local float cl;

	p1_x = (random() - 0.5) * random() * rn;
	p1_y = (random() - 0.5) * random() * rn;
	p1_z = (random() - 0.5) * random() * rn * 0.9;
	cparticle_lorg = org + p1;
	cl = col;
	if (cl < 0) cl = random() * 255;

	if (self.morphy == IMP_MWRAITH)
	{
		if (col == 12 || col == 251)
			particle (org + p1, ' 0 0 0', cl, 3);
		else
			particle (org + p1, ' 0 0 0', cl, 15);
	}
	else
		if (random() < pr) particle (org + p1, ' 0 0 0', cl, random() * 25); // IDEA - restrict colors?
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
	local entity sv, s2;
	local vector cf;

	sv = self;
	self = s;
	if (s == world) self = spawn();
	if (self == world) { self = sv; return; } // IDEA: error msg?
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
		else if (md != "")
			fire_missile(v, mvt, 0, ct, self.origin, ' 0 0 0', cln, md, "", SUB_Null, 5 + (random() * 10), SUB_Remove, SUB_Null); // meltthink, SUB_Null);
		else
		{
			if (WARNING)
			{
			bprint("\n]nfire_burst (chaos_env.qc, 1168) called with bad parms\n");
			}
			return; // no fn, no model, nothing to do
		}

		if (cb != SUB_Null) cb();

/* TDO: later
		if (flg & FL_NEWSELF) // because of engine lightning bolt code...
			{ // just some stuff we might want
			cf_x = E_ORG | E_OWNER | E_VELOCITY | E_SIZE | E_MOVETYPE | E_SOLID | E_FLAGS | E_MORPHNUM | E_ITEMS | E_FRAME | E_AANGLES;
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



vector(vector src, float lbper, vector lbvec, float lcnt) lava_shot =
{
	return(v0);
	// TDO: finish
};

void () fire_fly_touch =
{
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
		self.think = SUB_Remove; //meltthink;
		self.nextthink = time + 5 + (random() * 4);
		self.view_ofs = ' 0 0 2';
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

"wait" - density - default 2 (2 per second)
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
		self.nextthink = MAXFL;
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
	local vector v1;
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
	self.model = "";

	if (!self.mdl) self.mdl = "progs/s_rain.spr";

	if (!DARKPLACES)
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
																								if (WARNING)
																								if (FALSE) {
																									bprint("find_dest random: ");
																									bprint(ftos(r));
																									bprint(" unit selected - ent: ");
																									bprint(e.classname);
																									bprint(" \n"); }
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

	if (clsn != "")
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

	return(p);

/*
																								if (DEVMSG)
																								if (FALSE) {
																									bprint("find_dest selected: ");
																									bprint(p.classname);
																									bprint(", ");
																									bprint(vtos(p.origin));
																									bprint("\n"); }
*/
};

// IDEA - nemesis of sphere annihilation | something similar to sphere bomb

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
	self.model = ""; // TEST:ING
};

void(vector torg, string trgname, entity trgent) chaos_teleport =
{
//	local entity tel;
	local entity s;
	
	if (self.classname == "player") s = self; // only players own these

// IDEA - get trigger field size from model sizes
	// physical ent - because trigger has no mdl
	newmis = chaos_spawn(MOVETYPE_FLY, SOLID_BBOX, 0, 0,  torg, '-12 -12 -12', ' 12 12 12', v0, v0, "chaos_teleport_icon", "progs/sphere_annihilation.mdl", SUB_Null, 2, sphere_annihilation_move, SUB_Null, s, world);
	newmis.oldorigin = torg;
	newmis.aflag = -1; //stable
//	newmis.grab_callback = chaos_teleport_grab;

// trigger
	newmis.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  torg , '-16 -16 -16', ' 16 16 16', v0, v0, "chaos_teleport", "progs/sphere_annihilation.mdl", SUB_Null, 4, chaos_trigger_teleport, SUB_Null, s, world);

//	newmis.frame = needs think fn
	newmis.skin = 1; //animated skin group
// locate target
	newmis.trigger_field.movetarget = world;
	if (trgname) newmis.trigger_field.movetarget = find (world, targetname, trgname);
	else if (trgent) newmis.trigger_field.movetarget = trgent;

	if (!newmis.trigger_field.movetarget) newmis.trigger_field.movetarget = find_tdest(0, "");

	newmis.aiment = loop_sound(newmis, CHAN_WEAPON,"alt_ambience/hum1.wav", 0.9, ATTN_NORM, 3.62, torg, 0, LOOPFOREVER);
};

