/* ::-::
 *
 * Cataboligne
 *
 * file: m-gremlin.qc
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


// range held frames
$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6
$frame stand1 stand2 stand3 stand4 stand5
$frame pain1 pain2 pain3 pain4 pain5 pain6

// range firing frames
$frame lightfatt1 lightfatt2 lightfatt3 lightfatt4

// *** duplicate of player.mdl frames above - not really necc... just make sure gun has fire frames there
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

float grem_fly_frame = $flymove1;

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };

/*
		+---------------------------------------+
		|  world code                           | SEC-HEAD
		+---------------------------------------+
*/

void() m_precache_gremlin =
{
	precache_model ("progs/gremlin.mdl");
	precache_model ("progs/gremlin-fly.mdl");

	precache_sound ("gremlin/clawscrape.wav");
	precache_sound ("gremlin/hover_flap.wav");
	precache_sound ("gremlin/fly_flap.wav");

	precache_sound ("gremlin/idle1.wav"); // all laughs
	precache_sound ("gremlin/idle2.wav");
	precache_sound ("gremlin/idle3.wav");
	precache_sound ("gremlin/pain1.wav"); // vars growls
	precache_sound ("gremlin/pain2.wav"); // + death snd
	precache_sound ("gremlin/pain3.wav");
	precache_sound ("gremlin/sight1.wav"); // yum yum
	precache_sound ("gremlin/sight2.wav"); // billy
	precache_sound ("gremlin/sight3.wav"); // gun
	precache_sound ("gremlin/sight4.wav"); // water
//group stuff
//	precache_sound ("gremlin/gsight.wav"); // group carol
//	precache_sound ("gremlin/gidle1.wav"); // all laughs
//	precache_sound ("gremlin/gidle2.wav");
//	precache_sound ("gremlin/gidle3.wav");
	precache_sound ("gremlin/gidle_growl.wav"); // after pod growls + death snd

//	precache_sound ("gremlin/immerse.wav"); // pool thematic
//	precache_sound ("gremlin/pod_birth.wav"); // pod exit thematic
	precache_sound ("gremlin/minitheme.wav"); // mini thematic - death snd

//	precache_sound ("gremlin/walk.wav"); // need click click claws - record a cat
};

// fn(IS_GREMLIN) - test to see if entity e is a gremlin
// returns 1 for frame calc in weaponframe distplays

/*
deprecated - just use .mask_x & CB_GREMLIN

float(entity e) IS_GREMLIN =
{
	if (e.mask_x & CB_GREMLIN) return(1);
};
*/

/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

// fn(player_gremlin_bite*) - bite attack, owie
// fn(player_gremlin_claw*) - claw attack, slash

void()   player_gremlin_bite1 =[ $biteatt1, player_gremlin_bite2 ] {};
void()   player_gremlin_bite2 =[ $biteatt2, player_gremlin_bite3 ]
{
W_FireClawBite(ST_BITE);
};
void()   player_gremlin_bite3 =[ $biteatt3, player_gremlin_bite4 ] {};
void()   player_gremlin_bite4 =[ $biteatt4, player_gremlin_bite5 ] {};
void()   player_gremlin_bite5 =[ $biteatt5, player_gremlin_bite6 ] {};
void()   player_gremlin_bite6 =[ $biteatt6, player_stand1 ] {};

void()   player_gremlin_claw1 =[ $clawatt1, player_gremlin_claw2 ] {};
void()   player_gremlin_claw2 =[ $clawatt2, player_gremlin_claw3 ] {};
void()   player_gremlin_claw3 =[ $clawatt3, player_gremlin_claw4 ] {};
void()   player_gremlin_claw4 =[ $clawatt4, player_gremlin_claw5 ]
{
W_FireClawBite(ST_CLAW);
};
void()   player_gremlin_claw5 =[ $clawatt5, player_gremlin_claw6 ] {};
void()   player_gremlin_claw6 =[ $clawatt6, player_stand1 ] {};

// gremlin can use most frames from player.qc
// flying accomplished here

