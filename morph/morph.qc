/* ::-::
 *
 * Cataboligne
 *
 * file: morph.qc
 *
 * date: 9/14/11
 *
 * qc - support chaos mod morph ability
 *
 */

// flag masks - how cube knows what to offer

float MORPH_ARCHON;
float MORPH_MARINE;
float MORPH_MONSTER;
float MORPH_CASTLE; // wolf ?
float MORPH_HELLION;
float MORPH_STROG;
float MORPH_ARENA;
float MORPH_ANCIENT;

void() morph_setup =
{
	MORPH_ARCHON = CB_CHAOS + CB_ORDER;
	MORPH_MONSTER = CB_DEMON + CB_ENF + CB_HKNIGHT + CB_OGRE + CB_SHALR + CB_SHAMBL + CB_SCRAG + CB_ZOMBY + CB_CTHON + CB_GREMLIN +CB_SCOURGE;
//	MORPH_CASTLE = + ;
	MORPH_HELLION = CB_IMP + CB_ARACHN + CB_CYBER;
	MORPH_STROG = CB_GUNNEY + CB_TANK + CB_SUPTANK;
//	MORPH_ARENA = + ;
	MORPH_ANCIENT = CB_WRAITH + CB_DRAGON;

	MORPH_ALL = MORPH_ARCHON + MORPH_MONSTER + MORPH_HELLION + MORPH_STROG + MORPH_ANCIENT + CB_HUMAN;

// these morph fly nativley
	MORPH_FLY = CB_CHAOS + CB_ORDER + CB_SCRAG + CB_WRAITH + CB_DRAGON + CB_GREMLIN;
};



void() morph_precache =
{
	m_precache_scourge();
};



// fn (cb_morph) - provide CB_* value given a morphy, or vice versa

float(float sel) cb_morph =
{
// morphic codes to bits

	if (sel == IMP_MCHAOS)				return(CB_CHAOS);
	else if (sel == IMP_MORDER)		return(CB_ORDER);
//Techs:
	else if (sel == IMP_MHUMAN)		return(CB_HUMAN);
	else if (sel == CHAR_W)				return(CB_HUMAN);
	else if (sel == CHAR_D)				return(CB_HUMAN);
	else if (sel == CHAR_Q)				return(CB_HUMAN);
	else if (sel == CHAR_PK)			return(CB_HUMAN);
	else if (sel == CHAR_Q2)			return(CB_HUMAN);
	else if (sel == CHAR_Q3)			return(CB_HUMAN);
	else if (sel == IMP_MDEMO)			return(CB_DEMO);
//	else if (sel == IMP_MSPECIAL)		return(CB_SPEC);
//Medieval:
	else if (sel == IMP_MWRAITH)		return(CB_WRAITH);
	else if (sel == IMP_MDRAGON)		return(CB_DRAGON);
//Q2
	else if (sel == IMP_MGUNNEY)		return(CB_GUNNEY);
	else if (sel == IMP_MTANK)			return(CB_TANK);
	else if (sel == IMP_MSUPTANK)		return(CB_SUPTANK);
//Beastie:
	else if (sel == IMP_MZOMBIE)		return(CB_ZOMBY);
	else if (sel == IMP_MSHALR)		return(CB_SHALR);
	else if (sel == IMP_MWIZARD)		return(CB_SCRAG);
	else if (sel == IMP_MHKNIGHT)		return(CB_HKNIGHT);
	else if (sel == IMP_MSHAMBLR)		return(CB_SHAMBL);
	else if (sel == IMP_MDEMON)		return(CB_DEMON);
	else if (sel == IMP_MOGRE)			return(CB_OGRE);
	else if (sel == IMP_MCTHON)		return(CB_CTHON);
	else if (sel == IMP_MSCOURGE)		return(CB_SCOURGE);
	else if (sel == IMP_MGREMLIN)		return(CB_GREMLIN);
	else if (sel == IMP_MENF)			return(CB_ENF);
	else if (sel == IMP_MIMP)			return(CB_IMP);
	else if (sel == IMP_MCYBER)		return(CB_CYBER);
	else if (sel == IMP_MARACHN)		return(CB_ARACHN);
//anode:
	else if (sel == IMP_MANODEX)		return(CB_ANODEX);

// bit masks to morphic

	else if (sel == CB_CHAOS)			return(IMP_MCHAOS);
	else if (sel == CB_ORDER)			return(IMP_MORDER);
//Techs:
	else if (sel == CB_HUMAN)			return(IMP_MHUMAN);
	else if (sel == CB_DEMO)			return(IMP_MDEMO);
//	else if (sel == CB_SPECIAL)		return(IMP_MSPEC);
//Medieval:
	else if (sel == CB_WRAITH)			return(IMP_MWRAITH);
	else if (sel == CB_DRAGON)			return(IMP_MDRAGON);
//Strogs:
	else if (sel == CB_GUNNEY)			return(IMP_MGUNNEY);
	else if (sel == CB_TANK)			return(IMP_MTANK);
	else if (sel == CB_SUPTANK)		return(IMP_MSUPTANK);
//Beastie:
	else if (sel == CB_ZOMBY)			return(IMP_MZOMBIE);
	else if (sel == CB_SHALR)			return(IMP_MSHALR);
	else if (sel == CB_SCRAG)			return(IMP_MWIZARD);
	else if (sel == CB_HKNIGHT)		return(IMP_MHKNIGHT);
	else if (sel == CB_SHAMBL)			return(IMP_MSHAMBLR);
	else if (sel == CB_DEMON)			return(IMP_MDEMON);
	else if (sel == CB_OGRE)			return(IMP_MOGRE);
	else if (sel == CB_CTHON)			return(IMP_MCTHON);
	else if (sel == CB_SCOURGE)		return(IMP_MSCOURGE);
	else if (sel == CB_GREMLIN)		return(IMP_MGREMLIN);
	else if (sel == CB_ENF)				return(IMP_MENF);
//Hellion:
	else if (sel == CB_IMP)				return(IMP_MIMP);
	else if (sel == CB_CYBER)			return(IMP_MCYBER);
	else if (sel == CB_ARACHN)			return(IMP_MARACHN);
//anode:
	else if (sel == CB_ANODEX)			return(IMP_MANODEX);

	return 0; // failed - IMP_* &| CB_* not recognized
};



