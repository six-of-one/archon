/* ::-::
 *
 * Cataboligne
 *
 * file: m-zombie.qc
 *
 * date: 9/18/11
 *
 * qc - support chaos mod morph ability
 *
 */

/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/


$cd /raid/quake/id1/models/zombie

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

void() m_precache_zombie =
{
//// Zombie morph
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("chaos/z_gas.wav");
	precache_sound ("zombie/idle_w2.wav");
};

/* Morph to zombie */

float FL_CLOUDED = 16384; // zombie shot cloudkill

// fn(zombie_regen) - handle morph zombie regeneration

// not same as npc zombie, thats overkill
// player zombies can be killed by explosions, combined attack, or quad shot > 74 pts damage in one slice and deep lava.

void() zombie_regen =
{
	self.inpain = 0;

	if (self.frame & 2)
		T_Heal(self, 1 + random() * 2.2, 0); // Zombies regenerate
};

void() player_zombie_stand = [ $stand1, player_stand1 ]
{
	self.movetype=MOVETYPE_WALK;

	if(self.walkframe >= 15)
		self.walkframe = 0;
	if (self.walkframe == 10) 
		{
		stuffcmd(self,"cl_movement_maxspeed 220\n"); // TESTING could be darkplaces only

		if (random() < 0.7)
			morph_sound(0.2, "zombie/z_idle.wav", 4);
		else
			morph_sound(0.2, "zombie/z_idle1.wav", 3);
		}
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	zombie_regen();
	if (self.health < 30)  zombie_regen();
	if (self.health < 20)  zombie_regen();
};

void() player_zombie_run = [ $run1, player_run ]
{
	vector sp;
	float walk, frm;

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 19) self.walkframe = 0;
		}
	else
		{
		frm = $run1;
		if (self.walkframe >= 18) self.walkframe = 0;
		}

	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;
	if (self.health < 20)  zombie_regen();
	if (self.health < 30)  zombie_regen();
	zombie_regen();
};

////////////////////////////////////////////
// 12 frames of paina for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_paina1 = [ $paina1, player_zombie_paina2 ] {self.attack_finished=time+10; /*self.movetype=MOVETYPE_NONE;*/};
void() player_zombie_paina2 = [ $paina2, player_zombie_paina3 ] { };
void() player_zombie_paina3 = [ $paina3, player_zombie_paina4 ] { zombie_regen(); };
void() player_zombie_paina4 = [ $paina4, player_zombie_paina5 ] { zombie_regen(); };
void() player_zombie_paina5 = [ $paina5, player_zombie_paina6 ] { };
void() player_zombie_paina6 = [ $paina6, player_zombie_paina7 ] { };
void() player_zombie_paina7 = [ $paina7, player_zombie_paina8 ] { };
void() player_zombie_paina8 = [ $paina8, player_zombie_paina9 ] { };
void() player_zombie_paina9 = [ $paina9, player_zombie_paina10 ] { };
void() player_zombie_paina10 = [ $paina10, player_zombie_paina11 ] { };
void() player_zombie_paina11 = [ $paina11, player_zombie_paina12 ] { };
void() player_zombie_paina12 = [ $paina12, player_stand1 ] {self.attack_finished=time; /*self.movetype=MOVETYPE_WALK;*/};

