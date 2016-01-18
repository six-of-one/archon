/* ::-::
 *
 * Cataboligne
 *
 * file: bossman.qc
 *
 * date: 9/26/11
 *
 * qc - support chaos mod monster II
 *
 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/

$cd id1/models/boss
$origin 0 0 24
$base base
$skin skin


// longer arm waving stand frames
$frame mad1 mad2 mad3 mad4 mad5 mad6

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11

$frame sit1 sit2 sit3 sit4 sit5 sit6 sit7 sit8 sit9
$frame sit10 sit11 sit12 sit13 sit14 sit15 sit16 sit17
$frame sit18 sit19 sit20 sit21 sit22

// short stand frames
$frame talk1 talk2 talk3 talk4

$frame train1 train2 train3 train4 train5 train6

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13

$frame dance1 dance2 dance3 dance4 dance5 dance6 dance7 dance8 dance9

// a single fall frame - leaned back, 1 arm up
$frame fall1




//===========================================================================

// talking - stand frames

void()	bossman_talk1	=[	$stand1,	bossman_talk2	] {ai_stand();};
void()	bossman_talk2	=[	$stand2,	bossman_talk3	] {ai_stand();};
void()	bossman_talk3	=[	$stand3,	bossman_talk4	] {ai_stand();};
void()	bossman_talk4	=[	$stand4,	bossman_talk1	] {ai_stand();};

//===========================================================================

void(string sd) bossman_idle_sound =
{
	if (random() < 0.08)
		sound (self, CHAN_VOICE, sd, 1, ATTN_NORM);
};


void()	bossman_walk1	=[	$walk1,		bossman_walk2	] {
bossman_idle_sound("mon_II/bossman/bosshi.wav");
ai_walk(2);};
void()	bossman_walk2	=[	$walk2,		bossman_walk3	] {ai_walk(5);};
void()	bossman_walk3	=[	$walk3,		bossman_walk4	] {ai_walk(5);};
void()	bossman_walk4	=[	$walk4,		bossman_walk5	] {ai_walk(4);};
void()	bossman_walk5	=[	$walk5,		bossman_walk6	] {ai_walk(4);};
void()	bossman_walk6	=[	$walk6,		bossman_walk7	] {ai_walk(2);};
void()	bossman_walk7	=[	$walk7,		bossman_walk8	] {ai_walk(2);};
void()	bossman_walk8	=[	$walk8,		bossman_walk9	] {ai_walk(3);};
void()	bossman_walk9	=[	$walk9,		bossman_walk10	] {ai_walk(3);};
void()	bossman_walk10	=[	$walk10,	bossman_walk11	] {ai_walk(4);};
void()	bossman_walk11	=[	$walk11,	bossman_walk1	] {ai_walk(3);};


//===========================================================================

// mad - area attack "blah blah blah blah blah"

float BOSS_BLAH_DIST = 800;
float BOSS_BLAH_DMG = 1;

void() boss_blahblah =
{
	local entity e;
	local float f;

	self.enemy = world;
	e = findradius(self.origin, BOSS_BLAH_DIST);
	while (e)
	{
		if (e.netname != "Bossman")
		if (e.takedamage)
		if (e.flags & FL_CLIENT || e.flags & FL_MONSTER) // TDO: qualify morphs & monsters?
		{
			f = vlen(self.enemy.origin - self.origin);
			if (!self.enemy) self.enemy = e;
			else if (vlen(e.origin - self.origin) < f) self.enemy = e; // closest enemy gets face

			f = 0;
			if (vlen(e.origin - self.origin) < (BOSS_BLAH_DIST * 0.6))
				f = 2 * random();
//				T_Damage (e, self, self, 2 * random());
			if (vlen(e.origin - self.origin) < (BOSS_BLAH_DIST * 0.25))
				f = f + 2 + 4 * random();
//				T_Damage (e, self, self, 2 + 4 * random());
if (!e.flags & FL_CLIENT)//TEST:
			T_Damage (e, self, self, BOSS_BLAH_DMG + f);



bprint("boss blah attack: ");
bprint(item_ident(e));
bprint(" - dmg = ");
bprint(ftos(f + 1));
bprint("\n");




		}
		e = e.chain;
	}
	if (!self.enemy) // no one to attack
	{
		self.enemy = world;
		bossman_walk1();
		return;
	}

	if (self.attack_finished < time)
	{
		self.attack_finished = time  + 2.98;
		sound (self, CHAN_VOICE, "mon_II/bossman/bossblah.wav", 1, ATTN_NORM);
	}
}

void()	bossman_mad1	=[	$stand1,	bossman_mad2	] {ai_face();};
void()	bossman_mad2	=[	$stand2,	bossman_mad3	] {boss_blahblah();};
void()	bossman_mad3	=[	$stand3,	bossman_mad4	] {ai_face();};
void()	bossman_mad4	=[	$stand4,	bossman_mad5	] {ai_face();};
void()	bossman_mad5	=[	$stand5,	bossman_mad6	] {boss_blahblah();};
void()	bossman_mad6	=[	$stand6,	bossman_mad1	] {ai_face();};



//===========================================================================

void()	bossman_run1	=[	$walk1,		bossman_run2	]
{
bossman_idle_sound("mon_II/bossman/bossback.wav");
ai_run (20); 
};
void()	bossman_run2		=[	$walk2,		bossman_run3		] {ai_run(25);};
void()	bossman_run3		=[	$walk3,		bossman_run4		] {ai_run(18);};
void()	bossman_run4		=[	$walk4,		bossman_run5		] {ai_run(16);};
void()	bossman_run5		=[	$walk5,		bossman_run6		] {ai_run(14);};
void()	bossman_run6		=[	$walk6,		bossman_run7		] {ai_run(25);};
void()	bossman_run7		=[	$walk7,		bossman_run8		] {ai_run(21);};
void()	bossman_run8		=[	$walk8,		bossman_run9		] {ai_run(13);};
void()	bossman_run9		=[	$walk9,		bossman_run10	] {ai_run(18);};
void()	bossman_run10	=[	$walk10,	bossman_run11	] {ai_run(17);};
void()	bossman_run11	=[	$walk11,	bossman_run1		] {ai_run(15);};

//============================================================================

void()	bossman_pain1	=[	$train1,		bossman_pain2	] {sound (self, CHAN_VOICE, "mon_II/bossman/bossgard.wav", 1, ATTN_NORM);};
void()	bossman_pain2	=[	$train2,		bossman_pain3	] {};
void()	bossman_pain3	=[	$train3,		bossman_pain4	] {};
void()	bossman_pain4	=[	$train4,		bossman_pain5	] {};
void()	bossman_pain5	=[	$train5,		bossman_pain6	] {};
void()	bossman_pain6	=[	$train6,		bossman_run1	] {};

//============================================================================

void()	bossman_die1	=[	$death1,	bossman_die2	] {ai_forward(-10);};
void()	bossman_die2	=[	$death2,	bossman_die3	] {ai_forward(-8);};
void()	bossman_die3	=[	$death3,	bossman_die4	]
{self.solid = SOLID_NOT; ai_forward(-7);};
void()	bossman_die4	=[	$death4,	bossman_die5	] {};
void()	bossman_die5	=[	$death5,	bossman_die6	] {};
void()	bossman_die6	=[	$death6,	bossman_die7	] {};
void()	bossman_die7	=[	$death7,	bossman_die8	] {};
void()	bossman_die8	=[	$death8,	bossman_die9	] {ai_forward(-10);};
void()	bossman_die9	=[	$death9,	bossman_die10	] {ai_forward(-11);};
void()	bossman_die10	=[	$death10,	bossman_die11	] {};
void()	bossman_die11	=[	$death11,	bossman_die12	] {};
void()	bossman_die12	=[	$death12,	bossman_die13	] {};
void()	bossman_die13	=[	$death13,	bossman_die13	] {};

void() bossman_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_hellkn.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "mon_II/bossman/bossdead.wav", 1, ATTN_NORM);
	bossman_die1 ();

};


//============================================================================

// TDO: chance of going into mad for multiple enemies

void()	bossman_dance1 =[	$dance1,	bossman_dance2	] {ai_face();};
void()	bossman_dance2 =[	$dance2,	bossman_dance3	]
{
	ai_face();
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "mon_II/bossman/bossfall1.wav", 1, ATTN_NORM);
	else if (random() < 0.2)
		sound (self, CHAN_VOICE, "mon_II/bossman/bossfall2.wav", 1, ATTN_NORM);
};
void()	bossman_dance3 =[	$dance3,	bossman_dance4	] {ai_face();};
void()	bossman_dance4 =[	$dance4,	bossman_dance5	] {ai_melee();};
void()	bossman_dance5 =[	$dance5,	bossman_dance6	] {ai_melee();};
void()	bossman_dance6 =[	$dance6,	bossman_dance7	] {ai_face();};
void()	bossman_dance7 =[	$dance7,	bossman_dance8	] {ai_face();};
void()	bossman_dance8 =[	$dance8,	bossman_dance9	] {ai_face();};
void()	bossman_dance9 =[	$dance9,	bossman_run1	] {ai_face();};


//============================================================================

void(entity attacker, float damage)	bossman_pain =
{
	if (self.pain_finished > time)
		return;

//	sound (self, CHAN_VOICE, "mon_II/bossman/bossgard.wav", 1, ATTN_NORM);

	if (time - self.pain_finished > 5)
	{	// allways go into pain frame if it has been a while
		bossman_pain1 ();
		self.pain_finished = time + 1;
		return;
	}
	
	if ((random()*30 > damage))
		return;		// didn't flinch

	self.pain_finished = time + 1;
	bossman_pain1 ();

	if (random() < 0.2)
		sound (self, CHAN_VOICE, "mon_II/bossman/bossat1.wav", 1, ATTN_NORM);
	else if (random() < 0.2)
		sound (self, CHAN_VOICE, "mon_II/bossman/bossat2.wav", 1, ATTN_NORM);
};


// main range attack

void() bossman_mad =
{

	sound (self, CHAN_WEAPON, "mon_II/bossman/bosshi.wav", 1, ATTN_NORM);

	bossman_mad1 ();

};


/*QUAKED monster_bossman (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void(float ign) monster_bossman =
{
if (ign != A_MONSTER)
{
	if (!M_MONSTER_II & CB_M_BOSSMAN)
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/bossman.mdl");
	
	precache_sound2 ("mon_II/bossman/bossback.wav");
	precache_sound2 ("mon_II/bossman/bossblah.wav");
	precache_sound2 ("mon_II/bossman/bossdead.wav");
	precache_sound2 ("mon_II/bossman/bossecho.wav");
	precache_sound2 ("mon_II/bossman/bossgard.wav");
	precache_sound2 ("mon_II/bossman/bosshi.wav");
	precache_sound2 ("mon_II/bossman/bossat1.wav");
	precache_sound2 ("mon_II/bossman/bossat2.wav");
	precache_sound2 ("mon_II/bossman/bossfall1.wav");
	precache_sound2 ("mon_II/bossman/bossfall2.wav");
	precache_sound2 ("mon_II/bossman/bossfall3.wav");
}
	self.netname = "Bossman";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/bossman.mdl");
	self.skin = floor(6 * random());

	setsize (self, '-16 -16 -24', '16 16 60');
	self.health = 800;

	self.th_stand = bossman_talk1;
	self.th_walk = bossman_walk1;
	self.th_run = bossman_walk1; // idea: train frames?
	self.th_melee = bossman_dance1;
	self.th_missile = bossman_mad;
	self.th_pain = bossman_pain;
	self.th_die = bossman_die;

	walkmonster_start ();
};
