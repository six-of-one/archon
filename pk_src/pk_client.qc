/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: pk_client.qc
 *
 * date: Mon Jun 21 UTC 2010
 *
 * final qc
 *
 */

// special parms - for respawn

void() q100_SetChangeParms;
void() q100_SetNewParms;
void() q100_DecodeLevelParms;
float	modelindex_eyes, modelindex_player;
void () q100_ClientKill;
void () set_suicide_frame;
void () respawn;
void() q100_PutClientInServer;
void() player_stand1;
void() player_pain;
void() PlayerDie;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void () q100_ClientConnect;
void () q100_ClientDisconnect;
void () ExitIntermission;
void () IntermissionThink;
void () q100_CheckPowerups;


void() SetNewParms_PK =
{
	parm1 = 0; // IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm4 = -25;
	parm3 = parm5 = parm6 = parm7 = parm9 = 0;
	parm8 = 1;
	parm16 = MOTDTIME + 1;

	parm10 = parm11 = parm12 = 0;
	if(self.pk_items & PK_IT_EXTRADISP)
	{
		parm16 = parm16 | PK_IT_EXTRADISP;
	}

// Cataboligne 2.18.11 - set defaults code
	if (!Q_100 && !PK_100)
		parm6 = -6;

	cam_parms(2);
};

// called from engine - saves off pk parms for level change

void() SetChangeParms =
{
	if (find(world,classname,"pk*bot")) bot_changeParms();

	if (Q_100)
	{
		q100_SetChangeParms();
		return;
	}
// Cataboligne 9.11.3 purify - chase cam
	cam_parms(0);

	if (self.class_select == "class_player")
		parm15 = self.morphy;

	if (self.health <= 0 || self.classname == OBSERVER) // Cataboligne - 5.3.10 - fix level change issue when in dead observer or admin observer
	{
		morph_clearparms(self, TRUE);
		SetNewParms_PK();
		parm16 = parm16 | 256; // Cataboligne - 8.22.9 - pk orig oper
		return ;
	}

	// code xweaps - return poss map code for parm & clear items

	parm3 = self.mcode;

	if (self.scode & 512) // had a grapple - zip out bit, so an xwep grap doesnt become a pk grapgun
	{
		self.scode = self.scode - 512;
		self.pk_items = self.pk_items - (self.pk_items & PK_IT_GRAPGUN);
	}
// remove items
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_SUPERHEALTH | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD | self.scode));

	self.health = ceil(self.health / self.health_modifier); // morph back to human level

// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;

	parm1 = self.items;
	parm2 = self.health;
	armorsave_rev(self);
//	parm3 = self.armorvalue; // put in parm9
	parm4 = self.ammo_shells;

/* cant do here - if died, doesnt have gun yet
	if (self.ammo_shells < 25)
	if (self.mask_x & CB_HUMAN) // only humans get 25 shell ammo depot deal
	{
		if (self.items & (IT_SHOTGUN | IT_SUPER_SHOTGUN))
			parm4 = 25;
	}
*/

	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = (self.armortype * 100) + (self.armorvalue * 256);
	parm10 = parm11 = parm16 = 0;

	parm10 = PK_IT_AXE | self.pk_items;

// recode so *bot can have vars for skill level save - provide max inventory of 15 for mod expansion, current max is 3 on most except for explode ammo

// there are 2 more 2 bit sets above phone ammo - v * 1048576, v * 4194304

	parm11 = self.pk_explode_ammo + ((self.pk_turretammo & 3) * 16) + ((self.pk_canpabammo & 3) * 64) + ((self.pk_beartrapammo & 3) * 256) + ((self.pk_gravitywellammo & 3) * 1024)

// Cataboligne 8.12.9 purify - pk artifacts
	 + ((self.pkplus_egoammo & 3) * 4096) + ((self.pkplus_tombammo & 3) * 16384) + ((self.pkplus_actorammo & 3) * 65536) + ((self.pkplus_phoneammo & 3) * 262144);
// end pk_art

	// do hub message.
	parm16 = self.msgcount | 256; // | (self.pk_items & PK_IT_EXTRADISP);
};

// called from vars - clears pk parms

void() SetNewParms =
{
	if (Q_100)
	{
		q100_SetNewParms();
		return;
	}

	parm1 = 0; // IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm3 = 0;
	parm4 = -25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;

	parm10 = parm11 = parm12 = 0;
// do hub message.
	parm16 = 256;

	if (pk_flags & PK_TP_STATUSON)
	{
		parm16 = parm16 | PK_IT_EXTRADISP;
	}

	parm15 = -1;

// Cataboligne 2.18.11 - set defaults code
	if (!Q_100 && !PK_100)
		parm6 = -6; // no rockets anyway, so we use this to call default func

// Cataboligne 9.11.3 purify - chase cam
	cam_parms(2);
};

// called from PCIS - restores pk parms on new level


void() DecodeLevelParms = 
{
	if (Q_100)
	{
		q100_DecodeLevelParms();
		return;
	}

	if (!deathmatch || !ENHANCED) // Cataboligne - enhanced code - dont do this in DM
	if (serverflags)
	{
		if (world.model == "maps/start.bsp" && !inHubMap) // Cataboligne - 5.19.10 - q1 SP hack for using forced dyn items
			SetNewParms ();   // take away all stuff on starting new episode
		if (world.model == "maps/qstart.bsp") SetNewParms();
	}
//	bot_skinDecode();
	if (parm3) set_xweap(self, parm3);
	self.mcode = parm3;

	self.items = parm1;
	self.health = parm2;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	if (parm6 > 0) self.ammo_rockets = parm6;
	else self.ammo_rockets = 0;
	self.ammo_cells = parm7;
	self.weapon = parm8;

	self.armorvalue = ceil((parm9 &  16776960 ) / 256); // maxfl - 255
	self.armortype = (parm9 & 255) * 0.01;

	self.pk_items = parm10 | (parm16 & PK_IT_EXTRADISP); // fix PK mode false map to PK mode true map
	self.pk_explode_ammo = parm11 & 15;
	self.pk_turretammo = floor(parm11 / 16) & 3;
	self.pk_canpabammo = floor(parm11 / 64) & 3;
	self.pk_beartrapammo = floor(parm11 / 256) & 3;
	self.pk_gravitywellammo = floor(parm11 / 1024) & 3;

// Cataboligne 8.12.9 purify - pk artifacts
	self.pkplus_egoammo = floor(parm11 / 4096) & 3;
	self.pkplus_tombammo = floor(parm11 / 16384) & 3;
	self.pkplus_actorammo = floor(parm11 / 65536) & 3;
	self.pkplus_phoneammo = floor(parm11 / 262144) & 3;
// end pk_art

	self.msgcount = (parm16 & 255);

	if (self.class_select == "class_player") // a level change happened, this is not a bot, parm15 is valid - set it
	if (cb_morph(parm15)) // set only if valid - respawn hack deal
		self.morphy = parm15;

// char init

	if (!cb_morph(self.morphy))
	{
		self.morphy = IMP_MHUMAN; // base human - quake guy
		if (CHAR_CON)
		if (CHAR_CON >= CHAR_W && CHAR_CON  <= CHAR_Q3) self.morphy = CHAR_CON; // forced by server admin
		else self.morphy = set_char_num(MAP_MODE);
	}
	if (PK_100) self.morphy = IMP_MHUMAN;

	self.mask_x = cb_morph(self.morphy);

	if (self.mask_x & CB_HUMAN)
	{
		 self.items = self.items | IT_SHOTGUN | IT_AXE; // make sure humans have def weps before calling def

		if (self.ammo_shells < 25)
		{
			self.ammo_shells = 25;
		}
	}

	self.x_items = 0; // clear prior to defaults - cant clear again after that, and giveway must be added
// NOTE: *** morphy MUST be set prior to this call!
	if (parm6 == -6) set_defaults(self); // only done on respawn or spawn where we are clearing parms because of dead

// Cataboligne 9.11.3 purify - chase cam
	cam_parms(1);
};

void() PK_GotoNextMap =
{
	if (!Q_100 && !Q_99 && !PK_ADMINMAP)
	if (pk_flags & PK_TP_USERMAPON) // *pk - user supplied map loop deal
	{
		if (!execed)
		{
			execed = 1;
			localcmd ("pknextmap\n"); // alias loop trick to run a map loop - depending on engine, might need -zone {numeric}
		}
		return;
	}

	if(!PK_100 && !PK_ADMINMAP) 
	{
		if (check_custom_hub()) // *pk --- Cataboligne - 8.16.9 - do custom hub load from any exit here
			return;
	}
};

/*
============
ClientKill

Player entered the suicide command
============
*/

void () ClientKill =
{
	if (Q_100)
	{
		q100_ClientKill();
		return;
	}
	dead_drop(self); // Cataboligne - 10.7.11 - drop runes+
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame();
	self.modelindex = self.modelindex_morph;
	self.frags = self.frags - 2 * frag_minus_cide(self);	// extra penalty
	respawn ();
};

// called from PutClientInServer

