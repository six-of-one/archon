/* ::-::
 *
 * Cataboligne
 *
 * file: gremlin.qc
 *
 * date: 9/22/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/


$cd hipwork\models\grem
$origin 0 0 23
$scale 2
$base grembase.asc

$skin grem

// range held frames
$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6
$frame stand1 stand2 stand3 stand4 stand5
$frame pain1 pain2 pain3 pain4 pain5 pain6

// range firing frames
$frame lightfatt1 lightfatt2 lightfatt3 lightfatt4

$frame light1 light2 light3 light4

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6
$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

// crouching & prone frames

$frame crouchdown1 crouchdown2 crouchdown3
$frame crouch1 crouch2 crouch3 crouch4 crouch5
$frame prone1 prone2 prone3 prone4 prone5 prone6 prone7

// weapon storage access

$frame dropull1 dropull2 dropull3 dropull4 dropull5 dropull6 dropull7

// melee held frames

$frame meleerun1 meleerun2 meleerun3 meleerun4 meleerun5 meleerun6
$frame meleestnd1 meleestnd2 meleestnd3 meleestnd4 meleestnd5 meleestnd6
$frame meleestnd7 meleestnd8 meleestnd9 meleestnd10 meleestnd11 meleestnd12
$frame meleepain1 meleepain2 meleepain3 meleepain4 meleepain5 meleepain6

// melee firing frames

$frame meleeatt1 meleeatt2 meleeatt3 meleeatt4 meleeatt5 meleeatt6
$frame clawatt1 clawatt2 clawatt3 clawatt4 clawatt5 clawatt6
$frame biteatt1 biteatt2 biteatt3 biteatt4 biteatt5 biteatt6

$frame unused1 unused2 unused3 unused4 unused5 unused6

// death
$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11

$frame severedhead

// fly frames - match to run & stand for viswep code
$frame flymove1 flymove2 flymove3 flymove4 flymove5 flymove6
$frame flyhover1 flyhover2 flyhover3 flyhover4 flyhover5

$frame spawn1 spawn2 spawn3 spawn4 spawn5 spawn6 spawn7 spawn8 spawn9 spawn10



$frame maul1.asc maul2.asc maul3.asc maul4.asc maul5.asc maul6.asc
$frame maul7.asc maul8.asc maul9.asc maul10.asc maul11.asc maul12.asc maul13.asc

$frame flip1.asc flip2.asc flip3.asc flip4.asc flip5.asc flip6.asc flip7.asc
$frame flip8.asc

//============================================================================

/*
sounds

idle1 - laugh1
idle2 - laugh4
idle3 - laugh6

pain2 - growls_2a
pain3.wav - grr_amp
pain1.wav - laugh7_amp

sight1 - yum_yum
sight2 - billy_amp
sight3 - gun (monster getting gun?)
sight4 - water (monster near water?)

group sounds:
gsight - carol
gidle1 - laughs
gidle2 - laughs
gidle3 - laughs
gidle_growl

thematic:
immerse - big dump in pool
minitheme - small theme
pod_birth - exit pod music


*/


//============================================================================

float NumGremlins;
float NumSpawnGremlins;

entity()GremlinFindVictim;


/*
===========
GremlinFindTarget

gremlin is currently not attacking anything, so try to find a target

============
*/
float() GremlinFindTarget =
   {
   local entity   head;
   local entity   gorge;
   local float    dist;
   local float    result;

   if ((self.stoleweapon==0) && time > self.wait)
      {
      self.wait = time + 1.0;
      dist = 2000;
      gorge = world;
      head = nextent(world);
      while (head!=world)
         {
         if ((head.health < 1) && (head.flags & (FL_MONSTER|FL_CLIENT)))
            {
            result = fabs(head.origin_z - self.origin_z);
            if ((visible(head)) && (result<80) && (head.gorging == FALSE) && (visible_distance<dist))
               {
               dist = visible_distance;
               gorge = head;
               }
            }
         head = nextent(head);
         }
      if ((gorge != world) && (dist < (700*random())))
         {
// NOTE: not sure wht to do with this code! - cant go into gorge, its weird with the new model
return FALSE;

//         dprint("starting to gorge on ");
//         dprint(gorge.classname);
//         dprint("\n");
         self.oldenemy = self.enemy;
         self.gorging = TRUE;
         self.enemy = gorge;
         self.search_time = time + 4.0;
         FoundTarget();
         return TRUE;
         }
      }
   else if (self.stoleweapon)
      {
      head = GremlinFindVictim();
      if (head != world)
         {
         self.enemy = head;
         FoundTarget();
         self.attack_finished = time;
         self.search_time = time + 2.0;
         return TRUE;
         }
      }
   result = FindTarget();
   self.search_time = time + 2.0;
   return result;
   };
//============================================================================
/*
=============
gremlin_walk

The monster is walking it's beat
=============
*/
void(float dist) gremlin_walk =
   {
	movedist = dist;

	if (self.flags & FL_FLY)
	if (WALKSOUND && (self.cnt < time)) morph_walksound("gremlin/hover_flap.wav",1.35);

	// check for noticing a player
   if (GremlinFindTarget ())
		return;

	movetogoal (dist);
   };

//============================================================================

/*
=============
gremlin_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() gremlin_stand =
   {
   if (FindTarget ())
		return;

	if (time > self.pausetime)
      {
		self.th_walk ();
		return;
      }
   };

//============================================================================
float() GremlinCheckNoAmmo;
void() gremlin_glook1;
/*
=============
gremlin_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) gremlin_run =
   {
//   local entity oldtarget;
   local float r;
   local vector d;

// spawning go back
   if (self.frame >= $spawn1 && self.frame <= $spawn10) return;

	if (self.flags & FL_FLY)
	if (WALKSOUND && (self.cnt < time)) morph_walksound("gremlin/fly_flap.wav",2.2);

   if (self.watertype == CONTENT_LAVA)
      {  // do damage
      T_Damage (self, world, world, 2000);
      }
   movedist = dist;

// *** FIX - need gun frames only if carrying
//   if (self.stoleweapon)
//      self.frame = self.frame + $grun1.asc - $run1.asc;

   if (self.gorging)
      {
      traceline(self.origin, self.enemy.origin, TRUE, self);
      if (trace_fraction != 1.0)
         {
         self.gorging = FALSE;
         return;
         }
      if (!visible(self.enemy))
         {
         self.gorging = FALSE;
         return;
         }
      r = vlen(self.enemy.origin - self.origin);
      if (r < 130)
         {
         ai_face();
         if (r < 45)
            {
            self.th_melee ();
            self.attack_state = AS_STRAIGHT;
            return;
            }
         else if (walkmove (self.angles_y, dist) == FALSE)
            {
            self.gorging = FALSE;
            return;
            }
         return;
         }
      movetogoal (dist);      // done in C code...
      }
   else
      {
      if (random()>0.97)
         {
         if (GremlinFindTarget())
            return;
         }
      // get away from player if we stole a weapon
      if (self.stoleweapon)
         {
         if (self.enemy.health < 0 && self.enemy.classname == "player")
            {
            gremlin_glook1();
            return;
            }
         if (!GremlinCheckNoAmmo())
            {
            if (self.t_length==1)
               {
               remove(self.trigger_field);
               self.goalentity = self.enemy;
               self.t_length = 0;
               }
            return;
            }
         r = vlen(self.enemy.origin - self.origin);
         d = normalize(self.origin-self.enemy.origin);
         if (self.t_length == 0)
            {
            if (r<150)
               {
               self.trigger_field = spawn();
               setsize(self.trigger_field,'-1 -1 -1','1 1 1');
               self.t_length = 1;
               }
            }
         if (self.t_length==1)
            {
            if (r > 250)
               {
               remove(self.trigger_field);
               self.goalentity = self.enemy;
               self.t_length = 0;
//               self.attack_state = AS_SLIDING;
               }
            else
               {
               if (r < 160)
                  {
                  local vector ang;
                  local float done;
                  local vector end;
                  local float c;

                  ang = vectoangles(d);
                  done = 0;
                  c = 0;
                  while (done == 0)
                     {
                     makevectors(ang);
                     end = self.enemy.origin + v_forward * 350;
                     traceline(self.enemy.origin,end,FALSE,self);
                     if (trace_fraction == 1.0)
                        {
                        traceline(self.origin,end,FALSE,self);
                        if (trace_fraction == 1.0)
                           done = 1;
                        }
                     ang_y = anglemod(ang_y + 36);
                     c = c + 1;
                     if (c == 10)
                        {
                        done = 1;
                        }
                     }
                  setorigin(self.trigger_field,end);
                  }
               self.goalentity = self.trigger_field;
               self.ideal_yaw = vectoyaw(normalize(self.goalentity.origin-self.origin));
               ChangeYaw ();
               movetogoal (dist);      // done in C code...
               self.nextthink = time + 0.1;
               return;
               }
            }
         }
      ai_run(dist);
      self.nextthink = time + 0.1;
      }
   };

//============================================================================

void()   Gremlin_JumpTouch;
void()   Gremlin_FlipTouch;
void(float stc)  Gremlin_Melee;
void(float side)  Gremlin_Gorge;
void()   gremlin_stand1;

// standing, no wep or melee wep held
void()   gremlin_mlstand1  =[ $meleestnd1, gremlin_mlstand2  ]
{
	if (self.stoleweapon)
	{
		gremlin_stand1();
		return;
	}

	gremlin_stand();
	self.nextthink = time + 0.2;
};
void()   gremlin_mlstand2  =[ $meleestnd2, gremlin_mlstand3  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand3  =[ $meleestnd3, gremlin_mlstand4  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand4  =[ $meleestnd4, gremlin_mlstand5  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand5  =[ $meleestnd5, gremlin_mlstand6  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand6  =[ $meleestnd6, gremlin_mlstand7  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand7  =[ $meleestnd7, gremlin_mlstand8  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand8  =[ $meleestnd8, gremlin_mlstand9  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand9  =[ $meleestnd9, gremlin_mlstand10  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand10  =[ $meleestnd10, gremlin_mlstand11  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand11  =[ $meleestnd11, gremlin_mlstand12  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_mlstand12  =[ $meleestnd12, gremlin_mlstand1  ] {gremlin_stand();self.nextthink = time + 0.2;};

// standing with range wep
void()   gremlin_stand1  =[ $stand1, gremlin_stand2  ]
{
	if (!self.stoleweapon)
	{
		gremlin_mlstand1();
		return;
	}

	gremlin_stand();
	self.nextthink = time + 0.2;
};
void()   gremlin_stand2  =[ $stand2, gremlin_stand3  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand3  =[ $stand3, gremlin_stand4  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand4  =[ $stand4, gremlin_stand5  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand5  =[ $stand5, gremlin_stand1  ] {gremlin_stand();self.nextthink = time + 0.2;};
/*
void()   gremlin_stand6  =[ $stand6.asc, gremlin_stand7  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand7  =[ $stand7.asc, gremlin_stand8  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand8  =[ $stand8.asc, gremlin_stand9  ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand9  =[ $stand9.asc, gremlin_stand10 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand10 =[ $stand10.asc,   gremlin_stand11 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand11 =[ $stand11.asc,   gremlin_stand12 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand12 =[ $stand12.asc,   gremlin_stand13 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand13 =[ $stand13.asc,   gremlin_stand14 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand14 =[ $stand14.asc,   gremlin_stand15 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand15 =[ $stand15.asc,   gremlin_stand16 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand16 =[ $stand16.asc,   gremlin_stand17 ] {gremlin_stand();self.nextthink = time + 0.2;};
void()   gremlin_stand17 =[ $stand17.asc,   gremlin_stand1  ] {gremlin_stand();self.nextthink = time + 0.2;};
*/