// fn(polymorph_id) - tell player which morph state is selected
// p1 - client entity
// sel - valid class number
// fp - print this leadin, followed by state description - leaves unterminated (no "\n")
// exit - returns impulse to select this state

string(entity p1, float sel, string fp) polymorph_id =
{
	local string s1,s2;

	if (sel == IMP_MCHAOS)				{s1 = "Chaos icarnate.";				s2 = STI_MCHAOS;}
	if (sel == IMP_MORDER)				{s1 = "order icarnate.";				s2 = STI_MORDER;}
//Techs:
//	else if (sel == IMP_MHUMAN)		{s1 = "a lowly Cook.";					s2 = STI_MHUMAN;}
//	else if (sel == IMP_MDEMO)			{s1 = "a mad Bomber.";					s2 = STI_MDEMO;}
//	else if (sel == IMP_MSPECIAL)		{s1 = "a trained Specialist.";		s2 = STI_MSPECIAL;}
//	else if (sel == IMP_MTECH)			{s1 = "a crafty Technician.";			s2 = STI_MTECH;}
//	else if (sel == IMP_MENG)			{s1 = "a brilliant Engineer.";		s2 = STI_MENG;}
//Medieval:
//	else if (sel == IMP_MWRAITH)		{s1 = "a silent Wraith.";				s2 = STI_MWRAITH;}
//	else if (sel == IMP_MTHAM)			{s1 = "a conjuring Thamaturge."; 	s2 = STI_MTHAM;}
//	else if (sel == IMP_MDRAGON)		{s1 = "a savage Draconis.";			s2 = STI_MDRAGON;}
//	else if (sel == IMP_MTHIEF)		{s1 = "a stealthy Thief.";				s2 = STI_MTHIEF;}
//Beastie:
	else if (sel == IMP_MZOMBIE)		{s1 = "a rotting zombie.";				s2 = STI_MZOMBIE;}
	else if (sel == IMP_MSHALR)		{s1 = "a spellbinding Shalrath.";	s2 = STI_MSHALR;}
	else if (sel == IMP_MWIZARD)		{s1 = "a stalking Scrag.";				s2 = STI_MSCRAG;}
	else if (sel == IMP_MHKNIGHT)		{s1 = "a wicked Hell Knight.";		s2 = STI_MHKNIGHT;}
	else if (sel == IMP_MSHAMBLR)		{s1 = "a massive Shambler.";			s2 = STI_MSHAMBLR;}
	else if (sel == IMP_MDEMON)		{s1 = "a degenerate Fiend.";			s2 = STI_MDEMON;}
	else if (sel == IMP_MOGRE)			{s1 = "a skulking Ogre.";				s2 = STI_MOGRE;}
	else if (sel == IMP_MCTHON)		{s1 = "a Lava Bomb.";					s2 = STI_MCTHON;}
	else if (sel == IMP_MSCOURGE)		{s1 = "a hissing Scourge.";			s2 = STI_MSCOURGE;}
	else if (sel == IMP_MGREMLIN)		{s1 = "a nasty Gremlin.";				s2 = STI_MGREMLIN;}
	else if (sel == IMP_MENF)			{s1 = "a chief Enforcer.";				s2 = STI_MENF;}
//Doomer
	else if (sel == IMP_MIMP)			{s1 = "a Imp.";							s2 = STI_MIMP;}
	else if (sel == IMP_MCYBER)		{s1 = "a Cyberdemon.";					s2 = STI_MCYBER;}
	else if (sel == IMP_MARACHN)		{s1 = "a Arachnotron.";					s2 = STI_MARACHN;}
//Stroggos
	else if (sel == IMP_MGUNNEY)		{s1 = "a Gunner.";						s2 = STI_MGUNNEY;}
	else if (sel == IMP_MTANK)			{s1 = "a Tank.";							s2 = STI_MTANK;}
	else if (sel == IMP_MSUPTANK)		{s1 = "a SUPER Tank.";					s2 = STI_MSUPTANK;}

	sprint(p1,fp);
	sprint(p1,s1);
	return s2;
};

