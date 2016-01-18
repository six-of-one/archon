// **************************************
// server constants section

// **************************************

// base values
vector v0						= ' 0 0 0'; // zero vector | dimension
float MAXFL						= 16777215; // max (non mantissa) float - max bit mask

// **************************************
// code weaver section

// **************************************

// dont list unused vars warning when compiling
//#pragma warning disable Q302

// note - defines MUST be commented out - you cannot define null or 0 to clear them
// control whether warning code is compiled in

//#define warning

#ifdef warning
#endifdef

// control over test code

#define testset

#ifdef testset
#else
#endifdef


// **************************************
// engine section

// **************************************

float chaos;									// detect customized glquake engine - has cvars compiled
float CHAOS_ENG				= 10100010110111; // chaos engine id
float DARKPLACES;								// for detecting darkplaces
float XMOD;										// master exclude on extra elements
float ULOKW, ULOKD, ULOK2, ULOK3, ULOKHL;		// unlock codes
float PK_SEVEN, PK_EIGHT;
float LOK_STRICT				= 1; 			// lock deal
float XTR_SAVED1				= 1195724115; // saved1 test val

// scratch vars
//entity e0;

float z0 = 0;
float gsf;										// loop safety global - this MUST be watched CAREFULLY
//				usage list:			m-gremlin, m-chaos, morph, bot_way **, grap **
vector v1;
vector norm; 									// for trace_plane_normal manipulations

string sg;
string null_string = "";
string null_model = "progs/null.mdl";

// end engines

float() SUB_False				= { return 0; }; // Return a false value
float() SUB_True				= { return 1; }; // Return a true value
void() SUB_Void				= {  }; // just so fteqcc code can assign (void()) 0 to a fn call and detect it later

float() crandom;

// **************************************
// server strings section

// **************************************

// version info - at 1.0.5 - KEEP up to date! - note: files = admin.cfg, archon.txt, readme.txt, alias_codes.txt, cvar.txt
string vers						= "alias version \"echo quake-c: chaos archon (alpha) 1.0.5\"\n"; // these are displayed prior to the darkplaces internal cmd, which then runs - very cool
string stats					= "alias status \"echo code:     chaos archon (alpha) 1.0.5\"\n";
string vmotd					= "\\/ersion \b1\b.\b0\b.\b5a\b\n\n";
string motd2					= "\n\n[\\/\b1\b.\b0\b.\b5a\b] \b_-=\b* \bC\bataboligne\n\nhttp://www.moddb.com/mods/chaos-archon/\n\n";
string infobver				= "infobar 30 \"you are playing: Archon 1.0.5 alpha\"\n";

// web sites
string vweb						= "alias website \"echo http://www.moddb.com/mods/chaos-archon/\"\n";
string vdev						= "alias devsite \"echo http://www.moddb.com/members/invadercat/\"\n";
string vqcs						= "alias qcsite \"echo http://www.moddb.com/groups/qc/\"\n";
string sites					= "alias sites \"echo website  http://www.moddb.com/mods/chaos-archon/;echo devsite http://www.moddb.com/members/invadercat/;echo qcsite   http://www.moddb.com/groups/qc/\"\n";

// **************************************
// server console vars section

// **************************************

var float autocvar_no_auto = 0;	// allow everything to be turned off without re-launching defaults
var float autocvar_it_runemap = 0;  // if true print rune data to console

// **************************************
// Developer section

// **************************************

// global constant search

// ARCHON_
// WORLD_


/*
frame macro expansion

void() framename = [$framenum, nextthink] { ...code...};

void() framename =
{
	self.frame= $framenum;  // the model frame to displayed
	self.nextthink = time + 0.1;   // next frame happens in 1/10 of second
	self.think = nextthink; // the function to call at the next frame
	...code...
};

-- removes - 5 search replace sets
 =[ 
= \r{\r\tself.frame = 

, 
;\r\tself.nextthink = time + 0.1;\r\tself.think = 

 ] {
;\r\t

 ;
;

;};
;\r};

-- spaces
  
 

qr heximp_hover|cut -b 18-38|sed -e 's/$/;/

*/
// **************************************
// Archon section

// **************************************

var float autocvar_sv_nodule = 20;  // # of nodules on map
float ARCHON_NODULES;					// server count of nodules on map
// float NODULE_ENTRY_TIME;			// time when nodules start to appear
entity god_particle;						// one special nodule worth buku points

.float archon; // accumulates power

float ARCHON_FRAG;				 		// points per frag
float ARCHON_ITEM; 						// points per std item
float ARCHON_ART; 						// points per artifact
float ARCHON_AMMO; 						// points per std ammo
float ARCHON_AMMO_EXP; 					// points per explosive ammo
float ARCHON_WEP;							// points per gen weapon
float ARCHON_WEP_EXT;					// points per advanced weapon
float ARCHON_GEN;							// generic points
float ARCHON_MONSTER;					// points per monster = health / {}
float ARCHON_RUNE;						// points per rune per 3+ secs - run_runes timing
float ARCHON_POINT;						// points added per touch on power point if power_act does not spec it on map
float ARCHON_UNCOL = 0;					// if true allow uncollectable items (touching health box when you are at 100) to add archon pts
//												// value is factor 1 = full pts, 0.5 = 1/2 pts, etc.

float ARCHON_MORPH_MIN = 100;			// minimum archon points to morph

void() archon_altar;
void() archon_nodule_rnd;
void() archon_ppp;
void() archon_power;


// Archon spell casting
void() archon_target;
void(entity e) archon_target_clear;
void() clear_spell;
void() spell_target;

// spawn flag values
float NOITEM = 1;
float NOHEAL = 1;
float NOSPRAY = 2;
float P_RELOAD = 4;

// **************************************
// ADMIN section

// **************************************

#ifdef warning
float WARNING;								// display warnings - dev work mainly - now uses the following bit flags for specific warning sets
#endifdef
												// & 1 - server ops
												// & 2 - items
												// & 4 - monsters / morphs
												// & 8 - bot warnings
												// & 16 - hipnotic warnings
												// & 32 - weapons
												// & 64 - runes
												// & 128 - environment
												// & 256 - non bit mask elements
//
// dev - only enable this for painkeep maps or force pk mode (sv_ control) - any maps that loads a pk item / func
float PK;									// if set true painkeep code is enabled
float PK_MAP					= 6144;	// bit * = FALSE -- map sets painkeep mode  - PK = TRUE if: any pk*.bsp loaded, start.bsp loaded and message == "hub", a map loads any painkeep map item, PK = FALSE otherwise
float PK_ALWAYS				= 2048;	// bit *	= TRUE --- always in painkeep mode - PK = TRUE;
float PK_NEVER					= 4096;	// bit *	= TRUE --- never in painkeep mode  - PK = FALSE;
float PK_DYNAMIC				= 8192;	// bit *	= TRUE --- when always in painkeep mode & not on a PK map, dynamically load pk items if they are not present
//												// items include  - bear trap, can o' beans, gravity well, harpoon, turret, airfist, exploding shot, XXX - chain thunderbolt, pulse nailgun
float PK_SPIKER				= 16384;	// bit *	= FALSE -- allow spike traps, set to true for original pk treatment of spike shooters - they are removed
float PK_XSOUND				= 32768;	// bit * = TRUE --- use extra pk sound set
// compatability modes for the purists out there
float XENV;									// 99% compatability mode - if true (main mod) works but extra env & visual effects are disabled

float MAP_OBSTR;							// object errors -> warnings that remove map items should set this. so map repair (tbd) can init an emergency exit
float MAP_REPAIR;							// if true map repairs will execute
void() q_startmap;						// fix start map issue for q single player
.string class_select;					// allow selection by class
//float GMODE;								// genre mode - cfg for ambig map items

float SV_FALLEN;							// take action if player falls out of level 0 = none, 1 = return via phone type teleport, 2 = kill (no cide)
.float portal_busy;						// here for fallen test
float SV_HOLDING;							// 0 - no hold, 1 - allow players to pick up moveable stuff (items harp, aircannon or grav well can move, or temp decor)
float SV_TELEPORTALL;					// 0 - only telp player / bots / monsters, 1 = add missiles, 2 = teleport anything that hits a porter

// no exit was found (trigger_changelevel) - these set default limits for those levels
float NOEXIT_TIMEOUT;					// default time for levels without exits (trigger_changelevel)
float NOEXIT_FRAGLIMIT;					// default fraglimit for levels without exits (trigger_changelevel)
float NOEXIT_SAVETIME;					// save any timelimit if set
float NOEXIT_SAVEFRAG;					// save any fraglimit if set
float NOEXIT_CHECK;						// 1 if checked, -1 if timeout was set and needs cleared

float intermission_running;

float PK_HUB2					= 131072; // bit if TRUE, using custom hub - only used for level transtion from hub vote
float PK_ADHUB					= 1;		// set to 0 PK_mapmode and admin menu will ignore new maps - item load can still set PK mode for any pk map
float PK_ADMINMAP;						// if true this is an admin map command that overrides custom hub call from GotoNextMap

float pk_flags;							// replaces old usage of temp1, savedgamecfg stores this
float pk_xsound;							// set to state of PK_XSOUND bit for sound code toggle

float pk_itemovr;							// control items - admin override
float pk_map;								// true if a painkeep map is loaded
float pk_ditems;							// count painkeep items for dyn_items code
float PK_DYNTO;							// timeout in 120 secs
float PK_DYNRAD				= 8000;	// dynamic radius search 8000 units
void(entity e, float tm, void() rmv) dyn_remove;
void() dyn_rem;

