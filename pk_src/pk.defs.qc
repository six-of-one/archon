// **************************************
// painkeep
//
// **************************************


// server ops
float(string mp) PK_mapmode;
float pk_flags_ck;
float pk_itemovr_ck;
void() pk_cphub;


float PK;									// if set true painkeep code is enabled
#define PK_MAP					6144	// bit * = FALSE -- map sets painkeep mode  - PK = TRUE if: any pk*.bsp loaded, start.bsp loaded and message == "hub", a map loads any painkeep map item, PK = FALSE otherwise
#define PK_ALWAYS				2048	// bit *	= TRUE --- always in painkeep mode - PK = TRUE;
#define PK_NEVER					4096	// bit *	= TRUE --- never in painkeep mode  - PK = FALSE;
#define PK_DYNAMIC				8192	// bit *	= TRUE --- when always in painkeep mode & not on a PK map, dynamically load pk items if they are not present
//												// items include  - bear trap, can o' beans, gravity well, harpoon, turret, airfist, exploding shot, XXX - chain thunderbolt, pulse nailgun
#define PK_SPIKER				16384	// bit *	= FALSE -- allow spike traps, set to true for original pk treatment of spike shooters - they are removed
#define PK_XSOUND				32768	// bit * = TRUE --- use extra pk sound set

//#define PK-TP_STATUSON			256

// hub

.float hubstartupmessage;
.float messagetimeout;

.float revotemsg;

// For the level sequences, if the exec file has been run yet.
float execed;
#define PK_TP_USERMAPON		512


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
#define PK_IT_AXE				1
#define PK_IT_GRAVITYWELL		2
#define PK_IT_TURRET			4
#define PK_IT_CANPAB			8
#define PK_IT_GRAPGUN			16
#define PK_IT_AIRGUN			32
#define PK_IT_CLIGHT			64
#define PK_IT_BEARTRAP			128
//#define PK-IT_EXTRADISP		4096 //= 256; - pk artifacts support recode

#define PK_IT_RANGE				112 // range weps - grap, airgun, chainthunder
#define PK_IT_CARY				3982 // throwables - fire & forget - grav, turret, can, beartrap, ego, tomb, phone, actor
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
#define AIRG_STEPCONVERTEDTOFLY	2

// Air Gun flag constants.
// Setting an entity's AIRG_Flags excludes it from harm
#define AIRG_EXCLUDEENTITY		1

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

//#define	FL_GIBCONDUIT	8192		// set if it's the first conduit entity

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

#define GRAP_IDEAL				0 		// Going nothing
#define GRAP_OUT					1 		// It's outing out
#define GRAP_IN					2 		// It's comming back to the owner
#define GRAP_TOHARPOON			3 		// lengthen rope
#define GRAP_FIXED				4 		// The length is fixed.
#define GRAP_ROPESHORTEN		5 		// shorten rope
#define GRAP_ROPELENGTHEN		6		// lengthen rope
#define GRAP_HARPOON			7
#define GRAP_CORNER				8
#define GRAP_ROPE				9

#define VW_HARP_FRADJ        20 // frame adjust from run / stand for a fired harp


// crates o stuff

float PK_CRATE;

// sounds of busting
string CRATE_OPEN1			= "chaos/crate1a.wav";
string CRATE_OPEN2			= "chaos/crate1b.wav";
string CRATE_OPEN3			= "chaos/crate1c.wav";
string CRATE_OPENED			= "chaos/crate1o.wav";

// pk cubes

var float autocvar_it_cubes_info = 1;
var float autocvar_it_cubes_pk = 0;
var float autocvar_it_cubes_morph = 0;

float PK_CUBE;
#define PK_CUBE_DIST			192 // must be this close to cube to open, heh heh
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
#define BT_BUFFER				2	  	// The nuber of rels people are immune to beartraps after spawning

// grav

float PK_GRV_TIME;
float PK_GRV_SET;
float PK_GRV_RSP; // special respawn override


// exploding ammo for shotgun
.float pk_explode_ammo;
float PK_EXPLODEAMMO_MAX;

// item repositions
.vector ip_orgOrigin;

// the timeout (in mins) where items move back to there original position...
#define ip_timeout				2


// For Drowning Ignoring armor
float ignorearmor;


// hub ops
//#define PK_SF_HUB 16
string CL_BOBSET           = "cl_bob 0.02\n"; // val for turning view bob back on when not exited hub
#define CL_BOBVAL				0.02 // standard bob amount
#define PK_SF_HUB				1024	// moved to pk_flags
#define PK_TP_TIMEMASK			63
float inHubMap;
float custom_hub_loaded;				// if TRUE custom hub is used

.float voteIntermission;
//string() hub_select;
float() check_custom_hub;
float(float cn) bot_vote;			// bot...vote

// MOTD
#define MOTDTIME					120		// The amount of "frames" for the motd message (minimum should be 20)
#define DONTALLOWBOTS			1		// If we want to show anti bots messages at startup
.float msgcount;
void() updateStatusDisplay;

.float laststattime;					// time of last status update

// Quake Packet Message
#define	SVC_CENTERPRINT		26

.float disconnectPlayer;

// If the SFX are enabled or not
//float sparkFlashOff;
#define PK_TP_SPARKSFLASH		64

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
void()	player_bolt1;
void() copb_eatCan;

#ifndef enhanced
void() pulse_touch;
#endifdef

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
3 = new PK rule - guns are not taken as ammo, ammo respawns in 15 rels, health & armor respawn (if wep is taken it does not dissapear)
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
