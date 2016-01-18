/*
		+---------------------------------------+
		|  Chaos code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement chaos fn for pk

// fn (chaos_spawn) - the notorious and noxious spawn 'o chaos, right out of a dunwich horror story...

// spawn an ent & set basic properties, this stuff gets set almost every spawn
// reset - if not world, then reset parms on this ent
// ow - owner, overridden by master_own if set

// mvt - movetype
// sd - solid type
// cname - classname
// md - model
// flg - flags for ent
// ct - content check flags
// org - origin, uses self.origin if '0 0 0'
// smin - min bounding box			= for setsize
// smax - max bounding box			/
// an - facing angle
// tch - touch fn
// thk - think fn
// tht - think time
// thd - die, content chk fn

entity(float mvt, float sd, float flg, float ct, vector org, vector smin, vector smax, vector an, vector vel, string cname, string md, void() tch, float tht, void() thk, void() thd, entity ow, entity reset) chaos_spawn =
{
	local entity chaos_e;

	chaos_e = reset;
	if (chaos_e == world) chaos_e = spawn ();
#ifdef warning
	else 
		if (WARNING & 1) {bprint("chaos_spawn() resetting: "); bprint(chaos_e.classname); bprint("\n"); }
#endifdef
	if (chaos_e == world) // failed to spawn, call fn still needs to check if live ent
		{
#ifdef warning
		if (WARNING & 1) bprint("chaos_spawn() - ERROR: spawn() failed, returned world!\n");
#endifdef
		return(world);
		}

// init basic stuff
//	if (master_owner)	chaos_e.owner = master_owner;
//	else 
	chaos_e.owner = ow;
	chaos_e.classname = cname;
	chaos_e.movetype = mvt;
	chaos_e.solid = sd;
	chaos_e.flags = flg;
	chaos_e.angles = an;
	chaos_e.velocity = vel;

//	chaos_e._killmsg = chaos_e._killmsg2 = chaos_e.grab_callback = 
	chaos_e.th_stand = chaos_e.th_die = 
	chaos_e.th_walk = chaos_e.th_melee = /* chaos_e.upgrade_fn = */ chaos_e.touch = SUB_Null;

	if (tch != SUB_Null) chaos_e.touch = tch;
	if (thd != SUB_Null) chaos_e.th_die = /* chaos_e.th_stand = */ thd; // gen think & content chk

	if (thk != SUB_Null) // if we need to think
		{
//		chaos_e._stand = 
		chaos_e.think = thk;
		chaos_e.nextthink = time + tht;
		}

//	if (ct) content_cycle(chaos_e, ct, CONTENT_CHKTM);

	if (org != '0 0 0') setorigin (chaos_e, org);
	else setorigin (chaos_e, self.origin);
	setmodel (chaos_e, md);
	setsize (chaos_e, smin, smax);

	return(chaos_e);
};


// fn(cnt_ent) - count all such ents on level, make chain if head ent provided

// hent - head entity for chain struct
// match - find on this field
// srch - search for this

// "owner" - search classnames - .owner must = current self
// - note: if chaining, everything found will be chained, regardless of owner

// RETURN - count of ents matching search parm

//#define cntentnext

#ifdef cntentnext
float cnt_ent_next; // use pk .next to chain up
#endifdef

float(entity hent, string match, string srch) cnt_ent =
{
	local float rc;
	local entity sr, ch;

	sr = world;
	if (match == "classname") sr = find (world, classname, srch);
	else if (match == "owner") sr = find (world, classname, srch);
	else if (match == "netname") sr = find (world, netname, srch);
	else if (match == "map") sr = find (world, map, srch);
	else if (match == "targetname") sr = find (world, targetname, srch);
//	else if (match == "class_select") sr = find (world, class_select, srch);
//	else if (match == "quakeset") sr = find (world, quakeset, srch);
//	else if (match == "scode") sr = find (world, scode, srch);
	ch = hent;

	rc = 0;
	while (sr)
	{
			if (match == "owner")
			{
				if (sr.owner == self) rc = rc + 1;
			}
			else
			rc = rc + 1;
			if (hent)
			{
#ifdef cntentnext
				if (cnt_ent_next) ch.next = sr;
				else 
#endifdef
				ch.chain = sr;
				ch = sr;
			}
			if (match == "classname") sr = find (sr, classname, srch);
			else if (match == "owner") sr = find (sr, classname, srch);
			else if (match == "netname") sr = find (sr, netname, srch);
			else if (match == "map") sr = find (sr, map, srch);
			else if (match == "targetname") sr = find (sr, targetname, srch);
//			else if (match == "class_select") sr = find (sr, class_select, srch);
//			else if (match == "quakeset") sr = find (sr, quakeset, srch);
//			else if (match == "scode") sr = find (sr, scode, srch);
	}

	if (hent) 
	{
#ifdef cntentnext
		if (cnt_ent_next) ch.next = world;
		else 
#endifdef
		ch.chain = world; // remove other potential chains left around - not even sure if this can happen
	}
#ifdef cntentnext
	cnt_ent_next = FALSE;
#endifdef

	return(rc);
}

/*
		+---------------------------------------+
		|  bit operations code                  | SEC-HEAD
		+---------------------------------------+
*/

// fn(bit_cnt) - count available bits for random selection

// fb - bits to count
// rb - return a random bit from set - if zero, return total count

float(float fb, float rb) bit_cnt =
{
	local float rs,f;

	if (fb > 0)
	{
		f = 1;
		while (f <= 8388608) // max float bits
		{
			if (f & fb) rs = rs + 1;
			f = f * 2;
		}
	}
	else
		return(0); // error cond - no bits set!

	if (!rb) return(rs);
// pick a random bit
	f = floor(random() * rs);
	rs = f;

	f = 1;
	while (f <= 8388608 && rs > -1) // max float bits
	{
		if (f & fb) rs = rs - 1;
		if (rs > -1) f = f * 2;
	}

	return(f);
};

// fn(return_bit) - return a requested bit from a value and mask if available

// bt - bit value
// msk - mask value
// op - operation
// df - default return value

float BIT_HIGH = 8388608; // start here and go down till we find first on bit
float BIT_LOW = 1;

float (float bt, float msk, float op, float df) return_bit =
{
	local float f, v, sf;

	f = op;
	v = bt;
	sf = 64;
	if (msk != 0) v = bt & msk;
	if (!v) return(df);

	while (1)
	{
		if (v & f) return (f);
		if (op == BIT_LOW) f = f * 2;
		else //if (op == BIT_HIGH) - op doesnt have to be bit high
			f = floor(f / 2);
		sf = sf - 1;
		if (sf < 0 || f < BIT_LOW || f > BIT_HIGH) return(df);
	}
	return(df); // never executes - for dumb compiler warning
};

// given a mask (max value of all 1s - does not mask bits to print), print a bit set as string of 1s & 0s

void(float msk, float bt) bit_print =
{
	local float b, f, sf ;
	local string b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11 , b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24;  

	if (msk < 1) return;
	if (bt < 1) bt = 0;

	b = fabs(bt);
	f = fabs(msk);
	sf = 24;

	while (sf > 0 && f >= 1)
	{
/*
bprint("mask: ");
bprint(ftos(f));
bprint(" bit: ");
bprint(ftos(b&1));
bprint(" sf: ");
bprint(ftos(sf));
bprint("\n");*/
		if (sf == 24) b1 = ftos(b & 1);
		else if (sf == 23) b2 = ftos(b & 1);
		else if (sf == 22) b3 = ftos(b & 1);
		else if (sf == 21) b4 = ftos(b & 1);
		else if (sf == 20) b5 = ftos(b & 1);
		else if (sf == 19) b6 = ftos(b & 1);
		else if (sf == 18) b7 = ftos(b & 1);
		else if (sf == 17) b8 = ftos(b & 1);
		else if (sf == 16) b9 = ftos(b & 1);
		else if (sf == 15) b10 = ftos(b & 1);
		else if (sf == 14) b11 = ftos(b & 1);
		else if (sf == 13) b12 = ftos(b & 1);
		else if (sf == 12) b13 = ftos(b & 1);
		else if (sf == 11) b14 = ftos(b & 1);
		else if (sf == 10) b15 = ftos(b & 1);
		else if (sf == 9) b16 = ftos(b & 1);
		else if (sf == 8) b17 = ftos(b & 1);
		else if (sf == 7) b18 = ftos(b & 1);
		else if (sf == 6) b19 = ftos(b & 1);
		else if (sf == 5) b20 = ftos(b & 1);
		else if (sf == 4) b21 = ftos(b & 1);
		else if (sf == 3) b22 = ftos(b & 1);
		else if (sf == 2) b23 = ftos(b & 1);
		else if (sf == 1) b24 = ftos(b & 1);
		b = floor(b / 2);
		f = floor(f / 2);
		sf = sf - 1;
	}
	if (sf < 1)		bprint(b24);
	if (sf < 2)		bprint(b23);
	if (sf < 3)		bprint(b22);
	if (sf < 4)		bprint(b21);
	if (sf < 5)		bprint(b20);
	if (sf < 6)		bprint(b19);
	if (sf < 7)		bprint(b18);
	if (sf < 8)		bprint(b17);
	if (sf < 9)		bprint(b16);
	if (sf < 10)	bprint(b15);
	if (sf < 11)	bprint(b14);
	if (sf < 12)	bprint(b13);
	if (sf < 13)	bprint(b12);
	if (sf < 14)	bprint(b11);
	if (sf < 15)	bprint(b10);
	if (sf < 16)	bprint(b9);
	if (sf < 17)	bprint(b8);
	if (sf < 18)	bprint(b7);
	if (sf < 19)	bprint(b6);
	if (sf < 20)	bprint(b5);
	if (sf < 21)	bprint(b4);
	if (sf < 22)	bprint(b3);
	if (sf < 23)	bprint(b2);
	if (sf <24)		bprint(b1);
};

// return 2^rl, bounded by 2^0 (lowest bit, 1) to 2^23 (highest bit, 8388608)