void(entity spot) ClearSpawnPoint =
{
	local	entity thing;

	if (deathmatch < 2)
		return;

	thing = findradius(spot.origin, 80);
	while(thing)
	{
	 if (thing.solid == SOLID_TRIGGER && thing.takedamage == DAMAGE_NO &&
	 			thing.classname != "trigger_teleport")
	 {
	 	// crash point!!!
		// make it respawn...
		thing.solid = SOLID_NOT;
		 thing.model = string_null;
		thing.nextthink = time + 10;
		 thing.think = SUB_regen;
	 }
	 else if (thing.think == SUB_regen)
	 {
		thing.nextthink = thing.nextthink + 10;
	 }

	 thing = thing.chain;
	}
};

// called from PutClientInServer

// notes: does not include info_player_start - regular q1 dm spawn select does
//			 if in single player & PK mode set for pk items, spawn is random.

// fixing these if not in PK_100

// IDEA: if no spawns, use whatever is available - ammo, teleports, etc. - dont give away goodies

entity() PK_SelectSpawnPoint =
{
	local	entity spot, newspot, thing;
	local	float	numspots, totalspots;
	local	float	rnum, pcount;
	local	float	rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels - NOTE: if this ever spawns, this is DUMB code for dm
	spot = find (world, classname, "testplayerstart");
	if (PK_100 || (!deathmatch && !coop) || cvar("saved1") == 666) // if a developer wanted this in dm | coop they need to set saved1
	if (spot)
		return spot;

// choose a info_player_deathmatch point

// not PK_100 - support single player & coop - hey this is a request

 if (!PK_100)
 {
	if (coop)
	{
		lastspawn = find (lastspawn,classname,"info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn,classname,"info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (!deathmatch)
	{
		if (serverflags & 15)
		{	// return with a rune to start
			spot = find (world,classname,"info_player_start2");
			if (spot)
				return spot;
		}

		spot = find (world,classname,"info_player_start");
		if (!spot)
		{
			if (PK_100 && PK_100_OBJERR)
				error ("PutClientInServer: no info_player_start on level");
			else
				bprint ("*** Warning: PutClientInServer: no info_player_start on level - looking for dm start");
		}
		else
			return(spot);
	}
 }
 
// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");
// IDEA: if there are no dm spawns, and dm is set & !PK_100, make some (cvar control?)
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 256);
		pcount=0;
		while (thing)
		{
			if (thing.classname == "player" || thing.classname == "pk*bot") // NOTE: could be reason for bot spawn frag bork - didnt see pk*bot
				pcount=pcount + 1;
			thing=thing.chain;
		}
		if (pcount == 0) {
			spot.goalentity = spots;
			spots = spot;
			numspots = numspots + 1;
		}

		// Get the next spot in the chain
		spot = find (spot, classname, "info_player_deathmatch");
	}
	totalspots=totalspots - 1;
	if (!numspots)
	{
		// ack, they are all full, just pick one at random
//		bprint (PRINT_HIGH, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, "info_player_deathmatch");
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, "info_player_deathmatch");
		}
		if (spot || PK_100) return spot;
	}

// We now have the number of spots available on the map in numspots

	// Generate a random number between 1 and numspots

	numspots = numspots - 1;

	numspots = rint((random() * numspots) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	if (spot || PK_100) return spot;
	
	spot = find_tdest(0, "");
	return spot; // this better pretty damn well be somewhere in the level

};

// config players for admin on spawn & map for players if cfg avail

// code sets admin kby config & tries to run map commands - {mapname}.cfg file and any alias {mapname}_mapcmd

void() pk_plcfg =
{
	if (self.class_select == "class_player")
	{
		crosshair_off(self); // save at init
		pk_admincfg(self);
		if (pk_mapcmd) // alias cmd
		{
			stuffcmd(self, mapname);
			stuffcmd(self, ADMINMAPCMD);
		}
		if (pk_mapcfg) // cfg file cmd
		{
			stuffcmd(self, "exec ");
			stuffcmd(self, mapname);
			stuffcmd(self, ".cfg\n");
		}
// q3 map cfg
		if (DARKPLACES)
		{
			stuffcmd(self, Q3_BOBHOFF);
//			if (!pk_map) // not a pk map (some hubX maps have no .wad!)
//			if (world.wad == "") // q3 map? - then set bob
			if (!Q_100 && !PK_100)
			if (MAP_MODE == "Q3")
				q3_bob_height();
		}
// web site segment
		stuffcmd(self, "alias version \"echo quake-c: chaos archon alpha 3.0\"\n");
		stuffcmd(self, "alias website \"echo http://www.moddb.com/mods/chaos-archon/\"\n");
		stuffcmd(self, "alias devsite \"echo http://www.moddb.com/members/invadercat/\"\n");
		stuffcmd(self, "alias qcsite \"echo http://www.moddb.com/groups/qc/\"\n");
		stuffcmd(self, "alias sites \"echo website  http://www.moddb.com/mods/chaos-archon/;echo devsite http://www.moddb.com/members/invadercat/;echo qcsite   http://www.moddb.com/groups/qc/\"\n");

		stuffcmd(self, "infobar 30 \"you are playing: Archon 3.1 alpha\"\n");
	}
};

// called from PutClientInServer

//void() PK_CIS =
void() PutClientInServer =
{
	local entity spot;
	local float f;

	set_initBotLevel(); // *bot
	self.button16 = 0; // bot fixer

	self.admin = 0;
	self.rune_flag = 0;

	f = cvar("scratch3");
	if (f < 0 && !deathmatch && !coop) // morphic single player - because the server is reloaded every restart
	{
		parm15 = self.morphy = fabs(f);
		cvar_set("scratch3","0");
	}

	if (Q_100 || Q_99)
	{
		if (Q_99)
		{
			AddToSplashBig(self);
		}
		Chase_cam_level_start(); // Cataboligne 8.9.9 purify - chase cam
		q100_PutClientInServer(); // always encoding now
		return;
	}

	spot = PK_SelectSpawnPoint (); // *pk - get a spawn point, pk style 
	ClearSpawnPoint(spot); // *pk

	self.classname = "player";
	self.health = 100;
	self.max_health = 100;
	self.health_modifier = 1.0;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.wetsuit_finished = 0;
	self.empathy_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

// morphic
	self._stand = SUB_Null; // make sure these are safe & detectable
	self._pain = SUB_Null;
	self._run = SUB_Null;
	self._impulse = SUB_Null;
	self._hk_lesser = SUB_Null;
	self._hk_major = SUB_Null;
	self._attack = SUB_Null;
	self._jump = SUB_Null;
	self._jump2 = SUB_Null;
	self._die = SUB_Null;
	self._summon = SUB_Null;
	self._alt_fire = SUB_Null;
	self._killmsg = SUB_Null;
	self._killmsg2 = SUB_Null;

	DecodeLevelParms (); // note: sets char

//	W_SetCurrentAmmo (); // moved for m0rphic

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;

	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;

//	spot = SelectSpawnPoint ();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

// morphic stuff
	setmodel (self,"progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self,"progs/player.mdl");
	self.modelindex_morph = self.modelindex;

	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);

	self.view_ofs = ' 0 0 22';

	if (self.health_modifier <= 0) self.health_modifier = MHUMAN_HEALMOD;

	if  (cvar("anode"))
//	if (1) // TEST:
	{
		self.morphy = IMP_MANODEX;
		stuffcmd(self, "exec anode.cfg\n");
	}
	else
		stuffcmd(self, "exec archon.cfg\n");

//	self.morphy = IMP_MGREMLIN_F; // TEST:
	polymorph_check(self.morphy, self.morphy); // become incarnation

	if (self.ammo_shells < 0) // stop the morph ammo factory - morphs do not start with 25 shells
	{
		if (self.mask_x & CB_HUMAN) self.ammo_shells = 0 - self.ammo_shells;
		else self.ammo_shells = 0;
	}

	W_SetCurrentAmmo (); // moved for m0rphic
	player_stand1 ();

	if (deathmatch || coop)
	{
		makevectors (self.angles);
		spawn_tfog (self.origin + v_forward*20);

// Cataboligne - 9.13.11 - x_item giveaway for doors - only set by doors in dm

		self.x_items = self.x_items | x_item_dm_giveaway; // we could have set defaults
	}

	spawn_tdeath (self.origin,self);

// pk stuff below
	pk_plcfg();
	self.pk_items = self.pk_items | PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP
																	| PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE; // Cataboligne 8.12.9 purify - pk artifacts

	grap_releaseHarpoon();
	self.pk_currentInventory = self.pk_currentitem = PK_IT_AXE;
	self.beartrap_time = 0;
	self.bt_immune_time = time + BT_BUFFER;
	self.voteIntermission = 0;

	self.skin = 0;

	self.grap_owner = world;

	self.bolt_target = world;
	self.bolt_targetNext = world;
	self.bolt_targetTimeout = 0;
	self.bolt_targetNextTimeout = 0;
	if (self.bolt_targetTimeoutEntity)
	{
		remove(self.bolt_targetTimeoutEntity);
	}
	self.bolt_targetTimeoutEntity = world;
	self.bolt_conduitTimeout = 0;
	self.bolt_changeModelTimeout = 0;
	if (self.bolt_lightningFire)
	{
		remove(self.bolt_lightningFire);
	}
	self.bolt_lightningFire = world;

// PK - not a disconnected player entity
	self.disconnectPlayer = 0;
// end CIS stuff

// set wep cycle vars
	self.lastweapon = self.weapon;
	self.prevweapon = self.weapon;
	self.pklastweapon = self.pk_currentitem;
	self.pkprevweapon = self.pk_currentitem;

	stuffcmd(self, CL_BOBSET); // restore bobing - may have come from a hub vote

	self.pkplus_actortype = 0; // Cataboligne 8.12.9 purify - pk artifacts

//	if (!PK) return;

	if (inHubMap)
	{ // give the respawn guy a fighting chance...
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 15;

		// PAINKEEP timeout for the hub "how to vote" message.
		if (parm16 & 256)
		{
			self.hubstartupmessage = time + 15;
		}
	}

	// PAINKEEP SPLASH Make this entity splash
	AddToSplashBig(self);
	
	ominous_hum("", 1); // clear any stray hum

	// PAINKEEP Fix the velocity on respawn bug
	self.velocity = '0 0 0';

	Chase_cam_level_start(); // Cataboligne 8.9.9 purify - chase cam
};