////////////////////////////////////////////
// 28 frames of painb for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_painb1 = [ $painb1, player_zombie_painb2 ] {self.attack_finished=time+10;};
void() player_zombie_painb2 = [ $painb2, player_zombie_painb3 ] { };
void() player_zombie_painb3 = [ $painb3, player_zombie_painb4 ] { self.movetype=MOVETYPE_NONE; };
void() player_zombie_painb4 = [ $painb4, player_zombie_painb5 ] { };
void() player_zombie_painb5 = [ $painb5, player_zombie_painb6 ] { zombie_regen(); };
void() player_zombie_painb6 = [ $painb6, player_zombie_painb7 ] { zombie_regen(); self.takedamage = DAMAGE_NO; };
void() player_zombie_painb7 = [ $painb7, player_zombie_painb8 ] { };
void() player_zombie_painb8 = [ $painb8, player_zombie_painb9 ] { };
void() player_zombie_painb9 = [ $painb9, player_zombie_painb10 ] { };
void() player_zombie_painb10 = [ $painb10, player_zombie_painb11 ] { };
void() player_zombie_painb11 = [ $painb11, player_zombie_painb12 ] { };
void() player_zombie_painb12 = [ $painb12, player_zombie_painb13 ] { };
void() player_zombie_painb13 = [ $painb13, player_zombie_painb14 ] { };
void() player_zombie_painb14 = [ $painb14, player_zombie_painb15 ] { zombie_regen(); };
void() player_zombie_painb15 = [ $painb15, player_zombie_painb16 ] { zombie_regen(); };
void() player_zombie_painb16 = [ $painb16, player_zombie_painb17 ] { };
void() player_zombie_painb17 = [ $painb17, player_zombie_painb18 ] { };
void() player_zombie_painb18 = [ $painb18, player_zombie_painb19 ] { };
void() player_zombie_painb19 = [ $painb19, player_zombie_painb20 ] { };
void() player_zombie_painb20 = [ $painb20, player_zombie_painb21 ] { };
void() player_zombie_painb21 = [ $painb21, player_zombie_painb22 ] { zombie_regen(); };
void() player_zombie_painb22 = [ $painb22, player_zombie_painb23 ] { zombie_regen(); self.movetype=MOVETYPE_WALK; };
void() player_zombie_painb23 = [ $painb23, player_zombie_painb24 ] { self.takedamage = DAMAGE_AIM; };
void() player_zombie_painb24 = [ $painb24, player_zombie_painb25 ] { };
void() player_zombie_painb25 = [ $painb25, player_zombie_painb26 ] { };
void() player_zombie_painb26 = [ $painb26, player_zombie_painb27 ] { };
void() player_zombie_painb27 = [ $painb27, player_zombie_painb28 ] { };
void() player_zombie_painb28 = [ $painb28, player_stand1 ] {self.attack_finished=time; };

////////////////////////////////////////////
// 18 frames of painc for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_painc1 = [ $painc1, player_zombie_painc2 ] {self.attack_finished=time+10; /*self.movetype=MOVETYPE_NONE;*/};
void() player_zombie_painc2 = [ $painc2, player_zombie_painc3 ] { };
void() player_zombie_painc3 = [ $painc3, player_zombie_painc4 ] { };
void() player_zombie_painc4 = [ $painc4, player_zombie_painc5 ] { };
void() player_zombie_painc5 = [ $painc5, player_zombie_painc6 ] { zombie_regen(); };
void() player_zombie_painc6 = [ $painc6, player_zombie_painc7 ] { zombie_regen(); };
void() player_zombie_painc7 = [ $painc7, player_zombie_painc8 ] { };
void() player_zombie_painc8 = [ $painc8, player_zombie_painc9 ] { };
void() player_zombie_painc9 = [ $painc9, player_zombie_painc10 ] { };
void() player_zombie_painc10 = [ $painc10, player_zombie_painc11 ] { };
void() player_zombie_painc11 = [ $painc11, player_zombie_painc12 ] { };
void() player_zombie_painc12 = [ $painc12, player_zombie_painc13 ] { };
void() player_zombie_painc13 = [ $painc13, player_zombie_painc14 ] { };
void() player_zombie_painc14 = [ $painc14, player_zombie_painc15 ] { zombie_regen(); };
void() player_zombie_painc15 = [ $painc15, player_zombie_painc16 ] { zombie_regen(); };
void() player_zombie_painc16 = [ $painc16, player_zombie_painc17 ] { };
void() player_zombie_painc17 = [ $painc17, player_zombie_painc18 ] { };
void() player_zombie_painc18 = [ $painc18, player_stand1 ] {self.attack_finished=time; /*self.movetype=MOVETYPE_WALK;*/};

////////////////////////////////////////////
// 13 frames of paind for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_paind1 = [ $paind1, player_zombie_paind2 ] {self.attack_finished=time+10; /*self.movetype=MOVETYPE_NONE;*/};
void() player_zombie_paind2 = [ $paind2, player_zombie_paind3 ] { };
void() player_zombie_paind3 = [ $paind3, player_zombie_paind4 ] { };
void() player_zombie_paind4 = [ $paind4, player_zombie_paind5 ] { };
void() player_zombie_paind5 = [ $paind5, player_zombie_paind6 ] { };
void() player_zombie_paind6 = [ $paind6, player_zombie_paind7 ] { };
void() player_zombie_paind7 = [ $paind7, player_zombie_paind8 ] { zombie_regen(); };
void() player_zombie_paind8 = [ $paind8, player_zombie_paind9 ] { zombie_regen(); };
void() player_zombie_paind9 = [ $paind9, player_zombie_paind10 ] { };
void() player_zombie_paind10 = [ $paind10, player_zombie_paind11 ] { };
void() player_zombie_paind11 = [ $paind11, player_zombie_paind12 ] { };
void() player_zombie_paind12 = [ $paind12, player_zombie_paind13 ] { };
void() player_zombie_paind13 = [ $paind13, player_stand1 ] {self.attack_finished=time; /*self.movetype=MOVETYPE_WALK;*/};