float PK_ADMIN;							// allow admin - set this to 0 to completely disable all admin
float pk_adminimp;						// impulse set in admin.cfg to access admin commands, defaults to 255
float pk_admincode;						// code you must enter to access admin commands - set by admin.cfg, defaults to -1
float pk_adminpwdmask;					// if true password will be masked with *s
float pk_admintime;						// if > 0 - inactivity timer for admin mode
float pk_adminframe;						// only do once per frame
float LIVE_ADMIN				= 100;	// for being in game with admin privs - previous painkeep admin mode
float ADMIN_LOGIN				= -2;		// .admin value for login
float ADMINLOCK;							// polled from sv_c_adminlock
//float USER_MENU				= -1;		// .admin value that handles user menu - admin code set runs user menus
float USER_TIMEOUT			= 5;		// timeout user menu in 5 secs
float ADMIN_FAILED_LOGIN	= -777;	// login didnt succeed
string ADMINCODE				= "float1\n"; // local command that loads admin security password
//													  //- obscured to keep anyone with casual console access from divining its true meaning
string ADMINIMPULSE			= "float2\n"; // load the impulse
string ADMINTIME				= "float3\n"; // load the time out
float BOTFREEZE;							// if true stop bots cold
float BOTCAM;								// turning off frikbot botcam - 268226 in saved1 to turn on
float NODECOR;								// sv decor controls
void(float tm) th_bot_changeParms; // save bot parms to cvar or parm*

void(entity e) admin_clear;
string() build_itemmenu;
void() Admin_itembits;
float(float msk) rnd_bit_mask;
void(float msk, float bt) bit_print;

float pk_mapcfg;

// obliviously un-implemented for now
//string ADMINSRVCMD			= "_srvcmd\n"; // server vars alias cmd
//float pk_srvcmd				= 1; 		// ---: admin option later - allow these commands to be denied by admin

float pk_srvcfg;

void() pk_srvcmd_set;
void() mcode_load;
// end main admin

// stats pkg -meantime.qc

.float mean;
.float stdev;
float (float lMean, float lStDev) meantime;

float ply_count; // count 'em & weep
float high_score; // best of the best
float score_rel1				= 50;
float score_rel2				= 100;
float FL_SCORE1				= 4096;
float FL_SCORE2				= 65536;
float PLY_OBSERVER			= 1; // if true count observers in ply_count

float m_score_rel1;
float m_score_rel2;

// from light.qc

.entity next; // for the linked list of lightning - Cataboligne - 4.29,11 - moved to pk_defs 


// DARKPLACES specials
// wrap - fix fte broke ass shit

float surfnum;
string surface;

float(entity e, float s) getsurfacenumpoints_wrap = #434;
vector(entity e, float s, float n) getsurfacepoint_wrap = #435;
vector(entity e, float s) getsurfacenormal_wrap = #436;
string(entity e, float s) getsurfacetexture_wrap = #437;
float(entity e, vector p) getsurfacenearpoint_wrap = #438;
vector(entity e, float s, vector p) getsurfaceclippedpoint_wrap = #439;


float(entity e, float s) getsurfacenumpoints;
vector(entity e, float s, float n) getsurfacepoint;
vector(entity e, float s) getsurfacenormal;
string(entity e, float s) getsurfacetexture;
float(entity e, vector p) getsurfacenearpoint;
vector(entity e, float s, vector p) getsurfaceclippedpoint;
// end wrap specials


// **************************************
// runes

// **************************************


// for serverflags drop

float SVR1						= 131072;
float SVR2						= 262144;
float SVR4						= 524288;
float SVR8						= 1048576;
float SVRF;

float IMP_RUNEID				= 51;
float IMP_RUNEDROP			= 52;

float rune_new_map; // display rune message on new map

.float rune_flag;
float RUNE_3_ACM; // amount to accumulate under rule 3
.float rune_3_dmg; // rule 3 - these are cumulative effects
.float rune_3_resist;
.float rune_3_haste;
.float rune_3_rgn;
.float rune_3_vamp;
float rune_set;
void() run_runes;
void(entity e, entity p) rune_id;
void(entity e) rune_drop;
void() server_rune_follow;
void() fade_relocate;
void() rune_regen;
void() rune_vamp;
float(float atf) rune_haste;
void () rune_touch;
void(entity e) dead_runes;
void() rune_dmg_sound;

float RUNES;
float RUNE_CNT;
float RUNE_MASK;
float RUNE_RANDOM;
float RUNE_AR1M;
float RUNE_R1SFX;
float RUNE_MOVE; // move a rune after this many min regardless of other cnts

float rune_count; // total # on map
void() rune_maker;
void() rune_precache;

// runes can be forcefully removed in ENHANCED mode
float RUNE_PULL; // if true tells print code rune is being pulled and not to print drop messages
void(entity e, float pr) rune_pull;

float HARP_PULL				= 0.33;	// % chance harpoon poink gets a rune from a player - IDEA: seperate chance to drop a rune whilst being pulled ?
float HORN_PULL				= 0.25;	// % chance air horn will blow a rune off a player
float FALL_PULL				= 0.2;	// % chance a damaging fall will pull a rune loose
float DBL_PULL					= 1;		// set to 2 or more to increase chances of above pulls

float GRAV_PULL				= 0.5;	// % chance a gravity well will pull a rune loose - mostly depends on player being caught on something and in range of pull
float SGRAV_PULL				= 0.8;	// % chance a super gravity well / reality bomb will pull a rune loose


string rune_resist_sound;
string rune_strength_sound;
string rune_haste_sound;
string rune_regen_sound;
string rune_vampire_sound;

string tech_adoc_sound;
string tech_amp_sound;
string tech_dsh_sound;
string tech_tiem_sound;

float R_EARTH; // allow power mix
float R_HELL;
float R_BLACK;
float R_ELDER;
float R_VAMPIRE;
float R_AMMO;
float R_FLY;

float T_DSH;
float T_AMP;
float T_TEIM;
float T_ADOC;
float NO_TECH; // no techs allowed in rune mask

float RUNE_FLG_RS				= 1;
float RUNE_FLG_DM				= 2;
float RUNE_FLG_HS				= 4;
float RUNE_FLG_RG				= 8;
float RUNE_MASK_ALL; //		= 15; // because manual config must have mask off for bad bits

float RUNE_AMMO				= 16; // no rune code yet - for packs
float RUNE_FLG_FLY			= 32; // no rune code yet - for q3

float RUNE_VAMPIRE			= 64; // lithium rune
//float RUNE_PP					= 128; // power point rune

float RUNE_FULL				= 79; // for multi rule test

float TECH_DSH					= 131072; // techs from lith - leaves 10 bits for new runes above
float TECH_AMP					= 262144;
float TECH_TEIM				= 524288;
float TECH_ADOC				= 1048576;
float TECH_MASK_ALL			= 1966080;


float RULE1_MASK				= 15;
float RULE2_MASK				= 1966159; // original 4 + vampire + techs
float RALL_MASK				= 1966207; // everything

float RULOK2;		// unlock code - lith vector

float RUNE_VAMPIRE_PER; // percent of damage added to suck heads health - rule 2

float DEF_DOC_ARMORTYPE		= 0.6;

// if both are true the damage mult for quad + rune + tech = 16 !!!
float RUNE_QUAD_COMB			= 1; // allow damage runes to combind with quad
float RUNE_TECH_DMG_COMB	= 1; // allow damage runes to combind with each other
float RUNE_TECH_RS_COMB		= 1; // allow resist runes to combind with each other
float RUNE_NOWAY				= 1; // if true relocate runes past noway bounds for waypoints (quicker than normal relo
//										  // note: this also enables relocation repair (e.g. nextthink fail fix)
float RUNE_SHOW				= 0; // if true, rune console info print obeys DYN_SHOW rules
string RUNE_MSG_ISO			= ""; // set to "\n" to put blank lines around relocating msg

void() flyer_move; // fly rune for now

.vector movement; // for haste - this is dp engine supported

// end runes

// **************************************
// advanced item controls

// **************************************

// archon items

float MC_SUPER_SHOTGUN; // - 101 to get item override menu #
float MC_PULSE_NAILGUN; // for HUD

float MC_ASHELLS_LG;
float MC_ANAILS_LG;
float MC_AROCKETS_LG;
float MC_ACELLS_LG;
float MC_AEXPLSH;


void() func_make;

// item override admin
float DYN_SHOW;
float DYN_OVR;
float DYN_ART;
float DYN_FORCE;
float DYN_ARTFR;
float DYN_ARTFR_ONLY; // if set true dynamic only adds artifacts to map
float DYN_FORCE_CNT; // max forced items to load
float DYN_START_TIME			= 5;	// seconds till dynamic spawner starts its thing - precache must cutoff before this, leave a couple secs for map load
string (float mc) item_by_mcode;
void(string cls) item_call;
void(entity e, string cl) item_call_save;
string(entity e) item_ident;
void() dtf_handle;
entity() dyn_rndloc;
vector(vector pv1, float d1, float r1) stdv_rndloc
void() start_loopcyc;
void(float mc, vector vo, string wd) fn_make;
float(string sc, entity e) pk_mcode;
void() place_item_control;
void() pic_test;
float(float mcv, entity e) bit_mcode;

.float mcode;								// map item code - handle sub lists
.float scode;								// save item code - for restore
.string sscode;							// map item code string - for find

///float item_op;								// item operation currently in progress
///float IT_CALL					= 16;		// op is item call
///float IT_MAP					= 8;		// op is map call

// respawn times
//float RSP_AMMO; // these are dm 3 rules
//float RSP_ARMOR;
//float RSP_ITEM;
//float RSP_WEP;
//float RSP_ART;

float TE_EXPLOSION2			= 12;

float EXPLBOX_RESP;			// explode box respawn if true
void() d_barrel;

float RE_LOC					= -666; // relocate restore point if .delay = this - pk_item_position_init
float RSP_TIME; // respawn time
float POW_TIME; // power time
float CFM_TIME					= 60; // check for move time out
float PIC_TO					= 5; // place_item_control time out

