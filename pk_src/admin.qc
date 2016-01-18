// Admin.qc - Remote Administration of a Quake Server
//
// Modified 8/14/96
//
// Doug Keegan
// Rip on IRC/NetQuake
// doug.keegan@tamu.edu

// Cataboligne - advanced admin, 4.11.8

/*  new admin features:

password - unlimited digits, stored in admin.cfg, masked entry
access impulse - stored in admin.cfg
time limit - stored in admin.cfg

menu driven - impulse independent - no longer will you have to keep notes or bind tons of keys
controls bots

*/

.float admin_input; // gather administration input codes for exec

// time limit on admin password entry
float admin_time;
float A_TIME = 10; // 10 secs for admin password - if this is not set, admin access attempt becomes free invulnerable state!
float A_DELAY = 30; // time until you can do anything after failing the admin entry - no shooting, no admin!

// Level impulses
float   A_PKHUB  = 21;
float   A_PAINKEEP = 20;
float   A_PK0   = 19;
float   A_PK1   = 01;
float   A_PK2   = 02;
float   A_PK3   = 03;
float   A_PK4   = 04;
float   A_PK5   = 05;
float   A_PK6   = 06;
float   A_PK7   = 07;
float   A_PK8   = 08;
float   A_PK9   = 09;
float   A_PK10  = 10;
float   A_PK11  = 11;
float   A_PK12  = 12;
float   A_PK13  = 13;
float   A_PK14  = 14;
float   A_PK15  = 15;
float   A_PK16  = 16;
float   A_PK17  = 17;
float   A_PK18  = 18;

// link codes
float   A_DMT   = 01;
float   A_TEAMT = 02;
float   A_COOPT = 03;
float   A_NOEX  = 04;
float   A_JUMP  = 05;
float   A_RESET = 06;
float   A_START = 07;
float   A_FRAGL = 10;
float   A_TIMEL = 11;
float   A_GRAVU = 12;
float   A_FRICU = 13;
float   A_DMMAP = 22;
float   A_BOTS  = 23;
float   A_PKCON = 24;
float   A_ITEM  = 25;
float   A_MONST = 26;
float   A_SKICK = 30;
float   A_PKMOD = 60;


// for external modules

void() admin_resettimeout =
{
	if (self.goalentity.classname == "admintimer") // any input to admin menus resets timeout
		self.goalentity.nextthink = time + pk_admintime;
};

// save flags & mode, item overrides

void() admin_sv_cfg =
{
	local string str;

/*
if (self.class_select == "class_bot")
{//return;
bprint("------------------- **  admin sv - bot = ");
bprint(item_ident(self));
bprint("\n");
}
*/

	str = ftos(pk_flags);
	if (pk_flags != pk_flags_ck)
		cvar_set("savedgamecfg", str);
	pk_flags_ck = pk_flags;

	str = ftos(pk_itemovr);
	if (pk_itemovr != pk_itemovr_ck)
		cvar_set("saved3", str);
	pk_itemovr_ck = pk_itemovr;

	if (pk_admintime > 0) admin_resettimeout();
};


// clear screen from admin - exit or failed login after wait

void(entity e) admin_clear =
{


/*
if (self.class_select == "class_bot")
{
bprint("------------------- **  admin clear ");
bprint(e.netname);
bprint("\n");
}
*/


	if (e.class_select == "class_bot") return;

	if (e.light_lev > 0)
	{
		stuffcmd(e, "r_ambient ");
		stuffcmd(e, ftos(e.light_lev));
		stuffcmd(e, "\n");
//		e.light_lev = 0; // just always save this - func has multiple re-entry
	}
	else
		stuffcmd(e, "noadmingamma\n");
	stuffcmd(e, "noadmin_centertime\n");
	centerprint(e, "");
	e.impulse = e.admin = 0;
	e.takedamage = DAMAGE_AIM;	
	e.wad = e.message = e.path = e.target = "";
	e.enemy = world;
	if (CAM_DEF & DPCAM_ON)
	{
		stuffcmd(e, "chase_active ");
		stuffcmd(self, ftos(e.cam_x & 1)); // Cataboligne - 8.26.11 - support for dpcam
		stuffcmd(e, "\n");
	}

	if (e.dropent)
	if (e.dropent.classname == "dropinv")
	{
		stuffcmd(e, "con_notifytime "); // restore notify
		stuffcmd(e, ftos(e.dropent.grap_state));
		stuffcmd(e, "\ncon_notify ");
		stuffcmd(e, ftos(e.dropent.grap_length));
		stuffcmd(e, "\n");

		remove(e.dropent);
		e.dropent = world;
	}
	e.aflag = 0;
	
	crosshair_con(e, -1);
};

// clear | set these for players

void(entity e) pk_admincfg =
{
		admin_clear(e);

// set defaults not usually bound by quake
		stuffcmd(e, "bind 9 \"impulse 9\"\n"); // 9 is cheat in sp - this could be annoying for SP
		stuffcmd(e, "bind 0 \"impulse 10\"\n");
		stuffcmd(e, "bind enter \"impulse 11\"\n");
		stuffcmd(e, "bind backspace \"impulse 12\"\n");
}

/*
==========
TeamToggle
==========
*/
void() TeamToggle =
{
	if (cvar("teamplay") == 1)
	{
		self.wad = "\nTeam play is OFF...";
		localcmd("teamplay 0\n");
	}
	else
	{
		self.wad = "\nTeam play is ON...";
		localcmd("teamplay 1\n");
	}
};

/*
==========
DMToggle
==========
*/
void() DMToggle =
{
	if (cvar("deathmatch") == 1)
	{
		self.wad = "\nDeathmatch mode = 3...\nYou must restart level for new settings...";
	  localcmd("deathmatch 3\n");
	}
	else
	{
		self.wad = "\nDeathmatch mode = 1...\nYou must restart level for new settings...";
		localcmd("deathmatch 1\n");
	}
};

/*
==========
CoopToggle
==========
*/
void() CoopToggle =
{
	if (cvar("coop") == 1)
	{
		self.wad = "\nCoop is OFF...\nYou must restart level for new settings...";
		localcmd("coop 0\n");
		localcmd("deathmatch 1\n");
	}
	else
	{
		self.wad = "\nCoop is ON...\nYou must restart level for new settings...";
		localcmd("deathmatch 0\n");
		localcmd("coop 1\n");
	}
};

/*
==========
JumptoNext
==========
*/
void() JumptoNext =
{
	local entity ot;
	ot = find(world, classname, "trigger_changelevel");
	nextmap = ot.map;

	if (inHubMap)
		self.wad = "\nPainkeep hub - level loaded by vote";
//	else if (world.model == "maps/start.bsp" && world.message == "HUB")
//		self.wad = "\nPainkeep hub - level loaded by vote";
//	else if (world.model == "maps/hub2.bsp" || world.model == "maps/hub3.bsp")
//		self.wad = "\na Painkeep hub - level loaded by vote";
	else if (mapname == "start")
		self.wad = "\nOn start map - no next level";
	else if (!nextmap)
		self.wad = "\nNext level is not defined";
	else
	{
		admin_clear(self);
		bprint("Admin executed next level command...\n");
		if (!(custom_hub_loaded && nextmap == "start"))
			PK_ADMINMAP = TRUE; // in custom hub set do not allow loading hub
		GotoNextMap();
	}
};

/*
==========
ResetLevel
==========
*/
void() ResetLevel =
{
	admin_clear(self);
	bprint("Admin executed reset level command...\n");
	nextmap = mapname;
	PK_ADMINMAP = TRUE; // in custom hub set do not allow loading hub
	GotoNextMap();
};

/*
==========
ToggleNoExit
==========
*/
void() ToggleNoExit =
{
	if (cvar("noexit") == 1)
	{
		self.wad = "\nNo Exit is OFF...";
		localcmd("noexit 0\n");
	}
	else
	{
		self.wad = "\nNo Exit is ON...";
		if (cvar("fraglimit") <= 0 && cvar("timelimit") <= 0)
			self.wad = "\nNo Exit is ON...\ntimelimit, fraglimit are 0 - recommend you set one these";
		localcmd("noexit 1\n");
	}
};

/*
==========
variable adjuster
==========
*/
void() Admin_varmenu =
{
	if (self.cnt == 0.01)
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"      adjust variable      \n"
						" +-----------------------+ \n"
						"  increment     decrement  \n"
						"     1:     0.01     :6    \n"
						"     2:     0.1      :5    \n"
						"     3:     1.0      :4    \n"
						"          by value         \n"
						" +-----------------------+ \n"
						"   7: save modification    \n"
						"   8: enter new value      \n"
						"   9: main menu            \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
//	if (self.cnt == 1)
	else
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"      adjust variable      \n"
						" +-----------------------+ \n"
						"  increment     decrement  \n"
						"     1:      1       :6    \n"
						"     2:      10      :5    \n"
						"     3:      100     :4    \n"
						"          by value         \n"
						" +-----------------------+ \n"
						"   7: save modification    \n"
						"   8: enter new value      \n"
						"   9: main menu            \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
	self.wad = "";
	self.admin = self.lip = 19;
};

/*
==========
MapStart
==========
*/
void() MapStart =
{

	admin_clear(self);
	bprint("Admin loaded hub / start map...\n");

	nextmap = hub_select();
	GotoNextMap();
};

/*
==========
MapDM
==========
*/
void() Admin_dmmapmenu2 =
{
	self.message =
					 "\b Painkeep map expansion:\n"
					 "\b+------------------------+\n"
						"  01: pkts01   21: pkn1   \n"
						"  02: pkts02   22: pkn2   \n"
						"  03: pkts03   23: pkn3   \n"
						"  04: pkts04   24: pkn4   \n"
						"  05: pkts05   25: pkn5   \n"
						"  06: pkts06   26: pkn6   \n"
						"  07: pkts07   27: pkn7   \n"
						"  08: pkts08   28: pkn8   \n"
						"  09: pkts09   29: pkn9   \n"
						"  10: pkts10   30: pkn10  \n"
						"  11: pkts11   31: pkn11  \n"
						"  12: pkts12   32: pkn12  \n"
						"  13: pkts13   33: pkn13  \n"
						"  14: pkts14   34: pkn14  \n"
						"  15: pkts00   35: pkn15  \n"
						"    :          36: pkn16  \n"
						"    :          37: pkn17  \n"
						"  18: hub2     38: pkn18  \n"
						"  19: hub3     39: pkn19  \n"
						"  20: chv_hub  40: pkn20  \n"
						"  41: painkeep2           \n"
						"  42: custom hub          \n"
						"  60: original maps       \n"
						"  61: list hub links      \n"
						" 666: main menu           \n"
						"  admin impulse exits     \n"
					 "\b+------------------------+\n"
//					 "              * you must rename or link hub2 & hub3\n"
					 "\b Enter code: ";
};