////////////////////////////////////////////
// 30 frames of paine for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_paine1 = [ $paine1, player_zombie_paine2 ] {self.attack_finished=time+10; };
void() player_zombie_paine2 = [ $paine2, player_zombie_paine3 ] { };
void() player_zombie_paine3 = [ $paine3, player_zombie_paine4 ] { self.movetype=MOVETYPE_NONE; };
void() player_zombie_paine4 = [ $paine4, player_zombie_paine5 ] { };
void() player_zombie_paine5 = [ $paine5, player_zombie_paine6 ] { zombie_regen(); };
void() player_zombie_paine6 = [ $paine6, player_zombie_paine7 ] { zombie_regen(); };
void() player_zombie_paine7 = [ $paine7, player_zombie_paine8 ] { };
void() player_zombie_paine8 = [ $paine8, player_zombie_paine9 ] { };
void() player_zombie_paine9 = [ $paine9, player_zombie_paine10 ] { };
void() player_zombie_paine10 = [ $paine10, player_zombie_paine11 ] 
{
sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);
self.solid = SOLID_NOT; // this a good idea?
self.lefty = CB_ZOMBY; // keep cam unless killed
self.takedamage = DAMAGE_NO; // take no damage while down - makes morph zombie too vulnerable
};
void() player_zombie_paine11 = [ $paine11, player_zombie_paine111 ] { self.nextthink = self.nextthink + 2.5; };
void() player_zombie_paine111 = [ $paine11, player_zombie_paine12 ] { self.nextthink = self.nextthink + 2.5; };
void() player_zombie_paine12 = [ $paine12, player_zombie_paine13 ]
{
if (self.flags & FL_CLOUDED)
	{
		if (self.attack_finished > time)
		{
		self.think = player_zombie_paine11;
		return;
		}
		self.flags = self.flags - (self.flags & FL_CLOUDED);
	}
else if (random() < 0.1) // player zombie fallen and cant get up - 10%
	{
	self.think = player_zombie_paine11;
	return;
	}
T_Heal(self, 45, 0);
sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);

self.solid = SOLID_SLIDEBOX;
self.lefty = 0;
};
void() player_zombie_paine13 = [ $paine13, player_zombie_paine14 ] { };
void() player_zombie_paine14 = [ $paine14, player_zombie_paine15 ] { };
void() player_zombie_paine15 = [ $paine15, player_zombie_paine16 ] { };
void() player_zombie_paine16 = [ $paine16, player_zombie_paine17 ] { };
void() player_zombie_paine17 = [ $paine17, player_zombie_paine18 ] { };
void() player_zombie_paine18 = [ $paine18, player_zombie_paine19 ] { };
void() player_zombie_paine19 = [ $paine19, player_zombie_paine20 ] { };
void() player_zombie_paine20 = [ $paine20, player_zombie_paine21 ] { };
void() player_zombie_paine21 = [ $paine21, player_zombie_paine22 ] { };
void() player_zombie_paine22 = [ $paine22, player_zombie_paine23 ] { zombie_regen(); self.movetype=MOVETYPE_WALK; };
void() player_zombie_paine23 = [ $paine23, player_zombie_paine24 ] { zombie_regen(); };
void() player_zombie_paine24 = [ $paine24, player_zombie_paine25 ] { };
void() player_zombie_paine25 = [ $paine25, player_zombie_paine26 ] { };
void() player_zombie_paine26 = [ $paine26, player_zombie_paine27 ] { };
void() player_zombie_paine27 = [ $paine27, player_zombie_paine28 ] { self.takedamage = DAMAGE_AIM;};
void() player_zombie_paine28 = [ $paine28, player_zombie_paine29 ] { };
void() player_zombie_paine29 = [ $paine29, player_zombie_paine30 ] { };
void() player_zombie_paine30 = [ $paine30, player_stand1 ] {self.attack_finished=time; };

void(entity attacker, float take) player_zombie_pain =
{
	local float ad;

	ad = random() * 25;

	if (self.health < 50) T_Heal(self, 10, 0);

	if (take < 9) return;
//	if (self.inpain == 2) return;
	if(self.pain_finished > time) return;

	self.air_finished = self.pain_finished = time + 3;

	if (take >= (25 + ad)) // hard hit, got knocked down
		{
//		self.inpain = 2;
		player_zombie_paine1 ();
		return;
		}

	if(random()>0.50) morph_sound (0.75, "zombie/z_pain.wav", 1);
	else morph_sound(1, self.noise2, 1);

		if(random() < 0.66) 
			{
			if(random() > 0.50) player_zombie_painc1();
			else player_zombie_paina1();
			}
		else 
			{
			if(random() > 0.35)player_zombie_paind1();
			else player_zombie_painb1();
			}
//	}
};