float NO_REMOVE_NORET		= -665; // when set as aflag - dont remove, leave untouchable
float NO_REMOVE_TCH			= -664; // when set as aflag - dont remove, touchable again on respawn

float pic_tsk;
void() place_item_control_loop;

float WEP_SSHOT				= 1; 	 // admin of super shotgun
float WEP_NAILGUN				= 2; 	 // admin of nailgun
float WEP_PERF					= 4; 	 // admin of super nailgun
float WEP_GREN					= 8; 	 // admin of grenade
float WEP_ROCKET				= 16;  // admin of rocket
float WEP_THUNDER				= 32;  // admin of thunderbolt
float WEP_PKI					= 64;  // admin of pain keep items
float WEP_WEPSQ				= 63;  // all q weps									= 111111000000
float WEP_WEPSA				= 127; // incl pk items?							= 111111100000
float WEP_STOP					= 128;

// pk items special - not in override var
float WEP_GWELL				= 128;
float WEP_TURRET				= 256;
float WEP_BTRAP				= 512;
float WEP_EXPSH				= 1024;
float WEP_GRAP					= 2048;
float WEP_AIRG					= 4096;
float WEP_CPNB					= 8192;

float ART_QUAD					= 128;  // admin of quad
float ART_INV					= 256;  // admin of invulnerable
float ART_RAD					= 512;  // admin of rad suit
float ART_RING					= 1024; // admin of ring
float ART_ARTS					= 1920; // all art bits								= 000000011110
float ART_STOP					= 2048;

float ARM_GRN					= 2048;  // admin of green armor
float ARM_YEL					= 4096;  // admin of yellow armor
float ARM_RED					= 8192;  // admin of red armor
float ARM_ARMS					= 14336; // all armor bits							= 000000000000111
float ARM_STOP					= 16384;

float HEAL_15					= 16384;  // admin of heal 15
float HEAL_25					= 32768;  // admin of heal 25
float HEAL_100					= 65536;  // admin of heal 100
float HEAL_HEALS				= 114688; // all health bits						= 000000000000000111
float HEAL_STOP				= 131072;

float ITEM_ANY					= 131071; // any item bits set

float CON_ANY					= 8388607; // any bit set in this mask	- any above + controls (all bits - 64)
float CON_STOP					= 131072;  // stop replace / remove cycle here
// CON_* entries
float CON_ONLY					= 131072;  // only the selected items will be loaded
float CON_NONE					= 262144;  // none of the selected items will be loaded
float CON_SUBS					= 524288;  // substitute something for removed items
float CON_INF					= 1048576; // infinite ammo to all weps with bit set above - except carryables
float CON_CYC					= 2097152; // cycle selected bits in thier group

float CON_CHAOS				= 2490368; // item chaos it all 3 control bits set
// excluding inf_ammo from run bits
float CON_RUN					= 3014656; //4063232; // any control bit CON_* entries above - used by autorun
float CYC_TIME					= 80; // test: - 240; // seconds for cycle base - 4 mins +|- 2 mins

float IT_ARMOR_BITS;

void() item_loop;
void() item_control_menu;
float ammo_frame;
float(float cn, entity e, string op) ammo_con;
void () PlaceItem;

// end item overrides


// map translations

void() check_translate;

float TR_Q1DEF;					// default non q1 stuff to q1 in some sits
float TR_Q1QRY;					// query status - only need to do this once
float TR_WOLF;
float TR_DOOM;
float TR_QUAKE;
float TR_Q2;
float TR_Q3;
float TR_ALL;
float TR_NOT;						// 0 = no change, 1 = remove, 2 = best guess, 3 = randomize in genre, 4 = randomize to any

float FL_NOTRN_LEAVE			= 0;
float FL_NOTRN_RMV			= 1;
float FL_NOTRN_BG				= 2;
float FL_NOTRN_RNDIN			= 3;
float FL_NOTRN_RNDANY		= 4;

float FL_TR_RESTORE			= -1; //	restore to original - should only be set by code
float FL_TR_WOLF				= 1; //	tranlate these items to wolf items
float FL_TR_DOOM				= 2; // 	"			"		"		doom	"
float FL_TR_QUAKE				= 4; //		"			"		"		quake	"
float FL_TR_Q2					= 8; //		"			"		"		q2		"
float FL_TR_Q3					= 16; //	"			"		"		q3		"
float FL_TR_MELEE				= 32; // "			"		"		melee items
float FL_TR_RANDIN			= 64; // randomize in gen
float FL_TR_RANDOM			= 128; // total random
float FL_TR_REMOVE			= 256; // remove these items

float NO_PI;					// dont let item_call call place_item

// end translations



// missile code flags
float FL_PUNCH					= 2;				// use punchangle for weapon fire
float FL_2PUNCH				= 4;				// double punch
float FL_MPUNCH				= 6;				// mega punch?
float FL_MSL					= 8;				// set missile velocity
float FL_GRN					= 16;				// set grenade type velocitys
float FL_USEAMMO				= 32;				// for generic fire fns
float FL_CTHONF				= 64;				// cthon fire balls
float FL_SNDMIS				= 128;			// sound on missile wep channel
float FL_RUNEHST				= 256;			// missile gets runehaste check
float FL_AIM1K					= 131072;		// aim fn, val 1000
float FL_AIM10K				= 262144;		// aim fn, val 10000
float FL_AIM100K				= 524288;		// aim fn, val 100000
float FL_MORPHSHOT			= 2097152;		// builtin weapon damage
/*
be aware...also used as missile code flags

float RM_SKY					= 1;		// remove imm. if CONTENT_SKY
float FLT_LAVA					= 128;	// float in lava
float FLT_IMM					= 512;	// no lift, just blink it there
float MLT_LAVA					= 2048;	// melt in lava
float PF_LAVA					= 1048576;
*/


// pack - goes with dead

float BACKPACK_TIME			= 120; // time for thrown packs to live
float BACKPACK_TIME_DV		= 30; // deviation on time (+/-)

// dead rules

float corpse_solid;
float SOLID_CORPSE			= 5;

float DEAD_THROW;
float DEAD_THROW_NOWAY		= 1; // if true dont dead throw beyond noway, applies to packs - note thrown stuff in bounds could still get there
float DEAD_THROW_ARMOR;
float DEAD_THROW_PKI;
float DEAD_THROW_LIVERND	= 0.5; // chance a dead threw wep is touchable under rule 2
float DEAD_THROW_CNTRND		= 0.5; // chance a dead threw wep is NOT under rule 8
float DEAD_THROW_TIME		= 110;// test: 66; // time (in secs) a deadthrew wep hangs around
float DEAD_THROW_ARTIFACT	= 1; // if true when dead, any artifacts will be tossed out as inventory dropped

float IT_ARTIFACT = 7929856; // for detecting arts in items - used by rune id & dead drop

float DEAD_XPACK;
float DEAD_GIBPACK;

float DEAD_BODYCOUNT			= 28; // test: 48; // number of bodies (+1) in bodyque loop, if 0 bodies spawn (no que) and use timeout below
float DEAD_BODYTIME			= 120; // how long non que corpse hang around

vector MED_BOUNCE				= ' 210 210 320'; // medium bounce for dead thrown stuff - idea: factor in dead body velo
vector MED_BOUNCE_NOW		= '-210 -210 -320'; // medium bounce for dead thrown stuff - idea: factor in dead body velo

// here because deathrew needs to detect them before mcode
float MC_HOOK; // CTF hook map item
float MC_Q2_GRAPPLE;
float MC_Q3_GRAPPLE;
float MC_Q3_HOLDMEDKIT;
float MC_Q3_HOLDTELE;

// end dead rules



// **************************************
// chaos section

// **************************************

float ENHANCED					= 1; // adds features that werent originally there in the sub mods (like runes)

//float WORLD_NOWAY				= 1; // use world min & max for noway bounds if sv_ bounds not set

.float xp; // experience points

void() remove_fade;

// goes elsewhere section
float NO_FLOAT					= -671234; // dont float anything with this offset, or?

float MONSTER_DROWN			= FALSE; // if true monsters will take drown damage - NOTE: they dont know how to swim or get out of water yet
float MONSTER_ZOMBIE_DROWN = FALSE; // even if monsters can drown, zombie never will, and they make mucho noise while taking the damage - ruins SP ambience
//float MONSTER_TRANSPARENT	= TRUE; // take off from dyn_rem bug where some cube monsters ended up transparent

.float dmgtime;


float CBOMB_DEF_DMG			= 10; // base rnd damage when a chaos bomb makes explosives
float CBOMB_DEF_MAX			= 160; // if not negative, chaos bomb blast potential will not exceed this for all explosives
float RND_maxdmg; // set to CBOMB_DEF_MAX if > 0 this is the max damage all explosives from bomb can cause
float DUD_DEF_DMG				= 20; // defualt base damage for a dud explosive that blow

// inventory flags

.string stack1, stack2, stack6; // here for specials

float WEP_ITEM_MASK			= 255; // mask of range weapon bits in .items
float PK_ITEM_MASK			= 4094; // mask off non items bits
float WEP_MASK					= 4351; // mask off other items bits for def weap bits 1 + ... + 128 + 4096

float DROP_ALLOW; // inv bits player is allowed to drop

vector anti_bounce			= '-1 -1 -1'; // no bounce for items placed in the wild
vector GEN_BOUNCE				= ' 340 340 300'; // generic bounce for items tossed in the wild

// inventory code

void(entity de, entity ve, vector vb) dropinview;
void(entity p, float pg) drop_setup;
void(float im, entity p, vector vb) drop_inventory;
void() inventory;
void(entity p, string sl, float b, entity e) drop_string;
float(entity e, string ms) force_drop_set;
float(entity p, string ds, float bv, entity ew, string fm, vector vb, float ke) drop_one;
void(entity e) dead_artifact;
void(entity e) dead_drop;
void (entity e, entity p) stack_touch;
float(entity e, string ss) stack_search;
void(entity e, string ss) stack_delete;
float(entity e) stack_compress;