/*
cant find the sound files

// called from playerjump - commented out, not really called
// NOTE: recoded to override the default jump sound to minimize changes

void() pk_jump_sound =
{
	local float rs;
	rs = rint((random() * 4) + 1);

	if (rs == 1)
		sound (self, CHAN_BODY, "player/jump_1.wav", 1, ATTN_NORM);
	else if (rs == 2)
		sound (self, CHAN_BODY, "player/jump_2.wav", 1, ATTN_NORM);
	else if (rs == 3)
		sound (self, CHAN_BODY, "player/jump_3.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_BODY, "player/jump_4.wav", 1, ATTN_NORM);
};

// called from water_move - same deal

void() pk_gasp_sound =
{
	if (self.air_finished < time)
	{
	 	local float rs;

		rs = rint((random() * 2) + 1);

		if (rs == 1)
			sound (self, CHAN_BODY, "player/gasp_2.wav", 1, ATTN_NORM);
		else if (rs == 2)
			sound (self, CHAN_BODY, "player/gasp_3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/gasp_4.wav", 1, ATTN_NORM);
	}
	else if (self.air_finished < time + 9)
	{
			if (random() < 0.5)
				sound (self, CHAN_VOICE, "player/gasp_1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "player/gasp_5.wav", 1, ATTN_NORM);
	}
}
*/
/*
================
CheckPowerups

Check for turning off powerups
================
*/

void () CheckPowerups =
{
	if (Q_100)
	{
		q100_CheckPowerups();
		return;
	}

	if (time & 15 == 12)
	{
		stuffcmd(self, "con_notify 4\n");
		stuffcmd(self, "con_notifytime 3\n");
		stuffcmd(self, "con_notify_alias\n"); // for notify default
	}

	if (self.classname == OBSERVER) // Cataboligne 8.9.9 purify - chase cam (dead) & observer - clear all effects
	{
		morph_clearparms(self, TRUE);
		return;
	}						// NOTE: great place for some interesting chaos effects

	if (self.health <= 0)
		return;

	if (self.class_select == "class_player")
	if (self.x_items & X_PWR_ARMOR_ON || self.x_items & X_PWR_SCREEN_ON)
	{
		if ((time & 3) == 3 || (time & 3) == 2)
		{
			if (self.armorvalue <1) self.armorsave = -1;
			if (!self.armorsave) self.armorsave = self.armorvalue;
			self.armorvalue = self.ammo_cells;
		}
		else
			armorsave_rev(self);
	}
	else
		armorsave_rev(self);

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished > 0) // drop item
		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				if (self.group)
				{
					sprint (self, self.group);
					self.group = "";
				}
				else
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}

			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_INVISIBILITY);
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}

	// use the eyes
		self.frame = 0;
		
		if (self.mask_x & CB_HUMAN)
			self.modelindex = modelindex_eyes;
		else
			self.modelindex = 0;
	}
// else // so tossing the ring can clear this
	if (!self.invisible_finished)
		self.modelindex = self.modelindex_morph;	// don't use eyes

	// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished > 0) // drop item
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				if (self.group)
				{
					sprint (self, self.group);
					self.group = "";
				}
				else
				if  (self.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
					sprint (self,"Get ready to leave the RED stage - Good Performance!\n");
				else
					sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_INVULNERABILITY);
			self.invincible_time = 0;
			self.invincible_finished = 0;
			if (self.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
			{
				self.pkplus_actortype = 0;
				pk_setDamageSkin(self); // remove the pent costume
			}
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

// super damage
	if (self.super_damage_finished)
	{
// sound and screen flash when items starts to run out

		if (self.super_damage_finished > 0) // drop item
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (self.group)
				{
					sprint (self, self.group);
					self.group = "";
				}
				else
				if (self.pkplus_actortype == PKPLUS_ACTORQUAD) // pk art code here
					sprint (self,"The BLUE Curtain is dropping - You really frightened them!\n");
				else
					sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_QUAD);
			self.super_damage_finished = 0;
			self.super_time = 0;
			if (self.pkplus_actortype == PKPLUS_ACTORQUAD)
				self.pkplus_actortype = 0;
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}


// suit
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished > 0) // drop item
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				if (self.group)
				{
					sprint (self, self.group);
					self.group = "";
				}
				else
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				if (self.noise3 != "")
					sound (self, CHAN_AUTO, self.noise3, 1, ATTN_NORM);
				else
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_SUIT);
			self.rad_time = 0;
			self.radsuit_finished = 0;
// turn off suit skins
			if (self.mask_x & CB_HUMAN)
			if (self.skin > 4)
			{
				self.skin = 0;
				pk_setDamageSkin(self);
			}
		}
	}

	if (self.wetsuit_finished) // hip wetsuit , q2 rebreather
	{
		self.air_finished = time + 12;		// don't drown

		if (self.wetsuit_finished > 0) // drop item
		if (self.wetsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				if (!self.items & IT_SUIT)
				{
					if (self.group)
					{
						sprint (self, self.group);
						self.group = "";
					}
					else
					sprint (self, "Air supply in Re-breather expiring\n"); // IDEA: item stored messages
					sound (self, CHAN_AUTO, "q2_snd/airout.wav", 1, ATTN_NORM);
				}
				else
				{
				if (self.group)
				{
					sprint (self, self.group);
					self.group = "";
				}
				else
				sprint (self, "Air supply in Enviro suit expiring\n");
//				sound (self, CHAN_AUTO, self.noise3, 1, ATTN_NORM);
				sound (self, CHAN_AUTO, "q3_snd/airout.wav", 1, ATTN_NORM); // IDEA: make item store .noise3 work
				}

				stuffcmd (self, "bf\n");
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.wetsuit_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_SUIT); // re-breather does not set suit flag
			self.rad_time = 0;
			self.wetsuit_finished = 0;
// turn off suit skins
			if (self.mask_x & CB_HUMAN)
			if (self.skin > 4)
			{
				self.skin = 0;
				pk_setDamageSkin(self);
			}
		}
	}