void()   gremlin_walk1;

// in flight moving slowly or hovering
void()   gremlin_hover1  =[ $flyhover1, gremlin_hover2  ]
{
	if (! self.flags & FL_FLY)
	{
		gremlin_walk1();
		return;
	}

// NOTE: check vertical movement
	gremlin_walk(8);
	self.nextthink = time + 0.2;
};
void()   gremlin_hover2  =[ $flyhover2, gremlin_hover3  ] {gremlin_walk(8);self.nextthink = time + 0.2;};
void()   gremlin_hover3  =[ $flyhover3, gremlin_hover4  ] {gremlin_walk(8);self.nextthink = time + 0.2;};
void()   gremlin_hover4  =[ $flyhover4, gremlin_hover5  ] {gremlin_walk(8);self.nextthink = time + 0.2;};
void()   gremlin_hover5  =[ $flyhover5, gremlin_hover1  ] {gremlin_walk(8);self.nextthink = time + 0.2;};


void()   gremlin_mlwalk1 =[ $meleerun1,      gremlin_mlwalk2 ]
{
	if (self.model == "progs/gremlin-fly.mdl")
	if (self.flags & FL_FLY)
	{
		gremlin_hover1();
		return;
	}

	if (self.stoleweapon)
	{
		gremlin_walk1();
		return;
	}

	if (random() < 0.1)
		sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/idle1.wav","gremlin/idle2.wav","gremlin/sight1.wav","gremlin/sight2.wav","gremlin/idle3.wav"), 1, ATTN_IDLE);
	gremlin_walk(8);
};
void()   gremlin_mlwalk2 =[ $meleerun2,      gremlin_mlwalk3 ] {gremlin_walk(8);};
void()   gremlin_mlwalk3 =[ $meleerun3,      gremlin_mlwalk4 ] {gremlin_walk(8);};
void()   gremlin_mlwalk4 =[ $meleerun4,      gremlin_mlwalk5 ] {gremlin_walk(8);};
void()   gremlin_mlwalk5 =[ $meleerun5,      gremlin_mlwalk6 ] {gremlin_walk(8);};
void()   gremlin_mlwalk6 =[ $meleerun6,      gremlin_mlwalk1 ] {gremlin_walk(8);};

void()   gremlin_walk1 =[ $rockrun1,      gremlin_walk2 ]
{
	if (self.model == "progs/gremlin-fly.mdl")
	if (self.flags & FL_FLY)
	{
		gremlin_hover1();
		return;
	}

	if (!self.stoleweapon)
	{
		gremlin_mlwalk1();
		return;
	}

	if (random() < 0.1)
		sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/idle1.wav","gremlin/idle2.wav","gremlin/sight1.wav","","gremlin/idle3.wav"), 1, ATTN_IDLE);
	gremlin_walk(8);
};
void()   gremlin_walk2 =[ $rockrun2,      gremlin_walk3 ] {gremlin_walk(8);};
void()   gremlin_walk3 =[ $rockrun3,      gremlin_walk4 ] {gremlin_walk(8);};
void()   gremlin_walk4 =[ $rockrun4,      gremlin_walk5 ] {gremlin_walk(8);};
void()   gremlin_walk5 =[ $rockrun5,      gremlin_walk6 ] {gremlin_walk(8);};
void()   gremlin_walk6 =[ $rockrun6,      gremlin_walk1 ] {gremlin_walk(8);};
/*
void()   gremlin_walk7 =[ $walk7.asc,      gremlin_walk8 ] {gremlin_walk(8);};
void()   gremlin_walk8 =[ $walk8.asc,      gremlin_walk9 ] {gremlin_walk(8);};
void()   gremlin_walk9 =[ $walk9.asc,      gremlin_walk10 ] {gremlin_walk(8);};
void()   gremlin_walk10 =[ $walk10.asc,      gremlin_walk11 ] {gremlin_walk(8);};
void()   gremlin_walk11 =[ $walk11.asc,      gremlin_walk12 ] {gremlin_walk(8);};
void()   gremlin_walk12 =[ $walk12.asc,      gremlin_walk1 ] {gremlin_walk(8);};
*/

void()   gremlin_run1;
// in flight moving
void()   gremlin_fly1  =[ $flymove1, gremlin_fly2  ]
{
	if (! self.flags & FL_FLY)
	{
		gremlin_run1();
		return;
	}
	if (random() < 0.05)
		sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/idle1.wav","gremlin/idle2.wav","gremlin/sight1.wav","gremlin/sight2.wav","gremlin/idle3.wav"), 1, ATTN_IDLE);

// NOTE: check vertical movement
	gremlin_run(24);
//	self.nextthink = time + 0.2;
};
void()   gremlin_fly2  =[ $flymove2, gremlin_fly3  ] {gremlin_run(24);};
void()   gremlin_fly3  =[ $flymove3, gremlin_fly4  ] {gremlin_run(24);};
void()   gremlin_fly4  =[ $flymove4, gremlin_fly5  ] {gremlin_run(24);};
void()   gremlin_fly5  =[ $flymove5, gremlin_fly6  ] {gremlin_run(24);};
void()   gremlin_fly6  =[ $flymove6, gremlin_fly1  ] {gremlin_run(24);};

// running no wep or melee wep
void()   gremlin_mlrun1 =[ $meleerun1,      gremlin_mlrun2 ]
{
	if (self.model == "progs/gremlin-fly.mdl")
	if (self.flags & FL_FLY)
	{
		gremlin_fly1();
		return;
	}
	if (self.stoleweapon)
	{
		gremlin_run1();
		return;
	}

	if (random() < 0.05)
		sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/idle1.wav","gremlin/idle2.wav","gremlin/sight1.wav","","gremlin/idle3.wav"), 1, ATTN_IDLE);
	gremlin_run(16);
};
void()   gremlin_mlrun2 =[ $meleerun2,      gremlin_mlrun3 ] {gremlin_run(14);};
void()   gremlin_mlrun3 =[ $meleerun3,      gremlin_mlrun4 ] {gremlin_run(12);};
void()   gremlin_mlrun4 =[ $meleerun4,      gremlin_mlrun5 ] {gremlin_run(16);};
void()   gremlin_mlrun5 =[ $meleerun5,      gremlin_mlrun6 ] {gremlin_run(14);};
void()   gremlin_mlrun6 =[ $meleerun6,      gremlin_mlrun1 ] {gremlin_run(14);};

