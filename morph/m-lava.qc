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
Lava morph - Cthons son
A.K.A "Lavabomb"

(orignal chaos mod designator "SOC")

"the Story"

Once upon a Quake, Shubbers needed a realm gaurdian.
What better than an 80 foot tall lava creature that can throw explosive lava blobs?

Once summoned Cthon proved to be a great gaurdian.  With the exception of being very difficult to control.
The thing about a large mass of living lava - its hard to damage.

Enter the massive "House of Cthon" lava pit electric grid.
It took 100 shamblers to pump out the juice to power one electrode.  The grid needed two.
Cthon could be controlled.

Until the Nehahra conspiracy.

A lone power hungry immortal named "Max" bribed a few units of Shubbers forces to give the 200 Shamblers
a few dozen quad artifacts.  Max engineered this to happen when a lone warrior for the earth realm - "Lt. Phil"
just happened to come by looking for the earth rune.

And the over juiced electric anodes melted Cthon (the indestructible) into his own lava pool.

"I need a vacation"

But...

As the lava blobbed down into the pool, a few bits retained intellect and will.
Parts of Cthon lived!

Lavabomb is a small sentient lava pool the near exact size and shape of a tarbaby.

The lava form is capable of firing lava balls and spikes of its own mass.
It also possess the dangerous tarbaby jump attack and the tendency to explode when excessive damage occurs.

Jump in a lava pool and get healed.  Or... Turn into a mini Cthon.  Stay in the pool though - mini Cthon can NOT
exist away from the lava.  Mini Cthons lava balls explode - just like Dads.

And stay out of water - it causes damage.

However, when a Lavabomb takes damage - the wounded lava can metasize more tarbabys and lavabombs.

(If you get stuck Lavabomb has a built in grapple hook of lava with limited range.)

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
	precache_sound ("blob/death1.wav"); // exploding statue sound - pretty good
	precache_sound ("blob/hit1.wav"); // dull flesh thud
	precache_sound ("blob/sight1.wav"); // grrr
	precache_sound ("blob/mytosis.wav"); // mytose
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
		if (random() < 0.1) { chaos_fire_fly(null_string); 	rnd_size(0.5, -1.0, -1.0, null_string); }
	}
	if (self.walkframe == 4) if (random() < 0.25) lavablob_slimeflare();
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + self.lip;

	self.mcode = 0;
	if (self.watertype == CONTENT_LAVA)
	{
		self.mcode = -504;
		if (self.weapon != IT_ROCKET_LAUNCHER) self.volume = -100;
	}
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
		if (random() < 0.20) { chaos_fire_fly(null_string); 	rnd_size(0.3, -1.0, -1.0, null_string); }
	}
	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;

	self.mcode = 0;
	if (self.watertype == CONTENT_LAVA)
	{
		self.mcode = -504;
		if (self.weapon != IT_ROCKET_LAUNCHER) self.volume = -100;
	}
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