//MED
// empathy shields
	if (self.empathy_finished)
	{
// sound and screen flash when items starts to run out
		if (self.empathy_finished > 0) // drop item
		if (self.empathy_finished < time + 3)
		{
			if (self.empathy_time == 1)
			{
				if (self.group)
				{
					sprint (self, self.group);
					self.group = "";
				}
				else
				sprint (self, "Empathy Shields are running out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.empathy_time = time + 1;
			}

			if (self.empathy_time < time)
			{
				self.empathy_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.empathy_finished < time)
		{	// just stopped
//MED
//         self.items2 = self.items2 - HIP_IT_EMPATHY_SHIELDS;
			self.empathy_time = 0;
			self.empathy_finished = 0;
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
//MED
		else
			self.effects = self.effects | EF_DIMLIGHT;
	}
};

/*
===========
WaterMove

============
*/
void () q100_WaterMove;

void () WaterMove =
{
	local float f;
	local float ISL,drown; // new drown test
	local entity e;

	if (self.classname == OBSERVER) // Cataboligne 8.9.9 purify - chase cam (dead) & observer - no water stuff
		return;

	if (Q_100 || PK_100)
	{
		q100_WaterMove();
		return;
	}

//dprint (ftos(self.waterlevel));

	if (DARKPLACES)
	if (self.watertype == CONTENT_WATER)
	{
		surfnum  = getsurfacenearpoint(world, self.origin); // NOTE: does not continuosly detect = fail FIX:
		if (surfnum >= 0)
		{
			f = FALSE;
	
			surface = getsurfacetexture(world, surfnum);
			if (surface == "*teleport") f = TRUE; // teleport is not water, cant swim. cant drown
			if (surface == "*teleport2") f = TRUE;
			if (surface == "*teleport_pk") f = TRUE;
			if (surface == "*teleport_pk2") f = TRUE;
			if (surface == "*teleport_pk3") f = TRUE;
			if (surface == "*hellaport") f = TRUE;
			if (surface == "*time") f = TRUE;
			if (surface == "*tele1") f = TRUE;
			if (surface == "*tele_t1") f = TRUE;

			if (f)
			{


// TEST:
//bprint("*** excised water: ");
//bprint(surface);
//bprint("\n");



				self.watertype = self.waterlevel = 0;
				self.flags = self.flags - (self.flags & FL_INWATER);
				return;
			}
		}
	}

	if (self.waterlevel != 3)
	{
		if (self.mask_x == CB_HUMAN)
		{
			if (self.air_finished < time)
				sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
			else if (self.air_finished < time + 9)
				sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		}
		else
			morph_sound( 0.8, self.noise3, 1);

//		if (pk_xsound) pk_gasp_sound();
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			drown = TRUE;
			if (!MONSTER_DROWN && (self.flags & FL_MONSTER)) drown = FALSE;
		}
	}

	ISL = FALSE;
	if (self.morphy == IMP_MCTHON) ISL = TRUE;
	else if (self.morphy == IMP_MCHAOS) ISL = TRUE;
	else if (self.model == "progs/boss.mdl") ISL = TRUE;
	else if (self.classname == "monster_tarbaby") ISL = TRUE;

	if (ISL && self.pain_finished < time)  //checks for non breathers based on lava / plasma makeup
	{
//		if (IS_CHAOS_PURE(self)) drown = FALSE;
//		else 
		if (self.watertype == CONTENT_LAVA) drown = FALSE;
		else if (self.watertype == CONTENT_SLIME) drown = FALSE;
		else if (self.watertype == CONTENT_WATER) drown = TRUE;
		if (random() < 0.3) self.dmg = self.dmg / 2; // keep this down, water damage should not be excessive
	}

	if (self.classname == "monster_fish" || // like a fish in the deep blue sea
		(self.classname == "monster_zombie" && !MONSTER_ZOMBIE_DROWN)) drown = FALSE; 

	if (drown)
	{
		self.dmg = self.dmg + 2;
		if (self.dmg > 15)
			self.dmg = 10;

		if (!Q_100) ignorearmor = TRUE; // *pk - no armor taken when drowning
			// Cataboligne 9.11.3 purify
		e = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, v0, v0, v0, v0, v0, "drowning", "", SUB_Null, 0.01, SUB_Remove, SUB_Null, self, world);
		T_Damage (self, e, world, self.dmg);
		ignorearmor = FALSE;
		self.pain_finished = time + 1;
	}

	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			if (self.classname == "monster_tarbaby" && self.model != "progs/lavabomb.mdl") // tarbaby mutates in lava
			{
				setmodel(self,"progs/lavabomb.mdl");
				setsize (self, '-16 -16 -24', '16 16 40');
				self.health = self.health * 2;
				self.th_missile = lavaball_shot;
			}

			T_FireDamage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			if (self.mask_x & CB_GREMLIN || self.classname == "monster_gremlin")
				{
				self.dmgtime = time + 7 + (random() * 5);
				if (self.health < (66.6 * MGREMLIN_HEALMOD))
					if (random() < 0.16) T_Heal(self, self.waterlevel + random() * self.waterlevel, 0);
				}
			else if (self.morphy == IMP_MIMP) return; // NOTE - means imp can move full speed in slime, but does not benefit from wetsuit
			else if (! ISL) T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	else if (self.watertype == CONTENT_WATER)
	{
		if (self.mask_x & CB_GREMLIN || (self.classname == "monster_gremlin" && (GREM_AASPAWN | !deathmatch)))
		if (self.waterlevel > 0)
			gremlin_spawn(1.0 + random());

/*
lefty - gremlin count, dont exceed a certain amount
player 50?
npc 20?
server total 100?

*/
	}


	if (!(self.flags & FL_INWATER))
	{

// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags | FL_INWATER;
		self.dmgtime = 0;
	}

	if (!PK) // *pk - done elsewhere CHECK:
	if (! (self.flags & FL_WATERJUMP))
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};


//void() pk_pre_think =

void () PlayerPreThink =
{
	if (FRIKBOT)
	if (BotPreFrame ())
		return ;

	if (Q_100)
	{
		q100_PlayerPreThink();
		return;
	}

	if (intermission_running)
	{
		if (find(world,classname,"viswep")) vw_remove();
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used

// removed from WaterMove, it has to be done every frame.
	if (! (self.flags & FL_WATERJUMP))
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;

	if (cc_frame != framecount) // Cataboligne - 6.10.10 - making this a frame check - only way splashes will look "right"
// PAINKEEP SPLASH Check for entities splashing
		CheckWaterLevels();

	//JIM
	//WETSUIT
	if (self.wetsuit_finished > time)
	{
		if (self.waterlevel==2)
		{
			self.velocity = self.velocity * 1.25; // haste rune will override these
		}
		if (self.waterlevel==3)
		{
			self.velocity = self.velocity * 1.5;
		}
		if (self.waterlevel >= 2)
		{
		// play scuba sound
			if (self.swim_flag < time)
			{
				self.swim_flag = time + 7;
				sound (self, CHAN_BODY, "hipitems/wetsuit.wav", 1, ATTN_NORM);
			}
			//MED 01/17/97
			else
			{
				if (fabs(self.swim_flag - time - 6)<0.04)
				{
					DeathBubbles(1);
				}
				else if (fabs(self.swim_flag - time - 5.5)<0.04)
				{
					DeathBubbles(1);
				}
				else if (fabs(self.swim_flag - time - 5)<0.04)
				{
					DeathBubbles(1);
				}
			}
		}
  }

	if (self.pk_dutychecking == 0)
	{
		CheckRules ();
		if (self.movetype != MOVETYPE_NOCLIP)
		if (self.health > 0)
		if (self.classname == "player" || self.classname == "pk*bot")
		{
			WaterMove ();

			if (self.waterlevel == 2)
				CheckWaterJump ();
		}

//		if (!Q_100 && !PK_100)
//		if (!Q_100 && !PK_100)
		if (self.waterlevel)
		if (! self.flags & FL_WATERJUMP)
		if (self.cam_x & CHSCAM_ON)
		{
			cam_waterjump();  // Cataboligne 8.22.9 purify - chase cam
		}

	}
	else if (time > self.pk_dutychecking)
	{
		CheckRules ();
		if (self.movetype != MOVETYPE_NOCLIP)
		if (self.health > 0)
		if (self.classname == "player" || self.classname == "pk*bot")
		{
			WaterMove ();

			if (self.waterlevel == 2)
				CheckWaterJump ();
		}

		if (self.waterlevel)
		if (! self.flags & FL_WATERJUMP)
		if (self.cam_x & CHSCAM_ON)
		{
			cam_waterjump();  // Cataboligne 8.22.9 purify - chase cam
		}

	}

	if ((framecount & 3) == 2)
	if (self.classname == OBSERVER)
		flyer_move(); // Cataboligne - 7.26.10 - flyer mouse-fly right code from chaos mod flight

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}

	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		if (self._jump != SUB_Null) // Should be after these checks? (in client.qc under playerjump)
			self._jump();
		else
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// note: covers morph flyers, jetpack

	if ((framecount & 3) == 2)
	if ((!self.flags & FL_ONGROUND) || (self.v_angle_x < -45))
	if (self.movetype == MOVETYPE_FLY) // NOTE: horn, grap set this
		flyer_move(); // Cataboligne - 7.26.10 - flyer mouse-fly right code from chaos mod flight

// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';

// PAINKEEP_START
	if (time > self.attack_finished)
//	if (self.currentammo == 0)
	if (!HasAmmo(self.weapon, self.pk_currentitem))
	if (!ammo_con(self.weapon, self, "wpck"))
	if (self.weapon != IT_AXE || self.pk_currentitem != PK_IT_AXE)
	{
		self.weapon = W_BestWeapon ();
		self.pk_currentitem = W_BestPKWeapon ();
		W_SetCurrentAmmo ();
	}

// GRAPPLING
	grap_maintainHarpoon();
	self.oldorigin = self.origin;

	if (self.pk_dutychecking == 0)
	{
		updateStatusDisplay();
	}
	else if (time > self.pk_dutychecking)
	{
		updateStatusDisplay();
	}
};




float vw_bot_frame; // handle pk*bots