// running range wep
void()   gremlin_run1 =[ $rockrun1,      gremlin_run2 ]
{
	if (self.model == "progs/gremlin-fly.mdl")
	if (self.flags & FL_FLY)
	{
		gremlin_fly1();
		return;
	}
	if (!self.stoleweapon)
	{
		gremlin_mlrun1();
		return;
	}

	if (random() < 0.05)
		sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/idle1.wav","gremlin/idle2.wav","gremlin/sight1.wav","","gremlin/idle3.wav"), 1, ATTN_IDLE);
	gremlin_run(16);
};
void()   gremlin_run2 =[ $rockrun2,      gremlin_run3 ] {gremlin_run(14);};
void()   gremlin_run3 =[ $rockrun3,      gremlin_run4 ] {gremlin_run(12);};
void()   gremlin_run4 =[ $rockrun4,      gremlin_run5 ] {gremlin_run(16);};
void()   gremlin_run5 =[ $rockrun5,      gremlin_run6 ] {gremlin_run(14);};
void()   gremlin_run6 =[ $rockrun6,      gremlin_run1 ] {gremlin_run(14);};

/*
void()   gremlin_run7 =[ $run7.asc,      gremlin_run8 ] {gremlin_run(8);};
void()   gremlin_run8 =[ $run8.asc,      gremlin_run9 ] {gremlin_run(0);};
void()   gremlin_run9 =[ $run9.asc,      gremlin_run10 ] {gremlin_run(8);};
void()   gremlin_run10 =[ $run10.asc,      gremlin_run11 ] {gremlin_run(12);};
void()   gremlin_run11 =[ $run11.asc,      gremlin_run12 ] {gremlin_run(16);};
void()   gremlin_run12 =[ $run12.asc,      gremlin_run1 ] {gremlin_run(16);};
void()   gremlin_run13 =[ $run13.asc,      gremlin_run14 ] {gremlin_run(12);};
void()   gremlin_run14 =[ $run14.asc,      gremlin_run15 ] {gremlin_run(8);};
void()   gremlin_run15 =[ $run15.asc,      gremlin_run1 ] {gremlin_run(0);};
*/

void()   gremlin_jump1   =[ $meleestnd1,     gremlin_jump2   ] {ai_face();};
void()   gremlin_jump2   =[ $meleestnd2,     gremlin_jump3   ] {ai_face();};
void()   gremlin_jump3   =[ $meleerun1,     gremlin_jump4   ] {ai_face();};
void()   gremlin_jump4   =[ $meleerun2,     gremlin_jump5   ] {ai_face();};
void()   gremlin_jump5   =[ $meleerun3,     gremlin_jump6   ]
{
	ai_face();

   if (self.flags & FL_ONGROUND)
      {
      self.touch = Gremlin_JumpTouch;
      makevectors (self.angles);
      self.origin_z = self.origin_z + 1;
      self.velocity = v_forward * 300 + '0 0 300';
      self.flags = self.flags - FL_ONGROUND;
      }
   else
      {
      gremlin_run1();
      }
};
void()   gremlin_jump6   =[ $meleerun4,     gremlin_jump7   ] {};
void()   gremlin_jump7   =[ $meleerun5,     gremlin_jump8   ] {};
void()   gremlin_jump8   =[ $meleerun6,     gremlin_jump9   ] {};
void()   gremlin_jump9   =[ $meleerun1,     gremlin_jump10   ] {};
void()   gremlin_jump10   =[ $meleerun2,     gremlin_jump11   ] {};
void()   gremlin_jump11   =[ $meleerun3,     gremlin_jump1   ]
   {
   self.nextthink = time + 3;
   // if three seconds pass, assume gremlin is stuck and jump again
   };

void()   gremlin_jump12   =[ $meleestnd1,    gremlin_jump13  ] {};
void()   gremlin_jump13   =[ $meleestnd2,    gremlin_jump14  ] {};
void()   gremlin_jump14   =[ $meleerun1,    gremlin_jump15  ] {};
void()   gremlin_jump15   =[ $meleerun2,    gremlin_jump16  ] {};
void()   gremlin_jump16   =[ $meleerun3,    gremlin_run1 ] {};

void()   gremlin_shot1 = [$shotatt1, gremlin_shot2   ] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()   gremlin_shot2 = [$shotatt2, gremlin_shot3   ] {};
void()   gremlin_shot3 = [$shotatt3, gremlin_shot4   ] {};
void()   gremlin_shot4 = [$shotatt4, gremlin_shot5   ] {};
void()   gremlin_shot5 = [$shotatt5, gremlin_shot6   ] {};
void()   gremlin_shot6 = [$shotatt6, gremlin_run1   ] {};


//============================================================================
void() Gremlin_FireNailGun;

void() gremlin_nail1   =[$lightfatt1, gremlin_nail2  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
//   Gremlin_FireNailGun(4);
   Gremlin_FireNailGun();
   };
void() gremlin_nail2   =[$lightfatt2, gremlin_nail3  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireNailGun();
   };
void() gremlin_nail3   =[$lightfatt1, gremlin_nail4  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireNailGun();
   };
void() gremlin_nail4   =[$lightfatt2, gremlin_nail5  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireNailGun();
   };
void() gremlin_nail5   =[$lightfatt1, gremlin_nail6  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireNailGun();
   };
void() gremlin_nail6   =[$lightfatt2, gremlin_nail7  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireNailGun();
   };
void() gremlin_nail7 = [$lightfatt1, gremlin_run1   ] {};


//void(float ox) Gremlin_FireLaserGun;

void() gremlin_laser1   =[$lightfatt1, gremlin_laser7  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
//   Gremlin_FireLaserGun(4);
   };
/*
void() gremlin_laser2   =[$gfire1.asc, gremlin_laser3  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireLaserGun(4);
   };
void() gremlin_laser3   =[$gfire1.asc, gremlin_laser4  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireLaserGun(4);
   };
void() gremlin_laser4   =[$gfire1.asc, gremlin_laser5  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireLaserGun(4);
   };
void() gremlin_laser5   =[$gfire1.asc, gremlin_laser6  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireLaserGun(4);
   };
void() gremlin_laser6   =[$gfire1.asc, gremlin_laser7  ]
   {
	self.effects = self.effects | EF_MUZZLEFLASH;
   Gremlin_FireLaserGun(4);
   };*/
void() gremlin_laser7 = [$lightfatt1, gremlin_run1   ] {};

//============================================================================

void() Gremlin_FireLightningGun;
void() gremlin_light1   =[$lightfatt1, gremlin_light2  ]
   {
   Gremlin_FireLightningGun();
   };
void() gremlin_light2 = [$lightfatt2, gremlin_light3   ]
   {
   Gremlin_FireLightningGun();
   };
void() gremlin_light3   =[$lightfatt3, gremlin_light4  ]
   {
   Gremlin_FireLightningGun();
   };
void() gremlin_light4 = [$lightfatt4, gremlin_light5   ]
{
   Gremlin_FireLightningGun();
};
void() gremlin_light5 = [$lightfatt1, gremlin_run1   ] {};

//============================================================================

void()   gremlin_rocket1 = [$rockatt1, gremlin_rocket2   ] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()   gremlin_rocket2 = [$rockatt2, gremlin_rocket3   ] {};
void()   gremlin_rocket3 = [$rockatt3, gremlin_rocket4   ] {};
void()   gremlin_rocket4 = [$rockatt4, gremlin_rocket5   ] {};
void()   gremlin_rocket5 = [$rockatt5, gremlin_rocket6   ] {};
void()   gremlin_rocket6 = [$rockatt6, gremlin_run1   ] {};

