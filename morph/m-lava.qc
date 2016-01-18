/* ::-::
 *
 * Cataboligne
 *
 * file: m-lava.qc
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


$cd id1/models/lavablob
$origin 0 0 24
$base base		

$skin skin

$frame run1 run2 run3 run4 run5 run6  run7 run8 run9 run10 run11 run12 run13
$frame run14 run15 run16 run17 run18 run19 run20 run21 run22 run23
$frame run24 run25

$frame walk1 walk2 walk3 walk4  walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame jump1 jump2 jump3 jump4 jump5 jump6

$frame fly1 fly2 fly3 fly4

$frame exp

/*
		+---------------------------------------+
		|  world code                           | SEC-HEAD
		+---------------------------------------+
*/

void() m_precache_lavablob =
{
	precache_model ("progs/lavabomb.mdl");
	precache_model ("progs/cthon.mdl");

// blob sounds
	precache_sound2 ("blob/death1.wav"); // exploding statue sound - pretty good
	precache_sound2 ("blob/hit1.wav"); // dull flesh thud
	precache_sound2 ("blob/sight1.wav"); // grrr
	precache_sound ("chaos/lavabidle.wav"); // hisss
	precache_sound ("chaos/lava-shot.wav"); // nail shot
// cthon sounds
	precache_sound ("boss1/out1.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound ("boss1/throw.wav");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");

};

/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

void() lavablob_slimeflare;
void() Lavablob_JumpTouch;

 void() player_lavablob_stand = [ $walk1, player_stand1 ]
{
//	if (self.lip != 1 && self.lip != -1) self.lip = 1;
	self.lefty = time + 5;
	if (self.health > 18) self.count = self.health;

	if (self.walkframe > 6 || self.walkframe < 0) self.walkframe = 0;
	if (self.walkframe == 6 && self.lip == 1) self.lip = -1;
	if (self.walkframe == 0) self.lip = 1;

	if (self.walkframe == 2)
		{
		morph_sound (0.08, "chaos/lavabidle.wav", 2);
		if (random() < 0.1) { chaos_fire_fly(""); 	rnd_size(0.5, -1.0, -1.0, ""); }
		}
	if (self.walkframe == 4) if (random() < 0.25) lavablob_slimeflare();
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + self.lip;
};


void() player_lavablob_run = [ $run1, player_run ] 
{
	vector sp;
	local float walk, frm;
	local float twothr;

	if (self.health > 18) self.count = self.health;
	twothr = 67 * MLAVAB_HEALMOD; // 2/3 health level

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (self.lefty < time) // check for puddles, same freq as jump stop, heh heh
		{
		self.lefty = time + 5;
		frm = self.health - twothr;
		if (frm < 0) frm = 0;
		if (random() < (0.2 + (frm / 500)))
			{
			self.trigger_field = spawn();
			if (self.trigger_field)
				{
				setorigin( self.trigger_field, self.origin);
				self.trigger_field.owner = self; // dont heal self!
				self.trigger_field._stand = self.trigger_field.think = lavapud_live;
				self.trigger_field.nextthink = time + 0.1;
				self.trigger_field.dmg = 5 + (frm / 20);
				self.trigger_field.wait = time + 20 + (random() * frm);
				}
			}
		}
	else // check for slime flare!
		if (random() < 0.5) lavablob_slimeflare();

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 25) self.walkframe = 0;
		}
	else
		{
		frm = $run1;
		if (self.walkframe >= 25) self.walkframe = 0;
		}

	if (self.walkframe == 2 || self.walkframe == 20)
		{
		morph_sound (0.2, "chaos/lavabidle.wav", 2);
		if (random() < 0.20) { chaos_fire_fly(""); 	rnd_size(0.3, -1.0, -1.0, ""); }
		}
	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;
};


void()	lavablob_jump5;

void()	lavablob_fly1		=[	$fly1,	lavablob_fly2	] {};
void()	lavablob_fly2		=[	$fly2,	lavablob_fly3	] {};
void()	lavablob_fly3		=[	$fly3,	lavablob_fly4	] {};
void()	lavablob_fly4		=[	$fly4,	lavablob_fly1	] {
self.cnt = self.cnt + 1;

if (self.cnt == 4)
{
//dprint ("spawn hop\n");
lavablob_jump5 ();
}
};

void()	lavablob_jump1		=[	$jump1,	lavablob_jump2		] { };
void()	lavablob_jump2		=[	$jump2,	lavablob_jump3		] { };
void()	lavablob_jump3		=[	$jump3,	lavablob_jump4		] { };
void()	lavablob_jump4		=[	$jump4,	lavablob_jump5		] { };
void()	lavablob_jump5		=[	$jump5,	lavablob_jump6		]
{	
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Lavablob_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random()*150;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.cnt = 0;
};
void()	lavablob_jump6	=[	$jump6,lavablob_fly1	] { };