void() gremlin_hover = [ $flyhover1, player_stand1 ] {

	if (self._stand == gremlin_hover) 
	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;

	if (WALKSOUND && (self.cnt < time)) morph_walksound("gremlin/hover_flap.wav",1.35);

	if(self.walkframe >= 5)
		self.walkframe = 0;
//	if (self.walkframe == 3) morph_sound(0.08, "scourge/idle.wav", 3);
	self.frame = $flyhover1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() gremlin_fly = [ $flymove1, player_run ] {

	if (self._stand == gremlin_hover) 
	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;

	if (WALKSOUND && (self.cnt < time)) morph_walksound("gremlin/fly_flap.wav",2.2);

	if(self.walkframe >= 6)
		self.walkframe = 0;
//	if (self.walkframe == 3) morph_sound(0.08, "scourge/idle.wav", 3);
	self.frame = $flymove1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void()	player_gremlin_pain1 =	[	$pain1,	player_gremlin_pain2	] {self.weaponframe=0;};
void()	player_gremlin_pain2 =	[	$pain2,	player_gremlin_pain3	] {};
void()	player_gremlin_pain3 =	[	$pain3,	player_gremlin_pain4	] {};
void()	player_gremlin_pain4 =	[	$pain4,	player_gremlin_pain5	] {};
void()	player_gremlin_pain5 =	[	$pain5,	player_gremlin_pain6	] {};
void()	player_gremlin_pain6 =	[	$pain6,	player_run	] {};

void()	player_gremlin_meleepain1 =	[	$meleepain1,	player_gremlin_meleepain2	] {self.weaponframe=0;};
void()	player_gremlin_meleepain2 =	[	$meleepain2,	player_gremlin_meleepain3	] {};
void()	player_gremlin_meleepain3 =	[	$meleepain3,	player_gremlin_meleepain4	] {};
void()	player_gremlin_meleepain4 =	[	$meleepain4,	player_gremlin_meleepain5	] {};
void()	player_gremlin_meleepain5 =	[	$meleepain5,	player_gremlin_meleepain6	] {};
void()	player_gremlin_meleepain6 =	[	$meleepain6,	player_run	] {};

//void(entity attacker, float take) player_gremlin_pain =
void() player_gremlin_pain =
{
	local float ml;

	if (self.weaponframe)
		return;

//	ml = !self.holdent.flags & FL_HELD; // item_held()
	if (self.eweapon) ml = FL_MELEE(self.eweapon, self.weapon, self.pk_currentitem );

	if (random() < 0.4) morph_sound (0.8, rnd_string(v0, "gremlin/pain1.wav","gremlin/pain2.wav",null_string,null_string,"gremlin/pain3.wav"), 1);

	if (ml)
		player_gremlin_meleepain1();
	else
		player_gremlin_pain1();
};

// fall backward
void()   player_gremlin_die1 =[ $death1, player_gremlin_die2 ] {};
void()   player_gremlin_die2 =[ $death2, player_gremlin_die3 ] {};
void()   player_gremlin_die3 =[ $death3, player_gremlin_die4 ] {self.solid = corpse_solid;};
void()   player_gremlin_die4 =[ $death4, player_gremlin_die5 ] {};
void()   player_gremlin_die5 =[ $death5, player_gremlin_die6 ] {};
void()   player_gremlin_die6 =[ $death6, player_gremlin_die7 ] {};
void()   player_gremlin_die7 =[ $death7, player_gremlin_die8 ] {};
void()   player_gremlin_die8 =[ $death8, player_gremlin_die9 ] {};
void()   player_gremlin_die9 =[ $death9, SUB_Nop ] {};

// spin & fall face down
void()   player_gremlin_dieb1 =[ $deathb1, player_gremlin_dieb2 ] {};
void()   player_gremlin_dieb2 =[ $deathb2, player_gremlin_dieb3 ] {};
void()   player_gremlin_dieb3 =[ $deathb3, player_gremlin_dieb4 ] {self.solid = corpse_solid;};
void()   player_gremlin_dieb4 =[ $deathb4, player_gremlin_dieb5 ] {};
void()   player_gremlin_dieb5 =[ $deathb5, player_gremlin_dieb6 ] {};
void()   player_gremlin_dieb6 =[ $deathb6, player_gremlin_dieb7 ] {};
void()   player_gremlin_dieb7 =[ $deathb7, player_gremlin_dieb8 ] {};
void()   player_gremlin_dieb8 =[ $deathb8, player_gremlin_dieb9 ] {};
void()   player_gremlin_dieb9 =[ $deathb9, player_gremlin_dieb10 ] {};
void()   player_gremlin_dieb10 =[ $deathb9, player_gremlin_dieb11 ] {};
void()   player_gremlin_dieb11 =[ $deathb9, SUB_Nop ] {};

// fn (player_gremlin_die) - handle morph gremlin death - chance to throw pack if not gibbed

void() player_gremlin_die =
{
	local float gib;

	if (self.health < -95 || (!XENV && pointcontents(self.origin) == CONTENT_LAVA)) gib = TRUE;

	if (deathmatch || coop || (DEAD_GIBPACK & 2))
	if (!gib || DEAD_GIBPACK)
		DropBackpack();

	if (DEAD_THROW)
	if ((DEAD_THROW & 16) || !gib)
		DeadThrowWeps(newmis, self.origin); // newmis is the pack - ammo must be accounted

//	if ( GibMorph ("progs/gremlin.mdl", $severedhead, FL_HEADGIB | FL_NONHUMGIB | FL_NOSND | FL_PLAGUE, 0, -95, 8, 0, null_string) ) return;
   if (gib)
   {		
// note: diff to pk_gibplayer
		if (random() < 0.45) sound (self, CHAN_VOICE, rnd_string(' 50 25 12', "gremlin/gidle_growl.wav","gremlin/pain2.wav",null_string,null_string,"gremlin/minitheme.wav"), 1, ATTN_NORM);
		else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
// integrated head
      ThrowHead ("progs/gremlin.mdl", self.health);
		self.frame = $severedhead;

		ThrowGib ("progs/gib_m.mdl", self.health);
		newmis.frame = rint(random() * 2);
		ThrowGib ("progs/gib_m.mdl", self.health);
		newmis.frame = rint(random() * 2);
		ThrowGib ("progs/gib_m.mdl", self.health);
		newmis.frame = rint(random() * 2);
      return;
   }

	if (random() < 0.65) sound (self, CHAN_VOICE, rnd_string(' 50 25 12', "gremlin/gidle_growl.wav","gremlin/pain2.wav",null_string,null_string,"gremlin/minitheme.wav"), 1, ATTN_NORM);
	if (random() < 0.5)
		player_gremlin_die1();
	else
		player_gremlin_dieb1(); // IDEA: velocity check?
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float st) W_FireClawBite =
{
//	local	vector	source;
//	local	vector	org;
	local float dist, dm;
	local string miss;

	miss = null_string;
	dist = 64;
	dm = 8 + rint(random() + 0.45) * 4;
	if (st == ST_BITE)
		{
		dm = 20 + rint(random() * 5);
		dist = 48;
		}
	else
		miss = "knight/sword2.wav";

		W_FireAxe();
//	melee_damage(self.origin + '0 0 10', self.origin + '0 0 10' + v_forward*dist, dm, dm, 0, TE_GUNSHOT, miss, "gremlin/clawscrape.wav", "imp/claw.wav");

};

// fn(gremlin_flight_check) - see if gremlin can take off

// returns TRUE if flight can happen, FALSE otherwise
// max inv count for allowed flight - default = 3 weps, IDEA: wep weighting
// sf - loop safety valve counter

float() gremlin_flight_check =
{
	local float scnt;//, sf;
//	local entity lt;

	scnt = 0;
//	force_unload_list();
	self.movetarget = world; // get fresh inventory list
/* get inventory list to see if grem has to many things to fly - IMP:
	inv_list();
	if (self.movetarget) if (self.movetarget.flags & FL_INVLIST) 
	{
		lt = self.movetarget;
		while (lt != world && sf < 200)
		{
			if (lt.lefty == MC_MMELEE) // exclude builtins
			if (! lt.flags & FL_INVAMMO) scnt = scnt + 1;
			lt = lt.movetarget;
			sf = sf + 1;
		}
		self.movetarget.nextthink = time; // clear list
	}
*/
	return(scnt);
};

// fn(gremlin_takeoff) - attempt flight

void() gremlin_takeoff =
{
	if (self.movetype == MOVETYPE_FLY)
		flyer_mode(self);
	else
	if (self.map != "spawn")
	if (self.model == "progs/gremlin-fly.mdl") // gremlin in fly mode
	{
		self.attack_finished = time + 0.3;
		if (gremlin_flight_check() > GREM_FLY_MAXWEP) // IDEA done by wep weight system
		{
			sprint(self, "Your weapons are too heavy for you to fly with - throw some away.\n");
			return;
		}
		self._stand=gremlin_hover;
		self._run=gremlin_fly;
		gremlin_hover();
//				self.velocity = self.velocity * v_up * 50; // some upward motion
		flyer_check(self, TRUE);
	}
};



void() player_gremlin_attack =
{
//	if (random() < 0.07) morph_sound(2, self.msight, 3);

	if (self.map == "spawn")
	{
		gremlin_spawning();
		return;
	}

	if (self.impulse == ALT_FIRE_IMP) // note: can also use impulse 15
	{
		gremlin_takeoff();
		return;
	}

// bot controlled gremlin
	if (self.class_select == "class_bot")
	if (random() < 0.3)
	{
//		local float f;
//		f = self.movetype;
		if (self.movetype == MOVETYPE_FLY)
		{
			if (random() < 0.05) flyer_check(self, FALSE); //gremlin_takeoff();
		}
		else
		{
			if (random() < 0.2) gremlin_takeoff();			
		}
//		if (self.movetype != f) return;
	}

	if (self.weapon == IT_AXE)
	{
		if (rune_haste(0.5))
		self.attack_finished = time + 1.0;
		player_gremlin_bite1();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_gremlin_claw1();
		if (rune_haste(0.4))
		self.attack_finished = time + 0.8;
	}

// NOTE: see if this causes the viswep bug
//	if (self.eweapon || (self.weapon != IT_AXE && self.weapon != IT_SHOTGUN) ) // not sure this will ever be the case
	if (self.weapon != IT_AXE && self.weapon != IT_SHOTGUN)
	{
		self._attack = SUB_Null;
		W_Attack();
		self._attack=player_gremlin_attack;
	}

};


/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/

void() player_gremlin_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	split_morph_impulse();

	if (self.weapon == IT_SHOTGUN)
	{
//		sprint(self, "Gremlin using ( claws )\n");
		self.eweapon = world;
		self.weaponmodel = null_string;
		self.pk_currentitem = PK_IT_AXE;
	}

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
//		sprint(self, "Gremlin using ( bite )\n");
		self.eweapon = world;
		self.weaponmodel = null_string;
	}
};

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/