void()   gremlin_lunge1   =[ $biteatt1,     gremlin_lunge2   ] {ai_charge(0);};
void()   gremlin_lunge2   =[ $biteatt2,     gremlin_lunge3   ] {ai_charge(0);};
void()   gremlin_lunge3   =[ $biteatt3,     gremlin_lunge4   ] {ai_charge(0);};
void()   gremlin_lunge4   =[ $biteatt4,     gremlin_lunge5   ] {ai_charge(8);Gremlin_Melee(ST_BITE);};
void()   gremlin_lunge5   =[ $biteatt5,     gremlin_lunge6   ] {ai_charge(0);};
void()   gremlin_lunge6   =[ $biteatt6,     gremlin_run1   ] {ai_charge(0);};
/*
void()   gremlin_lunge1   =[ $lunge1.asc,     gremlin_lunge2   ] {ai_charge(0);};
void()   gremlin_lunge2   =[ $lunge2.asc,     gremlin_lunge3   ] {ai_charge(0);};
void()   gremlin_lunge3   =[ $lunge3.asc,     gremlin_lunge4   ] {ai_charge(0);};
void()   gremlin_lunge4   =[ $lunge4.asc,     gremlin_lunge5   ] {ai_charge(0);};
void()   gremlin_lunge5   =[ $lunge5.asc,     gremlin_lunge6   ] {ai_charge(0);};
void()   gremlin_lunge6   =[ $lunge6.asc,     gremlin_lunge7   ] {ai_charge(0);};
void()   gremlin_lunge7   =[ $lunge7.asc,     gremlin_lunge8   ] {ai_charge(15);};
void()   gremlin_lunge8   =[ $lunge8.asc,     gremlin_lunge9   ] {ai_charge(0);Gremlin_Melee(0);};
void()   gremlin_lunge9   =[ $lunge9.asc,     gremlin_lunge10] {ai_charge(0);};
void()   gremlin_lunge10  =[ $lunge10.asc,    gremlin_lunge11] {ai_charge(0);};
void()   gremlin_lunge11  =[ $lunge11.asc,    gremlin_run1] {ai_charge(0);};
*/

void()   gremlin_claw1   =[ $clawatt1,     gremlin_claw2   ] {ai_charge(0);};
void()   gremlin_claw2   =[ $clawatt2,     gremlin_claw3   ] {ai_charge(0);};
void()   gremlin_claw3   =[ $clawatt3,     gremlin_claw4   ] {ai_charge(0);};
void()   gremlin_claw4   =[ $clawatt4,     gremlin_claw5   ] {ai_charge(4);Gremlin_Melee(ST_CLAW);};
void()   gremlin_claw5   =[ $clawatt5,     gremlin_claw6   ] {ai_charge(0);};
void()   gremlin_claw6   =[ $clawatt6,     gremlin_run1   ] {ai_charge(0);};
/*
void()   gremlin_claw1   =[ $attk1.asc,     gremlin_claw2   ] {ai_charge(0);};
void()   gremlin_claw2   =[ $attk2.asc,     gremlin_claw3   ] {ai_charge(0);};
void()   gremlin_claw3   =[ $attk3.asc,     gremlin_claw4   ] {ai_charge(0);};
void()   gremlin_claw4   =[ $attk4.asc,     gremlin_claw5   ] {ai_charge(0);};
void()   gremlin_claw5   =[ $attk5.asc,     gremlin_claw6   ] {ai_charge(0);};
void()   gremlin_claw6   =[ $attk6.asc,     gremlin_claw7   ] {ai_charge(0);Gremlin_Melee(200);};
void()   gremlin_claw7   =[ $attk7.asc,     gremlin_claw8   ] {ai_charge(15);};
void()   gremlin_claw8   =[ $attk8.asc,     gremlin_claw9   ] {ai_charge(0);};
void()   gremlin_claw9   =[ $attk9.asc,     gremlin_claw10] {ai_charge(0);};
void()   gremlin_claw10  =[ $attk10.asc,    gremlin_claw11] {ai_charge(0);};
void()   gremlin_claw11  =[ $attk11.asc,    gremlin_run1] {ai_charge(0);};
*/

void()   gremlin_gorge1   =[ $maul1.asc,     gremlin_gorge2] {ai_charge(1);};
void()   gremlin_gorge2   =[ $maul2.asc,     gremlin_gorge3] {ai_charge(1);};
void()   gremlin_gorge3   =[ $maul3.asc,     gremlin_gorge4] {ai_charge(2);};
void()   gremlin_gorge4   =[ $maul4.asc,     gremlin_gorge5] {ai_charge(0);};
void()   gremlin_gorge5   =[ $maul5.asc,     gremlin_gorge6] {ai_charge(0);};
void()   gremlin_gorge6   =[ $maul6.asc,     gremlin_gorge7] {ai_charge(0);Gremlin_Gorge(200);};
void()   gremlin_gorge7   =[ $maul7.asc,     gremlin_gorge8] {ai_charge(0);};
void()   gremlin_gorge8   =[ $maul8.asc,     gremlin_gorge9] {ai_charge(0);Gremlin_Gorge(-200);};
void()   gremlin_gorge9   =[ $maul9.asc,     gremlin_gorge10] {ai_charge(0);};
void()   gremlin_gorge10   =[ $maul10.asc,     gremlin_gorge11] {ai_charge(0);};
void()   gremlin_gorge11   =[ $maul11.asc,     gremlin_gorge12] {ai_charge(0);};
void()   gremlin_gorge12   =[ $maul12.asc,     gremlin_gorge13] {ai_charge(0);};
void()   gremlin_gorge13   =[ $maul13.asc,     gremlin_gorge1] {ai_charge(0);};

void()   gremlin_look1   =[ $meleestnd1,     gremlin_look2] {self.nextthink = time + 0.2; self.ideal_yaw = self.ideal_yaw + 10; ChangeYaw(); };
void()   gremlin_look2   =[ $meleestnd2,     gremlin_look3] {self.nextthink = time + 0.2;};
void()   gremlin_look3   =[ $meleestnd3,     gremlin_look4] {self.nextthink = time + 0.2;};
void()   gremlin_look4   =[ $meleestnd4,     gremlin_look5] {self.nextthink = time + 0.2;};
void()   gremlin_look5   =[ $meleestnd5,     gremlin_look6] {self.nextthink = time + 0.2; self.ideal_yaw = self.ideal_yaw - 20; ChangeYaw(); };
void()   gremlin_look6   =[ $meleestnd6,     gremlin_look7] {self.nextthink = time + 0.2;};
void()   gremlin_look7   =[ $meleestnd7,     gremlin_look8] {self.nextthink = time + 0.2;};
void()   gremlin_look8   =[ $meleestnd8,     gremlin_look9] {self.nextthink = time + 0.2;};
void()   gremlin_look9   =[ $meleestnd9,     gremlin_look10] {self.nextthink = time + 0.2;};
void()   gremlin_look10  =[ $meleestnd10,    gremlin_look11] {self.nextthink = time + 0.2; self.ideal_yaw = self.ideal_yaw + 10; ChangeYaw(); };
void()   gremlin_look11  =[ $meleestnd11,     gremlin_look12] {self.nextthink = time + 0.2;};
void()   gremlin_look12  =[ $meleestnd12,     gremlin_run1]
   {
   if (self.oldenemy.health > 0)
      {
      self.enemy = self.oldenemy;
      HuntTarget ();
      }
   else
      {
      if (self.movetarget)
         self.th_walk ();
      else
         self.th_stand ();
      }
   };


void() GremlinDropBackpack;
void()   gremlin_glook1   =[ $stand1,     gremlin_glook2] { self.ideal_yaw = self.ideal_yaw + 10; ChangeYaw(); };
void()   gremlin_glook2   =[ $stand2,     gremlin_glook3] {};
void()   gremlin_glook3   =[ $stand3,     gremlin_glook4] {};
void()   gremlin_glook4   =[ $stand4,     gremlin_glook5] {};
void()   gremlin_glook5   =[ $stand5,     gremlin_glook6] {};
void()   gremlin_glook6   =[ $stand1,     gremlin_glook7] { self.ideal_yaw = self.ideal_yaw + -20; ChangeYaw(); };
void()   gremlin_glook7   =[ $stand2,     gremlin_glook8] {};
void()   gremlin_glook8   =[ $stand3,     gremlin_glook9] {};
void()   gremlin_glook9   =[ $stand4,     gremlin_glook10] {};
void()   gremlin_glook10   =[ $stand5,     gremlin_glook11] {};
void()   gremlin_glook11   =[ $stand1,     gremlin_glook12] { self.ideal_yaw = self.ideal_yaw + 20; ChangeYaw(); };
void()   gremlin_glook12   =[ $stand2,     gremlin_glook13] {};
void()   gremlin_glook13   =[ $stand3,     gremlin_glook14] {};
void()   gremlin_glook14   =[ $stand4,     gremlin_glook15] {};
void()   gremlin_glook15   =[ $stand5,     gremlin_glook16] {};
void()   gremlin_glook16   =[ $stand1,     gremlin_glook17] { self.ideal_yaw = self.ideal_yaw - 10; ChangeYaw(); };
void()   gremlin_glook17   =[ $stand2,     gremlin_glook18] {};
void()   gremlin_glook18   =[ $stand3,     gremlin_glook19] {};
void()   gremlin_glook19   =[ $stand4,     gremlin_glook20] {};

void()   gremlin_glook20   =[ $stand5,     gremlin_glook20]
   {
   GremlinDropBackpack();
   self.stoleweapon = FALSE;
   if (self.oldenemy.health > 0)
      {
      self.enemy = self.oldenemy;
      HuntTarget ();
      }
   else
      {
      if (self.movetarget)
         self.th_walk ();
      else
         self.th_stand ();
      }
   };

