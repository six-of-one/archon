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
	else 
		if (WARNING) {bprint("chaos_spawn() resetting: "); bprint(chaos_e.classname); bprint("\n"); }
	if (chaos_e == world) // failed to spawn, call fn still needs to check if live ent
		{
		if (WARNING) bprint("chaos_spawn() - ERROR: spawn() failed, returned world!\n");
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

	if (org != ' 0 0 0') setorigin (chaos_e, org);
	else setorigin (chaos_e, self.origin);
	setmodel (chaos_e, md);
	setsize (chaos_e, smin, smax);

	return(chaos_e);
};


// fn(cnt_ent) - count all such ents on level, make chain if head ent provided

// hent - head entity for chain struct
// match - find on this field
// srch - search for this

// RETURN - count of ents matching search parm
float cnt_ent_next; // use pk .next to chain up

float(entity hent, string match, string srch) cnt_ent =
{
	local float rc;
	local entity sr, ch;

	sr = world;
	if (match == "classname") sr = find (world, classname, srch);
//	else if (match == "class_select") sr = find (world, class_select, srch);
//	else if (match == "quakeset") sr = find (world, quakeset, srch);
	else if (match == "netname") sr = find (world, netname, srch);
	else if (match == "map") sr = find (world, map, srch);
//	else if (match == "scode") sr = find (world, scode, srch);
	ch = hent;

	rc = 0;
	while (sr)
		{
			rc = rc + 1;
			if (hent)
			{
				if (cnt_ent_next) ch.next = sr;
				else ch.chain = sr;
				ch = sr;
			}
			if (match == "classname") sr = find (sr, classname, srch);
//			else if (match == "class_select") sr = find (sr, class_select, srch);
//			else if (match == "quakeset") sr = find (sr, quakeset, srch);
			else if (match == "netname") sr = find (sr, netname, srch);
			else if (match == "map") sr = find (sr, map, srch);
//			else if (match == "scode") sr = find (sr, scode, srch);
		}
	if (hent) 
	{
		if (cnt_ent_next) ch.next = world;
		else ch.chain = world; // remove other potential chains left around - not even sure if this can happen
	}
	cnt_ent_next = FALSE;
	return(rc);
}

/*
		+---------------------------------------+
		|  bit operations code                  | SEC-HEAD
		+---------------------------------------+
*/

// fn(bit_cnt) - count available bits for random selection

// fb - bits to count
// rb - return a random bit from set

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

float BIT_HIGH = 8388608;
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
	self.frame = self.frame + 1;
	if (self.frame > self.state) self.frame = self.count;
	self.nextthink = time + self.delay;
};

// used for various effects (8 ray star & visage level decor)

void() func_model =
{
	self.mdl = self.model;
	precache_model (self.mdl);
	setmodel (self,self.mdl);

	self.frame = self.count;
	if (self.state)
	{
	if (self.delay <= 0) self.delay = 0.1;
	self.think = func_model_frames;
	self.nextthink = time + self.delay;
	}
};


// NOTE: came from chaos_env.qc

// fn(move_stop) halt a moving entity, play looped sound ns

void (entity e, string ns) move_stop =
{
	e.velocity = ' 0 0 0';
	e.movetype = MOVETYPE_NONE; // fails blast_move - removing fails shell casings in lava
	if (ns != "") sound(e, CHAN_WEAPON, ns, 1, ATTN_NORM);
};


// fn(loop_sound) - play a sound looped until stopped by remove, halt or search_time exceeded
// fn(loop_play) - plays loop sounds at given interval self.