/*
		+---------------------------------------+
		|  select section                       | SEC-HEAD
		+---------------------------------------+
*/

// handle morph selection impulses

// loop value at ends
float(float v) morph_selinc =
{
	local float f;

	f = 0;
	if (v < 1) f = 8388608;
	if (v > 8388608) f = 1;

	if (f) return(f);
	return(v);
};

void() morphic_impulse =
{
	local float dx, done, f, sv;
	local entity c;

	c = self.eweapon;

	done = FALSE;
	if (self.impulse >= 1 && self.impulse <= 9) done = 2; // exit stratagem
	if (!c) done = 1;
	else if (c.wad != "morph_cube") done = 1;

	if (done)
	{
		if (c)
		if (c.wad == "morph_cube")
		{
			c.owner = world;
			c.touch = painkeep_touch;
			centerprint(self, "The cube is free...");
		}
		if (done == 1) self.impulse = 0;
		cube_rearm(); // re arm player
		return;
	}

	dx = 1; // incase by some weird chance we have no valid impulse
	if (self.impulse == 10) dx = 2;
	else if (self.impulse == 12) dx = 0.5;

	c.lefty = c.lefty * dx;
	c.lefty = morph_selinc(c.lefty);

	sv = 30; // only 24 bits to test in one float
	f = 0;
	while (!f && sv > 0)
	{
		f = c.mask_x & c.lefty;
		if (!f) c.lefty = c.lefty * dx;
		c.lefty = morph_selinc(c.lefty);
		sv = sv - 1;
	}
	if (!f)
	{
		if (WARNING) bprint("*** Warning - morphic cube with no selection options! - removed\n");
		done = TRUE;
	}
	else
	{
		dx = cb_morph(f);
		if (dx)
		{
			self.state = dx;
			c.count = dx; // save in case we have fail
		}
		else self.state = c.count;
		morph_print(self);
	}

	if (done)
	{
		remove(c);
		cube_rearm(); // re arm player
	}

	self.impulse = 0;
};

 // morphic method 1 - the cube

// NOTE: alt fire must be done somewhere