// fn(lavablob_eject) - throw stuff on explode

void() lavablob_eject_particles =
{
	rnd_size(0.3, 0.1, -1.0, ""); // randomly size ejecta
	if (random() > 0.7)
		particle_burst(self.origin, 30, ' 0 0 0', ' 360 360 360', 3, 2, 3, FL_RNDUR | FL_COL1 | FL_COL2 | FL_PERC, ' 85 64 0 ', ' 10 15 0 ', ' 0.33 1.0 1.0');
};

void() lavablob_eject =
{
	fire_burst (lavaball_shot, self.origin, 0, 0, "", "", 0, 6, 8, ' 120 0 0', ' 300 360 360', lavablob_eject_particles, FL_ANGADR | FL_VELRND, world);
};

void() lavablob_die_explode1;

void() lavablob_die2 = [ $jump2, lavablob_die3 ] { };
void() lavablob_die3 = [ $jump1, lavablob_die4 ] { };
void() lavablob_die4 = [ $walk13, lavablob_die5 ] { };
void() lavablob_die5 = [ $walk15, lavablob_die6 ] { };
void() lavablob_die6 = [ $walk17, lavablob_die7 ] { };
void() lavablob_die7 = [ $walk19, lavablob_die8 ] { };
void() lavablob_die8 = [ $walk21, lavablob_die9 ] { };
void() lavablob_die9 = [ $walk22, lavablob_die10 ]
{
if (random() < 0.7)
	{
	self.think = SUB_Nop;
	self.skin = 1;
	sound (self,CHAN_WEAPON,"chaos/freeze.wav",1,ATTN_NORM);
	} 
};
void() lavablob_die10 = [ $walk23, SUB_Nop ]
{
//	self.think = SUB_Nop;
	self.skin = 1;
	sound (self,CHAN_WEAPON,"chaos/freeze.wav",1,ATTN_NORM);
};

void()	lavablob_die =[ $jump1, lavablob_die2 ]
{
	if (self.owner.watertype == CONTENT_WATER)
		self.think = lavablob_die2; // died in water := froze
	else if ((self.owner.count < 30) && (random() < 0.4))
		self.think = lavablob_die2; // low final health, cool slag down
	else
		self.think = lavablob_die_explode1; // BOOM!
};

void() lavablob_die_explode1 =	[ $jump2,	lavablob_die_explode2 ] { }; // extra frame for visibility
void() lavablob_die_explode2 =	[ $jump1,	lavablob_die_explode3 ] { };
void() lavablob_die_explode3 =	[ $jump2,	lavablob_die_explode4 ] { };
void() lavablob_die_explode4 =	[ $exp,		lavablob_die_explode5 ] { };
void() lavablob_die_explode5 =	[ $jump2,	lavablob_die_explode6 ] { };
void() lavablob_die_explode6 =	[ $exp,		lavablob_die_explode7 ] { };
void() lavablob_die_explode7 =	[ $exp,		lavablob_die_explode8 ] { };
void() lavablob_die_explode8	=	[ $exp,		SUB_Nop ] 
{
	lavablob_eject();

//	NO_BLAST = TRUE;
//	if (random() < 0.02) volcano_spawn(self.origin, 1.1); TDO: restore

	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
//	move_stop(self, "");

//	Explode(0, 120, world, TE_TAREXPLOSION, 0, BecomeExplosion); // dead_body here, not client ent

	T_RadiusDamage (self, self, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion ();
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/

// fn(Lavablob_JumpTouch) exec blob jump for lava morph
// tarbaby jump code, it is kind of cool - and gives lavablob morph a second attack

void()	Lavablob_JumpTouch =
{
	local	float	ldmg;

	if (other.takedamage && other.morphy != self.morphy && other.classname != "monster_tarbaby")
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 10 + 10*random();
			T_FireDamage (other, self, self, ldmg);	// IDEA - set fires here?
			sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM);
		}
	}
	else
		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM); // IDEA - place to put burn marks on world, or make sparks

	if (self.lefty < time) // blob will be time limited as jumping doesnt seem to exit for player
		{
		self.touch = SUB_Null;
		self.flags = self.flags | FL_ONGROUND;
		self.think = player_lavablob_run;
		self.movetype = MOVETYPE_WALK;
		self.nextthink = time + 0.1;
		return;
		}
	self.dmg = self.dmg / 3; // limit water damage while jumping

	if (!checkbottom(self)) // IDEA - ur? this never happens for player?
		{
		if (self.flags & FL_ONGROUND)
			{
			self.touch = SUB_Null;
			self.think = player_lavablob_run;
			self.movetype = MOVETYPE_WALK;
			self.nextthink = time + 0.1;
//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
			}
		return;	// not on ground yet
		}


	self.touch = SUB_Null;
	self.think = lavablob_jump1;
	self.nextthink = time + 0.1;
};