// emulate looped ambient sounds - should be accurate to a fraction of seconds

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
			remove(q);
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
		q = chaos_spawn(MOVETYPE_NONE, 0, 0, 0,  org, v0, v0, v0, v0, LOOPSOUND, "", SUB_Null, 0, SUB_Null, SUB_Null, p, world);
		q.cnt = chan;
		q.noise1 = sd;
		q.volume = vl;
		q.aflag = attn;
		q.delay = tm;
		q.distance = 0;
		q.search_time = time + end;
		return(q);
	}
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
			else if (ws != "")
			{
				sound (self, hum_chan, ws, 1, ATTN_NORM);
				self.chaosweptime = time + rtime;
			}
		}
		hum_chan = CHAN_WEAPON;
	}
};

// fn(newline) print newline to self client screen

void(entity e) newline =
{
if (e) sprint(e,"\n");
else bprint("\n");
}


// ENV
// use wrappers for engines these break (like fte)



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
	local float t, surfnum;
//	local string s3;
	string last_texture;

	if (XENV) return(FALSE);

	if (surf == "") // note - no q1 mode qual on surface string
	{
		surfnum = -1;
		t = FALSE;
		f = e;
		if (v == v0 && !f) f = self;
		if (v == v0 && f) v = f.origin + normalize(f.velocity) * 10;
		if (v == v0) return(t);

		if (pointcontents(v) == CONTENT_SKY) t = TRUE;

		last_texture = "";
		surfnum = getsurfacenearpoint(world, v);
	}

// new sky contents code

	if (surfnum >= 0 || surf != "")
	{
		if (surf == "") last_texture = getsurfacetexture(world, surfnum);
		else last_texture = surf;
		if (last_texture == "sky1" || last_texture == "sky4" || last_texture == "sky0" || last_texture == "sky2" || last_texture == "sky6") t = TRUE;
		else if (last_texture == "skydark") t = TRUE;
		else if (last_texture == "c1_") t = TRUE;
		else if (last_texture == "textures/K_sky/rabbit_skybox" || last_texture == "textures/skies/pjbasesky_arena1_sky") t = TRUE;
	}

	return(t);
};