void() Admin_dmmapmenu =
{
	if (Q_99)
	{
	self.message =
					 "\b  Quake map Menu:\n"
					 "\b+------------------------+\n"
						"    01:  dn1    20: e2m4  \n"
						"    02:  dm2    21: e2m5 \n"
						"    03:  dm3    22: e2m6  \n"
						"    04:  dm4    23: e2m7  \n"
						"    05:  dm5    24: e3m1  \n"
						"    06:  dm6    25: e3m2 \n"
						"    07:  start  26: e3m3  \n"
						"    08:  end    27: e3m4  \n"
						"    09:  e1m1   28: e3m5  \n"
						"    10:  e1m2   29: e3m6  \n"
						"    11:  e1m3   30: e3m7  \n"
						"    12:  e1m4   31: e4m1  \n"
						"    13:  e1m5   32: e4m2  \n"
						"    14:  e1m6   33: e4m3  \n"
						"    15:  e1m7   34: e4m4  \n"
						"    16:  e1m8   35: e4m5  \n"
						"    17:  e2m1   36: e4m6  \n"
						"    18:  e2m2   37: e4m7  \n"
						"    19:  e2m3   38: e4m8  \n"
//						"    60:  new maps         \n"
//						"    61:  list hub links   \n"
						"   666:  main menu        \n"
						"  admin impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}
	else if (PK_ADHUB)
	{
	self.message =
					 "\b  Painkeep map Menu:\n"
					 "\b+------------------------+\n"
						"    01:  pk1    11: pk11  \n"
						"    02:  pk2    12: pk12  \n"
						"    03:  pk3    13: pk13  \n"
						"    04:  pk4    14: pk14  \n"
						"    05:  pk5    15: pk15  \n"
						"    06:  pk6    16: pk16  \n"
						"    07:  pk7    17: pk17  \n"
						"    08:  pk8    18: pk18  \n"
						"    09:  pk9    19: pk0   \n"
						"    10:  pk10   21: hub   \n"
						"    20:  painkeep         \n"
						"    60:  new maps         \n"
						"    61:  list hub links   \n"
						"   666:  main menu        \n"
						"  admin impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	if (self.cnt) Admin_dmmapmenu2();
	}
	else
	{
	self.message =
					 "\b  Painkeep DM map Menu:\n"
					 "\b+------------------------+\n"
						"    01:  pk1    11: pk11  \n"
						"    02:  pk2    12: pk12  \n"
						"    03:  pk3    13: pk13  \n"
						"    04:  pk4    14: pk14  \n"
						"    05:  pk5    15: pk15  \n"
						"    06:  pk6    16: pk16  \n"
						"    07:  pk7    17: pk17  \n"
						"    08:  pk8    18: pk18  \n"
						"    09:  pk9    19: pk0   \n"
						"    10:  pk10   21: hub   \n"
						"    20:  painkeep         \n"
						"    61:  list hub links   \n"
						"   666:  main menu        \n"
						"  admin impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}

	self.wad = "";
	self.admin = 14;
	self.admin_input = 0;
};

// quake compat mode

string() MapQ99 =
{
	local string mname;
	mname = "";
	if (self.admin_input == 01) mname = "dm1";
	else if (self.admin_input == 02) mname = "dm2";
	else if (self.admin_input == 03) mname = "dm3";
	else if (self.admin_input == 04) mname = "dm4";
	else if (self.admin_input == 05) mname = "dm5";
	else if (self.admin_input == 06) mname = "dm6";
	else if (self.admin_input == 07) mname = "start";
	else if (self.admin_input == 08) mname = "end";
	else if (self.admin_input == 09) mname = "e1m1";
	else if (self.admin_input == 10) mname = "e1m2";
	else if (self.admin_input == 11) mname = "e1m3";
	else if (self.admin_input == 12) mname = "e1m4";
	else if (self.admin_input == 13) mname = "e1m5";
	else if (self.admin_input == 14) mname = "e1m6";
	else if (self.admin_input == 15) mname = "e1m7";
	else if (self.admin_input == 16) mname = "e1m8";
	else if (self.admin_input == 17) mname = "e2m1";
	else if (self.admin_input == 18) mname = "e2m2";
	else if (self.admin_input == 19) mname = "e2m3";
	else if (self.admin_input == 20) mname = "e2m4";
	else if (self.admin_input == 21) mname = "e2m5";
	else if (self.admin_input == 22) mname = "e2m6";
	else if (self.admin_input == 23) mname = "e2m7";
	else if (self.admin_input == 24) mname = "e3m1";
	else if (self.admin_input == 25) mname = "e3m2";
	else if (self.admin_input == 26) mname = "e3m3";
	else if (self.admin_input == 27) mname = "e3m4";
	else if (self.admin_input == 28) mname = "e3m5";
	else if (self.admin_input == 29) mname = "e3m6";
	else if (self.admin_input == 30) mname = "e3m7";
	else if (self.admin_input == 31) mname = "e4m1";
	else if (self.admin_input == 32) mname = "e4m2";
	else if (self.admin_input == 33) mname = "e4m3";
	else if (self.admin_input == 34) mname = "e4m4";
	else if (self.admin_input == 35) mname = "e4m5";
	else if (self.admin_input == 36) mname = "e4m6";
	else if (self.admin_input == 37) mname = "e4m7";
	else if (self.admin_input == 38) mname = "e4m8";
//	else if (self.admin_input == 39) mname = "";

	return(mname);
};

// new pk maps in conv pack - return map name

string() MapDM2 =
{
	local string mname;
	mname = "";
	if (self.admin_input == 41) mname = "painkeep2";
	else if (self.admin_input == 01) mname = "pkts01";
	else if (self.admin_input == 02) mname = "pkts02";
	else if (self.admin_input == 03) mname = "pkts03";
	else if (self.admin_input == 04) mname = "pkts04";
	else if (self.admin_input == 05) mname = "pkts05";
	else if (self.admin_input == 06) mname = "pkts06";
	else if (self.admin_input == 07) mname = "pkts07";
	else if (self.admin_input == 08) mname = "pkts08";
	else if (self.admin_input == 09) mname = "pkts09";
	else if (self.admin_input == 10) mname = "pkts10";
	else if (self.admin_input == 11) mname = "pkts11";
	else if (self.admin_input == 12) mname = "pkts12";
	else if (self.admin_input == 13) mname = "pkts13";
	else if (self.admin_input == 14) mname = "pkts14";
	else if (self.admin_input == 15) mname = "pkts00";
//	else if (self.admin_input == 16) mname = "pkts15";
	else if (self.admin_input == 21) mname = "pkn1";
	else if (self.admin_input == 22) mname = "pkn2";
	else if (self.admin_input == 23) mname = "pkn3";
	else if (self.admin_input == 24) mname = "pkn4";
	else if (self.admin_input == 25) mname = "pkn5";
	else if (self.admin_input == 26) mname = "pkn6";
	else if (self.admin_input == 27) mname = "pkn7";
	else if (self.admin_input == 28) mname = "pkn8";
	else if (self.admin_input == 29) mname = "pkn9";
	else if (self.admin_input == 30) mname = "pkn10";
	else if (self.admin_input == 31) mname = "pkn11";
	else if (self.admin_input == 32) mname = "pkn12";
	else if (self.admin_input == 33) mname = "pkn13";
	else if (self.admin_input == 34) mname = "pkn14";
	else if (self.admin_input == 35) mname = "pkn15";
	else if (self.admin_input == 36) mname = "pkn16";
	else if (self.admin_input == 37) mname = "pkn17";
	else if (self.admin_input == 38) mname = "pkn18";
	else if (self.admin_input == 39) mname = "pkn19";
	else if (self.admin_input == 40) mname = "pkn20";
	else if (self.admin_input == 42)
	{
		admin_clear(self);
		mname = "";
		bot_changelevel(); // *bot - reload bots on next level, handle intermission
		bprint("Admin loaded custom hub / start map...\n");
		check_custom_hub(); 
	}
	else if (self.admin_input == 18)
	{
		mname = "hub2";
	}
	else if (self.admin_input == 19)
	{
		mname = "hub3";
	}
	else if (self.admin_input == 20)
	{
		mname = "chv_hub";
	}
	return(mname);
};

// parse code for regular painkeep hub maps

float() MapDM =
{
	local string mname;

	if (Q_99) mname = MapQ99();
	else if (PK_ADHUB && self.cnt && self.admin_input < 60) mname = MapDM2();
	else if (self.admin_input == A_PAINKEEP) mname = "painkeep";
	else if (self.admin_input == A_PK0) mname = "pk0";
	else if (self.admin_input == A_PK1) mname = "pk1";
	else if (self.admin_input == A_PK2) mname = "pk2";
	else if (self.admin_input == A_PK3) mname = "pk3";
	else if (self.admin_input == A_PK4) mname = "pk4";
	else if (self.admin_input == A_PK5) mname = "pk5";
	else if (self.admin_input == A_PK6) mname = "pk6";
	else if (self.admin_input == A_PK7) mname = "pk7";
	else if (self.admin_input == A_PK8) mname = "pk8";
	else if (self.admin_input == A_PK9) mname = "pk9";
	else if (self.admin_input == A_PK10) mname = "pk10";
	else if (self.admin_input == A_PK11) mname = "pk11";
	else if (self.admin_input == A_PK12) mname = "pk12";
	else if (self.admin_input == A_PK13) mname = "pk13";
	else if (self.admin_input == A_PK14) mname = "pk14";
	else if (self.admin_input == A_PK15) mname = "pk15";
	else if (self.admin_input == A_PK16) mname = "pk16";
	else if (self.admin_input == A_PK17) mname = "pk17";
	else if (self.admin_input == A_PK18) mname = "pk18";
	else if (self.admin_input == A_PKHUB)
	{
		mname = "start";
		pk_flags = pk_flags - (pk_flags & PK_HUB2); // just in case we were on a custom hub
	}
	else
	{
		if (self.admin_input == 60) // switch menus
		{
			self.cnt = ! self.cnt;
			Admin_dmmapmenu();
		}
		else if (self.admin_input == 61) // hub links
		{
			local entity e, f, b;
			local vector v1, v2;
			local float dx, mm;
			e = find(world, classname, "hub_teleport");
			if (!e)
				bprint("---------------------\nHub NOT FOUND\n---------------------\n\n");
			else
			{
				bprint("---------------------\nHub map set\n---------------------\n\n");
				while (e)
				{
					if (e.model == "progs/hub_port.mdl" || e.model == "progs/null.mdl")
					{
						if (v1 != ' 0 0 0' && mm < 2)
						{
							bprint("\nmixed mode --- custom hub + regular hub!\n\n");
							mm = 2;
						}
						else
							if (mm < 2) mm = -1;
						bprint(e.map);
						bprint(", trg: ");
						b = e.enemy; // we know trigger messages for custom hubs
						if (!b) bprint("NO TRIGGER!");
						else { bprint(b.message); if (fabs(b.origin_z - e.origin_z) > 25) { bprint(" : Z > 25");} }
						bprint("\n");
						e = find(e, classname, "hub_teleport");
					}
					else
				 {
						if (!v1) bprint("hub_control maps:\n\n");
						if (mm < 0)
						{
							bprint("\nmixed mode --- custom hub + regular hub!\n\n");
							mm = 2;
						}
						bprint(e.map);

	// possible target message - list all after this
					dx = 8001;
					v1 = (e.absmin + e.absmax) * 0.5;
					f = findradius(v1, 8000);
					b = world;
					while (f)
					{
						if (f.classname == "trigger_multiple")
						if (f.message != "" && f.message != "\n" && f.message != " ")
						{
							v2 = (f.mins + f.maxs) * 0.5;
							if (vlen(v1 - v2) < dx)
							{
								b = f;
								dx = vlen(v1 - v2);
							}
						}
					f = f.chain;
					}
					if (b)
					{
						bprint(", possible trg: ");
						bprint(b.message);
						if (fabs(b.origin_z - e.origin_z) > 25) bprint(" : Z > 25");
					}


						bprint("\n");
						e = find(e, classname, "hub_teleport");
					if (!e)
					{
					bprint("\npossible map messages:\n\n");
					f = findradius(world.origin, 32000);
					while (f)
					{
						if (f.classname == "trigger_multiple")
						if (f.message != "" && f.message != "\n" && f.message != " ")
						{
							bprint(f.message);
							bprint("\n");
						}
					f = f.chain;
					}
						
					}
				 }
			  }

				bprint("\n---------------------\n");
		  }
		}

		return(FALSE);
	}
	if (mname == "") return(FALSE);

	bprint("Admin changing map to ");
	bprint(mname);
	bprint("\n");

	admin_clear(self);
	admin_sv_cfg();
	bot_changelevel(); // *bot - reload bots on next level, handle intermission
	NoExit_save(); // Cataboligne - 9.9.11 - protect against exitless levels in dm - restore setting
	changelevel(mname);
	return(TRUE);
};

/*
==========
StartKick
==========
*/
float KICKCODE = -94562375;

void() find_Kick =
{
	self.enemy = find(self.enemy, classname, self.target);
	if (!self.enemy) // end of list - 1st switch
	{
		if (self.target == "player") self.target = OBSERVER;
		else self.target = "player";
		self.enemy = find(world, classname, self.target);
		if (!self.enemy) // 2nd list no good - try looping
		{
			if (self.target == "player") self.target = OBSERVER;
			else self.target = "player";
			self.enemy = find(world, classname, self.target);
		}
		if (!self.enemy) Admin_mainmenu(); // nothing found for either search ?? - go back
	}
	self.admin_input = 0;
};

void() Admin_kickmenu =
{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"   1: kick player ->       \n\n";

	self.admin_input = 0;
	if (self.impulse == 1)
	{
		if (self.enemy == self)
		self.wad =
				  "\n\n   3: next player          \n"
						"   7: confirm kick         \n"
						"   6: main menu            \n"
						"  admin impulse exits      \n"
					 "\b+-------------------------+\n"
					 "\b      7 to confirm!        \n any other entry cancels  \n\b*** YOU ARE KICKING YOURSELF IF YOU ENTER 7! ***";
		else
		self.wad =
				  "\n\n   3: next player          \n"
						"   7: confirm kick         \n"
						"   6: main menu            \n"
						"  admin impulse exits      \n"
					 "\b+-------------------------+\n"
					 "\b      7 to confirm!        \n any other entry cancels  \n\b*** PLAYER WILL BE KICKED IF YOU ENTER 7! ***";
	self.admin_input = KICKCODE;
	}
	else
		self.wad =
				  "\n\n   3: next player          \n"
						"   7: confirm kick         \n"
						"   6: main menu            \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";

	self.admin = 15;
};
/*
==========
Bots
==========
*/

// set skill for bot admin if parm >0 if parm = 0 increment skill by 1, loop after 3

float(float sk) skill_add =
{
	local float skl;
	if (sk) skl = sk;
	else
	{
		skl = cvar("skill");
		skl = skl + 1;
	}
	if (skl > 3) skl = 0;
	localcmd("skill ");
	localcmd(ftos(skl));
	localcmd("\n");
	return(skl);
};

void() Admin_botmenu =
{
	self.message =
				       "\b     Admin Bot Menu:     \n"
				       "\b+--------------------------+\n"
							"    pk*bot       frikbot    \n"
							" 01: add bot   11: add bot  \n"
							" 02: remove 1  12: remove 1 \n"
							" 03: 3 *skill  13: 3 *skill \n"
							" - add 1 bot of each skill  \n"
							" 04: add 4     14: add 4    \n"
							" - add 4 bots - same skill  \n"
							" 05: verbose                \n"
							" 06: update    20: +skill   \n"
//							" 07: unrestricted           \n"
							" 08: observer mode          \n"
							" 09: observer time          \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	self.wad = "";
	self.admin = 18;
	self.admin_input = 0;
};

/*
==========
Items menu admin
==========
*/
void() Admin_itembits =
{
	local string adv, it, ad2;
	local float f;

	if (! pk_itemovr & CON_ANY)
	{
		bprint("\b--------------------------------\n");
		self.wad = "\nNo bits are set in item override!";
		bprint("\b--------------------------------\n");
		return;
	}
	if (pk_itemovr & ITEM_ANY)
	{
		self.wad = "\nBits set in item override listed.";
		bprint("\b--------------------------------\n");
	}
	f = 1;
	adv = "Bit set";
	if (pk_itemovr & CON_CYC) adv = "Cycle";
	else if (pk_itemovr & CON_ONLY) adv = "Only";
	else if (pk_itemovr & CON_NONE)
	{
		adv = "None of";
		if (pk_itemovr & CON_SUBS) adv = "Subs for";
	}
	if (pk_itemovr & CON_INF) ad2 = " - Infinite ammo";

	while (f != CON_STOP)
	{
		it = "";
		if (f & pk_itemovr)
			it = item_by_bit(f);
		if (it != "")
		{
			bprint(adv);
			bprint(": ");
			bprint(it);
			if (it != "pki" || ad2 != " - Infinite ammo")
			if (f < WEP_STOP) bprint(ad2);
			bprint("\n");
		}
		f = f * 2;
	}
	f = 0;
	bprint("\b--------------------------------\n");
// display control bits
	if (pk_itemovr & CON_ONLY)
	{
		f = f + 1;
		bprint("Only these items will be loaded\n");
	}
	if (pk_itemovr & CON_NONE)
	{
		f = f + 1;
		bprint("None of these items will be loaded\n");
	}
	if (pk_itemovr & CON_CYC)
	{
		f = f + 1;
		bprint("Cycle items in each section\n");
		bprint("- cycle timer = ");
		bprint(ftos(CYC_TIME));
		bprint("\n");
	}
// display modifier bits
	if (pk_itemovr & CON_SUBS)
	{
		bprint("Substitute removed items\n");
		if (!(pk_itemovr & CON_NONE) && !(pk_itemovr & CON_ONLY))
			bprint("\b- nothing to substitute!\n");
	}
	if (pk_itemovr & CON_INF)
	{
		bprint("Infinite ammo on selected weapons\n");
		if (! pk_itemovr & WEP_WEPSQ) bprint("\b- no weapon bits set!\n");
		if (PK && (pk_itemovr & WEP_PKI)) bprint("- sub pk items for ammo boxes\n");
	}
	if (!f) bprint("\n\bNo control bits!\n\n");
	else
	{
		if (! pk_itemovr & ITEM_ANY) bprint("\bNo items selected!\n");
//		if (f == 3) bprint("\bItem Cha*s selected...\n");
//		else
		if (f > 1) bprint("\bPossible control conflict!\n");
	}
	bprint("\b--------------------------------\n");
};

string() build_itemmenu =
{
	local string f;

	f =		       "\b     Admin Items Menu:     \n"
				       "\b+--------------------------+\n"
							"  +------- \bweapons\b ------+  \n"
							"  01: Double shotgun        \n" // 1
							"  02: Nailgun               \n" // 2
							"  03: Preforator            \n" // 4
							"  04: Grenade launcher      \n" // 8
							"  05: Rocket launcher       \n" // 16
							"  06: Lightning gun         \n" // 32
							"  07: Painkeep items        \n" // 64
							"  +------ \bartifacts\b -----+  \n" 
							"  08: Quad damage           \n" // 128
							"  09: Invulnerability       \n" // 256
							"  10: Radiation suit        \n" // 512
							"  11: Ring of shadows       \n" // 1024
							"  +-------- \barmor\b -------+  \n" 
							"  12: Green Armor           \n" // 2048
							"  13: Yellow Armor          \n" // 4096
							"  14: Red Armor             \n" // 8192
							"  +------- \bhealth\b -------+  \n" 
							"  15: 15 Health             \n" // 16384
							"  16: 25 Health             \n" // 32768
							"  17: Mega Health           \n" // 65536
							"  +------ \bcontrols\b ------+  \n" 
							"  18: Only these items      \n" // 131072
							"  19: None of these items   \n" // 262144
							"  20: Substitute removed    \n" // 542288
							"  21: Infinite ammo         \n" // 1048576
							"  22: Cycle selected items  \n" // 2097152
							"  29: All bits off          \n" 
							"  30: Show item bits        \n" 
							"  31: Update map now        \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";
	return(f);
};

void() Admin_itemmenu =
{
	if (Q_99)
	{
	self.message =
				       "\b     Admin Items Menu:     \n"
				       "\b+--------------------------+\n"
							"  +------- \bweapons\b ------+  \n"
							"  01: Double shotgun        \n" // 1
							"  02: Nailgun               \n" // 2
							"  03: Preforator            \n" // 4
							"  04: Grenade launcher      \n" // 8
							"  05: Rocket launcher       \n" // 16
							"  06: Lightning gun         \n" // 32
//							"  07: Painkeep items        \n" // 64
							"  +------ \bartifacts\b -----+  \n" 
							"  08: Quad damage           \n" // 128
							"  09: Invulnerability       \n" // 256
							"  10: Radiation suit        \n" // 512
							"  11: Ring of shadows       \n" // 1024
							"  +-------- \barmor\b -------+  \n" 
							"  12: Green Armor           \n" // 2048
							"  13: Yellow Armor          \n" // 4096
							"  14: Red Armor             \n" // 8192
							"  +------- \bhealth\b -------+  \n" 
							"  15: 15 Health             \n" // 16384
							"  16: 25 Health             \n" // 32768
							"  17: Mega Health           \n" // 65536
							"  +------ \bcontrols\b ------+  \n" 
							"  18: Only these items      \n" // 131072
							"  19: None of these items   \n" // 262144
							"  20: Substitute removed    \n" // 542288
							"  21: Infinite ammo         \n" // 1048576
							"  22: Cycle selected items  \n" // 2097152
							"  29: All bits off          \n" 
							"  30: Show item bits        \n" 
							"  31: Update map now        \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";
	}
	else
	{
	self.message = build_itemmenu();
	}
	self.wad = "";
	self.admin = 26;
	self.admin_input = 0;
};

/*
==========
Monsters menu admin
==========
*/

void() Admin_allmonsters =
{
	local string it;
	local float f, mn, c, m;

	mn = 0;
	c = MON_NAME_REG;
	m = MONSTER_MASK;
	if (self.cnt) 
	{
		c = MON_NAME_II;
		m = MONSTER_MASK_II;
	}

	bprint("\b--------------------------------\n");
	mn = 1;
	bprint("All monsters bit set: ");
	bit_print(m, m);
	bprint(" f: ");
	bprint(ftos(m));
	bprint("\n\nlist of all monsters:\n");
	f = 1;
	while (f < MONSTER_MASK)
	{
		it = monster_id(f, c);
		bprint(it);
		bprint("\n"); 
		f = f * 2;
	}

	bprint("\b--------------------------------\n");
};

void() Admin_monsterbits =
{
	local string it;
	local float f, mn, c, m, SS, CC, MM;

	mn = 0;
	c = MON_NAME_REG;
	m = MONSTER_MASK;
	SS = S_MONSTER;
	CC = C_MONSTER;
	MM = M_MONSTER;
	if (self.cnt) 
	{
		c = MON_NAME_II;
		m = MONSTER_MASK_II;
		SS = S_MONSTER_II;
		CC = C_MONSTER_II;
		MM = M_MONSTER_II;
	}

	bprint("\b--------------------------------\n");
	if (! MM & m)
		bprint("No map monsters appearing in DM\n");
	else
	{
		mn = 1;
		bprint("Map monsters bit set: ");
		bit_print(m, MM);
		bprint(" f: ");
		bprint(ftos(MM));
		bprint("\n\nlist appearing in DM:\n");
		f = 1;
		while (f < m)
		{
			it = monster_id(f, c);
			if (f & MM) { bprint(it); bprint("\n"); }
			f = f * 2;
		}
	}

	bprint("\b--------------------------------\n");
	if (! SS & m)
		bprint("No map monsters will respawn\n");
	else
	{
		mn = 1;
		bprint("Respawn monsters bit set: ");
		bit_print(m, SS);
		bprint(" f: ");
		bprint(ftos(SS));
		bprint("\n\nlist that respawn:\n");
		f = 1;
		while (f < m)
		{
			it = monster_id(f, c);
			if (f & SS) { bprint(it); bprint("\n"); }
			f = f * 2;
		}
	}
	bprint("\b--------------------------------\n");
	if (! CC & m)
		bprint("No random monsters appearing in DM\n");
	else
	{
		mn = 1;
		bprint("Random monsters bit set: ");
		bit_print(m, CC);
		bprint(" f: ");
		bprint(ftos(CC));
		bprint("\n\nlist appearing in DM:\n");
		f = 1;
		while (f < m)
		{
			it = monster_id(f, c);
			if (f & CC) { bprint(it); bprint("\n"); }
			f = f * 2;
		}
	}

	bprint("\b--------------------------------\n");
	bprint("Control bits set: ");
	bit_print(m, pk_monster_set);
	bprint(" f: ");
	bprint(ftos(pk_monster_set));
	bprint("\n\nlist contol set:\n");
	f = 1;
	while (f < m)
	{
		it = monster_id(f, c);
		if (f & pk_monster_set) { bprint(it); bprint("\n"); }
		f = f * 2;
	}

	bprint("\b--------------------------------\n");
	if (!mn) self.wad = "\nNo monster controls set.";
};

/*
==========
Monsters menu admin
==========
*/
void() Admin_monstermenu2 =
{
	self.message =
				       "\b     Admin Monster Menu:    \n"
				       "\b+--------------------------+\n"
							"  +------- \bmonster\b ------+  \n"
							"  01: Blarg                 \n" // 1
							"  02: Velociraptor          \n" // 2
							"  03: Phase spider          \n" // 4
							"  04: Manga Tai             \n" // 8
							"  05: Bossman               \n" // 16
							"  06: Alien pod             \n" // 32
//							"  07:        \n" // 64
//							"  08:        \n" // 128
//							"  09:        \n" // 256
//							"  10:        \n" // 512
//							"  11:        \n" // 1024
//							"  12:        \n" // 2048
//							"  13:        \n" // 4096
//							"  14:        \n" // 8192
//							"  15:        \n" // 16384
//							"  16:        \n" // 32768
//							"  17:        \n" // 65536
//							"  18:        \n" // 131072
//							"  19:        \n" // 262144
//							"  20:        \n" // 542288
//							"  21:        \n" // 1048576
//							"  22:        \n" // 2097152
//							"  23:        \n" // 4194304
//							"  24:        \n" // 8388608
							"  +------ \bcontrols\b ------+  \n" 
							"  26: Bits -> map monsters  \n" 
							"  27: Bits -> to random     \n"
							"  28: Bits -> to respawn    \n"
							"  29: All bits off          \n" 
							"  30: Show monster bits     \n"
							"  31: List all monsters     \n"
							"  32: Monster set I         \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";
};

void() Admin_monstermenu =
{
	self.message =
				       "\b     Admin Monster Menu:    \n"
				       "\b+--------------------------+\n"
							"  +------- \bmonster\b ------+  \n"
							"  01: Army Grunt            \n" // 1
							"  02: Fish                  \n" // 2
							"  03: Knight                \n" // 4
							"  04: Rabid Dog             \n" // 8
							"  05: Fiend                 \n" // 16
							"  06: Enforcer              \n" // 32
							"  07: Hell Knight           \n" // 64
							"  08: Ogre                  \n" // 128
							"  09: Shalrath              \n" // 256
							"  10: Shambler              \n" // 512
							"  11: Scragg                \n" // 1024
							"  12: Zomby                 \n" // 2048
							"  13: Cthon                 \n" // 4096
							"  14: Spawn                 \n" // 8192
							"  15: Scourge               \n" // 16384
							"  16: Shubbers              \n" // 32768
							"  17: Vorerel               \n" // 65536
							"  18: Gremlin               \n" // 131072
							"  19: Vomitus               \n" // 262144
//							"  20:        \n" // 542288
//							"  21:        \n" // 1048576
//							"  22:        \n" // 2097152
//							"  23:        \n" // 4194304
//							"  24:        \n" // 8388608
							"  +------ \bcontrols\b ------+  \n" 
							"  26: Bits -> map monsters  \n" 
							"  27: Bits -> to random     \n"
							"  28: Bits -> to respawn    \n"
							"  29: All bits off          \n" 
							"  30: Show monster bits     \n"
							"  31: List all monsters     \n"
							"  32: Monster set II        \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	if (self.cnt) Admin_monstermenu2();
	self.wad = "";
	self.admin = 30; //  - this & 3 must = 2
	self.admin_input = 0;
};

/*
==========
Painkeep impulses
==========
*/
void() Admin_pkmenu =
{
	if (PK_100)
	self.message =
				       "\b    Admin Painkeep Menu:    \n"
				       "\b+--------------------------+\n"
							"  01: SFX toggle            \n"
							"  02: HUB mode toggle       \n"
							"  03: Duty check toggle     \n"
							"  04: settings list         \n"
//							"  05: PK dynamic items      \n"
//							"  06: Spike traps           \n"
							"  07: Server map loop       \n"
							"    : PK v1.11 Compatible   \n"
//							"  07: Extra sound           \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";
	else
	self.message =
				       "\b    Admin Painkeep Menu:    \n"
				       "\b+--------------------------+\n"
							"  01: SFX toggle            \n"
							"  02: HUB mode toggle       \n"
							"  03: Duty check toggle     \n"
							"  04: settings list         \n"
							"  05: PK dynamic items      \n"
							"  06: Spike traps           \n"
							"  07: Server map loop       \n"
							"    : PK 2.X server         \n"
//							"  07: Extra sound           \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	self.wad = "";
	self.admin = 22;
	self.admin_input = 0;
};

/*
==========
AdminCommands
==========
*/
void() Admin_mainmenu =
{
	if (Q_99)
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"  01:  toggle deathmatch   \n"
						"  02:  toggle teamplay     \n"
						"  03:  toggle coop         \n"
						"  04:  toggle no exit      \n"
						"  05:  goto next level     \n"
						"  06:  reset level         \n"
						"  07:  start map load      \n"
						"  10:  server frag limit   \n"
						"  11:  server time limit   \n"
						"  12:  server gravity      \n"
						"  13:  server friction     \n"
						"  22:  map control         \n"
						"  23:  bot control         \n"
//						"  24:  painkeep control    \n"
						"  25:  item control        \n"
						"  26:  monster control     \n"
						"  30:  kick players        \n"
//						"  60:  PK mode toggle      \n"
//						"  ---  PK mode = TRUE      \n"
						"  97:  exit menu only      \n"
						"  98:  observer            \n"
						"  99:  respawn (exits)     \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
	else if (PK_100)
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"  01:  toggle deathmatch   \n"
						"  02:  toggle teamplay     \n"
						"  03:  toggle coop         \n"
						"  04:  toggle no exit      \n"
						"  05:  goto next level     \n"
						"  06:  reset level         \n"
						"  07:  hub map load        \n"
						"  10:  server frag limit   \n"
						"  11:  server time limit   \n"
						"  12:  server gravity      \n"
						"  13:  server friction     \n"
						"  22:  map control         \n"
						"  23:  bot control         \n"
						"  24:  painkeep control    \n"
//						"  25:  item control        \n"
//						"  26:  monster control     \n"
						"  30:  kick players        \n"
//						"  60:  PK mode toggle      \n"
						"  ---  PK mode = TRUE      \n"
						"  97:  exit menu only      \n"
						"  98:  observer            \n"
						"  99:  respawn (exits)     \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
	else if (PK) // menu with PK only entries
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"  01:  toggle deathmatch   \n"
						"  02:  toggle teamplay     \n"
						"  03:  toggle coop         \n"
						"  04:  toggle no exit      \n"
						"  05:  goto next level     \n"
						"  06:  reset level         \n"
						"  07:  hub map load        \n"
						"  10:  server frag limit   \n"
						"  11:  server time limit   \n"
						"  12:  server gravity      \n"
						"  13:  server friction     \n"
						"  22:  map control         \n"
						"  23:  bot control         \n"
						"  24:  painkeep control    \n"
						"  25:  item control        \n"
						"  26:  monster control     \n"
						"  30:  kick players        \n"
						"  60:  PK mode toggle      \n"
						"  ---  PK mode = TRUE      \n"
						"  97:  exit menu only      \n"
						"  98:  observer            \n"
						"  99:  respawn (exits)     \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
	else
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"  01:  toggle deathmatch   \n"
						"  02:  toggle teamplay     \n"
						"  03:  toggle coop         \n"
						"  04:  toggle no exit      \n"
						"  05:  goto next level     \n"
						"  06:  reset level         \n"
						"  07:  start map load      \n"
						"  10:  server frag limit   \n"
						"  11:  server time limit   \n"
						"  12:  server gravity      \n"
						"  13:  server friction     \n"
						"  22:  map control         \n"
						"  23:  bot control         \n"
						"  24:  painkeep control    \n"
						"  25:  item control        \n"
						"  26:  monster control     \n"
						"  30:  kick players        \n"
						"  60:  PK mode toggle      \n"
						"  ---  PK mode = FALSE     \n"
						"  97:  exit menu only      \n"
						"  98:  observer            \n"
						"  99:  respawn (exits)     \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}

	self.target = self.path = self.wad = "";
	self.admin = 6;
	self.admin_input = 0;
};

// setup timer for closing menus

// lt - light up admin if true
// tm - timeout to use

void(float lt, float tm) admin_timer =
{
	if (self.goalentity && self.goalentity.classname == "admintimer") // 'e says they already got one
	{
		remove(self.goalentity);
//		return; // fix - if we retime from user menu to admin we need to light up admin
	}

	self.goalentity = spawn();
	if (!self.goalentity) return;
	self.goalentity.classname = "admintimer";
	self.goalentity.owner = self;
	self.goalentity.think = PK_AdminImpulse;
	self.goalentity.nextthink = time + tm;

// if lt is true, this is a beacon light over an admin player
	if (lt)
	{
		self.goalentity.effects = EF_DIMLIGHT;
		setmodel(self.goalentity, "progs/s_light.spr"); // let everyone know this guy is in admin mode
	}
};

void() AdminCommands =
{
	local entity z;
	local float e, f;
	local string str;

	if (cvar("chase_active") > 0) stuffcmd(self, "chase_active 0\n");

	if (self.admin == 1)																// login
	{
		if (self.admin_input != pk_admincode)
		{
			self.attack_finished = time + A_DELAY; // penalty - cant use this for invulnerable state
			self.admin = ADMIN_FAILED_LOGIN;
			centerprint3(self, "admin password entry failure, you must wait ",ftos(A_DELAY)," secs!\n");
			return;
		}
		centerprint(self,"Administration privileges enabled, hit \b[ENTER]");
		Admin_mainmenu();
		if (pk_admintime > 0) // admin timeout
		{
			admin_timer(TRUE, pk_admintime);
		}
		return;
	}
	else if (self.admin < 6)															// main menu
	{
		self.admin = 6;
// main menu options
		if (self.admin_input == A_FRAGL)
		{
			self.wad = "\nEnter a new frag limit";
			self.admin_input = cvar("fraglimit");
			self.admin = 10;
			self.lip = 6;
			self.path = "fraglimit ";
			self.target = "\nfraglimit changed...";
		}
		else
		if (self.admin_input == A_TIMEL)
		{
			self.wad = "\nEnter a new time limit";
			self.admin_input = cvar("timelimit");
			self.admin = 10;
			self.lip = 6;
			self.path = "timelimit ";
			self.target = "\ntimelimit changed...";
		}
		else
		if (self.admin_input == A_GRAVU)
		{
			self.cnt = 1;
			Admin_varmenu();
			self.noise = "sv_gravity ";
			self.wad = "\nadjusting sv_gravity";
			self.admin_input = cvar("sv_gravity");
		}
		else
		if (self.admin_input == A_FRICU)
		{
			self.cnt = 0.01;
			Admin_varmenu();
			self.noise = "sv_friction ";
			self.wad = "\nadjusting sv_friction";
			self.admin_input = cvar("sv_friction");
		}
		else
		if (self.admin_input == A_TEAMT) TeamToggle(); else
		if (self.admin_input == A_DMT) DMToggle(); else
		if (self.admin_input == A_COOPT) CoopToggle(); else
		if (self.admin_input == A_JUMP) JumptoNext(); else
		if (self.admin_input == A_RESET) ResetLevel(); else
		if (self.admin_input == A_NOEX) ToggleNoExit(); else
		if (self.admin_input == A_START) MapStart(); else
		if (self.admin_input == A_DMMAP)
		{
			self.cnt = custom_hub_loaded; // pk_flags & PK_HUB2;
			Admin_dmmapmenu();
		}
		else
		if (self.admin_input == A_BOTS) Admin_botmenu(); else
		if (self.admin_input == A_PKCON)
		{
			if (!Q_99)  Admin_pkmenu();
		}
		else
		if (self.admin_input == A_ITEM)
		{
			if (!PK_100) Admin_itemmenu();
		}	
		else
		if (self.admin_input == A_MONST) // Cat - 9.19.11 - added monster controls to admin interface
		{
			if (!PK_100) Admin_monstermenu();
		}	
		else
		if (self.admin_input == A_PKMOD)
		{
		  if (!PK_100 && !Q_99)
		 {
			f = pk_flags & PK_MAP;
			pk_flags = pk_flags - f;
			if (f & PK_ALWAYS)
			{
				f = PK_NEVER;
				PK = 0;
				str = "\nPainkeep mode = never\npainkeep code never enabled\n*map items will not change until reloaded";
			}
			else if (f & PK_NEVER)
			{
				f = 0;
				PK = PK_mapmode(world.model);
				str = "\nPainkeep mode = map\npainkeep code enabled for painkeep maps\n*map items will not change until reloaded";
			}
			else
			{
				f = PK_ALWAYS;
				PK = 1;
				str = "\nPainkeep mode = always\npainkeep code always enabled\n*map items will not change until reloaded";
			}

			pk_flags = pk_flags | f;
			admin_sv_cfg();
			Admin_mainmenu();
			self.wad = str;
		 }
		}
		else
		if (self.admin_input == A_SKICK)
		{
			self.target = "player";
			self.enemy = world;
			find_Kick();
			if (self.enemy) Admin_kickmenu();
		}
		else if (self.admin_input == 97)													// live in game admin - not in menu
		{
			self.admin = LIVE_ADMIN;
			self.wad = self.message = self.path = self.target = "";
			self.enemy = world;
			centerprint(self, "");
			self.takedamage = DAMAGE_AIM;
			self.impulse = 0;
			if (self.light_lev > 0)
			{
				stuffcmd(self, "r_ambient \n");
				stuffcmd(self, ftos(self.light_lev));
				stuffcmd(self, "\n");
//				self.light_lev = 0;
			}
			else
				stuffcmd(self, "noadmingamma\n"); // set gamma level
			stuffcmd(self, "noadmin_centertime\n");
			sprint(self,"Entering live game admin mode - timeout is: ");
			if (pk_admintime < 60)
			{
				sprint(self,ftos(pk_admintime));
				sprint(self," seconds\n");
			}
			else
			{
				sprint(self,ftos(floor(pk_admintime / 60)));
				sprint(self," minutes\n");
			}
			sprint(self,"after which admin will turn off.\n");
			sprint(self,"Use admin impulse to return to menu mode.\n");
			return;
		}
		else if (self.admin_input == 98)
		{
			observer();
			self.goalentity.effects = 0;
			setmodel(self.goalentity, ""); // no light on admin observer
		}
		else if (self.admin_input == 99)													// admin respawn - exits admin mode
		{
			self.impulse = pk_adminimp;
			PK_AdminImpulse();
			centerprint(self, "");
			self.classname = "player";
			setmodel(self, ""); // dont let body que make a copy of a live player
			respawn ();
			return;
		}
		else
			self.admin_input = 0;
	}
	else if (self.admin == 9)															// new data value entered
	{
		if (self.path == "observer_time")
		{
			observer_time = self.admin_input;
		}
		else
		{
			if (self.path == "fraglimit ")
			if (NOEXIT_SAVEFRAG > -1)
				NOEXIT_SAVEFRAG = self.admin_input;

			if (self.path == "timelimit ")
			if (NOEXIT_SAVETIME > -1)
				NOEXIT_SAVETIME = self.admin_input;

			localcmd(self.path);
			localcmd(ftos(self.admin_input));
			localcmd("\n");
		}
		self.admin = self.lip; // admin level we are on
		self.wad = self.target;
		self.target = self.path = "";
		if (self.lip != 19) self.admin_input = 0;
	}
	else if (self.admin == 13)														// dm map from painkeep set
	{
		if (self.admin_input == 666)
			Admin_mainmenu();
		else
		{
			if (MapDM()) return;
			self.admin = 14;
			self.admin_input = 0;
		}
		self.wad = "\nNo map change.";
	}
	else if (self.admin == 15)														// kick players
	{
		if (self.admin_input == KICKCODE)
		{
			if (self.impulse == 7)
			{
				localcmd("kick ");
				localcmd(self.enemy.netname);
				localcmd("\n");
				self.enemy = world;
				Admin_kickmenu();
				find_Kick();
			}
			else
			{
				self.impulse = 0;
				Admin_kickmenu();
			}
		}
		else if (self.impulse == 6)
			Admin_mainmenu();
		else if (self.impulse == 1) Admin_kickmenu();
		else if (self.impulse == 3) find_Kick();
	}
	else if (self.admin == 17)														// bots
	{
		self.admin = 18;
		if (self.admin_input == 666)
			Admin_mainmenu();
		else if (self.admin_input == 1 || self.admin_input == 3 || self.admin_input == 4)
		{
			self.wad = "\nCould NOT load pk*bot(s) on server.";
			e = NUMBOTS;
			if (self.admin_input == 3) f = 1;
			else f = -1;
			AddAnotherBot (f);
			if (e != NUMBOTS) self.wad = "\nLoaded a pk*bot on server.";
			if (self.admin_input != 1)
			{
				e = NUMBOTS;
				if (self.admin_input == 3) f = f + 1;
				AddAnotherBot (f);
				if (self.admin_input == 3) f = f + 1;
				AddAnotherBot (f);
				if (self.admin_input != 3) AddAnotherBot (f);
				if (e != NUMBOTS) self.wad = "\nLoaded requested pk*bot(s) on server.";
			}
			if (e != NUMBOTS)
			if (DARKPLACES || chaos) th_bot_changeParms(3);
			self.admin_input = 0;
		}
		else if (self.admin_input == 11 || self.admin_input == 13 || self.admin_input == 14)
		{
			self.wad = "\nCould NOT load frikbot(s) on server.";
			e = bot_count;
			if (self.admin_input == 13) f = 1;
			else f = cvar("skill");
			BotConnect(0, 0, f);
			if (e != bot_count) self.wad = "\nLoaded A frikbot on server.";
			if (self.admin_input != 11)
			{
				e = bot_count;
				if (self.admin_input == 13) f = f + 1;
				BotConnect(0, 0, f);
				if (self.admin_input == 13) f = f + 1;
				BotConnect(0, 0, f);
				if (self.admin_input != 13) BotConnect(0, 0, f);
				if (e != bot_count) self.wad = "\nLoaded requested frikbot(s) on server.";
			}
			if (e != bot_count)
			if (DARKPLACES || chaos) th_bot_changeParms(3);
			self.admin_input = 0;
		}
		else if (self.admin_input == 2)
		{
			e = NUMBOTS;
			self.wad = "\nCould not remove a pk*bot from server.";
			removeBot(world);
			if (e != NUMBOTS) self.wad = "\nRemoved a pk*bot from server.";
			self.admin_input = 0;
		}
		else if (self.admin_input == 12)
		{
			e = bot_count;
			self.wad = "\nCould not remove a frikbot from server.";
			KickABot();
			if (e != bot_count) self.wad = "\nRemoved a frikbot from server.";
			self.admin_input = 0;
		}
		else if (self.admin_input == 5)
		{
			setVerboseMode();
			if (VERBOSEBOT)
				self.wad = "\npk*bots will not be quiet.";
			else
				self.wad = "\ncats got pk*bots tongues.";
			self.admin_input = 0;
		}
/*
		else if (self.admin_input == 7)
		{
//			if (serverflags & UNRESTRICTED)
			{
//				serverflags = (serverflags - UNRESTRICTED);
				self.wad = "\nBot commands restricted to admin.";
			}
			else
			{
//				serverflags = (serverflags | UNRESTRICTED);
				self.wad = "\nBot commands NOT restricted on server.\n\banyone can issue bot admin commands!";
			}
			self.admin_input = 0;
		}
*/
		else if (self.admin_input == 8)
		{
//			if (serverflags & FL_OBSERVER)
			if (cvar("sv_observe"))
			{
//				serverflags = (serverflags - FL_OBSERVER);
				cvar_set("sv_observe", "0");
				self.wad = "\nOnly admins can observe.";
			}
			else
			{
//				serverflags = (serverflags | FL_OBSERVER);
				cvar_set("sv_observe", "1");
				self.wad = "\n\bAll players can observe.";
			}
			self.admin_input = 0;
		}
		if (self.admin_input == 9)
		{
			self.wad = "\nEnter an observer time limit in seconds";
			self.admin_input = observer_time;
			self.admin = 10;
			self.lip = 18;
			self.path = "observer_time";
			self.target = "\nObserver time limit changed...";
		}
		else if (self.admin_input == 20)
		{
			f = skill_add(0);
			if (!f) self.wad = "\nSkill level is 0.";
			else if (f == 1) self.wad = "\nSkill level is 1.";
			else if (f == 2) self.wad = "\nSkill level is 2.";
			else if (f == 3) self.wad = "\nSkill level is 3.";
			else self.wad = "\nSkill level is UNKNOWN!.";
			self.admin_input = 0;
		}
		else
			self.admin_input = 0;
	}
	else if (self.admin == 19)														// variable adjust
	{
		self.path = self.noise;
		if (self.impulse == 9)
		{
			self.cnt = 0;
			self.wad = self.noise = "";
			Admin_mainmenu();
			setBotGravity(); // *bots
		}
		else if (self.impulse == 8)
		{
			self.target = self.wad;
			self.wad = "\nEnter a valid value";
			self.admin = 10;
		}
		else if (self.impulse == 1) self.admin_input = self.admin_input + self.cnt;
		else if (self.impulse == 2) self.admin_input = self.admin_input + (10 * self.cnt);
		else if (self.impulse == 3) self.admin_input = self.admin_input + (100 * self.cnt);
		else if (self.impulse == 4) self.admin_input = self.admin_input - (100 * self.cnt);
		else if (self.impulse == 5) self.admin_input = self.admin_input - (10 * self.cnt);
		else if (self.impulse == 6) self.admin_input = self.admin_input - self.cnt;
		else if (self.impulse == 7)
		{
			localcmd(self.path);
			localcmd(ftos(self.admin_input));
			localcmd("\n");
		}
	}
	else if (self.admin == 21)														// painkeep specific items
	{
		self.admin = 22;
		if (self.admin_input == 666)
			Admin_mainmenu();
		else if (self.admin_input == 1)
		{
			if (pk_flags & PK_TP_SPARKSFLASH)
			{
				self.wad = "\nSFX Enabled.";
				if (XENV) self.wad = "\nSFX Enabled - but blocked by XENV (sv_c_xenv).";
				pk_bas_flags(PK_TP_SPARKSFLASH, 1);
			}
			else
			{
				self.wad = "\nSFX Disabled.";
				pk_bas_flags(PK_TP_SPARKSFLASH, 0);
			}
		}
		else if (self.admin_input == 2)
		{
			if (pk_flags & PK_SF_HUB)
			{
				self.wad = "\nHub mode OFF";
				pk_bas_flags(PK_SF_HUB, 0);
			}
			else
			{
				self.wad = "\nHub mode ON";
				pk_bas_flags(PK_SF_HUB, 1);
			}
		}
		else if (self.admin_input == 3)
		{
			if (pk_flags & PK_TP_DUTYON)
			{
				self.wad = "\nDuty Checking OFF";
				pk_bas_flags(PK_TP_DUTYON, 0);
			}
			else
			{
				self.wad = "\nDuty Checking ON";
				pk_bas_flags(PK_TP_DUTYON, 1);
			}
		}
		else if (self.admin_input == 4)
		{
			self.wad = "\nSettings printed to console";
			sprint(self, "\n\nPainkeep main controls:\n");
			sprint(self, "\b-----------------------\n");
			if (!(pk_flags & PK_SF_HUB))
				sprint(self, "Voting Hub On       --- (sv_pk_hub)\n");
			else
				sprint(self, "Voting Hub \bOFF\b      --- (sv_pk_hub)\n");

			if (pk_flags & PK_TP_USERMAPON)
				sprint(self, "Server map loop \bON\b  --- (sv_pk_cmap)\n");
			else
				sprint(self, "Server map loop Off --- (sv_pk_cmap)\n");

			if (pk_flags & PK_TP_DUTYON)
				sprint(self, "Duty Checking On    --- (sv_pk_duty)\n");
			else
				sprint(self, "Duty Checking Off   --- (sv_pk_duty)\n");

			if (XENV)
				sprint(self, "SFX \bOFF\b             --- (sv_c_xenv)\n");
			else if (!(pk_flags & PK_TP_SPARKSFLASH))
				sprint(self, "SFX On              --- (sv_pk_sfx)\n");
			else
				sprint(self, "SFX \bOFF\b             --- (sv_pk_sfx)\n");

			if (pk_flags & PK_TP_STATUSON)
				sprint(self, "Status \bON\n");
			else
				sprint(self, "Status Off\n");	 

			if (!PK_100)
			{
				if (!(pk_flags & PK_SPIKER))
					sprint(self, "Spike traps enabled in PK mode\n");
				else
					sprint(self, "Spike traps DISABLED in PK mode\n");

				if (pk_flags & PK_DYNAMIC)
					sprint(self, "Dynamic Painkeep items \bON\b  - (pk_dyn_*)\n");
				else
					sprint(self, "Dynamic Painkeep items Off - (pk_dyn_*)\n");
			}
			else
			{
				sprint(self, "PK_100 set:\n");
				sprint(self, "Spkike traps DISABLED\n");
				sprint(self, "Dynamic Painkeep items Off\n");
			}
			sprint(self, "\b-----------------------\n\n");
		}
		else if (self.admin_input == 5 && !PK_100)
		{
			if (pk_flags & PK_DYNAMIC)
			{
				self.wad = "\nDynamic Painkeep items OFF";
				pk_bas_flags(PK_DYNAMIC, 0);
			}
			else
			{
				self.wad = "\nDynamic Painkeep items ON";
				pk_bas_flags(PK_DYNAMIC, 1);
				z = find(world,classname,"dyn_spawner");
				if (!z)
				{
					z = spawn();
					if (z)
					{
						z.think = dyn_item;
						z.nextthink = time + 1;
					}
				}
			}
		}
		else if (self.admin_input == 6 && !PK_100)
		{
			if (pk_flags & PK_SPIKER)
			{
				self.wad = "\nSpkike traps enabled in PK mode";
				pk_flags = pk_flags - PK_SPIKER;
			}
			else
			{
				self.wad = "\nSpkike traps disabled in PK mode";
				pk_flags = pk_flags | PK_SPIKER;
			}
		}
		else if (self.admin_input == 7)
		{
			if (pk_flags & PK_TP_USERMAPON)
			{
				self.wad = "\nServer map loop off";
				pk_flags = pk_flags - PK_TP_USERMAPON;
			}
			else
			{
				self.wad = "\nServer map loop ON";
				pk_flags = pk_flags | PK_TP_USERMAPON;
			}
		}
		else
			self.admin_input = 0;

		if (self.admin_input) admin_sv_cfg();
	}
	else if (self.admin == 25)														// item overrides
	{
		self.admin = 26;
		if (self.admin_input == 666)
			Admin_mainmenu();
		else if (self.admin_input == 29)
		{
			pk_itemovr = 0;
			admin_sv_cfg();
		}
		else if (self.admin_input == 30)
			Admin_itembits();
		else if (self.admin_input == 31)
		{
			z = spawn();
			if (z)
			{
				z.think = item_loop;
				z.nextthink = time + 0.1;
			}
		}
		else if (self.admin_input > 0 && self.admin_input < 23)
		{
			self.admin_input = self.admin_input - 1;
			f = AdminBitFlag(self.admin_input);
			if (Q_99  && self.admin_input == 6) f = 0;
			if (pk_itemovr & f)
				pk_itemovr = pk_itemovr - (pk_itemovr & f);
			else
				pk_itemovr = pk_itemovr | f;
			if (pk_itemovr != pk_itemovr_ck)
			{
				if (pk_itemovr & f)
					self.wad = "\nBit toggled on for selected item";
				else
					self.wad = "\nBit toggled off for selected item";
				admin_sv_cfg();
			}
		}
		self.admin_input = 0; //self.admin_input + 1;
	}
	else if (self.admin == 29)														// monster overrides
	{
		self.admin = 30; // one more than select val above - enter key reduces by 1, menu display sets this code & 3 must = 2
		if (self.admin_input == 666)
			Admin_mainmenu();
		else if (self.admin_input == 26)
		{
			if (self.cnt)
				cvar_set("sv_monster_map2", ftos(pk_monster_set & MONSTER_MASK_II));
			else
				cvar_set("sv_monster_map", ftos(pk_monster_set & MONSTER_MASK));
			self.wad = "\nBit set written to sv_monster_map";
			bprint("Map monsters bit set: ");
			bit_print(MONSTER_MASK, pk_monster_set);
			bprint("\n--- Please wait for the server to update monsters\n");
		}
		else if (self.admin_input == 27)
		{
			if (self.cnt)
				cvar_set("sv_monster_rnd2", ftos(pk_monster_set & MONSTER_MASK_II));				
			else
				cvar_set("sv_monster_rnd", ftos(pk_monster_set & MONSTER_MASK));
			self.wad = "\nBit set written to sv_monster_rnd";
			bprint("Random monsters bit set: ");
			bit_print(MONSTER_MASK, pk_monster_set);
			bprint("\n--- Please wait for the server to update monsters\n");
		}
		else if (self.admin_input == 28)
		{
			if (self.cnt)
				cvar_set("sv_monster_resp2", ftos(pk_monster_set & MONSTER_MASK_II));				
			else
				cvar_set("sv_monster_resp", ftos(pk_monster_set & MONSTER_MASK));
			self.wad = "\nBit set written to sv_monster_resp";
			bprint("Respawning map monsters bit set: ");
			bit_print(MONSTER_MASK, pk_monster_set);
			bprint("\n--- Please wait for the server to update monsters\n");
		}
		else if (self.admin_input == 29)
		{
			self.wad = "\nBit set cleared - 0";
			if (!pk_monster_set)
				pk_monster_set = MONSTER_MASK; // double action - if all off, turn all on
			else
				pk_monster_set = 0;
			if (pk_monster_set)
				self.wad = "\nBit set filled - 1s";
		}
		else if (self.admin_input == 30)
			Admin_monsterbits();
		else if (self.admin_input == 31)
			Admin_allmonsters();
		else if (self.admin_input == 32)
		{
			self.cnt = !self.cnt;
			Admin_monstermenu();
		}
		else if (self.admin_input > 0 && self.admin_input < 20) // < 25) NOTE: only 1 - 17 used
		{
			self.admin_input = self.admin_input - 1;
			f = AdminBitFlag(self.admin_input);
//			if (Q_99  && self.admin_input == 6) f = 0;
			if (pk_monster_set & f)
				pk_monster_set = pk_monster_set - (pk_monster_set & f);
			else
				pk_monster_set = pk_monster_set | f;

			if (pk_monster_set & f)
				self.wad = "\nBit toggled on for selected monster";
			else
				self.wad = "\nBit toggled off for selected monster";
		}
		self.admin_input = 0; //self.admin_input + 1;
	}

	if (self.admin == 15)
		centerprint3(self, self.message, self.enemy.netname, self.wad);
	else	if (self.admin == 19 || self.admin == 10)
	{
		str = ftos(self.admin_input);
		centerprint3(self, self.message, str, self.wad);
	}
	else
		centerprint3(self, self.message, "->", self.wad);
};

/*
============
Admin Impulse code
============

a series of ents to think data from alias assignments.

this allows for live (frequent) data change without recompiling!
*/

void() PK_SetAdmin =
{
	local entity e;

	e = spawn();
	e.nextthink = time + 0.2;
	e.think = PK_SetAdmin;

	if (self.classname == "admincode") 
	{
		pk_admincode = cvar("saved2");
		if ( ! pk_admincode) pk_admincode = -1;
		if (pk_admincode == -1) PK_ADMIN = 0;
		else
		{
			localcmd(ADMINIMPULSE);	// access impulse now
			e.classname = "adminimp";
		}
	}
	else if (self.classname == "adminimp") 
	{
		pk_adminimp = cvar("saved2");
		if ( ! pk_adminimp) pk_adminimp = 255;
		if (pk_adminimp == -1) PK_ADMIN = 0;
		else
		{
			localcmd(ADMINTIME);
			e.classname = "admintime";
		}
	}
	else if (self.classname == "admintime") 
	{
		pk_admintime = cvar("saved2");
		remove(e);
	}
/* more input
	else if (self.classname == "admin") 
	{
		pk_admin = cvar("saved2");
		localcmd("saved2 0\n");
		remove(e);
	}
*/
	else
		remove(e);

	if (!PK_ADMIN) remove(e);
	remove(self);
};

/*
============
User Menu
============
*/

// build menu for user

void() User_menu =
{
	string head, ln1, ln2, ln3, ln4, ln5, foot;

	ln1 = ln2 = ln3 = ln4 = ln5 = "";

	if (self.aflag == IMP_DROPI) // drop inv menu
	{
		drop_menu();
		return;
	}
	
	if (self.ammo_cells > 1 && self.pk_items & PK_IT_CLIGHT)
		head =
					 "\b   Painkeep User Menu:   \n"
					 "\b+------------------------+\n"
						"  1: Chain Thunderbolt    \n";
	else
		head =
					 "\b   Painkeep User Menu:   \n"
					 "\b+------------------------+\n";

	if (self.pk_gravitywellammo > 0)
		ln1 =
						"  2: Gravity Well         \n";
	if (self.pk_gravitywellammo == -1)
		ln1 =
						"  2: Super Gravity Well   \n";
	if (self.pk_turretammo > 0)
		ln2 =
						"  3: Auto Sentry          \n";
	if (self.pk_items & PK_IT_GRAPGUN)
	{
		ln3 =
						"  4: Harpoon              \n";
		foot = 
						"  5: release harpoon      \n\n"
				"\b*** following are impulse links ***\n\n"

						"  11: close combat wep    \n"
						"  12: prev pk weapon      \n"
						"  13: status display      \n"
						"    any impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}
	else
	{
	foot = 
				"\b*** following are impulse links ***\n\n"

						"  11: close combat wep    \n"
						"  12: prev pk weapon      \n"
						"  13: status display      \n"
						"    any impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}
	if (self.pk_items & PK_IT_AIRGUN)
	{
		if (self.pk_beartrapammo > 0)
			ln4 =
						"  6: Air fist             \n"
						"  7: Beartrap             \n";
		else
			ln4 =
						"  6: Air fist             \n";
	}
	else
	{
		if (self.pk_beartrapammo > 0)
			ln4 =
						"  7: Beartrap             \n";
	}
	if (self.pk_canpabammo > 0)
		ln5 =
						"  8: Can o' Pork n' Beans \n"
						"  9: Axe                  \n"
						"  0: Inventory list       \n"
						"  +--------------------+  \n";
	else
		ln5 =
						"  9: Axe                  \n"
						"  0: Inventory list       \n"
						"  +--------------------+  \n";

/*
	old menu - deprecated

	self.message =
					 "\b   Painkeep User Menu:   \n"
					 "\b+------------------------+\n"
						"  1: Chain Thunderbolt    \n"
						"  2: Gravity Well         \n"
						"  3: Auto Sentry          \n"
						"  4: Harpoon              \n"
						"  6: Air fist             \n"
						"  7: Beartrap             \n"
						"  8: Can o' Pork n' Beans \n"
						"  9: Axe                  \n"
						"  0: Inventory list       \n"
						"  +--------------------+  \n"
						"  5: release harpoon      \n\n"
				"\b*** following are impulse links ***\n\n"

						"  11: close combat wep    \n"
						"  12: prev pk weapon      \n"
						"  13: status display      \n"
						"    any impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
*/
	self.wad = "";
	centerprint7(self, head, ln1, ln2, ln3, ln4, ln5, foot);
};

// set painkeep item from user menu

void(float pki, float ci) user_menu_pkitem =
{
	if (ci) // ci - set current inventory too
		self.pk_currentInventory = self.pk_currentitem = pki;
	else
		self.pk_currentitem = pki;

	self.weapon = IT_AXE;
	self.forcewchange = TRUE;
	W_SetCurrentAmmo();
};

// fn(PK_AdminImpulse) - main admin input control routine

void() PK_AdminImpulse =
{
	local string as;
	local float f;

	self.attack_finished = time + 0.1; // debounce - dont want this every frame

	if (self.admin == USER_MENU) // process user menu (impulse 39) here + impulse 53, drop menu
	{
		if (Q_100 || Q_99) return; // Cataboligne - 8.16.9 - quake compatability mode

		if (cvar("chase_active") > 0) stuffcmd(self, "chase_active 0\n");

		crosshair_off(self);

		if (self.message == "")
		{
			if (cvar("r_ambient") > 0)
				self.light_lev = cvar("r_ambient");
			stuffcmd(self, "usergamma\n");
			stuffcmd(self, "admin_centertime\n");
			admin_timer(FALSE, USER_TIMEOUT);
			self.impulse = 0;
			self.message = "USER_MENU";
		}
		if (self.aflag == IMP_DROPI) // drop inv section
		{
			if (self.impulse > 0 && self.impulse < 8)
			{
				self.goalentity.nextthink = time + USER_TIMEOUT; // keep menu up while buttons are being pressed
				if (self.dropent)
				if (self.dropent.classname == "dropinv")
					self.dropent.weapon = self.impulse; // selected
				self.impulse = 0;
				self.dropent.grap_firetest = 0; // show it
			}
			if (self.dropent)
			if (self.dropent.classname == "dropinv")
			if (self.dropent.weapon)
			if (self.impulse == 11 || self.button0) //confirmed
			{
				self.goalentity.nextthink = time + USER_TIMEOUT;
				drop_inventory(self.dropent.weapon, self, anti_bounce);
				drop_setup(self, -1); // redo page
				self.impulse = 0;
				self.button0 = 0;
			}
			if (self.impulse == 8) // next page
			{
				self.goalentity.nextthink = time + USER_TIMEOUT;
				drop_setup(self, 1);
				if (self.dropent.noise == "")
				{
					drop_setup(self, 0);
				}
				self.impulse = 0;
			}
		}
		else
		if (self.impulse == 6)
		{
			if (self.pk_items & PK_IT_AIRGUN)
				user_menu_pkitem(PK_IT_AIRGUN, FALSE);
		}
		else if (self.impulse == 4)
		{
			if (self.pk_items & PK_IT_GRAPGUN)
				user_menu_pkitem(PK_IT_GRAPGUN, FALSE);
		}
		else if (self.impulse == 1)
		{
			if (self.ammo_cells > 1 && self.pk_items & PK_IT_CLIGHT)
				user_menu_pkitem(PK_IT_CLIGHT, FALSE);
		}
		else if (self.impulse == 2)
		{
			if (self.pk_gravitywellammo != 0)
				user_menu_pkitem(PK_IT_GRAVITYWELL, TRUE);
		}
		else if (self.impulse == 7)
		{
			if (self.pk_beartrapammo > 0)
				user_menu_pkitem(PK_IT_BEARTRAP, TRUE);
		}
		else if (self.impulse == 3)
		{
			if (self.pk_turretammo > 0)
				user_menu_pkitem(PK_IT_TURRET, TRUE);
		}
		else if (self.impulse == 8)
		{
			if (self.pk_canpabammo > 0)
				user_menu_pkitem(PK_IT_CANPAB, TRUE);
		}
		else if (self.impulse == 9)
		{
			user_menu_pkitem(PK_IT_AXE, TRUE);
		}
		else if (self.impulse == 5)
			grap_releaseHarpoon();
/*		else if (self.impulse == 11)
		{
			self.weapon = W_BestWeapon();
			self.pk_currentitem = W_BestPKWeapon();
			W_SetCurrentAmmo();
		}
		else if (self.impulse == 12)
			if (CanSelect(self.lastweapon, self.pklastweapon))
			{
				self.weapon = self.lastweapon;
				self.pk_currentitem = self.pklastweapon;
				W_SetCurrentAmmo();
			}
*/
		f = self.impulse;
		User_menu();
//		centerprint3(self, self.message, "", "");
		if (self.button0 || self.button1 || self.button2 || self.impulse)
		{
			admin_clear(self);
		}

		if (self.aflag == IMP_DROPI) // drop inv exit
			self.impulse = 0;
		else
// NOTE: if the impulses change - this code must change
		if (f == 11) // admin enter
			self.impulse = 46;
		else if (f == 12) // admin backspace
			self.impulse = 69;
		else if (f == 13)
			self.impulse = 201;
		else if (f == 10) // admin 0
			self.impulse = 38;
		else
			self.impulse = 0;
		return;
	}
	else if (self.impulse == pk_adminimp || self.classname == "admintimer") // toggle admin state on security impulse
	{
		if (self.classname == "admintimer") // entry from a timeout remote
		{
			if (!self.owner || !self.owner.admin) // hrm...
			{
				remove(self);
				return;
			}
			if (self.owner.goalentity != self)
			{
				self.think = SUB_Remove;
				self.nextthink = 0.1;
			}
			self = self.owner;
			self.admin = 7;
		}

		if (self.admin && self.admin < LIVE_ADMIN)
		{
			centerprint(self, "");
			if (self.admin < 0) // escaped login
			{
				self.attack_finished = time + A_TIME; // penalty - cant use this for invulnerable state
				self.admin = ADMIN_FAILED_LOGIN;
				centerprint3(self, "admin login escape, you must wait ",ftos(A_TIME)," secs!\n");
				return;
			}
			else
				self.admin = 0;
// IDEA: 5.19 exit - respawn here
			if (self.goalentity.classname == "admintimer")
			{
				remove(self.goalentity);
				self.goalentity = world;
			}
			admin_clear(self);
			self.attack_finished = time + 0.3; // clear keypress
			return;
		}
		else
		{
			if (self.admin == LIVE_ADMIN)
			{
				self.admin = 6;
				Admin_mainmenu();

// IDEA: 5.19 go observer here, escape or fail dont go observer
			}
			else // login
			{
				crosshair_off(self);
				self.admin = ADMIN_LOGIN; // enter access code
				admin_time = time + A_TIME; // 10 secs default - NOTE: this is 10 seconds of invulnerability
			}
			self.admin_input = 0;
			self.takedamage = DAMAGE_NO;
			if (cvar("r_ambient") > 0)
				self.light_lev = cvar("r_ambient");
			stuffcmd(self, "admingamma\n"); // set gamma level
			stuffcmd(self, "admin_centertime\n");
		}
	}
// code allows us to act like regular keypad entry, heh heh
	else if (self.impulse && (self.admin < -1 || (self.admin & 3) == 2)) // enter codes for menu or login
	{
		f = self.impulse; // cant change impulse to 0 - need to * password below
		if (f == 10) f = 0; // translate 0
		if (f < 10) self.admin_input = (self.admin_input * 10) + f; // build code
		else if (self.impulse == 12) self.admin_input = floor(self.admin_input / 10); // backspace
		if (self.impulse == 11 || self.button0) self.admin = fabs(self.admin) - 1; // enter (accept fire button here) - done
//		if (self.impulse == 11 && self.admin_input) self.admin = fabs(self.admin) - 1; // enter - done
		else if (self.admin > 0) // code for menu select go back now
		{
			as ="";
			if (self.admin_input) as = ftos(self.admin_input);
			else if (self.admin < 9) self.wad = "";
			if (self.admin < 9) centerprint3(self, self.message, as, "<");
			else centerprint3(self, self.message, as, self.wad);
			self.impulse = 0;
			return;
		}
	}

	if (self.admin > 0)
	{
		AdminCommands();
		self.impulse = 0;
	}
	else if (self.admin < -1) // processing login
	{
		if (admin_time < time) // timed out - force password check
		{
			self.admin = 1;
			AdminCommands();
		}
		else if (self.impulse)
		{
		as = "";
		if (pk_adminpwdmask) // cute password mask
		{
			if			(self.admin_input > 9999999999) as	= "***********" ; // alas, my compiler for additive strings, just stop echoing new chars here
			else if (self.admin_input > 999999999) as		= "**********" ;
			else if (self.admin_input > 99999999) as		= "*********" ;
			else if (self.admin_input > 9999999) as		= "********" ;
			else if (self.admin_input > 999999) as			= "*******" ;
			else if (self.admin_input > 99999) as			= "******" ;
			else if (self.admin_input > 9999) as			= "*****" ;
			else if (self.admin_input > 999) as				= "****" ;
			else if (self.admin_input > 99) as				= "***" ;
			else if (self.admin_input > 9) as				= "**" ;
			else if (self.admin_input > 0) as				= "*" ;
		}
		else
			if (self.admin_input) as = ftos(self.admin_input); // NOTE: this option leaves password in clear text
		centerprint3(self, "Enter admin password: ", as, "\n");
		self.impulse = 0;
		}
		else if (!self.admin_input)
		{
			as = ftos(floor(admin_time - time));
			centerprint3(self, "Enter admin password - seconds left: ", as, "\n");
		}
	}
};

// fn(admin_postthink) - called from post think, runs admin menus

float() admin_postthink =
{
	if (self.class_select == "class_bot") return(FALSE); // just incase a bot triggers user menu or admin entry...

	pk_adminframe = framecount;
//	if (deathmatch) // admin is debateable in SP, but...
	if (self.attack_finished < time)
	{
		if (self.admin != LIVE_ADMIN && (self.admin < 0 || (self.impulse && self.admin)))
		{
			if (self.admin == ADMIN_FAILED_LOGIN) admin_clear(self); // failed login - clear wait msg
			else PK_AdminImpulse();

			if (pk_admintime > 0)
			if (self.admin > 0)
			if (self.goalentity)
			if (self.goalentity.classname == "admintimer") // any input to admin menus resets timeout
				self.goalentity.nextthink = time + pk_admintime;
		}
		else if (self.impulse == pk_adminimp)
			PK_AdminImpulse();
	}
	if (self.admin)
	{
		if (pk_admintime > 0)
		if (self.goalentity)
		if (self.goalentity.classname == "admintimer")
		if (self.goalentity.model != "")
			setorigin(self.goalentity, self.origin + ' 0 0 60'); // track admin players

		if (self.admin != LIVE_ADMIN) return(TRUE);
	}
	return(FALSE);
};

// get admin away from a telefrag area - because admin cant cause or get hit by telefrag

void () tfragadmin_touch =
{
	if (other == self.owner)
		return ;

	if ((other.classname == "player") || (other.classname == "pk*bot"))
	{
		self.think = phone_teleport;
		self.nextthink = (time + 0.5);
		self.touch = SUB_Null;
	}

};
