/* Rubble QuickC program 
   By Jim Dose'  9/15/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Distributed (unsupported) on 3.12.97
*/

// oblong (arm gib) irr block (torso gib) tetra (tetra gib) 0 1 2
$frame hiprubl1 hiprubl2 hiprubl3
// smaller block (cube) small block (rectangle) small block (odd) 3 4 5
$frame blockrubl1 blockrubl2 blockrubl3
// small beveled block, med beveled block, large beveled block 6 7 8
$frame bevelrubl1 bevelrubl2 bevelrubl3
// torso twists = 4, largest last 9 10 11 12
$frame blocktwist1 blocktwist2 blocktwist3 blocktwist4
// trapeziod solids - smaller, flat tile, odd, med, large, larger 13 14 15 16 17 18
$frame blocktrapez1 flattile1  blocktrodd1 blocktrapez2 blocktrapez3 blocktrapez4
// minis 19 20 21 22
$frame bevelmini blockmini trapezmini twistmini
// micro 23 24 25 26
$frame bevelmicro blockmicro trapezmicro twistmicro
// menhir - 4 sided monument - pyramid top sm, med, lg
$frame menhirm1 menhirm2 menhirm3
// menhir - 4 sided crystal oblong sm, med, lg
$frame menhirco1 menhirco2 menhirco3
// menhir - odd oblong sm, med, lg
$frame menhiro1 menhiro2 menhiro3
// length down from origin for punch up effect
float menhir1_LEN = 40, menhir2_LEN = 82, menhir3_LEN = 140;
// basalt column - skin 7
$frame basalt1 basalt2 basalt3

// rubble skin support - original hip & dm4 so far

// 0 1 2 -- brown splotch, dark coppery, light coppery
$skin hipskin1 hipskin2 hipskin3
// 3 4 5 -- dm4 cieling, dm4 skygrate, dm4walls
$skin metal1_6 metal1_3 mmetal1_3
// 6 -- lava rubble skin
$skin aa_lava

void() hipRubbleTouch =
{
	if ( self.ltime < self.pausetime )
	   return;
	
	if (self.velocity != ' 0 0 0') // still moving
	if (self.velocity_x != 0 && self.velocity_y != 0 && self.quakeset != EARTHQUAKE)
	if (other.takedamage)
		{
		if (!self.dmg) self.dmg = RUBBLE_DMGDEF;
		T_Damage (other, self, self.owner, self.dmg );
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		self.pausetime = self.ltime + 0.1;
		}
	else
		if (self.noise != null_string) sound(self, CHAN_WEAPON, self.noise, 1, ATTN_NORM);
};

// fn(RubbleInSolid) - take care of rubble in solids

void() RubbleInSolid =
{
	move_stop(self, self.noise4);
};

// fn(hipThrowRubble) - make rubble happen, yep more map clutter