void() player_zombie_jump = {
	// Zombies can't jump
};

// fn(IS_ZOMBIE) - detect other zombies

float(entity e) IS_ZOMBIE =
{
	if (e.flags & FL_MONSTER && e.classname == "monster_zombie") return TRUE;
	return (e.morphy == IMP_MZOMBIE); // morph zombies
};

void() ZombieGrenadeTouch2;

// fn(ZombiePlague) - got hit by some plagued flesh, damn rotten zombies

// IDEA - limits to base type - i.e. q2 for q2 only, doom to doom only etc

float ST_BEATPLAGUE			= 3; // 3 rnds fighting off plague and its gone...for now
float ST_HEALPLAGUE			= 0.05; // % per for beating plague for normal health boxes
float CK_PLAGUE_CATCH		= 0.8; // chance per touch to catch plague - IDEA - diff for some morphs?
float CK_PLAGUE_RND			= 0.1; // chance to fight plague per round
float CK_PLAGUE_TIME			= 2; // time before retouch on bodies / heads
float CK_PLAGUE_ZGIB			= 0.3; // chance zombie gibs / head are plagued
float CK_PLAGUE_GIB			= 0.03; // chance regular gibs / head are plagued
float TM_PLAGUE				= 1; // round defined for think - 1 sec

void() ZombiePlague =
{
	local float dm;

	if (!self.enemy || self.lip > ST_BEATPLAGUE) // enemy gone? will this ever happen?
	{
		remove(self);
		return;
	}

	if (self.enemy.healtype == HEAL_ROT || self.enemy.healtype == HEAL_NORM)
	{
		if (random() < ST_HEALPLAGUE)
		{
			self.enemy.healtype = -1; // box only stops one plague ent
			remove(self);
			return;
		}
		else if (random() < 0.6)
			self.enemy.healtype = -1; // box has limited chances if it fails
	}

	if (self.enemy.healtype > HEAL_NORM || self.enemy.deadflag) // stopped by any special heal - IDEA includes d_berserk and q2_adrenaline
	{
//		self.enemy.healtype = -1; box stops all plague ents
		remove(self);
		return;
	}

	self.nextthink = time + TM_PLAGUE;

	if (random() < CK_PLAGUE_RND) 
	{
		self.lip = self.lip + 1;
		return; // fought off bug this rnd
	}

	self.lip = 0;
	dm = floor(random() * 5.5); // 0 - 5
	T_Damage (self.enemy, self, self.owner, dm );
	if (self.enemy.health < 0) self.enemy.deathtype = "plague";
};

// fn(PlagueTouch) - handle contact with plagued gibs & bodies

void() PlagueTouch =
{
	local entity p;

	if (IS_ZOMBIE(other)) return; // covers owner touch
	else if (self.invisible_time > time) return;

	if (random() < CK_PLAGUE_CATCH)
	if (other.takedamage && (other.classname == "player" || other.flags & FL_MONSTER))
	{
		p = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, v0, v0, v0, v0, v0, "plague", "", SUB_Null, 1, ZombiePlague, SUB_Null, self.owner, world);
		p.enemy = other;
		p.search_time = time + 120;
	}

	self.invisible_time = time + CK_PLAGUE_TIME + random() * CK_PLAGUE_TIME; // no re-touch for this long for bodies & heads
	if (self.class_select != "dead_body")
		ZombieGrenadeTouch2(); // do reg damage, remove missile - NOTE: not for entire bodies / heads
};

// fn(GibTDie) - gib tracer done

void() GibTDie =
{
//	self.dest_y = ITEM_MELTD;
	self.think = meltthink;
};

// fn(GibTracer) - shoot zombies enemys in range

// IDEA - squisy slashy type sound made periodically