/*  code table:

return val		rl
------------------
1					0
2					1
4					2
8					3
16					4
32					5
64					6
128				7
256				8
512				9
1024				10
2048				11
4096				12
8192				13
16384				14
32768				15
65536				16
131072			17
262144			18
524288			19
1048576			20
2097152			21
4194304			22
8388608			23
*/

float (float rl) AdminBitFlag =
{
	local float f, e;

	f = floor(rl);
	if (f < 0 || f > 23) return(0);
	e = 1;
	while (f > 0)
	{
		f = f - 1;
		e = e * 2;
	}
	return(e);
};

// return a random bit from a mask

float(float msk) rnd_bit_mask =
{
	float f, sf, mm, b;

	if (msk < 1) return(0); // no other possibilities
	if (msk == 1) return(1);

	b = mm = 0;
	f = 1;
	if (f & msk) b = f;
	while (msk > f && mm < 23) // max out rnd selector
	{
		mm = mm + 1;
		f = AdminBitFlag(mm);
		if (!b)
		if (f & msk) b = f;
	}

	f = 0;
	sf = 100;
	while (f == 0 && sf > 0)
	{
		f = AdminBitFlag(random() * mm);
		if (! (f & msk)) f = 0;
		sf = sf - 1;
	}
	if (!f) // damn - didnt get one? - take first bit then
		f = b;
	return(f);
};


void() SUB_Nop =
{
	return;
};

void() func_model_frames =
{
	if (self.state)
	{
		self.frame = self.frame + 1;
		if (self.frame > self.state) self.frame = self.count;
	}

	if (self.dmg)
	{
		if (self.aflag)
		{
			self.skin = self.skin + 1;
			if (self.skin > self.dmg) self.skin = self.cnt;
		}
		if (self.lip)
		{
			self.skin = self.skin + self.lip;
			if (self.lip > 0)
			if (self.skin == self.dmg) self.lip = -1;
			if (self.lip < 0)
			if (self.skin == self.cnt) self.lip = 1;
		}
	}
	self.nextthink = time + self.delay;
};

// used for various effects (8 ray star & visage level decor)

void() func_model =
{
	if (self.model)
	{
		self.mdl = self.model;
		if (time < 2) precache_model (self.mdl);
		setmodel (self,self.mdl);
	}

// set these only if they are set - otherwise use defaults
	if (self.count) self.frame = self.count;
	if (self.cnt) self.skin = self.cnt;

	self.lip = self.aflag = 0;
	if (self.dmg)
	if (self.dmg < 0) self.lip = 1; // reversable loop
	else self.aflag = 1; // regular loop
	self.dmg = fabs(self.dmg);

	if (self.state || self.dmg)
	{
		if (self.delay <= 0) self.delay = 0.1;
		self.think = func_model_frames;
		self.nextthink = time + self.delay;
	}
// if mapper didnt say it can move...it cant
	if (self.map != "move") self.map = "nonmove";

// note "copystatic" - make static when copied as a template - originals must remane non static for copy data
// and this fails

	if (self.wad == "static") makestatic(self); // gone from live ents - note: archon map tech may have changeable terrain
};

// quake hack section - quake is now a roguelike

void() InitTrigger;
void() func_maphack;

// set a biome with a trigger
// see func_maphack for biome data

void() biome_use = 
{
	if (self.stack1 == "worldspawn")
		biome = world;
	else
		biome = self;
};

void() func_biome = 
{
	self.use = biome_use;
	biome = world;
};

// probe for a hack at test origin - if none found, make via func_maphack

// self is trigger ent, with maphack as its owner
// note - some ent vars are passed blind !!!

entity(vector horg) chaos_maphack_probe =
{
	self.trigger_field = world;
	self.dest = horg; //self.origin + self.rotate;
//	self.dest_z = self.owner.origin_z;
	self.goalentity = find (world, classname, "func_maphack");//self.chain; // not gonna do anything if there is not 1 existing maphack !
	self.count = 6;
	while (self.goalentity && self.count > 0)
	{
		if (self.goalentity.origin == self.dest)
		{
#ifdef warning
																			if (WARNING & 128)
																			{
																				bprint(" *** warning:   map hack found by load trigger: ");
																				bprint(vtos(self.goalentity.origin));
																				bprint(", desired: ");
																				bprint(vtos(self.dest));
																				bprint(", trigger owner at: ");
																				bprint(vtos(self.owner.origin));
																				bprint("\n");
																			}
#endifdef
				self.count = 0;
		}
		else
			self.goalentity = find (self.goalentity, classname, "func_maphack");
//		self.goalentity = self.goalentity.chain;
//		self.count = self.count - 1;
	}

	if (self.count) // nothing found there - make it
//	if (!self.goalentity)
	{
		self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.dest , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.2, func_maphack, SUB_Null, self.owner, world);
//		self.trigger_field.origin_z = self.owner.origin_z;

// this is where we can do biomes
		if (biome)
		{
			self.trigger_field.mean = biome.mean;
			self.trigger_field.stdev = biome.stdev;
			self.trigger_field.count = biome.count;
			self.trigger_field.cnt = biome.cnt;
			self.trigger_field.delay = biome.delay;
			self.trigger_field.map = biome.map;
			self.trigger_field.rotate_type = biome.rotate_type;
			self.trigger_field.lefty = biome.lefty;
			self.trigger_field.stack1 = biome.stack1;
			self.trigger_field.stack2 = biome.stack2;
			self.trigger_field.stack3 = biome.stack3;
			self.trigger_field.stack4 = biome.stack4;
			self.trigger_field.stack5 = biome.stack5;
			self.trigger_field.stack6 = biome.stack6;
			self.trigger_field.stack7 = biome.stack7;
			self.trigger_field.stack8 = biome.stack8;
			self.trigger_field.stack9 = biome.stack9;
			self.trigger_field.stack10 = biome.stack10;
			self.trigger_field.stack11 = biome.stack11;
			self.trigger_field.stack12 = biome.stack12;
			self.trigger_field.stack13 = biome.stack13;
			self.trigger_field.stack14 = biome.stack14;
			self.trigger_field.stack15 = biome.stack15;
			self.trigger_field.stack16 = biome.stack16;
			self.trigger_field.target1 = biome.target1;
			self.trigger_field.target2 = biome.target2;
			self.trigger_field.group = biome.group;
			self.trigger_field.rad_time = biome.rad_time;
		}
		else
		{
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.lefty = self.lefty;
			self.trigger_field.stack1 = self.stack1;
			self.trigger_field.stack2 = self.stack2;
			self.trigger_field.stack3 = self.stack3;
			self.trigger_field.stack4 = self.stack4;
			self.trigger_field.stack5 = self.stack5;
			self.trigger_field.stack6 = self.stack6;
			self.trigger_field.stack7 = self.stack7;
			self.trigger_field.stack8 = self.stack8;
			self.trigger_field.stack9 = self.stack9;
			self.trigger_field.stack10 = self.stack10;
			self.trigger_field.stack11 = self.stack11;
			self.trigger_field.stack12 = self.stack12;
			self.trigger_field.stack13 = self.stack13;
			self.trigger_field.stack14 = self.stack14;
			self.trigger_field.stack15 = self.stack15;
			self.trigger_field.stack16 = self.stack16;
			self.trigger_field.target1 = self.target1;
			self.trigger_field.target2 = self.target2;
			self.trigger_field.group = self.group;
			self.trigger_field.rad_time = self.rad_time;
		}
		self.trigger_field.spawnflags = 17; // rose red

#ifdef warning
																			if (WARNING & 128)
																			{
																				bprint(" *** warning:  *map hack load trigger made chunk: ");
																				bprint(vtos(self.trigger_field.origin));
																				bprint("\n");
																			}
#endifdef
	}
	return(self.trigger_field);
};

// rotate will contain sizing of chunks later

// make chunks

void() chaos_maphack_touch =
{
	if (other.classname != "pk*bot")
	if (other.classname != "player")
		return;

	if (self.group == "start")
	if (autobiome < 1)
	{
		autobiome = self.rad_time;
		if (!autobiome) autobiome = 24; // default - build 24 chunks
	}
// find all hacks
//	cnt_ent(self, "classname", "func_maphack");

// test destination location - 8 ray star

//	self.dest1 = self.owner.origin + '512 0 0';
	self.dest1 = self.owner.origin;
	self.dest1_x = self.dest1_x + self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '512 512 0';
	self.dest1_y = self.dest1_y + self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '-512 0 0';
	self.dest1 = self.owner.origin;
	self.dest1_x = self.dest1_x - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '-512 -512 0';
	self.dest1_y = self.dest1_y - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '0 512 0';
	self.dest1 = self.owner.origin;
	self.dest1_y = self.dest1_y + self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '-512 512 0';
	self.dest1_x = self.dest1_x - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '0 -512 0';
	self.dest1 = self.owner.origin;
	self.dest1_y = self.dest1_y - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '512 -512 0';
	self.dest1_x = self.dest1_x + self.lefty;
	chaos_maphack_probe(self.dest1);


/*
#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint("\n"); // blank a line for 8 set
//																			}
#endifdef
	if (self.cnt == 45) // corners get 2 more chunks
	{
// test destination location
		self.mangle_x = self.rotate_x;
		self.dest = self.origin + self.mangle;
		self.dest_z = self.owner.origin_z;
		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.dest)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack found by load corner x trigger: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", desired: ");
																					bprint(vtos(self.dest));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - performing tests\n");
	//																			}
	#endifdef
					self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}

		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.dest , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.origin_z = self.owner.origin_z;
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.mangle;
			self.trigger_field.cnt = 0;
			self.trigger_field.spawnflags = 17;

#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint(" *** warning:   map hack load trigger made corner x chunk: ");
																				bprint(vtos(self.trigger_field.origin));
																				bprint(", owner at: ");
																				bprint(vtos(self.owner.origin));
																				bprint(" - making 2nd chunk\n");
//																			}
#endifdef
		}

		self.angles_y = self.rotate_y;
		self.dest = self.origin + self.angles;
		self.dest_z = self.owner.origin_z;
		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.dest)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack found by load corner y trigger: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", desired: ");
																					bprint(vtos(self.dest));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - performing tests\n");
	//																			}
	#endifdef
					self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}

		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.dest , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.origin_z = self.owner.origin_z;
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.angles;
			self.trigger_field.cnt = 90;
			self.trigger_field.spawnflags = 17;

#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint(" *** warning:   map hack load trigger made corner y chunk: ");
																				bprint(vtos(self.trigger_field.origin));
																				bprint(", owner at: ");
																				bprint(vtos(self.owner.origin));
																				bprint(" - done\n");
//																			}
#endifdef
		}
	}
	else

// test sides any time we build out and not in corner
	{
		if (self.rotate_x != 0)
		{
			self.pos1 = self.pos2 = self.owner.origin;
			self.pos1_y = self.pos1_y + 512;
			self.pos2_y = self.pos2_y - 512;
			self.trigger_field.pos1 = self.pos1;
			self.trigger_field.pos2 = self.pos2;
		}
		else if (self.rotate_y != 0)
		{
			self.pos1 = self.pos2 = self.owner.origin;
			self.pos1_x = self.pos1_x + 512;
			self.pos2_x = self.pos2_x - 512;
			self.trigger_field.pos1 = self.pos1;
			self.trigger_field.pos2 = self.pos2;
		}

		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.pos1)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise found pos1: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", tested: ");
																					bprint(vtos(self.pos1));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - moving on\n");
	//																			}
	#endifdef
				self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}
		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.pos1 , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.rotate;
			self.trigger_field.cnt = self.cnt;
			self.trigger_field.spawnflags = 17;
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise made chunk at pos1: ");
																					bprint(vtos(self.pos1));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - testing pos2\n");
	//																			}
	#endifdef
		}

		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.pos2)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise found pos2: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", tested: ");
																					bprint(vtos(self.pos2));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - moving on\n");
	//																			}
	#endifdef
				self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}
		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.pos2 , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.rotate;
			self.trigger_field.cnt = self.cnt;
			self.trigger_field.spawnflags = 17;
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise made chunk at pos2: ");
																					bprint(vtos(self.pos2));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - done\n");
	//																			}
	#endifdef
		}

	}
*/ 
};