void(string rubblename, float rubblefr, float rubblesk, vector org, string code) hipThrowRubble =
{
//	local	entity rubble;

// no rubble if env turned off or in *_100 mode
	if (XENV) return;

	newmis = spawn();
	if (!newmis) return;
	newmis.origin = org;
	setmodel (newmis, rubblename );
	setsize (newmis, '0 0 0', '0 0 0');
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.dmg = 10; // rubble damage if hip touch used
	newmis.pausetime = newmis.ltime = time;

	newmis.frame = rubblefr; // frame in rubble master model
	newmis.skin = rubblesk; // skin in rubble master model

	if (code == "hip" || code == "rubble") // regular hipnotic rubble
	{
		newmis.velocity_x = 70 * crandom();
		newmis.velocity_y = 70 * crandom();
		newmis.velocity_z = 140 + 70 * random();
		newmis.avelocity_x = random()*600;
		newmis.avelocity_y = random()*600;
		newmis.avelocity_z = random()*600;
		newmis.touch = hipRubbleTouch;
	}
	else if (code == "earthquake")
	{
		newmis.velocity_x = 5 * crandom();
		newmis.velocity_y = 5 * crandom();
		newmis.velocity_z = -75 + random() * -50;
		newmis.avelocity_x = random() * 50;
		newmis.avelocity_y = random() * 50;
		newmis.avelocity_z = random() * 50;
		newmis.angles_x = random() * 360;
		newmis.angles_y = random() * 360;
		newmis.touch = hipRubbleTouch;
		newmis.noise = "chaos/rockfall.wav";
	}
	else if (code == "explosion")
	{
// this was a compile warning: "hipnotic/hiprubbl.qc:114: warning: Implicit conversion"
// we believe the code should be as follows...
//		newmis.velocity_x = (self.velocity + random() * (self.velocity * 3)) + v_up * crandom() * 100 + v_right * crandom() * 100;

		newmis.velocity = (self.velocity + random() * (self.velocity * 3)) + v_up * crandom() * 100 + v_right * crandom() * 100;
//		newmis.velocity_y = 5 * crandom();
//		newmis.velocity_z = -75 + random() * -50;
		newmis.avelocity_x = random() * 100;
		newmis.avelocity_y = random() * 100;
		newmis.avelocity_z = random() * 100;
		newmis.dmg = RUBBLE_DMGDEF * random() + 5;
		newmis.touch = hipRubbleTouch;
		newmis.angles_x = random() * 360;
		newmis.angles_y = random() * 360;
		newmis.noise = "chaos/rockfall.wav";
	}

	newmis.flags = 0;
	newmis.think = meltthink;
	newmis.th_die = RubbleInSolid;
	newmis.noise4 = null_string;
	newmis.nextthink = time + RUBBLE_TIME + crandom()* RUBBLE_TDEV;
	newmis.classname = "rubble";
	newmis.class_select = "class_rubble";
	newmis.netname = "a piece of rubble";
//	content_cycle(newmis, FLT_LAVA | MLT_LAVA | CK_EARTHQUAKE | PF_WATER | PF_SLIME | PF_SOLID | FL_NOPART, CONTENT_CHKTM);
//	newmis.th_stand = floaterPointer;
//	newmis.frame = 0;
};

void() rubble_use =
{
	local float which;
	local float index;
	
	index = 0;
	
	do 
	   {
		which = self.cnt;
		if ( self.cnt == 0 )
			{
			which = 1 + 3*random();
			which = floor( which );
			}
		if ( which == 1 )
		   {
		   hipThrowRubble( "progs/rubble_m.mdl", $hiprubl1, 2, self.origin, "hip" ); // frm 4, skn 2
		   }
		else if ( which == 2 )
		   {
		   hipThrowRubble( "progs/rubble_m.mdl", $hiprubl3, 1, self.origin, "hip" ); // frm 13, skn 1
		   }
		else
		   {
		   hipThrowRubble( "progs/rubble_m.mdl", $hiprubl2, 1, self.origin, "hip" ); // frm 7, skn1
		   }
		index = index + 1;
		}
	while( index < self.count );
};