void() chaos_precache;

float FL_REMOVE				= 64;
float FL_HELD					= 128;
float NO_BUBBLES				= -1; // this ent wont make bubbles
float FL_VANM					= 131072; // vmodel animation in progress
//float FL_SLOW					= 262144; // something is slowing player - velocity percentage in .distance -- was for zomby gas cloud slowdown

float EF_FULLBRIGHT			= 512;
// end inventorys


// env stuff - part of chaos engine env effects - mostly unused

float CHAOS_TELE_LIMIT		= 6; // max number of cube spawned spheres per map instance

void(vector pv1, vector pv2, float typ, string snd) lightning_bolt;

void(vector org, float ofs, vector vp, vector vr, float dur, float amt, float rmt, float flg, vector clm, vector crm, vector per) particle_burst;
float FL_RND					= 1; // pick a random color
float FL_COL1					= 2; // this color active
float FL_COL2					= 4;
float FL_COL3					= 8;
float FL_ALLCL					= 16; // fire particles of all 3 colors
float FL_PERC					= 32; // percentage determins how much of each to throw if more than 1 used, usage always rand() < per_x < _y < _z
float FL_RNDUR					= 64; // randomize duration


void(void() fr, vector org, float mvt, float vel, string cln, string md, float ct, float amt, float rmt, vector vp, vector vr, void() cb, float flg, entity s) fire_burst;
float FL_FRCORG				= 1; // force load origin
float FL_VELRND				= 2; // randomize velocity * random()
float FL_VELRND2				= 4; // randomize 1/2 velocity + * random()
float FL_NEWSELF				= 8; // use a new self ent every iteration - lightning req.
float FL_ANGADD				= 16; // angle progression
float FL_ANGADR				= 32; // random addition
float FL_ANGADS				= 48; // any angle add flag
float FL_OWNOWN				= 64; // selfs owner (instead of just self)
//float FL_MSTOWN				= 128; // if master_owner is set use that otherwise fall back to other flags

// fireball & fire fly stuff
float NOFLY						= 88800; // dont make a launcher
float NOFLYMIRV				= 88400; // no launcher, no mirv
float NOMIRV					= 88200; // dont mirv
float MIRV_RESIZE				= TRUE; // when a mirv happens, make smaller balls
float MIRV_MIN					= 0; // minimum number of balls to mirv
float MIRV_RND					= 4; // additional random balls to mirv
float FIRE_FLY_TM				= 5; // time for fly to live
float FIRE_FLY_TDEV			= 4; // std dev fly life
// fire fly velocity controls
float FIRE_FLY_VELBASE		= 600; // fire fly base velocity - not the Q1 launcher default!
float FIRE_FLY_VELLARGE		= 600; // larger fire fly base velocity
float FIRE_FLY_VELDEV		= 200; // fire fly velocity deviation
float FIRE_FLY_VELXY			= 50; // fire fly x & y velocity
float FIRE_FLY_VELBW			= 400; // fire fly velocity when fireball wep hits world
float FIRE_FLY_VELMIRV		= 100; // fire fly velocity when a mirv occurs
float FIRE_FLY_DMG			= 20; // base dmg - Q1 default
vector FIREB_MSL_AVEL		= ' 200 100 300'; // default fireball missile avelocity


// skin sequence in volcano.mdl
float LAVA_START				= 0; // lava puddle / volcano start skin
float LAVA_FLOWEND			= 9; // lava volcano end skin
float LAVA_DARKCOOL			= 10; // hot lava cooling - volcano
float LAVA_DEADSKIN			= 11; // dead skin - volcano / puddle

float VOLCANO_LOC				= 3000; // quake units to settle volcano
float VOLCANO_ERUPT			= 180;//600; // secs for volcano to erupt before it can change state again
float MAX_ASH_CYC				= 128; // max cycles ash will burn
float LAVA_BLAST				= 0.6; // < % chance of one flare if explosion in lava
float LAVA_SHOT				= 0.17; // % chance a bullet hitting lava will release a mini lavaball
float LAVA_PLASMA_MLT		= 0.5; // % chance of melting a plasma bomb in lava
// lava puddle stuff
float LAVA_PUDEND				= 6; // lava puddle end skin

// super lavaball
float LAVA_LGSKIN				= 2; // skin for large lavaball
// lavaballs
// lavaball.mdl :== 0 - 4 irregular lavaball, 5 - 9 spherical, 10 - large irregular, 11 - large sphere
float LAVA_LGFRAME			= 10; // frame for large lavaball, 11 = large sphere
float LAVA_MINFRAME			= 3; // frame for mini lavaball
float LAVA_MCRFRAME			= 4; // frame for micro lavaball
float HTLAVA					= 0; // hot lava skin in lavaball / snowball
float DKLAVA					= 1; // dark lava skin in lavaball / snowball
float SKSNOW					= 3; // snow skin in lavaball / snowball
float SKTELE					= 4; // teleport skin in lavaball / snowball
float SKGTELE					= 4; // teleport skin in grenade


/// *** DUMMY SECTION - IDEA: move to better location later on

// 8192 section

float FL_NOPART				= 8192; //no particles when melting
float FL_FROZEN				= 8192; // ball lightning freezes monsters
			 
float RMIN_SKY					= -60;	// removed from values returned
float RMIN_LAVA				= -50;
float RMIN_SLIME				= -40;
float RMIN_WATER				= -30;

float RM_SKY					= 1; // dummy(s) - just so we dont have to recode later
//float RM_SKY					= 1;		// remove imm. if CONTENT_SKY
float RM_WATER 				= 2;		// remove imm. if CONTENT_WATER
float RM_SLIME 				= 4;		// remove imm. if CONTENT_SLIME
float RM_LAVA					= 8;		// remove imm. if CONTENT_LAVA
float CKO						= 16; 	// only check content, take no action - should not be used in cycle - negates timer
float FLT_WATER				= 32; 	// float when in water
float FLT_SLIME				= 64; 	// float in slime
float FLT_LAVA					= 128;	// float in lava
//float FLT_BOB					= 256;	// bob cycle while floating
float FLT_IMM					= 512;	// no lift, just blink it there
float MLT_SLIME				= 1024;	// melt in slime, ** time prior to melt in .wait
float MLT_LAVA					= 2048;	// melt in lava
//float MLT_WATER				= 4096;	// melt in water (what the hey, made of sugar?)
//float MLT_IMM				= 8192;	// melt with no wait time - *** ISSUE: FL_NOPART code borks this, but its not implemented yet
//float MLT_BLOW				= 16384;	// try to blow up explosives, dmg based on currentammo and mode_x - subflare spot
//float FLT_SINK				= 32768;	// eventually sink the floaty, ** time in .delay

/* deprecated - not used, ever
float FRC_RESP					= 65536;	// force a respawn after .pausetime, if MLT_IMM, this will be instant
float CLR_TOUCH				= 131072;// clear touch fn when first event occurs
*/

float CK_EARTHQUAKE			= 131072;// check if ent in earthquake range

float PF_WATER					= 262144;// call .th_stand() every time in content
float PF_SLIME					= 524288;
float PF_LAVA					= 1048576;
float PF_EMPTY					= 2097152;
float SF_CHK					= 4194304;// call .th_walk() on sched above also
float PF_SOLID		 			= 8388608;// solid check, for stopping things?

float CTI_LAVA					= 1050776;// Lava flag indicated - RM_LAVA | CKO | FLT_LAVA | MLT_LAVA | PF_LAVA
float CTI_WATER				= 262194;// Water flag indicated
float CTI_SLIME				= 525396;// Slime flag indicated

.float content_flag;

.string quakeset; // string search link all quakeable ents
string EARTHQUAKE				= "earthquake"; // select things we want to shake up

float QUAKE_RUBBLE			= 0.17; // chance of rubble when skaking loose debris
float QUAKE_RUBBLE_PER		= 0.04; // chance of rubble percent per richter
float RUBBLE_DMGDEF			= 10; // default damage from hot rubble
float RUBBLE_TIME				= 15; // test: 45; // time for rubble to hang around
float RUBBLE_TDEV				= 15; // dev time on rubble
float RUBBLE_BLASTRAD		= 48; // distance from explosion to look for rubble to blast
float EXPLODE_RUBBLE			= 0.6; // chance of rubble from explosion
float RUBBLE_SHOT				= 0.07; // % chance a bullet hitting solid will release a mini rubble

void(vector rorg, vector vel, float vibe, float rskn) rubble_debris;

// end env section


// flags for find_tdest making random selections
//float FL_ITEM = 256; 					// include items - if FL_RSEVEN is not set, code will favor item dests 10 %
float FL_RSTELE				= 512;	// include teleports - if FL_RSEVEN is not set, code will favor teleport destinations 60%
float FL_RSSTART				= 1024;	// include all player starts - if FL_RSEVEN is not set code will favor these only 30%
float FL_RSRNG					= 2048;	// find closest range among selections - IDEA - FL_ZPREF - prefer near z level to closer up / down
float FL_RSEVEN				= 4096;	// chances are equal for any destination
float FL_RSALL					= 5888; // select it all, chances even

// telesphere stuff

entity(float fl, string clsn) find_tdest;
void() sphere_annihilation_move;
void() trigger_teleport;

float CHAOS_UNSTABLE_TELE; // base percent chance for unstable teleport to change targets


//DP_SV_MODELFLAGS_AS_EFFECTS
//this extension allows model flags to be specified on entities so you can add a rocket trail and glow to any entity, etc.
//setting any of these will override the flags the model already has, to disable the model's flags without supplying any of your own you must use EF_NOMODELFLAGS.
//idea: LordHavoc, Dresk - darkplaces implementation: LordHavoc