// auto load some biome, like lava

float autobiome;

void() chaos_maphack_touch =
{
	if (other.classname != "pk*bot")
	if (other.classname != "player")
		return;

	if (self.group == "start")
	if (autobiome < 1)
	{
		autobiome = self.rad_time;
		if (!autobiome) autobiome = 24; // default - build 24 chunks
	}
// find all hacks
//	cnt_ent(self, "classname", "func_maphack");

// test destination location - 8 ray star

//	self.dest1 = self.owner.origin + '512 0 0';
	self.dest1 = self.owner.origin;
	self.dest1_x = self.dest1_x + self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '512 512 0';
	self.dest1_y = self.dest1_y + self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '-512 0 0';
	self.dest1 = self.owner.origin;
	self.dest1_x = self.dest1_x - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '-512 -512 0';
	self.dest1_y = self.dest1_y - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '0 512 0';
	self.dest1 = self.owner.origin;
	self.dest1_y = self.dest1_y + self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '-512 512 0';
	self.dest1_x = self.dest1_x - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '0 -512 0';
	self.dest1 = self.owner.origin;
	self.dest1_y = self.dest1_y - self.lefty;
	chaos_maphack_probe(self.dest1);

//	self.dest1 = self.owner.origin + '512 -512 0';
	self.dest1_x = self.dest1_x + self.lefty;
	chaos_maphack_probe(self.dest1);


#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint("\n"); // blank a line for 8 set
//																			}
#endifdef
/*
	if (self.cnt == 45) // corners get 2 more chunks
	{
// test destination location
		self.mangle_x = self.rotate_x;
		self.dest = self.origin + self.mangle;
		self.dest_z = self.owner.origin_z;
		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.dest)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack found by load corner x trigger: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", desired: ");
																					bprint(vtos(self.dest));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - performing tests\n");
	//																			}
	#endifdef
					self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}

		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.dest , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.origin_z = self.owner.origin_z;
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.mangle;
			self.trigger_field.cnt = 0;
			self.trigger_field.spawnflags = 17;

#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint(" *** warning:   map hack load trigger made corner x chunk: ");
																				bprint(vtos(self.trigger_field.origin));
																				bprint(", owner at: ");
																				bprint(vtos(self.owner.origin));
																				bprint(" - making 2nd chunk\n");
//																			}
#endifdef
		}

		self.angles_y = self.rotate_y;
		self.dest = self.origin + self.angles;
		self.dest_z = self.owner.origin_z;
		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.dest)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack found by load corner y trigger: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", desired: ");
																					bprint(vtos(self.dest));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - performing tests\n");
	//																			}
	#endifdef
					self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}

		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.dest , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.origin_z = self.owner.origin_z;
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.angles;
			self.trigger_field.cnt = 90;
			self.trigger_field.spawnflags = 17;

#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint(" *** warning:   map hack load trigger made corner y chunk: ");
																				bprint(vtos(self.trigger_field.origin));
																				bprint(", owner at: ");
																				bprint(vtos(self.owner.origin));
																				bprint(" - done\n");
//																			}
#endifdef
		}
	}
	else

// test sides any time we build out and not in corner
	{
		if (self.rotate_x != 0)
		{
			self.pos1 = self.pos2 = self.owner.origin;
			self.pos1_y = self.pos1_y + 512;
			self.pos2_y = self.pos2_y - 512;
			self.trigger_field.pos1 = self.pos1;
			self.trigger_field.pos2 = self.pos2;
		}
		else if (self.rotate_y != 0)
		{
			self.pos1 = self.pos2 = self.owner.origin;
			self.pos1_x = self.pos1_x + 512;
			self.pos2_x = self.pos2_x - 512;
			self.trigger_field.pos1 = self.pos1;
			self.trigger_field.pos2 = self.pos2;
		}

		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.pos1)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise found pos1: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", tested: ");
																					bprint(vtos(self.pos1));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - moving on\n");
	//																			}
	#endifdef
				self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}
		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.pos1 , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.rotate;
			self.trigger_field.cnt = self.cnt;
			self.trigger_field.spawnflags = 17;
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise made chunk at pos1: ");
																					bprint(vtos(self.pos1));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - testing pos2\n");
	//																			}
	#endifdef
		}

		self.goalentity = self.chain;
		self.count = 500; // could be more eventually
		while (self.goalentity && self.count > 0)
		{
			if (self.goalentity.origin == self.pos2)
			{
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise found pos2: ");
																					bprint(vtos(self.goalentity.origin));
																					bprint(", tested: ");
																					bprint(vtos(self.pos2));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - moving on\n");
	//																			}
	#endifdef
				self.count = 0;
			}
			else
			self.goalentity = self.goalentity.chain;
			self.count = self.count - 1;
		}
		if (self.chain)
		if (!self.goalentity) // nothing there - make it
		{
			self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.pos2 , '-16 -16 -16', '16 16 16', v0, v0, "func_maphack", "", SUB_Null, 0.3, func_maphack, SUB_Null, self, world);
			self.trigger_field.rotate_type = self.rotate_type;
			self.trigger_field.rotate = self.rotate;
			self.trigger_field.cnt = self.cnt;
			self.trigger_field.spawnflags = 17;
	#ifdef warning
	//																			if (WARNING & 128)
	//																			{
																					bprint(" *** warning:   map hack sidewise made chunk at pos2: ");
																					bprint(vtos(self.pos2));
																					bprint(", owner at: ");
																					bprint(vtos(self.owner.origin));
																					bprint(" - done\n");
	//																			}
	#endifdef
		}

	}
*/ 

	remove(self);
};

void() chaos_maphack_trigger =
{
	if (autobiome >= 0)
	{
		chaos_maphack_touch();
		autobiome = autobiome - 1;

#ifdef warning
//																			if (WARNING & 128)
//																			{
																				bprint(" *** warning:   map hack autobiome: ");
																				bprint(vtos(self.origin));
																				bprint(", owner at: ");
																				bprint(vtos(self.owner.origin));
																				bprint(" - done\n");
//																			}
#endifdef

		remove(self);
	}
	else
	{
		InitTrigger ();
		self.touch = chaos_maphack_touch;
		self.model = null_string;
		self.dest1_x = 0 - (self.lefty / 2);
		self.dest1_y = 0 - (self.lefty / 2);
		self.dest1_z = -16;
		self.dest2_x = self.lefty / 2;
		self.dest2_y = self.lefty / 2;
		self.dest2_z = 2048; // note - flyer issues
		
		setsize(self, self.dest1, self.dest2);
	}
};

// fade hack chunks in from 0.1

void() maphack_poof =
{
	if (self.alpha < 1)
	{
		self.nextthink = time + 0.2;
		self.alpha = self.alpha + 0.05;
	}
};

/*

miserable failure

void() copy_static =
{
	makestatic(self);
};
*/

// fn(func_maphack) - quake hack function

// like nethack - random quake level rooms, v1.0

// state - map segment to load as model

/*QUAKED func_maphack (.6 .1 .6) (-8 -8 -8) (8 8 8) FADEIN null null null AUTOLOAD
--------  CAT  -------
Chaos Mod MK II

spawnflags = 16			- auto load next chunk

Select a random map segment for quake hack mode maps

map segment:

"mean"			"#"		- start number - 1 default
"stdev"			"#"		- randomize this #, if 0 will count stack*
"count"			"#"		- prefer this segment number (> 0)
"cnt"			"#"		- preference percent for "count" - 0.3 default
"map"			"{name}"	- use this named segment
"delay"			"#"		- reset after delay rels if "map" not set
"rotate_type"	"1"		- rotate random 90 deg. incr
"lefty"			"#"     - trigger size set - total size value, must be + and evenly divisible by 2
"group"			"start"	- use auto fire trigger on this biome
"rad_time"		"#"		- number of times to auto fire
"stack*"        "map"   - map segments to randomize - 1 to 16 - stack1 MUST be set, probabilty of choice is equal unless --v
"button*"       "#"     - probability for each biome from 0 - 1000, if not assigned standard randomizer is used

targets:
"target1"       "{n}"   - list of ents to copy
"target2"       "{n}"   - list of ents to randomly copy
- will copy relative to 0,0,0 of maphack source
- ents that have model blank and mdl will set new models to mdl
*/