void() morph_cube_use = 
{
	local entity c, sv;

	sv = self;
	c = self.eweapon;

	if (c.wad != "morph_cube")
	{
		self.button0 = 0;
		self.weapon = W_BestWeapon();
		self.pk_currentitem = W_BestPKWeapon();
		self.eweapon = vchk(self.weapon, self.pk_currentitem, self.vwepent);
		W_SetCurrentAmmo();
		if (WARNING)	bprint("*** WARNING - in cube use and dont have a cube!\n");
		return;
	}

	if (!self.state) return; // no selection made yet
	if (self.state == self.morphy) // cant select same thing
	{
		self.eweapon.owner = world;
		self.eweapon.touch = painkeep_touch;
		centerprint(self, "The cube is free...");
		cube_rearm(); // re arm player
		return;
	}
	if (self.state == IMP_MSCOURGE) // TEST: only one so far
// evolve here

	self.eweapon = world; // thrown pack have cube in them! - NOTE: prevents packs from getting xweap

	polymorph_check(self.state, 0);

	remove(c);
	self.impulse = 0;
	cube_rearm(); // re arm player
};

void() morph_cube =
{
	local float r;

	r = rint(random() * 6);
	if (!r)
	{
		if (time > 240) self.mask_x = MORPH_ARCHON;
		else r = r + 1;
	}
	if (r < 3) self.mask_x = MORPH_STROG;
	else if (r == 3) self.mask_x = MORPH_HELLION;
	else self.mask_x = MORPH_MONSTER;


// TEST:
self.mask_x = MORPH_MONSTER;


	setmodel(self, "progs/morph_cube.bsp");
	self.netname = "Morphic Cube";
	self.touch = painkeep_touch;
	self.pk_touch = cube_touch;
	self.noise = "items/r_item2.wav";
	self._attack = morph_cube_use; // fire button to use
	self._fr_attack = SUB_Null; // fire button to use
	self.attack_finished = 3;

	self.punchangle = ' 210 210 240'; // for ejector
//	item_eject(self, ' 210 210 240'); // done by pk_place_item with punchangle set

	setsize (self,'-16 -16 0','16 16 32');
	StartItem ();
};



/*
		+---------------------------------------+
		|  audio section                        | SEC-HEAD
		+---------------------------------------+
*/

// morph sound code

// NOTE - only turns off voice!

void() morph_sound_off =
{
	sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
	self.soundoff = MAXFL; // dont fire again until its time
};

// fn(morph_sound) - play sound for morph, does lock, can handle null sound, random play
// settings -
// r1 - random() < this value to play
// sn - sound file, will not play if null
// lts - lock time, will not play a sound again for this many seconds

void(float r1, string sn, float lts ) morph_sound =
{
	if (time < self.soundlock) return; // dont play these too much
	if (intermission_running) return morph_sound_off();
	if (sn != "") {
		if (random() < r1)
			{
			sound (self, CHAN_VOICE, sn, 0.8, ATTN_NORM);
			self.soundlock = time + lts;
			self.soundoff = time + 2; // FIX - check to make sure all idle & sight < 2 secs
			}}
};

void(string ws, float rtime ) morph_walksound =
{
	float fgr;

	fgr = self.flags & FL_ONGROUND;
//	if (self.morphy == IMP_MGREMLIN && self._stand == gremlin_hover) fgr = TRUE;

	if (WALKSOUND && ((self.cnt < time) || !fgr))
		{
		sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
// supertank hack - need a better method - ignore flag or some such
		if ( (!fgr && !(self.morphy == IMP_MSUPTANK) ) || intermission_running)
			return;
		else
			{
			sound (self, CHAN_BODY, ws, 0.6, ATTN_NORM);
			self.cnt = time + rtime;
			}
		}
};



// fn(morph_test) - test multiple morph nums, return true for any match-

float(entity etest, float m1,float m2,float m3,float m4,float m5,float m6) morph_test =
{
if (etest.morphy == m1 && m1) return TRUE;
if (etest.morphy == m2 && m2) return TRUE;
if (etest.morphy == m3 && m3) return TRUE;
if (etest.morphy == m4 && m4) return TRUE;
if (etest.morphy == m5 && m5) return TRUE;
if (etest.morphy == m6 && m6) return TRUE;
};