//void() pk_post_think =
void () PlayerPostThink =
{
	if (vw_bot_frame != framecount)  // run these things once this frame
	{
		viswep_pkbot();
		if (find(world, classname, LOOPSOUND)) loop_play(); // play on looped sounds

// sphere of annihilation controls
		if (sphere_a) sphere_annihilation_phys_move();
	}

	if (FRIKBOT)
	if (BotPostFrame ())
		return ;

	if (find(world,classname,"pk*bot"))
  {
		if ((self.view_ofs != '0 0 0') && !self.deadflag)
		if (CheckDropPath ()) // *bot
		{
			DropBotPath ();
		}

		if (!(DARKPLACES || chaos)) // handle other engines
		if (cvar("botlevel")) // hack so alias can load new map & keep pk*bots - set by console command aliases for map & changelevel - bmap & blvl
		{
			bot_changelevel(); // map change MUST happen - this clears bots from map!
			cvar_set("botlevel", "0");
		}
  }

	if (self.movetarget.model == "progs/anode_x.mdl")
	{
		if (intermission_running || self.view_ofs == '0 0 0')
		{
			self.movetarget.model = "";
		}
		else
		{
			self.movetarget.angles_x = 0; // - self.angles_x;
			setorigin(self.movetarget, self.origin);
			self.movetarget.angles_y = self.angles_y; // relative angles
		}
	}

	if (self.vw_frame != framecount)
		viswep_post(); // Cataboligne - 9.26.9 - viswep code link - always have to run this for 1 player + pk*bots deal

	if (self.admin == USER_MENU) // user menu does not allow skip postthink codes
	{
		if (self.view_ofs != '0 0 0') 
			admin_postthink();
	}
	else
	if (PK_ADMIN && !ADMINLOCK) // *pk - run admin for both modes - any deactivation will 0 this || make sure user menu always works
	if (self.admin || (self.impulse == pk_adminimp))
	if (pk_adminframe != framecount)
	if (admin_postthink()) return;


	if (chaos)
		if (!(self.cam_x & CHSCAM_ON))  // Cataboligne - 5.14.10 - cam purify - custom engine dont display vw_ for 1pv
			{
//			if (!(self.flags & FL_NDISMDL)) bprint("switching to not display vwep\n");
			self.flags = self.flags | FL_NDISMDL; // old self.flags method, replacing with:
			}
		else
			{
//			if (self.flags & FL_NDISMDL) bprint("switching to display vwep\n");
			self.flags = self.flags - (self.flags & FL_NDISMDL);
			}

// runes - these qaulify the below 2 tests in the call!
	if (self.rune_flag & RUNE_FLG_RG || self.rune_flag & T_ADOC) rune_regen();
	if (self.rune_flag & RUNE_VAMPIRE) rune_vamp();

	if (Q_100 || Q_99) // CHECK: q99-ness effect hereish
	{
		q100_PlayerPostThink();
		return;
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	//JIM
	//WETSUIT
	if (self.wetsuit_finished > time)
	{
		if (self.waterlevel==2)
		{
			self.velocity = self.velocity * 0.8;
		}
		if (self.waterlevel==3)
		{
			self.velocity = self.velocity * 0.66;
		}
	}

	if (self.deadflag)
	// BOLT_START
	{
		if (self.deadflag == DEAD_DYING && self.bolt_conduitTimeout > time) // it's the conduit time for this player...
		{
			// make sure the player think is set correctly
			self.think = player_conduitJerk;
		}
		return;	 // dying, so do nothing
	}


// do weapon stuff

	if (!XENV)
	if (WEPHUM)
	if (self.eweapon)
	if (self.eweapon.fly_sound != HUMLOCAL)
	if (self.eweapon.noise2 != "")
	if (self.chaosweptime < time)
//		if (self.eweapon.weapon != MC_AIRGUN)
		ominous_hum(self.eweapon.noise2, self.eweapon.chaosweptime);

	if (self.ammo_rockets < self.ammo_hgrenade) self.ammo_hgrenade = self.ammo_rockets; // NOTE: while rockets & grenades are the same ammo q1 style

	if (time < self.attack_finished)
		return;

	if (self.attack_finished < time) W_WeaponFrame ();

	if (self.classname != OBSERVER) // Cataboligne - 8.16.9 - dont need this for observers
// check to see if player landed and play landing sound

	if (!(self.hook & HOOK_ON)) // Cataboligne 9.11.3 purify
	{
		if (self.classname == "player" || self.classname == "pk*bot") // dont thud the cam

		if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
		{
			if (self.watertype == CONTENT_WATER)
				sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
			else if (self.jump_flag < -650)
			{
				T_Damage (self, world, world, 5); // IDEA: falling damage related to dist & velo (*_z)
				//sound (self, CHAN_VOICE, "player/fall_2.wav", 1, ATTN_NORM);
				if (self.mask_x == CB_HUMAN)
					sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
				self.deathtype = "falling";
			}
			else
				if (self.mask_x == CB_HUMAN)
					sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
				//sound (self, CHAN_VOICE, "player/fall_1.wav", 1, ATTN_NORM);

			self.jump_flag = 0;
		}

		if (!(self.flags & FL_ONGROUND))
			self.jump_flag = self.velocity_z;

	}
	else // Cataboligne 9.11.3 purify - this is damage from your own hook activities - i.e. skullcrack
	{
		hook_dmg_check(); // IDEA: server flag?
		self.finaldest = self.velocity;
	}

	// If it's air blast time, blow entity's
	if (self.AIRG_BlastTimeout > time)
	{
		horn_airblast(FALSE);
	}

// PK_DUTYCHECKING_START
	if (self.pk_dutychecking == 0)
	{
		bolt_checkTargets();

		CheckPowerups ();

		if (self.copb_timeout)
		{
			if (self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		if (pk_flags & PK_TP_DUTYON)
		{
			self.pk_dutychecking = time + 0.5;
		}
	}
	else if (time > self.pk_dutychecking)
	{
		bolt_checkTargets();

		CheckPowerups ();

		if (self.copb_timeout)
		{
			if (self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		if (pk_flags & PK_TP_DUTYON)
		{
			self.pk_dutychecking = time + 0.5;
		}
		else
		{
			self.pk_dutychecking = 0;
		}
	}
	else
	{
		if (!(pk_flags & PK_TP_DUTYON))
		{
			self.pk_dutychecking = 0;
		}
	}
};

// called from client connect

//void() pk_clientconnect =
void () ClientConnect =
{
	local float v;

	ClientInRankings (); // sets .ishuman & .class_select for humans
	bot_con(TRUE); // *bot - doesnt depend on active bots, must always happen
	if (Q_100 || Q_99)
	{
		q100_ClientConnect();
		return;
	}


	v = random() * 6;
	bprint (self.netname);
	if (v < 1)
	{
		bprint(" joined the carnage\n");
	}
	else if (v < 2)
	{
		bprint(" joined the fragging\n");
	}
	else if (v < 3)
	{
		bprint(" dropped in for tea\n");
	}
	else if (v < 4)
	{
		bprint(" entered the fragfest\n");
	}
	else if (v < 5)
	{
		bprint(" came to die\n");
	}
	else
	{
		bprint(" entered the game\n");
	}

// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
// MOTD_START
//	self.msgcount = 1;
};

// called from client disconnect

//void() pk_clientdisconnect =
void () ClientDisconnect =
{
//	if (FRIKBOT) 
		ClientDisconnected ();
	bot_con(FALSE); // *bot

	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	dead_drop(self); // Cataboligne - 10.7.11 - drop runes+

	if (!Q_100 && !Q_99)
	{
// PK - set flag so that we know that it's a disconnected entity.
		self.disconnectPlayer = 1;

		grap_releaseHarpoon();
		self.beartrap_time = 0;
		self.voteIntermission = 0;

		self.grap_owner = world;

		self.bolt_target = world;
		self.bolt_targetNext = world;
		self.bolt_targetTimeout = 0;
		self.bolt_targetNextTimeout = 0;
		if (self.bolt_targetTimeoutEntity)
		{
			remove(self.bolt_targetTimeoutEntity);
		}
		self.bolt_targetTimeoutEntity = world;
		self.bolt_conduitTimeout = 0;
		self.bolt_changeModelTimeout = 0;
		if (self.bolt_lightningFire)
		{
			remove(self.bolt_lightningFire);
		}
		self.bolt_lightningFire = world;

		admin_sv_cfg();

		bprint (self.teamname);
	}
// normal disc
	q100_ClientDisconnect();
};

// fn(frag_plus) - return frag to add if frags should be counted after death & ffw limit set

// test entity e

float(entity e) frag_plus =
{
	if (FFW_LIMIT > 0)
	if (e.deadflag)
	if (e.search_time < time)
		return(0);

	return(1); // chaos mod vector!
};

// fn(frag_minus) - return frag to *** subtract ***

// test entity e

float(entity e) frag_minus =
{
	return(1); // chaos mod vector!
};

// suicide frags / enviroment frags

float(entity e) frag_minus_cide =
{
	if (NOCIDE) return(0);
	return(1);
};

float world_frags; // how many env kills world gets

float(entity e) frag_minus_envcide =
{
	if (NOENVCIDE) return(0);
	world_frags = world_frags + 1;
	return(1);
};

// fn(no*cide) - dont count some suicide frags

/* deprecated for conditionals below

float NOCIDE_DEFRAG; // restore lost frags

// frag already removed - so we add it back in - chaos mod vectors

// no suicide frags at all
void(entity e) nocide =
{
	if (NOCIDE) e.frags = e.frags + 1;
};

// no environment suicide frags
void(entity e) noenvcide =
{
	if (!NOCIDE && NOENVCIDE) e.frags = e.frags + 1;
};
*/

// called from killed - updated client obit for pk items
entity Infl, Targ, Att;

void(entity targ, entity inflictor, entity attacker) PK_ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;
	rnum = random();



//TEST:
Infl = inflictor;
Targ = targ;
Att = attacker;

if (cvar("saved1") == -556)
{
bprint("\nInflicitor was:");
bprint(item_ident(inflictor));
bprint("\n");
}



	if (attacker.classname == "bot_fix") return;

	if (targ.classname == "player")
	{
		if (targ.watertype != CONTENT_LAVA && (targ.flags & FL_DEMONBOOM || targ.deathtype == "rage") ) // because a dying demon in a rage still explodes...
		{
			targ.deathtype = "";
			bprint (targ.netname);
			bprint (" went to pieces in a fit of rage!\n");
			return;
		}

		if (attacker.classname == "teledeath"  || attacker.classname == "portalteledeath")
		{
			bprint (targ.netname);
			if (attacker.classname == "portalteledeath")
				bprint (" was portal fragged by ");
			else
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			attacker.owner.frags = attacker.owner.frags + frag_plus(attacker.owner);
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - frag_minus(targ);
			return;
		}

// Cataboligne 8.12.9 purify - pk artifacts
		if (inflictor.classname == "ego")
		{
//			rnum = random ();
			bprint (targ.netname);
			if (inflictor.owner == targ)
			{
				if (!NOPKCIDE)
					targ.frags = (targ.frags - frag_minus(targ));
//				nocide(targ);
				if (rnum < 0.250)
					bprint (" had a mental breakdown!\n");
				else if (rnum < 0.5)
					bprint (" let his EGO get out of control!\n");
				else if (rnum < 0.750)
					bprint ("'s own EGO was self destructive!\n");
				else
					bprint ("'s EGO sometimes has a mind of its own!\n");
				return;
			}
			attacker.frags = (attacker.frags + frag_plus(attacker));
			if (rnum < 0.250)
				bprint (" was impressed by the power of ");
			else if (rnum < 0.5)
				bprint (" was counseled by ");
			else if (rnum < 0.750)
				bprint (" was overpowered by ");
			else
				bprint (" was manipulated by ");
			bprint (attacker.netname);
			bprint ("'s EGO\n");
			return;
		}
		if (inflictor.classname == "corpse")
		{
//			rnum = random ();
			bprint (targ.netname);
			if (inflictor.owner == targ)
			{
				if (!NOPKCIDE)
					targ.frags = (targ.frags - frag_minus(targ));
//				nocide(targ);
				if (rnum < 0.250)
					bprint (" was caught robbing the family grave!\n");
				else if (rnum < 0.5)
						bprint (" could not get away from a relative's corpse\n");
				else if (rnum < 0.750)
					bprint (" should not have gone for the family's jewelry\n");
				else
					bprint (" was brought down by an old friend\n");
				return;
			}
			attacker.frags = (attacker.frags + frag_plus(attacker));
			if (rnum < 0.250)
				bprint (" was dragged down by an old friend in ");
			else if (rnum < 0.5)
				bprint (" was laid to rest by ");
			else if (rnum < 0.750)
				bprint (", poor kid, got tuckered out dragging someone in ");
			else
				bprint (" should not have defiled ");
			bprint (attacker.netname);
			bprint ("'s Tomb\n");
			return;
		}
// end pk_art
		if (inflictor.classname == "sphere_annihilation")
		{
			local string sa;
			bprint (targ.netname);
			deathstring = rnd_string(' 90.0 60.0 60.0'," has is ass crushed by  "," finds out where the black hole goes for ","",""," goes beyond the event horizion of ");
			if (sphere_a.owner)
			{
				if (sphere_a.owner ==  targ) // whoopsie - got a wee bit too close
				{
					if (!NOPKCIDE)
						targ.frags = (targ.frags - frag_minus(targ));
					if (random() < 0.5)
					{
						deathstring = rnd_string(' 90.0 60.0 60.0'," got dumb and set a sphere of annihlation free...good going chump!\n"," checked his own event horizon\n","",""," made a really bad mistake\n");
						bprint (deathstring);
					}
					else
						bprint(" - oh my god...its full of stars.\n");
					return;
				}

				sa = sphere_a.owner.netname;
			}
			else sa = " a wild ";
			bprint (deathstring);
			bprint (sa);
			bprint(" sphere of annihilation\n");
			attacker.frags = (attacker.frags + frag_plus(attacker)); // add it up
			return;
		}

// NOTE: non score list bot
		if (attacker.classname == "player" ||  attacker.classname == OBSERVER) // Cataboligne 9.23.9 - attacker could have died & become observer
		{
			if (targ == attacker)
			{
				// killed self
				bprint (targ.netname);

				if (inflictor.weapon == IT_AXE && inflictor.pk_currentitem == PK_IT_GRAVITYWELL)
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," sees eye to eye with eternity\n"," got sucked into his own trap\n","",""," visits another dimension\n"));
					else
					bprint (" visits another dimension\n");
					if (!NOPKCIDE)
						targ.frags = (targ.frags - frag_minus(targ));
					return;
				}

				if (inflictor.weapon == IT_AXE && inflictor.pk_currentitem == PK_IT_BEARTRAP)
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," got bit in the ass by his own trap\n"," felt his own cold steel trap\n","",""," forgot about his beartrap\n"));
					else
					bprint (" forget about his beartrap\n");
					if (!NOPKCIDE)
						targ.frags = (targ.frags - frag_minus(targ));
					return;
				}

				targ.frags = targ.frags - frag_minus_cide(targ);
//				nocide(targ);

				if (inflictor.classname == "cluster_bomb")
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," checks his cluster bomb spread\n"," went to collect the cluster bombs\n","",""," checked to see if the cluster bombs were duds\n"));
					else
						bprint (" becomes bored with life\n");
				}
				if (inflictor.classname == "grenade")
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," is painting the level red\n"," trips over his own pineapple\n","",""," tries to put the pin back in\n"));
					else
						bprint (" tries to put the pin back in\n");
				}
				else if (inflictor.classname == "missile")
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," launches a new career\n"," dances with his own HE\n","",""," becomes bored with life\n"));
					else
						bprint (" becomes bored with life\n");
				}
				else if (inflictor.classname == "laser")
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," melted him self\n"," got down with his own light beams\n","",""," self cremated\n"));
					else if (rnum > 0.4 )
						bprint (" becomes bored with life\n");
					else
						bprint (" checks if his weapon is loaded\n");
				}