string(entity targ, entity attacker) player_gremlin_killmsg =
{
	if (!ENHANCED) return " was outsmarted by a Gremlin\n";

	if (attacker.weapon == IT_AXE)
		return " was bit to death by ";
	else if  (attacker.weapon == IT_SHOTGUN)
	{
		if (random() < 0.3)
			return " was clawed to pieces by ";
		else
			return "was mauled by ";
	}
	else
		return " got murdered (heh heh) by ";
};

//string(entity targ, entity attacker) player_gremlin_killmsg2 =
string() player_gremlin_killmsg2 =
{
	if (!ENHANCED) return "noname";
	return ".\n";
};

// fn(touch_theft) - attempt to steal another players wep on touch
// self - visible wep
// other - thief

/*
notes

4x chances if behind owner (opposite pitch angle)
cumulative? (factor in chaos & xp later...)

*/
float STEAL_TIME				= 5; // 5 secs between theft attempts
float STEAL_BASE				= 0.1; // base chance to steal item

void() touch_theft =
{
//	local entity el, sv, ew, ow; // for make_prime
	local entity sv;
//	local float a, w, si;

	if (other == self.owner) return;
	if (!(other.flags & FL_STEAL)) return;
	if (self.wait > time) return;

	self.wait = time + STEAL_TIME;
	sv = self;

if (WARNING) bprint("theft attemp\n");

	/* IMP: major recode - prob via. drop item code
	if (random() < STEAL_BASE)
		{
		si = self.impulse & 255;
		ow = self.owner;
		ew = self.eweapon;
		a = wep_ref(WMOD_RDA,si,0,ow,0);
		w = ew.dmg_save;
		if (!w) w = ew.currentammo;
		if (!w) w = 1;
		if (!(other.mode_x & self.mode_x))
			{
			self = ew;
			weapon_touch();
			if (!glot) {self = sv; return; } // cant steal, no inventory room
if (WARNING) bprint("theft wep success\n");
			el = spawn(); // temp inv ent
			el.lefty = sv.weapon;
			el.weapon = sv.impulse;
			el.eweapon = ew;
			if (w < a) w = a;
			a = a - w;
			self = ow;
			if (!make_prime(el)) // handles victim inventory control
				{
				a = 0;
				}
			remove(el);
			if (a > 0)
				{
				wep_ref(WMOD_ADDA,glot,a,other,ew.weaponframe); // got all ammo
				w = w + a;
				}
			}
		else // already got one, try to get some ammo
			{
			if (ew.weaponframe == AMMO_NONE) return;
			if (self.weapon >= MC_CARRYABLE) return;
			if (!a) return;
if (WARNING) bprint("theft ammo success\n");
			if (w > 3) w = w + rint((w / 2) * crandom());
			if (w > a) w = a;
			wep_ref(WMOD_ADDA,0,w,other,ew.weaponframe); // stole some ammo
			}
		wep_ref(WMOD_ADDA,si,0 - w,ow,ew.weaponframe);
		other.flags = other.flags - (other.flags & (FL_HOLDTCH | FL_STEAL));
		}
	*/
};

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