// fn(morph_ffchk) - see if morph matches morph / monster under fire conditions

// return true if attack does no damage (team attack deal - assumes like morphs / monsters on same team)
// return false if attack does damage

// issues - makes less sense with ogre's grenade - that ought to hurt other ogres

// atk - attacker ent
// trg - target ent

float(entity atk, entity trg) morph_ffchk =
{
	local float l;
	local entity mon, oth;

	l = FALSE;
	if (MORPH_FF || Q_100) return(l); // TDO: sv_
	if ((trg.flags & FL_CLIENT) && (atk.flags & FL_CLIENT)) return(trg.morphy == atk.morphy);
	if ((trg.flags & FL_MONSTER) | (atk.flags & FL_CLIENT)) 
	{
		l = TRUE;
		mon = trg;
		oth = atk;
	}
	if ((trg.flags & FL_CLIENT) | (atk.flags & FL_MONSTER))
	{
		l = TRUE;
		mon = atk;
		oth = trg;
	}
	if (l == FALSE) return(l);

//	if (mon.classname == "monster_army") 
	if (mon.classname == "monster_demon1") return(oth.morphy == IMP_MDEMON);
//	else if (mon.classname == "monster_dog"
	else if (mon.classname == "monster_dragon") return(oth.morphy == IMP_MDRACON);
	else if (mon.classname == "monster_enforcer") return(oth.morphy == IMP_MENF);
//	else if (mon.classname == "monster_fish"
	else if (mon.classname == "monster_hell_knight") return(oth.morphy == IMP_MHKNIGHT);
	else if (mon.classname == "monster_knight") return(oth.morphy == IMP_MHKNIGHT);
	else if (mon.classname == "monster_ogre") return(oth.morphy == IMP_MOGRE);
//	else if (mon.classname == "monster_oldone"
	else if (mon.classname == "monster_shalrath") return(oth.morphy == IMP_MSHALR);
	else if (mon.classname == "monster_shambler") return(oth.morphy == IMP_MSHAMBLR);
	else if (mon.classname == "monster_tarbaby") return(oth.morphy == IMP_MCTHON);
//	else if (mon.classname == "monster_vomit"
	else if (mon.classname == "monster_wizard") return(oth.morphy == IMP_MWIZARD);
	else if (mon.classname == "monster_zombie") return(oth.morphy == IMP_MZOMBIE);
	else if (mon.classname == "monster_scourge") return(oth.morphy == IMP_MSCOURGE);
	else if (mon.classname == "monster_imp") return(oth.morphy == IMP_MIMP || oth.morphy == IMP_MARACHN);
	else if (mon.classname == "monster_cyberdemon") return(oth.morphy == IMP_MCYBER);
	else if (mon.classname == "monster_arachnotron") return(oth.morphy == IMP_MIMP || oth.morphy == IMP_MARACHN);
	else if (mon.classname == "monster_gremlin") return(oth.morphy == IMP_MGREMLIN);
	else if (mon.classname == "monster_scourge") return(oth.morphy == IMP_MSCOURGE);
	else if (mon.classname == "monster_gunner") return(oth.morphy == IMP_MGUNNEY || oth.morphy == IMP_MTANK || oth.morphy == IMP_MSUPTANK);
	else if (mon.classname == "monster_tank") return(oth.morphy == IMP_MGUNNEY || oth.morphy == IMP_MTANK || oth.morphy == IMP_MSUPTANK);
	else if (mon.classname == "monster_boss1" /* && self.model == "progs/q2_supertank.mdl" */) return(oth.morphy == IMP_MGUNNEY || oth.morphy == IMP_MTANK || oth.morphy == IMP_MSUPTANK);
	return(FALSE);
};

// fn(morph_clichk) - single player - see if monster will not question and attack unknown morph, return true if its so
// - i.e. an ogre would not question presence of an unfamiliar ogre, hell knight, shalrath, scourge or shambler. it might attack gremlin, scragg, chaos, demon, enforcer, zombie, or other morphs
//
// self - monster entity making check
// chk - player ent
// in general lesser monsters will obey typical minion leaders unless unruly
/*
maybe this should be based on a D&D type tolerance table?

IMP_MENF		- former human leader
IMP_MZOMBIE
IMP_MSHALR	- monster leader, above hknights
IMP_MWIZARD
IMP_MHKNIGHT  monster leader
IMP_MSHAMBLR  all monsters are "smart" enough...and shamblers are only friends with other shamblers,
				  small buildings and semi trucks, just because they are "slightly" bigger
IMP_MDEMON
IMP_MOGRE
IMP_MSCOURGE
*/