void() func_maphack =
{
	if (self.map)
	{
		self.mdl = self.map;
		setmodel (self,self.mdl);
		self.delay = 0;
		return;
	}

	if (self.mean <= 0) self.mean = 1;
	if (!self.stdev)
	{
		if (self.stack1) self.stdev = self.stdev + 1;
		if (self.stack2) self.stdev = self.stdev + 1;
		if (self.stack3) self.stdev = self.stdev + 1;
		if (self.stack4) self.stdev = self.stdev + 1;
		if (self.stack5) self.stdev = self.stdev + 1;
		if (self.stack6) self.stdev = self.stdev + 1;
		if (self.stack7) self.stdev = self.stdev + 1;
		if (self.stack8) self.stdev = self.stdev + 1;
		if (self.stack9) self.stdev = self.stdev + 1;
		if (self.stack10) self.stdev = self.stdev + 1;
		if (self.stack11) self.stdev = self.stdev + 1;
		if (self.stack12) self.stdev = self.stdev + 1;
		if (self.stack13) self.stdev = self.stdev + 1;
		if (self.stack14) self.stdev = self.stdev + 1;
		if (self.stack15) self.stdev = self.stdev + 1;
		if (self.stack16) self.stdev = self.stdev + 1;
	}

// all chuncks have equal chance of being chosen, unless button* values set

	self.state = self.mean + rint(fabs(self.stdev) * random());

// biome provides probability on a per-chunk basis - we think so anyway

	if (biome)
	if (biome.button1)
	{
		self.aflag = rint(random() * 1000);
		self.aflag = self.aflag - biome.button1;
		if (self.aflag <= 0) self.state = 1;
		self.aflag = self.aflag - biome.button2;
		if (self.aflag <= 0) self.state = 2;
		self.aflag = self.aflag - biome.button3;
		if (self.aflag <= 0) self.state = 3;
		self.aflag = self.aflag - biome.button4;
		if (self.aflag <= 0) self.state = 4;
		self.aflag = self.aflag - biome.button5;
		if (self.aflag <= 0) self.state = 5;
		self.aflag = self.aflag - biome.button6;
		if (self.aflag <= 0) self.state = 6;
		self.aflag = self.aflag - biome.button7;
		if (self.aflag <= 0) self.state = 7;
		self.aflag = self.aflag - biome.button8;
		if (self.aflag <= 0) self.state = 8;
		self.aflag = self.aflag - biome.button9;
		if (self.aflag <= 0) self.state = 9;
		self.aflag = self.aflag - biome.button10;
		if (self.aflag <= 0) self.state = 10;
		self.aflag = self.aflag - biome.button11;
		if (self.aflag <= 0) self.state = 11;
		self.aflag = self.aflag - biome.button12;
		if (self.aflag <= 0) self.state = 12;
		self.aflag = self.aflag - biome.button13;
		if (self.aflag <= 0) self.state = 13;
		self.aflag = self.aflag - biome.button14;
		if (self.aflag <= 0) self.state = 14;
		self.aflag = self.aflag - biome.button15;
		if (self.aflag <= 0) self.state = 15;
		self.aflag = self.aflag - biome.button16;
		if (self.aflag <= 0) self.state = 16;
	}

	if (self.count)
	{
		if (!self.cnt) self.cnt = 0.3;
		if (self.cnt < random())
			self.state = self.count;
	}

	if (self.stack1)
	{
		self.mdl = self.stack1;
//		if (self.state == 1) self.mdl = self.stack1;
		if (self.state == 2 && self.stack2) self.mdl = self.stack2;
		if (self.state == 3 && self.stack3) self.mdl = self.stack3;
		if (self.state == 4 && self.stack4) self.mdl = self.stack4;
		if (self.state == 5 && self.stack5) self.mdl = self.stack5;
		if (self.state == 6 && self.stack6) self.mdl = self.stack6;
		if (self.state == 7 && self.stack7) self.mdl = self.stack7;
		if (self.state == 8 && self.stack8) self.mdl = self.stack8;
		if (self.state == 9 && self.stack9) self.mdl = self.stack9;
		if (self.state == 10 && self.stack10) self.mdl = self.stack10;
		if (self.state == 11 && self.stack11) self.mdl = self.stack11;
		if (self.state == 12 && self.stack12) self.mdl = self.stack12;
		if (self.state == 13 && self.stack13) self.mdl = self.stack13;
		if (self.state == 14 && self.stack14) self.mdl = self.stack14;
		if (self.state == 15 && self.stack15) self.mdl = self.stack15;
		if (self.state == 16 && self.stack16) self.mdl = self.stack16;		
	}
	else // TEST: remove this
	if (world.model == "maps/x4_1.bsp")
	{
		self.mdl = "maps/x4_6.bsp";
		if (self.state < 2) self.mdl = "maps/x4_1.bsp";
		if (self.state == 2) self.mdl = "maps/x4_2.bsp";
		if (self.state == 3) self.mdl = "maps/x4_3.bsp";
		if (self.state == 4) self.mdl = "maps/x4_4.bsp";
		if (self.state == 5) self.mdl = "maps/x4_5.bsp";
		if (self.state > 5) self.mdl = "maps/x4_6.bsp";
		self.lefty = 512;
	}


	if (self.rotate_type)
	{
		self.aflag = 1;
		if (self.rotate_type > 1) // FIX: make 0.1 - 0.9 for rotating all pieces
		{
			if (self.state != floor(self.rotate_type)) self.aflag = 0;
// trick to encode 2 rotates, could do more
			self.msgcount = (self.rotate_type - floor(self.rotate_type)) * 10;
			if (self.state == self.msgcount) self.aflag = 1;
		}

		if (self.aflag)
			self.angles_y = rint(3.3 * random()) * 90;
	}

	if (self.delay > 0) // idea: fade replace?
	{
		self.nextthink = time + self.delay;
		self.think = func_maphack;
	}

	setmodel (self,self.mdl);
//	self.model = self.mdl;

	self.solid = SOLID_BSP; // map piece

	if (self.target1)
	{
		cnt_ent(self, "targetname", self.target1);
		self.dropent = self.chain;
		while (self.dropent)
		{
			self.aiment = spawn();
			copyentity(self.dropent, self.aiment);
			self.aiment.targetname = "";
			setorigin(self.aiment, self.origin + self.dropent.origin);
			if ((self.aiment.classname == "func_model") || (self.aiment.classname == "misc_model"))
			if (self.spawnflags & 1)
			{
				self.aiment.alpha = 0.05;
				self.aiment.think = maphack_poof;
				self.aiment.nextthink = time + 0.2;
			}
			if (!self.aiment.model) setmodel(self.aiment, self.aiment.mdl);
//			if (self.aiment.wad == "copystatic")
//			{
//				self.aiment.think = copy_static;
//				self.aiment.nextthink = time + 0.1 + random();
//			}
			self.dropent = self.dropent.chain;
		}
	}

	if (self.target2)
	{
		self.aflag = cnt_ent(self, "targetname", self.target2);
		self.dropent = self.chain;
		while (self.dropent)
		{
			if (!self.dropent.lefty) self.dropent.lefty = 0.3;
			if (random() < self.dropent.lefty)
			{
				self.aiment = spawn();
				copyentity(self.dropent, self.aiment);
				self.aiment.targetname = "";
				if ((self.aiment.classname == "func_model") || (self.aiment.classname == "misc_model"))
				if (self.spawnflags & 1)
				{
					self.aiment.alpha = 0.05;
					self.aiment.think = maphack_poof;
					self.aiment.nextthink = time + 0.2;
				}
				setorigin(self.aiment, self.origin + self.dropent.origin);
				if (!self.aiment.model) setmodel(self.aiment, self.aiment.mdl);
//				if (self.aiment.wad == "copystatic") makestatic(self.aiment);
			}
		self.dropent = self.dropent.chain;
		}
	}

// build trigger
	if (self.spawnflags & 16)
	{

// trigger
		self.trigger_field = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0,  self.origin + '0 0 64' , '-16 -16 -16', '16 16 16', v0, v0, "maphack_trigger", "", SUB_Null, 0.5, chaos_maphack_trigger, SUB_Null, self, world);

		self.trigger_field.rotate_type = self.rotate_type;
		self.trigger_field.lefty = self.lefty;

		self.trigger_field.stack1 = self.stack1;
		self.trigger_field.stack2 = self.stack2;
		self.trigger_field.stack3 = self.stack3;
		self.trigger_field.stack4 = self.stack4;
		self.trigger_field.stack5 = self.stack5;
		self.trigger_field.stack6 = self.stack6;
		self.trigger_field.stack7 = self.stack7;
		self.trigger_field.stack8 = self.stack8;
		self.trigger_field.stack9 = self.stack9;
		self.trigger_field.stack10 = self.stack10;
		self.trigger_field.stack11 = self.stack11;
		self.trigger_field.stack12 = self.stack12;
		self.trigger_field.stack13 = self.stack13;
		self.trigger_field.stack14 = self.stack14;
		self.trigger_field.stack15 = self.stack15;
		self.trigger_field.stack16 = self.stack16;
		self.trigger_field.target1 = self.target1;
		self.trigger_field.target2 = self.target2;
		self.trigger_field.group = self.group;
		self.trigger_field.rad_time = self.rad_time;
	}

	if (self.spawnflags & 1)
	{
		self.alpha = 0.05;
		self.think = maphack_poof;
		self.nextthink = time + 0.2;
	}
};

// fn(loop_sound) - play a sound looped until stopped by remove, halt or search_time exceeded
// fn(loop_play) - plays loop sounds at given interval self.

// emulate looped ambient sounds - should be accurate to a fraction of rels

// p - entity owning sound						.owner
// chan - sound channel							.cnt
// sd - sound wave to play						.noise1
// vl - volume level								.volume
// attn - attenuation setting					.aflag
// tm - time to loop sound						.delay - checked in .delay
// org1 - location of sound					.origin
// halt - if true stop sound matching entity p
// end - + time - time after which this sound ends .search_time