//				if (curwep_mapcode(targ, 0) == MC_GRAVITY)
//				else if (inflictor.classname == "gravity_armed")
//					bprint(rnd_string(' 90.0 60.0 60.0'," sees eye to eye with eternity\n"," got sucked into his own trap\n","",""," visits another dimension\n"));

//				if (curwep_mapcode(targ, 0) == MC_BEARTRAP)
//				else if (inflictor.classname == "beartrap_armed")
//					bprint(rnd_string(' 90.0 60.0 60.0'," got bit in the ass by his own trap\n"," felt his own cold steel trap\n","",""," forgot about his beartrap\n"));

//				else if (inflictor.classname == "turret")
//					bprint(rnd_string(' 90.0 60.0 60.0'," got shot in the ass by his own autosentry\n"," learns a valuable lesson about automated weapons\n","",""," forgot to hide from his autosentry\n"));

//				if (curwep_mapcode(targ, 0) == MC_BOMB)
				else if (inflictor.classname == "bomb")
					bprint(rnd_string(' 90.0 60.0 60.0'," parties with Wile E. Coyote\n"," finds his bomb in the dark\n","",""," was too late to snuff the fuse\n"));

				else if (inflictor.classname == "democharge")
					bprint(rnd_string(' 90.0 60.0 60.0'," blew his own ass to hell\n"," forgot to check the safety\n","",""," didnt run fast enough\n"));

				else if (inflictor.classname == "proximity_grenade")
				{
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," got stupid\n"," went back to get the prox grenade\n","",""," tested the prox grenades motion sensor\n"));
					else
						bprint (" becomes bored with life\n");
				}

				else if (inflictor.classname == "ball_lightning")
					bprint(rnd_string(' 90.0 60.0 60.0'," felt the shaft of the ball lightning\n"," didnt respect the power of the dynamo\n","",""," hung around to watch\n"));