void() GibTracer =
{
	self.nextthink = time + 0.1;

	if (self.turret_timeout < time || self.health < 0) // ran out
	{
		self.th_die(); // gib tracer
		return;
	}

	if (self.owner.enemy)
	if (self.owner.enemy.takedamage && (self.owner.enemy.classname == "player" || self.owner.enemy.flags & FL_MONSTER))
	{
		if (self.owner.enemy.mask_x & CB_ZOMBY) return; // can this even happen?

		fire_missile(ZOMBIE_FLSH_VEL * 0.833335, MOVETYPE_FLYMISSILE, FL_CTHONF, RM_SKY | MLT_LAVA | FL_NOPART | CK_EARTHQUAKE | PF_SOLID, self.origin + '0 0 10', self.owner.enemy.origin - self.origin, "grenade", "progs/zom_gib.mdl", "zombie/z_shot1.wav", ZombieGrenadeTouch2, 2.5, SUB_Remove, SUB_Null);
		newmis.dmg = 10 + random() * 5;
		self.health = self.health - newmis.dmg;
		newmis.avelocity = '3000 1000 2000';

		self.nextthink = time + 1.3; // only shoot so often
	}
};

// gib tracer deal

void() ZombieGrenadeTouch2 =
{
	local float h;
	
	if (other.mask_x & CB_ZOMBY) return;

	if (self.classname == "gib_tracer") // touched a gib tracer - do a bit of damage - IDEA chance of plague
	if (self.attack_finished < time) // limit to touch hits
	{
		h = 5 + random() * 5;
		T_Damage (other, self, self.owner, h);
		self.health = self.health + h;
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		self.attack_finished = time + 0.3 + random();
		return;
	}
	self.owner.enemy = other;
	ZombieGrenadeTouch(); // reg damage
};


void() player_ZombieFireGrenade =
{
	if (self.weapon == IT_NAILGUN) // shoot gib fountain chunk
	{
		fire_missile(ZOMBIE_FLSH_VEL, MOVETYPE_BOUNCE, FL_GRN , RM_SKY | MLT_LAVA | FLT_LAVA | FL_NOPART | CK_EARTHQUAKE | PF_SOLID, self.origin + '0 0 8', ' 0 0 0', "gib_tracer", "progs/gib_m.mdl", "zombie/z_shot1.wav", ZombieGrenadeTouch2, 0.1, GibTracer, GibTDie);
		newmis.frame = 7;
		newmis.takedamage = DAMAGE_YES;
		newmis.health = 300;
		newmis.turret_timeout = 30 + random() * 60 + time;
		newmis.avelocity = '400 250 500';
		return;
	}
	else
		fire_missile(ZOMBIE_FLSH_VEL, MOVETYPE_BOUNCE, FL_GRN , RM_SKY | MLT_LAVA | FL_NOPART | CK_EARTHQUAKE | PF_SOLID, self.origin + '0 0 8', ' 0 0 0', "grenade", "progs/zom_gib.mdl", "zombie/z_shot1.wav", ZombieGrenadeTouch2, 2.5, SUB_Remove, SUB_Null);

	newmis.dmg = 10 + random() * 15;  // player stinks a little bit more, thus more dmg
	newmis.avelocity = '3000 1000 2000';

	if (self.weapon == IT_SUPER_SHOTGUN) newmis.touch = PlagueTouch; // plague'd meat - regular shot  + plague touch
};


// fn(cloudkill) - think fn for cloudkill effects

// .dmg - damage per sec
// .dmg_save - random damage per sec
//. dmg_take - falloff range ala scraggs pain field
// .distance - cloud size / range - IDEA volume that fills a space?
// .cnt, .lip - particle thickness / random thickness
// .search_time - how long cloud lives
// .state - clouds state kill, startup, live, shutdown = < 0, >200, 100 - 200, < 100, 
// .count - used for percentage on up & down, set to 0
// .rad_time - chance of instant death after time + this
// .lefty - chance of instant death
// IDEAS: color?

float MIN_CLOUD_DIST			= 800; // minimum distance between player / zombie clouds
float CLOUD2_STATE			= 40; // if 2nd cloud is to start - cloud 1 state must be < than this