// fn(gremlin_spawning) - player respawn / init - not on map change

// IDEA: monster_grem come thru here as well

void() gremlin_spawning =
{
	if (self.frame < $spawn1) 
	{
		self.frame = $spawn1;
		if (self.flags & FL_MONSTER) 
		{
			self.th_pain = SUB_Null;
			self.think = gremlin_spawning;
		}
	}
	else if (self.frame > $spawn10)
	{
		self.frame = $meleestnd2;
		if (self.flags & FL_CLIENT)
		{
			self.map = null_string;
		}
		else if (self.flags & FL_MONSTER)
		{
			self.th_pain = gremlin_pain;
			gremlin_run1();
		}
	}
	else self.frame = self.frame + 1;

	self.nextthink = time + 0.2;
};

// fn(gremlin_spawn_pnt) - generate a random spawn pt around gremlin for water spawns

// loc - center
// dx - randomize on this dist
// mn - minimum dist from center, always additive to above
// zx - z dist
// zr - z random

vector(vector loc, float dx, float mn, float zx, float zr) gremlin_spawn_pnt =
{
	local vector rn;
	local float dy, ng; 

	rn = loc;
	dy = crandom() * dx;
	ng = 1;
	if (dy < 0) ng = -1;
	rn_x = rn_x + ng * mn + dy;

	dy = crandom() * dx;
	ng = 1;
	if (dy < 0) ng = -1;
	rn_y = rn_y + ng * mn + dy;

	dy = crandom() * zr;
	ng = 1;
	if (dy < 0) ng = -1;
	rn_z = rn_z + ng * zx + dy;

	return(rn);
};