//				else if (inflictor.classname == "sphere_annihilation")
//					bprint(rnd_string(' 90.0 60.0 60.0'," got dumb and set a sphere of annihlation free...good going chump!\n"," checked his own event horizon\n","",""," made a really bad mistake\n"));
				else
				{
// NOTE: conflict - morph that can get eweaps - fires builtin (capable of morphicide) & switches to eweap or v.v
					if (attacker.eweapon)
					{
						if (attacker.eweapon._killmsg != SUB_Null) // xwep kill - must be coded to handle suicide message
						{
							deathstring = attacker.eweapon._killmsg(targ, attacker);
							if (deathstring == "return") return; // printed in killmsg call, just go back

							deathstring2 = attacker.eweapon._killmsg2(targ, attacker);
							if (deathstring != "")
							{
								bprint (deathstring);
								bprint (deathstring2);
								return;
							}
						}
						bprint (" fell victim to his own experimental weapon\n");
						return;
					}

					if (attacker._killmsg != SUB_Null) // morphicide
					if (attacker.weapon & attacker.builtin) // make sure its not a reg or xwep kill
					{
						deathstring = attacker._killmsg(targ, attacker);
						if (deathstring == "return") return; // printed in killmsg call, just go back

						deathstring2 = attacker._killmsg2(targ, attacker);
						if (deathstring == "") // nope, ur?
						{
//							deathstring = DEF_MORPH_DEATH1; //   was killed by 
							deathstring = " was killed"; //   was killed by 
							deathstring2 =  DEF_MORPH_DEATH2; // some how, we just arent sure
						}
						bprint (deathstring);
						bprint (deathstring2);
						return;
					}

					if ((inflictor.weapon == IT_LIGHTNING) || ((inflictor.weapon == IT_AXE) && (targ.pk_currentitem == PK_IT_CLIGHT)) && attacker.waterlevel > 1)
					{
						if (ENHANCED)
							bprint(rnd_string(' 90.0 60.0 60.0'," rode his own lightning!\n"," goes fishin in a thunder storm\n","",""," discharges into the water\n"));
						else
							bprint (" discharges into the water.\n");
						return;
					}

					if (inflictor.weapon == IT_GRENADE_LAUNCHER)
						bprint (" tries to put the pin back in\n");
//					else
//						bprint (" becomes bored with life\n"); // NOTE: generic death
					else if (rnum > 0.4 || !ENHANCED) // hip mod
						bprint (" becomes bored with life\n");
					else
						bprint (" checks if his weapon is loaded\n");
				}
				return;
			}
			else if ((teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team))
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";
				else if (rnum < 0.50)
					deathstring = " checks his glasses\n";
				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";
				else
					deathstring = " loses another friend\n";
				bprint (attacker.netname);
				bprint (deathstring);
				attacker.frags = attacker.frags - frag_minus(attacker);
				return;
			}
			else
			{
				attacker.frags = attacker.frags + frag_plus(attacker); // note: adds frags for all wep kills below - this includes monsters! - NOTE: anode_x vector...

				if (attacker.frags > high_score) high_score = attacker.frags; // secretly for bot morph decision making

// died & empathy damaged hit targ
				if (empathy_dmg == 1)
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" shares ");
					else
						bprint (" feels ");
					bprint (attacker.netname);
					bprint ("'s pain\n");
					return;
				}
// TDO: all fire & forget

//MED 11/18/96
            if (inflictor.classname == "proximity_grenade")
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" got too friendly with ");
					else
						bprint (" did the rhumba with ");
					bprint (attacker.netname);
					bprint ("'s bomb\n");
					return;
				}

            if (inflictor.classname == "laser" || inflictor.classname == "plasma")
				{
					bprint (targ.netname);

					if (!ENHANCED || random() < 0.8)
					if (inflictor.weapon == -256) // laser cannon secret code
					{
						if (random()<0.5)
							bprint (" was toasted by ");
						else
							bprint (" was radiated by ");
						bprint (attacker.netname);
						bprint ("'s laser\n");
						return;
					}

					if (random()<0.5)
						bprint (" was radiated by ");
					else if (random()<0.5)
						bprint (" was melted by ");
					else
						bprint (" felt the lumnous heat from ");
					bprint (attacker.netname);
					if (random()<0.2)
						bprint ("'s hot light\n");
					else
						bprint ("'s laser\n");
					return;
				}

            if (inflictor.classname == "cluster_bomb")
				{
					bprint (targ.netname);
					if (random()<0.5 || !ENHANCED)
						bprint (" exploded under a rain of ");
					else
						bprint (" got more shrapnel than smiles with ");

					bprint (attacker.netname);
					bprint ("'s cluster bombs\n");
					return;
				}


            if (inflictor.classname == "bfg_ball") // TDO: q2 message for direct hit
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" was erased by ");
					else
						bprint (" got smashed by ");

					bprint (attacker.netname);
					bprint ("'s BFG blast\n");
					return;
				}

            if (inflictor.classname == "bfg_laser")
				{
					bprint (targ.netname);
					if (!ENHANCED)
					{
						bprint (" couldn't hide from ");
						bprint (attacker.netname);
						bprint ("'s BFG\n");
						return;
					}
					if (random()<0.5)
						bprint (" couldn't hide from ");
					if (random()<0.5)
						bprint (" was melted by ");
					else
						bprint (" felt the lumnous heat from ");

					bprint (attacker.netname);
					if (random()<0.5)
						bprint ("'s BFG lasers\n");
					else
						bprint ("'s BFG\n");
					return;
				}

            if (inflictor.classname == "hook_ball")
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" was hooked by ");
					else
						bprint (" had his internal organs ripped out by ");

					bprint (attacker.netname);
					bprint ("'s grapple\n");
					return;
				}

            if (inflictor.classname == "demonboom")
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" was ripped to shreds by ");
					else
						bprint (" got a blast from ");

					bprint (attacker.netname);
					bprint ("'s fiendish rage\n");
					return;
				}

            if (inflictor.classname == "cloudkill")
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" breathed his last from ");
					else
						bprint (" got a last gasp from ");

					bprint (attacker.netname);
					bprint ("'s toxic cloud\n");
					return;
				}

            if (inflictor.classname == "plague")
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" caught the plague from ");
					else
						bprint (" did something he shouldnt with ");

					bprint (attacker.netname);
					bprint ("\n");
					return;
				}

// morph missiles
				if (inflictor.owner.class_select != "class_monster") // make sure a monster didnt shot it
				{
					if (inflictor.classname == "fireballwep" || inflictor.classname == "fireballmissle")
					{
						bprint (targ.netname);
						if (random()<0.5)
							bprint (" felt the heat from ");
						else
							bprint (" was melted by ");

						bprint (attacker.netname);
						bprint ("'s hot rocks\n");
						return;
					}

					if (inflictor.classname == "lavaspike")
					{
						bprint (targ.netname);
						if (random()<0.5)
							bprint (" got the hot point from ");
						else
							bprint (" was nailed down by ");

						bprint (attacker.netname);
						bprint ("'s red hot spikes\n");
						return;
					}
					
					if (inflictor.classname == "wizspike")
					{
						bprint (targ.netname);
						if (random()<0.5)
							bprint (" was really stiffed by ");
						else
							bprint (" felt the pain from ");

						bprint (attacker.netname);
						bprint ("'s eldritch spell\n");
						return;
					}
					
					if (inflictor.classname == "knightspike")
					{
						bprint (targ.netname);
						if (random()<0.5)
							bprint (" was on the wrong end of ");
						else
							bprint (" got the special delivery from ");

						bprint (attacker.netname);
						bprint ("'s sword spell\n");
						return;
					}
					
					if (inflictor.classname == "gib_tracer")
					{
						bprint (targ.netname);
						if (random()<0.5)
							bprint (" was pelted with ");
						else
							bprint (" got all stinky with ");

						bprint (attacker.netname);
						bprint ("'s rotting meat\n");
						return;
					}
				}


			if (inflictor.classname == "dragon_fire") // owwie - note: not done yet
				{
					bprint (targ.netname);
					if (random()<0.5 || !ENHANCED)
						bprint (" was fried by a Dragon\n");
					else
						bprint (" became an amature throat specialist for Dragon kind\n");
					return;
				}

			if (inflictor.classname == "poison") // spider attack
				{
					bprint (targ.netname);
					if (random()<0.5 || !ENHANCED)
						bprint (" was poisoned by a Spider\n");
					else
						bprint (" should have sucked out the Spider venom\n");
					return;
				}

            if (inflictor.classname == "vomis") // vomis spike
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" was slimed by a Vomitus\n");
					else if (random()<0.5)
						bprint (" was vomited on by a Vomitus\n");
					else
						bprint (" got vomit all over him\n");

//					bprint (attacker.netname);
//					bprint ("\n");
					return;
				}

            if (inflictor.classname == "vomisexplod") // vomis bomb
				{
					bprint (targ.netname);
					if (random()<0.5)
						bprint (" caught the vomitus exploding spittle\n");
					else
						bprint (" got vomit bombed!\n");

//					bprint (attacker.netname);
//					bprint ("\n");
					return;
				}



				//rnum = attacker.weapon;
				// For the correct death messages
				rnum = inflictor.weapon; // set when wep fired

				if (rnum == IT_AXE)
				{
// PAINKEEP_START
					if (inflictor.pk_currentitem == PK_IT_AXE)
					{
						deathstring = " was ax-murdered by ";
						deathstring2 = "\n";
					}
					else if (inflictor.pk_currentitem == PK_IT_AIRGUN)
					{
// AIRG_WEAPON_START

// Death messages for the AirFist.

						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
							deathstring2 = "'s wind!\n" ;
						}
						else
						{
							bprint (attacker.netname);
							bprint (" blows ");
							bprint (targ.netname);
							bprint ("\n");
							return;
						}
					}
// AIRG_WEAPON_END
// GRAPPLING_START
					else if (inflictor.pk_currentitem == PK_IT_GRAPGUN)
					{
						deathstring = " got ";
						deathstring2 = "'s point\n";
					}
// GRAPPLING_END
					else if (inflictor.pk_currentitem == PK_IT_BEARTRAP)
					{
						deathstring = " was clamped by ";
						deathstring2 = "\n";
					}
					else if (inflictor.pk_currentitem == PK_IT_GRAVITYWELL)
					{
						deathstring = " fountains in front of ";
						deathstring2 = "\n";
					}