string LOOPSOUND = "sound_loop";
float LOOPFOREVER = 100000000000;

void() loop_play = 
{
	local entity p, q;

	q = find(world, classname, LOOPSOUND);
	while (q)
	{
//		if (q.weaponframe == framecount) return;
		p = find(q, classname, LOOPSOUND);
//		q.weaponframe = framecount;
		if (q.search_time < time) // done - remove
		{
			sound (q, q.cnt,"misc/null.wav",1,ATTN_NORM);
			remove(q);
		}
		else if (q.distance < time) // hit time, replay
		{
			q.distance = time + q.delay;
			sound (q, q.cnt, q.noise1, q.volume, q.aflag);
//			if (DEVMSG) bprint("playing: "); bprint(q.noise1); newline(world);
		}
		q = p;
	}
};

entity(entity p, float chan, string sd, float vl, float attn, float tm, vector org1, float halt, float end) loop_sound =
{
	local entity q;
	local vector org;

	q = world;
/*

// for now this code just makes the new sound

	q = find(world, classname, LOOPSOUND);
	while (q)
	{
		if (q.owner == p && sd == q.noise1)
		{
			if (halt) { remove(q); return world; }
			else if (DEVMSG) { bprint("sound already playing: "); bprint(q.noise1); newline(world); }
			q.delay = tm;
			q.search_time = time + end;
			return q;
		}
		q = find(q, classname, LOOPSOUND);
	}
*/
	if (!q) // make new sound
	{
		org = org1;
		if (org == v0) org = p.origin;
		q = chaos_spawn(MOVETYPE_NONE, 0, 0, 0,  org, v0, v0, v0, v0, LOOPSOUND, null_string, SUB_Null, 0, SUB_Null, SUB_Null, p, world);
		q.cnt = chan;
		q.noise1 = sd;
		q.volume = vl;
		q.aflag = attn;
		q.delay = tm;
		q.distance = 0;
		q.search_time = time + end;
		return(q);
	}
	return(world);  // Cataboligne - 8.7.13 - compiler warning - what would this be, fail?
}

// fn(ominous_hum) - idle sound for some weps
// ws - weapon sound
// rtime - time to loop - if zero play ws once
.float chaosweptime;
float hum_chan; // channel for hum - must be set prior to call, always reset to CHAN_WEAPON

void(string ws, float rtime) ominous_hum =
{
	if (WEPHUM)
	{
		if (!rtime)
		{
			self.chaosweptime = MAXFL;
			sound (self, hum_chan, ws, 1, ATTN_NORM);
		}
		else if (self.chaosweptime < time)
		{
			sound (self, hum_chan, "misc/null.wav", 1, ATTN_NORM);
			if (intermission_running)
				return;
			else if (ws != null_string)
			{
				sound (self, hum_chan, ws, 1, ATTN_NORM);
				self.chaosweptime = time + rtime;
			}
		}
		hum_chan = CHAN_WEAPON;
	}
};

// fn(newline) print newline to self client screen

/*
 deprecated - pointless

void(entity e) newline =
{
if (e) sprint(e,"\n");
else bprint("\n");
}
*/




// fn(sky_touch) - new sky tex missile / object strike test - called by touch fns, as touch or think fn
// fn(sky_touch_pointer) - touch / think fn redirect - if called as touch or think does remove if RM_SKY set in content flags

// operation
// - 2 tests for origin v or entity e.origin + norm(e.velocity) * 10 - pointcontents and surface (darkplaces)
// - if surf non blank its value will be tested and disregard all other info

// return - TRUE if object is touching (near?) sky
// sets global string last texture for other code to reference

// e - passed entity, if world, try self, if self == world return FALSE

// IDEA: limit re-entry

/* sky list - so far

sky1, sky4 - quake 1 default skies
sky6 - chaos maps, black was also used for castle arioch - needs to be sky_black
sky2 - gallery map
sky0 - doom e1m1 q1 map, latest
skydark - stonehenge (thick enough for content check)

texture/ * skies - q3 maps
*/

float(string surf, vector v, entity e) sky_touch =
{
	local entity f;
	local float t, surfnum2;
//	local string s3;
	string last_texture;

	if (XENV) return(FALSE);
	if (!DARKPLACES) return(FALSE); // Cat - 8.14.11 - fix fteqw bug

	if (surf == null_string) // note - no q1 mode qual on surface string
	{
		surfnum2 = -1;
		t = FALSE;
		f = e;
		if (v == v0 && !f) f = self;
		if (v == v0 && f) v = f.origin + normalize(f.velocity) * 10;
		if (v == v0) return(t);

		if (pointcontents(v) == CONTENT_SKY) t = TRUE;

		last_texture = null_string;
		surfnum2 = getsurfacenearpoint(world, v);
	}

// new sky contents code

	if (surfnum2 >= 0 || surf != null_string)
	{
		if (surf == null_string) last_texture = getsurfacetexture(world, surfnum2);
		else last_texture = surf;
		if (last_texture == "sky1" || last_texture == "sky4" || last_texture == "sky0" || last_texture == "sky2" || last_texture == "sky6") t = TRUE;
		else if (last_texture == "firey_") t = TRUE;
		else if (last_texture == "s6_") t = TRUE;
		else if (last_texture == "dsky1_") t = TRUE;
		else if (last_texture == "d2_sky1_rmd_") t = TRUE;
		else if (last_texture == "textures/K_sky/rabbit_skybox" || last_texture == "textures/skies/pjbasesky_arena1_sky") t = TRUE;
		else if (last_texture == "graveyard/grave_") t = TRUE;
		else if (last_texture == "skydark") t = TRUE;
		else if (last_texture == "c1_") t = TRUE;
		else if (last_texture == "unit5_") t = TRUE;
		else if (last_texture == "mandr_") t = TRUE;
		else if (last_texture == "snow2_") t = TRUE;
	}

	return(t);
};

void() sky_touch_pointer =
{

// UNKNOWN op - decide what is happening with this code
//	if (sky_touch(null_string, v0, self))
//	if (self.content_flag & RM_SKY) // has a remove sky setting - wont work after content_clear
//		SUB_Remove();

// IDEA: rethink code here if called as a think fn, till timeout
};


// fn(rnd_string) - randomly select one of 5 strings - great for sounds
// wt - weight seq. 1-100, if '0 0 0' chances are equal, example - for 50% rs1, 25% rs2, 12% rs3, 7% rs4, 3% rs5
//		  % for rs4 and rs5 are interpolated - w4 = z * (z / x)		 '50 25 12'
/*
		between 51 - 100 = rs1, 26 - 50 = rs2, 13 - 25 = rs3, 4 - 12 = rs4, < 4 = rs5
		THESE MUST BE IN ORDER WITH X THE LARGEST! - x > y > z AND x CANNOT be 0!
		rs1-5 strings, will return NULL if rs1 is NULL, other NULL string will not be selected
		i.e. if rs1 is the only non NULL string, it will always be the outcome

for 2 strings in rs1, rs5 
for 50/50 wt = '50 50 50'
for 75/25 wt = '75 75 75', string rs1 will be 25%
*/

string(vector wt, string rs1, string rs2, string rs3, string rs4, string rs5) rnd_string =
{
	local float w1,w2,w3,w4,rstr,cv;
	local string sl;

	sl = null_string;
	cv = 1;

	if (wt == '0 0 0') wt = ' 80.0 60.0 40.0';
	w1 = wt_x;
	w2 = wt_y;
	w3 = wt_z;
	w4 = ceil(wt_z * (wt_z / wt_x)); // gives 20 if chances eq. - 80 60 40 20

	if (rs1 != null_string)
	while (sl == null_string) 
		{
		rstr = rint(random() * 100); // 1-100
		sl = rs5;
		if (rstr > w4) sl = rs4;
		if (rstr > w3) sl = rs3;
		if (rstr > w2) sl = rs2;
		if (rstr > w1 || cv > 10) sl = rs1; // dont go past 10 iterations
		cv = cv + 1;
		}
	return sl;
};


/*QUAKED trigger_hurt_switch (.5 .5 .5) ? START_OFF
Switchable - when target is called .touch will toggle
wait - time between toggles, if -1 switch is disabled after 1 call
delay - time elapse before toggle when target called
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
frags - take away this many upon death, default 0
noise*  - custom death messages to give

spawnflags & 1 - start off
deadflag & 2 - use noenvcide if enabled - frags must be set, default is 1

custom message = self.noise - one obituary string
deadflag & 1 - print target name first
random:
noise2, noise3, noise4 - string for obituary
cnt = rnd chance of 2 vs 3 - default 50%
style = separate rnd chance of 4 if set - default 10%
*/
void() InitTrigger;
void () hurt_touch;

void() hurt_switch =
{
	if (self.classname == "hurt_trigger_delay") // delayed effect
	{
		if (self.enemy)
		if (self.enemy.touch == hurt_touch)
			self.enemy.touch = SUB_Nop;
		else
			self.enemy.touch = hurt_touch;
		remove(self);
		return;
	}

	if (self.attack_finished > time) return; // cant toggle right now

// setup msg - done in map ent
//	self.deadflag = self.deadflag | 1;
	if (self.noise2 != null_string && self.noise3 != null_string)
	{
		if (self.cnt <= 0) self.cnt = 0.5;
		if (self.style <= 0) self.style = 0.1;
		if (random() < self.cnt)
			self.noise = self.noise2; //" turned into hot slag";
		else
			self.noise = self.noise3; // " visits the Volcano God";
		if (self.noise4 != null_string)
		if (random() < self.style)
			self.noise = self.noise4; // " is playing geologist again";
	}
	else
	if (self.noise == null_string && self.noise2 != null_string || self.noise3 != null_string)
	{
		if (self.noise2 != null_string) self.noise = self.noise2;
		if (self.noise3 != null_string) self.noise = self.noise3;
	}
	if (self.noise != null_string)
		self.class_select = "CDM"; // custom death msg

	if (self.wait)
	{
		if (self.wait < 0)
			self.use = SUB_Nop;
		else
			self.attack_finished = time + self.wait;
	}

	if (self.delay)
	{
		local entity e;
		e = spawn();
		e.classname = "hurt_trigger_delay";
		e.think = hurt_switch;
		e.nextthink = time + self.delay;
		e.enemy = self;
		return;
	}

	if (self.touch == hurt_touch)
		self.touch = SUB_Nop;
	else
		self.touch = hurt_touch;
};

