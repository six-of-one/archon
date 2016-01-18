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
	MORPH_MONSTER = CB_DEMON + CB_ENF + CB_HKNIGHT + CB_OGRE + CB_SHALR + CB_SHAMBL + CB_SCRAG + CB_ZOMBY + CB_CTHON + CB_GREMLIN + CB_SCOURGE;
//	MORPH_CASTLE = + ;
	MORPH_HELLION = CB_IMP + CB_ARACHN + CB_CYBER;
	MORPH_STROG = CB_GUNNEY + CB_TANK + CB_SUPTANK;
//	MORPH_ARENA = + ;
	MORPH_ANCIENT = CB_DRAGON; // + CB_WRAITH;

	MORPH_ALL = MORPH_ARCHON + MORPH_MONSTER + MORPH_HELLION + MORPH_STROG + MORPH_ANCIENT + CB_HUMAN;

// these morph fly nativley
	MORPH_FLY = CB_CHAOS + CB_ORDER + CB_SCRAG + CB_WRAITH + CB_DRAGON + CB_GREMLIN;
// these morphs can always hook
	MORPH_HOOK = CB_CHAOS + CB_CTHON + CB_ZOMBY + CB_SCOURGE; // + CB_GREMLIN;
	MORPH_SARMOR = CB_SCOURGE + CB_GREMLIN + CB_IMP;

	MONSTER_MASK = CB_M_ARMY + CB_M_FISH + CB_M_KNIGHT + CB_M_DOG + CB_M_DEMON + CB_M_ENF + CB_M_HKNIGHT + CB_M_OGRE + CB_M_SHALR + CB_M_SHAMBL + CB_M_SCRAG + CB_M_ZOMBY + 
						CB_M_CTHON + CB_M_TARBABY + CB_M_SCOURGE + CB_M_SHUBS + CB_M_SVORE + CB_M_GREMLIN + CB_M_VOMIT;

	MONSTER_MASK_II = CB_M_BLARG + CB_M_RAPTOR + CB_M_SPIDER + CB_M_MANGA + CB_M_BOSSMAN;

// note - no fish, shubs or cthon
	MONSTER_Q1 = CB_M_ARMY + CB_M_KNIGHT + CB_M_DOG + CB_M_DEMON + CB_M_ENF + CB_M_HKNIGHT + CB_M_OGRE + CB_M_SHALR + CB_M_SHAMBL + CB_M_SCRAG + CB_M_ZOMBY + 
						CB_M_TARBABY;

};