// BOLT_START
					else if (inflictor.pk_currentitem == PK_IT_CLIGHT)
					{
						if (attacker.waterlevel > 1)
						{
							deathstring = " accepts ";
							deathstring2 = "'s discharge\n";
						}
						else
						{
							bprint (attacker.netname);
							bprint (" short-circuits ");
							bprint (targ.netname);
							bprint ("\n");
							return;
						}
					}
// BOLT_END
// PAINKEEP_END
				}


				if (attacker.eweapon)
				{
					deathstring = DEF_WEP_DEATH1; //  was just plain shot with 
					deathstring2 = "'s experimental weapon\n";

					if (attacker.eweapon._killmsg != SUB_Null) // xwep kill
					if (attacker.eweapon._killmsg != (void ()) 0)
					{
						deathstring = attacker.eweapon._killmsg(targ, attacker);
						if (deathstring == "return") return; // printed in killmsg call, just go back

						if (attacker.eweapon._killmsg2 != (void ()) 0)
						deathstring2 = attacker.eweapon._killmsg2(targ, attacker);
						if (deathstring == "")
						{
							deathstring = DEF_WEP_DEATH1; //  was just plain shot with 
							deathstring2 = "'s experimental weapon\n"; // 's random weapon of choice
						}
					}
					bprint (targ.netname);
					bprint (deathstring);
					bprint (attacker.netname);
					bprint (deathstring2);
					return;
				}

				if (attacker._killmsg != (void ()) 0)
				if (attacker._killmsg != SUB_Null) // morphic kill
				if (attacker.weapon & attacker.builtin) // make sure its not a reg or xwep kill
				{
					deathstring = attacker._killmsg(targ, attacker);
					if (deathstring == "return") return; // printed in killmsg call, just go back

					if (attacker._killmsg2 != (void ()) 0)
					deathstring2 = attacker._killmsg2(targ, attacker);

					if (deathstring == "") // nope, ur?
					{
						deathstring = DEF_MORPH_DEATH1; //   was killed by 
						deathstring2 =  DEF_MORPH_DEATH2; // some how, we just arent sure
					}
					bprint (targ.netname);
					bprint (deathstring);
					if (deathstring2 != "noname")
					{
						bprint (attacker.netname);
						bprint (deathstring2);
					}
					return;
				}


				if (rnum == IT_SHOTGUN)
				{
// EXPLODESHELLS_START
					if (inflictor.classname == "ExplodeShellsAttack")
					{
						bprint (attacker.netname);
						bprint (" turns ");
						bprint (targ.netname);
						bprint (" into pulpy red chunks\n");
						return;
					}
					else
					{
						deathstring = " chewed on ";
						deathstring2 = "'s boomstick\n";
					}
// EXPLODESHELLS_END
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
// EXPLODESHELLS_START
					if (inflictor.classname == "ExplodeShellsAttack")
					{
						bprint (attacker.netname);
						bprint (" turns ");
						bprint (targ.netname);
						bprint (" into a fine red mist\n");
						return;
					}
					else
					{
						deathstring = " ate 2 loads of ";
						deathstring2 = "'s buckshot\n";
			 		}
// EXPLODESHELLS_END
				}
				if (rnum == IT_NAILGUN)
				{
// PULSE_GUN_START
					deathstring = " was nailed by ";
					deathstring2 = "\n";
// PULSE_GUN_END
				}
				if (rnum == IT_SUPER_NAILGUN)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_GRENADE_LAUNCHER)
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				if (rnum == IT_ROCKET_LAUNCHER)
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s rocket\n" ;
					}
				}
				if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge\n";
					else
						deathstring2 = "'s shaft\n";
				}

				if (deathstring2 == "" && deathstring == "") // no wep kill msg, how strange - use defaults
				{
					deathstring = DEF_WEP_DEATH1; //  was just plain shot with 
					deathstring2 =  DEF_WEP_DEATH2; // 's random weapon of choice
				}

				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				bprint (deathstring2);
			}
			return;
		}
		else if (attacker.classname == "CDM" || attacker.class_select == "CDM") // Cataboligne - 2.20.11 - customized death messages
		{
			if (attacker.noise1) bprint(attacker.noise1); // pre strings
			if (attacker.deadflag & 1) bprint(targ.netname); // use targ name
			if (attacker.netname) bprint(attacker.netname); // main message
			if (attacker.noise) bprint(attacker.noise); // other strings
			bprint("\n");
			if (attacker.frags)
			{
				if (attacker.deadflag & 2) // any custom death msg ent with deadflag & 2 is classed as environmental suicide
					targ.frags = targ.frags - (attacker.frags * frag_minus_envcide(targ));
//				if (attacker.deadflag & 2) noenvcide(targ);
			}
			return;
		}
// TURRET_START
		else if (attacker.classname == "turret" || attacker.classname == "turret_gib")
		{
			bprint(targ.netname);

		// check if killed the droper of the turret.
			if (attacker.owner == targ) {
					// killed self
					if (!NOPKCIDE)
						targ.frags = targ.frags - frag_minus(targ);
					if (ENHANCED)
						bprint(rnd_string(' 90.0 60.0 60.0'," got shot in the ass by his own autosentry\n"," learns a valuable lesson about automated weapons\n","",""," forgot to hide from his autosentry\n"));
					else
					bprint(" forgot to hide from his own AutoSentry!\n");
				return;
			}

		// increase frags & print message.
			attacker.owner.frags = attacker.owner.frags + frag_plus(attacker.owner);

			bprint(" was ventilated by ");
			bprint(attacker.owner.netname);
			bprint("'s AutoSentry\n");
			return;
		}
// TURRET_END
		else
		{
			bprint (targ.netname);

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				targ.frags = targ.frags - frag_minus(targ); // getting killed by dm monster losses a frag
				if (attacker.classname == "monster_army")
					bprint (" was shot by a Grunt\n");
				else
				if (attacker.classname == "monster_demon1")
					bprint (" was eviscerated by a Fiend\n");
				else
				if (attacker.classname == "monster_dog")
					bprint (" was mauled by a Rottweiler\n");
				else
				if (attacker.classname == "monster_dragon")
					bprint (" was fried by a Dragon\n");
				else
				if (attacker.classname == "monster_enforcer")
					bprint (" was blasted by an Enforcer\n");
				else
				if (attacker.classname == "monster_fish")
					bprint (" was fed to the Rotfish\n");
				else
				if (attacker.classname == "monster_hell_knight")
					bprint (" was slain by a Death Knight\n");
				else
				if (attacker.classname == "monster_knight")
					bprint (" was slashed by a Knight\n");
				else
				if (attacker.classname == "monster_ogre")
					bprint (" was destroyed by an Ogre\n");
				else
				if (attacker.classname == "monster_oldone")
					bprint (" became one with Shub-Niggurath\n");
				else
				if (attacker.classname == "monster_shalrath")
					bprint (" was exploded by a Vore\n");
				else
				if (attacker.classname == "monster_supervore")
					bprint (" was eviscerated by a Hierophant Vorerel\n");
				else
				if (attacker.classname == "monster_shambler")
					bprint (" was smashed by a Shambler\n");
				else
				if (attacker.classname == "monster_tarbaby")
					bprint (" was slimed by a Spawn\n");
				else
				if (attacker.classname == "monster_vomit")
					bprint (" was vomited on by a Vomitus\n");
				else
				if (attacker.classname == "monster_wizard")
					bprint (" was scragged by a Scrag\n");
				else
				if (attacker.classname == "monster_zombie")
					bprint (" joins the Zombies\n");
//MED
				else
            if (attacker.classname == "monster_gremlin")
               bprint (" was outsmarted by a Gremlin\n");
//MED
				else
            if (attacker.classname == "monster_scourge")
               bprint (" was stung by a Centroid\n");
				else // now have generic
				{
					deathstring = "";
					if (attacker._killmsg != (void()) 0)
						deathstring = attacker._killmsg(targ, attacker);
					if (!deathstring)
						bprint(" was mauled by ");
					else if (deathstring == "return") // printed in killmsg call, just go back
						return;
					else
						bprint(deathstring);
					bprint(attacker.netname);
               bprint ("\n");
				}

				return;
			}

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				targ.frags = targ.frags - frag_minus(targ);
				bprint (" blew up\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				targ.frags = targ.frags - frag_minus(targ);
				bprint (" tried to leave\n");
				return;
			}
// all env after this
			targ.frags = targ.frags - frag_minus_envcide(targ); 
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint (" was squished\n");
//				noenvcide(targ);
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (" was spiked\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (" ate a lavaball\n");
//				noenvcide(targ);
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the fishes\n");
				else
					bprint (" sucks it down\n");
//				noenvcide(targ);
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
//				noenvcide(targ);
				return;
			}
			else if (rnum == -5)
			{
//				noenvcide(targ);
				if (MAP_MODE == "Q3" || MAP_MODE == "Q2")
				{
					bprint (" does a back flip into the lava.\n");
					return;
				}

				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (" turned into hot slag\n");
				else
					bprint (" visits the Volcano God\n");
				return;
			}

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" fell to his death\n");
//				noenvcide(targ);
				return;
			}

			// its worse than that - he's dead Jim
			// this puts all mystery deaths under envcide rules
			bprint (" died\n");
		}
	}
};