// fn(lavablob_slimeflare) - check for slime flare up

void() lavablob_slimeflare =
{
	local entity sv;
	
	if (self.watertype == CONTENT_SLIME)
		{
		sv = self;
		self = spawn();
		setorigin(self, sv.origin);
		self.think = SUB_Remove;
		self.nextthink = time + 0.05;
		self.count = time - (random());
		self.flags = FL_FLARE;
		self.owner = world;
		slime_flare();
		self = sv;
		}
};



// fn(cthonme) = change to cthon if in lava pool

void() cthonme =
{
	if (self.watertype == CONTENT_LAVA)
		player_lavacthon_become();
	else
		sprint(self, "You must be in lava to emerge\n");
}


void() player_lavablob_attack =
{

	if (self.impulse == ALT_FIRE_IMP)
	{
		cthonme();
		return;
	}

	if (self.weapon == IT_SHOTGUN) // fire a lava ball
	{
		self.attack_finished=time+0.55;

		// lava blobs fire lava balls
		fireball_missile(FIREBALL_WEP_VEL, "fireballwep", "progs/lavaball.mdl", "boss1/throw.wav", 0);
		setsize(newmis, v0, v0);
		newmis.frame = floor(1.1 + random());
	}
	else // fire spikes - IDEA: will lavablob ever have other attacks?
	{
		self.attack_finished=time+0.25;

		fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY, self.origin, ' 0 0 0', "lavaspike", "progs/spike.mdl", "chaos/lava-shot.wav", spike_touch, 6, SUB_Remove, SUB_Nop);
		newmis.skin = 1;
	}
};


/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/


void() player_lavablob_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	if (self.pk_currentitem != PK_IT_AXE) return; // selected a pk goody - dont re-message

	if (self.weapon == IT_AXE)
	{
		sprint(self, "Lava Bomb using ( Jump attack )\n");
	}
	if (self.weapon == IT_SHOTGUN)
	{
		sprint(self, "Lava Bomb using ( Lava balls )\n");
		self.items = self.items | IT_CELLS;
	}

	if (self.weapon == IT_NAILGUN)
	{
		sprint(self, "Lava Bomb using ( Lava nails )\n");
		self.items = self.items | IT_NAILS;
	}
};

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/

string() player_lavablob_killmsg = { return rnd_string(' 60.0 50.0 40.0'," got melted by a Lava Bomb ","",""," was blasted by a Lava Bomb "," was fired! "); };
string() player_lavablob_killmsg2 = { return "\n"; };

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_lavablob_become = 
{
	local float tc;
	local entity s2;

	self._stand=player_lavablob_stand;
	self._run=player_lavablob_run;
	self._pain=SUB_Nop; // FIX - pain sound, maybe framed player_lavablob_pain;
	self._die=lavablob_die;
	self._jump=SUB_Null;
	self._jump2=	lavablob_jump1;
	self._attack=player_lavablob_attack;
	self._impulse=player_lavablob_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_lavablob_killmsg;
	self._killmsg2=player_lavablob_killmsg2;

	setmodel(self,"progs/lavabomb.mdl");
	self.modelindex_morph = self.modelindex;

	self.builtin = self.items = self.items | IT_SHOTGUN | IT_NAILGUN;
	self.weapon = IT_SHOTGUN;

	self.skin = 0;

	self.msight = "blob/sight1.wav";
//	self.noise2 = "enforcer/pain1.wav";
	self.noise3 = "";
	self.view_ofs = ' 0 0 4';
	self.cam_z = 0.1;  //cam
//	if(!deathmatch)
//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
	setsize (self, '-16 -16 -24', '16 16 20');
	self.health = self.health * MLAVAB_HEALMOD / self.health_modifier;
	self.health_modifier = MLAVAB_HEALMOD;
	if (silent != NO_TFOG) // coming from cthon form
		{
		makevectors(self.v_angle);
		spawn_tfog(self.origin + 20 * v_forward);
		}

	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become an Lava Bomb.\n"); // owwieee! it burnsies...
		}
//		player_stand1(); // in case we came from cthon fire frames
};