void () trigger_hurt_switch =
{
	InitTrigger ();
	if ((self.spawnflags & 1) && self.targetname != null_string) // if no targetname is given this becomes a regular hurt trigger!
		self.touch = SUB_Nop;
	else
		self.touch = hurt_touch;

	if (!self.dmg)
		self.dmg = 5;

	if (self.deadflag & 2)
	if (!self.frags)
		self.frags = 1;

	if (self.targetname)
		self.use = hurt_switch;
};

// fn(notmod) - test to see of entity should be in mod - if not, remove
// also test dp/c

/*
	affects (thus far)

	doors
	func_wall
	func_illusionary
	trigger_*

!mod2 - to be added (same as !mod) when visage specials done

*/

float(entity e) notmod =
{

	if (e.wad == "!mod" || e.netname == "!mod")
	{
		remove(e);
		return(TRUE);
	}

	if (DARKPLACES || chaos)
	if (e.wad == "!dpc" || e.netname == "!dpc") // cant have it
	{
		remove(e);
		return(TRUE);
	}

	if (!DARKPLACES && !chaos)
	if (e.wad == "dpc" || e.netname == "dpc") // required by
	{
		remove(e);
		return(TRUE);
	}

// !dp is the mode for all darkplaces only stuff wall blocks - so the func_wall will exist everywhere but dp
	if (DARKPLACES)
	if (e.wad == "!dp" || e.netname == "!dp")
	{
		remove(e);
		return(TRUE);
	}

	if (!DARKPLACES)
	if (e.wad == "dp" || e.netname == "dp")
	{
		remove(e);
		return(TRUE);
	}

	if (chaos)
	if (e.wad == "!chaos" || e.netname == "!chaos")
	{
		remove(e);
		return(TRUE);
	}

	if (!chaos)
	if (e.wad == "chaos" || e.netname == "chaos")
	{
		remove(e);
		return(TRUE);
	}

	return(FALSE);
};

// trigger relay with deviation time


void() DelayThink;

void() SUB_Stat_UseTargets =
{
	local entity t;

//
// check for a stat delay
//
	if (self.mean || self.stdev) // NOTE: a stdev with 0 (or -) mean will fire instantly if rnd value < 0
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + meantime(self.mean, self.stdev);
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}

// rest of trigger fire code
	SUB_UseTargets();
};

/*QUAKED trigger_stat_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
uses pk stat data .mean & .stdev for delay if present
*/
void() trigger_stat_relay =
{
// Cataboligne - 4.21.11 - triggers not in mod maps
	if (notmod(self)) return;

	self.use = SUB_Stat_UseTargets;
};

void () func_illusionary;

// mod only func_illusionary - doesnt appear if mod not running
// - further check of notmod specific code - allow restrict to dp/c even if mod running

void () m_func_illusionary =
{
	if (notmod(self)) return;

	func_illusionary();
};

// map item wrapper (so  radiant doesnt have the one m_ entry)

void() func_m_illusionary =
{
	m_func_illusionary();
};



/*QUAKED func_map_feature (.8 .1 .8) (-8 -8 -8) (8 8 8)  SPAWN SLIDE FADE RUBBLE
--------  CAT  -------
Chaos Mod MK II

"spawn" - fire process on map spawn - DEPRECATED
"slide" - slide in "angle" direction as it goes (fades or dissappears)
"fade" - area will fade as it dissappears
"rubble" - generate rubble according to "count"

-------- KEYS --------
"target" - entity to work on
"targetname" - trigger - timer or damage is activator
"delay" - time it takes to fade or slide before its gone, 10 rel default
"frame" - time during slide to set non-solid (if solid)
"height" - total distance to slide
"aflag" - amount to fade every rel, calculated from "delay" if 0
"wait" - time until feature returns, -1 never return
"count" - amount of rubble to generate - generic model, or use models in "target1", "target2"
"target1", "target2" - rubble models
"noise" - noise at start
"noise1" - break noise at end of delay
"noise2" - restore noise at end of wait

-------- NOTES --------
a controler for removeable map areas
*/

// func_map_feature - archon removeable map features (damage or timer)

// target - target such as a func_wall or func_model

float MF_SPAWN = 1;
float MF_SLIDE = 2;
float MF_FADE = 4;
float MF_RUBBLE = 8;

void () multi_wait;

void() think_map_feature =
{
	local float op, oh;

	op = self.aflag / 4;
	oh = self.height / self.delay / 4;

	if (self.deadflag) // done - restore it
	{
		setorigin(self.enemy, self.oldorigin);
		self.enemy.alpha = 1.0; // IDEA: fade restore?
		self.enemy.solid = self.lefty;
		if (self.noise2) sound (self.enemy, CHAN_BODY,self.noise2,1,ATTN_NORM);
		self.enemy = world;
		self.deadflag = FALSE;
		multi_wait();
		return;
	}

	if (self.search_time < time)
	{
		if (self.noise1) sound (self.enemy, CHAN_BODY,self.noise1,1,ATTN_NORM);
		self.enemy.alpha = 0.001; // because 0 alpha is 1 alpha - engine "dur"

		if (self.wait > 0)
		{
			self.nextthink = time + self.wait;
			self.deadflag = TRUE;
		}
		else
		{
			remove(self.enemy); // chaos vector - save this for potential restore
			self.nextthink = time + 0.2;
			self.think = SUB_Remove;
		}
	}
	else
	{
		if (self.spawnflags & MF_SLIDE) self.enemy.origin_z = self.enemy.origin_z - oh;
		if (self.spawnflags & MF_FADE)
		{
			self.enemy.alpha = self.enemy.alpha - op;
			if (self.enemy.alpha <=0) self.enemy.alpha = 0.001; // because 0 alpha is 1 alpha - engine "dur"
		}
		if (self.lefty) // go non solid
		if (self.rad_time)
		if (self.rad_time < time) self.enemy.solid = 0;

		self.nextthink = time + 0.25;
	}
};

void() use_map_feature =
{
	local entity e;

	if (self.nextthink > time)
	{
		return;		// already been triggered
	}

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;

	if (activator.classname == "pk*bot")
		bot_triggered (activator);
	SUB_UseTargets ();

	e = find (world,targetname,self.target);
	if (e)
	{
		self.enemy = e;
		self.deadflag = FALSE;
		self.oldorigin = e.origin;
		self.lefty = e.solid;
		if (e.alpha <= 0) e.alpha = 1.01;

		if (self.delay <= 0) self.delay = 10;
		if (self.aflag <= 0) self.aflag = 1 / self.delay; // so if delay is 20 we fade or slide 0.05 every rel;
		self.search_time = time + self.delay;
		self.rad_time = 0;
		if (self.frame) self.rad_time = time + self.frame;

		if (self.noise) sound (self.enemy, CHAN_BODY,self.noise,1,ATTN_NORM);

		self.think = think_map_feature;
		self.nextthink = time + 1;
	}
};

// made this into a trigger - regular func_ map loaded item did not fire when activated, go figure

void() func_map_feature =
{
	if (notmod(self)) return;

	self.use = use_map_feature;

	self.th_weight = triggerweight; // *bot
	self.istrigger = 1;
	InitTrigger ();
}

// fn(func_saver) - save player from a fall
// fn(mk_saver) - setup saver
// fn(th_saver) - think runs saver
// fn(lt_saver) - extra bolts

void() lt_saver =
{
	lightning_bolt( self.origin,  self.enemy.origin, 0, null_string);
	self.delay = self.delay - 1;
	if (self.delay) self.nextthink = time + 0.3;
	else remove(self);
};

// stop player fall in targeting trigger and wait a few rels for them to FIRE to avoid fall

entity() PK_SelectSpawnPoint;
void(entity spot) ClearSpawnPoint;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

void() th_saver =
{
	local string c3, c4, c5, c6;
	local entity spot;

	c3 = c4 = c5 = c6 = null_string;

	if (self.button0) // player accepted save - it costs .frags
	{
// try a target first (hopefully a teleporter dest)
		if (self.target)
		{
			spot = find(world, targetname, self.target);
		}

// if no target, teleport player to a random loc
		if (!spot)
		{
			spot = find_tdest(FL_RSTELE | FL_RSSTART | FL_ITEM, null_string);
			ClearSpawnPoint(spot); // *pk
		}

		if (spot)
		{
			self.aiment.frags = self.aiment.frags - self.frags;

			self.aiment.origin = spot.origin + '0 0 1';
			self.aiment.angles = spot.angles;
			self.aiment.fixangle = TRUE;		// turn this way immediately
			if (deathmatch || coop)
			{
				makevectors (self.aiment.angles);
				spawn_tfog (self.aiment.origin + v_forward*20);
			}

			spawn_tdeath (self.aiment.origin,self.aiment);
		}
#ifdef warning
		else
			if (WARNING & 1) bprint("func_saver - FAIL: no teleport desitnation available, check map code\n");
#endifdef
	}
	if (self.delay < 1 || self.button0)
	{
		centerprint(self.aiment, null_string);
		self.aiment.movetype = self.lefty;
		self.aiment.aiment = world;
		remove(self);
		return;
	}
	
	c3 = "You have ( ";
	c4 = " ) rels to press FIRE\nThe cost = ";
	c5 = ftos(self.delay);
	c6 = ftos(self.frags);

	centerprint7(self.aiment, self.message, c3, c5, c4, c6, " frags\n", self.noise4);

	self.nextthink = time + 1;

	if (self.aiment.class_select == "class_bot") // NOTE: later exclude non score bots
	if (self.aiment.movetype != MOVETYPE_NONE)
	if (random() < 0.5) // 50 / 50 chance a bot will decide to save
	{



bprint("saver: \bsaved a bot!\n");



		self.button0 = TRUE;
		self.nextthink = time + 1 + 3 * random(); // fake consider time for bot
	}

	self.delay = self.delay - 1;
	self.aiment.movetype = MOVETYPE_NONE;

// fire a "catch" bolt (or something) - NOTE: make it "jagged"

	lightning_bolt( self.origin,  self.aiment.origin, 0, "weapons/lstart.wav");
	spot = spawn();
	spot.origin = self.origin;
	spot.aiment = self.aiment;
	spot.think = lt_saver;
	spot.nextthink = time + 0.3;
	spot.delay = 3;
	
};