void() morph_precache =
{
	m_precache_scourge();
	m_precache_enforcer();
	m_precache_shalrath();
	m_precache_demon();
	m_precache_zombie();
	m_precache_hknight();
	m_precache_wizard();
	m_precache_shambler();
	m_precache_lavablob();
	m_precache_gremlin();
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
	else if (sel == IMP_MGREMLIN_F)	return(CB_GREMLIN);
	else if (sel == IMP_MGREMLIN_L)	return(CB_GREMLIN);
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
	else if (sel == CB_GREMLIN)		return(IMP_MGREMLIN_F);
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
	else if (sel == IMP_MGREMLIN_F)	{s1 = "a nasty Gremlin.";				s2 = STI_MGREMLIN;}
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

// id monsters from bit flag - for admin

string(float mb, float mode) monster_id =
{
	local string s2;

	s2 = "";

	if (mode == MON_NAME_REG)
	{
		if (mb == CB_M_ARMY) 			s2 = "Army Grunt";
		if (mb == CB_M_FISH) 			s2 = "Fish";
		if (mb == CB_M_KNIGHT) 			s2 = "Knight";
		if (mb == CB_M_DOG) 				s2 = "Rabid Dog";
		if (mb == CB_M_DEMON) 			s2 = "Fiend";
		if (mb == CB_M_ENF) 				s2 = "Enforcer";
		if (mb == CB_M_HKNIGHT) 		s2 = "Hell Knight";
		if (mb == CB_M_OGRE) 			s2 = "Ogre";
		if (mb == CB_M_SHALR) 			s2 = "Shalrath";
		if (mb == CB_M_SHAMBL) 			s2 = "Shambler";
		if (mb == CB_M_SCRAG) 			s2 = "Scragg";
		if (mb == CB_M_ZOMBY) 			s2 = "Zomby";
		if (mb == CB_M_CTHON) 			s2 = "Cthon";
		if (mb == CB_M_TARBABY) 		s2 = "Spawn";
		if (mb == CB_M_SCOURGE) 		s2 = "Scourge";
		if (mb == CB_M_SHUBS) 			s2 = "Shub Niggurath";
		if (mb == CB_M_SVORE) 			s2 = "Vorerel";
		if (mb == CB_M_GREMLIN) 		s2 = "Gremlin";
		if (mb == CB_M_VOMIT) 			s2 = "Vomitus";
	}
	else
	if (mode == MON_FUNC_REG)
	{
		if (mb == CB_M_ARMY) 			s2 = "monster_army";
		if (mb == CB_M_FISH) 			s2 = "monster_fish";
		if (mb == CB_M_KNIGHT) 			s2 = "monster_knight";
		if (mb == CB_M_DOG) 				s2 = "monster_dog";
		if (mb == CB_M_DEMON) 			s2 = "monster_demon1";
		if (mb == CB_M_ENF) 				s2 = "monster_enforcer";
		if (mb == CB_M_HKNIGHT) 		s2 = "monster_hell_knight";
		if (mb == CB_M_OGRE) 			s2 = "monster_ogre";
		if (mb == CB_M_SHALR) 			s2 = "monster_shalrath";
		if (mb == CB_M_SHAMBL) 			s2 = "monster_shambler";
		if (mb == CB_M_SCRAG) 			s2 = "monster_wizard";
		if (mb == CB_M_ZOMBY) 			s2 = "monster_zombie";
		if (mb == CB_M_CTHON) 			s2 = "monster_boss";
		if (mb == CB_M_TARBABY) 		s2 = "monster_tarbaby";
		if (mb == CB_M_SCOURGE) 		s2 = "monster_scourge";
		if (mb == CB_M_SHUBS) 			s2 = "monster_oldone";
		if (mb == CB_M_SVORE) 			s2 = "monster_supervore";
		if (mb == CB_M_GREMLIN) 		s2 = "monster_gremlin";
		if (mb == CB_M_VOMIT) 			s2 = "monster_vomit";
	}
	else
	if (mode == MON_NAME_II)
	{
		if (mb == CB_M_BLARG) 			s2 = "Blarg";
		if (mb == CB_M_RAPTOR) 			s2 = "Velociraptor";
		if (mb == CB_M_SPIDER) 			s2 = "Phase Spider";
		if (mb == CB_M_MANGA) 			s2 = "Manga Tai";
		if (mb == CB_M_BOSSMAN) 		s2 = "Like a Boss";
	}
	else
	if (mode == MON_FUNC_II)
	{
		if (mb == CB_M_BLARG) 			s2 = "monster_blarg";
		if (mb == CB_M_RAPTOR) 			s2 = "monster_raptor";
		if (mb == CB_M_SPIDER) 			s2 = "monster_spider";
		if (mb == CB_M_MANGA) 			s2 = "monster_manga";
		if (mb == CB_M_BOSSMAN) 		s2 = "monster_bossman";
	}
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

	self.eweapon = world; // dont put cube ref in pack
	if (self.mask_x & (CB_HUMAN | CB_ENF || CB_GREMLIN)) // only humans throw packs so far
	{
		self.eweapon = self.theowner; // set for throwing pack

		if (!self.prevweapon & self.builtin)
			self.weapon = self.prevweapon;
	}

// evolve here

	if (self.state == IMP_MGREMLIN_F)
	if (random() < 0.65) self.state = IMP_MGREMLIN_L;

	polymorph_check(self.state, 0);

	remove(c);
	self.impulse = 0;
	cube_rearm(); // re arm player
};

/*QUAKED morph_cube  (0 .5 .8) (-16 -16 0) (16 16 32)
--------  CAT  --------

to use as map item - they will respawn
wad = "morph_cube"

nothing - pick a random set from morph_cube list

"mask_x" - morph list bit mask

CB_CHAOS						= 1
CB_ORDER						= 2
//humans
CB_HUMAN						= 4
CB_DEMO						= 8
//medievals
CB_WRAITH					= 16
CB_DRAGON					= 32
// q2
CB_GUNNEY					= 64
CB_SUPTANK					= 128
CB_TANK						= 256

//beasties
CB_DEMON						= 512
CB_ENF						= 1024
CB_HKNIGHT					= 2048
CB_OGRE						= 4096
CB_SHALR						= 8192
CB_SHAMBL					= 16384
CB_SCRAG						= 32768
CB_ZOMBY						= 65536
CB_CTHON						= 131072
CB_GREMLIN					= 262144
CB_SCOURGE					= 524288
// doom
CB_IMP						= 2097152
CB_ARACHN					= 4194304 // mode bits = 4 modes
CB_CYBER						= 8388608

*/

void() morph_cube =
{
	local float r;

	if (!self.mask_x)
	{
		r = rint(random() * 6);
		if (!r)
		{
			if (time > 240) self.mask_x = MORPH_ARCHON;
			else r = r + 1;
		}
		if ((r < 3) && ULOK2) self.mask_x = MORPH_STROG;
		else if ((r == 3) && ULOKD) self.mask_x = MORPH_HELLION;
		else self.mask_x = MORPH_MONSTER;
	}


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
	if (self.morphy == IMP_MGREMLIN_F && self._stand == gremlin_hover) fgr = TRUE;

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


// Cataboligne 9.19.3 - morph chasecam return to FPV correct perspective
// replaces "self.owner.view_ofs_z = 22;" code in chasecam.qc
// with "self.owner.view_ofs_z =  morph_chasecam_fpv();"
// o is owner of chasecam, the player

float(entity o) morph_chasecam_fpv =
{
float ofs;
	ofs = 22;

// safety just in case
	if (o.classname != "player") return(o.view_ofs_z); // some calls are not for players

	if (o.morphy == IMP_MZOMBIE) 				ofs = 20;
	else if (o.morphy == IMP_MCHAOS) 		ofs = 4;
	else if (o.mask_x & CB_GREMLIN) 		ofs = 22;
	else if (o.morphy == IMP_MSHALR) 		ofs = 34;
	else if (o.morphy == IMP_MWIZARD) 		ofs = 28;
	else if (o.morphy == IMP_MHKNIGHT) 		ofs = 34;
	else if (o.morphy == IMP_MSHAMBLR) 		ofs = 54;
	else if (o.morphy == IMP_MDEMON) 		ofs = 12;
	else if (o.morphy == IMP_MOGRE) 			ofs = 34;
	else if (o.morphy == IMP_MCTHON) 
	{
		if (o.model == "progs/cthon.mdl")
														ofs =  120;
		else
														ofs = 4;
	}
	else if (o.morphy == IMP_MSCOURGE) 		ofs = 5;
	else if (o.morphy == IMP_MENF) 			ofs = 24;
	else if (o.morphy == IMP_MCYBER) 		ofs = 56;
	else if (o.morphy == IMP_MIMP) 			ofs = 18;
	else if (o.morphy == IMP_MTANK) 			ofs = 52;
	else if (o.morphy == IMP_MSUPTANK) 		ofs = 54;
	else if (o.morphy == IMP_MGUNNEY) 		ofs = 32;
	else if (o.morphy == IMP_MWRAITH) 		ofs = 1;
	return (ofs);
};


// fn(morph_test) - test multiple morph nums, return true for any match-

float(entity e, float m1,float m2,float m3,float m4,float m5,float m6) morph_test =
{
if (m1)
if ((e.morphy == m1) || (e.mask_x & m1)) return TRUE;
if (m2)
if ((e.morphy == m2) || (e.mask_x & m1)) return TRUE;
if (m3)
if ((e.morphy == m3) || (e.mask_x & m1)) return TRUE;
if (m4)
if ((e.morphy == m4) || (e.mask_x & m1)) return TRUE;
if (m5)
if ((e.morphy == m5) || (e.mask_x & m1)) return TRUE;
if (m6)
if ((e.morphy == m6) || (e.mask_x & m1)) return TRUE;
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
	else if (mon.classname == "monster_supervore") return(oth.morphy == IMP_MSHALR);
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
	else if (mon.classname == "monster_gremlin") return(oth.mask_x & CB_GREMLIN);
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

// not having - fish, oldone

float(entity chk) morph_clichk =
{
if (self.classname == "monster_army") return morph_test(chk,IMP_MENF,IMP_MOGRE,IMP_MZOMBIE,0,0,0); // he's kinda dumb...and a dork
else if (self.classname == "monster_ogre") return morph_test(chk,IMP_MOGRE,IMP_MHKNIGHT,IMP_MSHALR,IMP_MSCOURGE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_knight") return morph_test(chk,IMP_MHKNIGHT,IMP_MSHALR,IMP_MOGRE,0,0,IMP_MSHAMBLR);
else if (self.classname == "monster_shambler") return morph_test(chk,IMP_MSHAMBLR,CB_GREMLIN,0,0,0,0);
else if (self.classname == "monster_demon1") return morph_test(chk,IMP_MDEMON,CB_GREMLIN,0,0,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_wizard") return morph_test(chk,IMP_MWIZARD,IMP_MHKNIGHT,IMP_MSHALR,IMP_MDEMON,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_zombie") return morph_test(chk,IMP_MZOMBIE,0,0,0,0,0); // zombies get no respect, they are just loathed
else if (self.classname == "monster_dog") return morph_test(chk,IMP_MOGRE,IMP_MENF,0,0,IMP_MDEMON,IMP_MSHAMBLR);
else if (self.classname == "monster_hell_knight") return morph_test(chk,IMP_MHKNIGHT,IMP_MSHALR,IMP_MOGRE,IMP_MSCOURGE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_tarbaby") return morph_test(chk,IMP_MHKNIGHT,IMP_MSHALR,IMP_MWIZARD,CB_GREMLIN,IMP_MCTHON,IMP_MSHAMBLR);
else if (self.classname == "monster_boss") return morph_test(chk,IMP_MCTHON,0,0,0,0,0); // cthon likes lava
else if (self.classname == "monster_enforcer") return morph_test(chk,IMP_MENF,IMP_MHKNIGHT,IMP_MOGRE,IMP_MSCOURGE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_supervore") return  morph_test(chk,IMP_MOGRE,IMP_MSHALR,CB_GREMLIN,IMP_MDEMON,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_shalrath") return  morph_test(chk,IMP_MOGRE,IMP_MSHALR,CB_GREMLIN,IMP_MDEMON,IMP_MSCOURGE,IMP_MSHAMBLR);
else if (self.classname == "monster_scourge") return morph_test(chk,IMP_MSCOURGE,CB_GREMLIN,0,0,0,IMP_MSHAMBLR);
else if (self.classname == "monster_gremlin") return morph_test(chk,IMP_MSCOURGE,CB_GREMLIN,IMP_MDEMON,IMP_MOGRE,0,IMP_MSHAMBLR);
else if (self.classname == "monster_vomit") return morph_test(chk,IMP_MSCOURGE,CB_GREMLIN,IMP_MDEMON,IMP_MCTHON,0,IMP_MSHAMBLR);
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

void(entity e, float all) morph_clearparms =
{
	local float f;
	e.mask = v0;
	e.noise1 = e.noise2 = e.noise3 = e.noise4 = e.msight = "";

	e.weaponframe = 0;
	e.weaponmodel = "";

// Cataboligne - 9.15.11 - moved from chasecam
	if (all) // morph change will retain these
	{
		e.flags = FL_CLIENT | FL_ONGROUND | FL_JUMPRELEASED; // default, need to clear drop pull & such
		e.invincible_time = e.super_damage_finished = e.radsuit_finished = e.wetsuit_finished = e.invisible_finished = e.invincible_finished =
		e.empathy_finished = 0;
		e.effects = 0;
		e.group = ""; // for specials
	}

	f = e.items & (IT_QUAD | IT_SUIT | IT_INVISIBILITY | IT_INVULNERABILITY);
	e.skin = e.items = e.builtin = 0;
	if (!all) e.items = f; // maintain powers

// remove items & ammos
	e.weapon = e.currentammo = e.ammo_shells = e.ammo_nails = e.ammo_rockets = e.ammo_cells = 0;
	e.eweapon = world;
	e.pkprevweapon = e.pklastweapon = e.prevweapon = e.lastweapon = 0;
// remove pk items & ammos
	e.pkplus_egoammo = e.pkplus_tombammo = e.pkplus_actorammo = e.pkplus_phoneammo = 0;
	e.pk_gravitywellammo = e.pk_turretammo = e.pk_canpabammo = e.pk_beartrapammo = e.pk_explode_ammo = 0;

// these are not items - just select flags
	e.pk_items = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP
					| PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;

// remove x items & ammos
	e.ammo_bullet = e.ammo_slug = e.ammo_gaspr = e.ammo_hgrenade = 0;
	e.x_items = x_item_dm_giveaway;
};

// fn(morph_CycleWeaponCommand) - cycle builtins for morphs

// dx =  1 - fwd
// dx = -1 - bwd

void(float dx) morph_CycleWeaponCommand =
{
	local float sf;
	sf = 50;
	while (1)
	{
		if (self.weapon == IT_MJOLNIR)
		{
			self.pk_currentitem = PK_IT_AXE;
			if (dx == 1)
			{
				self.weapon = IT_AXE;
				self.pk_currentitem = self.pk_currentInventory;
				PK_SetCurrentAmmo();
			}
			else
				self.weapon = IT_LIGHTNING;
		}
		else if (self.weapon == IT_AXE) // && self.pk_currentitem == self.pk_currentInventory)
		{
			if (dx == 1)
				self.weapon = IT_SHOTGUN;
			else
				self.weapon = IT_MJOLNIR;
			self.pk_currentitem = PK_IT_AXE;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.pk_currentitem = PK_IT_AXE;
			if (dx == 1)
				self.weapon = IT_SUPER_SHOTGUN;
			else
			{
				self.weapon = IT_AXE;
				self.pk_currentitem = self.pk_currentInventory;
				PK_SetCurrentAmmo();
			}
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			if (dx == 1)
				self.weapon = IT_NAILGUN;
			else
				self.weapon = IT_SHOTGUN;
			self.pk_currentitem = PK_IT_AXE;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			if (dx == 1)
				self.weapon = IT_SUPER_NAILGUN;
			else
				self.weapon = IT_SUPER_SHOTGUN;
			self.pk_currentitem = PK_IT_AXE;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			if (dx == 1)
				self.weapon = IT_GRENADE_LAUNCHER;
			else
				self.weapon = IT_NAILGUN;
			self.pk_currentitem = PK_IT_AXE;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			if (dx == 1)
				self.weapon = IT_ROCKET_LAUNCHER;
			else
				self.weapon = IT_SUPER_NAILGUN;
			self.pk_currentitem = PK_IT_AXE;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			if (dx == 1)
				self.weapon = IT_LIGHTNING;
			else
				self.weapon = IT_GRENADE_LAUNCHER;
			self.pk_currentitem = PK_IT_AXE;
		}
		else if (self.weapon == IT_LIGHTNING)
		{
			if (dx == 1)
				self.weapon = IT_MJOLNIR;
			else
				self.weapon = IT_ROCKET_LAUNCHER;
			self.pk_currentitem = PK_IT_AXE;
		}

// fix loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;

		if (CanSelect(self.weapon, self.pk_currentitem))
		{
			W_SetCurrentAmmo();
			return;
		}
	}

};

// fn(morph_impulse) - generic morph impulse testing

void() morph_impulse =
{
	if (self.impulse == 1) // select builtins with normal impulses
	{
		if (self.builtin & IT_AXE) 
		{
			self.weapon = IT_AXE;
			// toggle through all the objects we have.
			pk_cycleObjects();

			if (self.pk_currentitem == PK_IT_AXE)
			{
				self.weaponmodel = "";
			}
			else 
			{
				PK_SetCurrentAmmo();
			}
		}
		else
			if (WARNING)
				bprint("Warning - this morph form has no base weapon - it cannot select painkeep items\n");
	}
	else if ((self.impulse == 2) && (self.builtin & IT_SHOTGUN))
	{
		self.weapon = IT_SHOTGUN;
		self.pk_currentitem = PK_IT_AXE; // so that when morphs impulse select stuff, the pk item recently cycled to will clear and let them fire this wep
	}
	else if ((self.impulse == 3) && (self.builtin & IT_SUPER_SHOTGUN))
	{
		self.weapon = IT_SUPER_SHOTGUN;
	}
	else if ((self.impulse == 4) && (self.builtin & IT_NAILGUN))
	{
		self.weapon = IT_NAILGUN;
	}
	else if ((self.impulse == 5) && (self.builtin & IT_SUPER_NAILGUN))
	{
		self.weapon = IT_SUPER_NAILGUN;
	}
	else if ((self.impulse == 6) && (self.builtin & IT_GRENADE_LAUNCHER))
	{
		self.weapon = IT_GRENADE_LAUNCHER;
	}
	else if ((self.impulse == 7) && (self.builtin & IT_ROCKET_LAUNCHER))
	{
		self.weapon = IT_ROCKET_LAUNCHER;
	}
	else if ((self.impulse == 8) && (self.builtin & IT_LIGHTNING))
	{
		self.weapon = IT_LIGHTNING;
	}

	else if (self.impulse == 10)
		morph_CycleWeaponCommand(1);
	else if (self.impulse == 12)
		morph_CycleWeaponCommand(-1);
	else if (self.impulse == IMP_MSIGHT)
	{
		if (self.msight == "gremlinsight") // ugh - hack, need a callback here or something
			morph_sound(2, rnd_string( ' 50 25 12', "gremlin/sight1.wav","gremlin/idle3.wav","gremlin/sight4.wav","gremlin/sight3.wav","gremlin/sight2.wav"), 3);
		else
			morph_sound(2, self.msight, 3);							// let player morphs "talk"
		if (self._summon != SUB_Null) self._summon();		// attempt summon - TEST: ing
	}

	if (self.weapon != IT_AXE) self.pk_currentitem = PK_IT_AXE;

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

// half morph impulse, half rebular weapons - note: has to have builtin axe - this cant be skipped


void() split_morph_impulse =
{

	if (self.impulse == 1)
	{
		self.eweapon = world; // fixes pk inventory not reporting correctly when selected like this
		self.weaponmodel = "";
		W_ChangeWeapon ();
		self.forcewchange = 0;
	}
	else if (self.impulse >= 3 && self.impulse <= 8)
		W_ChangeWeapon ();
	else if (self.impulse == 9)
		W_ChangeWeapon (); // mjolnir
	else if (self.impulse == 10)
		CycleWeaponCommand ();
	else if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	else
	morph_impulse();

	if (self.weapon != IT_AXE)
	{
		self.pk_currentitem = PK_IT_AXE;
	}
};


// fn(morph_armor_check) - drop armor when morphing

void(float mpy) morph_armor_check =
{
	local entity e;

	if ((self.mask_x & MORPH_SARMOR) || self.armortype == ARM_SCRG) // builtin type armor is not thrown
	{
		if (!(mpy & (MORPH_SARMOR | CB_HKNIGHT))) self.armorvalue = self.armortype = 0; // not going to an armor morph - its gone
		return;
	}

	if (self.armorvalue * self.armortype)
//	if (self.items & (IT_ARMOR1|IT_ARMOR1|IT_ARMOR3)) // dont really care what item it is if any
	{
//		proc_dropitem(code_bit(self.mode_y & (IV_ARM1|IV_ARM2|IV_ARM3),0,1),TRUE);
		e = spawn();
		e.classname = "dyn_item";  // TDO: make this a gen. armor toss fn - use with dead throw too - if d threw weps, do armor
		setorigin(e, self.origin);
		item_call_save(e, "item_armor2");
		e.wad = "armor_toss"; // for get
		e.currentammo = self.armorvalue;
		e.volume = 150; // set max
		if (e.currentammo > e.volume) e.volume = e.currentammo;

		self.armorvalue = self.armortype = 0;
	}
};

// return numeric (morphic) char code for a given map mode
float(string mm) set_char_num =
{
	local float cn;
	
	cn = CHAR_Q;
	if (mm == "W") cn = CHAR_W;
	if (mm == "D") cn = CHAR_D;
	if (mm == "Q") cn = CHAR_Q;
	if (mm == "PK") cn = CHAR_PK;
	if (mm == "Q2") cn = CHAR_Q2;
	if (mm == "Q3") cn = CHAR_Q3;
	return(cn);
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
	self.cam_z = 10 / 100;
	self.cam_y = 30;
	stuffcmd(self, "chase_up 10\n");
	stuffcmd(self, "chase_back 30\n");
	stuffcmd(self, "exec m-human.cfg\n");


	if (self.morphy == CHAR_W) setmodel(self, "progs/plyr_bw.mdl");
	if (self.morphy == CHAR_D) setmodel(self, "progs/plyr_dm.mdl");
	if (self.morphy == CHAR_Q) setmodel(self, "progs/player.mdl");
	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
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


			if (self.mask_x & CB_ENF)
			if (self.ammo_cells < 5) self.ammo_cells = 5;

			if (self.mask_x & CB_OGRE)
			if (self.ammo_rockets < 2) self.ammo_rockets = 2;

			if (self.mask_x & (CB_HUMAN | CB_ENF | CB_OGRE | CB_GREMLIN))
				DropBackpack();
			morph_armor_check(cb_morph(cmd));
	//		morph_powerup_check(cmd);
			morph_clearparms(self, FALSE);
		}

		self.morphy = cmd;

		self.mask_x = cb_morph(cmd);

		self.alpha = 1;				// clear any prev state set - i.e. chaos
		self.skin = 0; // clear damage - note also clear suits
		if (WALKSOUND) sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
		morph_sound_off();
//		self.eweapon = world;
		self._summon = SUB_Null;

//		if (cmd == IMP_MCHAOS) player_chaos_become(pls);
//		else 
			if (cmd == IMP_MZOMBIE) player_zombie_become(pls);
		else if (cmd == IMP_MSHALR) player_shalrath_become(pls);
		else if (cmd == IMP_MWIZARD) player_wizard_become(pls);
		else if (cmd == IMP_MHKNIGHT) player_hknight_become(pls);
		else if (cmd == IMP_MSHAMBLR) player_shambler_become(pls);
		else if (cmd == IMP_MDEMON) player_demon_become(pls);
		else if (cmd == IMP_MOGRE) player_ogre_become(pls);
		else if (cmd == IMP_MCTHON) player_lavablob_become(pls);
		else if (cmd == IMP_MSCOURGE) player_scourge_become(pls);
		else if (cmd == IMP_MENF) player_enforcer_become(pls);
		else if (cmd == IMP_MGREMLIN_F) player_gremlin_become(pls);
		else if (cmd == IMP_MGREMLIN_L) player_gremlin_become(pls);

		else if (cmd == IMP_MANODEX) player_anode_become(pls);
		else player_human_become(pls);
	/*
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



// gib frames in gib_m.mdl - custom is just a variable base
$frame internal slab chunk armlet torso arm leg custom thrchunk thrarm thrleg

// fn(GibMorph) - provide morph state gibbage
// returns true if gib occured
// hd - head model, hf - head frame if needed
// hl - health level to gib
// sz - size, determins gib counts, default 10
string gibsz; // gib array of sizes for each gib frame
// g* - custom gib model
// gf - first gib frame in model
// rd - chance to throw each gib, defaults to 50%
// flg - flags 												 v- size weight
float FL_INTORG				= 1;			// 1 - internal organ
float FL_INTSLAB				= 2;			// 2 - slab of internal meat (orig)
float FL_GIBCHUNK			= 4;			// 1 - chunk of gibblet
float FL_ARMLET				= 8;			// 2 - original amrlet gib
float FL_TORSO				= 16;			// 3 - original torso gib
float FL_ARMGIB				= 32;			// 4 - perquake arm gib
float FL_LEGGIB				= 64;			// 4 - perquake leg gib
float FL_HUMANGIB			= 127;		// use all (gib_m.mdl) gibs
float FL_HUMANORG			= 26;			// original quake gibs (gib1 - gib3 mdl), size wt = 9
float FL_ONLYHUMGIB			= 120;		// use only (human appearing) gibs
float FL_NONHUMGIB			= 7;			// use no (human appearing) gibs
float FL_CUSTOMGIB			= 128;		// 1 - use custom gib (string g1) mdl, frame gf
float FL_CUSTOMGIB2			= 256;		// 2 - use custom gib (string g1) mdl, frame gf+1
float FL_CUSTOMGIB3			= 512;		// 3 - use custom gib (string g1) mdl, frame gf+2
float FL_ALLCUST				= 896;		// all custom frames above
float FL_ANYGIB				= 1023;		// need at least 1 gib flag to throw anything but a head
float FL_HUMANSND			= 1024;		// use all human sounds
float FL_NOHUMSND			= 2048;		// use only generic sounds
float FL_NOSND				= 4096;		// no sounds
float FL_HEADGIB				= 8192;		// 2 - head is set to orig. qc specific parms
float FL_MORPHSND			= 16384;		// use a preset morph sound
float FL_PLAGUE				= 32768;		// make a plague check for gib
float GIB_TWITCH				= 0.5; 		// chance of throwing a gib that twitches

// original GibPlayer
// if ( GibMorph ("progs/h_player.mdl", 0, FL_HEADGIB | FL_HUMANORG, 1, -40, 9, 0, "") ) return;
//GibMorph ("progs/h_shams.mdl", 0, FL_HEADGIB | FL_NONHUMGIB, 0, -60, 30, 0, "")  // shambler
//GibMorph ("progs/h_mega.mdl", 0, FL_HEADGIB | FL_HUMANGIB, 0.5, -45, 12, 0, "") // enforcer
//GibMorph ("progs/h_ogre.mdl", 0, FL_HEADGIB | FL_NONHUMGIB, 0, -80, 18, 0, "")  // ogre


// TDO: unfake this

float (string hd, float hf, float flg, float rd, float hl, float sz, float gf, string g1) GibMorph =
{
	if (self.health <= hl)
	{
		GibPlayer(); // TDO:	
		return(1);
	}
	return(0);
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


// fn(morph_heal) - check the max - 100 rule - high health level morphs get a boost when health is {scale} < MAX
// operation - if morph with > 1.0 health modifier is more than {scaled} < max, health unit value is * health modifier

// ck - entity to check
// hl - health value

// CHECK - balance in play, originally implemented because limited wep morphs were at a disadvantage

float(entity e, float hl) morph_heal =
{
	local float hlb, hmx, hs;

	if (!MAX100) return(0); // global off

	if (e.health_modifier > 1.0)
	{
		hlb = (hl * e.health_modifier) - hl;			// boost - for 25 units, return 50 on a 3.0 mod, because orig fn adds in 25
		hmx = e.max_health * e.health_modifier;	// max health for morph state
		hs = (hmx * MH_HIGH) - (hmx * MH_LOW);					// scalor for health between .5 & .8

		if (e.health < (hmx * MH_LOW))						// health is .5 of MAX or less, full health mod boost
			return(hlb);									
		else if (e.health < (hmx * MH_HIGH))				// health is .8 of MAX to .5 of MAX, scale health boost
			return(hlb * (((hmx * MH_HIGH) - e.health) / hs ) );
	}
	return(0);													// health > .8 of MAX - no boost
};


entity random_monster_spawn;

// need think to wake them up because *monster_start_go has to happen
// NOTE: this does seem to wack monsters that attack player / morph on site (grunts)

void() random_monster_wakey =
{
	local entity f;

	if (self.owner.health < 1) // got killed - likely a monsta_frag --- note: chaos vector
	{
		remove(self);
		return;
	}
		
	if (self.owner.class_select == "class_monster")
	if (self.owner.enemy.classname == "player")
	{
		f = self;
		self.owner.goalentity = self.owner.enemy;
//		self.owner.nextthink = time + 2 + random() * 2;
//		self.owner.think = self.owner.th_walk;
		self = self.owner;
		FoundTarget();
		remove(f);
		return;
	}
//	f = self;
	f =  find_tdest(FL_RSTELE | FL_RSSTART | FL_ITEM, "");
	if (!f) f = findradius(self.owner.origin, PK_DYNRAD);

//	self = self.owner;
//	FoundTarget();
	if (f) // these should be random monsters - when they get here there should be no enemy
//	if((self.owner.enemy == world) || (self.owner.enemy == self))	//If he doesn't have an enemy
	{
		self.owner.goalentity = f;	// target entity f
		self.owner.nextthink = time + 2 + random() * 2;
		self.owner.think = self.owner.th_walk;
	}
	remove(self);
};


void() random_monster =
{
	local vector v;
	local float M;

	C_MONSTER = cvar("sv_monster_rnd");
	C_MONSTER_II = cvar("sv_monster_rnd2");

	C_MONSTER = C_MONSTER - (C_MONSTER & (CB_M_CTHON | CB_M_SHUBS)); // because we really dont want to spawn cthon or shubs without a qualify - maybe pre coded map locations

	if (self.classname != "random_mspawn")
	{
// turned off
		if ((!C_MONSTER)  && (!C_MONSTER_II))
		{
// IDEA: get rid of all random monsters here?
			if (random_monster_spawn)
				remove(random_monster_spawn);
			random_monster_spawn = world;
			return;
		}
		else if (!random_monster_spawn) // turned on
		{
			random_monster_spawn = spawn();
			random_monster_spawn.classname = "random_mspawn";
		}
		if (random_monster_spawn.classname != "random_mspawn")
		{
			remove(random_monster_spawn); // NOTE: this could be removing an important ent, maybe it should be qualified?
			random_monster_spawn = spawn();
			random_monster_spawn.classname = "random_mspawn";
		}
		random_monster_spawn.think = random_monster;
		random_monster_spawn.nextthink = time + C_MONSTER_WAIT * random() + C_MONSTER_DEV * crandom();
		return;
	}

	local float f;
	local entity e,c;
	self.nextthink = time + C_MONSTER_WAIT * random() + C_MONSTER_DEV * crandom();
/*
	if (!C_MONSTER)
	{
		remove(self);
		random_monster_spawn = world;
		return;
	}	*/
	if ((!C_MONSTER) && (!C_MONSTER_II)) return; // whoops - nothing to do - this shouldnt happen...of course

//	f = 100;
	self.cnt = rnd_bit_mask(C_MONSTER);
	self.count = rnd_bit_mask(C_MONSTER_II);
//	if (self.cnt < 1) self.cnt = 1;
//	else self.cnt = self.cnt * 2;
/* this loop was for an incremental search - we do random selection now
	while ( (! self.cnt & C_MONSTER) && (f > 0) )
	{
		self.cnt = self.cnt * 2;
		if (self.cnt > MONSTER_MASK) self.cnt = 1;
		f = f - 1;
	}
	if (f <= 0)
*/
	if ((self.cnt < 1) && (self.count < 1))
	{
		if (WARNING) bprint("*** WARNING - random monster spawn found no bits - check sv_monster_rnd!\n");
		return;
	}

	M = MON_FUNC_REG;
	f = self.cnt;
	if (self.count < 1) self.count = 0;
	if ( (f < 1) && (self.count >= 1) )
	{
		self.cnt = 0;
		f = self.count;
		M = MON_FUNC_II;
	}

	c = self;
	while (f)
	{
		self = spawn();
		self.wad = monster_id(f, M); // get spawn func

		self.classname = "dyn_monster";
		item_call(self.wad);


bprint("spawning: ");
bprint(item_ident(self));
bprint("\n");


		e = dyn_rndloc();
		v = e.origin;
		v_z = v_z + 30 - fabs(e.mins_z); // has to move up enough to account for monsters feet at -24
		setorigin(self, v);
		spawn_tdeath(v, self);
		if ((f >= 1) && (M == MON_FUNC_II)) f = 0;
		if ( (c.cnt >= 1) && random() < C_MONSTER_II_RND)
		{
			c.cnt = 0;
			f = c.count;
			M = MON_FUNC_II;
		}
		else
			f = 0;
	}


	if (WARNING) // dont normally post random monster info
	{
		bprint("*** Random monster spawned: ");
		bprint(self.wad);
		if (e)
		{
			bprint(" near: ");
			bprint(e.classname);
		}
		else
			bprint(" on the map");
		bprint("\n");
	}
};

// TDO: upgrades

// do the respawn
void() monster_respawn_fire =
{
	setorigin(self, self. origin + ' 0 0 8');
	item_call(self.classname); // back to life
	spawn_tfog (self.origin);
	spawn_tdeath(self.origin, self);
};

void() monster_respawn =
{

	if (self.classname != "monster_respawn")
	{
// turned on
		if (!monster_respawner)
		{
			monster_respawner = spawn();
			monster_respawner.classname = "monster_respawn";
		}
		if (monster_respawner.classname != "monster_respawn")
		{
			remove(monster_respawner); // NOTE: this could be removing an important ent, maybe it should be qualified?
			monster_respawner = spawn();
			monster_respawner.classname = "monster_respawn";
		}
		monster_respawner.think = monster_respawn;
		monster_respawner.nextthink = time + S_MONSTER_WAIT * random() +  S_MONSTER_DEV * crandom();
		return;
	}

	local float f;
	local entity e;
	local string mn;
	self.nextthink = time + S_MONSTER_WAIT * random() +  S_MONSTER_DEV * crandom();

	f = 1;
	while ( f < MONSTER_MASK)
	{
		if (f & S_MONSTER) // want to try and respawn these guys
		{
			mn = monster_id(f, MON_FUNC_REG);
			e = find(world, classname, mn);
			while (e)
			{
				if (e.model != "")
				if (e.health <= 0)
				if (e.think != monster_respawn_fire)
				{
					BodyQueAsset(e, world, TRUE); // make a dead body
					e.model = ""; // hide this guy
					e.think = monster_respawn_fire;
					e.nextthink = time + 10 + 20 * random();
				}
				e = find(e, classname, mn);
			}
		}
		f = f * 2;
	}

};



float(entity e) IS_LAVA =
{
	local float f;
	f = FALSE;

	if (e.morphy == IMP_MCTHON) f = TRUE;
	else if (e.morphy == IMP_MCHAOS) f = TRUE;
	else if (e.model == "progs/boss.mdl") f = TRUE;

	return(f);
};

// NOTE: TDO: put back in volcano when added to mod

// fn(fireball_missile) - fire off a fireball (or anything) as a missile, treated as lavaball
// fn(lavaball_shot) - generic call for think, fire_burst
// fn(lavaball_supershot) - generic call for think, fire_burst - makes larger size lava balls

// vel - velocity
// cl - classname
// md - model
// sd - weapon sound
// fr - frame
// flg - added flags

// default melt = 16, default damage = 20
// NOTE: this uses missile ent for sounds

void(float vel, string cl, string md, string sd, float flg) fireball_missile =
{
	fire_missile(vel, MOVETYPE_FLYMISSILE, flg, RM_SKY | FLT_IMM | MLT_LAVA | FLT_LAVA | PF_WATER | PF_SLIME | PF_LAVA | CK_EARTHQUAKE, self.origin, 
					 v0, cl, md, sd, fire_fly_touch, FIRE_FLY_TM + random() * FIRE_FLY_TDEV, meltthink, fire_fly_adj);

	newmis.avelocity = FIREB_MSL_AVEL;
	newmis.dmgtime = time + 0.1;  // clear fields
	if (cl == "fireballwep") newmis.dmgtime = time + 0.07;
	newmis.rad_time = time + 2; // content check timer
	newmis.dmg = FIRE_FLY_DMG; // 20
	newmis.dest_y = 16;
	newmis.class_select = "class_firefly"; // all things made here + fireball weps
	chaos_mdlsize(newmis);
};

void() lavaball_shot =
{
	local string sd;
	local float fl;

	sd = "";
	if (self.flags & FL_MONSTER) { sd = "boss1/throw.wav"; fl = FL_CTHONF; }

	fireball_missile(FIREBALL_WEP_VEL, "fireball", "progs/lavaball.mdl", sd, fl);
//	newmis.grab_callback = grab_lavaball;
};

// put back in chaos morph when added

// fn(chaos_mdlsize) - set sizes for certain models

void(entity e) chaos_mdlsize =
{
	local vector vmin, vmax;
	if (!e) return;

	vmin = vmax = v0;
	if (e.model == "progs/teleport.mdl")			{ vmin = '-16 -16 -16'; vmax = ' 16 16 16'; }
	else if (e.model == "progs/lavaball.mdl" || e.model == "progs/snowball.mdl")
	{
		if (e.frame == 0 || e.frame == 5)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 2 || e.frame == 3 ||
			  e.frame == 7 || e.frame == 8)			{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
		if (e.frame == 4 || e.frame == 9)			{ vmin = '-1 -1 -1'; vmax = ' 1 1 1'; }
	}
	else if (e.model == "progs/grenade.mdl")
	{
		if (e.frame == 0)								{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; } // reg grenade
		if (e.frame == 1 || e.frame == 6)			{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; } // telespheres
		if (e.frame == 2 || e.frame == 7)			{ vmin = '-3 -3 -3'; vmax = ' 3 3 3'; }
		if (e.frame == 3 || e.frame == 4 ||
			  e.frame == 8 || e.frame == 9)			{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
		if (e.frame == 5 || e.frame == 10)		{ vmin = '-1 -1 -1'; vmax = ' 1 1 1'; }
	}
	else if (e.model == "progs/proxbomb.mdl")	{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
	else if (e.model == "progs/hook.mdl")			{ vmin = '-5 -5 -5'; vmax = ' 5 5 5'; }
	else if (e.model == "progs/v_spike.mdl")		{ vmin = '-4 -4 -4'; vmax = ' 4 4 4'; }
	else if (e.model == "progs/ejbatt.mdl")		{ vmin = '-2 -2 -6'; vmax = ' 2 2 4'; }
	else if (e.model == "progs/s_bubble.spr")	{ vmin = '-2 -2 -2'; vmax = ' 2 2 2'; }
	else if (e.model == "progs/chaos_b2.mdl")	{ vmin = '-16 -16 -24'; vmax = ' 16 16 40'; }
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
	if (r1 > 15) s1 = "progs/gas.mdl";
	else if (r1 > 13) s1 = "progs/grenade.mdl";
	else if (r1 > 10) s1 = "maps/b_exbox2.bsp";
	else if (r1 > 8) s1 = "maps/b_rock0.bsp";
	else if (r1 > 7) s1 = "progs/ejbatt.mdl";
	else if (r1 > 5) s1 = "progs/proxbomb.mdl";
	else if (r1 > 3) s1 = "progs/hook.mdl";
	else if (r1 > 2) s1 = "progs/v_spike.mdl";
	if (e)
	{
		setmodel(e, s1);
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
		self.aflag = 0;
		return;
	}
	r1 = floor(random() * 8.6);
	wfire = W_FireSpikes;
	vspk = SUB_Null;
	if (self.weapon == IMP_MOGRE) { wfire = W_FireGrenade; r1 = 5; }
	else if (r1 > 7) wfire = fire_laser1;
//	else if (r1 > 6) wfire = fire_cbolt; // TDO: put back in for chaos morph
	else if (r1 > 5) { wfire = W_FireGrenade; vspk = RND_Damage; }
	else if (r1 > 5) { wfire = W_FireRocket; vspk = RND_Damage; }
	else if (r1 > 4) wfire = W_FireLightning;
	if (r1 < 4) vspk = RND_Spike;

	RND_frame = random() * 7.4;
	RND_skin = random() * 3.4;
	RND_maxdmg = CBOMB_DEF_MAX;
	
// really just a fancy bouncing betty
	fire_burst (wfire, self.origin + ' 0 0 30', 0, 0, "", "", 0, 3, 8, ' 120 0 0', ' 300 360 360', vspk, FL_ANGADR | FL_VELRND | FL_FRCORG | FL_NEWSELF | FL_OWNOWN, world);
	RND_maxdmg = 0; // reset
	remove(self);
};














