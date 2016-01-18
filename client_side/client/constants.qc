/*

Constants used only on the client.

*/

// add-entity mask bits
float MASK_ENGINE				= 1;
float MASK_ENGINEVIEWMODELS	= 2;
float MASK_NORMAL				= 4;

// renderflag bits
float RF_VIEWMODEL		= 1;
float RF_EXTERNALMODEL	= 2;
float RF_DEPTHHACK		= 4;
float RF_ADDATIVE			= 8;
float RF_USEAXIS			= 16;

// flags for 2d drawing
float DRAWFLAG_NORMAL       = 0;
float DRAWFLAG_ADDITIVE     = 1;
float DRAWFLAG_MODULATE     = 2;
float DRAWFLAG_2XMODULATE   = 3;

// setview parameter
float VF_MIN			= 1;	//(vector)
float VF_MIN_X		= 2;	//(float)
float VF_MIN_Y		= 3;	//(float)
float VF_SIZE			= 4;	//(vector) (viewport size)
float VF_SIZE_Y		= 5;	//(float)
float VF_SIZE_X		= 6;	//(float)
float VF_VIEWPORT		= 7;	//(vector, vector)
float VF_FOV			= 8;	//(vector)
float VF_FOVX			= 9;	//(float)
float VF_FOVY			= 10;	//(float)
float VF_ORIGIN		= 11;	//(vector)
float VF_ORIGIN_X		= 12;	//(float)
float VF_ORIGIN_Y		= 13;	//(float)
float VF_ORIGIN_Z		= 14;	//(float)
float VF_ANGLES		= 15;	//(vector)
float VF_ANGLES_X		= 16;	//(float)
float VF_ANGLES_Y		= 17;	//(float)
float VF_ANGLES_Z		= 18;	//(float)
float VF_DRAWWORLD	= 19;	//(float)
float VF_DRAWENGINESBAR	= 20;	//(float)
float VF_DRAWCROSSHAIR	= 21;	//(float)

float VF_CL_VIEWANGLES	= 33;	//(vector)
float VF_CL_VIEWANGLES_X	= 34;	//(float)
float VF_CL_VIEWANGLES_Y	= 35;	//(float)
float VF_CL_VIEWANGLES_Z	= 36;	//(float) 

// input events
float INPUT_KEYDOWN   = 0;
float INPUT_KEYUP     = 1;
float INPUT_MOUSEMOVE = 2;

// stats
// 0 - 31 are reserved for standard engine stats
// 32 - 128 are for QuakeC modders
float STAT_HEALTH			= 0;
float STAT_WEAPONMODEL	= 2;
float STAT_AMMO			= 3;
float STAT_ARMOR			= 4;
float STAT_WEAPONFRAME	= 5;
float STAT_SHELLS			= 6;
float STAT_NAILS			= 7;
float STAT_ROCKETS		= 8;
float STAT_CELLS			= 9;
float STAT_ACTIVEWEAPON	= 10;
float STAT_TOTALSECRETS	= 11;
float STAT_TOTALMONSTERS	= 12;
float STAT_SECRETS		= 13; // bumped on client side by svc_foundsecret
float STAT_MONSTERS		= 14; // bumped by svc_killedmonster
float STAT_ITEMS			= 15;
float STAT_HIP_IT_EMPATY_SHIELD			= 56;
float STAT_HIP_IT_WETSUIT			= 57;

// Archon extended HUD
float STAT_MCODE = 33; // track mcode of current weap in csqc - heh heh
float STAT_RUNEFLAG = 34; // track rune_flag
float STAT_PKM = 49; // track painkeep PK mode

float STAT_EXPSHELL = 35; // track splode shells - dual purpose spell cost
float STAT_PKINV = 36; // track pk inv - 3 weps
float STAT_PKWEP = 37; // track pk inv - cur wep

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

//float STAT_SPELLCOST = 65; // track spell point cost
float STAT_ARCHON = 66; // track archon power for power bar display

// fooey.  these will be tricky to maintain since the list is built on the fly
//					this will need to be UPDATED everytime we add, re-arrange or change items

float MC_SHOTGUN = 101;
float MC_SUPER_SHOTGUN = 102;

float MC_PULSE_NAILGUN = 135;
float MC_GRAP = 137;
float MC_CHTHUNDR = 136;
float MC_AIRGUN = 138;
float MC_HOOK = 148;
float MC_HIP_MJOLNIR = 149;
float MC_HIP_LASERCAN = 150;
float MC_HIP_PROXGUN = 151;
float MC_Q2_RAILGUN = 218;
float MC_C_FLAMER = 293;

// pk inv - collectables
float PK_IT_AXE				= 1;
float PK_IT_GRAPGUN			= 16;
float PK_IT_AIRGUN			= 32;
float PK_IT_CLIGHT			= 64;
float PK_IT_GRAVITYWELL		= 2;
float PK_IT_TURRET			= 4;
float PK_IT_CANPAB			= 8;
float PK_IT_BEARTRAP			= 128;
float PKPLUS_IT_EGO			= 256;
float PKPLUS_IT_TOMB			= 512;
float PKPLUS_IT_ACTOR		= 1024;
float PKPLUS_IT_PHONE		= 2048;

// runes - another fooey - rune powers can randomize...but we think these flag values are constant and only the appearance changes

float RUNE_FLG_RS				= 1;
float RUNE_FLG_DM				= 2;
float RUNE_FLG_HS				= 4;
float RUNE_FLG_RG				= 8;
float RUNE_VAMPIRE			= 64; // lithium rune
float TECH_DSH					= 131072; // techs from lith - leaves 10 bits for new runes above
float TECH_AMP					= 262144;
float TECH_TEIM				= 524288;
float TECH_ADOC				= 1048576;

// player flags, calculated in 
float PFL_DEAD     = 4;
float PFL_GIBBED   = 8;
const float		CONTENT_EMPTY					= -1;
const float		CONTENT_SOLID					= -2;
const float		CONTENT_WATER					= -3;
const float		CONTENT_SLIME					= -4;
const float		CONTENT_LAVA					= -5;
const float		CONTENT_SKY						= -6;
float		STAT_VIEWHEIGHT					= 16;