void() mk_saver =
{
	local entity e;

	e = spawn();
	if (!e) return;

	e.origin = self.origin; //activator.origin;
	e.aiment = activator;
	e.classname = "saver";
	activator.aiment = e;

	e.message = self.message;
	e.noise4 = self.noise4;
	e.target = self.target;

	if (self.delay) e.delay = self.delay;
	else e.delay = 5;
	if (self.frags) e.frags = self.frags;
	else e.frags = 1;
	e.lefty = activator.movetype;
	e.button0 = FALSE;

	e.think = th_saver;
	e.nextthink = time + 0.1;
};

void() func_saver =
{
	self.use = mk_saver;
};


/*QUAKED effect_affect (.7 0 .7) (-8 -8 -8) (8 8 8) ALLSAME
--------  CAT  -------
"ltime" (60) - frequency of change - happens every this many rels
"target" - entity to make modifications to
"mean", "stdev" - new calculation for aspect of target
"*" - field to modify - value non zero, first come first changed of
--- "wait, delay, style, speed, lefty, count, cnt"
-------- NOTES --------
change some field (float) in an entity - update value with meantime calculation
ALLSAME - all targets get same value, otherwise individual targets are randomized
*/

void() th_effect_affect =
{
	local float f;
	local entity t;

	t = find (world, targetname, self.target);
	if (self.spawnflags & 1)
		f = meantime(self.mean, self.stdev);
	while (t)
	{
		if (! self.spawnflags & 1)
			f = meantime(self.mean, self.stdev);
		if (self.wait) t.wait = f;
		else if (self.delay) t.delay = f;
		else if (self.style) t.style = f;
		else if (self.speed) t.speed = f;
		else if (self.lefty) t.lefty = f;
		else if (self.count) t.count = f;
		else if (self.cnt) t.cnt = f;

		t = find (t, targetname, self.target);
	}
	if (!self.targetname)
	{
		if (self.ltime < 1) self.ltime = 60;
		self.nextthink = time + self.ltime;
		self.think = th_effect_affect;
	}
};

void() effect_affect =
{
	if (!self.mean && !self.stdev || !self.target) // no stats or targ, no go
	{
		remove(self);
		return;
	}

	if (!self.targetname) // not targeted - run loop on think
	{
		if (self.ltime < 1) self.ltime = 60;
		self.nextthink = time + self.ltime;
		self.think = th_effect_affect;
	}
	else
	{
		self.use = th_effect_affect;
	}
};



// fn(IS_MISSILE) - ent is a flying missile object (FMO)

// class finder
// gr fire_missile *|grep -o " \".*\","|cut -d "," -f -1|sort -u

float(entity e) IS_MISSILE =
{
	local float f;
	f = FALSE;

	if (e.classname == "spike") f = TRUE;
//	else if (e.classname == "pulse_spike") f = TRUE;
	else if (e.classname == "grenade") f = TRUE;
	else if (e.classname == "ogre_grenade") f = TRUE;
	else if (e.classname == "missile") f = TRUE;
	else if (e.classname == "laser") f = TRUE;
	else if (e.classname == "plasma") f = TRUE;
	else if (e.classname == "proximity_grenade") f = TRUE;
	else if (e.classname == "MultiGrenade") f = TRUE;
	else if (e.classname == "MiniGrenade") f = TRUE;
	else if (e.classname == "vomisss") f = TRUE;
	else if (e.classname == "vomisexplod") f = TRUE;
	else if (e.classname == "cluster_bomb") f = TRUE;
	else if (e.classname == "fireballwep") f = TRUE;
	else if (e.classname == "lavaspike") f = TRUE;
	else if (e.classname == "fireballmissle") f = TRUE;
	else if (e.classname == "wizspike") f = TRUE;
	else if (e.classname == "knightspike") f = TRUE;
//	else if (e.classname == "zombyflesh") f = TRUE;
	else if (e.classname == "gib_tracer") f = TRUE;
	else if (e.classname == "beacon") f = TRUE;
//	else if (e.classname == "fireball") f = TRUE;
//	else if (e.classname == "calderashard") f = TRUE;
	return(f);
};


// info_allow - indicate a map allows certain things, like large monster flyers

float ALLOW_LARGE_FLYER;

void() info_allow =
{
// allow random monsters that are flyers and large - dragons, cthulhu, etc
	if (self.netname == "largeflyers") ALLOW_LARGE_FLYER = TRUE;

	remove(self);
};

// new body que - builds que on the fly

entity bodyque_first; // start up pointer
entity bodyque_head;
float body_cnt;

// so other stuff can bodyque

// trm - self terminate body - not part of loop sequence

void(entity e, entity bq, float trm) BodyQueAsset =
{
	if ((e.model == null_string) || (e.model == null_model)) return;

	if (trm) // terminate it later
	{
		bq = spawn(); // make one each time
		bq.think = remove_fade; //SUB_Remove;
		bq.nextthink = time + DEAD_BODYTIME + random() * 30;
		if (!deathmatch) bq.nextthink = time + DEAD_BODYTIME * 6 + random() * 40; // this would be for respawnable monsters
		bq.classname = "bodyque";	
	}

	bq.angles = e.angles;
	bq.model = e.model;
	bq.modelindex = e.modelindex;
	bq.frame = e.frame;
// this makes no sense as runes under 2 get tossed on death, and respawn under 1
//	bq.rune_flag = e.rune_flag;  // corpse have runes - when gibable, they will be protected by resist

// needs testing - this was failing on cthon & lavabomb skin 1
	bq.colormap = e.colormap; // player colors till disconnect - changes when changed live
//	bq.colormap = 0; // Cataboligne - 10.29.12 - fix lava morph dead skin issues - done in death fn() now

//	bq.clientcolors = e.clientcolors; // does nothing - colors happen thru the colormap, of which there are client slots count
	if ((e.class_select == "class_monster") || (e.flags & FL_MONSTER)) // follow death frames if here
	{
		bq.think = e.think;
		bq.nextthink = e.nextthink;
	}

	bq.flags = e.flags - (e.flags & (FL_CLIENT | FL_MONSTER) ); // mask off these flags
	bq.movetype = e.movetype;
	bq.velocity = e.velocity;
	bq.deathtype = e.deathtype; // plague, etc
	bq.touch = e.touch;
	bq.flags = 0;
	bq.skin = e.skin; // *pk damage skins
	setorigin (bq,e.origin);
	setsize (bq,e.mins,e.maxs);

/*
// this actually sets colors for a given colormap = clientno + 1 (this example sets colors for colormap = 2)
// to set a color map above 1 a listen server must be running

	bq.b_clientno = 1;
	bq.b_shirt = 9;
	bq.b_pants = 10;
	UpdateClient(bq);
*/
};

void (entity e) CopyToBodyQue =
{
	if ((e.model == null_string) || (e.model == null_model)) return;

	if (DEAD_BODYCOUNT < 1)
	{
		bodyque_head = spawn(); // make one each time
		bodyque_head.think = remove_fade; //SUB_Remove;
		bodyque_head.nextthink = time + DEAD_BODYTIME + random() * 30;
		bodyque_head.classname = "bodyque";
	}
	else
	if (body_cnt < DEAD_BODYCOUNT)
	{
		if (bodyque_head)
		{
			bodyque_head.owner = spawn(); // next in linx
			bodyque_head = bodyque_head.owner;
		}
		else
			bodyque_first = bodyque_head = spawn(); // make first one

		bodyque_head.classname = "bodyque";
		body_cnt = body_cnt + 1;
	}
	else
	{
		if (!bodyque_head.owner)
			bodyque_head.owner = bodyque_first; // make loop
		else
			bodyque_head = bodyque_head.owner; // cycle loop
	}

	BodyQueAsset(e, bodyque_head, FALSE);
};


// detect a rogue map - for specials

float(string mp) rogue_map =
{
	if (mp == "maps/r1m1.bsp") return(TRUE);
	if (mp == "maps/r1m2.bsp") return(TRUE);
	if (mp == "maps/r1m3.bsp") return(TRUE);
	if (mp == "maps/r1m4.bsp") return(TRUE);
	if (mp == "maps/r1m5.bsp") return(TRUE);
	if (mp == "maps/r1m6.bsp") return(TRUE);
	if (mp == "maps/r1m7.bsp") return(TRUE);
	if (mp == "maps/r2m1.bsp") return(TRUE);
	if (mp == "maps/r2m2.bsp") return(TRUE);
	if (mp == "maps/r2m3.bsp") return(TRUE);
	if (mp == "maps/r2m4.bsp") return(TRUE);
	if (mp == "maps/r2m5.bsp") return(TRUE);
	if (mp == "maps/r2m6.bsp") return(TRUE);
	if (mp == "maps/r2m7.bsp") return(TRUE);
	if (mp == "maps/r2m8.bsp") return(TRUE);

	return(FALSE);
};



// chaos morph and beam support


// fn(IS_CHAOS) - morph is master of chaos
// fn(IS_CHAOS_PURE) - morph is master of chaos in natural form

float(entity e) IS_CHAOS =
{
	if (e.height == IMP_MCHAOS) return TRUE; // chaos in another from
	return(e.morphy == IMP_MCHAOS);
};