.float modelflags;
.float clientcolors; //controls coloring on scoreboard (using a single number that contains pants and shirt colors (pants + shirt * 16, 0-255 potentially), so be sure to set it for a bot)
.float scale; // make models diff size

// entity color - access 0 - 255 (prob from palette)
.float glow_color;
.float glow_size;
.float glow_trail;

float EF_NOMODELFLAGS		= 8388608; // ignore any effects in a model file and substitute your own
float MF_ROCKET  				= 1; // leave a trail
float MF_GRENADE 				= 2; // leave a trail
float MF_GIB     				= 4; // leave a trail
float MF_ROTATE  				= 8; // rotate (bonus items)
float MF_TRACER  				= 16; // green split trail
float MF_ZOMGIB  				= 32; // small blood trail
float MF_TRACER2 				= 64; // orange split trail
float MF_TRACER3 				= 128; // purple trail

float MF_HAPPYTRAIL			= 1011; // bits to select random trail, > 255 means no trail

// end chaos


// heal codes

float HEAL_ROT					= 1;
float HEAL_NORM				= 2;
float HEAL_MEGA				= 3;
float HEAL_BOT					= 4; // doom health bottle - ignore normal max, no rot
float HEAL_SOUL				= 5; // doom health: soul, mega spheres - 200 max, no rot
float HEALT_CURE				= 3; // healtype needed set to cure plague, etc

float Q_MEGA_MAX				= 250; // max from q1
float Q_NORM_MAX				= 100; // standard max health
float Q_ARMOR_MAX				= 200; // standard max armor
float D_ARMOR_MAX;
float Q2_ARMOR_MAX;
float(float ehm, float hv) morph_healmax;

float SPC_HEAL_MOD			= 0.25; // how much a special heal (mega, etc) lets its max expand for morphs with heal mod > 1
//											  // so if max heal is 200, and the mod is 3.0, the max is 1.75 * 200 = 350
// defaults

void(entity e) set_defaults;

float DEF_HEALTH;
float DEF_ARMOR;
float DEF_ATYPE				= 0.3; // default armor is always lowest protection ?
float DEF_ITEMS; // q1 standard bit flags
float DEF_PK_ITEMS; // pk bit flags
float DEF_WEAPON; // bit for wep slot - per genre char default action
float DEF_REMWEP				= 256; // bit set in def_weap - if normal defaults are set - remove them NOTE: axe doesnt remove because of pk item code, but it can be replaced!
float DEF_REMAMMO				= 512; // bit set in def_weap - if normal ammo set - remove it


float DEF_AMMO_BULLETS; // initial ammo defaults if set
float DEF_AMMO_SHELLS;
float DEF_AMMO_CELLS;
float DEF_AMMO_ROCKETS;
float DEF_AMMO_NAILS;
float DEF_AMMO_SLUGS;
float DEF_AMMO_GAS;

float DEF_AMMO_BASE			= 25; // if no ammo given for a default wep, this is it

// **************************************
// X (extra) weapon stuff

// **************************************

string DEF_WEP_DEATH1		= " was just plain killed with ";
string DEF_WEP_DEATH2		= "'s random weapon of choice\n";

.vector bulletspread; // weapon fire spread - used to be punchangle

float ALT_FIRE_IMP			= 13; // impulse for alt fire
.void(entity ew) _alt_fire;

float DEF_X_ITEMS; // x bit flags

// end defaults

entity sphere_a; // only one of these ever
void() sphere_annihilation_phys_move;

// for q3 lg udern water
float MC_Q3_LIGHTNING;

.float crosshair_sv; // save crosshair so it can be turned off during menus & such
float IMP_CROSSHAIR			= 49; // impulse controls crosshair
void(entity e, float i) crosshair_con;
void(entity e) crosshair_off;

// inits - by genre and map

// char data moved to morph.defs

string MAP_MODE; // genre of loaded map (if detected) Q quake (default), Q2 quake 2, Q3 quake 3, D doom, W wolf, PK painkeep

float INIT_CON; // control flag
float CHAR_CON; // control flag - character mode

float INIT_0_W;
float INIT_1_D;
float INIT_2_Q;
float INIT_3_PK;
float INIT_4_Q2;
float INIT_5_Q3;
float INIT_6_HP;
float INIT_7;

float FL_INIT_CGEN_BIT		= 1; // genre by char - bits per genre
float FL_INIT_CGEN_MC		= 2; // genre by char - 1 map code per genre
float FL_INIT_MGEN_BIT		= 4; // genre by map - bits per genre
float FL_INIT_MGEN_MC		= 8; // genre by map - 1 map code per genre
float FL_INIT_ARB_MC			= 16; // arbitrary map codes - 8 total, everyone gets this set
float FL_INIT_PKO				= 32; // pk items added only when genre is pk
//float FL_INIT_ADD				= 32; // add to initial weaps -- deprecated, happens when DEF_REMWEP is false
//float FL_INIT_REP				= 64; // replaces initial weaps -- handled by DEF_REMWEP now

// end inits


.float ammo_bullet;
.float ammo_slug;
.float ammo_gaspr;
.float ammo_hgrenade;

float PK_BULLETAMMO_MAX;
float PK_SLUGAMMO_MAX;
float PK_GASAMMO_MAX;


// extra item flags & code

float x_item_dm_giveaway; // need to give everyone keys to doors in dm for x_item doors

.float x_items; // extra weapon item control - pwr armors / extended keys / etc
void() x_item_touch;
void(entity e, float camct, float mcd, string spf, float islot) xwep_fakeload;
void(entity e, float smc) set_xweap;
void(entity e) xw_parm;
float X_CHGLVL;

// special codes for x weps - usually found in .lefty
float IGN_INV 					= 66600;
float FL_MELEE_WEP			= 66601;
float SND_OVER					= 66602; // play eweapon sound over after fire call

entity telesnd; // teleport sound effect (dest) global - so holdable can change sound played (hackish way to do things)

float IMP_PARM					= 55;
float(entity e, entity f, float dm) power_armor;
void() power_armor_impulse;
.float armorsave; // save armor value for power armor flipping value
void(entity e) armorsave_rev;

float X_PWR_ARMOR				= 1;
float X_PWR_SCREEN			= 2;
float X_PWR_ARMOR_ON			= 4;
float X_PWR_SCREEN_ON		= 8;

float X_PWR_ARM_INV			= 3; // pwr armor bits
float X_PWR_ARM_MASK			= 12; // pwr armor on bits


string(float xi) x_key_print;

// X inventory flags

float X_BASE_KEY				= 48; // first two keys (bits 16 & 32 call key_touch) for translated items

float X_D_KEY_BIT				= 1008; // any doom key bit - 1111110000

float X_D_KEY_CRED			= 16;
float X_D_KEY_CBLUE			= 32;
float X_D_KEY_CYEL			= 64;
float X_D_KEY_SKRED			= 128;
float X_D_KEY_SKBLUE			= 256;
float X_D_KEY_SKYEL			= 512;

float X_Q2_KEY_BIT			= 8176; // any q2 key bit - 1111111110000

float X_Q2_KEY_RED			= 16; // q2 has lots of keys.  good for tech runes / etc
float X_Q2_KEY_BLUE			= 32;
float X_Q2_KEY_PYRAMID		= 64;
float X_Q2_KEY_CUBE			= 128;
float X_Q2_KEY_PASS			= 256;
float X_Q2_KEY_AIRSTRK		= 512;
float X_Q2_KEY_DATACD		= 1024;
float X_Q2_KEY_CDSPIN		= 2048;
float X_Q2_KEY_CHEAD			= 4096; // note: second head key
// 8192

float X_D_MAP					= 16384;
float X_D_VIS					= 32768;

float X_PP						= 65536; // portable power point

float X_INV						= 122867; ///  11101111111110011
// last val = 57331; ///  1101111111110011

// end extra items


// q3 goodies

//float X_Q3_HTEL				= 65536;
//float X_Q3_HMED				= 131072;

//float X_INV						= 253939; ///  111101111111110011    --- 57331; //  1101111111110011


// vars x weapon things

void() W_FireClusterGren;

void() x_weapon_touch;

void(entity e, float trv) master_item_control;
void(string tri, float trv) master_item_control_loop;
float(entity e, float q1ck, string itm) noxtr_item_control;
void() x_pwr_touch;
void() x_pack_touch;
void(float velmul, float mvt, float flg, float ct, vector fmorg, vector vdr, string cname, string md, string sd, void() tch, float tht, void() thk, void() thd) fire_missile;
void(entity e, void () tch, float dm) Track_Missile;
void(float recurse, vector p1, vector p2, entity from, float damage) LightningDamage_x;

void() melee_hit;
void() player_plasma1;
void() X_FireHitscan;
void() X_FireRailgun;
void() player_mgchg1;
void() player_pistol1;

void(vector dir1, vector end1, vector bspread, string snd1) X_DeepSleepBlst;

float SPIKE_VEL					= 1000; // IMP: make these cvar? port to other code
float DEF_VEL						= 600;
float ROCKET_VEL					= 1000;

float SPIKE_STICK					= 0.2; // chance a spike sticks in solid

float LASERCAN_VEL;
float LASER_VEL;
float PLASMA_VEL;
float HGREN_VEL;
float GRENADE_VEL;
float ROCKET_FUSE;
float WEPHUM; // weapons hum
float HUMLOCAL					= -41200855;    // taking local control, dont override by auto

// from chaos mod - flamer & flame stuff

float FL_FLARE					= 8192; //entity is a flare starter
float FL_SUBFLARE				= 16384; // flare up flow
float MAX_FLAME_CYC			= 64; // max cycles flame will burn
float MAX_FLARE_CHANCE		= 0.33; // max % of flare in slime
float MAX_FLARE				= 220; // max flares total per level
float MAX_AREA_FLARE			= 40; // max fires in one area
float FLARE_CK_RAD			= 1000; // area to check for flares

float FL_ONFIRE				= 8192;