// fn(gremlin_check_spot) - check for another gremlin nearby

float(float rng, vector sp1) gremlin_check_spot =
{
	local entity e;

	e = findradius(sp1, rng);
	gsf = 150;
	while (e && gsf > 0)
	{
		gsf = gsf - 1;
//		if (e.classname == "monster_gremlin" || 
		if (e.flags & FL_MONSTER) return(TRUE); // try not to spawn in gremlins & monsters
		if (e.flags & FL_CLIENT && e.classname == "player") return(TRUE); // try not to spawn in live players
		e = e.chain;
	}
	if (pointcontents(sp1) == CONTENT_SOLID) return(TRUE);
	if (pointcontents(sp1 + ' 0 0 -24') == CONTENT_SOLID) return(TRUE);
	return(FALSE);
};

// fn(gremlin_spawn) - make new gremlins in water

// cn - amt to spawn
// self - germlin ent

void(float cn) gremlin_spawn =
{
	local float sf, sv, lv, lz, zr, sp, ts;
	local vector spot;
	local entity sv1;

//	if (self.waterlevel < 1) return;
//	else if (self.watertype != CONTENT_WATER) return;
//	else 
	if (self.search_time > time) return;

	sf = cnt_ent(world, "classname", "monster_gremlin");  // doesnt include player gremlins

	if (sf > GREM_MAX) return; // gremlins maxed out

if (WARNING)
{
bprint("spawning gremlins, count: ");
bprint(ftos(sf));
newline(world);
}

	sf = 100; // limit loop - NOT gsf
	ts = 80; // test value
	sp = rint(cn); // try to spawn this many
	lv = 40; // min range

	if (self.waterlevel < 2) { zr = lz = 0; self.search_time = time + 8; }
	else if (self.waterlevel < 3) { lz = 7; zr = 5; self.search_time = time + 4; }
	else { lz = 0; zr = lv; self.search_time = time + 1; }

	while (sp > 0 && sf > 0)
	{
		sf =sf - 1;
		sv = 10;
		spot = gremlin_spawn_pnt(self.origin, 24, lv, lz, zr);
		while (sv > 0 && gremlin_check_spot(30, spot))
		{
			sv = sv - 1;
			spot = gremlin_spawn_pnt(self.origin, 24, lv, lz, zr);
		}
		if (sv > 0)
		{


if (WARNING) bprint("made a gremlin\n");


			self.show_hostile = time + 1;
			sv1 = self;
			self = chaos_spawn(MOVETYPE_STEP, SOLID_SLIDEBOX, 0, 0, spot, ' 0 0 0', ' 0 0 0', ' 0 0 0', ' 0 0 0', "monster_gremlin", null_string, SUB_Null, 0, SUB_Null, SUB_Null, sv1, world);

			monster_gremlin(A_MONSTER);
			if (self.model == "progs/gremlin-fly.mdl")
				flymonster_start_go();
			else
				walkmonster_start_go(); // set monster state & damage - important
			FoundTarget();
			self.pausetime = 0;
			gremlin_spawning();
			self = sv1;
			sp = sp - 1;
		}
		else // none spawned expand rad
		{


if (WARNING) bprint("gremlin spawn fail\n");


			if (sf < ts) { lv = lv * 2; ts = ts - 20; }
			if (ts == 40 && self.waterlevel == 3) zr = zr + 40;
		}
	}
};