float(entity e) IS_CHAOS_PURE =
{
	return(e.morphy == IMP_MCHAOS);
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

	if (self.morphy == IMP_MORDER)
		particle (org + p1, '0 0 0', 194 + random() * 5, random() * 25); // 237 - fire orange range
	else
	if (self.morphy == IMP_MWRAITH)
	{
		if (col == 12 || col == 251)
			particle (org + p1, '0 0 0', cl, 3);
		else
			particle (org + p1, '0 0 0', cl, 15);
	}
	else
		if (random() < pr) particle (org + p1, '0 0 0', cl, random() * 25); // IDEA - restrict colors?
};


// simple version - see original chaos code for full deal, this is grav well code
float (entity e, float t) move_check =
{
	local float f;

	f = FALSE;

	if (e.model != "progs/boss.mdl" && e.model != "progs/oldone.mdl" && e.model != "progs/cthon.mdl") // dont pull bosses or cthon morph
//	if (pk_art_movshot_ck(e, "grav")) // Cataboligne 8.12.9 purify - pk artifacts
//	if (e.classname != "chase_cam") - no more cam
	if (e.map != "nonmove") // 7.22.13 - func_models we should not suck
	//if (e != self.owner)
	if (e.classname != OBSERVER)
	if (e.movetype != MOVETYPE_NONE) // anything that can move
	if (e.movetype != MOVETYPE_PUSH)
	if (e.movetype != MOVETYPE_NOCLIP)
		f = TRUE;
	return(f);
};

// fn(rnd_list) - select a random item from a .chain structure, held items will be dropped
// fn(list_test) - test item for req. parms
// returns entity selected or world if select fails
// hent - head entity
// rads - within this radius of hent
// tent - test entity
// flg - list flag set
float FL_MISSILE                                = 4; // item is a flying missile
float FL_DECOR                          = 8; // item is a non solid decor
float FL_PLAYER                         = 16; // item selected must be a player class
//float FL_MONSTER = 32
float FL_LTALL                                  = 316;  // test all - will return match FL_*

//
float(entity tent, float flg) list_test =
{
        if (!flg) return 1;
        if (flg & FL_PLAYER) if (tent.classname == "player") return FL_PLAYER;
        if (flg & FL_MONSTER) if (tent.flags & FL_MONSTER) return FL_MONSTER;
        if (flg & FL_ITEM) if (tent.flags & FL_ITEM) return FL_ITEM;
//        if (flg & FL_DECOR) if (IS_DECOR(tent)) return FL_DECOR;
        if (flg & FL_MISSILE) if (IS_MISSILE(tent)) return FL_MISSILE;
        return 0;
};

void(entity e) print_chain = // TEST fn - print out linked chain of ents
{
        while (e)
        {
                bprint(" chain ent: ");
                if (e.netname != null_string)    { bprint(e.netname); bprint(" : "); }
                if (e.classname != null_string) bprint(e.classname);
                bprint(" \n");
                e = e.chain;
        }
};

entity archon_high;

entity(entity hent, float flg) rnd_list =
{
        local float rc, r1;
        local entity sel, sr, s2;

        sel = s2 = world;
        rc = 0.3;
        sr = hent;
			archon_high = world;
 //       set_CLE("calderashard", null_string, null_string, null_string, null_string, null_string, null_string);
        while (sr) // count stuff
                {
                if (move_check(sr, 15999 | 128)) //T_BLAST | T_IGNHELD)) // FIX - remove move_check failures from chain?
						{
                        if (list_test(sr, flg))
								{
									rc = rc + 1;
									if (sr.archon > archon_high.archon) archon_high = sr; // get archon pts high scorer
								}
                  }
                sr = sr.chain;
                }
        sr = hent;
        r1 = floor(rc * random());
        while ((sr != world) && (sel == world))
                {
                        if (move_check(sr, 15999 | 128))
                        if (list_test(sr, flg))
                        {
                                r1 = r1 - 1;
                                s2 = sr;
                        }
                if (r1 < 1.0) sel = s2;
                sr = sr.chain;
                }
        if (!sel && s2) sel = s2;
//        if (sel) if (sel.flags & FL_HELD) drop_held(sel, v0); // item_held() // cant hold items yet
        return(sel);
};


// fn(chaos_mdlsize) - set sizes for certain models

void(entity e) chaos_mdlsize =
{
	local vector vmin, vmax;
	if (!e) return;

	vmin = vmax = v0;
	if (e.model == "progs/teleport.mdl")			{ vmin = '-16 -16 -24'; vmax = '16 16 16'; }
	else if (e.model == "progs/lavaball.mdl") // || e.model == "progs/snowball.mdl")
	{
		if (e.frame == 0 || e.frame == 5)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 2 || e.frame == 3 ||
			  e.frame == 7 || e.frame == 8)			{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
		if (e.frame == 4 || e.frame == 9)			{ vmin = '-1 -1 -1'; vmax = '1 1 1'; }
	}
	else if (e.model == "progs/grenade.mdl")
	{
		if (e.frame == 0)								{ vmin = '-2 -2 -2'; vmax = '2 2 2'; } // reg grenade
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; } // telespheres
		if (e.frame == 2 || e.frame == 7)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 3 || e.frame == 4 ||
			  e.frame == 8 || e.frame == 9)			{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
		if (e.frame == 5 || e.frame == 10)		{ vmin = '-1 -1 -1'; vmax = '1 1 1'; }
	}
	else if (e.model == "progs/proxbomb.mdl")	{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
	else if (e.model == "progs/hook.mdl")			{ vmin = '-5 -5 -5'; vmax = ' 5 5 5'; }
	else if (e.model == "progs/v_spike.mdl")		{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
//	else if (e.model == "progs/ejbatt.mdl")		{ vmin = '-2 -2 -6'; vmax = '2 2 4'; }
	else if (e.model == "progs/s_bubble.spr")	{ vmin = '-2 -2 -2'; vmax = '2 2 2'; }
	else if (e.model == "progs/chaos_b2.mdl")	{ vmin = '-16 -16 -24'; vmax = '16 16 40'; }
	if (vmin != v0 && vmax != v0) setsize(e, vmin, vmax);
};

// fn(chaos_bomb_rndmdl) - random model for chaos bomb
// if e == world return model string, else set model / sizes

string(entity e) chaos_bomb_rndmdl =
{
	local string s1;
	local float r1;
	r1 = floor(random() * 17.3);

	s1 = "progs/teleport.mdl";
	if (r1 > 15) s1 = "progs/g_gas.mdl";
	else if (r1 > 13) s1 = "progs/grenade.mdl";
	else if (r1 > 10) s1 = "maps/b_exbox2.bsp";
	else if (r1 > 8) s1 = "maps/b_rock0.bsp";
//	else if (r1 > 7) s1 = "progs/ejbatt.mdl";
	else if (r1 > 5) s1 = "progs/proxbomb.mdl";
	else if (r1 > 3) s1 = "progs/hook.mdl";
	else if (r1 > 2) s1 = "progs/v_spike.mdl";
	if (e)
	{
		setmodel(e, s1);
		chaos_mdlsize(e); // have to size it or bbox is wrong
	}
	return(s1);
};

// fn(chaos_bomb) - explode a chaos thrown item shooting variable wep missiles
// fn(RND_Spike) - create random spikes for chaos bomb
// fn(RND_Damage) - random damage for explosives (just because 10 random grenades from a betty are pretty damn dangerous for anything nearby)

float RND_frame;
float RND_skin;
float RND_maxdmg; // set to CBOMB_DEF_MAX if > 0 this is the max damage all explosives from bomb can cause

void() RND_Spike =
{
	if (newmis)
	{
		newmis.frame = RND_frame;
		newmis.skin = RND_skin;
	}
};

void() RND_Damage =
{
	local float dm;

	if (newmis)
	{
		dm = CBOMB_DEF_DMG + random() * DUD_DEF_DMG; // 10 + rnd * 20
		if (RND_maxdmg >= 0) // in use if not < 0
		{
			if (dm > RND_maxdmg) dm = RND_maxdmg;
			RND_maxdmg = RND_maxdmg - dm;
			if (RND_maxdmg < 0) RND_maxdmg = 0;
		}
		newmis.dmg = dm;
	}
};

// for the obit

void(float ox) W_FireSpikes;
void() W_FireGrenade;
void() W_FireRocket;
void () W_FireLightning;
void(float fl) fire_laser1;

void() W_FireClusterRock =
{
	W_FireRocket();
	newmis.classname = "cluster_bomb";
};

void() W_FireClusterGren =
{
	W_FireGrenade();
	newmis.classname = "cluster_bomb";	
};

void() chaos_bomb =
{
	local float r1;
	local void() wfire, vspk;

	if (self.aflag == MOVETYPE_BOUNCE) // the bouncing part of betty, she is a bad ass too
	{
		self.nextthink = time + 0.1 + random() * 0.4; // time to bounce
		self.velocity_z = 200 + 200 * random();
		if (random() < 0.5)
		{
			self.velocity_x = 50 * crandom();
			self.velocity_y = 50 * crandom();
		}
		self.aflag = 0; // return call does bomb out
		return;
	}
	r1 = floor(random() * 8.6);
	wfire = W_FireSpikes;
	vspk = SUB_Null;
	if (self.weapon == IMP_MOGRE) { wfire = W_FireClusterGren; r1 = 5; }
	else if (r1 > 7) wfire = fire_laser1;
//	else if (r1 > 6) wfire = fire_cbolt; // IMP: put back in for chaos morph
	else if (r1 > 5) { wfire = W_FireClusterGren; vspk = RND_Damage; }
	else if (r1 > 5) { wfire = W_FireClusterRock; vspk = RND_Damage; }
	else if (r1 > 4) wfire = W_FireLightning;
	if (r1 < 4) vspk = RND_Spike;

	RND_frame = random() * 7.4;
	RND_skin = random() * 3.4;
	RND_maxdmg = CBOMB_DEF_MAX;
	
// really just a fancy bouncing betty
	fire_burst (wfire, self.origin + '0 0 30', 0, 0, null_string, null_string, 0, 3, 8, '120 0 0', ' 300 360 360', vspk, FL_ANGADR | FL_VELRND | FL_FRCORG | FL_NEWSELF | FL_OWNOWN, world);
	RND_maxdmg = 0; // reset
	remove(self);
};