void() cloudkill =
{
	local float dist, mult, f, clc;
	local entity head;

	if (self.classname != "cloudkill") // called as fn - make a cloudkill
	{
		chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, RM_SKY, self.origin, v0, v0, v0, v0, "cloudkill", "", SUB_Null, 0.2,cloudkill, SUB_Null, self, world);
		return;
	}

	if (self.search_time) if (self.search_time < time) self.state = 10 + random() * self.lip; // running down now

	if (!self.state) // state not preset - do an init
	{
		self.wait = 5;
		if (!self.lip) self.lip = 10 * random();
		self.state = 210 + random() * self.lip;
		self.count = 201;
		if (self.search_time < time) // didnt set a time - come up with some random life span ~ 60 sec to 150 sec +
		{
			self.search_time = time + 60 + random() * self.lip + random() * self.cnt;
			if (random() < 0.15) self.search_time = self.search_time + 60 + 30 * random();
		}
		if (!self.cnt) self.cnt = 10 + 5 * random();
		if (self.distance < 10)
		{
			self.distance = 50 + random() * 100;
			if (random() < 0.3) self.distance = self.distance + random() * random() * 120;
		}
		if (self.rad_time < 30) self.rad_time = 60 + random() * 30; // time before instant death checked
		if (!self.lefty) self.lefty = 0.02; // 2% chance to die per sec beyond above
	}

	if (self.state < 0)
	{
		self.owner.enemy = world;
		remove(self);
		return;
	}

	mult = 1;

	if (self.state < 100) // wind down
	{
		self.search_time = 0;
		if (self.count < self.state || self.count > 100) self.count = self.state;
		self.state = self.state - 1;
		if (random() < 0.2) self.state = self.state - random();
		mult = self.state / self.count; // percentage slump

//		self.distance = self.distance * dist;
//		if (dist < 0.5) self.cnt = self.cnt * dist;
//		if (dist < 0.4) self.dmg = self.dmg * dist;
	}

	if (self.state > 200) // start up
	{
		mult = (self.count - 200) / (self.state - 200);
		self.state = self.state - 1;
		if (random() < 0.2) self.state = self.state - 1.5 * random();
	}

	
	self.nextthink = time + 0.2;

	clc = 0; // cloud blob cound
	dist = (self.cnt + random() * self.lip) * mult;


bprint("cloud loop: ");
bprint(ftos(dist));
bprint("\n");



	while (dist > 0) // particle effects cloud
	{
		dist = dist - 1;
		chaos_particle(self.origin, self.distance * mult, 1, 56 + random() * 6);

		if (DARKPLACES) // clouds from mdl
		{
			local entity e;
			head = findradius(self.origin, self.distance * mult);
			f = TRUE;
			if (clc > 15)
			while (head && f)
			{
				if (head.classname == "clouds")
				if (vlen(head.origin - cparticle_lorg) < 10)
					f = FALSE;
				head = head.chain;
			}
			if (f && clc < 100)
			{
				clc = clc + 1;
				e = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, RM_SKY, cparticle_lorg, v0, v0, v0, v0, "clouds", "progs/lavaball.mdl", SUB_Null, 0.4,SUB_Remove, SUB_Null, self, world);
//				e = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, RM_SKY, self.origin, v0, v0, v0, v0, "clouds", "progs/lavaball.mdl", SUB_Null, 0.4,SUB_Remove, SUB_Null, self, world);
//				e.origin_x = e.origin_x + crandom() * 60;
//				e.origin_y = e.origin_y + crandom() * 60;
//				e.origin_z = e.origin_z + crandom() * 60;
				if (e.origin_z < 10) e.origin_z = e.origin_z + 5 +  random() * 8; // get out of floor - turns dark when unlit from origin outside level
				e.alpha = 0.01 + random() * 0.1;
				e.frame = 12;
				e.skin = 5;
				e.effects = EF_NOMODELFLAGS;
				e.angles_y = crandom() * 180;
				e.angles_z = crandom() * 180;
			}
		}
	}

// cloud damage here

	head = findradius(self.origin, self.distance * mult);
	if (self.wait > 1) self.wait = self.wait - 1;
	else
	while (head)
	{
		self.wait = 5; // dmg once per sec.
		if (head != self)
		if (head.solid == SOLID_SLIDEBOX)  // BLOODCHECK - this is one for sure that we might want FL_CLIENT, FL_MONSTER so its more inclusive
		{
			if (!IS_ZOMBIE(head)) // us / our family
			if (!IS_LAVA(head)) // non breathers // IDEA also exclude wraiths
			if (head.takedamage)
			{
				dist = vlen(head.origin - self.origin);
				if (head.lastvictim != self || head.cnt < 2)
				{
					head.lastvictim = self;
					head.cnt = time + self.rad_time;
				}

				if (self.dmg_take > 0)
					T_Damage (head, self, self.owner, self.dmg * (self.dmg_take / dist) + self.dmg_save * random());
				else
					T_Damage (head, self, self.owner, self.dmg + self.dmg_save * random());
/* // IDEA - count cumulative dmg?	
				if (!morph_ffchk(self.owner,head))
				{
					if (self.dmg > 4)
						SpawnBlood (head.origin, ' 0 0 0', head.cnt * (FULL_EFFECT_DIST / dist));
				}
*/
if (WARNING)
{
bprint("cloud vic: ");
bprint(head.classname);
bprint(" dmg: ");
if (self.dmg_take > 20)
	bprint(ftos(self.dmg  * (self.dmg_take / dist)));
else
	bprint(ftos(self.dmg));
}

				if (self.rad_time) // sudden death
				if (self.lefty)
				if (mult == 1)
				if (head.cnt  < time)
				if (random() < self.lefty) { if (WARNING) bprint("\ndied!");
					T_Damage (head, self, self.owner, head.health + 5);
} if (WARNING) bprint("\n");
			}
		}
		head = head.chain;
	}

};