.float firecontrol;
void() V_FlamerAnim;
void() W_FireFlamer;
void () player_flamer1;
void () FlameTouch;
void() flame_check;
void() slime_flare;
void() flamer_precache;

// end x weaps section


// genre section - weps, items, maps etc.

// hip

float IT_MJOLNIR				= 128;

void() hip_precache;

// wolf

void() wolf_precache;
void() wchg2_weapon_touch;

// doom

string DOOM_DET				= "doom/dsitembk.wav"; // vs.	self.noise4
float D_POWER_WAIT; // seconds major doom powers need to respawn - norm 30
float D_POWER_TIME; // seconds of power supply

float DOOR_2S					= -6; // for doors that have a separate open and close sound - like doom / wolf doors, vs. self.sounds
void() door_sounds_wd;
void() button_sounds_d;

float DOOM_ALPHA;
void(entity e, float mc) doom_alpha_tran;

void() doom_precache;

float d_reps_base				= 57005000; // heh heh - DEAD+
void() d_rep_set;
void() player_saw1;
void() player_bfg1;
//void(float cn) doom_pistol_spread;

float DOOM_BFG 				= 66603;
float DOOM_BFG_TRACE			= 1024; // IDEA: adjust by doom to quake dist adjust for maps ?

// q1

// detect wad = q1 maps, other method - worldtype
// use 3x this value for worldtype with no wad = q1 items (for now)

//										  // worldtype q = 0, 1, 2
float IT0_WQ1					= 3; // worldtype 3
float IT1_WQ1					= 4; // worldtype 4
float IT3_WQ1					= 5; // worldtype 5
float IT4_WQ1					= 6; // worldtype 6

void () weapon_chainlg; // for !XMOD

// q2

string Q2_DET					= "q2_snd/respawn1.wav"; // against	self.noise4
float Q2_POWER_WAIT; // norm = 30
float Q2_POWER_TIME; // norm = 30

void() q2_precache;
void() q2_weapon_shotgun;
void() q2_item_health;
void() X_FireHandGrenade;
void() X_FireBlaster;
void()	player_q2hgr1;
void() q2_teleport_particles;

float q2_bfg_shot; // indicates damage from q2 bfg shot - may not get used, radius is already 1/2 dmg
float Q2_BFG 					= 66604;
float Q2_BFG_TRACE			= 1000;
float Q2_BFG_LASER			= 256;
float Q2_BFG_LASER_DMG		= 5; // 5 pts every 10th sec

.float silencer_finished; // q2 silencer
float Q2_SILENCE; // value of silence as percentage of original volume

// q3

string Q3_DET					= "q3_snd/respawn1.wav"; // against	self.noise4 - NOTE: artifacts are different
string Q3_BOBHOFF				= "cl_itembobheight 0\n"; // q3 item bob height off setting
float Q3_POWER_WAIT; // norm = 120
float Q3_POWER_TIME; // norm = 30
float Q3_RAILBEAM				= 357811;
float Q3_JP_INSTANT			= 1; // if true jump pads are instant trip to target

void() q3_precache;
void() q3_suspend;
void() q3_weapon_shotgun;
void() q3_item_health;
void() q3_bob_height;
// health - armor rot
void(entity e, float v) q3_ha_rot;
float Q3_HAH_TMP, Q3_HAA_TMP; // global temps

// artifact shells

float Q3_SH_QUAD				= 0;
float Q3_SH_REGEN				= 1;
float Q3_SH_HASTE				= 2;
float Q3_SH_ENV				= 3;

// hipnotic


// end genre section

// **************************************
// server, HUD, csqc

// **************************************


//EXT_CSQC
// #232 void(float index, float type, .void field) SV_AddStat (EXT_CSQC)
void(float index, float type, ...) addstat = #232;

/*
these were adding globals - reverted to numeric

float AST_STRING = 1;
float AST_FLOAT = 2;

float STAT_MCODE = 33; // track mcode of current weap in csqc - heh heh
float STAT_RUNEFLAG = 34; // track rune_flag

float STAT_EXPSHELL = 35; // track splode shells
float STAT_PKINV = 36; // track pk inv
float STAT_PKWEP = 37; // track pk wep
float STAT_PKGWELL = 38; // pki ammos
float STAT_PKTURR = 39; // pki ammos
float STAT_PKBT = 40; // pki ammos
float STAT_PKCOPB = 41; // pki ammos
float STAT_PKTOMB = 42; // pki ammos
float STAT_PKEGO = 43; // pki ammos
float STAT_PKPH = 44; // pki ammos
float STAT_PKMASK = 45; // pki ammos

float STAT_AMBUL = 46; // enh ammos
float STAT_AMSLUG = 47; // enh ammos
float STAT_AMGAS = 48; // enh ammos

float STAT_STK1 = 50; // string data
float STAT_STK2 = 51; // string data


float STAT_HIP_IT_EMPATY_SHIELD			= 56;
float STAT_HIP_IT_WETSUIT			= 57;

float STAT_VOL = 64; // track morph cost or chaos level
float STAT_MORPH = 65; // track morph cost or chaos level
float STAT_ARCHON = 66; // track archon power for power bar display

*/


// so we can make new sv_ console vars
//DP_REGISTERCVAR - adds a new console cvar to the server console (in singleplayer this is the player's console), the cvar exists until the mod is unloaded or the game quits.
//idea: LordHavoc - darkplaces implementation: LordHavoc
float(string name, string value) registercvar = #93;

//DP_MOVETYPEFOLLOW
//idea: id Software, LordHavoc (redesigned)
//darkplaces implementation: LordHavoc
//movetype definitions:
float MOVETYPE_FOLLOW		= 12;

float SV_AMMO_MAX; // if true server maxes override genre limits
float DEF_AMMO					= 100; // in case something is wrong in ammo code
float MAX_AMMO					= 1023; // 2 per float this way once parms are combined

float AMMO_NONE				= 100; // mostly melee weps
float AMMO_SHELLS				= 101; // ranged gun uses this ammo type
float AMMO_NAILS				= 103;
float AMMO_ROCKETS			= 105;
float AMMO_CELLS				= 107;
float AMMO_LIGHTNING			= 107; // q3 ammo - just cells for now
float AMMO_BFG					= 107; // q3 ammo - just cells for now
float AMMO_BULLETS			= 109;
float AMMO_SLUGS				= 111;
float AMMO_GRENADES			= 113; // q2 / q3 - handled as rockets in touch
float AMMO_GAS					= 115;

float EXPLOSIVE				= 114688; // for things that explode - chaos mod

// **************************************
// viswep

// **************************************

.float vw_frame; // only run once per frame per ent

// attaches e to a tag on tagentity (note: use "" to attach to entity origin/angles instead of a tag)
//description:
//allows entities to be visually attached to model tags (which follow animations perfectly) on other entities, for example attaching a weapon to a player's hand, 
// or upper body attached to lower body, allowing it to change angles and frame separately (note: origin and angles are relative to the tag, use '0 0 0' for both 
// if you want it to follow exactly, this is similar to viewmodelforclient's behavior).

//note 2: if the tag is not found, it defaults to "" (attach to origin/angles of entity)
//note 3: attaching to world turns off attachment
//note 4: the entity that this is attached to must be visible for this to work

.entity tag_entity; // entity this is attached to (call setattachment to set this)
.float tag_index; // which tag on that entity (0 is relative to the entity, > 0 is an index into the tags on the model if it has any) (call setattachment to set this)
//builtin definitions:
void(entity e, entity tagentity, string tagname) setattachment = #443;

float(entity e, float qw, float pkw) FL_MELEE; // tell if a wep is melee

float qweps, pkweps; // inventory bit masks for weps
.entity vwepent; // vis wep entity pointers
.entity eweapon; // vis wep pointer
.string vwepmdl; // visible weapon model load
.float viswframe; // special framing - drop / pull [not used yet]
.void() _attack; // fires weapon - null if fire from frames
.void() _fr_attack; // starts frame set
void() e_weap_Attack;
entity EWEAP; // current firing pointer - dont use with thinks!

void() viswep_pkbot;
void() viswep_post;
void() viswep_togl;
void() viswep_pre;
entity(entity e) vw_chain;
void() vw_remove;
void(entity vh, float cd) viswep_ld;
float(string wpm) ver_weaponmodel;

vector(entity hent) grap_vw_adj;
.void(float v_frm) vv_draw; // viswep code - weapon drawn
.void(float v_frm) vv_holster; // viswep code -weapon hosltered
void() player_nail3;
float VW; // viswep support - set to 0 to return to generic gun / axe
float VW_ARMOR; // viswep armor support - eventually admin controlled & cvar
float VW_HOLSTER; // viswep - show holstered weps when true
var float autocvar_sv_centerwep;

// Cataboligne - projectile / cartridge fire(d) positioning - 9.30.9

// really needed by viswep & chasecam which shows how bad original positioning looks

float FL_NDISMDL				= 8388608; // flag to prevent display of viswep models

// q weps
// shotguns - cart eject - just an extra
float VWX_SHOTGUN				= 11;
float VWY_SHOTGUN				= 9;
float VWZ_SHOTGUN				= 9;

float VWX_VEL_SHOTGUN		= 8;	// cart eject velocity
float VWY_VEL_SHOTGUN		= 48;
float VWZ_VEL_SHOTGUN		= 16;

// nails
float VWX_NAILG				= 16;	// 12		v_forward *
float VWY_NAILG				= 9;	//			v_right *
float VWZ_NAILG				= 15;	// 16		v_up *

float VWX_SNAILG				= 22;	// 14
float VWY_SNAILG				= 9;
float VWZ_SNAILG				= 15;	// 16

float VWX_PNAILG				= 31;	// 15
float VWY_PNAILG				= 9.5;// 8
float VWZ_PNAILG				= 14;	// 15