void()   gremlin_pain1   =[ $meleepain1,     gremlin_pain2   ] {ai_back(2);};
void()   gremlin_pain2   =[ $meleepain2 ,     gremlin_pain3   ] {ai_back(4);};
void()   gremlin_pain3   =[ $meleepain3 ,     gremlin_pain4   ] {ai_back(2);};
void()   gremlin_pain4   =[ $meleepain4 ,     gremlin_pain5   ] { };
void()   gremlin_pain5   =[ $meleepain5 ,     gremlin_pain6   ] { };
void()   gremlin_pain6   =[ $meleepain6 ,     gremlin_run1 ] { };

void()   gremlin_gunpain1   =[ $pain1,     gremlin_gunpain2   ] { };
void()   gremlin_gunpain2   =[ $pain2,     gremlin_gunpain3   ] {ai_back(4);};
void()   gremlin_gunpain3   =[ $pain3,     gremlin_gunpain4   ] { };
void()   gremlin_gunpain4   =[ $pain4,     gremlin_gunpain5   ] { };
void()   gremlin_gunpain5   =[ $pain5,     gremlin_gunpain6   ] { };
void()   gremlin_gunpain6   =[ $pain6,     gremlin_run1 ] { };

void(entity attacker, float damage) gremlin_pain =
{
//   local float r;

   if (random()<0.8)
      {
      self.gorging = FALSE;
      self.enemy = attacker;
      FoundTarget();
      }
   if (self.touch == Gremlin_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
//   if (random()<0.5)
//      sound (self, CHAN_VOICE, "grem/pain2.wav", 1, ATTN_NORM);
//   else
//   r = random();
//   if (r<0.33)
      sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/pain1.wav","gremlin/pain2.wav","","","gremlin/pain3.wav"), 1, ATTN_NORM);
//   else if (r<0.66)
//      sound (self, CHAN_VOICE, "grem/pain2.wav", 1, ATTN_NORM);
//   else
//      sound (self, CHAN_VOICE, "grem/pain3.wav", 1, ATTN_NORM);

   if (self.stoleweapon)
      {
      gremlin_gunpain1 ();
      }
   else
      {
      gremlin_pain1 ();
      }
};

void()   gremlin_spawn1 =[ $spawn1,      gremlin_spawn2 ] 
{
   self.nextthink = time + 0.2;
   self.th_pain = SUB_Null;
//    sound (self, CHAN_VOICE, rnd_string(v0, "gremlin/idle1.wav","gremlin/idle2.wav","gremlin/sight1.wav","","gremlin/idle3.wav"), 1, ATTN_IDLE);
};
void()   gremlin_spawn2 =[ $spawn2,      gremlin_spawn3 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn3 =[ $spawn3,      gremlin_spawn4 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn4 =[ $spawn4,      gremlin_spawn5 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn5 =[ $spawn5,      gremlin_spawn6 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn6 =[ $spawn6,      gremlin_spawn7 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn7 =[ $spawn7,      gremlin_spawn8 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn8 =[ $spawn8,      gremlin_spawn9 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn9 =[ $spawn9,      gremlin_spawn10 ] {self.nextthink = time + 0.2;};
void()   gremlin_spawn10 =[ $spawn10,   gremlin_run1 ] {
   self.th_pain = gremlin_pain;
};


void()   gremlin_die1    =[ $death1,    gremlin_die2 ]
{
sound (self, CHAN_VOICE, rnd_string(' 50 25 12', "gremlin/gidle_growl.wav","gremlin/pain2.wav","","","gremlin/minitheme.wav"), 1, ATTN_NORM);
};
void()   gremlin_die2    =[ $death2,    gremlin_die3 ] { };
void()   gremlin_die3    =[ $death3,    gremlin_die4 ] { };
void()   gremlin_die4    =[ $death4,    gremlin_die5 ] { };
void()   gremlin_die5    =[ $death5,    gremlin_die6 ] { };
void()   gremlin_die6    =[ $death6,    gremlin_die7 ] { self.solid = SOLID_NOT; };
void()   gremlin_die7    =[ $death7,    gremlin_die8 ] { };
void()   gremlin_die8    =[ $death8,    gremlin_die9 ] { };
void()   gremlin_die9    =[ $death9,    gremlin_die9 ] { self.classname="deadbody"; }; // Cataboligne - so more can spawn


void()   gremlin_die1b    =[ $deathb1,    gremlin_die2b ]
{
sound (self, CHAN_VOICE, rnd_string(' 50 25 12', "gremlin/gidle_growl.wav","gremlin/pain2.wav","","","gremlin/minitheme.wav"), 1, ATTN_NORM);
};
void()   gremlin_die2b    =[ $deathb2,    gremlin_die3b ] { };
void()   gremlin_die3b    =[ $deathb3,    gremlin_die4b ] { };
void()   gremlin_die4b    =[ $deathb4,    gremlin_die5b ] { };
void()   gremlin_die5b    =[ $deathb5,    gremlin_die6b ] { };
void()   gremlin_die6b    =[ $deathb6,    gremlin_die7b ] { self.solid = SOLID_NOT; };
void()   gremlin_die7b    =[ $deathb7,    gremlin_die8b ] { };
void()   gremlin_die8b    =[ $deathb8,    gremlin_die9b ] { };
void()   gremlin_die9b    =[ $deathb9,    gremlin_die10b ] { };
void()   gremlin_die10b    =[ $deathb10,    gremlin_die11b ] { };
void()   gremlin_die11b    =[ $deathb11,    gremlin_die11b ] { self.classname="deadbody"; }; // Cataboligne - so more can spawn

void() gremlin_gib=
   {
   sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
//	ThrowHead ("progs/h_grem.mdl", -35);
	ThrowHead ("progs/gremlin.mdl", -35);
	self.frame = $severedhead;
//	item_throwGib ("progs/gremlin.mdl", self.health, "gib", 10 + random()*10, $severedhead);
   ThrowGib ("progs/gib1.mdl", -35);
   ThrowGib ("progs/gib1.mdl", -35);
   ThrowGib ("progs/gib1.mdl", -35);
   };

void()   gremlin_flip1    =[ $flip1.asc,    gremlin_flip2 ]
   {
   ai_face();
	makevectors (self.angles);
   self.origin_z = self.origin_z + 1;
   self.velocity = '0 0 350' - (v_forward * 200);
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
   sound (self, CHAN_VOICE, rnd_string(' 50 25 12', "gremlin/gidle_growl.wav","gremlin/pain2.wav","","","gremlin/minitheme.wav"), 1, ATTN_NORM);
   };
void()   gremlin_flip2    =[ $flip2.asc,    gremlin_flip3 ] {ai_face();};
void()   gremlin_flip3    =[ $flip3.asc,    gremlin_flip4 ] {};
void()   gremlin_flip4    =[ $flip4.asc,    gremlin_flip5 ] {};
void()   gremlin_flip5    =[ $flip5.asc,    gremlin_flip6 ] {};
void()   gremlin_flip6    =[ $flip6.asc,    gremlin_flip7 ] {self.touch = Gremlin_FlipTouch;};
void()   gremlin_flip7    =[ $flip7.asc,    gremlin_gib ]
   {
   self.nextthink = time + 3;
   // if three seconds pass, assume gremlin is stuck and jump again
   };
void()   gremlin_flip8    =[ $flip8.asc,    gremlin_flip8 ]
   {
   self.solid = SOLID_NOT;
   };

/*
===============
GremlinDropBackpack
===============
*/
void() GremlinDropBackpack =
{
	local entity	item;

	item = spawn();
	item.origin = self.origin - '0 0 24';

   self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS ) );
   item.items = self.items;

   if (item.items & IT_AXE)
		item.netname = "Axe";
   else if (item.items & IT_SHOTGUN)
		item.netname = "Shotgun";
   else if (item.items & IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
   else if (item.items & IT_NAILGUN)
		item.netname = "Nailgun";
   else if (item.items & IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
   else if (item.items & IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
   else if (item.items & IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
   else if (item.items & IT_LIGHTNING)
		item.netname = "Thunderbolt";
/*
   else if (item.items & IT_LASER_CANNON)
      item.netname = "Laser Cannon";
   else if (item.items & IT_PROXIMITY_GUN)
      item.netname = "Proximity Gun";
   else if (item.items & IT_MJOLNIR)
      item.netname = "Mjolnir"; */
   else
		item.netname = "";

   item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
   if (item.ammo_shells < 0) item.ammo_shells = 0;
   if (item.ammo_nails < 0) item.ammo_nails = 0;
   if (item.ammo_rockets < 0) item.ammo_rockets = 0;
   if (item.ammo_cells < 0) item.ammo_cells = 0;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;

	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
};

void() gremlin_die =
{
   local vector   vec;
	local float		dot;

// check for gib
   if (self.items & (IT_SUPER_SHOTGUN|IT_NAILGUN|IT_SUPER_NAILGUN|IT_GRENADE_LAUNCHER|IT_ROCKET_LAUNCHER|IT_LIGHTNING))//|IT_LASER_CANNON|IT_PROXIMITY_GUN))
      {
      GremlinDropBackpack();
      self.stoleweapon = FALSE;
      }

   makevectors (self.angles);
   vec = normalize (damage_attacker.origin - self.origin);
	dot = vec * v_forward;

   if (self.health < -35)
      {
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/gremlin.mdl", self.health);
		self.frame = $severedhead;
//		item_throwGib ("progs/gremlin.mdl", self.health, "gib", 10 + random()*10, $severedhead);

		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		return;
      }
   else if (dot>0.7 && (random()<0.5) && (self.flags & FL_ONGROUND))
      {
      gremlin_die1b();
      return;
      }
// regular death
   gremlin_die1 ();
};

/*
===========
GremlinAttemptWeaponSteal

see if we can steal enemy's weapon

============
*/
float() GremlinFindTarget;

float() GremlinAttemptWeaponSteal =
   {
   local vector delta;
   local entity tempself;
   local float best;
   local entity victim;
   local float amount;

// *** FIX - recode for new inventory

return FALSE;

   if (self.stoleweapon)
      {
      dprint("gremlin trying to steal a weapon again\n");
      return FALSE;
      }
   if (!(self.enemy.flags & FL_CLIENT))
      {
      return FALSE;
      }

   delta = (self.enemy.origin - self.origin);

   if (vlen(delta) > 100)
      return FALSE;
   if (random() < 0.5)
      return FALSE;
   //
   // we are within range so lets go for it
   //
   victim = self.enemy;
   best = victim.weapon;
   if (best == IT_AXE || best == IT_SHOTGUN)// || best == IT_MJOLNIR)
      return FALSE;
   // take that weapon from the entity
   victim.items = victim.items - (victim.items & best);
   // give it to our gremlin
   self.items = self.items | best;
   self.weapon = best;
   // take some ammo while we are at it
   self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS ) );
   if (best == IT_SUPER_SHOTGUN)
      {
      amount = victim.ammo_shells;
      if (amount > 20)
         amount = 20;
      victim.ammo_shells = victim.ammo_shells - amount;
      self.ammo_shells = self.ammo_shells + amount;
		self.items = self.items | IT_SHELLS;
      self.currentammo = self.ammo_shells;
      sprint (victim, "Gremlin stole your Super Shotgun\n");
      }
   else if (best == IT_NAILGUN)
      {
      amount = victim.ammo_nails;
      if (amount > 40)
         amount = 40;
      victim.ammo_nails = victim.ammo_nails - amount;
      self.ammo_nails = self.ammo_nails + amount;
      self.items = self.items | IT_NAILS;
      self.currentammo = self.ammo_nails;
      sprint (victim, "Gremlin stole your Nailgun\n");
      }
   else if (best == IT_SUPER_NAILGUN)
      {
      amount = victim.ammo_nails;
      if (amount > 40)
         amount = 40;
      victim.ammo_nails = victim.ammo_nails - amount;
      self.ammo_nails = self.ammo_nails + amount;
      self.items = self.items | IT_NAILS;
      self.currentammo = self.ammo_nails;
      sprint (victim, "Gremlin stole your Super Nailgun\n");
      }
   else if (best == IT_GRENADE_LAUNCHER)
      {
      amount = victim.ammo_rockets;
      if (amount > 5)
         amount = 5;
      victim.ammo_rockets = victim.ammo_rockets - amount;
      self.ammo_rockets = self.ammo_rockets + amount;
      self.items = self.items | IT_ROCKETS;
      self.currentammo = self.ammo_rockets;
      sprint (victim, "Gremlin stole your Grenade Launcher\n");
      }
   else if (best == IT_ROCKET_LAUNCHER)
      {
      amount = victim.ammo_rockets;
      if (amount > 5)
         amount = 5;
      victim.ammo_rockets = victim.ammo_rockets - amount;
      self.ammo_rockets = self.ammo_rockets + amount;
      self.items = self.items | IT_ROCKETS;
      self.currentammo = self.ammo_rockets;
      sprint (victim, "Gremlin stole your Rocket Launcher\n");
      }
   else if (best == IT_LIGHTNING)
      {
      amount = victim.ammo_cells;
      if (amount > 40)
         amount = 40;
      victim.ammo_cells = victim.ammo_cells - amount;
      self.ammo_cells = self.ammo_cells + amount;
      self.items = self.items | IT_CELLS;
      self.currentammo = self.ammo_cells;
      sprint (victim, "Gremlin stole your Lightning Gun\n");
      }
/*   else if (best == IT_LASER_CANNON)
      {
      amount = victim.ammo_cells;
      if (amount > 40)
         amount = 40;
      victim.ammo_cells = victim.ammo_cells - amount;
      self.ammo_cells = self.ammo_cells + amount;
      self.items = self.items | IT_CELLS;
      self.currentammo = self.ammo_cells;
      sprint (victim, "Gremlin stole your Laser Cannon\n");
      }
   else if (best == IT_PROXIMITY_GUN)
      {
      amount = victim.ammo_rockets;
      if (amount > 5)
         amount = 5;
      victim.ammo_rockets = victim.ammo_rockets - amount;
      self.ammo_rockets = self.ammo_rockets + amount;
      self.items = self.items | IT_ROCKETS;
      self.currentammo = self.ammo_rockets;
      sprint (victim, "Gremlin stole your Proximity Gun\n");
      }*/
   tempself = self;
   self = victim;
   self.weapon = W_BestWeapon ();
//   W_SetCurrentAmmo ();
   self = tempself;

   // tag the gremlin as having stolen a weapon
   self.stoleweapon = TRUE;
   self.attack_finished = time;
   // don't fire the first shot at the person we stole the weapon from
   // all the time
   if (random()>0.65)
      self.lastvictim = victim;
   else
      self.lastvictim = self;
//   self.attack_state = AS_STRAIGHT;
   // find a recipient
   victim = GremlinFindVictim();
   if (victim != world)
      {
      self.enemy = victim;
      FoundTarget();
      self.attack_finished = time;
      self.search_time = time + 1.0;
      }

   return TRUE;
   };
//============================================================================

float() GremlinWeaponAttack;
void() Gremlin_MeleeAttack =
   {
   local float num;
   if (self.gorging)
      {
      gremlin_gorge1();
      }
   else
      {
      if (self.stoleweapon == 1)
         {
         if (Q_100 && Q_100_OBJERR) objerror("gremlin meleeing with stolen weapon");
			self.stoleweapon = FALSE; // it wasnt me, I didnt do it! honest...
         gremlin_claw1 ();
         }
      else if ((self.enemy.flags & FL_CLIENT) && random() < 0.4)
         {
         if (GremlinAttemptWeaponSteal())
            return;
         }
      num = random();
      if (num<0.3)
         {
         gremlin_claw1 ();
         }
      else if (num < 0.6)
         {
         gremlin_lunge1 ();
         }
      else
         {
         gremlin_claw1 ();
         }
      }
   };

/*
============
gremlin_recoil
============
*/
/*
void() gremlin_recoil =
   {
   self.nextthink = time + 0.1;
   self.flags = self.flags - FL_ONGROUND;
   if (vlen(self.velocity)<2)
      {
      self.movetype = self.spawnsolidtype;
      self.think = self.spawnthink;
      }
   };
*/
/*
============
GremlinRecoil
============
*/
/*
void(vector dir, float mag) GremlinRecoil =
   {
   self.spawnsolidtype = self.movetype;
   self.movetype = MOVETYPE_BOUNCE;
   self.spawnthink = self.think;
   self.think = gremlin_recoil;
   self.nextthink = time;
   self.velocity = mag * dir;
   self.velocity_z = self.velocity_z + 100;
   self.flags = self.flags - FL_ONGROUND;
   };
*/

/*
============
GremlinCheckNoAmmo

attack with a weapon
============
*/
float() GremlinCheckNoAmmo =
   {
	if (self.currentammo > 0)
		return TRUE;
   else
      {
      self.stoleweapon = FALSE;
      return FALSE;
      }
   };

/*
============
GremlinFindVictim

find a victim to shoot at
============
*/
entity() GremlinFindVictim =
   {
   local entity head;
   local entity selected;
   local float dist;
   local float head_dist;
//   local float decision;

   self.search_time = time + 1.0;
// look in our immediate vicinity

   selected = world;
   dist = 1000;
   head = findradius(self.origin, 1000);
   while(head)
      {
      if(!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT)))
         {
         if (visible(head) && (head.health > 0) && (head !=self))
            {
            head_dist = vlen(head.origin-self.origin);
            if (head == self.lastvictim)
               head_dist = head_dist * 2;
            if (head.flags & FL_CLIENT)
               head_dist = head_dist / 1.5;
            if (head.classname == self.classname)
               head_dist = head_dist * 1.5;
            if (head_dist < dist)
               {
               selected = head;
               dist = head_dist;
               }
            }
         }
      head = head.chain;
      }
   self.lastvictim = selected;

   return selected;
   };

/*
============
Gremlin_FireRocket

fire a rocket
============
*/
void() Gremlin_FireRocket =
{
	local	entity missile;
   local vector dir;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
   self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed

   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.1 * v_right + crandom()* 0.1 *v_up;
   missile.velocity = normalize(dir);
   missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = T_MissileTouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
//   GremlinRecoil(dir,-1000);
};

/*
============
Gremlin_FireNailGun

fire a nailgun
============
*/
//void(float ox) Gremlin_FireNailGun =
void() Gremlin_FireNailGun =
{
   local vector dir;

   self.currentammo = self.ammo_nails = self.ammo_nails - 1;
   self.effects = self.effects | EF_MUZZLEFLASH;

   sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.1 * v_right + crandom()* 0.1 *v_up;
   dir = normalize(dir);
   launch_spike (self.origin + '0 0 16', dir);
};

/*
============
Gremlin_FireLaserGun

fire a laser cannon
============
*/
/*
void(float ox) Gremlin_FireLaserGun =
{
   local vector dir;

   self.currentammo = self.ammo_cells = self.ammo_cells - 1;
   self.effects = self.effects | EF_MUZZLEFLASH;

   sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.1 * v_right + crandom()* 0.1 *v_up;
   dir = normalize(dir);
   HIP_LaunchLaser(self.origin + '0 0 16', dir, 0, "");
};

/*
============
Gremlin_FireShotGun

fire a shotgun
============
*/
void() Gremlin_FireShotGun =
{
   local vector dir;

   self.currentammo = self.ammo_shells = self.ammo_shells - 1;
   self.effects = self.effects | EF_MUZZLEFLASH;

   sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.1 *v_right + crandom()* 0.1 *v_up;
   dir = normalize(dir);
   self.v_angle = vectoangles(dir);
   FireBullets (6, dir, '0.04 0.04 0');
};

/*
============
Gremlin_FireSuperShotGun

fire a shotgun
============
*/
void() Gremlin_FireSuperShotGun =
{
   local vector dir;

   self.currentammo = self.ammo_shells = self.ammo_shells - 2;
   self.effects = self.effects | EF_MUZZLEFLASH;

   sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.3 *v_right + crandom()* 0.3 *v_up;
   dir = normalize(dir);
   self.v_angle = vectoangles(dir);
   FireBullets (14, dir, '0.14 0.08 0');
};

/*
============
Gremlin_FireLightningGun

fire lightning gun
============
*/
void() Gremlin_FireLightningGun =
   {
	local	vector	org, dir;
   local float cells;

// explode if under water
   if (self.watertype <= CONTENT_WATER)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
      discharged = 1;
		T_RadiusDamage (self, self, 35*cells, world);
      discharged = 0;
//      W_SetCurrentAmmo ();
		return;
	}

   self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

   self.currentammo = self.ammo_cells = self.ammo_cells - 2;
   org = self.origin + '0 0 16';

	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);
   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.1 *v_right + crandom()* 0.1 *v_up;
   dir = normalize(dir);

	traceline (org, self.origin + dir*600, TRUE, self);

   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

   LightningDamage_x(FALSE, org, trace_endpos+(dir*4), self, 30);
};

/*
================
GremlinFireProximityGrenade
================
*//*
void() GremlinFireProximityGrenade =
{
   local entity missile;
   local vector dir;

   NumProximityGrenades = NumProximityGrenades + 1;
   self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
   missile.owner = self;
   missile.lastvictim = self;
   missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
   missile.classname = "proximity_grenade";
   missile.takedamage = DAMAGE_NO;
   missile.health = 5;
   missile.state = 0;

// set missile speed

   dir = normalize(self.enemy.origin - self.origin);
   self.v_angle = vectoangles(dir);
   makevectors(self.v_angle);
   dir = dir + crandom()* 0.1 *v_right + crandom()* 0.1 *v_up;
   dir = normalize(dir);
   missile.velocity = dir * 600;
	missile.velocity_z = 200;

   missile.avelocity = '100 600 100';

	missile.angles = vectoangles(missile.velocity);

   missile.touch = ProximityGrenadeTouch;

// set missile duration
   missile.nextthink = time + 2;
   missile.delay = time + 15 + (10*random());
   missile.think = ProximityBomb;
   missile.th_die = ProximityGrenadeExplode;

   setmodel (missile, "progs/proxbomb.mdl");
   setorigin (missile, self.origin);
   setsize (missile, '-1 -1 -1', '1 1 1');
};

/*
============
GremlinWeaponAttack

attack with a weapon
============
*/
void()   gremlin_shot1;
void()   gremlin_nail1;
void()   gremlin_light1;
void()   gremlin_rocket1;

float() GremlinWeaponAttack =
   {
//	local	float	r;
//   local entity targ;
//   local vector vec;


   if (!GremlinCheckNoAmmo ())
      return FALSE;

   self.show_hostile = time + 1; // wake monsters up

   if (self.weapon == IT_SHOTGUN)
      {
      gremlin_shot1 ();
      Gremlin_FireShotGun();
      SUB_AttackFinished(1);
      }
	else if (self.weapon == IT_SUPER_SHOTGUN)
      {
      gremlin_shot1 ();
      Gremlin_FireSuperShotGun();
      SUB_AttackFinished(1);
      }
	else if (self.weapon == IT_NAILGUN)
      {
      gremlin_nail3 ();
      SUB_AttackFinished(1);
      }
	else if (self.weapon == IT_SUPER_NAILGUN)
      {
      gremlin_nail3 ();
      SUB_AttackFinished(1);
      }
	else if (self.weapon == IT_GRENADE_LAUNCHER)
      {
      gremlin_rocket1();
      OgreFireGrenade();
      self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
      SUB_AttackFinished(1);
      }
	else if (self.weapon == IT_ROCKET_LAUNCHER)
      {
      gremlin_rocket1();
      Gremlin_FireRocket();
      SUB_AttackFinished(1);
      }
	else if (self.weapon == IT_LIGHTNING)
      {
      gremlin_light1();
      SUB_AttackFinished(1);
      sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
      }
/*   else if (self.weapon == IT_LASER_CANNON)
      {
      gremlin_laser3();
      SUB_AttackFinished(1);
      }
   else if (self.weapon == IT_PROXIMITY_GUN)
      {
      gremlin_rocket1();
      GremlinFireProximityGrenade();
      SUB_AttackFinished(1);
      }*/
   return TRUE;
   };

void() Gremlin_MissileAttack =
   {
   if (self.stoleweapon)
      {
      if (GremlinWeaponAttack())
         return;
      else if ((random()<0.1) && (self.flags & FL_ONGROUND))
         {
         gremlin_jump1();
         return;
         }
      }
   if (self.flags & FL_ONGROUND)
      gremlin_jump1();
   };

/*QUAKED monster_gremlin (1 0 0) (-32 -32 -24) (32 32 64) Ambush

	note: updated to use new model

*/
void(float ign) monster_gremlin =
{
if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		remove(self);
		return;
	}
	
	if (!M_MONSTER & CB_M_GREMLIN)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}
   precache_model ("progs/gremlin.mdl");
//   precache_model ("progs/h_grem.mdl");

   precache_sound ("grem/death.wav");
   precache_sound ("grem/attack.wav");
   precache_sound ("demon/djump.wav");
   precache_sound ("demon/dhit2.wav");
/*
//precached in morph - uncomment if separated

	precache_sound ("gremlin/clawscrape.wav");
	precache_sound ("gremlin/hover_flap.wav");
	precache_sound ("gremlin/fly_flap.wav");

	precache_sound ("gremlin/idle1.wav"); // all laughs
	precache_sound ("gremlin/idle2.wav");
	precache_sound ("gremlin/idle3.wav");
	precache_sound ("gremlin/pain1.wav"); // vars growls
	precache_sound ("gremlin/pain2.wav");
	precache_sound ("gremlin/pain3.wav");
	precache_sound ("gremlin/sight1.wav"); // yum yum
	precache_sound ("gremlin/sight2.wav"); // billy
	precache_sound ("gremlin/sight3.wav"); // gun
	precache_sound ("gremlin/sight4.wav"); // water
*/
}
	self.netname = "Gremlin";

	if (deathmatch) GREM_MAX = 64;
	else GREM_MAX = 256;

   NumGremlins = NumGremlins + 1;
   self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.class_select = "class_monster";

   setmodel (self, "progs/gremlin.mdl");

//   setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	setsize (self, '-16 -16 -14',  ' 16 16 32');

   self.health = 100;
   self.max_health = 101;
   self.yaw_speed = 40;

   self.th_stand = gremlin_stand1;
   self.th_walk = gremlin_walk1;
   self.th_run = gremlin_run1;
   self.th_die = gremlin_die;
   self.th_melee = Gremlin_MeleeAttack;     // one of two attacks
   self.th_missile = Gremlin_MissileAttack; // check for random jump or firing of weapon
   self.th_pain = gremlin_pain;

   if (random() < 0.3) // 0.03)
   {
	setmodel (self, "progs/gremlin-fly.mdl");
	flymonster_start();
   }
   else
	walkmonster_start();
};

float()  GremlinCheckAttack =
   {
	local vector	spot1, spot2;
	local entity	targ;
	local float		chance;

	targ = self.enemy;

   if (time < self.attack_finished)
      return FALSE;

// see if any entities are in the way of the shot
   spot1 = self.origin;// + self.view_ofs;
   spot2 = targ.origin;// + targ.view_ofs;

   if ((vlen(spot2 - spot1) <= 90) && (self.stoleweapon == 0))
      {
      self.attack_state = AS_MELEE;
      return TRUE;
      }
// missile attack
   chance = 0.03 + self.stoleweapon;
   if (random() < chance)
      {
      self.attack_state = AS_MISSILE;
      return TRUE;
      }
	return FALSE;
   };


//===========================================================================

void(float stc)  Gremlin_Melee =
{
//	local	float	ldmg;
	local vector	delta;

	ai_face ();

//   walkmove (self.ideal_yaw, 12);   // allow a little closing


	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	W_FireClawBite(stc);
/*
//    sound (self, CHAN_WEAPON, "grem/attack.wav", 1, ATTN_NORM);
	ldmg = 10 + 5*random();
	if (side == 0)
		ldmg = ldmg + 15; // bite damage
	else // slash
	T_Damage (self.enemy, self, self, ldmg);

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
*/
};

//===========================================================================
void(float dm) Gremlin_ThrowHead =
   {
   local string gibname;
   if (self.classname == "monster_ogre")
      gibname = "progs/h_ogre.mdl";
	else if (self.classname == "monster_knight")
      gibname = "progs/h_knight.mdl";
   else if (self.classname == "monster_shambler")
      gibname = "progs/h_shams.mdl";
   else if (self.classname == "monster_demon1")
      gibname = "progs/h_demon.mdl";
   else if (self.classname == "monster_wizard")
      gibname = "progs/h_wizard.mdl";
   else if (self.classname == "monster_zombie")
      gibname = "progs/h_zombie.mdl";
   else if (self.classname == "monster_dog")
      gibname = "progs/h_dog.mdl";
   else if (self.classname == "monster_hell_knight")
      gibname = "progs/h_hellkn.mdl";
   else if (self.classname == "monster_enforcer")
      gibname = "progs/h_mega.mdl";
   else if (self.classname == "monster_army")
      gibname = "progs/h_guard.mdl";
   else if (self.classname == "monster_shalrath")
      gibname = "progs/h_shal.mdl";
   else if (self.classname == "monster_gremlin")
      gibname = "progs/h_grem.mdl";
   else if (self.classname == "monster_scourge")
      gibname = "progs/h_scourg.mdl";
   else if (self.classname == "monster_fish")
      gibname = "progs/gib1.mdl";
   else
      gibname = "progs/h_player.mdl";
   ThrowHead(gibname,dm);
   };
//===========================================================================

/*
============
Gremlin_Damage

The damage is coming from inflictor, but get mad at attacker

note: ignores - armor, takedamage flag, kill - may only be done to corpse
============
*/
//void(entity targ, entity inflictor, entity attacker, float damage) Gremlin_Damage=
void(entity targ, entity attacker, float damage) Gremlin_Damage=
{
// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time || targ.invincible_finished < 0)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
		return;

// do the damage
   targ.health = targ.health - damage;
   };

void() Gremlin_Split =
   {
   local entity grem;
   local entity temp;
   local entity head;
   local float done;
   local vector ang;
   local float c;
   local vector pos;
   local float proceed;

   if (NumSpawnGremlins >= (NumGremlins*2))
      return;
   done = 0;
   c = 0;
   ang = self.angles;
   while (done == 0)
      {
      makevectors(ang);
      pos = self.origin + (80 * v_forward);
      head = findradius(pos, 35);
      proceed = 1;
      while (head)
         {
         if ((head.health > 0) && (head.flags & (FL_MONSTER | FL_CLIENT)))
            proceed = 0;
         head = head.chain;
         }
      traceline(self.origin,pos,FALSE,self);
      if (trace_fraction == 1 && (proceed == 1))
         {
         traceline(self.origin,(pos-'40 40 0'),FALSE,self);
         if (trace_fraction == 1)
            {
            traceline(self.origin,(pos+'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
               {
               traceline(self.origin,(pos + '0 0 64'),FALSE,self);
               if (trace_fraction == 1)
                  {
                  traceline(self.origin,(pos - '0 0 64'),FALSE,self);
                  if (trace_fraction != 1)
                     {
                     done = 1;
                     }
                  }
               }
            }
         }
      if (done == 0)
         {
         ang_y = ang_y + 36;
         c = c + 1;
         if (c==10)
            {
            return;
            }
         }
      }
   NumSpawnGremlins = NumSpawnGremlins + 1;
   grem = spawn();
   SUB_CopyEntity(self,grem);
   grem.solid = SOLID_SLIDEBOX;
   grem.movetype = MOVETYPE_STEP;
	grem.class_select = "class_monster";
   setmodel (grem, "progs/grem.mdl");
   setsize (grem, VEC_HULL_MIN, VEC_HULL_MAX);
   if (self.health < 100) self.health = 100;
   grem.health = self.health / 2;
   self.health = self.health / 2;
//   grem.max_health = 101;
//   grem.gorging = FALSE;
   grem.stoleweapon = FALSE;
   grem.items = 0;
   total_monsters = total_monsters + 1;
//   WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
//   WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
//   WriteLong (MSG_BROADCAST, total_monsters);
   setorigin(grem, pos);
   temp = self;
   self = grem;
   gremlin_spawn1();
   self.enemy = world;
   self.gorging = FALSE;
   self = temp;
   };

void(float side)  Gremlin_Gorge =
   {
	local	float	ldmg;
	local vector	delta;
   local entity temp;

//   ai_face ();
//   walkmove (self.ideal_yaw, 6);   // allow a little closing

	delta = self.enemy.origin - self.origin;
//   self.enemy.takedamage = DAMAGE_YES;

    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
//    sound (self, CHAN_WEAPON, "grem/attack.wav", 1, ATTN_NORM);
   ldmg = 7+5*random();
   Gremlin_Damage (self.enemy, self, ldmg);

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
   if (self.enemy.health < -200.0)
      {
      if (self.enemy.gorging==FALSE)
         {
         self.enemy.gorging = TRUE;
         sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
         temp = self;
         self = self.enemy;
         Gremlin_ThrowHead(-15);
//         ThrowGib ("progs/gib1.mdl", -15);
//         ThrowGib ("progs/gib2.mdl", -15);
//         ThrowGib ("progs/gib3.mdl", -15);
         self = temp;
         ldmg = 150 + 100*random();
         T_Heal(self,ldmg,FALSE);
//         if (self.health >= self.max_health)
            Gremlin_Split();
         }
      self.enemy = world;
      self.gorging = FALSE;
/*
      if (self.stoleweapon)
         {
         temp = GremlinFindVictim();
         if (temp != world)
            {
            self.enemy = temp;
            FoundTarget();
            self.search_time = time + 1.0;
//            return;
            }
         }
*/
//      FindTarget();
/*
      if (self.oldenemy.health > 0)
         {
         self.enemy = self.oldenemy;
         HuntTarget ();
         }
      else
         {
         if (self.movetarget)
            self.th_walk ();
         else
            self.th_stand ();
         }
*/
      gremlin_look1();
      }
   };


void()   Gremlin_JumpTouch =
{
//	local	float	ldmg;

   if (self.health <= 0)
		return;

/*
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 40 + 10*random();
			T_Damage (other, self, self, ldmg);
		}
	}
*/
	if (!checkbottom(self))
      {
		if (self.flags & FL_ONGROUND)
         {
         self.touch = SUB_Null;
         self.think = gremlin_jump1;
         self.nextthink = time + 0.1;
         }
		return;	// not on ground yet
      }

	self.touch = SUB_Null;
   self.think = gremlin_jump12;
	self.nextthink = time + 0.1;
};

void()   Gremlin_FlipTouch =
{
//	local	float	ldmg;

	if (!checkbottom(self))
      {
		if (self.flags & FL_ONGROUND)
         {
         self.touch = SUB_Null;
         self.think = gremlin_flip1;
         self.nextthink = time + 0.1;
         }
		return;	// not on ground yet
      }

	self.touch = SUB_Null;
   self.think = gremlin_flip8;
	self.nextthink = time + 0.1;
};