////////////////////////////////////////////
// 13 frames of atta for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_atta1 = [ $atta1, player_zombie_atta2 ] { };
void() player_zombie_atta2 = [ $atta2, player_zombie_atta3 ] { };
void() player_zombie_atta3 = [ $atta3, player_zombie_atta4 ] { };
void() player_zombie_atta4 = [ $atta4, player_zombie_atta5 ] { };
void() player_zombie_atta5 = [ $atta5, player_zombie_atta6 ] { };
void() player_zombie_atta6 = [ $atta6, player_zombie_atta7 ] { };
void() player_zombie_atta7 = [ $atta7, player_zombie_atta8 ] { };
void() player_zombie_atta8 = [ $atta8, player_zombie_atta9 ] { };
void() player_zombie_atta9 = [ $atta9, player_zombie_atta10 ] { };
void() player_zombie_atta10 = [ $atta10, player_zombie_atta11 ] { };
void() player_zombie_atta11 = [ $atta11, player_zombie_atta12 ] { };
void() player_zombie_atta12 = [ $atta12, player_zombie_atta13 ] { };
void() player_zombie_atta13 = [ $atta13, player_stand1 ] { player_ZombieFireGrenade(); self.attack_finished=time; };

////////////////////////////////////////////
// 14 frames of attb for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_attb1 = [ $attb1, player_zombie_attb2 ] { };
void() player_zombie_attb2 = [ $attb2, player_zombie_attb3 ] { };
void() player_zombie_attb3 = [ $attb3, player_zombie_attb4 ] { };
void() player_zombie_attb4 = [ $attb4, player_zombie_attb5 ] { };
void() player_zombie_attb5 = [ $attb5, player_zombie_attb6 ] { };
void() player_zombie_attb6 = [ $attb6, player_zombie_attb7 ] { };
void() player_zombie_attb7 = [ $attb7, player_zombie_attb8 ] { };
void() player_zombie_attb8 = [ $attb8, player_zombie_attb9 ] { };
void() player_zombie_attb9 = [ $attb9, player_zombie_attb10 ] { };
void() player_zombie_attb10 = [ $attb10, player_zombie_attb11 ] { };
void() player_zombie_attb11 = [ $attb11, player_zombie_attb12 ] { };
void() player_zombie_attb12 = [ $attb12, player_zombie_attb13 ] { };
void() player_zombie_attb13 = [ $attb12, player_zombie_attb14 ] { };
void() player_zombie_attb14 = [ $attb14, player_stand1 ] { player_ZombieFireGrenade(); self.attack_finished=time; };

////////////////////////////////////////////
// 12 frames of attc for player_zombie, going to stand
////////////////////////////////////////////

void() player_zombie_attc1 = [ $attc1, player_zombie_attc2 ] { };
void() player_zombie_attc2 = [ $attc2, player_zombie_attc3 ] { };
void() player_zombie_attc3 = [ $attc3, player_zombie_attc4 ] { };
void() player_zombie_attc4 = [ $attc4, player_zombie_attc5 ] { };
void() player_zombie_attc5 = [ $attc5, player_zombie_attc6 ] { morph_sound(0.1, "zombie/idle_w2.wav", 3); };
void() player_zombie_attc6 = [ $attc6, player_zombie_attc7 ] { };
void() player_zombie_attc7 = [ $attc7, player_zombie_attc8 ] { };
void() player_zombie_attc8 = [ $attc8, player_zombie_attc9 ] { };
void() player_zombie_attc9 = [ $attc9, player_zombie_attc10 ] { };
void() player_zombie_attc10 = [ $attc10, player_zombie_attc11 ] { };
void() player_zombie_attc11 = [ $attc11, player_zombie_attc12 ] { };
void() player_zombie_attc12 = [ $attc12, player_stand1 ] { player_ZombieFireGrenade(); self.attack_finished=time; };