// rockets
float VWX_ROCKETL				= 20;
float VWY_ROCKETL				= 11;
float VWZ_ROCKETL				= 16;

float VWX_GRENADEL			= 18;	// 10
float VWY_GRENADEL			= 11;
float VWZ_GRENADEL			= 16;

// cell guns
float VWX_THUNDER				= 12;
float VWY_THUNDER				= 8;
float VWZ_THUNDER				= 16;

float VWX_PLASMA				= 32;
float VWY_PLASMA				= 8;
float VWZ_PLASMA				= 16;

float VWX_LASER				= 32;
float VWY_LASER				= 8.5;
float VWZ_LASER				= 16;

// pk weps
// cell guns
float VWX_CHTHUNDER			= 20;	// 18
float VWY_CHTHUNDER			= 8;
float VWZ_CHTHUNDER			= 16;

float VWX_HARP_IDLE			= 4;	// harpoon is fired, player standing idle
float VWY_HARP_IDLE			= -10;
float VWZ_HARP_IDLE			= -6;
float ROPE_FWD					= 24; // distance to move last seg fwd when it is longer rope piece

float VWX_HARP_RETR			= 8;	// harpoon being retracted
float VWY_HARP_RETR			= 8;
float VWZ_HARP_RETR			= 0;

// slug weps

float VWX_RAILGUN				= 26;
float VWY_RAILGUN				= 14;
float VWZ_RAILGUN				= 15;

// burner

float VWX_FLAMER				= 22;
float VWY_FLAMER				= 2;
float VWZ_FLAMER				= 16;

// hip

// rockets
float VWX_PROXMINE			= 18;
float VWY_PROXMINE			= 11;
float VWZ_PROXMINE			= 16;

// cells
float VWX_LASERCAN			= 22;
float VWY_LASERCAN			= 9;
float VWZ_LASERCAN			= 12;


/// cam section - redone 9.29.13

var float autocvar_sv_cam = 0;

void() cam_waterjump;


// message protocol defines
float SVC_SETVIEWPORT		= 5;
float SVC_SETVIEWANGLES		= 10;

// free player entity variable
// '.float speed'  bit-flag defines:

//float CHSCAM_MONSTER  = ;
float CHSCAM_ON				= 1;
float LASERTARG_ON			= 4;
float LASERTARG_LIT			= 32;

.vector cam; // all chase cam data
void() cam_punch;						// return punchangle if passed parm - otherwise set self. var
void() dead_cam_set;					// Cataboligne 9.11.3 purify proto - chase cam
float DCAMTO;							// timeout for death cam 2 mins
float DCAMTOACT;						// action after timeout 0 = respawn, 1 = disconnect

// frag counting

float FFW_LIMIT;						// time limit on how long players get frags from fire & forget weaps after dead
float NOCIDE;							// dont cound suicide frags for idiom of var
float NOENVCIDE;
float NOPKCIDE;
float() frag_minus_cide;

// cam vision field settings
float DCAM_FOV					= 130; // dead cam crow vision
string DCAM_SET_FOV			= "fov 130\n"; // set it if not set or changed
string STD_FOV					= "fov 90\n";
string CAM_FOV					= "fov 80\n"; // field for cam view


// **************************************
// Rotation - Hip

// **************************************
.vector neworigin;
.vector rotate;
.float endtime;
.float rotate_type;
.string path;
.string group;
.string event;
.float duration;


// **************************************
// painkeep protos - everything below this line

// **************************************


// admin code
.float admin;
float(string mp) PK_mapmode;
void() PK_SetAdmin;
void() PK_AdminImpulse;
void() admin_sv_cfg;
void() Admin_mainmenu;
float() admin_postthink;
void() admin_resettimeout;
string OBSERVER = "jafo"; // nod to Blue Thunder : "just another fucking observer"
float pk_flags_ck;
float pk_itemovr_ck;
float (float rl) AdminBitFlag;
void() dyn_item;
void() pk_cphub;
void(entity e) pk_admincfg;
void () tfragadmin_touch;

//float PK-TP_STATUSON			= 256;
.float hubstartupmessage;
.float messagetimeout;

.float revotemsg;

// For the level sequences, if the exec file has been run yet.
float execed;
float PK_TP_USERMAPON		= 512;


// relocated from defs.qc

string (string s) precache_sound__ = #19;  // dynamic items deal
string (string s) precache_model__ = #20; 
string (string s) precache_sound;
string (string s) precache_model; 

// hijacked for pk_mode running non pk maps with non pk sounds
//void(entity e, float chan, string samp, float vol, float atten) pk_sound = #8;
void(entity e, float chan, string samp, float vol, float atten) pk_sound; // *frikbot
void(vector pos, string samp, float vol, float atten) pk_ambientsound = #74;

// from triggers

// For new teleporter sounds
float SOUND_GOT;
string normalsound;
string reversesound;

// PK new print prototypes...
//void(entity client, string s, string s1) centerprint2 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2) centerprint3 = #73;	// sprint, but in middle
//void(entity client, string s, string s1, string s2, string s3) centerprint4 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4) centerprint5 = #73;	// sprint, but in middle
//void(entity client, string s, string s1, string s2, string s3, string s4, string s5) centerprint6 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4, string s5, string s6) centerprint7 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4, string s5, string s6, string s8) centerprint8 = #73;	// sprint, but in middle
//void(entity client, string s, string s1, string s2, string s2b ,string s3, string s3b, string s4, string s4b, string s5, string s5b, string s6, string s7) centerprint8 = #73;	// sprint, but in middle

// 2d trains

// used by path_corners to specify the 2 possible destinations
.string target1;
.string target2;

// items
.float pk_items;	// Items used for impulse 1
.float pk_currentitem;
float pk_attack;		// bit 1 = can make a pk attack on any map, bit 2 = pk_artifacts attack
void() use_pkitem; // bots using pk items
void(entity e, vector pv1) item_eject;


float PK_INV = 1; // if true show pk items in inventory list
float PKID; // painkeep item ids that are ammo count stored: PKPLUS_IT_EGO + PKPLUS_IT_TOMB + PKPLUS_IT_ACTOR + PKPLUS_IT_PHONE + PK_IT_GRAVITYWELL + PK_IT_TURRET + PK_IT_CANPAB + PK_IT_BEARTRAP;


// Items used in impulse 1
float PK_IT_AXE				= 1;
float PK_IT_GRAVITYWELL		= 2;
float PK_IT_TURRET			= 4;
float PK_IT_CANPAB			= 8;
float PK_IT_GRAPGUN			= 16;
float PK_IT_AIRGUN			= 32;
float PK_IT_CLIGHT			= 64;
float PK_IT_BEARTRAP			= 128;
//float PK-IT_EXTRADISP		= 4096; //= 256; - pk artifacts support recode

float PK_IT_RANGE				= 112; // range weps - grap, airgun, chainthunder
float PK_IT_CARY				= 3982; // throwables - fire & forget - grav, turret, can, beartrap, ego, tomb, phone, actor
/*
Impulse 1 will toggle between Axe, Bear Trap, CoPB, AS, and GW.


Custom impulses:

Impulse 30 - AirFist
Impulse 31 - Grappling Gun
Impulse 22 - Pulse Nailgun
Impulse 33 - Chain Lightning Gun
Impulse 34 - Gravity Well
Impulse 35 - Bear Trap
Impulse 36 - AutoSentry
Impulse 37 - Can of Pork and Beans
Impulse 38 - Axe (just to do complete)
*/
// pk ammo
.float pk_gravitywellammo, pk_turretammo, pk_canpabammo, pk_beartrapammo;

// Ammo Max'S
// q1 standard
float Q1_SHELLAMMO_MAX;
float Q1_NAILAMMO_MAX;
float Q1_ROCKETAMMO_MAX;
float Q1_CELLAMMO_MAX;

float PK_GRAVITYWELLAMMO_MAX;
float PK_TURRETAMMO_MAX;
float PK_CANPABAMMO_MAX;
float PK_BEARTRAPAMMO_MAX;

float PK_MAX_LIVENT; // max live ents (fire & forget) weapons a server allows
float pk_livent; // current count

// The current inventory item
.float pk_currentInventory;

// new gibs
entity damage_inflictor;	// set by T_Damage


// Variables used for the air gun.

// Used to flag states for entity's for the AirFist mod.
.float AIRG_Flags;

// Variables used to track when to turn of FLY movetype for flying entity's
.entity AIRG_FlyTracker;

// Constant used on the AIRG_Flags to specifiy that we have converted this
// flying monsters movetype from MOVETYPE_STEP to MOVETYPE_FLY (see horn.qc for
// more info).
float AIRG_STEPCONVERTEDTOFLY	= 2;

// Air Gun flag constants.
// Setting an entity's AIRG_Flags excludes it from harm
float AIRG_EXCLUDEENTITY		= 1;

// At the moment the AIRG_Flags variable is used only for the exclusion routine
// but this may change.

// Used in the Max Fire Rate Calculations.
.float AIRG_FireCount;
.float AIRG_Timeout;


// Airblast timeout variable.	Tracks how long the "blast" affects monsters...
.float AIRG_BlastTimeout;				// Airblast origin, & viewing angle
.vector AIRG_BlastOrigin;
.vector AIRG_BlastAngle;

// Prototypes used
void() launch_horn;
void(float firstBlast) horn_airblast;


// chain thunder bolt
.entity bolt_target;	    				// current player firing at ...
.entity bolt_targetNext;				// next target in the chain...
.float bolt_targetTimeout; 			// used to timeout the bolt_target...
.float bolt_targetNextTimeout; 		// used to timeout the bolt_targetNext...

.entity bolt_targetTimeoutEntity; 	// Entity timeout, used just for the nextthink!

.float bolt_conduitTimeout;			// Entity conduit timeout if the entity handles it...

//float	FL_GIBCONDUIT	= 8192;		// set if it's the first conduit entity