void()	lavablob_jump1		=[	$jump1,	lavablob_jump2		] { if (intermission_running) player_stand1(); };
void()	lavablob_jump2		=[	$jump2,	lavablob_jump3		] { if (intermission_running) player_stand1(); };
void()	lavablob_jump3		=[	$jump3,	lavablob_jump4		] { if (intermission_running) player_stand1(); };
void()	lavablob_jump4		=[	$jump4,	lavablob_jump5		] { if (intermission_running) player_stand1(); };
void()	lavablob_jump5		=[	$jump5,	lavablob_jump6		]
{	
	if (intermission_running)
	{
		player_stand1();
		return;
	}
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
void()	lavablob_jump6	=[	$jump6,lavablob_fly1	] { if (intermission_running) { player_stand1(); self.velocity = v0; } };

// fn(lavablob_eject) - throw stuff on explode

void() lavablob_eject_particles =
{
	rnd_size(0.3, 0.1, -1.0, null_string); // randomly size ejecta
	if (random() > 0.7)
		particle_burst(self.origin, 30, '0 0 0', ' 360 360 360', 3, 2, 3, FL_RNDUR | FL_COL1 | FL_COL2 | FL_PERC, ' 85 64 0 ', '10 15 0 ', '0.33 1.0 1.0');
};

void() lavablob_eject =
{
	fire_burst (lavaball_shot, self.origin, 0, 0, null_string, null_string, 0, 6, 8, '120 0 0', ' 300 360 360', lavablob_eject_particles, FL_ANGADR | FL_VELRND, world);
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
	self.colormap = 0;
	sound (self,CHAN_WEAPON,"chaos/freeze.wav",1,ATTN_NORM);
	} 
};
void() lavablob_die10 = [ $walk23, SUB_Nop ]
{
//	self.think = SUB_Nop;
	self.skin = 1;
	self.colormap = 0;
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

	setmodel(self, null_string);

//	NO_BLAST = TRUE;
//	if (random() < 0.02) volcano_spawn(self.origin, 1.1); TDO: restore at some future release date (beta | final?)

	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
//	move_stop(self, null_string);

//	Explode(0, 120, world, TE_TAREXPLOSION, 0, BecomeExplosion); // dead_body here, not client ent

	T_RadiusDamage (self, self, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	other = self; // fixed FSCK: non bot in SV_FlyMove - seems to work now
	self = spawn();
	BecomeExplosion ();
	self = other;
};

// from rogue tarbaby mod

void() lavablob_mytosis =
{
	local float r;

// IDEA: chance of throwing off ejecta, lava sound

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 2;

	tbaby_mitosis(0);
	if (!newmis) return; // didnt spawn, go back

	self.th_pain = player_pain; // because mytosis fn nulls this

	newmis.classname = "monster_lavabomb";
	newmis.netname = "Bomb";
	newmis.class_select = "class_monster";
	newmis.think = tbaby_checknew; // should be set already
	if (random() < 0.2) newmis.skin = 2; // pk lava skin

	r = random();

	if (r < 0.2) // regular tarbaby
	{
		newmis.netname = "Spawn";
		newmis.classname = "monster_tarbaby";
		setmodel (newmis, "progs/tarbaby.mdl");
		newmis.health = 80;
		newmis.skin = 0;
	}
	else if (r < 0.5) // hell spawn
	{
		newmis.netname = "Spawn";
		newmis.classname = "monster_tarbaby";
		setmodel (newmis, "progs/tarbaby.mdl");
		newmis.health = 100;
		newmis.skin = 2;
	}
	setsize (newmis, '-16 -16 -24', '16 16 20');

	chaos_spawn(0, 0, 0, 0,  v0, v0, v0, v0, v0, "monster_wakey", null_string, SUB_Null, 1.33 + random(), random_monster_wakey, SUB_Null, newmis, world);
	newmis.pausetime = 0;
};

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/

// fn(Lavablob_JumpTouch) exec cfg/morph/blob jump for lava morph
// tarbaby jump code, it is kind of cool - and gives lavablob morph a second attack

void()	Lavablob_JumpTouch =
{
	local	float	ldmg;

	if (other.takedamage && other.morphy != self.morphy && other.classname != "monster_tarbaby" && other.classname != "monster_lavabomb" && other.classname != "monster_vomit")
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
		self.morphy = sv.morphy;
		slime_flare();
		self = sv;
		}
};



// fn(cthonme) = change to cthon if in lava pool

void() cthonme =
{
	if (self.watertype == CONTENT_LAVA)
	{
// use archon power
		if (self.volume < 0)
			self.archon = self.archon + self.volume;
// emerge
		player_lavacthon_become();
//		polymorph_check(IMP_MCTHONTALL, 0);
	}
	else
		sprint(self, "You must be in lava to emerge\n");
}


// blob needs sep missile touch because of vampire rune

void () blob_lava_touch =
{
	if (other.mask_x != CB_CTHON) // Cataboligne - 9.22.11 - only here till we get chaos_ff done IMP: remove
	T_Damage (other,self,self.owner,self.dmg);
	remove (self);
};


