/*

adaptive painkeep code main file
(i.e. - adaptive - its easy to add to other mods)
	-- in theory anyway

Cataboligne 

pk 1.2 --- 3.29.8
pk 2.0 --- 5.3.10
pk 2.2 --- 2.5.11
pk 3.0 --- 10.28.11


==================================================

What is Painkeep?

"PainKeep is a DeathMatch-only "mission-pack" designed for use with registered
Quake. PainKeep not only offers brand new weapons (with new pickup and view
models), but also a new rich environment with tons of new sounds, new special
effects, great new features, and lots of surprises. Every modification
included is original. This is in no way a compilation of various "weekend
mods" from the net."

Goals:

PainKeep goes back to Deathmatch's original emphasis. Make other players die.

==================================================

Release schedule:

Painkeep v1.1: 02 July 1997 - Copyright (c)1996,1997 Team Evolve.

Painkeep v1.11: 11 Aug 1997 - Evolve bug fix update

PainKeep Artifacts 1.3 - 03 Dec 1999 - Copyright (c)1999, 2000 Thing & Ergodic
- new maps and 4 new painkeep items

Painkeep Convenience pack: 17 Aug 2001 - Multiple credits:
- PKN Maps (+new hub [ #2 ]) - quovadis and clan [N]
- PK Artefacts 1.3, ThinG maps (+new hub [ #3 ]) - ThinG and Ergodic
- readme signed --==blakjack==-- (perhaps the packager ?)

Painkeep v1.12c - 23 Feb 2008 - Eddie Cottongim (quake world update)

Painkeep v1.2 - 27 Apr 2008 - Cataboligne (source code update for v1.11)
- admin & user menus, re-organized source code for adding to other mods

Painkeep v1.2.1 - 16 Oct 2008 - Cataboligne (source code update for v1.11)
- bug fixes, extended map support for hubs 2 & 3

Painkeep 2.0 (beta) - 18 May 2010 - Cataboligne (major update!)
- bots, visible weps, chase cam, quake 3 map support, random pk items

Painkeep 2.1 - 19 Apr 2011 - Cataboligne
- gold version for 2.x, bug fixes - final release

Painkeep 3.0 - 27 Oct 2012 - Cataboligne
- bundled with Archon [!] - not a separate release (yet)
- painkeep item stat control, modified pk items, other improvements

==================================================

*/

// precache all PK items here - relocated from world.qc

void() PK_init =
{

	chaos = cvar("chaos"); // glquake mod engine
	DARKPLACES = cvar("pr_checkextension"); // check for dp engine

// info strings set by server - these only work on the server
	localcmd(vers);		//		quake-c: chaos archon (alpha) 1.0.x
	localcmd(stats);		//		code: chaos archon (alpha) 1.0.x
	localcmd(vweb);		//		http://www.moddb.com/mods/chaos-archon/
	localcmd(vdev);		//		http://www.moddb.com/members/invadercat/
	localcmd(vqcs);		//		http://www.moddb.com/groups/qc/
	localcmd(sites);		//		{ 3 sites listed above }
	localcmd("echo;echo ***;echo *** enter 'codes' at console for list of common commands ***;echo ***;echo\n");

	pk_precache();
	q1_precache();

	viswep_pre();

	qweps = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_MJOLNIR;
	pkweps = PK_IT_AXE | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT	| PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB
							 | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE; // pk plus weps

	pk_srvcmd_set(); 	// set server controls for qc code

	if (cvar("saved1") == XTR_SAVED1) // allow xmod to be set on other engines
	{
		cvar_set("saved1", "0"); // clear temp code
		if (DARKPLACES || chaos) cvar_set("sv_xtras", "1");
		XMOD = 1;
	}

	if (!XMOD) // possible to run qc w/o paks
	{
		ULOKW = ULOKD = ULOK2 = ULOK3 = FALSE;
	}

	ULOKHL = FALSE; // place holder - HL stuff not supported yet - Cataboligne 10.12.12

	if (!PK_SEVEN) // not found - turn off
	{
		ULOKW = ULOKD = FALSE;
	}

	if (!PK_EIGHT)
	{
		ULOK2 = ULOK3 = FALSE;
	}

	if (!DARKPLACES) // may not use all this - dp auto precaches
	{
		if (ULOKW) wolf_precache();
		if (ULOKD) doom_precache();
		if (ULOK2) q2_precache();
		if (ULOK3) q3_precache();
		chaos_precache();
		hip_precache();
		morph_precache();
		rune_precache();
		hook_precache();  // Cataboligne - hook mod
	}

	pk_art_precache(); // Cataboligne 8.12.9 purify - pk artifacts

	PK_ADMIN = 6; // code sets allow admin here - can be disabled by admin menu, 3 is base menu set

	local entity e;

	if (PK_ADMIN)
	{
// access code first
		e = spawn();
		e.nextthink = time + 0.5; // cat: 8.8.9 - had to increment, wasnt getting code
		e.think = PK_SetAdmin;
		e.classname = "admincode";

		localcmd(ADMINCODE);
		pk_admincode = pk_adminimp = -1;
		pk_adminpwdmask = TRUE;
	}

	pk_itemovr = pk_itemovr_ck = cvar("saved3"); // admin override of map items

// causes item overrides to happen on map load

	if (pk_itemovr & CON_RUN) // change some items - admin override
	{
		e = spawn();
		if (e)
		{
			e.think = item_loop;
			e.nextthink = time + 2; // do this well after items spawn
		}
	}


// set PK mode based on engine var | saved*

	pk_flags = pk_flags_ck = cvar("savedgamecfg");
	pk_map = PK_mapmode(world.model);

// genre for init stuff

	MAP_MODE = "Q";

	if (pk_map) MAP_MODE = "PK";
	else if (world.wad == "wolftex.wad" && ULOKW) MAP_MODE = "W";
	else if (world.wad == "doomtex.wad" && ULOKD) MAP_MODE = "D";
	else if (world.wad == "doom2tex.wad" && ULOKD) MAP_MODE = "D";
	else if (world.wad == "q2.wad" && ULOK2) MAP_MODE = "Q2";
	else if (world.wad == null_string && !pk_map && ULOK3) MAP_MODE = "Q3";

// single player hack - if hub flag is set and we forced dynamic items level exit returns to hub
	if (!deathmatch && (pk_flags & PK_SF_HUB)) pk_flags = pk_flags - PK_SF_HUB;
 
// got mode, set PK master switch
	PK = FALSE;

	if (pk_flags & PK_ALWAYS)
		PK = TRUE;
	else if (pk_flags & PK_NEVER)
		PK = FALSE;
	else
	{
		PK = PK_mapmode(world.model);
	}

	custom_hub_loaded = pk_flags & PK_HUB2; // see if we came from a custom hub
	if (world.model == "maps/start.bsp" && world.message == "HUB")
	{
		pk_flags = pk_flags - (pk_flags & PK_HUB2);
		custom_hub_loaded = FALSE;
		localcmd("alias hubmap \"bf\"\n"); // always deactivate
	}
	admin_sv_cfg();

// setup dynamic items

	if (!DARKPLACES && !chaos) // admin menu only control
	if (pk_flags & PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR) // wont see DYN_* stuff here unless it is compiler set
	{
		if (!(pk_flags & PK_DYNAMIC) && !DYN_OVR && !DYN_FORCE) DYN_ARTFR_ONLY = DYN_ARTFR;
		pk_ditems = 0;
		e = spawn();
		if (e)
		{
			e.think = dyn_item;
			e.nextthink = time + DYN_START_TIME; // do this well after items spawn
		}
	}

	pk_livent = 0; // nothing lives yet

// load pk bots w/enh. engine

	if (DARKPLACES || chaos)
	{
		cvar_set("sv_bot_pkset", "1");
		localcmd("unalias blvl bmap\n"); // unalias - not needed
	}

	bot_lvlreload = world;

// drop inventory allows serverflags runes to be thrown out - must follow players to new levels if they were collected

	if (!RUNES)
	{
		SVRF = SVR1 + SVR2 + SVR4 + SVR8; // detect follower runes
	
		if (serverflags & SVRF)
		{
			e = spawn();
			e.think = server_rune_follow;
			e.nextthink = time + PIC_TO - 2;
		}
	}
	rune_new_map = FALSE;

// extra sounds by...are apparently not supplied, except gib_?.wav

	pk_xsound = (pk_flags & PK_XSOUND);
	/*
// extra player pain sounds
	if (pk_xsound)
	{
	precache_sound ("player/pain_1.wav");
	precache_sound ("player/pain_2.wav");
	precache_sound ("player/pain_3.wav");
	precache_sound ("player/pain_4.wav");
	precache_sound ("player/pain_5.wav");
	precache_sound ("player/pain_6.wav");
	precache_sound ("player/pain_7.wav");

// extra player death sounds
	precache_sound ("player/death_1.wav");
	precache_sound ("player/death_2.wav");
	precache_sound ("player/death_3.wav");
	precache_sound ("player/death_4.wav");
	precache_sound ("player/death_5.wav");
	precache_sound ("player/death_6.wav");
	precache_sound ("player/death_7.wav");
	precache_sound ("player/death_8.wav");
	precache_sound ("player/death_9.wav");
	precache_sound ("player/death_10.wav");
	precache_sound ("player/death_11.wav");


// misc sounds that mark has replaced.

	precache_sound ("player/suck_1.wav");
	precache_sound ("player/suck_2.wav");
	precache_sound ("player/suck_3.wav");
	precache_sound ("player/suck_4.wav");
	precache_sound ("player/suck_5.wav");
	precache_sound ("player/suck_6.wav");
	precache_sound ("player/suck_7.wav");
	precache_sound ("player/suck_8.wav");

	precache_sound ("player/burn_1.wav");
	precache_sound ("player/burn_2.wav");
	precache_sound ("player/burn_3.wav");
	precache_sound ("player/burn_4.wav");
	precache_sound ("player/burn_5.wav");

 	precache_sound ("player/drown_1.wav");
 	precache_sound ("player/drown_2.wav");
 	precache_sound ("player/drown_3.wav");
 	precache_sound ("player/drown_4.wav");


 	precache_sound ("player/jump_1.wav");
 	precache_sound ("player/jump_2.wav");
 	precache_sound ("player/jump_3.wav");
 	precache_sound ("player/jump_4.wav");


 	precache_sound ("player/gasp_1.wav");
 	precache_sound ("player/gasp_2.wav");
 	precache_sound ("player/gasp_3.wav");
 	precache_sound ("player/gasp_4.wav");
 	precache_sound ("player/gasp_5.wav");


 	precache_sound ("player/fall_1.wav");
 	precache_sound ("player/fall_2.wav");
	}
	*/
};