float(entity chk) morph_clichk =
{
if (self.classname == "monster_army") return morph_test(chk,IMP_MENF,IMP_MOGRE,IMP_MZOMBIE,0,0,0); // he's kinda dumb...and a dork
else if (self.classname == "monster_ogre") return morph_test(chk,IMP_MOGRE,IMP_MHKNIGHT,IMP_MSHALR,IMP_MSCOURGE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_knight") return morph_test(chk,IMP_MHKNIGHT,IMP_MSHALR,IMP_MOGRE,0,0,IMP_MSHAMBLR);
else if (self.classname == "monster_shambler") return morph_test(chk,IMP_MSHAMBLR,IMP_MGREMLIN,0,0,0,0);
else if (self.classname == "monster_demon1") return morph_test(chk,IMP_MDEMON,IMP_MGREMLIN,0,0,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_wizard") return morph_test(chk,IMP_MWIZARD,IMP_MHKNIGHT,IMP_MSHALR,IMP_MDEMON,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_zombie") return morph_test(chk,IMP_MZOMBIE,0,0,0,0,0); // zombies get no respect, they are just loathed
else if (self.classname == "monster_dog") return morph_test(chk,IMP_MOGRE,IMP_MENF,0,0,IMP_MDEMON,IMP_MSHAMBLR);
else if (self.classname == "monster_hell_knight") return morph_test(chk,IMP_MHKNIGHT,IMP_MSHALR,IMP_MOGRE,IMP_MSCOURGE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_tarbaby") return morph_test(chk,IMP_MHKNIGHT,IMP_MSHALR,IMP_MWIZARD,IMP_MGREMLIN,IMP_MCTHON,IMP_MSHAMBLR);
else if (self.classname == "monster_boss") return morph_test(chk,IMP_MCTHON,0,0,0,0,0); // cthon likes lava
//else if (self.classname == "monster_vomit") return morph_test(chk,0,0,0,0,0,IMP_MSHAMBLR);
else if (self.classname == "monster_enforcer") return morph_test(chk,IMP_MENF,IMP_MHKNIGHT,IMP_MOGRE,IMP_MSCOURGE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_shalrath") return  morph_test(chk,IMP_MOGRE,IMP_MSHALR,IMP_MGREMLIN,IMP_MDEMON,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_scourge") return morph_test(chk,IMP_MSCOURGE,IMP_MGREMLIN,0,0,0,IMP_MSHAMBLR);
else if (self.classname == "monster_gremlin") return morph_test(chk,IMP_MSCOURGE,IMP_MGREMLIN,IMP_MDEMON,IMP_MOGRE,0,IMP_MSHAMBLR);
// doom monsters - only friendly with doom dimension biengs
else if (self.classname == "monster_imp") return morph_test(chk,IMP_MIMP,IMP_MARACHN,IMP_MCYBER,0,0,0);
else if (self.classname == "monster_arachnotron") return morph_test(chk,IMP_MIMP,IMP_MARACHN,IMP_MCYBER,0,0,0);
else if (self.classname == "monster_cyberdemon") return morph_test(chk,IMP_MIMP,IMP_MARACHN,IMP_MCYBER,0,0,0);
// stroggos - only like the strog
else if (self.classname == "monster_gunner") return morph_test(chk,IMP_MGUNNEY,IMP_MTANK,IMP_MSUPTANK,0,0,0);
else if (self.classname == "monster_tank") return morph_test(chk,IMP_MGUNNEY,IMP_MTANK,IMP_MSUPTANK,0,0,0);
else if (self.classname == "monster_boss1" /* && self.model == "progs/q2_supertank.mdl" */ ) return morph_test(chk,IMP_MGUNNEY,IMP_MTANK,IMP_MSUPTANK,0,0,0);
return morph_test(chk,IMP_MSCOURGE,0,0,0,0,IMP_MSHAMBLR); // no classname
};


// fn(morph_clearparms) - clear out new inventory system for respawn
// f - ent to clear
// all - clear everything, otherwise just clear morph stuff

void(entity f, float all) morph_clearparms =
{
	f.mask = v0;
	f.noise1 = f.noise2 = f.noise3 = f.noise4 = f.msight = "";

	f.weaponframe = 0;
	f.weaponmodel = "";

// Cataboligne - 9.15.11 - moved from chasecam
	if (all) // morph change will retain these
	{
		f.flags = FL_CLIENT | FL_ONGROUND | FL_JUMPRELEASED; // default, need to clear drop pull & such
		f.invincible_time = f.super_damage_finished = f.radsuit_finished = f.invisible_finished = f.invincible_finished = 0;
		f.effects = 0;
	}

	f.skin = f.items = f.builtin = 0;
// f.frame = 0;
//		f.items = f.items - (f.items & (IT_QUAD | IT_SUIT | IT_INVISIBILITY | IT_INVULNERABILITY));
	f.weapon = f.currentammo = f.ammo_shells = f.ammo_nails = f.ammo_rockets = f.ammo_cells = 0;
	f.eweapon = world;
	f.pkprevweapon = f.pklastweapon = f.prevweapon = f.lastweapon = 0;
// remove pk items & ammos
	f.pkplus_egoammo = f.pkplus_tombammo = f.pkplus_actorammo = f.pkplus_phoneammo = 0;
	f.pk_gravitywellammo = f.pk_turretammo = f.pk_canpabammo = f.pk_beartrapammo = f.pk_explode_ammo = 0;
// remove x items & ammos
	f.ammo_bullet = f.ammo_slug = f.ammo_gaspr = f.ammo_hgrenade = 0;
	f.x_items = x_item_dm_giveaway;
};

// fn(morph_impulse) - generic morph impulse testing

void() morph_impulse =
{
	if (self.impulse == 10)
		CycleWeaponCommand ();
	else if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	else if (self.impulse == IMP_MSIGHT)
	{
		if (self.msight == "gremlinsight") // ugh - hack, need a callback here or something
			morph_sound(2, rnd_string( ' 50 25 12', "gremlin/sight1.wav","gremlin/idle3.wav","gremlin/sight4.wav","gremlin/sight3.wav","gremlin/sight2.wav"), 3);
		else
			morph_sound(2, self.msight, 3);							// let player morphs "talk"
		if (self._summon != SUB_Null) self._summon();		// attempt summon - TEST: ing
	}
	if (self.impulse == IMP_MFLY)
	{
		flyer_mode(self);
	}
/*
	if (cmd == IMP_MFIREM)
		{
		if (self._hk_major) if (self._hk_major != SUB_Null) self._hk_major(); // missile attack
		}
	else if (cmd == IMP_MFIREL)
		{
		if (self._hk_lesser) if (self._hk_lesser != SUB_Null) self._hk_lesser(); // melee attack
		}
	else if (cmd == IMP_MSELECT) polymorph_select(1);		// select a morph - need perm. checking

	else 
*/
};

// fn(polymorph_check) - do a change by code or impulse, handles other morph impulse commands
// self - entity to morph, note code requirements below for some values
// cmd - instruction for morphing
// pls - player silent - code for quiet mode on level chg, & respawn

// polymorph other - set self to correct player after impulse call from spell caster
// check morph allow bits prior to switch

// TEST:ING
void(float silent) player_human_become = 
{
};

void(float cmd, float pls) polymorph_check =
{
	if (!cb_morph(cmd)) return; // ha ha, validation

	if (cb_morph(cmd))	// these are polymorph commands
	{
		if (!pls) // if pls is set its a spawn (level load) | respawn incarnation
		{
			if (self.morphy == cmd) return; // nothing to do - NOTE: WARNING: if an eweapon fires this off, it must be cleared after this
	// changing states & not starting level - validated in weapons.qc -- impulse commands 
	/*
			if (IS_CHAOS(self))
			{
				if (self.aflag & 16) return; // no change during star bursts
				if (cmd == self.state) // returning to native form
				{
					if (chaos_poly)
					{
						remove(chaos_poly);
						chaos_poly = world;
					}
				}
				else if (!chaos_poly) // going to another form - set random return code
				{
					chaos_poly = chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "chaos_morph", "", SUB_Null, cmd + (crandom() * 150.0), chaos_morph_chgthk, SUB_Null, self, world);
				}
			}
	*/
			viswep_ld(self, -1); // unloads weps - NOTE: threw option
			if (self.mask_x & (CB_HUMAN | CB_ENF | CB_OGRE | CB_GREMLIN))
				DropBackpack();
	//		morph_armor_check();
	//		morph_powerup_check(cmd);
			morph_clearparms(self, FALSE);
		}

		self.morphy = cmd;

		self.mask_x = cb_morph(cmd);

		self.alpha = 1;				// clear any prev state set - i.e. chaos
		self.skin = 0;
		if (WALKSOUND) sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
		morph_sound_off();
//		self.eweapon = world;
		self._summon = SUB_Null;

	//	if (cmd == IMP_MCHAOS) player_chaos_become(pls);
		if (cmd == IMP_MSCOURGE) player_scourge_become(pls);
		else if (cmd == IMP_MSHALR) player_shalrath_become(pls);
		else if (cmd == IMP_MANODEX) player_anode_become(pls);
		else player_human_become(pls);
	/*	else if (cmd == IMP_MZOMBIE) player_zombie_become(pls);
		else if (cmd == IMP_MSHALR) player_shalrath_become(pls);
		else if (cmd == IMP_MWIZARD) player_wizard_become(pls);
		else if (cmd == IMP_MHKNIGHT) player_hknight_become(pls);
		else if (cmd == IMP_MSHAMBLR) player_shambler_become(pls);
		else if (cmd == IMP_MDEMON) player_demon_become(pls);
		else if (cmd == IMP_MOGRE) player_ogre_become(pls);
		else if (cmd == IMP_MCTHON) player_lavablob_become(pls);
		else if (cmd == IMP_MSCOURGE) player_scourge_become(pls);
		else if (cmd == IMP_MGREMLIN) player_gremlin_become(pls);
		else if (cmd == IMP_MENF) player_enforcer_become(pls);
		else if (cmd == IMP_MIMP) player_imp_become(pls);
		else if (cmd == IMP_MCYBER) player_cyber_become(pls);
		else if (cmd == IMP_MARACHN) player_arachn_become(pls);
		else if (cmd == IMP_MGUNNEY) player_gunney_become(pls);
		else if (cmd == IMP_MTANK) player_tank_become(pls);
		else if (cmd == IMP_MSUPTANK) player_supertank_become(pls);
		else if (cmd == IMP_MWRAITH) player_wraith_become(pls);
		else player_human_become(pls);
	*/
		self.modelindex_morph = self.modelindex;

		self.eweapon = vchk(self.weapon, self.pk_currentitem, self.vwepent); // TDO: default could load eweap for morph - it needs consolted if morphs ever get ews
	
		if (cmd == IMP_MCHAOS || cmd == IMP_MWIZARD || cmd == IMP_MWRAITH)
		{
			flyer_check(self, TRUE);
			if (cmd == IMP_MWRAITH && !self.deadflag && !WRAITH_USE_CAM) self.cam_x = self.cam_x - (self.cam_x & CHSCAM_ON);
		}
		else
			flyer_check(self, FALSE);

//	if (cmd != IMP_MWIZARD && cmd != IMP_MCHAOS && cmd != IMP_MWRAITH) self.movetype = MOVETYPE_WALK; // only spawned flyers
	}
};

// fn (morph_die) - morph creature dies - put it out of misery but leave a pretty corpse or gibblets
// common morph death stuff

// self must be dying ent

// I know you, but you cant be you, we put you through the window, this is the really real world, there aint no comin' back! WHAT?!

void() morph_die =
{
	if (sphere_a.owner == self) sphere_a.owner = world; // owner died, sphere free
	stuffcmd(self, "scr_zoomwindow 0\n");
	morph_sound_off();
	self.alpha = 1; // clear prev state

	if (WALKSOUND) sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);

// from player
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.view_ofs = '0 0 -8';
};