/*
 new zombie attacks to balance morph battle

	plague shot - the gift that keeps giving, causes random dmg 0-5 per sec. after hit, until dead or mega healed
			IDEA - humans / gremlins could rise as zombies if killed this way - transformation process

	tracer gib - large twitching gib shot out - will shoot 10 pt dmg flesh blobs and anyone the zombie attacks
			like sentry it will run out of health, can be blasted to small gibblets, max 3 useable every so often

	cloudkill - decomposing body releases massive cloud of noxious gases - knocked down for 1 - 2 min after
			any breathing morph in cloud loses 5-10 pts per sec.  wont affect lavablob, chaos
			chance of instant death after short time (2 min +)
*/

void() player_zombie_attack =
{
	local entity p;

	if (self.weapon != IT_AXE)
	{
		self.attack_finished=time+10; // note: trick to put finish time into fire frames - ISSUE: dont work with rune haste!
		if(random()>0.66) player_zombie_atta1();
		else if(random()>0.5) player_zombie_attb1();
		else player_zombie_attc1();
	}
	else
	if (!self.enemy || self.enemy.classname != "cloudkill" || ( (self.enemy.state < CLOUD2_STATE) && (vlen(self.origin - self.enemy.origin) > MIN_CLOUD_DIST) ) )
	{
		self.enemy = p = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, RM_SKY, self.origin, v0, v0, v0, v0, "cloudkill", "", SUB_Null, 0.2,cloudkill, SUB_Null, self, world);
		p.dmg = 2;
		p.dmg_save = 1;
		p.dmg_take = 0;
		p.cnt = 70;
		p.lip = 20;
		p.distance = self.health * 3;
		p.search_time = time + self.health + self.health * 0.5 * random() + 30 * random();
		p.rad_time = self.health * 0.6 + 30 * random();
		p.lefty = 0.04;
		self.flags = self.flags | FL_CLOUDED; // take a short dirt nap
		self.attack_finished = time + 60 + 60 * random();
		sound (self, CHAN_VOICE, "chaos/z_gas.wav", 1, ATTN_NORM);
		player_zombie_paine1(); // falls down after gas out
	}
};

// fn(player_zombie_impulse) - extra weps

void() player_zombie_impulse =
{
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	if (self.pk_currentitem != PK_IT_AXE) return; // selected a pk goody - dont re-message

	if (self.weapon == IT_AXE)
	{
//		self.items = self.items | IT_AXE;
		sprint(self, "Zombie using ( stench cloud )\n"); 
	}

	if (self.weapon == IT_SHOTGUN)
	{
		sprint(self, "Zombie using ( flesh spray )\n");
//		self.items = self.items | IT_SHOTGUN;
	}

	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		sprint(self, "Zombie using ( plague'd meat )\n");
//		self.items = self.items | IT_SUPER_SHOTGUN;
	}

	if (self.weapon == IT_NAILGUN)
	{
		sprint(self, "Zombie using ( gib fountain )\n");
//		self.items = self.items | IT_NAILGUN;
	}
};


string() player_zombie_killmsg = {
	if (random() < 0.8)
		return " was splatted to death by ";
	else
		return " caught leprosy from ";
};

string() player_zombie_killmsg2 = {
	return ", and rotted away.\n";
};

void(float silent) player_zombie_become = 
{
	self._stand=player_zombie_stand;
	self._run=player_zombie_run;
	self._pain=player_zombie_pain;
	self._die=zombie_die;
	self._jump=SUB_Nop; // white zombie cant jump
	self._jump2=SUB_Nop;
	self._attack=player_zombie_attack;
	self._impulse=player_zombie_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_zombie_killmsg;
	self._killmsg2=player_zombie_killmsg2;

	setmodel(self,"progs/zombie.mdl");
//	self.modelindex_morph=self.modelindex;
//	self.mask_x = CB_ZOMBY;
	self.builtin = self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN;
	self.weapon = IT_SHOTGUN;

//	self._hk_major = morph_major;
//	self._hk_lesser = morph_lesser;
	self.msight = "zombie/idle_w2.wav";
	self.noise2 = "zombie/z_pain1.wav";
	self.noise2 = "";
	self.view_ofs = '0 0 20'; // lowered 2
	self.cam_z = 0.1;
	self.lefty = 0; // cam
//	if(!deathmatch)
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
//	 	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = self.health * MZOMBIE_HEALMOD / self.health_modifier;
	self.health_modifier = MZOMBIE_HEALMOD;
					// should this be the cl_* speeds?
//	stuffcmd (self, "sv_maxspeed 150\n");  // they stink, lose body parts and are slowwww...
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);


	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become a zombie.\n"); // yuk :-|~
		morph_impulse();
		}
};