// fn (precache_sound) -- dynamic item takeovers - because some engines cannot precache after map load
// fn(precache_model)

string (string s) precache_sound =
{
	if (time < PIC_TO)
		return(precache_sound__(s));

	return(string_null);// Cataboligne - 8.7.13 - compiler warning
};

string (string s) precache_model =
{
/// moved here to simplify code (pkitems.qc)

	if (time < PIC_TO) // only do this for map load items
	{
		if (s == "progs/g_airgun.mdl" || s == "progs/g_airgun2.mdl" || s == "progs/g_clight.mdl" || s == "progs/g_harp.mdl" || s == "progs/tpower.mdl" || s == "progs/beans.mdl" || s == "progs/bearpick.mdl" || s == "maps/b_eshel0.bsp" )
		{
			if (!(pk_flags & PK_MAP) && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
		}

		if (s == "progs/ego.mdl" || s == "progs/tomb.mdl" || s == "progs/actor.mdl" || s == "progs/phone.mdl") // pkpitems.qc
		{
			if (!(pk_flags & PK_MAP) && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
		}

		return(precache_model__(s));
	}

	return(string_null);// Cataboligne - 8.7.13 - compiler warning
}; 

// set mode based on map name

float(string mp) PK_mapmode =
{
	if (mp == "maps/start.bsp" && world.message == "hub") return(TRUE); // NOTE: relies on loaded map
	if (mp == "maps/pk0.bsp") return(TRUE);
	if (mp == "maps/pk1.bsp") return(TRUE);
	if (mp == "maps/pk2.bsp") return(TRUE);
	if (mp == "maps/pk3.bsp") return(TRUE);
	if (mp == "maps/pk4.bsp") return(TRUE);
	if (mp == "maps/pk5.bsp") return(TRUE);
	if (mp == "maps/pk6.bsp") return(TRUE);
	if (mp == "maps/pk7.bsp") return(TRUE);
	if (mp == "maps/pk8.bsp") return(TRUE);
	if (mp == "maps/pk9.bsp") return(TRUE);
	if (mp == "maps/pk10.bsp") return(TRUE);
	if (mp == "maps/pk11.bsp") return(TRUE);
	if (mp == "maps/pk12.bsp") return(TRUE);
	if (mp == "maps/pk13.bsp") return(TRUE);
	if (mp == "maps/pk14.bsp") return(TRUE);
	if (mp == "maps/pk15.bsp") return(TRUE);
	if (mp == "maps/pk16.bsp") return(TRUE);
	if (mp == "maps/pk17.bsp") return(TRUE);
	if (mp == "maps/pk18.bsp") return(TRUE);
	if (mp == "maps/painkeep.bsp") return(TRUE);
	if (PK_ADHUB)	// add on maps from painkeep updates
	{
		if (mp == "maps/hub2.bsp") return(TRUE);
		if (mp == "maps/hub3.bsp") return(TRUE); // renamed for 1.2 code to work with main hub (start.bsp)

		if (mp == "maps/pkn1.bsp") return(TRUE);
		if (mp == "maps/pkn2.bsp") return(TRUE);
		if (mp == "maps/pkn3.bsp") return(TRUE);
		if (mp == "maps/pkn4.bsp") return(TRUE);
		if (mp == "maps/pkn5.bsp") return(TRUE);
		if (mp == "maps/pkn6.bsp") return(TRUE);
		if (mp == "maps/pkn7.bsp") return(TRUE);
		if (mp == "maps/pkn8.bsp") return(TRUE);
		if (mp == "maps/pkn9.bsp") return(TRUE);
		if (mp == "maps/pkn10.bsp") return(TRUE);
		if (mp == "maps/pkn11.bsp") return(TRUE);
		if (mp == "maps/pkn12.bsp") return(TRUE);
		if (mp == "maps/pkn13.bsp") return(TRUE);
		if (mp == "maps/pkn14.bsp") return(TRUE);
		if (mp == "maps/pkn15.bsp") return(TRUE);
		if (mp == "maps/pkn16.bsp") return(TRUE);
		if (mp == "maps/pkn17.bsp") return(TRUE);
		if (mp == "maps/pkn18.bsp") return(TRUE);
		if (mp == "maps/pkn19.bsp") return(TRUE);
		if (mp == "maps/pkn20.bsp") return(TRUE);
		if (mp == "maps/pkts00.bsp") return(TRUE);
		if (mp == "maps/pkts01.bsp") return(TRUE);
		if (mp == "maps/pkts02.bsp") return(TRUE);
		if (mp == "maps/pkts03.bsp") return(TRUE);
		if (mp == "maps/pkts04.bsp") return(TRUE);
		if (mp == "maps/pkts05.bsp") return(TRUE);
		if (mp == "maps/pkts06.bsp") return(TRUE);
		if (mp == "maps/pkts07.bsp") return(TRUE);
		if (mp == "maps/pkts08.bsp") return(TRUE);
		if (mp == "maps/pkts09.bsp") return(TRUE);
		if (mp == "maps/pkts10.bsp") return(TRUE);
		if (mp == "maps/pkts11.bsp") return(TRUE);
		if (mp == "maps/pkts12.bsp") return(TRUE);
		if (mp == "maps/pkts13.bsp") return(TRUE);
		if (mp == "maps/pkts14.bsp") return(TRUE);
		if (mp == "maps/painkeep2.bsp") return(TRUE);

		if (mp == "maps/air2.bsp") return(TRUE);
		if (mp == "maps/air3.bsp") return(TRUE);
		if (mp == "maps/anomie.bsp") return(TRUE);
		if (mp == "maps/arena.bsp") return(TRUE);
		if (mp == "maps/bastion.bsp") return(TRUE);
		if (mp == "maps/blood2.bsp") return(TRUE);
		if (mp == "maps/blood3.bsp") return(TRUE);
		if (mp == "maps/campers-cove.bsp") return(TRUE);
		if (mp == "maps/castle2.bsp") return(TRUE);
		if (mp == "maps/chv_hub.bsp") return(TRUE);
		if (mp == "maps/city.bsp") return(TRUE);
		if (mp == "maps/court.bsp") return(TRUE);
		if (mp == "maps/crater.bsp") return(TRUE);
		if (mp == "maps/crater2.bsp") return(TRUE);
		if (mp == "maps/doom1_e1.bsp") return(TRUE);
		if (mp == "maps/egyptra.bsp") return(TRUE);
		if (mp == "maps/egyptra2.bsp") return(TRUE);
		if (mp == "maps/egyptra3.bsp") return(TRUE);
		if (mp == "maps/factory.bsp") return(TRUE);
		if (mp == "maps/factory2.bsp") return(TRUE);
		if (mp == "maps/factory3.bsp") return(TRUE);
		if (mp == "maps/fragtown.bsp") return(TRUE);
		if (mp == "maps/garden.bsp") return(TRUE);
		if (mp == "maps/giza2.bsp") return(TRUE);
		if (mp == "maps/haunted.bsp") return(TRUE);
		if (mp == "maps/platinum.bsp") return(TRUE);
		if (mp == "maps/platinum2.bsp") return(TRUE);
		if (mp == "maps/platinum3.bsp") return(TRUE);
		if (mp == "maps/q1edgepk.bsp") return(TRUE);
		if (mp == "maps/spine2.bsp") return(TRUE);
		if (mp == "maps/summerpk.bsp") return(TRUE);
		if (mp == "maps/toxic.bsp") return(TRUE);
		if (mp == "maps/toxic2.bsp") return(TRUE);
		if (mp == "maps/well.bsp") return(TRUE);
	}
	return(FALSE);
};

// fn(q_startmap) - set q1 startmap name in single player

void() q_startmap =
{
	if (self.map == "start") // trying to load start.bsp - fix/hack
	{
		if (world.model == "maps/e1m7.bsp" && world.message == "The House of Chthon") // qualify these ? - some custom load might rename other maps to q1 names
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/e2m6.bsp" && world.message == "the Dismal Oubliette")
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/e3m6.bsp" && world.message == "Chambers of Torment")
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/e4m7.bsp" && world.message == "Azure Agony")
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/end.bsp" && world.message == "Shub-Niggurath's Pit")
		{
			self.map = "qstart";
		}
	}
};

// count up players for map overloads

void() player_count =
{
	local entity e;

	ply_count = 0;
	e = find(world,classname,"player");
	while (e)
	{
		ply_count = ply_count + 1;
		e = find(e,classname,"player");
	}

	e = find(world,classname,"pk*bot");
	while (e)
	{
		ply_count = ply_count + 1;
		e = find(e,classname,"pk*bot");
	}

// count observers
	e = find(world,classname,OBSERVER);
	while (e && PLY_OBSERVER)
	{
		ply_count = ply_count + 1;
		e = find(e,classname,OBSERVER);
	}

	if (cvar("sv_adm")) ply_count = 65536;
};

// fn(pk_srvcmd_set) - setup new server control vars & load from cfg or alias
// fn(pk_srvcmd_load) - load new server control vars
// fn(botmatch) - load bots for bot match

void() botmatch =
{
	local float f, t, b;

	cvar_set("saved1", "0"); // clear possible impulse entry

	if (self.cnt < 0 || bot_count > 0 || NUMBOTS > 0)
	{
		if (self.cnt < 0)
		{
			b = bot_count + NUMBOTS + 1;
			if (b > 1)
			bprint("All Bots removed!\n");
			while (b > 0)
			{
				removeBot(world); // pk
				KickABot(); // frik
				b = b - 1;
				if ((bot_count + NUMBOTS) == 0) b = 0;
			}
			return;
		}
		bprint("Bots already running - botmatch exiting\n");
		remove(self);
		return;
	}		

	bprint("Botmatch turned on, loading ");
	bprint(ftos(self.cnt));
	bprint(" bots!\n");

	b = NUMBOTS;
	
	t = self.cnt / 2;

 if (deathmatch) // pk*bots only in dm
 {
	while (t > 0.33 && self.cnt > 0)
	{
		f = rint(random() * 3.3);
		AddAnotherBot (f);
		self.cnt = self.cnt - 1;
		t = t - 1;
	}

	if (b != NUMBOTS)
	{
		bprint("---> loaded ");
		bprint(ftos(NUMBOTS));
		bprint(" pk*bots\n");
	}
	else
	{
		bprint("---> Error: bots not loaded, exiting - make sure this is a multiplayer server\n");
	}
 }

	b = bot_count;

	if (self.cnt < 1)
	{
		remove(self);
		return;
	}

	while (self.cnt > 0)
	{
		f = rint(random() * 3.3);
		BotConnect(0, 0, f);
		self.cnt = self.cnt - 1;
	}

	if (b != bot_count)
	{
		bprint("---> loaded ");
		bprint(ftos(bot_count));
		bprint(" frikbots\n");
	}
	else
	{
		bprint("---> Error: bots not loaded, exiting - make sure this is a multiplayer server\n");
		remove(self);
		return;
	}
	if (DARKPLACES || chaos) th_bot_changeParms(5);
	remove(self);
};

// fn (\ch) - launch botspawn call

// b - true if done by impulse

void(float b) b_launch =
{
	local entity e;
	local float bcnt;

	if (DARKPLACES || chaos)
	{
		bcnt = cvar("sv_botmatch");
		cvar_set("sv_botmatch", "0");
	}

	if (b) bcnt = b;

	if (bcnt != -666)
	if (bot_count > 0 || NUMBOTS > 0) return; // have bots, go back

	e = spawn();
	if (e)
	{
		e.think = botmatch;
		e.nextthink = time + 3 + 4 * random(); // make em wait a few secs, build suspense
		e.cnt = bcnt;
		if (e.cnt == 1) e.cnt = 6; // default load = 6 bots
		if (bcnt != -666)
		if (e.cnt < 0) e.cnt = 0 - e.cnt; // -{number} runs {number} bots
		if (coop && fabs(e.cnt) > 3) e.cnt = 3;
	}
};

// restore limits if noexit used

void() NoExit_save =
{
	if (!deathmatch || inHubMap) return;
	
	if (NOEXIT_SAVEFRAG > -1)
	{
		localcmd("fraglimit ");
		localcmd(ftos(NOEXIT_SAVEFRAG));
		localcmd("\n");
		NOEXIT_SAVEFRAG = -2;
	}

	if (NOEXIT_SAVETIME > -1)
	{
		localcmd("timelimit ");
		localcmd(ftos(NOEXIT_SAVETIME));
		localcmd("\n");
		NOEXIT_SAVETIME = -2;
	}	
};


// fn(pk_liveupd) - these cvar update live during game

float st_pk_sfx;			// state vars - so we know when it changes
float st_pk_hub;
float st_pk_cmap;

// fn(pk_bas_flags) - set basic pk flags, handles cvar update, admin cfg
//			reworked from old code to include cvar controls with bit flags and handle changes to both

// bt - bit
// st - state, 1 or 0

// fn(pk_bas_update) - update status of live changes to console
// brpint cm to console and ON or OFF according to bt state

void(float bt, string cm) pk_bas_update =
{
	bprint(cm);
	if (bt) bprint("ON\n");
	else bprint("OFF\n");
};

void(float bt, float st) pk_bas_flags =
{
	if (bt == PK_DYNAMIC)
	{
		if (st)	pk_flags = pk_flags | PK_DYNAMIC;
		else		pk_flags = pk_flags - (pk_flags & PK_DYNAMIC);
		if (DARKPLACES || chaos) cvar_set("pk_dyn_ovr", ftos(st));
		DYN_OVR = st;
	}

	if (bt == PK_SF_HUB)
	{
		if (st)	pk_flags = pk_flags | PK_SF_HUB;
		else		pk_flags = pk_flags - (pk_flags & PK_SF_HUB);
		if (DARKPLACES || chaos) cvar_set("sv_pk_hub", ftos(st));
		st_pk_hub = st;
	}

	if (bt == PK_TP_SPARKSFLASH)
	{
		if (!st)	pk_flags = pk_flags | PK_TP_SPARKSFLASH;
		else		pk_flags = pk_flags - (pk_flags & PK_TP_SPARKSFLASH);
		if (DARKPLACES || chaos) cvar_set("sv_pk_sfx", ftos(st));
		st_pk_sfx = st;
	}

	if (bt == PK_TP_USERMAPON) // Cat - 2.28.11 - added to live updates
	{
		if (st)	pk_flags = pk_flags | PK_TP_USERMAPON;
		else		pk_flags = pk_flags - (pk_flags & PK_TP_USERMAPON);
		if (DARKPLACES || chaos) cvar_set("sv_pk_cmap", ftos(st));
		st_pk_cmap = st;
	}
	admin_sv_cfg();
};

// fn(pk_liveupd) - detect live changes to config cvars by server admin - call up code to effect in game
/// genius code
entity bot_fix;

void() pk_liveupd =
{
	local entity e;
	local float f;
	
// server controls

	ADMINLOCK = cvar("sv_c_adminlock");
	WARNING = cvar("sv_c_warning");

// bots
	f = cvar("saved1");

	if (f == 268226) // frik botcam toggle code
	{
		BOTCAM = fabs(1 - BOTCAM); // NOTE: frik code does NOT verify the state of cam if toggled off with this
		cvar_set("saved1", "0"); // cant clear outside test, used for too much dev prints
		f = 0;
	}
		
	noway_below = cvar("sv_bot_noway_below"); // no bot waypoints below this
	noway_above = cvar("sv_bot_noway_above"); // bot bot waypoints above this

	if (WORLD_NOWAY)
	{
		if (!noway_below) noway_below = world.mins_z;
		if (!noway_above) noway_above = world.maxs_z;
	}

	NODECOR = cvar("sv_c_nodecor");

// runes
	if (time > 1)
		run_runes();
 
// check for botmatch changes
	if (deathmatch || coop)
	if (cvar("sv_botmatch") != 0) b_launch(0);

	if (BOT_FIXED)  // try to fix stuck bots
	if (!bot_fix)
	if (!intermission_running)
	if (find(world,class_select,"class_bot")) // at least one bot
		bot_fixer();


// cam stuff
	DCAMTO = cvar("sv_cam_timeout");
	DCAMTOACT = cvar("sv_cam_to_action");

// viswep
	VW_ARMOR = cvar("sv_vw_armor");
	VW_HOLSTER = cvar("sv_vw_holster");
	if (VW != cvar("sv_vw"))
	{
		VW = cvar("sv_vw");
		if (!VW)
		{
			VW_ARMOR = FALSE;
		}
		viswep_togl(); // load it up
	}

	XENV = cvar("sv_c_xenv");

// pk basics - if a cvar is changed, update status bit

	if (st_pk_sfx != cvar("sv_pk_sfx"))
	{
		pk_bas_flags(PK_TP_SPARKSFLASH, cvar("sv_pk_sfx"));
		pk_bas_update(st_pk_sfx, "Painkeep special effects ");
	}
	if (st_pk_hub != cvar("sv_pk_hub"))
	{
		pk_bas_flags(PK_SF_HUB, cvar("sv_pk_hub"));
		pk_bas_update(st_pk_hub, "Painkeep Hub mode ");
	}
	if (st_pk_cmap != cvar("sv_pk_cmap"))
	{
		pk_bas_flags(PK_TP_USERMAPON, cvar("sv_pk_cmap"));
		pk_bas_update(st_pk_cmap, "Painkeep custom server maps ");
	}

// vars server controls

	SV_FALLEN = cvar("sv_c_fallen");
	SV_HOLDING = cvar("sv_c_holding");

	if (deathmatch)
	if (time > 2) // dont do before we recognize the hub & get triggers loaded
	if (!inHubMap)  // *pk - dont need this on hub
	{
		if (!NOEXIT_CHECK)
		{
			NOEXIT_SAVETIME = NOEXIT_SAVEFRAG = -2;

			if (find(world, classname, "trigger_changelevel"))
				NOEXIT_CHECK = 1;
			else if (!cvar("timelimit") && !cvar("fraglimit")) // no limits already set
			{
				NOEXIT_CHECK = -1; // using default timeout if set
				NOEXIT_SAVETIME = cvar("timelimit");
				NOEXIT_SAVEFRAG = cvar("fraglimit");
			}
		}

	// update noext defaults if changed live and they are in use
		if (NOEXIT_CHECK < 0)
		{
			if (NOEXIT_TIMEOUT != cvar("sv_c_noexit_timeout"))
			{
				bprint("\bServer set default time limit due to no exit\n");
				NOEXIT_TIMEOUT = cvar("sv_c_noexit_timeout");
				localcmd("timelimit ");
				localcmd(ftos(NOEXIT_TIMEOUT));
				localcmd("\n");
			}
			if (NOEXIT_FRAGLIMIT != cvar("sv_c_noexit_fraglimit"))
			{
				bprint("\bServer set default frag limit due to no exit\n");
				NOEXIT_FRAGLIMIT = cvar("sv_c_noexit_fraglimit");
				localcmd("fraglimit ");
				localcmd(ftos(NOEXIT_FRAGLIMIT));
				localcmd("\n");
			}
		}
	}

// hook codes
	HOOK = cvar("sv_c_hook");
	HOOK_DMG = cvar("sv_c_hook_dmg");
	HOOK_RANGE = cvar("sv_c_hook_range");
	HOOK_TIME = cvar("sv_c_hook_time");
	HOOK_URTO = cvar("sv_c_hook_urto");
	HOOK_SPEED = cvar("sv_c_hook_speed");
	HOOK_DAMP = cvar("sv_c_hook_damp");
	MAX_CHAIN_LEN = HOOK_RANGE;

	if (MAP_MODE == "Q2") LASER_HOOK = TRUE;
	else if (MAP_MODE == "Q3") LTN_HOOK = TRUE;

// overrides
	if (cvar("sv_c_hook_laser") > 0) LASER_HOOK = TRUE;
	else if (cvar("sv_c_hook_ltn") > 0) LTN_HOOK = TRUE;
	if (cvar("sv_c_hook_laser") < 0) LASER_HOOK = FALSE;
	if (cvar("sv_c_hook_ltn") < 0) LTN_HOOK = FALSE;
	if (!ULOK2) LASER_HOOK = FALSE;
	if (!ULOK3) LTN_HOOK = FALSE;

// frag suicide controls - nocides when set dont take frags

	NOCIDE = 	cvar("sv_pl_nocide");
	NOENVCIDE = cvar("sv_pl_nolavacide");
	NOPKCIDE = 	cvar("sv_pl_nopkcide");
	if (NOCIDE && NOENVCIDE >= 0) NOENVCIDE = NOCIDE; // if noenvc < 0 can still have env suicide when nocide is true
	if (NOCIDE && NOPKCIDE >= 0) NOPKCIDE = NOCIDE; // if nopkc < 0 can still have pk ffw suicide when nocide is true

	FFW_LIMIT = cvar("sv_pl_ffwlimit");

// defaults - set on respawn or server entry
	DEF_HEALTH = cvar("it_def_health");
	DEF_ARMOR = cvar("it_def_armor");
	DEF_ITEMS = cvar("it_def_items");
	DEF_PK_ITEMS = cvar("it_def_pkitems");
	DEF_WEAPON = cvar("it_def_weapon");

	DEF_AMMO_BULLETS = cvar("it_def_ammo_bullets");
	DEF_AMMO_SHELLS = cvar("it_def_ammo_shells");
	DEF_AMMO_CELLS = cvar("it_def_ammo_cells");
	DEF_AMMO_ROCKETS = cvar("it_def_ammo_rockets");
	DEF_AMMO_NAILS = cvar("it_def_ammo_nails");
	DEF_AMMO_SLUGS = cvar("it_def_ammo_slugs");
	DEF_AMMO_GAS = cvar("it_def_ammo_gas");

	DEF_X_ITEMS = cvar("it_def_x_items");
// wep inits
	INIT_CON = cvar("it_init_con");
	CHAR_CON = cvar("it_char_con");

	INIT_0_W = cvar("it_init_0_wolf");
	INIT_1_D = cvar("it_init_1_doom");
	INIT_2_Q = cvar("it_init_2_quake");
	INIT_3_PK = cvar("it_init_3_pk");
	INIT_4_Q2 = cvar("it_init_4_q2");
	INIT_5_Q3 = cvar("it_init_5_q3");
	INIT_6_HP = cvar("it_init_6_hip");
	INIT_7 = cvar("it_init_7");

// q1 ammo
	Q1_SHELLAMMO_MAX				= cvar("it_max_shellammo");
	Q1_NAILAMMO_MAX					= cvar("it_max_nailammo");
	Q1_ROCKETAMMO_MAX				= cvar("it_max_rocketammo");
	Q1_CELLAMMO_MAX					= cvar("it_max_cellammo");

// item ammo levels - NOTE: limit to what can be carried tween levels is fixed! (at 3) - CHECK: tween levels storage code - as 4 could be 0, 5 -> 1, etc - any over 3 should be 3
	PK_GRAVITYWELLAMMO_MAX	= cvar("pk_max_gravitywellammo");
	PK_TURRETAMMO_MAX				= cvar("pk_max_turretammo");
	PK_CANPABAMMO_MAX			= cvar("pk_max_canpabammo");
	PK_BEARTRAPAMMO_MAX		= cvar("pk_max_beartrapammo");

	PK_EXPLODEAMMO_MAX			= cvar("pk_max_explodeammo"); // tween level limit ~15 ?
// plus items
	PKPLUS_EGOAMMO_MAX			= cvar("pk_max_egoammo");
	PKPLUS_TOMBAMMO_MAX		= cvar("pk_max_tombammo");
	PKPLUS_ACTORAMMO_MAX	= cvar("pk_max_actorammo");
	PKPLUS_PHONEAMMO_MAX	= cvar("pk_max_phoneammo");

	SV_AMMO_MAX = cvar("sv_c_ammo_max");

	if (cvar("sv_c_drop"))
		IMP_DROPI = IMP_DROPI_ACT; // drop inv control
	else
		IMP_DROPI =  0;

// x ammos
	PK_BULLETAMMO_MAX				= cvar("it_max_bulletammo");
	PK_SLUGAMMO_MAX					= cvar("it_max_slugammo");
	PK_GASAMMO_MAX						= cvar("it_max_gasammo");

	PK_MAX_LIVENT = cvar("pk_max_livent");

	DEAD_THROW = cvar("sv_dead_throw");
	DEAD_THROW_ARMOR = cvar("sv_dead_throw_armor");
	DEAD_THROW_PKI = cvar("sv_dead_throw_pki");
	DEAD_XPACK = cvar("sv_dead_xpack");
	DEAD_GIBPACK = cvar("sv_dead_gibpack");

	X_CHGLVL = cvar("it_xchgl");

	Q2_SILENCE = cvar("q2_silence");

// nodules

//	if (time > 120) // no nodules for 2 mins - NODULE_ENTRY_TIME
// if (time < 240)
//TEST
	if (time > 10)
	if (time < 70)
	{
		if (ARCHON_NODULES  != (autocvar_sv_nodule / 2)) // only 1/2 cnt to start
		{
			ARCHON_NODULES = autocvar_sv_nodule / 2;
			cube_handle("sv_nodule");
		}
	}
	else
	if (ARCHON_NODULES  != autocvar_sv_nodule) 
	{
		cube_handle("sv_nodule");
		ARCHON_NODULES = autocvar_sv_nodule;
	}

// morphic
	MORPH_CUBE_TIME = cvar("sv_morph_time");
	MORPH_CUBE_DV = cvar("sv_morph_dv");
	MORPH_BOT = cvar("sv_morph_bot");
	MORPH_FREE = cvar("sv_morph_free");

	if (time > 5) // for msg
	if (MORPHIC  != cvar("sv_morph")) 
	{
		cube_handle("sv_morph");
		MORPHIC = cvar("sv_morph");
	}

// monsters
	DM_MONSTER = FALSE;
	if (find(world,class_select,"class_monster")) DM_MONSTER = TRUE;

	HUB_MONSTER = cvar("sv_monster_hub");
	S_MONSTER = cvar("sv_monster_resp");
	S_MONSTER_II = cvar("sv_monster_resp2");
	if (S_MONSTER & MONSTER_MASK)
	{
		if (!monster_respawner) monster_respawn();
	}
	else
	if (monster_respawner)
	{
		remove(monster_respawner);
		monster_respawner = world;
	}

	if (ENHANCED)
	{
		FAST_MONSTER = cvar("sv_monster_fast");
		SLOW_MONSTER = cvar("sv_monster_slow");
		R_FAST_MONSTER = cvar("sv_monster_rnd_fast");
		R_SLOW_MONSTER = cvar("sv_monster_rnd_slow");
	}
	C_FS_MONSTER = cvar("sv_monster_cfs");

	if (MON_SPEED_DIV <= 0) MON_SPEED_DIV = 1;

	C_MONSTER_CNT = cvar("sv_monster_cnt");
	if ( (C_MONSTER != cvar("sv_monster_rnd")) || (C_MONSTER_II != cvar("sv_monster_rnd2")) )
	{
		random_monster(); // control
	}

	if ((C_MONSTER  || C_MONSTER_II) && random_monster_spawn.nextthink <= 0)
		random_monster(); // fix not spawning monsters when nthink got < 0
	
	if (M_MONSTER != cvar("sv_monster_map"))
	{
		M_MONSTER = cvar("sv_monster_map"); // IMP: process loop - turn bits on and off, remove culled monsters
//		if (!R_MONSTER) // monsters were not removed when loading map - live controls usefull
		if (M_MONSTER < 0)
		if (!deathmatch)
//			bprint("*** Alert - map monsters turned off in single player / coop\n --- certain levels can NOT be finished without using enhancements\n");
			bprint("*** Alert - map monsters turned off in single player / coop\n --- all monster targets will fire on map load\n");
	}
	M_MONSTER_II = cvar("sv_monster_map2");

// list monster control bits
	if (cvar("sv_monster_list"))
	{
		localcmd("monster_bits\n");
		cvar_set("sv_monster_list", "0");
	}

// pk cubes
	PK_CUBE_TIME = cvar("it_cubes_time"); // TDO: doesnt reset existing makers

	if (PK_CUBE_TIME < 0)
	{
		PK_CUBE_TIME = fabs(PK_CUBE_TIME);
		PK_CUBE_DV = PK_CUBE_TIME * 0.3;
	}
	else
		PK_CUBE_DV = 0;

	if (time > 5) // for msg
	if (PK_CUBE  != cvar("pk_cubes")) 
	{
		cube_handle("pk_cubes");
		PK_CUBE = cvar("pk_cubes");
	}

// crates - use cube timing, but lasts twice as long
	if (time > 5) // for msg
	if (PK_CRATE  != cvar("it_crates")) 
	{
		cube_handle("it_crates");
		PK_CRATE = cvar("it_crates");
	}


//server defaulter - if no specials set

	if (deathmatch)
	{
		f = autocvar_no_auto;
		if (!f) // test auto-launch
		{
			cvar_set("no_auto", "1"); // only test once
			if (!PK_CRATE && !PK_CUBE && !MORPHIC && !RUNES)
			if (!S_MONSTER && !S_MONSTER_II && !C_MONSTER && !C_MONSTER_II && !M_MONSTER && !M_MONSTER_II)
			{
				localcmd("typical\n"); // run typical alias
				localcmd("default_hub_map\n"); // load default hub
			}
		}
	}


// turrets
	if (PK_TUR_AMMO != cvar("pk_tur_ammo") || 
		PK_TUR_TIME != cvar("pk_tur_time") || 
		PK_TUR_HEAL != cvar("pk_tur_health") || 
		PK_TUR_TARGOWN != cvar("pk_tur_targetown") || 
		PK_TUR_VARIETY != cvar("pk_tur_variety") || 
		PK_TUR_QUADCON != cvar("pk_tur_quadcon")) PK_TUR_SET = FALSE; // reset

// beartrap
	if (PK_BT_TIME != cvar("pk_bt_time") ||
			PK_BT_TIMETOFOLLOW != cvar("pk_bt_follow") ||
			PK_BT_DMG != cvar("pk_bt_dmg")) PK_BT_SET = FALSE;

// gravity

	if (PK_GRV_TIME != cvar("pk_grv_time")) PK_GRV_SET = FALSE;
	PK_GRV_RSP = cvar("pk_grv_rsp");

// tomb
	if (PKPLUS_TOMB_TIME != cvar("pk_tomb_time")) PK_TOMB_SET = FALSE;

// others
	LASER_FLY = cvar("sv_c_laser_fly"); 
	LASER_BOUNCE = cvar("sv_c_laser_bounce");

// map translations
	check_translate();

// respawn times
	D_POWER_WAIT = 
	Q2_POWER_WAIT = 

	RSP_TIME = cvar("sv_c_rsp_time");
	Q3_POWER_WAIT = 4 * RSP_TIME;

// art power supply times
	D_POWER_TIME = 
	Q2_POWER_TIME = 
	Q3_POWER_TIME = 

	POW_TIME = cvar("sv_c_pow_time");

	EXPLBOX_RESP = cvar("it_explbox_resp");

// artifacts
	if (PK_ART  != cvar("sv_pk_art"))
	{
		PK_ART  = cvar("sv_pk_art");
		pkplus_item_control_loop();
		if (!PK_ART)
		{
			DYN_ART = FALSE;
			DYN_ARTFR = FALSE;
		}
		else
		{
			DYN_ART = cvar("pk_dyn_art");
			DYN_ARTFR = cvar("pk_dyn_art_force");
		}
	}

// dynamic items
	DYN_SHOW = cvar("pk_dyn_show");
	DYN_OVR = cvar("pk_dyn_ovr");
	DYN_FORCE = FALSE;
	if (!DYN_OVR) DYN_FORCE = cvar("pk_dyn_force");
	DYN_FORCE_CNT = cvar("pk_dyn_force_cnt");
	DYN_ARTFR_ONLY = FALSE; // yes, has to reset every time

	if ((!DYN_OVR && (pk_flags & PK_DYNAMIC)) || (DYN_OVR && !(pk_flags & PK_DYNAMIC))) // got toggled - set pk_flags bit
	{
		pk_bas_flags(PK_DYNAMIC, DYN_OVR);
	}

	if (!PK_ART && ((DYN_ART && (DYN_OVR || DYN_FORCE) ) || DYN_ARTFR))
	{
		if (WARNING)
		{
			bprint("*** Warning - pk_art deactivated and dynamic controls enabled: ");
			if (DYN_ART) bprint("DYN_ART ");
			if (DYN_ARTFR) bprint("DYN_ARTFR ");
			bprint("- ignored, to use these - set: sv_pk_art 1\n");
		}
		DYN_ART = FALSE;
		DYN_ARTFR = FALSE;
	}
	else
	{
		DYN_ART = cvar("pk_dyn_art");
		DYN_ARTFR = cvar("pk_dyn_art_force");
	}

// test it
	if (pk_flags & PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR)
	{
		if (!DYN_OVR && !DYN_FORCE) DYN_ARTFR_ONLY = DYN_ARTFR;
		if (!find(world,classname,"dyn_spawner"))
		{
			pk_ditems = 0;
			e = spawn();
			if (e)
			{
				e.think = dyn_item;
				e.nextthink = time + DYN_START_TIME; // do this well after items spawn
			}
		}
	}
	else
	{
		e = find(world,classname,"dyn_spawner");
		while (e)
		{
			if (WARNING) bprint("*** Warning - dynamic items deactivated, spawner removed\n");
			e.nextthink = -1;
			remove(e);
			e = find(e,classname,"dyn_spawner");
		}
	}


	if (cvar("it_mapcode")) // print list of map codes available to console
	{
		local string cl;
		f = 1;
		while (f < 1024)
		{
			cl =  item_by_mcode(f);
			if (cl != null_string)
			{
				if (f < 10) bprint(" ");
				if (f < 100) bprint(" ");
				if (f < 1000) bprint(" ");
				bprint(ftos(f));
				bprint("  -  (bit: ");
				bit_print(MAXFL, bit_mcode(f, world)); // for use in bit masks
				bprint(")  ");
				bprint(cl);
				bprint("  -  (bv: ");
				bprint(ftos(bit_mcode(f, world)));
				bprint(")\n");
				if (cvar("it_mapcode") == 2) bprint("\n");			// extra visibility - harder to read on game screen, but great for bash console view
				else if (cvar("it_mapcode") == 4) bprint("-----------------------------------------------------------------------------\n"); 
			}
			f = f + 1;
		}
		bprint("map mode = ");
		bprint(MAP_MODE);
		bprint("\n");
		cvar_set("it_mapcode", "0");
	}

	if (cvar("it_make")) // create item at random location if map code valid
	{
		fn_make(cvar("it_make"), v0, null_string);
//		cvar_set("saved1", ftos(cvar("saved1") + 1)); // TEST
		cvar_set("it_make", "0");
	}

	item_control_menu();
}
// fn(pk_monitor) - some sv_ commands are continuosly monitored
// IDEA: chaos mod - chaos effect can turn this off, so chaos can muss vars.

void() pk_monitor =
{
	pk_liveupd();

// place item controls - wait for PIC_TO to do this
// 		not done in live update because we dont want it to fire off right after a map load when things are settling down
	if (pic_tsk != cvar("it_place_item"))
	if (!pic_tsk) // only init loop when it was intially off - every loop call starts more control ents
		place_item_control_loop();

	self.nextthink = time + 3 + random();
};

void() pk_srvcmd_load =
{
	if (!DARKPLACES && !chaos) return;

	local entity e;

// start the server monitor and loop cycle process after place item control time out (currently 5 secs)
	e = spawn();
	e.think = start_loopcyc;
	e.nextthink = time + PIC_TO + random() * 3;
	e.classname = "pk_loopcyc";

	e = spawn();
	e.think = pk_monitor;
	e.nextthink = time + PIC_TO;
	e.classname = "pk_monitor";

// set server flag bit stored states

	st_pk_sfx = st_pk_hub = st_pk_cmap = 0;
	if (!pk_flags & PK_TP_SPARKSFLASH) st_pk_sfx = 1;
	if (pk_flags & PK_SF_HUB) st_pk_hub = 1;
	if (pk_flags & PK_TP_USERMAPON) st_pk_cmap = 1;

	if (st_pk_sfx != cvar("sv_pk_sfx")) pk_bas_flags(PK_TP_SPARKSFLASH, st_pk_sfx);
	if (st_pk_hub != cvar("sv_pk_hub")) pk_bas_flags(PK_SF_HUB, st_pk_hub);
	if (st_pk_cmap != cvar("sv_pk_cmap")) pk_bas_flags(PK_TP_USERMAPON, st_pk_cmap);

// these all req. map reload for full effectiveness

	XMOD = cvar("sv_xtras");

	localcmd("exec cfg/map/pk_7.cfg\n"); // module X - wont exec until after first map load - this should be ok, because first map of server should always be a hub
	localcmd("exec cfg/map/pk_8.cfg\n");
	
	pk_liveupd(); // load live now, set all cfg changed vars
};

void() reload_map =
{
	if (deathmatch) // Cataboligne - 8.9.13 - change from old code that did a double map load
		localcmd("default_hub\n"); // MUST be encoded with changelevel so players dont loose morph state or archon points
	else
		localcmd("changelevel start\n"); // NOTE: returing to start strips players of items, but we currently cant de-map
};

void() pk_srvcmd_set =
{
// set mcodes - this means they can change and things like func_make that have fixed map codes might go wrong if the code changes in the future - DOH!
	mcode_load();

// server controls, default on for full feature set
	pk_mapcfg = 1;
	pk_srvcfg = 1;

// painkeep item ids that are ammo count stored
	PKID = PKPLUS_IT_EGO + PKPLUS_IT_TOMB + PKPLUS_IT_ACTOR + PKPLUS_IT_PHONE + PK_IT_GRAVITYWELL + PK_IT_TURRET + PK_IT_CANPAB + PK_IT_BEARTRAP;


/// this section assigns vars to default values - they will rule any engine not dp registercvar able or not customized as the glquake build we release
//				- it would be trivial to take the custom cvar section from the glquake build and add to _any_ engine...
//				IDEA: make that segment of pr_edict.c an includeable file

	XMOD = 1; // default is on now, this is an SOP switcheroo
	ULOKW = ULOKD = ULOK2 = ULOK3 = TRUE;

/*

 ye old depricated codes

	if (world.worldtype == IT0_WQ1) ULOKW = TRUE;
	else if (world.worldtype == IT1_WQ1) ULOKD = TRUE;
	else if (world.worldtype == IT3_WQ1) ULOK2 = TRUE;
	else if (world.worldtype == IT4_WQ1) ULOK3 = TRUE;
	else if (world.wad == null_string) ULOK3 = TRUE; // Cataboligne - 10.22.12 - was not detecting q3 maps by worldtype
*/

	ULOKHL = FALSE; // place holder - HL stuff not natively supported yet (if ever) - Cataboligne 10.12.12

	PK_SEVEN = cvar("pk_seven");
	PK_EIGHT = cvar("pk_eight");

// score deal

	m_score_rel1 = (serverflags & FL_SCORE1);
	m_score_rel2 = (serverflags & FL_SCORE2);

	ARCHON_FRAG = 1; // pts per frag
	ARCHON_ITEM = 0.05; // points per std item
	ARCHON_ART = 0.3; // points per artifact
	ARCHON_AMMO = 0.05; // points per std ammo
	ARCHON_AMMO_EXP = 0.07; // points per explosive ammo
	ARCHON_WEP = 0.1; // points per gen weapon
	ARCHON_WEP_EXT = 0.2; // points per advanced weapon
	ARCHON_MONSTER = 50; // 100 health at spawn = 2 pts
	ARCHON_RUNE = 1; // points added per rune every time run_runes runs - every 3 secs
	ARCHON_POINT = 1;
	ARCHON_GEN = 0.1; // generic points

// pk control
	ADMINLOCK = FALSE;
	XENV = FALSE;
	WARNING = FALSE;
	BOTFREEZE = 0;
	BOTCAM = 0;

	SV_FALLEN = 1;
	SV_HOLDING = 1;

// limits for exits with no detectable exits
	NOEXIT_TIMEOUT = 0;
	NOEXIT_FRAGLIMIT = 0;

// runes
	RUNES = 0;
	RUNE_CNT = 4;
	RUNE_MOVE = 10 + rint(random() * 5);
	RUNE_MASK_ALL =
	RUNE_MASK = 15;
	RUNE_3_ACM = 0.2;
	RUNE_AR1M = 0;
	RUNE_R1SFX = 0;

	RUNE_RANDOM = 0;
	R_EARTH = RUNE_FLG_RS; // allow power mix
	R_BLACK = RUNE_FLG_DM;
	R_HELL = RUNE_FLG_HS;
	R_ELDER = RUNE_FLG_RG;

	R_VAMPIRE = RUNE_VAMPIRE; // lith + extra
	R_AMMO = RUNE_AMMO; // here for items - not enabled yet
	R_FLY = RUNE_FLG_FLY;

	T_DSH = TECH_DSH; // lith techs
	T_AMP = TECH_AMP;
	T_TEIM = TECH_TEIM;
	T_ADOC = TECH_ADOC;

// hook codes - these should be set for non register cvar, unmoded engines
	HOOK = 0;
	HOOK_DMG = 0;
	HOOK_RANGE = 1200;
	HOOK_TIME = 0;
	HOOK_URTO = 0;
	HOOK_SPEED = 600;
	HOOK_DAMP = 0;
	LASER_HOOK = 0;
	LTN_HOOK = 0;

	if (cvar("sv_adm"))
		m_score_rel1 = m_score_rel2 = cvar("sv_adm");

	if (MAP_MODE == "Q2") LASER_HOOK = TRUE;
	else if (MAP_MODE == "Q3") LTN_HOOK = TRUE;
	if (!ULOK2) LASER_HOOK = FALSE;
	if (!ULOK3) LTN_HOOK = FALSE;

	if (LOK_STRICT)
	{
		if (!m_score_rel1)
		if (world.target1 == "score_rel1")
			XMOD = -666;

		if (!m_score_rel2)
		if (world.target1 == "score_rel2")
			XMOD = -666;
	}

// cam controls
	DCAMTO = 0; // RELEASE - final release default should have 2 mins & respawn
	DCAMTOACT = 0;
	FFW_LIMIT = 0;

	NOCIDE = 0;
	NOENVCIDE = 0;
	NOPKCIDE = 0;

// vw controls
	VW_ARMOR = FALSE; /// has issues - can be turned on with sv_vw_armor 1
	VW_HOLSTER = TRUE;
	VW = TRUE;
	var float autocvar_sv_centerwep = 0;

// dynamic item defaults
	DYN_SHOW = FALSE;
	DYN_OVR = FALSE;
	DYN_ART = TRUE;
	DYN_FORCE = FALSE;
	DYN_ARTFR = FALSE;
	DYN_FORCE_CNT = 6;
	PK_DYNTO = 120;
	pic_tsk = 0;

// morphic
	MORPH_CUBE_TIME = 120;
	MORPH_CUBE_DV = 40;
	MORPHIC = 0; // def: 2 ?
	MORPH_BOT = 1; // frik bot only
	MORPH_FREE = 0;
	morph_setup();

// monsters
	M_MONSTER = 0;
	S_MONSTER = 0;
	C_MONSTER = 0;

	M_MONSTER_II = 0;
	S_MONSTER_II = 0;
	C_MONSTER_II = 0;

	S_MONSTER_WAIT = 30; //60; // min wait till we respawn a dead mosnter
	S_MONSTER_DEV = 10;

	C_MONSTER_WAIT = 60;// 80; // how long till we spawn another random mosnter
	C_MONSTER_DEV = 20;
	C_MONSTER_CNT = 0;

	FAST_MONSTER = 0;
	SLOW_MONSTER = 0;
	R_FAST_MONSTER = 0;
	R_SLOW_MONSTER = 0;
	C_FS_MONSTER = 0;

	if (MON_SPEED_DIV <= 0) MON_SPEED_DIV = 1;

	if (XMOD == -666)
	{
		newmis = spawn();
		newmis.think = reload_map;
		newmis.nextthink = time + 0.666;
		return;
	}

// crates

	PK_CRATE = 0;

// pk cubes

	PK_CUBE = 0;
	PK_CUBE_TIME = 60;
	PK_CUBE_DV = 0;

	world.group = " - keep an eye out\n";

// map translations

	TR_Q1DEF = 1;
	TR_Q1QRY = 1; // run on map load
	TR_WOLF = 0;
	TR_DOOM = 0;
	TR_QUAKE = 0;
	TR_Q2 = 0;
	TR_Q3 = 0;
	TR_ALL = 0;
	TR_NOT = 2;

	NO_PI = 0;

	DOOM_ALPHA = 0;

// respawn times
	D_POWER_WAIT = 
	Q2_POWER_WAIT = 
	RSP_TIME = 30;

	Q3_POWER_WAIT = 4 * RSP_TIME;

// art power supply times
	D_POWER_TIME = 
	Q2_POWER_TIME = 
	Q3_POWER_TIME = 

	POW_TIME = 30;

	EXPLBOX_RESP = 1;

// defaults
	DEF_HEALTH = 0;
	DEF_ARMOR = 0;
	DEF_ITEMS = 0;
	DEF_PK_ITEMS = 0;
	DEF_WEAPON = 0;

	DEF_AMMO_BULLETS = 0;
	DEF_AMMO_SHELLS = 0;
	DEF_AMMO_CELLS = 0;
	DEF_AMMO_ROCKETS = 0;
	DEF_AMMO_NAILS = 0;
	DEF_AMMO_SLUGS = 0;
	DEF_AMMO_GAS = 0;

	D_ARMOR_MAX = Q_ARMOR_MAX;
	Q2_ARMOR_MAX = Q_ARMOR_MAX;

	DEF_X_ITEMS = 0;

	INIT_CON = 0;
	CHAR_CON = 1;

	INIT_0_W = 0;
	INIT_1_D = 0;
	INIT_2_Q = 0;
	INIT_3_PK = 0;
	INIT_4_Q2 = 0;
	INIT_5_Q3 = 0;
	INIT_6_HP = 0;
	INIT_7 = 0;

// 		 ammo
	Q1_SHELLAMMO_MAX				= 100;
	Q1_NAILAMMO_MAX					= 200;
	Q1_ROCKETAMMO_MAX				= 100;
	Q1_CELLAMMO_MAX					= 200; // pk amount

	PK_BULLETAMMO_MAX				= 200;
	PK_SLUGAMMO_MAX					= 50;
	PK_GASAMMO_MAX						= 400;
	
// item ammo levels
	PK_GRAVITYWELLAMMO_MAX	= 1;
	PK_TURRETAMMO_MAX				= 3;
	PK_CANPABAMMO_MAX			= 1;
	PK_BEARTRAPAMMO_MAX		= 3;

	PK_EXPLODEAMMO_MAX	= 10;
// plus items
	PKPLUS_EGOAMMO_MAX			= 2;
	PKPLUS_TOMBAMMO_MAX		= 3;
	PKPLUS_ACTORAMMO_MAX	= 1;
	PKPLUS_PHONEAMMO_MAX	= 1;

// armor bits
	IT_ARMOR_BITS = IT_ARMOR1 + IT_ARMOR2 + IT_ARMOR3;

	IMP_DROPI = IMP_DROPI_ACT; // allow inv drop by default

	SV_AMMO_MAX = FALSE;

	PK_MAX_LIVENT = 256; // guessed - need research into where slowdown starts

	DEAD_THROW = 0;
	DEAD_THROW_ARMOR = 0;
	DEAD_THROW_PKI = 0;
	DEAD_XPACK = 1;
	DEAD_GIBPACK = 1;

	X_CHGLVL = 1;

	x_item_dm_giveaway = 0;

// weps

	GRENADE_VEL = 600;
	HGREN_VEL = 200;
	PLASMA_VEL = 600;
	LASERCAN_VEL = 1000;
	LASER_VEL = 600;
	ROCKET_FUSE = 5.0;
	WEPHUM = 1;
	Q2_SILENCE = 0.2; // 20% vol default

	LASER_FLY = 5;
	LASER_BOUNCE = 3;

// pk artifacts
	PK_ART = TRUE; // Cataboligne - 8.12.9 - pk artifacts support

// chaos stuff

CHAOS_UNSTABLE_TELE = 0.9; // TEST 0.3;

// not an enabled / wise engine - we must return now, no live server controls are possible and we are running on defaults

	if (!DARKPLACES && !chaos) 
	{
		XMOD = 0; // for release - other engines have to use saved1 hack
//		XMOD = 1; // for now - "assume the sale" only way to handle non-enabled engines, once we go to chaos-mod this is an issue because the paks may not be installed
		return;
	}

// new server controls
// NOTE: chaos eng mod contains all these

	if (DARKPLACES) // reg under darkplaces - chaos engine has pre-reg
	{
// csqc - HUD, etc

// AST_STRING = 1 --- see pk.defs for other STAT_* number value idents
// AST_FLOAT = 2

		addstat(33, 2, mcode);
		addstat(34, 2, rune_flag);
// pk 
		addstat(35, 2, pk_explode_ammo);
		addstat(36, 2, pk_items); // only detects 3 inv weps
		addstat(37, 2, pk_currentitem); // current wep
		addstat(38, 2, pk_gravitywellammo); // pk ammos
		addstat(39, 2, pk_turretammo); // pk ammos
		addstat(40, 2, pk_beartrapammo); // pk ammos
		addstat(41, 2, pk_canpabammo); // pk ammos
		addstat(42, 2, pkplus_tombammo); // pk ammos
		addstat(43, 2, pkplus_egoammo); // pk ammos
		addstat(44, 2, pkplus_phoneammo); // pk ammos
		addstat(45, 2, pkplus_actorammo); // pk ammos
// enhanced
		addstat(46, 2, ammo_bullet); // enh ammos
		addstat(47, 2, ammo_slug); // enh ammos
		addstat(48, 2, ammo_gaspr); // enh ammos

//		addstat(50, 1, stack1); // target string
//		addstat(51, 1, stack2); // target string

		addstat(64, 2, volume);
		addstat(65, 2, morphy);
		addstat(66, 2, archon);
	}
/*
		if (pk_srvcmd)
		{
			localcmd("d");
			localcmd(ADMINSRVCMD);
			localcmd(mapname);
			localcmd(ADMINSRVCMD);
		}
*/
// these MUST be rest every map.  EVERY map

	cvar_set("sv_bot_noway_below", "0"); // no bot waypoints below this
	cvar_set("sv_bot_noway_above", "0"); // bot bot waypoints above this

// server controls - override immediately
		pk_mapcfg = cvar("sv_c_mapcfg");
		pk_srvcfg = cvar("sv_c_srvcfg");
		ADMINLOCK = cvar("sv_c_adminlock"); // so server admin can lock out remote admins in case of abuse - local console commands will still work

// for dedicated server
		if (pk_mapcfg) // cfg file cmd
		{
			localcmd("exec cfg/map/");
			localcmd(mapname);
			localcmd(".cfg\n");
		}
// NOTE: chaos eng doesnt need to store defaults this way - they will save in config.cfg


		if (!deathmatch)
		{
			if (!cvar("sv_qstart"))
			{
				localcmd("exec cfg/sp_server.cfg\n");
			}
		}
		else
		if (pk_srvcfg)
		{
			if (!cvar("sv_dmstart"))
			{
				localcmd("exec cfg/d_server.cfg\n");
			}
			localcmd("exec cfg/map/");
			localcmd(mapname);
			localcmd("_server.cfg\n");
		}

	pk_srvcmd_load();
};

// called from many places - handles pk_mode 0 where map sets whether or not we use PK stuff

// really sound(), mod for frikbot code
// called from sound(...) in frikbot/bot.qc

void(entity e, float chan, string samp, float vol, float atten) pk_sound = 
{
	local string psamp;
	local float svol;

	svol = vol;
	psamp = samp; // sample that actually plays

	if (!PK)
	{
		if (samp == "ambience/windfly.wav") psamp = "alt_ambience/windfly.wav";
		if (samp == "items/r_item2.wav") psamp = "alt_sounds/items/r_item2.wav";
		if (samp == "misc/secret.wav") psamp = "alt_sounds/misc/secret.wav";
	}

// q2 silencer for wep channel stuff
	if (chan == CHAN_WEAPON)
	if (e.silencer_finished)
	{
		if (e.silencer_finished > time)
		{
			svol = vol * Q2_SILENCE;
		}
		else
		{
			e.silencer_finished = 0;
			sprint (e, "Silencer used up\n");
		}
	}

// pk_sound() - fn() here plays actual sound
	frik_sound(e, chan, psamp, svol, atten);
};

void(vector pos, string samp, float vol, float atten) ambientsound =
{
	local string psamp;

	psamp = samp; // sample that actually plays

	if (!PK) // not in PK mode, play alternate sounds
	{
		if (samp == "ambience/fl_hum1.wav") psamp = "alt_ambience/fl_hum1.wav";
		else if (samp == "ambience/buzz1.wav") psamp = "alt_ambience/buzz1.wav";
//		else if (samp == "ambience/fire1.wav") psamp = "alt_ambience/fire1.wav";
		else if (samp == "ambience/suck1.wav") psamp = "alt_ambience/suck1.wav";
		else if (samp == "ambience/drone6.wav") psamp = "alt_ambience/drone6.wav";
		else if (samp == "ambience/buzz1.wav") psamp = "alt_ambience/buzz1.wav";
		else if (samp == "ambience/drip1.wav") psamp = "alt_ambience/drip1.wav";
		else if (samp == "ambience/comp1.wav") psamp = "alt_ambience/comp1.wav";
//		else if (samp == "ambience/thunder1.wav") psamp = "alt_ambience/thunder1.wav";
		else if (samp == "ambience/fl_hum1.wav") psamp = "alt_ambience/fl_hum1.wav";
		else if (samp == "ambience/swamp1.wav") psamp = "alt_ambience/swamp1.wav";
		else if (samp == "ambience/swamp2.wav") psamp = "alt_ambience/swamp2.wav";
		else if (samp == "ambience/hum1.wav") psamp = "alt_ambience/hum1.wav";
		if (psamp != samp) precache_sound(psamp);
	}
	pk_ambientsound(pos, psamp, vol, atten);
};

// called from below
void() get_teleport_sounds =
{
	local	float v;

	v = random() * 4;
	if (world.wad == "q2.wad")
	{
		normalsound = "q2_snd/telep1.wav";
		reversesound = "q2_snd/telep1.wav";
	}
	else if (v < 1)
	{
		normalsound = "misc/teleport/tele_1.wav";
		reversesound = "misc/teleport/tele_1a.wav";
	}
	else if (v < 2)
	{
		normalsound = "misc/teleport/tele_2.wav";
		reversesound = "misc/teleport/tele_2a.wav";
	}
	else if (v < 3)
	{
		normalsound = "misc/teleport/tele_3a.wav";
		reversesound = "misc/teleport/tele_3a.wav";
	}
		else
	{
		normalsound = "misc/teleport/tele_4.wav";
		reversesound = "misc/teleport/tele_4a.wav";
	}
};

// called from below

void() play_teleport2 =
{
	get_teleport_sounds();
	SOUND_GOT = TRUE;

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);		
	else
	sound (self, CHAN_VOICE, reversesound, 1, ATTN_NORM);
	remove (self);
};

// called from teleport touch

// s2 - special sound to play

void(vector org, string s2) spawn_tfog2 =
{
	local entity e;
	e = spawn ();
	e.origin = org;
	e.nextthink = time + 0.2;
	e.think = play_teleport2;
	e.noise = s2;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