/*QUAKED func_rubble (0.4 0.4 0.2) (0 0 0) (32 32 32)
  Spawns random sized rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble =
{
//	precache_model ("progs/rubble1.mdl");
//	precache_model ("progs/rubble2.mdl");
//	precache_model ("progs/rubble3.mdl");
	precache_model ("progs/rubble_m.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble";
	self.cnt = 0;
	self.use = rubble_use;
};
	
/*QUAKED func_rubble1 (0.4 0.4 0.2) (0 0 0) (8 8 8)
  Spawns small rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble1 =
{
//	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble_m.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble1";
	self.cnt = $hiprubl1;
	self.use = rubble_use;
};
	
/*QUAKED func_rubble2 (0.4 0.4 0.2) (0 0 0) (16 16 16)
  Spawns medium rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble2 =
{
//	precache_model ("progs/rubble3.mdl");
	precache_model ("progs/rubble_m.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble2";
	self.cnt = $hiprubl2;
	self.use = rubble_use;
};
	
/*QUAKED func_rubble3 (0.4 0.4 0.2) (0 0 0) (32 32 32)
  Spawns large rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble3 =
{
//	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble_m.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble3";
	self.cnt = $hiprubl3;
	self.use = rubble_use;
};
	
// fn(rubble_debris) - rubble for debris from quake or explosions
// fn(rubble_debris_think) - think to spread rubble debris effects
// fn(menhir_think) - move menhirs up
// fn(menhir_break) - time is up - menhir dies

// rorg - center of rubble origin
// vel - velocity to move rubble along
// vibe - power of rubble maker

// quake debris == shaker

float MENHIR_BLAST = 43; // subtract from .distance (rise height) to determine rubble when menhir shatters

void() menhir_break =
{
	float sz;

	self.solid = SOLID_NOT;
	while (self.distance > 0)
	{
		self.origin = self.origin - ' 0 0 15';
		sz = sz + 2;
		rubble_debris(self.origin, ' 0 0 50', 1 + sz, self.skin);
		rubble_debris(self.origin, ' 0 0 50', 2 + sz, self.skin);
		self.distance = self.distance - MENHIR_BLAST;
	}
// use loop to play this once (remove turns off all sounds for an ent) - remove after 4 secs, but play only every 60
	loop_sound(self, CHAN_WEAPON,"chaos/menhir_expl.wav", 1, ATTN_NORM, 60, v0, 0, 4);
	SUB_Remove();
};

void() menhir_think =
{
	self.nextthink = time + 0.1;

	makevectors(self.angles);
	setorigin(self, self.origin + normalize(v_up) * self.lip);
	if (self.noise != null_string) ominous_hum(self.noise, 2.19);
	if (vlen(self.origin - self.oldorigin) > self.distance)
	{
		ominous_hum("misc/null.wav", 0);
		self.think = menhir_break;
		self.nextthink = time + 2 * (RUBBLE_TIME + crandom()* RUBBLE_TDEV);
	}
};

void(vector rorg, vector vel, float vibe, float rskn) rubble_debris =
{
	local float v, fr, rb, rs, dm, mflg, mr, menhr, menhsz, menhsk, m;
	local string rubblemode, surface2, msnd;
	local vector org, vel2, menhv;
	
	local float surnum2;

// no rubble if env turned off or in *_100 mode
	if (XENV) return;

																											if (WARNING)
																											if (FALSE) {
																												bprint("rubble debris: ");
																												bprint(self.classname);
																												bprint(" : "); bprint(vtos(rorg));
																												bprint(" : "); bprint(vtos(vel));
																												bprint(" : "); bprint(ftos(vibe));
																												newline(world); }

//	vibe = self.flags;
	makevectors (vel);
	org  = vel2 = v0;
	v = 2 + random() * 2;
	if (self.classname != "shaker") v = vibe / 2 + crandom() * 2;

//	if (pointcontents(rorg + ' 0 0 -6') == CONTENT_EMPTY || self.classname == "explode_debris")
	for (fr = 0; fr < v; fr = fr + 1)
	{
			mflg = 0;
// particle debris
			if (self.classname == "shaker")
			{
				org_x = crandom() * 75; // rnd pos around pnt
				org_y = crandom() * 75;
				org_z = 0 - 3 - random() * 3;
				vel2_x = crandom() * 1.5; // rnd drift
				vel2_y = crandom() * 1.5;
				vel2_z = 0 - 2 - random() * 2; // down vel2
				if (! sky_touch(null_string, rorg + org, world))
					particle (rorg + org, vel2, 3 + random() * 7, 1.6);
			}
			mr = vibe;
			if (mr > 9) mr = 9; // cap vibe for % test
// try some rubble
			if (vibe > 2)
			if ( (random() < (QUAKE_RUBBLE + QUAKE_RUBBLE_PER * ( mr - 4 ))) || self.classname != "shaker") // higher richter scale quakes make rubble too...
			{
				mr = -1;
				m = dm = 0;
				msnd = null_string;
				if (self.classname == "shaker")
				{
// setup menhirs - quakes only
					mr = 0;
					menhr = floor(random() * 2.4) * 3; // random menhir shape 0, 3, 6 additive into menhir frames
					menhsk = floor(random() * 2.4) * 2; // random menhir skin - for now 0, 2, 4

					if (random() < 0.5)
					{
						org_x = crandom() * 100; // rnd pos around pnt
						org_y = crandom() * 100;
					}
					else
					{
						org_x = crandom() * 60; // rnd pos around pnt + 40
						org_y = crandom() * 60;
						if (org_x < 0) org_x = org_x - 40;
						else org_x = org_x + 40;
						if (org_y < 0) org_y = org_y - 40;
						else org_y = org_y + 40;
					}
				}
				else
				{
					org = v_forward * random() * 10;
					org = org + v_up * crandom() * 24;
					org = org + v_right * crandom() * 24;
				}
				surnum2 = -1;
				surnum2 = getsurfacenearpoint(world, rorg + org);
				if (surnum2 >= 0)
					surface2 = getsurfacetexture(world, surnum2);

					if (rskn > 0)
						rs = rskn;
					else if (surface2 == "*lava1") // skin support for quake texs, also generic support on some maps
						{ rs = 6; mflg = MLT_LAVA; } //$aa_lava; mflg = MLT_LAVA; }
					else if (surface2 == "metal1_6")
						rs = 3; // $metal1_6;
					else if (surface2 == "metal1_3")
						rs = 4; // $metal1_3;
					else if (surface2 == "mmetal1_3")
						rs = 5; // $mmetal1_3;
					else if (world.model == "maps/dm4.bsp")
						rs = 3 + floor(random() * 2.1);
					else // no matches - pick some generic rubble skin
					{
						rs = floor(random() * 5.4);
						if (rs == 3) rs = floor(random() * 2.4); // skip 3 - its too dm4 specific for now
					}

					if (!mr && (vibe > 9 || random() < 0.2)) // big is back - even the shambler is afraid
					{
						mr = $menhirm3 + menhr;
						menhsz = menhir3_LEN;
						menhv = ' 22 22 0';
						if (random() < 0.85) msnd = "chaos/menhir.wav";
					}
					if (vibe > 6 && random() < 0.25) // size - rnd for now
					{
						rb = rint(random() * 3.4);
						if ((random() < 0.1 || TRUE) && !mr)
						{
							mr = $menhirm2 + menhr;
							menhsz = menhir2_LEN;
							menhv = ' 11 11 0';
							if (random() < 0.65) msnd = "chaos/menhir.wav";
						}
						if (rb == 0) rb = $bevelrubl2; // lg rubbles
						else if (rb == 1) rb = $bevelrubl3;
						else if (rb == 2) rb = $blocktwist4;
						else if (rb == 3) rb = $blocktrapez3;
					}
					else if (vibe > 4 && random() < 0.75)
					{
						dm = (RUBBLE_DMGDEF * 0.5) * random();
						rb = rint(random() * 3.4);
						if (!mr && (random() < 0.05 || TRUE))
						{
							mr = $menhirm1 + menhr;
							menhsz = menhir1_LEN;
							menhv = ' 6.5 6.5 0';
							if (random() < 0.45) msnd = "chaos/menhir.wav";
						}
						if (rb == 0) rb = $blockrubl1; // small rubbles
						else if (rb == 1) rb = $blockrubl2;
						else if (rb == 2) rb = $blocktrapez1;
						else if (rs != 6 && rb == 3) rb = $flattile1;
						else rb = $blocktrodd1;
					}
					else // > 2 implied by call condition for shakers
					{
						dm = 0;
						rb = rint(random() * 3.4);
						if (random() < 0.4) rb = rb + 4;
						if (rb == 0) rb = $bevelmini; // mini & micro rubbles
						else if (rb == 1) rb = $blockmini;
						else if (rb == 2) rb = $trapezmini;
						else if (rb == 3) rb = $twistmini;
						else if (rb == 4) rb = $bevelmicro;
						else if (rb == 5) rb = $blockmicro;
						else if (rb == 6) rb = $trapezmicro;
						else if (rb == 7) rb = $twistmicro;
					}
					if (self.classname == "shaker")
					{
						rubblemode = "earthquake";
						if (mr > 0)
						{
							m = 70;
							traceline (rorg + org, rorg + org - ' 0 0 2400', TRUE, self);
							vel2 = ' 0 0 4';
							while (vel2_z < (menhsz * 0.9) && m > 0) // run a solid check along menhir path seeking open space.
							{
								if (pointcontents(trace_endpos - vel2) != CONTENT_SOLID)
								{
if (WARNING) bprint("menhir ck found open\n");
									traceline (trace_endpos - vel2, trace_endpos - vel2 - ' 0 0 2400', TRUE, self);
									vel2 = ' 0 0 4';
								}
								vel2_z = vel2_z + 6;
								m = m - 1;
							}
							if (sky_touch(null_string, trace_endpos - ' 0 0 2', world)) m = 0;
							else
							if (m > 0) // sky check for q3 maps that may have sky below
							{
								dm = (menhsz * 0.5); // 20, 40, 85
								hipThrowRubble( "progs/rubble_m.mdl", mr, menhsk, trace_endpos - ' 0 0 2', rubblemode );
								if (!newmis) return;
								vel2_x = vel2_y = 0 - menhv_x;
								vel2_z = 0 - menhsz;
								newmis.classname = "menhir_rubble";
								setsize(newmis, vel2, menhv);
								newmis.velocity = newmis.avelocity = v0;
								newmis.angles_x = 17 * crandom();
								newmis.think = menhir_think;
								newmis.nextthink = random() + 20 * random();
								newmis.distance = menhsz * 0.94; // distance to rise
								newmis.lip = 0.6 + random(); // grow rate
								newmis.oldorigin = newmis.origin;
								newmis.movetype = MOVETYPE_NONE;
								newmis.noise = msnd;
								mflg = MLT_LAVA | PF_SOLID | CK_EARTHQUAKE;

																											if (WARNING)
																											if (FALSE) {
																												bprint("******\nmade a menhir (sz): ( ");
																												bprint(vtos(vel2));
																												bprint(", ");
																												bprint(vtos(menhv));
																												bprint(" )\n******\n"); }
							}
						}
					}
					else if (self.classname == "explosion") rubblemode = "explosion";
					else rubblemode = "rubble";
					if ((m < 1) && ! sky_touch(surface2, v0, world))
					{
						hipThrowRubble( "progs/rubble_m.mdl", rb, rs, rorg + org, rubblemode );
						if (!newmis) return;
						m = 1;
						if ((random() < 0.5) && (random() > (vibe / 10))) newmis.noise = null_string;
					}
					if (m > 0)
					{
						if (dm) newmis.dmg = dm;
						if (pointcontents(rorg + org) == CONTENT_SOLID) newmis.velocity = newmis.avelocity = v0;
						if (mflg) newmis.content_flag = newmis.content_flag - (newmis.content_flag & mflg);
					}

			}
	}
};

/*
void(vector rorg, vector vel, float vibe, float tdev) rubble_debris_think =
{
	local entity e;

	if (self.classname != "rubble_think")
	{ // flags, origin, maxs
		chaos_spawn(0, 0, vibe, 0, rorg, vel, vel, v0, v0, "rubble_think", null_string, SUB_Null, tdev * random(), rubble_debris_think, SUB_Null, self, world);
		return;
	}

	rubble_debris(self.origin, self.flags, self.maxs, 0);
	remove(self);
}
*/