void() player_lavablob_attack =
{

	if (self.impulse == ALT_FIRE_IMP)
	{
		cthonme();
		return;
	}
	
	if (self.archon < 7)
	if (self.weapon == IT_ROCKET_LAUNCHER) self.weapon = IT_NAILGUN;

	if (self.weapon != IT_NAILGUN) // fire a lava ball, or explosive bomb
	{
		if (rune_haste(0.275))
		self.attack_finished=time+0.55;

		// lava blobs fire lava balls
		fireball_missile(FIREBALL_WEP_VEL, "fireballwep", "progs/lavaball.mdl", "boss1/throw.wav", 0);
		setsize(newmis, v0, v0);
		newmis.frame = floor(1.1 + random());
		newmis.morphy = self.morphy;
		newmis.touch = blob_lava_touch;

// use archon power
		if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			newmis.dmg = 60;
			newmis.touch = newmis.think = newmis.th_die = Wiz_MissileTouch;
			if (self.volume < 0)
				self.archon = self.archon + self.volume;
		}
	}
	else // fire spikes - IDEA: will lavablob ever have other attacks?
	{
		if (rune_haste(0.125))
		self.attack_finished=time+0.25;

		fire_missile(SPIKE_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY, self.origin, '0 0 0', "lavaspike", "progs/spike.mdl", "chaos/lava-shot.wav", spike_touch, 6, SUB_Remove, SUB_Nop);
		newmis.skin = 1;
		newmis.morphy = self.morphy;
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

	if (!self.builtin & IT_ROCKET_LAUNCHER)
	{
		if (self.archon > 120) // ARCHON_MORPH_XMIN - minimum archon pts req to activate powers
		{
			self.builtin = self.builtin | IT_ROCKET_LAUNCHER;
			self.items = self.items | self.builtin;
		}
	}
	else
	if (self.archon < 7)
		self.items = self.items - (self.items & IT_ROCKET_LAUNCHER);
	else
		self.items = self.items | IT_ROCKET_LAUNCHER;	

	morph_impulse();

// switch to normal jump & back
	if (self.impulse == 16) // IMP_MJSWUP
	{
		if (self._jump2 == lavablob_jump1)
		{
			self._jump2=SUB_Null;
			stuffcmd(self, "hud_message \"Lava Bomb: normal jump\"\n");
		}
		else
		{
			self._jump2 = lavablob_jump1;
			stuffcmd(self, "hud_message \"Lava Bomb: jump attack\"\n");
		}
	}

/*
	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		sprint(self, "Lava Bomb using ( Jump attack )\n");
	}
*/
	self.volume = 0;

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
//		sprint(self, "Lava Bomb using ( Lava balls )\n");
		self.items = self.items | IT_CELLS;
	}

	if (self.weapon == IT_NAILGUN)
	{
//		sprint(self, "Lava Bomb using ( Lava nails )\n");
		self.items = self.items | IT_NAILS;
	}

	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.volume = -6;
//		sprint(self, "Lava Bomb using ( lava bombs! )\n");
		self.items = self.items | IT_ROCKETS;
	}
};

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/

string() player_lavablob_killmsg =
{
	return(rnd_string(' 60.0 50.0 40.0'," got melted by Lava Bomb ",null_string,null_string," was blasted by Lava Bomb "," was fired by "));
};
string() player_lavablob_killmsg2 =
{
	return "\n";
};

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_lavablob_become = 
{
	self._stand=player_lavablob_stand;
	self._run=player_lavablob_run;
	self._pain=lavablob_mytosis;
	self._die=lavablob_die;
	self._jump=SUB_Null;
	self._jump2=	lavablob_jump1;
	self._attack=player_lavablob_attack;
	self._impulse=player_lavablob_impulse;
	self._killmsg=player_lavablob_killmsg;
	self._killmsg2=player_lavablob_killmsg2;

	self.cam_z = 10 / 100;
	self.cam_y = 36;

	stuffcmd(self, "exec cfg/morph/m-lava.cfg\n");

	setmodel(self,"progs/lavabomb.mdl");
	self.modelindex_morph = self.modelindex;

	self.builtin = IT_AXE | IT_NAILGUN;
	self.items = self.items | self.builtin;
	self.weapon = IT_AXE;
	self.volume = 0; // because of swap
	self.mcode = 0; // in case we came back from cthon - for hud

	self.skin = 0;

	self.msight = "blob/sight1.wav";
//	self.noise2 = "enforcer/pain1.wav";
	self.noise3 = null_string;
	self.view_ofs = '0 0 4';

	setsize (self, '-16 -16 -24', '16 16 20');
	self.health = self.health * MLAVAB_HEALMOD / self.health_modifier;
	self.health_modifier = MLAVAB_HEALMOD;

	if (silent != -666) // NO_TFOG - not coming from cthon form
	{
		makevectors(self.v_angle);
		spawn_tfog(self.origin + 20 * v_forward);
	}
	else
		player_run(); // fix the back in blob, but firing cthon issue

};