.float bolt_changeModelTimeout;		// used to change the view weapon modal timeout.

// Used as the lightning fire source entity so that the "player" can fire lightning himeself
.entity bolt_lightningFire;


// harpoon
.entity grap_cornerchainNext; 		// next in the rope corner chain.
.entity grap_ropechainPrev;			// prev in the rope chain.
.entity grap_owner; 						// Can't use owner cas the object can't see the owner!
.entity grap_pull;
.float grap_checkTimeout;
.float grap_state;
.float grap_length;
.vector grep_offset;						// harpoon target offset for bringing back to owner
.float grap_firetest;

float GRAP_IDEAL				= 0; 		// Going nothing
float GRAP_OUT					= 1; 		// It's outing out
float GRAP_IN					= 2; 		// It's comming back to the owner
float GRAP_TOHARPOON			= 3; 		// lengthen rope
float GRAP_FIXED				= 4; 		// The length is fixed.
float GRAP_ROPESHORTEN		= 5; 		// shorten rope
float GRAP_ROPELENGTHEN		= 6;		// lengthen rope
float GRAP_HARPOON			= 7;
float GRAP_CORNER				= 8;
float GRAP_ROPE				= 9;

float VW_HARP_FRADJ        = 20; // frame adjust from run / stand for a fired harp


// crates o stuff

float PK_CRATE;

// sounds of busting
string CRATE_OPEN1			= "chaos/crate1a.wav";
string CRATE_OPEN2			= "chaos/crate1b.wav";
string CRATE_OPEN3			= "chaos/crate1c.wav";
string CRATE_OPENED			= "chaos/crate1o.wav";

// pk cubes

float PK_CUBE;
float PK_CUBE_DIST			= 192; // must be this close to cube to open, heh heh
float PK_CUBE_TIME; // freq of respawn
float PK_CUBE_DV; // dev of respawn
void(string cb) cube_handle;

// can o p&b
.float copb_timeout;
.float copb_nextFartTimeout;


// auto turrets
.float turret_timeout;
.float turret_soundtimeout;
.float turret_ownertimeout;
.entity turret_base;
void(entity e, float tm) turret_KillStraker;

float PK_TUR_AMMO; // base cells to fire, 0 = infinite
float PK_TUR_TIME; // time to live, after which explode, 0 = no timeout
float PK_TUR_HEAL; // health we get - base = 2/3 this, < 0 = no limit
float PK_TUR_TARGOWN; // time after which turret shoots owner, 0 = dont target owner
float PK_TUR_VARIETY; // a variety of turrets - 
float PK_TUR_QUADCON;
float PK_TUR_SET; // set non 0 when vars loaded

// b traps
float PK_BT_SET;
float PK_BT_TIMETOFOLLOW;
float PK_BT_DMG;
float PK_BT_TIME;

.float beartrap_time;
.float bt_immune_time;
float BT_BUFFER				= 2;	  	// The nuber of secs people are immune to beartraps after spawning

// grav

float PK_GRV_TIME;
float PK_GRV_SET;
float PK_GRV_RSP; // special respawn override

// other weps

float LASER_FLY; // time a laser is in flight
float LASER_BOUNCE; // how much a reflecting laser can bounce
float LASER_RND_END = 0.02; // orig = 0.15, chance per bounce a laser will end

// exploding ammo for shotgun
.float pk_explode_ammo;
float PK_EXPLODEAMMO_MAX;

// item repositions
.vector ip_orgOrigin;

// the timeout (in mins) where items move back to there original position...
float ip_timeout				= 2;


// For Drowning Ignoring armor
float ignorearmor;


// hub ops
//float PK_SF_HUB = 16;
string CL_BOBSET           = "cl_bob 0.02\n"; // val for turning view bob back on when not exited hub
float CL_BOBVAL				= 0.02; // standard bob amount
float PK_SF_HUB				= 1024;	// moved to pk_flags
float PK_TP_TIMEMASK			= 63;
float inHubMap;
float custom_hub_loaded;				// if TRUE custom hub is used

.float voteIntermission;
string() hub_select;
float() check_custom_hub;
float(float cn) bot_vote;			// bot...vote

// MOTD
float MOTDTIME					= 120;		// The amount of "frames" for the motd message (minimum should be 20)
float DONTALLOWBOTS			= 1;		// If we want to show anti bots messages at startup
.float msgcount;
void() updateStatusDisplay;

.float laststattime;					// time of last status update

// Quake Packet Message
float	SVC_CENTERPRINT		= 26;

.float disconnectPlayer;

// If the SFX are enabled or not
//float sparkFlashOff;
float PK_TP_SPARKSFLASH		= 64;

// Last weapon stuff
.float lastweapon;
.float prevweapon;
.float pklastweapon;
.float pkprevweapon;
.float forcewchange;

// CenterPrint functions
void(float to, float f) WriteB3;
void(float to, float f) WriteBDigit;
void(float to, float f) WriteBFloat;


// **************************************
// Cataboligne relocated from many places

// new pk central code point reqs
void() grap_releaseHarpoon;
void() SUB_regen;
void(entity e) AddToSplashBig;
float(entity e) frag_plus;
float() frag_minus;

// pk_prethink
void() WaterMove;
void() CheckRules;
void() CheckWaterJump;
void() PlayerDeathThink;
void() PlayerJump;
float() W_BestWeapon;
void() W_SetCurrentAmmo;
void(entity e) PK_SetCurrentAmmoOnly;
void() CheckWaterLevels;
float cc_frame;
// pk_postthink
void () W_WeaponFrame;
void() CheckPowerups;

// moved from v106 *.qc - Cataboligne - 3.27.8

// client code
void() grap_maintainHarpoon;
void() bolt_checkTargets;
void() player_conduitJerk;
void() copb_checkFart;
void(entity targ, entity inflictor, entity attacker) PK_ClientObituary;

// item code
void() grap_checkIfGrap;
void() ip_checkForMovement;
float() W_BestPKWeapon;
void(entity targ) pk_setDamageSkin;
// added
void() painkeep_touch;
void() pk_ammo_touch;
void() pk_bound_ammo;
void() pk_item_position;
void() pk_item_position_init;
float(float w, float w2) PK_RankForWeapon;
void(float new, float new2) PK_Deathmatch_Weapon;
void() DropBackpack;
void() BackpackTouch;
//void(entity e) PK_BackpackSetup;

// player code
void() bolt_fire;
void() bolt_s_explode1;
void(entity grapOwner) grap_remove;
void() pk_stand_frames;
void() pk_run_frames;

// added
void() pk_harpoon_frames;
void() player_pnail1;
void() PK_PlayerDie;
void() PK_GibPlayer;
void() PK_DeathSound;
//void(float sec) pk_player_sound;

// weapons
.entity theowner; 						// .owner replacement pulse nailgun
void() turret_dropTurret;
void() beartrap_dropBearTrap;
void() drop_gravity;
void() drop_gravity_sups;
void() grap_fire;
void(float shotcount, vector dir, vector spread) FireExplodeShells;
void() pulse_touch;
void()	player_bolt1;
void() copb_eatCan;

// added
void(float shots) W_FireShotgunExploder;
void(float ox) W_FirePulseSpikes;
void() PK_SetCurrentAmmo;
float(float weaponnum, float pknum) CanSelect;
float(float weaponnum, float pknum) HasAmmo;
//void() PK_WeaponFrame;
float() PK_BestWeapon;
float() PK_CheckNoAmmo;
void() PK_ChangeWeapon;
void() PK_CycleWeaponCommand;
void() PK_CycleWeaponReverseCommand;
void() PK_ImpulseCommands;
void() PK_Attack;
void(entity e) pk_missile_splash;

// new features
.void() pk_touch; 						// group all touch code mods here
void() pk_placeitem;
void () pkplus_touch;



// testing
.float alpha; // darkplaces model transparency!

entity lastspawn;

/*

NOTES:

code base: these are done in many places, here for portability

	if (PK) AddToSplashBig(self); // *pk - Make this entity splash
	if (PK) AddToSplash(missile); // *pk - Make this entity splash

	if (PK) newmis.AIRG_Flags = AIRG_EXCLUDEENTITY; // *pk - 

	if (other.classname != "player")
	{
		if (PK) grap_checkIfGrap(); // *pk - harpoon item move checks
		return;
	}

deathmatch modes

1 = regular quake dm, all items respawn, guns are always taken on touch
2 = old doom dm rules - guns are not taken as ammo on touch if you have one already, _only_ powerups respawn (if wep is taken it does not dissapear)
3 = new PK rule - guns are not taken as ammo, ammo respawns in 15 secs, health & armor respawn (if wep is taken it does not dissapear)
4+ = (unintentional but logical extrapolation from code) - healths & pk weps respawn, ammo, armor, powerups & weapons do not, weapons dissappear (gone till reload!)


for portability the following fn()'s are entirely replaced when running in PK mode - note this does make modding this mod harder as much code can be run from 2 places

RankForWeapon() - called separately in v106 & pk code - has different parms, called from respective *Deathmatch_Weapon
WeaponFrame() - called from pre think loop, not a divert

--- tie in dirverts exec for most of the code

CheatCommand()
CycleWeaponReverseCommand()
CycleWeaponCommand()
ChangeWeapon()
ImpulseCommands()
Attack()

DropBackpack()
BackpackTouch()
DeathSound()
GibPlayer()
PlayerDie()
ClientObituary() - divert by fn() call, still runs killed code afterwards
Deathmatch_Weapon - divert by fn() call, still runs weapon_touch code afterwards
BestWeapon()
SetCurrentAmmo()
PlayerPreThink
PlayerPostThink

SPECIAL NOTE: to make mods to both v106 (or other) code and painkeep - make mod before tie in call diversion.
					if your code requiers more complex mods you will need to either a) mod both code sets, or b) make a new code set
					if you choose to mod both code sets we recommend a tie in fn() call to the same code
*/