void() sky_touch_pointer =
{

// UNKNOWN op - decide what is happening with this code
//	if (sky_touch("", v0, self))
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

	sl = "";
	cv = 1;

	if (wt == ' 0 0 0') wt = ' 80.0 60.0 40.0';
	w1 = wt_x;
	w2 = wt_y;
	w3 = wt_z;
	w4 = ceil(wt_z * (wt_z / wt_x)); // gives 20 if chances eq. - 80 60 40 20

	if (rs1 != "")
	while (sl == "") 
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

// fn(info_think) - think to display various info

// TESTING
float zz;

void () info_think =
{
	if (self.button0) 
	{
		bprint(self.noise);
		bprint(ftos(self.button0));
		bprint("\n");
	}
	else if (self.noise) bprint(self.noise);

	if (self.button1) 
	{
		bprint(self.noise1);
		bprint(ftos(self.button1));
		bprint("\n");
	}
	else if (self.noise1) bprint(self.noise1);

	if (self.button2) 
	{
		bprint(self.noise2);
		bprint(ftos(self.button2));
		bprint("\n");
	}
	else if (self.noise2) bprint(self.noise2);

	if (self.items) 
	{
		bprint(self.noise3);
		bprint(ftos(self.items));
		bprint("\n");
	}
	else if (self.noise3) bprint(self.noise3);

	if (self.weapon)
	{
		bprint(self.noise4);
		bit_print(MAXFL, self.weapon);
		bprint("\n");
	}
	else
	if (self.pos1) 
	{
		bprint(self.noise4);
		bprint(vtos(self.pos1));
		bprint("\n");
	}
	else if (self.noise4) bprint(self.noise4);

	if (self.target) bprint(self.target);
	if (self.target1) bprint(self.target1);
	if (self.target2) bprint(self.target2);

	remove(self);
};

float info_ttime;

void(float tm, string l1, string l2, string l3, string l4, string l5, float f1, float f2, float f3, float f4, vector v1, float bp) spawn_infot =
{
	local entity e;
	local float t;

	if (!WARNING) return;

	e = spawn();
	if (l1) e.noise = l1;
	if (l2) e.noise1 = l2;
	if (l3) e.noise2 = l3;
	if (l4) e.noise3 = l4;
	if (l5) e.noise4 = l5;

	if (f1) e.button0 = f1;
	if (f2) e.button1 = f2;
	if (f3) e.button2 = f3;
	if (f4) e.items = f4;
	if (v1 != v0) e.pos1 = v1;
	if (bp) e.weapon = bp;

	e.think = info_think;
	t = time + tm;
	if (t <= info_ttime) t = info_ttime + 1;
	e.nextthink = t;
	info_ttime = t;
}

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

// spawn_infot(1, "", "",  "",  "",  "", 0, 0, 0, 0, v0, 0);

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
	if (self.noise2 != "" && self.noise3 != "")
	{
		if (self.cnt <= 0) self.cnt = 0.5;
		if (self.style <= 0) self.style = 0.1;
		if (random() < self.cnt)
			self.noise = self.noise2; //" turned into hot slag";
		else
			self.noise = self.noise3; // " visits the Volcano God";
		if (self.noise4 != "")
		if (random() < self.style)
			self.noise = self.noise4; // " is playing geologist again";
	}
	else
	if (self.noise == "" && self.noise2 != "" || self.noise3 != "")
	{
		if (self.noise2 != "") self.noise = self.noise2;
		if (self.noise3 != "") self.noise = self.noise3;
	}
	if (self.noise != "")
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
	if ((self.spawnflags & 1) && self.targetname != "") // if no targetname is given this becomes a regular hurt trigger!
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


// TESTING
//	if (cvar("saved1") == 17 || cvar("saved1") == -999) return(FALSE); // allow test



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
// Cataboligne - 4.21.11 - triggerss not in mod maps
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

float() crandom;

void() th_arcarn =
{
	local float f;
	local vector v1;

	self.nextthink = time + self.wait + self.cnt * random();

	if (self.alpha == 0)
	{
		v1_x = self.distance * random();
		v1_y = self.distance * random();
		if (self.lip)
		if (random() < self.lip)
			v1_z = self.oldorigin_z + crandom() * self.height;

		setorigin(self, self.oldorigin + v1);
		setmodel(self, self.mdl);
		self.nextthink = time + 0.1 + 0.2 * random();
		self.aflag = 0.1;
	}
	if (self.alpha < 1)
	{
		self.alpha = self.alpha + self.aflag;
		self.nextthink = time + 0.1 + 0.2 * random();

		if (self.alpha > 0.6 && self.aflag == 0.1)
		{
			self.solid = SOLID_BSP;
			if (self.flags)
			if (random() < 0.33)
			{
				self.effects = rnd_bit_mask(self.flags);
			}
		}
		else if (self.alpha < 0.6 && self.aflag == -0.1)
		{
			self.solid = SOLID_NOT;
			self.effects = 0;
		}

		if (self.alpha > 1)
		{
			self.nextthink = time + self.delay + self.count * random();
			if (random() < self.style) 
				self.nextthink = time + (self.delay / 0.6) + (self.count / 0.5) * random();
			self.alpha = 1;
		}
		else if (self.alpha < 0.05)
		{
			f = 0;
			if (self.lefty)
			if (random() < 0.1)
				f = self.lefty;
			self.nextthink = time + self.wait + self.cnt * random() + f;
			self.alpha = 0;
			self.model = "";
			self.solid = 0;
		}
	}
	else
	{
		self.nextthink = time + 0.1 + 0.2 * random();
		self.aflag = -0.1;		
		self.alpha = self.alpha + self.aflag;
	}
	
};

// func_arcarn - archon arena blocks

// mdl = model to use
// following all have defaults (*)
// distance (64) - randomizing dist around center
// height (32) - possible height randomizer
// lip (0.25) - chance of variable height

// wait (20) - time to appear
// cnt (30) - randomizer on appear time
// lefty (rnd) - start time pause, random pauses

// delay (30) - time to hang
// count (40) - randomizer on hang time
// style (0) - chance of very short hangs

// flags (12) - bit map of allowed effects - EF_*

void() func_arcarn =
{
	local float f;

	if (!DARKPLACES)
	{
		precache_model("maps/aarn1.bsp");
		precache_model("maps/aarn2.bsp");
		precache_model("maps/aarn3.bsp");
	}

	f = random();
	if (self.mdl == "")
	if (f < 0.33)
		self.mdl = "maps/aarn1.bsp";
	else if (f < 0.66)
		self.mdl = "maps/aarn2.bsp";
	else
		self.mdl = "maps/aarn3.bsp";

	if (self.wait < 1) self.wait = 20; // appear time
	if (self.cnt < 1) self.cnt = 30;
	if (random() < 0.2)
	{
		f = random();
		if (f < 0.25) self.lefty = 30;
		else if (f < 0.5) self.lefty = 60;
		else if (f < 0.6) self.lefty = 80;
	}

	if (self.delay < 1) self.delay = 30; // hang time
	if (self.count < 1) self.count = 40;

	self.think = th_arcarn;
	self.nextthink = time + self.wait + self.cnt * random() + self.lefty;

	if (self.lefty) // small chance of fast starts - TDO: .var
	if (random() < 0.1)
		self.nextthink = time + self.wait * random();

	self.oldorigin = self.origin;
	if (self.distance < 1) self.distance = 64;
	if (self.height< 1) self.height = 32;
	if (!self.lip) self.lip = 0.24;

	self.alpha = 0;
	if (self.flags < 1) self.flags = 12;
};

// fn(func_saver) - save player from a fall
// fn(mk_saver) - setup saver
// fn(th_saver) - think runs saver
// fn(lt_saver) - extra bolts

void() lt_saver =
{
	lightning_bolt( self.origin,  self.enemy.origin, 0, "");
	self.delay = self.delay - 1;
	if (self.delay) self.nextthink = time + 0.3;
	else remove(self);
};

// stop player fall in targeting trigger and wait a few secs for them to FIRE to avoid fall

entity() PK_SelectSpawnPoint;
void(entity spot) ClearSpawnPoint;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

void() th_saver =
{
	local string c3, c4, c5, c6;
	local entity spot;

	c3 = c4 = c5 = c6 = "";

	if (self.button0) // player accepted save - it costs .frags
	{
// try a target first (hopefully a teleporter dest)
		if (self.target)
		{
			spot = find(world, targetname, self.target);
		}

// if no target, teleport player to a random spawn
		if (!spot)
		{
			spot = PK_SelectSpawnPoint (); // *pk - get a spawn point, pk style 
			ClearSpawnPoint(spot); // *pk
		}
// TDO: add item location randomizer when chaos teleport done

		if (!spot) // FAILED!
		{
			if (WARNING) bprint("func_saver - FAIL: no teleport desitnation available, check map code\n");
		}
		else
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
	}
	if (self.delay < 1 || self.button0)
	{
		centerprint(self.aiment, "");
		self.aiment.movetype = self.lefty;
		self.aiment.aiment = world;
		remove(self);
		return;
	}
	
	c3 = "You have ( ";
	c4 = " ) seconds to press FIRE\nThe cost = ";
	c5 = ftos(self.delay);
	c6 = ftos(self.frags);

	centerprint7(self.aiment, self.message, c3, c5, c4, c6, " frags\n", self.noise4);

	self.nextthink = time + 1;

	if (!self.aiment.ishuman) // NOTE: later exclude non score bots
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
	self.modelindex = 0;
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

/*QUAKED effect_affect (.7 0 .7) (-8 -8 -8) (8 8 8) ALLSAME
--------  CAT  -------
"ltime" (60) - frequency of change - happens every this many seconds
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