void(float silent) player_gremlin_become = 
{
//	float sv_melee;

	self._stand = SUB_Null;
	self._run = SUB_Null;
	self._pain = player_gremlin_pain;
	self._die = player_gremlin_die;
	self._jump = SUB_Null;
	self._jump2 = SUB_Null;
	self._attack = player_gremlin_attack;
	self._impulse = player_gremlin_impulse;
//	self._can_get_p = SUB_True;
	self._killmsg = player_gremlin_killmsg;
	self._killmsg2 = player_gremlin_killmsg2;

	self.cam_z = 15 / 100;
	self.cam_y = 32;

	stuffcmd(self, "exec cfg/morph/m-gremlin.cfg\n");

	if (self.morphy == IMP_MGREMLIN_F) // flyer
		setmodel(self,"progs/gremlin-fly.mdl");
	else
		setmodel(self,"progs/gremlin.mdl");
	self.mdl = self.model;
//	self.modelindex_morph=self.modelindex;
//	self.mask_x = CB_GREMLIN;

	self.builtin = IT_AXE | IT_SHOTGUN;
	self.items = self.items | self.builtin;
	self.weapon = IT_SHOTGUN;


	self.msight = "gremlinsight";
	self.noise2 = "gremlin/pain2.wav";
	self.noise3 = null_string;
	self.view_ofs = ' 0 0 22';

	setsize (self, '-16 -16 -14',  ' 16 16 32');
	self.health = self.health * MGREMLIN_HEALMOD / self.health_modifier;
	self.health_modifier = MGREMLIN_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

/*
// this is code to give gremlin default weps.  has to be re-implemented
	if (random() < 0.3)
	{
	//	base_weps();
		self.viswframe = -1; // must start -1
	}
*/

	if (self.armortype == 0) //gremlin has some base armor on create
	{
		player_scourge_armor(self, 80, GIVEARMOR); 
	}

	if (!silent) // silent for starting new level as this beasty
	{
		bprint(self.netname);
		bprint(" has become "); // gremlin
		bprint(polymorph_id(self.morphy));
		bprint(".\n");
//		morph_impulse();
	}
	if (self.map == "spawn") self.frame = $spawn1;
};
