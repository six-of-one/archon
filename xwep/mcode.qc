/* ::-::
 *
 * Cataboligne
 *
 * file: mcode.qc
 *
 * date: 5/27/10
 *
 * qc - map codes for wep cycling - chaos mod code
 *
 */

//float MIN_ITEM					= 100;
//float MAX_INVITEM			= 255;
//float MAX_OLDQ				= 300;
float MAX_ITEM					= 999;

float ITEM_SET1				= 1023;
float ITEM_SET2				= 1047552; // allows multiplexing of 2 x 1023 bit values in 1 float if needed


// master code list

/// quake 1
// q1 wep ids
float MC_AXE;
float MC_SHOTGUN;
//float MC_SUPER_SHOTGUN; // - 101 to get item override menu #
float MC_NAILGUN;
float MC_SUPER_NAILGUN;
float MC_GRENADEL;
float MC_ROCKETL;
float MC_THUNDER;

// 108 is special - xlates to pkitems on admin item override menu

// special ids
float MC_QUAD;
float MC_PENT;
float MC_RING;
float MC_SUIT;

// armor ids
float MC_ARMOR1;
float MC_ARMOR2;
float MC_ARMOR3;

// health ids - translate
float MC_HEALTHROT;
float MC_HEALTH;
float MC_HEALTHMEGA;

// key ids
float MC_KEY1;
float MC_KEY2;

// ammo ids
float MC_ASHELLS;
//float MC_ASHELLS_LG;
float MC_ANAILS;
//float MC_ANAILS_LG;
float MC_AROCKETS;
//float MC_AROCKETS_LG;
float MC_ACELLS;
//float MC_ACELLS_LG;

// boom!
float MC_EXPLOD1;
float MC_EXPLOD2;

// sigil id - flags
float MC_SIGIL1;
float MC_SIGIL2;
float MC_SIGIL4;
float MC_SIGIL8;

float MC_SIGIL16; // ammo rune
float MC_SIGIL32; // fly rune

float MC_SIGIL64; // vampire rune

float MC_Q1;
float MC_RNDITM; // # of q1 items - have to change as items changes
float MC_NR_RNDITM; // no runes

float MC_SIGIL;

// key ids special (keyX)
float MC_KEY1_0;
float MC_KEY1_1;
float MC_KEY1_2;
float MC_KEY2_0;
float MC_KEY2_1;
float MC_KEY2_2;

float MC_BACKPACK;

/// painkeep
// pk wep ids
float MC_EXPSHOTGUN;
//float MC_PULSE_NAILGUN; // moved for HUD
float MC_CHTHUNDR;
float MC_GRAP;
float MC_AIRGUN;

// device ids - carryable stuff? (doesnt use ammo like a range wep)
//float MC_CARRYABLE;
// pk weps;
float MC_BEARTRAP;
float MC_GRAVITY;
float MC_SENTRY;
float MC_CANOBEANS;
//float MC_AEXPLSH;
// pk plus
float MC_TOMB;
float MC_EGO;
float MC_PHONE;
float MC_MASK;

float MC_PK;
float MC_PK_RNDITM; // # of base pk items
float MC_PKP_RNDITM; // + plus items


float MC_T_RNDITM; // # of total items

//float MC_HOOK; // CTF hook map item - moved to defs

/// hipnotic
// wep ids
float MC_HIP_MJOLNIR;
float MC_HIP_LASERCAN;
float MC_HIP_PROXGUN;

float MC_HIP_WETSUIT;
float MC_HIP_EMPSH;
float MC_HIP_CORNUCOPIA;

float MC_HIP;

float MC_HIP_RNDITM; // # of total items

/// doom

float MC_D_FIST;
float MC_D_SAW;
//float MC_D_PISTOL;
float MC_D_SHOTGUN;
float MC_D_BOOMSTICK;
float MC_D_CHAINGUN;
float MC_D_ROCKETL;
float MC_D_PLASMA;
float MC_D_BFG;

float MC_D_BERS;
float MC_D_INVUL;
float MC_D_INVIS;
float MC_D_RADSUIT;
float MC_D_SOULSPH;
float MC_D_MEGASPH;

float MC_D_ARM_SPR;
float MC_D_ARM_GRN;
float MC_D_ARM_BLU;

float MC_D_HBOTTLE;
float MC_D_STIMPAK;
float MC_D_MEDKIT;

float MC_D_KEY_RED_SK;
float MC_D_KEY_BLU_SK;
float MC_D_KEY_YEL_SK;
float MC_D_KEY_RED_CR;
float MC_D_KEY_BLU_CR;
float MC_D_KEY_YEL_CR;

float MC_D_ASHELLS;
float MC_D_ASHELLS_LG;
float MC_D_ABULLETS;
float MC_D_ABULLETS_LG;
float MC_D_AROCKET;
float MC_D_AROCKETS_LG;
float MC_D_ACELLS;
float MC_D_ACELLS_LG;

float MC_D_PACK;

float MC_D_NIGHTVS;
float MC_D_AUTOMAP;

float MC_D_BARREL;

float MC_DOOM;

float MC_D_RNDITM; // # of total items

/// wolf 3d

float MC_W_KNIFE;
float MC_W_PISTOL;
float MC_W_MACHGUN;
float MC_W_CHAINGUN;
float MC_W_MORTAR;
float MC_W_FLAMER;

float MC_W_CLIP;
float MC_W_GAS;
float MC_W_MORTARS;
float MC_W_PACK;

float MC_W_FACESPHERE;
float MC_W_HEALTH;
float MC_W_FOOD;
float MC_W_DOGFOOD;
float MC_W_BLOOD;
float MC_W_BLDBNS;

float MC_W_KEY_G;
float MC_W_KEY_B;

float MC_W_G_CROSS;
float MC_W_G_CHALICE;
float MC_W_G_CHEST;
float MC_W_G_CROWN;

float MC_W_BARREL;

float MC_WOLF;

float MC_W_RNDITM; // # of total items

/// q2

float MC_Q2_BLASTER;
float MC_Q2_SHOTGUN;
float MC_Q2_DBLSHOTGUN;
float MC_Q2_MACHINEGUN;
float MC_Q2_CHAINGUN;
float MC_Q2_GRENADEL;
float MC_Q2_ROCKETL;
float MC_Q2_HYPBLASTER;
float MC_Q2_RAILGUN;
float MC_Q2_BFG;
//float MC_Q2_GRAPPLE;

float MC_Q2_QUAD;
float MC_Q2_INVUL;
float MC_Q2_ENVIRO;
float MC_Q2_SILENCE;

float MC_Q2_ARM_SHARD;
float MC_Q2_ARM_JAK;
float MC_Q2_ARM_COMBAT;
float MC_Q2_ARM_BODY;
float MC_Q2_ARM_PSHIELD;
float MC_Q2_ARM_PSCREEN;

float MC_Q2_STIMPAK;
float MC_Q2_FIRSTAID;
float MC_Q2_MEDKIT;
float MC_Q2_MEGA;

float MC_Q2_KEY_RED;
float MC_Q2_KEY_BLU;
float MC_Q2_KEY_CHEAD;
float MC_Q2_KEY_ATARGET;
float MC_Q2_KEY_CD;
float MC_Q2_KEY_SPINNER;
float MC_Q2_KEY_PASS;
float MC_Q2_KEY_POWER;
float MC_Q2_KEY_PYRAMID;

float MC_Q2_ASHELLS;
float MC_Q2_ABULLETS;
float MC_Q2_AROCKETS;
float MC_Q2_AGRENADES;
float MC_Q2_ACELLS;
float MC_Q2_ASLUGS;

float MC_Q2_PACK;
float MC_Q2_ADRENALINE;
float MC_Q2_BANDOLIER;
float MC_Q2_BREATHER;

float MC_Q2_BARREL;

float MC_Q2;

float MC_Q2_RNDITM; // # of total items

float MC_Q2_TECH_RES; // tech
float MC_Q2_TECH_DOC;
float MC_Q2_TECH_AMP;
float MC_Q2_TECH_TM;

/// q3

float MC_Q3_GAUNTLET;
//float MC_Q3_GRAPPLE;
float MC_Q3_MACHINEGUN;
float MC_Q3_SHOTGUN;
float MC_Q3_GRENADEL;
float MC_Q3_ROCKETL;
float MC_Q3_PLASMA;
//float MC_Q3_LIGHTNING;
float MC_Q3_RAILGUN;
float MC_Q3_BFG;

float MC_Q3_QUAD;
float MC_Q3_REGEN;
float MC_Q3_ENVIRO;
float MC_Q3_INVIS;
float MC_Q3_HASTE;
float MC_Q3_FLIGHT;

float MC_Q3_ARM_SHARD;
float MC_Q3_ARM_COMBAT;
float MC_Q3_ARM_BODY;

float MC_Q3_HSMALL;
float MC_Q3_HEALTH;
float MC_Q3_HLARGE;
float MC_Q3_MEGA;

float MC_Q3_ASHELLS;
float MC_Q3_ABULLETS;
float MC_Q3_AROCKETS;
float MC_Q3_AGRENADES;
float MC_Q3_ACELLS;
float MC_Q3_ASLUGS;
float MC_Q3_ALIGNTNING;
float MC_Q3_ABFG;

//float MC_Q3_HOLDMEDKIT; // moved to defs for other code
//float MC_Q3_HOLDTELE;

float MC_Q3_BARREL;

float MC_Q3;

float MC_Q3_RNDITM; // # of total items

/// chaos

float MC_REGGUN;
float MC_TALLBALL;
float MC_DEEPSLEEP;
float MC_QUANTUM;

float MC_C_FLAMER;
float MC_C_AGAS;
float MC_C_AGAS_LG;

float MC_TOT; // total mcodes

// fn(mcode_load) - set map codes dynamically so we dont have the long list anymore

void() mcode_load =
{
	local float f;

	f = 99; // starts at 100 for string array

/// quake
	
	MC_AXE = f = (f + 1);
	MC_SHOTGUN = f = (f + 1);
	MC_SUPER_SHOTGUN = f = (f + 1);	//	-	101	to	get	item	override	menu	#
	MC_NAILGUN = f = (f + 1);
	MC_SUPER_NAILGUN = f = (f + 1);
	MC_GRENADEL = f = (f + 1);
	MC_ROCKETL = f = (f + 1);
	MC_THUNDER = f = (f + 1);

//	108	is	special	-	xlates	to	pkitems	on	admin	item	override	menu

//	special ids
	MC_QUAD = f = (f + 1);
	MC_PENT = f = (f + 1);
	MC_RING = f = (f + 1);
	MC_SUIT = f = (f + 1);

//	armor ids
	MC_ARMOR1 = f = (f + 1);
	MC_ARMOR2 = f = (f + 1);
	MC_ARMOR3 = f = (f + 1);

//	health ids	-	translate
	MC_HEALTHROT = f = (f + 1);
	MC_HEALTH = f = (f + 1);
	MC_HEALTHMEGA = f = (f + 1);

//	key ids
	MC_KEY1 = f = (f + 1);
	MC_KEY2 = f = (f + 1);

//	ammo ids
	MC_ASHELLS = f = (f + 1);
	MC_ASHELLS_LG = f = (f + 1);
	MC_ANAILS = f = (f + 1);
	MC_ANAILS_LG = f = (f + 1);
	MC_AROCKETS = f = (f + 1);
	MC_AROCKETS_LG = f = (f + 1);
	MC_ACELLS = f = (f + 1);
	MC_ACELLS_LG = f = (f + 1);

//	boom!
	MC_EXPLOD1 = f = (f + 1);
	MC_EXPLOD2 = f = (f + 1);

	MC_NR_RNDITM = f - MC_AXE;		//			no	runes

// sigil id - flags
	MC_SIGIL1 = f = (f + 1);
	MC_SIGIL2 = f = (f + 1);
	MC_SIGIL4 = f = (f + 1);
	MC_SIGIL =
	MC_SIGIL8 = f = (f + 1);

	MC_Q1 = (f + 1);

	MC_RNDITM = f - MC_AXE;		//	#	of	q1	items	-	have	to	change	as	items	changes

	MC_BACKPACK = f = (f + 1);

///	painkeep
//	pk	wep	ids
//	MC_EXPSHOTGUN = f = (f + 1); // no map loadable exploding shotgun - and if there is we may not want the code here anyway, would be a chaos code and not a pk item
	MC_PULSE_NAILGUN = f = (f + 1);
	MC_CHTHUNDR = f = (f + 1);
	MC_GRAP = f = (f + 1);
	MC_AIRGUN = f = (f + 1);

//	device	ids	-	carryable	stuff?	(doesnt	use	ammo	like	a	range	wep)
//	MC_CARRYABLE = f = (f + 1);
//	pk	weps;
	MC_BEARTRAP = f = (f + 1);
	MC_GRAVITY = f = (f + 1);
	MC_SENTRY = f = (f + 1);
	MC_CANOBEANS = f = (f + 1);
	MC_AEXPLSH = f = (f + 1);

// IDEA: change (what ??) when there is a map loadable exploding shot gun? or not...
	MC_PK_RNDITM = f - MC_PULSE_NAILGUN;		//	#	of	base	pk	items

//	pk	plus
	MC_TOMB = f = (f + 1);
	MC_EGO = f = (f + 1);
	MC_PHONE = f = (f + 1);
	MC_MASK = f = (f + 1);

	MC_PKP_RNDITM = f - MC_PULSE_NAILGUN;		//			+	plus	items
	MC_PK	 = (f + 1);

/// ctf

	MC_HOOK = f = (f + 1);

	MC_T_RNDITM = f - MC_AXE;		//	#	of	total	items

/// hipnotic
	MC_HIP_MJOLNIR = f = (f + 1);
	MC_HIP_LASERCAN = f = (f + 1);
	MC_HIP_PROXGUN = f = (f + 1);

	MC_HIP_WETSUIT = f = (f + 1);
	MC_HIP_EMPSH = f = (f + 1);
	MC_HIP_CORNUCOPIA = f = (f + 1);

	MC_HIP = (f + 1);
	MC_HIP_RNDITM = f - MC_HIP_MJOLNIR;

///	doom

//	MC_D_FIST = f = (f + 1); // NOTE: not a map spawn item, can this be removed?
	MC_D_SAW = f = (f + 1);
	MC_D_PISTOL = f = (f + 1);
	MC_D_SHOTGUN = f = (f + 1);
	MC_D_BOOMSTICK = f = (f + 1);
	MC_D_CHAINGUN = f = (f + 1);
	MC_D_ROCKETL = f = (f + 1);
	MC_D_PLASMA = f = (f + 1);
	MC_D_BFG = f = (f + 1);

	MC_D_BERS = f = (f + 1);
	MC_D_INVUL = f = (f + 1);
	MC_D_INVIS = f = (f + 1);
	MC_D_RADSUIT = f = (f + 1);
	MC_D_SOULSPH = f = (f + 1);
	MC_D_MEGASPH = f = (f + 1);

	MC_D_ARM_SPR = f = (f + 1);
	MC_D_ARM_GRN = f = (f + 1);
	MC_D_ARM_BLU = f = (f + 1);

	MC_D_HBOTTLE = f = (f + 1);
	MC_D_STIMPAK = f = (f + 1);
	MC_D_MEDKIT = f = (f + 1);

	MC_D_KEY_RED_SK = f = (f + 1);
	MC_D_KEY_BLU_SK = f = (f + 1);
	MC_D_KEY_YEL_SK = f = (f + 1);
	MC_D_KEY_RED_CR = f = (f + 1);
	MC_D_KEY_BLU_CR = f = (f + 1);
	MC_D_KEY_YEL_CR = f = (f + 1);

	MC_D_ASHELLS = f = (f + 1);
	MC_D_ASHELLS_LG = f = (f + 1);
	MC_D_ABULLETS = f = (f + 1);
	MC_D_ABULLETS_LG = f = (f + 1);
	MC_D_AROCKET = f = (f + 1);
	MC_D_AROCKETS_LG = f = (f + 1);
	MC_D_ACELLS = f = (f + 1);
	MC_D_ACELLS_LG = f = (f + 1);

	MC_D_PACK = f = (f + 1);

	MC_D_BARREL = f = (f + 1);

	MC_DOOM = (f + 1);
	MC_D_RNDITM = f - MC_D_SAW;		//	#	of	total	items

///	wolf	3d

	MC_W_KNIFE = f = (f + 1);
	MC_W_PISTOL = f = (f + 1);
	MC_W_MACHGUN = f = (f + 1);
	MC_W_CHAINGUN = f = (f + 1);
	MC_W_MORTAR = f = (f + 1);
	MC_W_FLAMER = f = (f + 1);

	MC_W_CLIP = f = (f + 1);
	MC_W_GAS = f = (f + 1);
	MC_W_MORTARS = f = (f + 1);
	MC_W_PACK = f = (f + 1);

	MC_W_FACESPHERE = f = (f + 1);
	MC_W_HEALTH = f = (f + 1);
	MC_W_FOOD = f = (f + 1);
	MC_W_DOGFOOD = f = (f + 1);
	MC_W_BLOOD = f = (f + 1);
	MC_W_BLDBNS = f = (f + 1);

	MC_W_KEY_G = f = (f + 1);
	MC_W_KEY_B = f = (f + 1);

	MC_W_BARREL = f = (f + 1);

	MC_WOLF = (f + 1);
	MC_W_RNDITM = f - MC_W_KNIFE;		//	#	of	total	items

/// q2

	MC_Q2_BLASTER = f = (f + 1);
	MC_Q2_SHOTGUN = f = (f + 1);
	MC_Q2_DBLSHOTGUN = f = (f + 1);
	MC_Q2_MACHINEGUN = f = (f + 1);
	MC_Q2_CHAINGUN = f = (f + 1);
	MC_Q2_GRENADEL = f = (f + 1);
	MC_Q2_ROCKETL = f = (f + 1);
	MC_Q2_HYPBLASTER = f = (f + 1);
	MC_Q2_RAILGUN = f = (f + 1);
	MC_Q2_BFG = f = (f + 1);
	MC_Q2_GRAPPLE = f = (f + 1);

	MC_Q2_QUAD = f = (f + 1);
	MC_Q2_INVUL = f = (f + 1);
	MC_Q2_ENVIRO = f = (f + 1);
	MC_Q2_SILENCE = f = (f + 1);

	MC_Q2_ARM_SHARD = f = (f + 1);
	MC_Q2_ARM_JAK = f = (f + 1);
	MC_Q2_ARM_COMBAT = f = (f + 1);
	MC_Q2_ARM_BODY = f = (f + 1);
	MC_Q2_ARM_PSHIELD = f = (f + 1);
	MC_Q2_ARM_PSCREEN = f = (f + 1);

	MC_Q2_STIMPAK = f = (f + 1);
	MC_Q2_FIRSTAID = f = (f + 1);
	MC_Q2_MEDKIT = f = (f + 1);
	MC_Q2_MEGA = f = (f + 1);

	MC_Q2_KEY_RED = f = (f + 1);
	MC_Q2_KEY_BLU = f = (f + 1);
	MC_Q2_KEY_CHEAD = f = (f + 1);
	MC_Q2_KEY_ATARGET = f = (f + 1);
	MC_Q2_KEY_CD = f = (f + 1);
	MC_Q2_KEY_SPINNER = f = (f + 1);
	MC_Q2_KEY_PASS = f = (f + 1);
	MC_Q2_KEY_POWER = f = (f + 1);
	MC_Q2_KEY_PYRAMID = f = (f + 1);

	MC_Q2_ASHELLS = f = (f + 1);
	MC_Q2_ABULLETS = f = (f + 1);
	MC_Q2_AROCKETS = f = (f + 1);
	MC_Q2_AGRENADES = f = (f + 1);
	MC_Q2_ACELLS = f = (f + 1);
	MC_Q2_ASLUGS = f = (f + 1);

	MC_Q2_PACK = f = (f + 1);
	MC_Q2_ADRENALINE = f = (f + 1);
	MC_Q2_BANDOLIER = f = (f + 1);
	MC_Q2_BREATHER = f = (f + 1);

	MC_Q2_BARREL = f = (f + 1);

	MC_Q2 = (f + 1);
	MC_Q2_RNDITM = f - MC_Q2_BLASTER; // # of total items

/// q3

	MC_Q3_GAUNTLET = f = (f + 1);
	MC_Q3_GRAPPLE = f = (f + 1);
	MC_Q3_MACHINEGUN = f = (f + 1);
	MC_Q3_SHOTGUN = f = (f + 1);
	MC_Q3_GRENADEL = f = (f + 1);
	MC_Q3_ROCKETL = f = (f + 1);
	MC_Q3_PLASMA = f = (f + 1);
	MC_Q3_LIGHTNING = f = (f + 1);
	MC_Q3_RAILGUN = f = (f + 1);
	MC_Q3_BFG = f = (f + 1);

	MC_Q3_QUAD = f = (f + 1);
	MC_Q3_REGEN = f = (f + 1);
	MC_Q3_ENVIRO = f = (f + 1);
	MC_Q3_INVIS = f = (f + 1);
	MC_Q3_HASTE = f = (f + 1);
	MC_Q3_FLIGHT = f = (f + 1);

	MC_Q3_ARM_SHARD = f = (f + 1);
	MC_Q3_ARM_COMBAT = f = (f + 1);
	MC_Q3_ARM_BODY = f = (f + 1);

	MC_Q3_HSMALL = f = (f + 1);
	MC_Q3_HEALTH = f = (f + 1);
	MC_Q3_HLARGE = f = (f + 1);
	MC_Q3_MEGA = f = (f + 1);

	MC_Q3_ASHELLS = f = (f + 1);
	MC_Q3_ABULLETS = f = (f + 1);
	MC_Q3_AROCKETS = f = (f + 1);
	MC_Q3_AGRENADES = f = (f + 1);
	MC_Q3_ACELLS = f = (f + 1);
	MC_Q3_ASLUGS = f = (f + 1);
	MC_Q3_ALIGNTNING = f = (f + 1);
	MC_Q3_ABFG = f = (f + 1);

	MC_Q3_HOLDMEDKIT = f = (f + 1);
	MC_Q3_HOLDTELE = f = (f + 1);

	MC_Q3_BARREL = f = (f + 1);

	MC_Q3 = (f + 1);
	MC_Q3_RNDITM = f - MC_Q3_GAUNTLET; // # of total items

	MC_REGGUN = f = (f + 1);
	MC_TALLBALL = f = (f + 1);
	MC_DEEPSLEEP = f = (f + 1);
	MC_QUANTUM = f = (f + 1);
	MC_C_FLAMER = f = (f + 1);
	MC_C_AGAS = f = (f + 1);
	MC_C_AGAS_LG = (f + 1);

	MC_TOT = f - MC_AXE;		//	total # of total items

// specials we dont want randomizing onto map with rnd across all genres

	MC_SIGIL16 = f = (f + 1);
	MC_SIGIL32 = f = (f + 1);
	MC_SIGIL64 = f = (f + 1);

//	key ids special
	MC_KEY1_0 = f = (f + 1);
	MC_KEY1_1 = f = (f + 1);
	MC_KEY1_2 = f = (f + 1);
	MC_KEY2_0 = f = (f + 1);
	MC_KEY2_1 = f = (f + 1);
	MC_KEY2_2 = f = (f + 1);

// note: out of seq - not randomly generated
	MC_D_NIGHTVS = f = (f + 1);
	MC_D_AUTOMAP = f = (f + 1);

	MC_W_G_CROSS = f = (f + 1);
	MC_W_G_CHALICE = f = (f + 1);
	MC_W_G_CHEST = f = (f + 1);
	MC_W_G_CROWN = f = (f + 1);

	MC_Q2_TECH_RES = f = (f + 1);
	MC_Q2_TECH_DOC = f = (f + 1);
	MC_Q2_TECH_AMP = f = (f + 1);
	MC_Q2_TECH_TM = f = (f + 1);

};


// fn(bit_mcode) - item bit assoc with given mcode

float(float mcv, entity e) bit_mcode =
{
	local float mc;

	mc = mcv;
	if (!mc && e) mc = e.mcode;
	if (!mc) return(0);

/// q1

	if (mc == MC_AXE)														return(IT_AXE);
	if (mc == MC_SHOTGUN)												return(IT_SHOTGUN);
	if (mc == MC_SUPER_SHOTGUN)										return(IT_SUPER_SHOTGUN);
	if (mc == MC_NAILGUN)												return(IT_NAILGUN);
	if (mc == MC_SUPER_NAILGUN)										return(IT_SUPER_NAILGUN);
	if (mc == MC_GRENADEL)												return(IT_GRENADE_LAUNCHER);
	if (mc == MC_ROCKETL)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_THUNDER)												return(IT_LIGHTNING);

	if (mc == MC_PENT)													return(IT_INVULNERABILITY);
	if (mc == MC_SUIT)													return(IT_SUIT);
	if (mc == MC_RING)													return(IT_INVISIBILITY);
	if (mc == MC_QUAD)													return(IT_QUAD);

	if (mc == MC_ARMOR1)													return(IT_ARMOR1);
	if (mc == MC_ARMOR2)													return(IT_ARMOR2);
	if (mc == MC_ARMOR3)													return(IT_ARMOR3);

	if (mc == MC_HEALTHROT)												return(0);
	if (mc == MC_HEALTH)													return(0);
	if (mc == MC_HEALTHMEGA)											return(IT_SUPERHEALTH);

	if (mc == MC_KEY1)													return(IT_KEY1);
	if (mc == MC_KEY2)													return(IT_KEY2);
	if (mc == MC_SIGIL1)													return(R_EARTH);
	if (mc == MC_SIGIL2)													return(R_BLACK);
	if (mc == MC_SIGIL4)													return(R_HELL);
	if (mc == MC_SIGIL8)													return(R_ELDER);
	
	if (mc == MC_SIGIL16)												return(R_AMMO);
	if (mc == MC_SIGIL32)												return(R_FLY);
	if (mc == MC_SIGIL64)												return(R_VAMPIRE);

	if (mc == MC_ASHELLS)												return(IT_SHELLS);
	if (mc == MC_ANAILS)													return(IT_NAILS);
	if (mc == MC_AROCKETS)												return(IT_ROCKETS);
	if (mc == MC_ACELLS)													return(IT_CELLS);

	if (mc == MC_ASHELLS_LG)											return(IT_SHELLS);
	if (mc == MC_ANAILS_LG)												return(IT_NAILS);
	if (mc == MC_AROCKETS_LG)											return(IT_ROCKETS);
	if (mc == MC_ACELLS_LG)												return(IT_CELLS);


/// pk
	
// pk item subs by special bits
	if (mc == MC_GRAVITY)												return(PK_IT_GRAVITYWELL);
	if (mc == MC_SENTRY)													return(PK_IT_TURRET);
	if (mc == MC_BEARTRAP)												return(PK_IT_BEARTRAP);
	if (mc == MC_AEXPLSH)												return(0);
	if (mc == MC_CHTHUNDR)												return(PK_IT_CLIGHT);
	if (mc == MC_PULSE_NAILGUN)										return(IT_NAILGUN);
	if (mc == MC_GRAP)													return(PK_IT_GRAPGUN);
	if (mc == MC_AIRGUN)													return(PK_IT_AIRGUN);
	if (mc == MC_CANOBEANS)												return(PK_IT_CANPAB);
	if (mc == MC_EGO)														return(PKPLUS_IT_EGO);
	if (mc == MC_TOMB)													return(PKPLUS_IT_TOMB);
	if (mc == MC_MASK)													return(PKPLUS_IT_ACTOR);
	if (mc == MC_PHONE)													return(PKPLUS_IT_PHONE);

/// ctf

	if (mc == MC_HOOK)													return(PK_IT_GRAPGUN);

/// hipnotic

	if (mc == MC_HIP_MJOLNIR)											return(IT_MJOLNIR);
	if (mc == MC_HIP_LASERCAN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_HIP_PROXGUN)											return(IT_GRENADE_LAUNCHER);

	if (mc == MC_HIP_WETSUIT)											return(0);
	if (mc == MC_HIP_EMPSH)												return(0);
	if (mc == MC_HIP_CORNUCOPIA)										return(0);

/// doom

	if (mc == MC_D_SHOTGUN)												return(IT_SHOTGUN);
	if (mc == MC_D_BOOMSTICK)											return(IT_SUPER_SHOTGUN);
	if (mc == MC_D_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_D_ROCKETL)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_D_PLASMA)												return(IT_LIGHTNING);
	if (mc == MC_D_BFG)													return(IT_EXTRA_WEAPON);
	if (mc == MC_D_SAW)													return(IT_NAILGUN);
	if (mc == MC_D_PISTOL)												return(IT_AXE);

	if (mc == MC_D_BERS)													return(IT_QUAD);
	if (mc == MC_D_INVUL)												return(IT_INVULNERABILITY);
	if (mc == MC_D_INVIS)												return(IT_INVISIBILITY);
	if (mc == MC_D_RADSUIT)												return(IT_SUIT);

	if (mc == MC_D_ARM_GRN)												return(IT_ARMOR2);
	if (mc == MC_D_ARM_BLU)												return(IT_ARMOR3);

	if (mc == MC_D_SOULSPH)												return(IT_SUPERHEALTH);

	if (mc == MC_D_KEY_RED_SK)											return(X_D_KEY_SKRED);
	if (mc == MC_D_KEY_BLU_SK)											return(X_D_KEY_SKBLUE);
	if (mc == MC_D_KEY_YEL_SK)											return(X_D_KEY_SKYEL);
	if (mc == MC_D_KEY_RED_CR)											return(X_D_KEY_CRED);
	if (mc == MC_D_KEY_BLU_CR)											return(X_D_KEY_CBLUE);
	if (mc == MC_D_KEY_YEL_CR)											return(X_D_KEY_CYEL);

	if (mc == MC_D_ASHELLS)												return(IT_SHELLS);
	if (mc == MC_D_ASHELLS_LG)											return(IT_SHELLS);
//	if (mc == MC_D_ABULLETS)											return(IT_BULLETS);
//	if (mc == MC_D_ABULLETS_LG)										return(IT_BULLETS);
	if (mc == MC_D_AROCKET)												return(IT_ROCKETS);
	if (mc == MC_D_AROCKETS_LG)										return(IT_ROCKETS);
	if (mc == MC_D_ACELLS)												return(IT_CELLS);
	if (mc == MC_D_ACELLS_LG)											return(IT_CELLS);
	if (mc == MC_D_NIGHTVS)												return(X_D_VIS);
	if (mc == MC_D_AUTOMAP)												return(X_D_MAP);

/// wolf

	if (mc == MC_W_KNIFE)												return(IT_AXE);
	if (mc == MC_W_PISTOL)												return(IT_SHOTGUN);
	if (mc == MC_W_MACHGUN)												return(IT_NAILGUN);
	if (mc == MC_W_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_W_MORTAR)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_W_FLAMER)												return(IT_GRENADE_LAUNCHER);
//	if (mc == MC_W_CLIP)													return(IT_BULLETS);
//	if (mc == MC_W_GAS)													return(IT_GAS);
	if (mc == MC_W_MORTARS)												return(IT_ROCKETS);

	if (mc == MC_W_HEALTH)												return(0);
	if (mc == MC_W_FOOD)													return(0);
	if (mc == MC_W_DOGFOOD)												return(0);
	if (mc == MC_W_BLOOD)												return(0);
	if (mc == MC_W_BLDBNS)												return(0);

	if (mc == MC_W_FACESPHERE)											return(IT_SUPERHEALTH);

	if (mc == MC_W_KEY_G)												return(IT_KEY1);
	if (mc == MC_W_KEY_B)												return(IT_KEY2);
	if (mc == MC_W_BARREL)												return(0);

	if (mc == MC_W_G_CROSS)												return(0);
	if (mc == MC_W_G_CHALICE)											return(0);
	if (mc == MC_W_G_CHEST)												return(0);
	if (mc == MC_W_G_CROWN)												return(0);

/// q2

	if (mc == MC_Q2_BLASTER)											return(IT_AXE);
	if (mc == MC_Q2_SHOTGUN)											return(IT_SHOTGUN);
	if (mc == MC_Q2_DBLSHOTGUN)										return(IT_SUPER_SHOTGUN);
	if (mc == MC_Q2_MACHINEGUN)										return(IT_NAILGUN);
	if (mc == MC_Q2_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_Q2_GRENADEL)											return(IT_GRENADE_LAUNCHER);
	if (mc == MC_Q2_ROCKETL)											return(IT_ROCKET_LAUNCHER);
	if (mc == MC_Q2_HYPBLASTER)										return(IT_LIGHTNING);
	if (mc == MC_Q2_RAILGUN)											return(IT_GRENADE_LAUNCHER);
	if (mc == MC_Q2_BFG)													return(IT_EXTRA_WEAPON);
	if (mc == MC_Q2_GRAPPLE)											return(PK_IT_GRAPGUN);

	if (mc == MC_Q2_QUAD)												return(IT_QUAD);
	if (mc == MC_Q2_INVUL)												return(IT_INVULNERABILITY);
	if (mc == MC_Q2_ENVIRO)												return(IT_SUIT);
	if (mc == MC_Q2_SILENCE)											return(0);

	if (mc == MC_Q2_ARM_SHARD)											return(0);
	if (mc == MC_Q2_ARM_JAK)											return(IT_ARMOR1);
	if (mc == MC_Q2_ARM_COMBAT)										return(IT_ARMOR2);
	if (mc == MC_Q2_ARM_BODY)											return(IT_ARMOR3);
	if (mc == MC_Q2_ARM_PSHIELD)										return(0);
	if (mc == MC_Q2_ARM_PSCREEN)										return(0);

	if (mc == MC_Q2_STIMPAK)											return(0);
	if (mc == MC_Q2_FIRSTAID)											return(0);
	if (mc == MC_Q2_MEDKIT)												return(0);
	if (mc == MC_Q2_MEGA)												return(IT_SUPERHEALTH);

	if (mc == MC_Q2_KEY_RED)											return(X_Q2_KEY_RED);
	if (mc == MC_Q2_KEY_BLU)											return(X_Q2_KEY_BLUE);
	if (mc == MC_Q2_KEY_CHEAD)											return(X_Q2_KEY_CHEAD);
	if (mc == MC_Q2_KEY_ATARGET)										return(X_Q2_KEY_AIRSTRK);
	if (mc == MC_Q2_KEY_CD)												return(X_Q2_KEY_DATACD);
	if (mc == MC_Q2_KEY_SPINNER)										return(X_Q2_KEY_CDSPIN);
	if (mc == MC_Q2_KEY_PASS)											return(X_Q2_KEY_PASS);
	if (mc == MC_Q2_KEY_POWER)											return(X_Q2_KEY_CUBE);
	if (mc == MC_Q2_KEY_PYRAMID)										return(X_Q2_KEY_PYRAMID);

	if (mc == MC_Q2_ASHELLS)											return(IT_SHELLS);
	if (mc == MC_Q2_ABULLETS)											return(0);
	if (mc == MC_Q2_AROCKETS)											return(IT_ROCKETS);
	if (mc == MC_Q2_AGRENADES)											return(IT_ROCKETS);
	if (mc == MC_Q2_ACELLS)												return(IT_CELLS);
	if (mc == MC_Q2_ASLUGS)												return(0);

	if (mc == MC_Q2_PACK)												return(0);
	if (mc == MC_Q2_ADRENALINE)										return(0);
	if (mc == MC_Q2_BANDOLIER)											return(0);
	if (mc == MC_Q2_BREATHER)											return(0);

	if (mc == MC_Q2_BARREL)												return(0);

/// q3

	if (mc == MC_Q3_GAUNTLET)											return(IT_AXE);
	if (mc == MC_Q3_GRAPPLE)											return(PK_IT_GRAPGUN);
	if (mc == MC_Q3_MACHINEGUN)										return(IT_NAILGUN);
	if (mc == MC_Q3_SHOTGUN)											return(IT_SUPER_SHOTGUN);
	if (mc == MC_Q3_GRENADEL)											return(IT_GRENADE_LAUNCHER);
	if (mc == MC_Q3_ROCKETL)											return(IT_ROCKET_LAUNCHER);
	if (mc == MC_Q3_PLASMA)												return(IT_SUPER_NAILGUN);
	if (mc == MC_Q3_LIGHTNING)											return(IT_LIGHTNING);
	if (mc == MC_Q3_RAILGUN)											return(IT_SHOTGUN);
	if (mc == MC_Q3_BFG)													return(IT_EXTRA_WEAPON);

	if (mc == MC_Q3_QUAD)												return(IT_QUAD);
	if (mc == MC_Q3_REGEN)												return(0);
	if (mc == MC_Q3_ENVIRO)												return(IT_SUIT);
	if (mc == MC_Q3_INVIS)												return(IT_INVISIBILITY);
	if (mc == MC_Q3_HASTE)												return(0);
	if (mc == MC_Q3_FLIGHT)												return(0);

	if (mc == MC_Q3_ARM_SHARD)											return(0);
	if (mc == MC_Q3_ARM_COMBAT)										return(IT_ARMOR2);
	if (mc == MC_Q3_ARM_BODY)											return(IT_ARMOR3);

	if (mc == MC_Q3_HSMALL)												return(0);
	if (mc == MC_Q3_HEALTH)												return(0);
	if (mc == MC_Q3_HLARGE)												return(0);
	if (mc == MC_Q3_MEGA)												return(IT_SUPERHEALTH);

	if (mc == MC_Q3_ASHELLS)											return(IT_SHELLS);
	if (mc == MC_Q3_ABULLETS)											return(0);
	if (mc == MC_Q3_AROCKETS)											return(IT_ROCKETS);
	if (mc == MC_Q3_AGRENADES)											return(IT_ROCKETS);
	if (mc == MC_Q3_ACELLS)												return(IT_CELLS);
	if (mc == MC_Q3_ASLUGS)												return(0);
	if (mc == MC_Q3_ALIGNTNING)										return(IT_CELLS);
	if (mc == MC_Q3_ABFG)												return(IT_CELLS);

	if (mc == MC_Q3_HOLDMEDKIT)										return(PK_IT_CANPAB);
	if (mc == MC_Q3_HOLDTELE)											return(PKPLUS_IT_PHONE);

/// chaos
	
	if (mc == MC_REGGUN)													return(IT_SUPER_SHOTGUN);
	if (mc == MC_TALLBALL)													return(IT_AXE);
	if (mc == MC_DEEPSLEEP)												return(IT_AXE);
	if (mc == MC_QUANTUM)												return(IT_LIGHTNING);
	if (mc == MC_C_FLAMER)												return(IT_GRENADE_LAUNCHER);
	if (mc == MC_C_AGAS)													return(0);
	if (mc == MC_C_AGAS_LG)												return(0);

	return(0);
};

// fn(pk_mcode) - map code for items

// e - ent being tested
// sc - classname to test
// returns map code value

// ambiguous items on native maps must set the correct classname for this fn

float(string sc, entity e) pk_mcode =
{
//	local float mc;
//	local string tsc;
//	tsc = sc;

	if (sc == null_string && e) sc = e.classname;

	if (sc == null_string)
	{
#ifdef warning
		if (WARNING & 2)
			bprint("\b *** pk_mcode - entry with no classname\n");
#endifdef
		return(0); 
	}

	if (e)
	if (e.event == "dynamic_item")									return(0);

/// q1
	if (e) // qualify ent
	{
		if ((sc == "item_shells") && (e.spawnflags & 1))			return(MC_ASHELLS_LG);
		if ((sc == "item_spikes") && (e.spawnflags & 1))			return(MC_ANAILS_LG);
		if ((sc == "item_rockets") && (e.spawnflags & 1))			return(MC_AROCKETS_LG);
		if ((sc == "item_cells") && (e.spawnflags & 1))			return(MC_ACELLS_LG);
		if ((sc == "item_health") && (e.spawnflags & 1))			return(MC_HEALTHROT);
		if ((sc == "item_health") && (e.spawnflags & 2))			return(MC_HEALTHMEGA);

		if ((sc == "item_sigil") && (e.spawnflags & R_EARTH))	return(MC_SIGIL1);
		if ((sc == "item_sigil") && (e.spawnflags & R_BLACK))	return(MC_SIGIL2);
		if ((sc == "item_sigil") && (e.spawnflags & R_HELL))		return(MC_SIGIL4);
		if ((sc == "item_sigil") && (e.spawnflags & R_ELDER))	return(MC_SIGIL8);

		if ((sc == "item_sigil") && (e.spawnflags & R_AMMO))		return(MC_SIGIL16);
		if ((sc == "item_sigil") && (e.spawnflags & R_FLY))		return(MC_SIGIL32);
		if ((sc == "item_sigil") && (e.spawnflags & R_VAMPIRE))		return(MC_SIGIL64);

		if (sc == "item_keyX")
		{
			if (!e.cnt)															return(MC_KEY1_0);
			if (e.cnt == 10)													return(MC_KEY1_0);
			if (e.cnt == 11)													return(MC_KEY1_1);
			if (e.cnt == 12)													return(MC_KEY1_2);
			if (e.cnt == 20)													return(MC_KEY2_0);
			if (e.cnt == 21)													return(MC_KEY2_1);
			if (e.cnt == 22)													return(MC_KEY2_2);
		}
		if (sc == "w_key")
		{
			if (e.spawnflags & 1)											return(MC_W_KEY_G);
			if (e.spawnflags & 2)											return(MC_W_KEY_B);
		}
	}

	if (sc == "weapon_axe")											return(MC_AXE);
	if (sc == "weapon_shotgun")										return(MC_SHOTGUN);
	if (sc == "weapon_supershotgun")								return(MC_SUPER_SHOTGUN);
	if (sc == "weapon_nailgun")										return(MC_NAILGUN);
	if (sc == "weapon_nailgun_q1")									return(MC_NAILGUN);
	if (sc == "weapon_supernailgun")								return(MC_SUPER_NAILGUN);
	if (sc == "weapon_grenadelauncher")							return(MC_GRENADEL);
	if (sc == "weapon_rocketlauncher")								return(MC_ROCKETL);
	if (sc == "weapon_lightning")									return(MC_THUNDER);
// ammo
	if (sc == "item_shells")											return(MC_ASHELLS);
	if (sc == "item_spikes")											return(MC_ANAILS);
	if (sc == "item_rockets")											return(MC_AROCKETS);
	if (sc == "item_cells")											return(MC_ACELLS);

	if (sc == "item_artifact_invulnerability")					return(MC_PENT);
	if (sc == "item_artifact_super_damage")						return(MC_QUAD);
	if (sc == "item_artifact_invisibility")						return(MC_RING);
	if (sc == "item_artifact_envirosuit")							return(MC_SUIT);

	if (sc == "item_health")											return(MC_HEALTH);
	if (sc == "item_armor1")											return(MC_ARMOR1);
	if (sc == "item_armor2")											return(MC_ARMOR2);
	if (sc == "item_armorInv")										return(MC_ARMOR3);
	if (sc == "item_key1")												return(MC_KEY1);
	if (sc == "item_key2")												return(MC_KEY2);
	if (sc == "item_sigil")											return(MC_SIGIL);
	if (sc == "misc_explobox")										return(MC_EXPLOD1);
	if (sc == "misc_explobox2")										return(MC_EXPLOD2);

// keys special
	if (sc == "item_key1_0")											return(MC_KEY1_0);
	if (sc == "item_key1_1")											return(MC_KEY1_1);
	if (sc == "item_key1_2")											return(MC_KEY1_2);
	if (sc == "item_key2_0")											return(MC_KEY2_0);
	if (sc == "item_key2_1")											return(MC_KEY2_1);
	if (sc == "item_key2_2")											return(MC_KEY2_2);

	if (sc == "fn_backpack")											return(MC_BACKPACK);

/// pk
	if (sc == "weapon_airfist")										return(MC_AIRGUN);
	if (sc == "weapon_chainlg")										return(MC_CHTHUNDR);
	if (sc == "weapon_grapgun")										return(MC_GRAP);
	if (sc == "weapon_pulsenail")									return(MC_PULSE_NAILGUN);
	if (sc == "item_painkeep_gwell")								return(MC_GRAVITY);
	if (sc == "item_painkeep_turret")								return(MC_SENTRY);
	if (sc == "item_painkeep_beartrap")							return(MC_BEARTRAP);
	if (sc == "item_painkeep_expshells")							return(MC_AEXPLSH);
	if (sc == "item_painkeep_can")									return(MC_CANOBEANS);

	if (sc == "item_pkplus_ego")										return(MC_EGO);
	if (sc == "item_pkplus_tomb")									return(MC_TOMB);
	if (sc == "item_pkplus_actor")									return(MC_MASK);
	if (sc == "item_pkplus_phone")									return(MC_PHONE);

/// ctf

	if (sc == "weapon_hook")											return(MC_HOOK);

/// hipnotic
	
	if (sc == "weapon_mjolnir")										return(MC_HIP_MJOLNIR);
	if (sc == "weapon_laser_gun")									return(MC_HIP_LASERCAN);
	if (sc == "weapon_proximity_gun")								return(MC_HIP_PROXGUN);

	if (sc == "item_artifact_wetsuit")								return(MC_HIP_WETSUIT);
	if (sc == "item_artifact_empathy_shields")					return(MC_HIP_EMPSH);
	if (sc == "item_hornofconjuring")								return(MC_HIP_CORNUCOPIA);

/// doom
	if (sc == "d_weapon_shotgun")									return(MC_D_SHOTGUN);
	if (sc == "d_weapon_supershotgun")								return(MC_D_BOOMSTICK);
	if (sc == "d_weapon_chaingun")									return(MC_D_CHAINGUN);
	if (sc == "d_weapon_rocketlauncher")							return(MC_D_ROCKETL);
	if (sc == "d_weapon_plasma")										return(MC_D_PLASMA);
	if (sc == "d_weapon_bfg")											return(MC_D_BFG);
	if (sc == "d_weapon_saw")											return(MC_D_SAW);
	if (sc == "d_weapon_pistol")										return(MC_D_PISTOL);

	if (sc == "d_art_berserker")										return(MC_D_BERS);
	if (sc == "d_art_invulnerable")									return(MC_D_INVUL);
	if (sc == "d_art_invisible")										return(MC_D_INVIS);
	if (sc == "d_art_radsuit")										return(MC_D_RADSUIT);
	if (sc == "d_art_soulsphere")									return(MC_D_SOULSPH);
	if (sc == "d_art_megasphere")									return(MC_D_MEGASPH);

	if (sc == "d_item_spiritarmor")									return(MC_D_ARM_SPR);
	if (sc == "d_item_armorgreen")									return(MC_D_ARM_GRN);
	if (sc == "d_item_armorblue")									return(MC_D_ARM_BLU);

	if (sc == "d_item_healthbottle")								return(MC_D_HBOTTLE);
	if (sc == "d_item_healthstimpak")								return(MC_D_STIMPAK);
	if (sc == "d_item_healthmedkit")								return(MC_D_MEDKIT);

	if (sc == "d_key_redskull")										return(MC_D_KEY_RED_SK);
	if (sc == "d_key_blueskull")										return(MC_D_KEY_BLU_SK);
	if (sc == "d_key_yellowskull")									return(MC_D_KEY_YEL_SK);
	if (sc == "d_key_bluecard")										return(MC_D_KEY_BLU_CR);
	if (sc == "d_key_redcard")										return(MC_D_KEY_RED_CR);
	if (sc == "d_key_yellowcard")									return(MC_D_KEY_YEL_CR);

	if (sc == "d_ammo_4shell")										return(MC_D_ASHELLS);
	if (sc == "d_ammo_shellbox")										return(MC_D_ASHELLS_LG);
	if (sc == "d_ammo_clip")											return(MC_D_ABULLETS);
	if (sc == "d_ammo_ammobox")										return(MC_D_ABULLETS_LG);
	if (sc == "d_ammo_1rocket")										return(MC_D_AROCKET);
	if (sc == "d_ammo_rockbox")										return(MC_D_AROCKETS_LG);
	if (sc == "d_ammo_cellpack")										return(MC_D_ACELLS);
	if (sc == "d_ammo_cellbox")										return(MC_D_ACELLS_LG);

	if (sc == "d_item_pack")											return(MC_D_PACK);
	if (sc == "d_item_nightvis")										return(MC_D_NIGHTVS);
	if (sc == "d_item_automap")										return(MC_D_AUTOMAP);

	if (sc == "d_barrel")												return(MC_D_BARREL);

/// wolf
	if (sc == "w_weapon_knife")										return(MC_W_KNIFE);
	if (sc == "w_weapon_pistol")										return(MC_W_PISTOL);
	if (sc == "w_weapon_machinegun")								return(MC_W_MACHGUN);
	if (sc == "w_weapon_chaingun")									return(MC_W_CHAINGUN);
	if (sc == "w_weapon_mortar")										return(MC_W_MORTAR);
	if (sc == "w_weapon_flamer")										return(MC_W_FLAMER);

	if (sc == "w_ammo_clip")											return(MC_W_CLIP);
	if (sc == "w_ammo_gas")											return(MC_W_GAS);
	if (sc == "w_ammo_rock")											return(MC_W_MORTARS);
	if (sc == "w_item_pack")											return(MC_W_PACK);

	if (sc == "w_heal_medkit")										return(MC_W_HEALTH);
	if (sc == "w_heal_food")											return(MC_W_FOOD);
	if (sc == "w_heal_dogfood")										return(MC_W_DOGFOOD);
	if (sc == "w_heal_blood")											return(MC_W_BLOOD);
	if (sc == "w_heal_bldbns")										return(MC_W_BLDBNS);
	if (sc == "w_art_facesphere")									return(MC_W_FACESPHERE);

	if (sc == "w_key_g")												return(MC_W_KEY_G);
	if (sc == "w_key_b")												return(MC_W_KEY_B);
	if (sc == "w_item_cross")											return(MC_W_G_CROSS);
	if (sc == "w_barrel")												return(MC_W_BARREL);

	if (sc == "w_item_cross")											return(MC_W_G_CROSS);
	if (sc == "w_item_chalice")										return(MC_W_G_CHALICE);
	if (sc == "w_item_chest")											return(MC_W_G_CHEST);
	if (sc == "w_item_crown")											return(MC_W_G_CROWN);

/// q2

	if (sc == "q2_weapon_blaster")									return(MC_Q2_BLASTER);
	if (sc == "q2_weapon_shotgun")									return(MC_Q2_SHOTGUN);
	if (sc == "q2_weapon_supershotgun")							return(MC_Q2_DBLSHOTGUN);
	if (sc == "q2_weapon_machinegun")								return(MC_Q2_MACHINEGUN);
	if (sc == "weapon_chaingun")										return(MC_Q2_CHAINGUN);
	if (sc == "q2_weapon_grenadelauncher")						return(MC_Q2_GRENADEL);
	if (sc == "q2_weapon_rocketlauncher")							return(MC_Q2_ROCKETL);
	if (sc == "weapon_hyperblaster")								return(MC_Q2_HYPBLASTER);
	if (sc == "q2_weapon_railgun")									return(MC_Q2_RAILGUN);
	if (sc == "q2_weapon_bfg")										return(MC_Q2_BFG);
	if (sc == "q2_weapon_grapple")									return(MC_Q2_GRAPPLE);

	if (sc == "q2_item_quad")											return(MC_Q2_QUAD);
	if (sc == "item_invulnerability")								return(MC_Q2_INVUL);
	if (sc == "q2_item_enviro")										return(MC_Q2_ENVIRO);
	if (sc == "item_silencer")										return(MC_Q2_SILENCE);

	if (sc == "q2_item_armor_shard")								return(MC_Q2_ARM_SHARD);
	if (sc == "item_armor_jacket")									return(MC_Q2_ARM_JAK);
	if (sc == "q2_item_armor_combat")								return(MC_Q2_ARM_COMBAT);
	if (sc == "q2_item_armor_body")									return(MC_Q2_ARM_BODY);
	if (sc == "item_power_shield")									return(MC_Q2_ARM_PSHIELD);
	if (sc == "item_power_screen")									return(MC_Q2_ARM_PSCREEN);

	if (sc == "q2_item_health_small")								return(MC_Q2_STIMPAK);
	if (sc == "q2_item_health")										return(MC_Q2_FIRSTAID);
	if (sc == "q2_item_health_large")								return(MC_Q2_MEDKIT);
	if (sc == "q2_item_health_mega")								return(MC_Q2_MEGA);

	if (sc == "key_red_key")											return(MC_Q2_KEY_RED);
	if (sc == "key_blue_key")											return(MC_Q2_KEY_BLU);
	if (sc == "key_commander_head")									return(MC_Q2_KEY_CHEAD);
	if (sc == "key_airstrike_target")								return(MC_Q2_KEY_ATARGET);
	if (sc == "key_data_cd")											return(MC_Q2_KEY_CD);
	if (sc == "key_data_spinner")									return(MC_Q2_KEY_SPINNER);
	if (sc == "key_pass")												return(MC_Q2_KEY_PASS);
	if (sc == "key_power_cube")										return(MC_Q2_KEY_POWER);
	if (sc == "key_pyramid")											return(MC_Q2_KEY_PYRAMID);

	if (sc == "q2_ammo_shells")										return(MC_Q2_ASHELLS);
	if (sc == "q2_ammo_bullets")										return(MC_Q2_ABULLETS);
	if (sc == "q2_ammo_rockets")										return(MC_Q2_AROCKETS);
	if (sc == "q2_ammo_grenades")									return(MC_Q2_AGRENADES);
	if (sc == "q2_ammo_cells")										return(MC_Q2_ACELLS);
	if (sc == "q2_ammo_slugs")										return(MC_Q2_ASLUGS);

	if (sc == "item_pack")												return(MC_Q2_PACK);
	if (sc == "item_adrenaline")										return(MC_Q2_ADRENALINE);
	if (sc == "item_bandolier")										return(MC_Q2_BANDOLIER);
	if (sc == "item_breather")										return(MC_Q2_BREATHER);

	if (sc == "q2_misc_explobox")									return(MC_Q2_BARREL);

	if (sc == "q2_ctf_resist")										return(MC_Q2_TECH_RES);
	if (sc == "q2_ctf_regen")											return(MC_Q2_TECH_DOC);
	if (sc == "q2_ctf_stren")											return(MC_Q2_TECH_AMP);
	if (sc == "q2_ctf_haste")											return(MC_Q2_TECH_TM);

/// q3

	if (sc == "weapon_gauntlet")										return(MC_Q3_GAUNTLET);
	if (sc == "weapon_grapplinghook")								return(MC_Q3_GRAPPLE);
	if (sc == "q3_weapon_machinegun")								return(MC_Q3_MACHINEGUN);
	if (sc == "q3_weapon_shotgun")									return(MC_Q3_SHOTGUN);
	if (sc == "q3_weapon_grenadelauncher")						return(MC_Q3_GRENADEL);
	if (sc == "q3_weapon_rocketlauncher")							return(MC_Q3_ROCKETL);
	if (sc == "weapon_plasmagun")									return(MC_Q3_PLASMA);
	if (sc == "q3_weapon_lightning")								return(MC_Q3_LIGHTNING);
	if (sc == "q3_weapon_railgun")									return(MC_Q3_RAILGUN);
	if (sc == "q3_weapon_bfg")										return(MC_Q3_BFG);

	if (sc == "q3_item_quad")											return(MC_Q3_QUAD);
	if (sc == "item_regen")											return(MC_Q3_REGEN);
	if (sc == "q3_item_enviro")										return(MC_Q3_ENVIRO);
	if (sc == "item_invis")											return(MC_Q3_INVIS);
	if (sc == "item_haste")											return(MC_Q3_HASTE);
	if (sc == "item_flight")											return(MC_Q3_FLIGHT);

	if (sc == "q3_item_armor_shard")								return(MC_Q3_ARM_SHARD);
	if (sc == "q3_item_armor_combat")								return(MC_Q3_ARM_COMBAT);
	if (sc == "q3_item_armor_body")									return(MC_Q3_ARM_BODY);

	if (sc == "q3_item_health_small")								return(MC_Q3_HSMALL);
	if (sc == "q3_item_health")										return(MC_Q3_HEALTH);
	if (sc == "q3_item_health_large")								return(MC_Q3_HLARGE);
	if (sc == "q3_item_health_mega")								return(MC_Q3_MEGA);

	if (sc == "q3_ammo_shells")										return(MC_Q3_ASHELLS);
	if (sc == "q3_ammo_bullets")										return(MC_Q3_ABULLETS);
	if (sc == "q3_ammo_rockets")										return(MC_Q3_AROCKETS);
	if (sc == "q3_ammo_grenades")									return(MC_Q3_AGRENADES);
	if (sc == "q3_ammo_cells")										return(MC_Q3_ACELLS);
	if (sc == "q3_ammo_slugs")										return(MC_Q3_ASLUGS);
	if (sc == "ammo_lightning")										return(MC_Q3_ALIGNTNING);
	if (sc == "ammo_bfg")												return(MC_Q3_ABFG);

	if (sc == "holdable_medkit")										return(MC_Q3_HOLDMEDKIT);
	if (sc == "holdable_teleporter")								return(MC_Q3_HOLDTELE);

	if (sc == "q3_misc_explobox")									return(MC_Q3_BARREL);

/// chaos
	
	if (sc == "c_weapon_reggun")										return(MC_REGGUN);
	if (sc == "c_weapon_tallball")										return(MC_TALLBALL);
	if (sc == "c_weapon_deepsleep")									return(MC_DEEPSLEEP);
	if (sc == "weapon_quantum")										return(MC_QUANTUM);
	if (sc == "weapon_flamer")										return(MC_C_FLAMER);
	if (sc == "ammo_gas")												return(MC_C_AGAS);
	if (sc == "ammo_gas_lg")											return(MC_C_AGAS_LG);


// q3 - translates classname for now
//	else if (sc == null_string)								return(MC_);

#ifdef warning
	if (WARNING & 2)
//	if (sc != "dyn_item") // && mc == 0) // again - test will always be true now, deprecated
	{
		bprint("\b *** item with no map code translation:\n");
		bprint(" -------------->  ");
		bprint(sc);
		bprint("\n");
	}
#endifdef

	return(0);

};


// this is called with self.delay == 104, how does it return a null string ?
//		***     warning: loopcyc - no FL_ITEM set on = _-=* Number Six - searched:  - code: 104
//		]prvm_global server MC_SUPER_NAILGUN
//		MC_SUPER_NAILGUN: 104

// fn(item_by_mcode) - given map code mc, return call string

string (float mc) item_by_mcode =
{
	if (mc == MC_AXE)														return("weapon_axe");
	if (mc == MC_SHOTGUN)												return("weapon_shotgun");
	if (mc == MC_SUPER_SHOTGUN)										return("weapon_supershotgun");
	if (mc == MC_NAILGUN)												return("weapon_nailgun");
	if (mc == MC_SUPER_NAILGUN)										return("weapon_supernailgun");
	if (mc == MC_GRENADEL)												return("weapon_grenadelauncher");
	if (mc == MC_ROCKETL)												return("weapon_rocketlauncher");
	if (mc == MC_THUNDER)												return("weapon_lightning");

	if (mc == MC_PENT)													return("item_artifact_invulnerability");
	if (mc == MC_SUIT)													return("item_artifact_envirosuit");
	if (mc == MC_RING)													return("item_artifact_invisibility");
	if (mc == MC_QUAD)													return("item_artifact_super_damage");

	if (mc == MC_ARMOR1)													return("item_armor1");
	if (mc == MC_ARMOR2)													return("item_armor2");
	if (mc == MC_ARMOR3)													return("item_armorInv");

	if (mc == MC_HEALTHROT)												return("item_health_15");
	if (mc == MC_HEALTH)													return("item_health");
	if (mc == MC_HEALTHMEGA)											return("item_health_mega");

	if (mc == MC_KEY1)													return("item_key1");
	if (mc == MC_KEY2)													return("item_key2");
	if (mc == MC_SIGIL1)													return("item_sigil1");
	if (mc == MC_SIGIL2)													return("item_sigil2");
	if (mc == MC_SIGIL4)													return("item_sigil4");
	if (mc == MC_SIGIL8)													return("item_sigil8");

//	if (mc == MC_SIGIL16)												return("item_sigil16");
//	if (mc == MC_SIGIL32)												return("item_sigil32");
	if (mc == MC_SIGIL64)												return("item_sigil64");

	if (mc == MC_ASHELLS)												return("item_shells");
	if (mc == MC_ANAILS)													return("item_spikes");
	if (mc == MC_AROCKETS)												return("item_rockets");
	if (mc == MC_ACELLS)													return("item_cells");

	if (mc == MC_ASHELLS_LG)											return("item_shells_lg");
	if (mc == MC_ANAILS_LG)												return("item_spikes_lg");
	if (mc == MC_AROCKETS_LG)											return("item_rockets_lg");
	if (mc == MC_ACELLS_LG)												return("item_cells_lg");

	if (mc == MC_EXPLOD1)												return("misc_explobox");
	if (mc == MC_EXPLOD2)												return("misc_explobox2");


// TDO - q1 backpack cls - & in dyn items call()

	if (mc == MC_KEY1_0)													return("item_key1_0");
	if (mc == MC_KEY1_1)													return("item_key1_1");
	if (mc == MC_KEY1_2)													return("item_key1_2");
	if (mc == MC_KEY2_0)													return("item_key2_0");
	if (mc == MC_KEY2_1)													return("item_key2_1");
	if (mc == MC_KEY2_2)													return("item_key2_2");

	if (mc == MC_BACKPACK)												return("fn_backpack");

// pk item subs by special bits
	if (mc == MC_GRAVITY)												return("item_painkeep_gwell");
	if (mc == MC_SENTRY)													return("item_painkeep_turret");
	if (mc == MC_BEARTRAP)												return("item_painkeep_beartrap");
	if (mc == MC_AEXPLSH)												return("item_painkeep_expshells");
	if (mc == MC_CHTHUNDR)												return("weapon_chainlg");
	if (mc == MC_PULSE_NAILGUN)										return("weapon_pulsenail");
	if (mc == MC_GRAP)													return("weapon_grapgun");
	if (mc == MC_AIRGUN)													return("weapon_airfist");
	if (mc == MC_CANOBEANS)												return("item_painkeep_can");

	if (mc == MC_EGO)														return("item_pkplus_ego");
	if (mc == MC_TOMB)													return("item_pkplus_tomb");
	if (mc == MC_MASK)													return("item_pkplus_actor");
	if (mc == MC_PHONE)													return("item_pkplus_phone");

/// ctf

	if (mc == MC_HOOK)													return("weapon_hook");

/// hipnotic
	
	if (mc == MC_HIP_MJOLNIR)											return("weapon_mjolnir");
	if (mc == MC_HIP_LASERCAN)											return("weapon_laser_gun");
	if (mc == MC_HIP_PROXGUN)											return("weapon_proximity_gun");

	if (mc == MC_HIP_WETSUIT)											return("item_artifact_wetsuit");
	if (mc == MC_HIP_EMPSH)												return("item_artifact_empathy_shields");
	if (mc == MC_HIP_CORNUCOPIA)										return("item_hornofconjuring");

/// doom
	if (mc == MC_D_SHOTGUN)												return("d_weapon_shotgun");
	if (mc == MC_D_BOOMSTICK)											return("d_weapon_supershotgun");
	if (mc == MC_D_CHAINGUN)											return("d_weapon_chaingun");
	if (mc == MC_D_ROCKETL)												return("d_weapon_rocketlauncher");
	if (mc == MC_D_PLASMA)												return("d_weapon_plasma");
	if (mc == MC_D_BFG)													return("d_weapon_bfg");
	if (mc == MC_D_SAW)													return("d_weapon_saw");
	if (mc == MC_D_PISTOL)												return("d_weapon_pistol");

	if (mc == MC_D_BERS)													return("d_art_berserker");
	if (mc == MC_D_INVUL)												return("d_art_invulnerable");
	if (mc == MC_D_INVIS)												return("d_art_invisible");
	if (mc == MC_D_RADSUIT)												return("d_art_radsuit");
	if (mc == MC_D_SOULSPH)												return("d_art_soulsphere");
	if (mc == MC_D_MEGASPH)												return("d_art_megasphere");

	if (mc == MC_D_ARM_SPR)												return("d_item_spiritarmor");
	if (mc == MC_D_ARM_GRN)												return("d_item_armorgreen");
	if (mc == MC_D_ARM_BLU)												return("d_item_armorblue");

	if (mc == MC_D_HBOTTLE)												return("d_item_healthbottle");
	if (mc == MC_D_STIMPAK)												return("d_item_healthstimpak");
	if (mc == MC_D_MEDKIT)												return("d_item_healthmedkit");

	if (mc == MC_D_KEY_RED_SK)											return("d_key_redskull");
	if (mc == MC_D_KEY_BLU_SK)											return("d_key_blueskull");
	if (mc == MC_D_KEY_YEL_SK)											return("d_key_yellowskull");
	if (mc == MC_D_KEY_RED_CR)											return("d_key_redcard");
	if (mc == MC_D_KEY_BLU_CR)											return("d_key_bluecard");
	if (mc == MC_D_KEY_YEL_CR)											return("d_key_yellowcard");

	if (mc == MC_D_ASHELLS)												return("d_ammo_4shell");
	if (mc == MC_D_ASHELLS_LG)											return("d_ammo_shellbox");
	if (mc == MC_D_ABULLETS)											return("d_ammo_clip");
	if (mc == MC_D_ABULLETS_LG)										return("d_ammo_ammobox");
	if (mc == MC_D_AROCKET)												return("d_ammo_1rocket");
	if (mc == MC_D_AROCKETS_LG)										return("d_ammo_rockbox");
	if (mc == MC_D_ACELLS)												return("d_ammo_cellpack");
	if (mc == MC_D_ACELLS_LG)											return("d_ammo_cellbox");

	if (mc == MC_D_PACK)													return("d_item_pack");
	if (mc == MC_D_NIGHTVS)												return("d_item_nightvis");
	if (mc == MC_D_AUTOMAP)												return("d_item_automap");

	if (mc == MC_D_BARREL)												return("d_barrel");

/// wolf
	if (mc == MC_W_KNIFE)												return("w_weapon_knife");
	if (mc == MC_W_PISTOL)												return("w_weapon_pistol");
	if (mc == MC_W_MACHGUN)												return("w_weapon_machinegun");
	if (mc == MC_W_CHAINGUN)											return("w_weapon_chaingun");
	if (mc == MC_W_MORTAR)												return("w_weapon_mortar");
	if (mc == MC_W_FLAMER)												return("w_weapon_flamer");

	if (mc == MC_W_CLIP)													return("w_ammo_clip");
	if (mc == MC_W_GAS)													return("w_ammo_gas");
	if (mc == MC_W_MORTARS)												return("w_ammo_rock");
	if (mc == MC_W_PACK)													return("w_item_pack");

	if (mc == MC_W_FACESPHERE)											return("w_art_facesphere");
	if (mc == MC_W_HEALTH)												return("w_heal_medkit");
	if (mc == MC_W_FOOD)													return("w_heal_food");
	if (mc == MC_W_DOGFOOD)												return("w_heal_dogfood");
	if (mc == MC_W_BLOOD)												return("w_heal_blood");
	if (mc == MC_W_BLDBNS)												return("w_heal_bldbns");

	if (mc == MC_W_KEY_G)												return("w_key_g");
	if (mc == MC_W_KEY_B)												return("w_key_b");
	if (mc == MC_W_BARREL)												return("w_barrel");
	
	if (mc == MC_W_G_CROSS)												return("w_item_cross");
	if (mc == MC_W_G_CHALICE)											return("w_item_chalice");
	if (mc == MC_W_G_CHEST)												return("w_item_chest");
	if (mc == MC_W_G_CROWN)												return("w_item_crown");


/// q2

	if (mc == MC_Q2_BLASTER)											return("q2_weapon_blaster"); 
	if (mc == MC_Q2_SHOTGUN)											return("q2_weapon_shotgun"); 
	if (mc == MC_Q2_DBLSHOTGUN)										return("q2_weapon_supershotgun"); 
	if (mc == MC_Q2_MACHINEGUN)										return("q2_weapon_machinegun"); 
	if (mc == MC_Q2_CHAINGUN)											return("weapon_chaingun"); 
	if (mc == MC_Q2_GRENADEL)											return("q2_weapon_grenadelauncher"); 
	if (mc == MC_Q2_ROCKETL)											return("q2_weapon_rocketlauncher"); 
	if (mc == MC_Q2_HYPBLASTER)										return("weapon_hyperblaster"); 
	if (mc == MC_Q2_RAILGUN)											return("q2_weapon_railgun"); 
	if (mc == MC_Q2_BFG)													return("q2_weapon_bfg"); 
	if (mc == MC_Q2_GRAPPLE)											return("q2_weapon_grapple"); 

	if (mc == MC_Q2_QUAD)												return("q2_item_quad"); 
	if (mc == MC_Q2_INVUL)												return("item_invulnerability"); 
	if (mc == MC_Q2_ENVIRO)												return("q2_item_enviro"); 
	if (mc == MC_Q2_SILENCE)											return("item_silencer"); 

	if (mc == MC_Q2_ARM_SHARD)											return("q2_item_armor_shard"); 
	if (mc == MC_Q2_ARM_JAK)											return("item_armor_jacket"); 
	if (mc == MC_Q2_ARM_COMBAT)										return("q2_item_armor_combat"); 
	if (mc == MC_Q2_ARM_BODY)											return("q2_item_armor_body"); 
	if (mc == MC_Q2_ARM_PSHIELD)										return("item_power_shield"); 
	if (mc == MC_Q2_ARM_PSCREEN)										return("item_power_screen"); 

	if (mc == MC_Q2_STIMPAK)											return("q2_item_health_small"); 
	if (mc == MC_Q2_FIRSTAID)											return("q2_item_health"); 
	if (mc == MC_Q2_MEDKIT)												return("q2_item_health_large"); 
	if (mc == MC_Q2_MEGA)												return("q2_item_health_mega"); 

	if (mc == MC_Q2_KEY_RED)											return("key_red_key"); 
	if (mc == MC_Q2_KEY_BLU)											return("key_blue_key"); 
	if (mc == MC_Q2_KEY_CHEAD)											return("key_blue_key"); 
	if (mc == MC_Q2_KEY_ATARGET)										return("key_airstrike_target"); 
	if (mc == MC_Q2_KEY_CD)												return("key_data_cd"); 
	if (mc == MC_Q2_KEY_SPINNER)										return("key_data_spinner"); 
	if (mc == MC_Q2_KEY_PASS)											return("key_pass"); 
	if (mc == MC_Q2_KEY_POWER)											return("key_power_cube"); 
	if (mc == MC_Q2_KEY_PYRAMID)										return("key_pyramid"); 

	if (mc == MC_Q2_ASHELLS)											return("q2_ammo_shells"); 
	if (mc == MC_Q2_ABULLETS)											return("q2_ammo_bullets"); 
	if (mc == MC_Q2_AROCKETS)											return("q2_ammo_rockets"); 
	if (mc == MC_Q2_AGRENADES)											return("q2_ammo_grenades"); 
	if (mc == MC_Q2_ACELLS)												return("q2_ammo_cells"); 
	if (mc == MC_Q2_ASLUGS)												return("q2_ammo_slugs"); 

	if (mc == MC_Q2_PACK)												return("item_pack"); 
	if (mc == MC_Q2_ADRENALINE)										return("item_adrenaline"); 
	if (mc == MC_Q2_BANDOLIER)											return("item_bandolier"); 
	if (mc == MC_Q2_BREATHER)											return("item_breather"); 

	if (mc == MC_Q2_BARREL)												return("q2_misc_explobox");

	if (mc == MC_Q2_TECH_RES)											return("q2_ctf_resist"); 
	if (mc == MC_Q2_TECH_DOC)											return("q2_ctf_regen"); 
	if (mc == MC_Q2_TECH_AMP)											return("q2_ctf_stren"); 
	if (mc == MC_Q2_TECH_TM)											return("q2_ctf_haste"); 

/// q3

	if (mc == MC_Q3_GAUNTLET)											return("weapon_gauntlet"); 
	if (mc == MC_Q3_GRAPPLE)											return("weapon_grapplinghook"); 
	if (mc == MC_Q3_MACHINEGUN)										return("q3_weapon_machinegun"); 
	if (mc == MC_Q3_SHOTGUN)											return("q3_weapon_shotgun"); 
	if (mc == MC_Q3_GRENADEL)											return("q3_weapon_grenadelauncher"); 
	if (mc == MC_Q3_ROCKETL)											return("q3_weapon_rocketlauncher"); 
	if (mc == MC_Q3_PLASMA)												return("weapon_plasmagun"); 
	if (mc == MC_Q3_LIGHTNING)											return("q3_weapon_lightning"); 
	if (mc == MC_Q3_RAILGUN)											return("q3_weapon_railgun"); 
	if (mc == MC_Q3_BFG)													return("q3_weapon_bfg"); 

	if (mc == MC_Q3_QUAD)												return("q3_item_quad"); 
	if (mc == MC_Q3_REGEN)												return("item_regen"); 
	if (mc == MC_Q3_ENVIRO)												return("q3_item_enviro"); 
	if (mc == MC_Q3_INVIS)												return("item_invis"); 
	if (mc == MC_Q3_HASTE)												return("item_haste"); 
	if (mc == MC_Q3_FLIGHT)												return("item_flight"); 

	if (mc == MC_Q3_ARM_SHARD)											return("q3_item_armor_shard"); 
	if (mc == MC_Q3_ARM_COMBAT)										return("q3_item_armor_combat"); 
	if (mc == MC_Q3_ARM_BODY)											return("q3_item_armor_body"); 

	if (mc == MC_Q3_HSMALL)												return("q3_item_health_small"); 
	if (mc == MC_Q3_HEALTH)												return("q3_item_health"); 
	if (mc == MC_Q3_HLARGE)												return("q3_item_health_large"); 
	if (mc == MC_Q3_MEGA)												return("q3_item_health_mega"); 

	if (mc == MC_Q3_ASHELLS)											return("q3_ammo_shells"); 
	if (mc == MC_Q3_ABULLETS)											return("q3_ammo_bullets"); 
	if (mc == MC_Q3_AROCKETS)											return("q3_ammo_rockets"); 
	if (mc == MC_Q3_AGRENADES)											return("q3_ammo_grenades"); 
	if (mc == MC_Q3_ACELLS)												return("q3_ammo_cells"); 
	if (mc == MC_Q3_ASLUGS)												return("q3_ammo_slugs"); 
	if (mc == MC_Q3_ALIGNTNING)										return("ammo_lightning"); 
	if (mc == MC_Q3_ABFG)												return("ammo_bfg"); 

	if (mc == MC_Q3_HOLDMEDKIT)										return("holdable_medkit"); 
	if (mc == MC_Q3_HOLDTELE)											return("holdable_teleporter"); 

	if (mc == MC_Q3_BARREL)												return("q3_misc_explobox"); 

/// chaos
	
	if (mc == MC_REGGUN)													return("c_weapon_reggun");
	if (mc == MC_TALLBALL)												return("c_weapon_tallball");
	if (mc == MC_DEEPSLEEP)												return("c_weapon_deepsleep");
	if (mc == MC_QUANTUM)												return("weapon_quantum");
	if (mc == MC_C_FLAMER)												return("weapon_flamer");
	if (mc == MC_C_AGAS)													return("ammo_gas");
	if (mc == MC_C_AGAS_LG)												return("ammo_gas_lg");

//	if (mc == MC_) return("item_");

	return(null_string);
};

// fn(valid_wep_mcode) - validate weapon map codes for fake loads, etc.

// return a valid inventory bit for op
// return 0 if not a valid weapon map code

float(float mcv) valid_wep_mcode =
{
/// q1

	if (mcv == MC_AXE)													return(IT_AXE);
	if (mcv == MC_SHOTGUN)												return(IT_SHOTGUN);
	if (mcv == MC_SUPER_SHOTGUN)										return(IT_SUPER_SHOTGUN);
	if (mcv == MC_NAILGUN)												return(IT_NAILGUN);
	if (mcv == MC_SUPER_NAILGUN)										return(IT_SUPER_NAILGUN);
	if (mcv == MC_GRENADEL)												return(IT_GRENADE_LAUNCHER);
	if (mcv == MC_ROCKETL)												return(IT_ROCKET_LAUNCHER);
	if (mcv == MC_THUNDER)												return(IT_LIGHTNING);

/// ctf

	if (mcv == MC_HOOK)													return(IT_AXE);

/// hipnotic

	if (mcv == MC_HIP_MJOLNIR)											return(IT_MJOLNIR);
	if (mcv == MC_HIP_LASERCAN)										return(IT_SUPER_NAILGUN);
	if (mcv == MC_HIP_PROXGUN)											return(IT_GRENADE_LAUNCHER);

/// doom

	if (mcv == MC_D_SHOTGUN)											return(IT_SHOTGUN);
	if (mcv == MC_D_BOOMSTICK)											return(IT_SUPER_SHOTGUN);
	if (mcv == MC_D_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mcv == MC_D_ROCKETL)											return(IT_ROCKET_LAUNCHER);
	if (mcv == MC_D_PLASMA)												return(IT_LIGHTNING);
	if (mcv == MC_D_BFG)													return(IT_EXTRA_WEAPON);
	if (mcv == MC_D_SAW)													return(IT_NAILGUN);
	if (mcv == MC_D_PISTOL)												return(IT_AXE);

/// wolf

	if (mcv == MC_W_KNIFE)												return(IT_AXE);
	if (mcv == MC_W_PISTOL)												return(IT_SHOTGUN);
	if (mcv == MC_W_MACHGUN)											return(IT_NAILGUN);
	if (mcv == MC_W_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mcv == MC_W_MORTAR)												return(IT_ROCKET_LAUNCHER);
	if (mcv == MC_W_FLAMER)												return(IT_GRENADE_LAUNCHER);

/// q2

	if (mcv == MC_Q2_BLASTER)											return(IT_AXE);
	if (mcv == MC_Q2_SHOTGUN)											return(IT_SHOTGUN);
	if (mcv == MC_Q2_DBLSHOTGUN)										return(IT_SUPER_SHOTGUN);
	if (mcv == MC_Q2_MACHINEGUN)										return(IT_NAILGUN);
	if (mcv == MC_Q2_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mcv == MC_Q2_GRENADEL)											return(IT_GRENADE_LAUNCHER);
	if (mcv == MC_Q2_ROCKETL)											return(IT_ROCKET_LAUNCHER);
	if (mcv == MC_Q2_HYPBLASTER)										return(IT_LIGHTNING);
	if (mcv == MC_Q2_RAILGUN)											return(IT_GRENADE_LAUNCHER);
	if (mcv == MC_Q2_AGRENADES)										return(IT_GRENADE_LAUNCHER); // hand grenades
	if (mcv == MC_Q2_BFG)												return(IT_EXTRA_WEAPON);
	if (mcv == MC_Q2_GRAPPLE)											return(IT_AXE); // needs to be grap gun -> special

/// q3

	if (mcv == MC_Q3_GAUNTLET)											return(IT_AXE);
	if (mcv == MC_Q3_GRAPPLE)											return(IT_AXE); // needs to be grap gun -> special
	if (mcv == MC_Q3_MACHINEGUN)										return(IT_NAILGUN);
	if (mcv == MC_Q3_SHOTGUN)											return(IT_SUPER_SHOTGUN);
	if (mcv == MC_Q3_GRENADEL)											return(IT_GRENADE_LAUNCHER);
	if (mcv == MC_Q3_ROCKETL)											return(IT_ROCKET_LAUNCHER);
	if (mcv == MC_Q3_PLASMA)											return(IT_SUPER_NAILGUN);
	if (mcv == MC_Q3_LIGHTNING)										return(IT_LIGHTNING);
	if (mcv == MC_Q3_RAILGUN)											return(IT_SHOTGUN);
	if (mcv == MC_Q3_BFG)												return(IT_EXTRA_WEAPON);

/// chaos

	if (mcv == MC_REGGUN)												return(IT_SUPER_SHOTGUN);
	if (mcv == MC_TALLBALL)												return(IT_AXE);
	if (mcv == MC_DEEPSLEEP)											return(IT_AXE);
	if (mcv == MC_QUANTUM)												return(IT_LIGHTNING);
	if (mcv == MC_C_FLAMER)												return(IT_GRENADE_LAUNCHER);

	return(0); // not a valid x weapon
};

// fn(wepbit_mcode) - given a bit and map mode, provide map code

// Cataboligne - 9.7.11 - added ammo type & default wep counts for dead threw

// bt - bit for weapon
// md - mode of map

float(float bt, string md) wepbit_mcode =
{
/// q1

	if (md == "Q" || md == "PK")
	{
		if (bt == IT_AXE)													return(MC_AXE);				// 4096
		if (bt == IT_SHOTGUN)											return(MC_SHOTGUN);			// 1
		if (bt == IT_SUPER_SHOTGUN)									return(MC_SUPER_SHOTGUN);	// 2
		if (bt == IT_NAILGUN)											return(MC_NAILGUN);			// 4
		if (bt == IT_SUPER_NAILGUN)									return(MC_SUPER_NAILGUN);	// 8
		if (bt == IT_GRENADE_LAUNCHER)								return(MC_GRENADEL);			// 16
		if (bt == IT_ROCKET_LAUNCHER)									return(MC_ROCKETL);			// 32
		if (bt == IT_LIGHTNING)											return(MC_THUNDER);			// 64
		if (bt == IT_MJOLNIR)											return(MC_HIP_MJOLNIR);		// 128
	}

	if (md == "PK2") // dead threw deal
	{
		if (bt == PK_IT_AXE)												return(MC_AXE);				// 4096
		if (bt == PK_IT_GRAVITYWELL)									return(MC_GRAVITY);			// 2
		if (bt == PK_IT_TURRET)											return(MC_SENTRY);			// 4
		if (bt == PK_IT_CANPAB)											return(MC_CANOBEANS);		// 8
		if (bt == PK_IT_BEARTRAP)										return(MC_BEARTRAP);			// 128
		if (bt == PK_IT_GRAPGUN)										return(MC_GRAP);				// 16
		if (bt == PK_IT_AIRGUN)											return(MC_AIRGUN);			// 32
		if (bt == PK_IT_CLIGHT)											return(MC_CHTHUNDR);			// 64

		if (bt == PKPLUS_IT_EGO)										return(MC_EGO);				// 256
		if (bt == PKPLUS_IT_TOMB)										return(MC_TOMB);				// 512
		if (bt == PKPLUS_IT_ACTOR)										return(MC_MASK);				// 1024
		if (bt == PKPLUS_IT_PHONE)										return(MC_PHONE);				// 2048
	}

/// ammo types & defaults for std weps - dead threw deal

	if (md == "QA")
	{
		if (bt == IT_AXE)													return(AMMO_NONE);			// 4096
		if (bt == IT_SHOTGUN)											return(AMMO_SHELLS);			// 1
		if (bt == IT_SUPER_SHOTGUN)									return(AMMO_SHELLS);			// 2
		if (bt == IT_NAILGUN)											return(AMMO_NAILS);			// 4
		if (bt == IT_SUPER_NAILGUN)									return(AMMO_NAILS);			// 8
		if (bt == IT_GRENADE_LAUNCHER)								return(AMMO_ROCKETS);		// 16
		if (bt == IT_ROCKET_LAUNCHER)									return(AMMO_ROCKETS);		// 32
		if (bt == IT_LIGHTNING)											return(AMMO_CELLS);			// 64
//		if (bt == IT_MJOLNIR)											return(AMMO_CELLS);			// 128
	}

	if (md == "QAC")
	{
		if (bt == IT_AXE)													return(0);						// 4096
		if (bt == IT_SHOTGUN)											return(5);						// 1
		if (bt == IT_SUPER_SHOTGUN)									return(5);						// 2
		if (bt == IT_NAILGUN)											return(30);						// 4
		if (bt == IT_SUPER_NAILGUN)									return(30);						// 8
		if (bt == IT_GRENADE_LAUNCHER)								return(5);						// 16
		if (bt == IT_ROCKET_LAUNCHER)									return(5);						// 32
		if (bt == IT_LIGHTNING)											return(15);						// 64
//		if (bt == IT_MJOLNIR)											return(AMMO_CELLS);			// 128
	}

/// doom

	else if (md == "D")
	{
		if (bt == IT_SHOTGUN)											return(MC_D_SHOTGUN);
		if (bt == IT_SUPER_SHOTGUN)									return(MC_D_BOOMSTICK);
		if (bt == IT_SUPER_NAILGUN)									return(MC_D_CHAINGUN);
		if (bt == IT_ROCKET_LAUNCHER)									return(MC_D_ROCKETL);
		if (bt == IT_LIGHTNING)											return(MC_D_PLASMA);
		if (bt == IT_EXTRA_WEAPON)										return(MC_D_BFG);
		if (bt == IT_NAILGUN)											return(MC_D_SAW);
		if (bt == IT_AXE)													return(MC_D_PISTOL);
	}

/// wolf

	else if (md == "W")
	{
		if (bt == IT_AXE)													return(MC_W_KNIFE);
		if (bt == IT_SHOTGUN)											return(MC_W_PISTOL);
		if (bt == IT_NAILGUN)											return(MC_W_MACHGUN);
		if (bt == IT_SUPER_NAILGUN)									return(MC_W_CHAINGUN);
		if (bt == IT_ROCKET_LAUNCHER)									return(MC_W_MORTAR);
		if (bt == IT_GRENADE_LAUNCHER)								return(MC_W_FLAMER);
	}
	
/// q2

	else if (md == "Q2")
	{
		if (bt == IT_AXE)													return(MC_Q2_BLASTER);
		if (bt == IT_SHOTGUN)											return(MC_Q2_SHOTGUN);
		if (bt == IT_SUPER_SHOTGUN)									return(MC_Q2_DBLSHOTGUN);
		if (bt == IT_NAILGUN)											return(MC_Q2_MACHINEGUN);
		if (bt == IT_SUPER_NAILGUN)									return(MC_Q2_CHAINGUN);
		if (bt == IT_GRENADE_LAUNCHER)								return(MC_Q2_GRENADEL);
		if (bt == IT_ROCKET_LAUNCHER)									return(MC_Q2_ROCKETL);
		if (bt == IT_LIGHTNING)											return(MC_Q2_HYPBLASTER);
		if (bt == IT_GRENADE_LAUNCHER)								return(MC_Q2_RAILGUN);
		if (bt == IT_EXTRA_WEAPON)										return(MC_Q2_BFG); // NOTE: repeat bits DONT work! - cant default q2 bfg for now
	}

/// q3

	else if (md == "Q3")
	{
		if (bt == IT_AXE)													return(MC_Q3_GAUNTLET);
//		if (bt == IT_AXE)													return(MC_Q3_GRAPPLE);
		if (bt == IT_SHOTGUN)											return(MC_Q3_MACHINEGUN);
		if (bt == IT_SUPER_SHOTGUN)									return(MC_Q3_SHOTGUN);
		if (bt == IT_GRENADE_LAUNCHER)								return(MC_Q3_GRENADEL);
		if (bt == IT_ROCKET_LAUNCHER)									return(MC_Q3_ROCKETL);
		if (bt == IT_SUPER_NAILGUN)									return(MC_Q3_PLASMA);
		if (bt == IT_LIGHTNING)											return(MC_Q3_LIGHTNING);
		if (bt == IT_NAILGUN)											return(MC_Q3_RAILGUN);
		if (bt == IT_EXTRA_WEAPON)										return(MC_Q3_BFG);
	}

	return(0);
};


// implement for upgrades

void () painkeep_weapon_touch;

// NOTE: make these both eweapons, only way it will ever work with map mode

/*QUAKED weapon_pulsenail (0 .5 .8) (-16 -16 0) (16 16 32)
*/

// note: wont set map mode either
// CHECK make sure !PK code doesnt change this

void () weapon_pulsenail =
{
	precache_model ("progs/g_fnail.mdl");
	setmodel (self, "progs/g_fnail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Pulse Rifle";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	self.mask_x = CB_HUMAN+ CB_GREMLIN + CB_OGRE;
	StartItem ();
};

// regular nailgun wont be pk translated

void () weapon_nailgun_q1 =
{
	weapon_nailgun();
	self.touch = painkeep_weapon_touch;
};

// axe attack - assumes player frames

void() fire_axe =
{
	local float r;

	sound (self, CHAN_WEAPON, self.noise1, 1, ATTN_NORM);
	r = random();
	if (r < 0.25)
	  player_axe1 ();
	else if (r<0.5)
	  player_axeb1 ();
	else if (r<0.75)
	  player_axec1 ();
	else
	  player_axed1 ();
};

/*QUAKED weapon_axe (0 .5 .8) (-16 -16 0) (16 16 32)

 no quake map will ever have this or the shotgun
 used entirely for dead threw and dynamic / random spawns

*/

void () weapon_axe =
{
	self.touch = weapon_touch; // NOTE: does not work - touch ends up SUB_Null
	self._attack = SUB_Null;
	self._fr_attack = fire_axe;

	self.currentammo = 0;
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE;
	self.weaponframe = AMMO_NONE;
	self.attack_finished = 0.5;
	self.dmg_save = 0;

	self.netname = "War Axe";
	precache_model ("progs/g_axe.mdl");
	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/vw_axe.mdl");
	setmodel (self,"progs/g_axe.mdl");
	self.weaponmodel = "progs/v_axe.mdl";
	self.vwepmdl = "progs/vw_axe.mdl";
	self.noise1 = "weapons/ax1.wav"; // missed
	self.noise3 = "player/axhit2.wav"; // hit wall &| solid
//	self.noise4 = "zombie/z_hit.wav"; // hit flesh

	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN;

	self.archon = ARCHON_WEP * 2;
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q100_weapon_shotgun =
{
	self.touch = x_weapon_touch;
	self._attack = W_FireShotgun;
	self._fr_attack = player_shot1;

	self.currentammo = 25;
	self.items = IT_SHOTGUN;
	self.weaponframe = AMMO_SHELLS;
	self.attack_finished = 0.5;
	self.dmg_save = 1;

	self.netname = "Shotgun";
	precache_model ("progs/shotgun.mdl");
	precache_model ("progs/v2_shot.mdl");
	precache_model ("progs/vw_shot.mdl");
	setmodel (self, "progs/shotgun.mdl");
	self.weaponmodel = "progs/v2_shot.mdl";
	self.vwepmdl = "progs/vw_shot.mdl";
	self.noise3 = "weapons/guncock.wav"; 

	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
	self.mask_x = CB_HUMAN + CB_ENF;

	self.archon = ARCHON_WEP;
};

/*QUAKED weapon_hook (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() 	weapon_grapgun;
void() 	player_q3grap;

void () weapon_hook =
{
	weapon_grapgun();

	self.netname = "Grappling hook";

	self.touch = x_weapon_touch;
	self._attack = player_q3grap;
	self._fr_attack = SUB_Null;

	self.currentammo = 0;
	self.lip = 0;
	self.attack_finished = 0.5;
	self.lefty = SEL_S_HOOK;
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_GRAPGUN; // grap replacement

	self.dmg = 5;
/*
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
*/
	self.style = FL_MELEE_WEP;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.vv_draw = vw_q1_grap;

	setmodel (self, "progs/g_grap.mdl");
	self.weaponmodel = "progs/v_grap.mdl";
	self.vwepmdl = "progs/vw_grap.mdl";

// grap specials

	self.killtarget =  "progs/hook.mdl";
	self.target = "player/axhit2.wav"; // hook hit a solid - not damaged
	self.noise1 = "hook/retract.wav"; // drop
	self.target1 = "hook/chain1.wav"; // in + out
	self.target2 = "hook/chain2.wav"; // in + out
	self.targetname = "weapons/ax1.wav"; // launch snd
	self.bulletspread_x = 0.85; // damp

	self.mask_x = CB_HUMAN + CB_GREMLIN;

	self.archon = ARCHON_WEP;
};

// cubes - open 'er up and see what it is

// self MUST BE player
void() cube_rearm =
{
	if (self.deadflag) return;

	self.eweapon = world;
	if (self.morphy == IMP_MCHAOS) self.mcode = -666;
	else if (self.morphy == IMP_MORDER) self.mcode = -667;
	else
	{
		self.mcode = 0; // clear HUD
		self.weapon = W_BestWeapon();
		self.pk_currentitem = W_BestPKWeapon();
		self.eweapon = vchk(self.weapon, self.pk_currentitem, self.vwepent);
		W_SetCurrentAmmo();
//	if (!self.mask_x & MORPH_ARCHON) 
		self.volume = 0; // clear HUD
	}
	admin_clear(self); // for morphic cube
};


// self is player or crate
// c = self.eweapon = cube
// c = self = crate

void(entity e, float trvs) item_translate;

void() painkeep_cube_use =
{
	local entity c, sv, crate, y;
	local float f, d;
	local vector v;

	sv = self;
	d = 0;
	y = crate = world;

	if (self.wad == "pk_crate") crate = self;

	if (!crate) // player wad string better never = pk_crate
	{
		c = self.eweapon;
		v1 = self.origin - c.origin;
		if (vlen(v1) > PK_CUBE_DIST)
		{
			sprint(self, "You are too far away to open your cube.\n");
			return;
		}

		cube_rearm(); // re arm player
		self.button0 = 0;

		if (c.wad != "pk_cube")
		{
#ifdef warning
			if (WARNING & 2)	bprint("*** WARNING - in cube use and dont have a cube or a crate!\n");
#endifdef
			return;
		}
		c.think = SUB_Null;

		if (c.owner)
		if (c.message) sprint(c.owner, c.message);
		c.owner = world;
	}
	else
	{
		c = self; // crate is self - still have to set, might use cube code
		if (c.solid == SOLID_TRIGGER) return; // opened crate
	}
	f = floor(random() * c.stdev);
	if (c.items) d = c.items + f; // select item
	c.touch = SUB_Null;

	sound (c, CHAN_WEAPON, c.noise, 1, ATTN_NORM);

// make something random if none was given

	if (!d)
	{
		f = MC_PK_RNDITM;
		if (PK_ART) f = MC_PKP_RNDITM - 1;
		d = MC_PULSE_NAILGUN + rint(random() * f);
		if (random() < 0.36)
		{
			d = 0;
			f = rint(random() * 10);
			if (f < 4) d = MC_REGGUN; // MC_HIP_LASERCAN;
			else if (f < 6 && ULOK2) d = MC_Q2_BFG;
			if (d) c.ammo_cells = -1;
			else
			{
				if (f < 7) d = MC_QUANTUM;
//				else if (f < 8) d = MC_DEEPSLEEP;
				else
				{
					f = rint(random() * 6);
					if (f == 1) d = MC_HEALTHMEGA;
					else if (f == 2) d = MC_ARMOR3;
					else if (f == 3) { d = MC_EXPLOD2; if (ULOKD) d = MC_D_BARREL;  } 
					else if (f == 4) d = MC_HOOK;
					else if (f == 5)
					{
//						d = MC_HIP_MJOLNIR;
						d = MC_C_FLAMER;
						if (random() < 0.6)
						{
							if (ULOK2)
							{
								d = MC_Q2_ARM_PSHIELD;
								c.ammo_cells = -1;
							}
							if (ULOK3) d = MC_Q3_HASTE; 
						}
						
						if (d == MC_C_FLAMER) // making a flamer - random ammo
						{
							self = spawn();
							self.wait = MC_C_AGAS_LG;
							func_make();
							newmis.punchangle = MED_BOUNCE_NOW;
							func_make();
							newmis.punchangle = MED_BOUNCE_NOW;
							remove(self);
							self = sv;
						}
					}
					else
					{
						d = MC_PENT;
						f = MC_TOT - 2;
						if (random() < 0.2 && XMOD) d = MC_SUPER_SHOTGUN + rint(random() * f); // any item besides q1 axe or sg
						if (random() < 0.2 && MORPHIC && c.event == "dynamic_item") c.wad = "morph_cube"; // can only do this with dynamic pk cubes
					}
				}
			}
		}
	}

	if (crate)
	{
		if (c.classname != "info_notnull") // crate is now open
		{
			if (c.model == "progs/crate_lg.bsp")
				setmodel(c, "progs/crate_lg_o1.bsp");
			else
			if (random() < 0.5)
				setmodel(c, "progs/crate_o1.bsp"); // crates become debris
			else
			if (random() < 0.5)
				setmodel(c, "progs/crate_o2.bsp");
			else
				setmodel(c, "progs/crate_o3.bsp");

			c.solid = SOLID_TRIGGER; // non blocking
			if (c.classname != "func_crate")
				c.takedamage = DAMAGE_AIM; // this isnt actually shootable because of the trigger solid

			if (c.th_stand != SUB_Null) // could be respawnable
			{
				c.think = c.th_stand;
				c.nextthink = time + PK_CUBE_TIME + crandom() * PK_CUBE_DV;
			}
			else
			{
				c.health = 20; // note: not really shootable because of solid flag
				c.think = c.th_die = SUB_Remove;
				c.nextthink = time + PK_CUBE_TIME + crandom() * PK_CUBE_DV;
			}
		}

		if (crate.message)
		if (damage_attacker.class_select == "class_player")
		{
			sprint(damage_attacker, crate.message);
			sprint(damage_attacker, "\n");
		}

// find any crate targets and process
		if (crate.target)
		{
			c = find (world,targetname,crate.target);
			if(c)
			{
				self = c;
				painkeep_cube_use();
//				c = find (world,targetname,c.target);
			}
		}
		y = c = spawn(); // crates make a new thing
		setorigin(c, crate.origin + '0 0 8');
		c.event = "dynamic_item"; // dont respawn
		c.ammo_cells = crate.ammo_cells; // was set above

		c.wad = item_by_mcode(d); // default
		f = floor(random() * crate.stdev);

// map loaded crates
		if (crate.items) c.wad = item_by_mcode(crate.items + f);
		else if (crate.map) c.wad = crate.map; // crate on map specced an item
		else if (crate.wait)
		{
			self = c; // temp ent
			self.delay = self.count = 0;
			self.wait = crate.wait;
			self.spawnflags = (crate.spawnflags & 4); // no respawn on item - + spawnflag for dynamic remove
			func_make();
			d = pk_mcode(newmis.wad, world);
			if (d == MC_EXPLOD1 || d == MC_EXPLOD2 || d == MC_D_BARREL || d == MC_Q2_BARREL)
				newmis.th_stand = SUB_Remove;
			newmis.velocity = v0; // stop eject
			if (y) remove(y);
			self = sv;
			return;
		}
	}
	else
	if (c.wad == "pk_cube")
	{
		c.model = null_string;
		if (c.event != "dynamic_item") // a map created cube - should respawn, items will not remove
		{
			c.solid = SOLID_NOT;
			if (deathmatch)
//			if (deathmatch == 1 || deathmatch == 3)
			c.think = SUB_regen;
			c.nextthink = time + PK_CUBE_TIME + crandom() * PK_CUBE_DV;
			v = c.origin + '0 0 4';
			y = c = spawn();
			c.origin = v;
			c.event = "dynamic_item"; // dont respawn
		}
		c.wad = item_by_mcode(d);
	}

	self = c;
	self.class_select = null_string; // for q3 holds
	self.mask_x = 0; // reset
	self.style = 0; // so we arent making a melee wep out of a range wep
//	item_translate(self, FL_TR_RANDOM);


	if (random() > 0.15 || crate) // crates always give goody
	{
		self.pk_touch = painkeep_touch;
		d = pk_mcode(self.wad, world);

		if (d == MC_EXPLOD1 || d == MC_EXPLOD2 || d == MC_D_BARREL || d == MC_Q2_BARREL) // cause barrels are special
		{
			self.event = self.classname = null_string;
			self.scode = -1; // item call tests this for making barrels
			item_call(self.wad);
			newmis.th_stand = SUB_Remove; // go away after boom
			newmis.event = "dynamic_item"; // dont respawn - in case above misses
			pk_ditems = pk_ditems + 1; // do here because call already made
			if (y) remove(y); // cant remove a dynamic cube - it has a dyn_rem
			self = sv;
			return;
		}
		if (d) self.event = "dynamic_item"; // just to double check

		item_call(self.wad);

// dont make  non melee items under this rule
		if (TR_ALL == FL_TR_MELEE)
		{
			if (!self.scode) self.scode = pk_mcode(self.classname, world); // for xlate
			item_translate(self, TR_ALL);
		}

		if (self.classname == "item_painkeep_gwell")
		if (random() < 0.333)
		{
			self.skin = 1; // super gravity well
			self.frame = 1;
			self.archon = 0.80;
		}

		if (!crate)
			self.punchangle = '110 110 280'; // for ejector
		else
		{
			self.punchangle = anti_bounce;
			if ( (crate.spawnflags & 4) || crate.event ==  "dynamic_item")
			{
				f = crate.mean;
				if (!f) f = PK_DYNTO * 2;
				if (self.class_select == "class_monster")
				{
					if (crate.event !=  "dynamic_item")
					dyn_remove(self, (f + 20 * random()), dyn_rem); // monsters think & have to go old style
				}
				else
					dyn_remove(self, (f + 20 * random()), SUB_Null);
			}
		}

// pk cube fix - spawned something and fns are reversed
		if (self.class_select != "class_monster")
		{
			if (self.pk_touch == painkeep_touch)
			if (self.touch != painkeep_touch)
			{
				self.pk_touch = self.touch;
			}
			self.touch = painkeep_touch;
			self.solid = SOLID_TRIGGER;	// allow it to be touched again - needed on x weaps
		}
		else
		{
			if (damage_attacker)
			if (random() < 0.92)
			if (damage_attacker.flags & FL_CLIENT)
			{
				self.charmer = damage_attacker;
				self.charmed = 1;
			}
#ifdef warning
									self.map = "I came from a cube / crate"; // TEST - remove
#endifdef
			self.flags = FL_MONSTER; // 11.14.13
		}
	}
	else
	{
		if ((random() < 0.5) && (chaos_tele_total < CHAOS_TELE_LIMIT))
		{
			chaos_teleport(self.origin, null_string, world);
			newmis.origin_z = newmis.origin_z + 20 + random() * 30;
			chaos_tele_total = chaos_tele_total + 1;

			if (random() < 0.95) // mostly not permanent
				dyn_remove(newmis, (PK_DYNTO * (2 + random() + random()) + (20 * random())), chaos_tele_expire);
		}
		else if (random() < 0.25)
		{
			d = rnd_bit_mask(MONSTER_Q1); // no mask_y - use any q1 monster
			self.wad = monster_id(d, MON_FUNC_REG);
			self.origin_z = self.origin_z + 8;
			item_call(self.wad);
#ifdef warning
									self.map = "I came from a cube / crate"; // TEST - remove
#endifdef
//			self.button13 = 0; // dont let dyn_rem wack the *_start_go from setting takedamage, etc.
			self.flags = FL_MONSTER; // 11.14.13 - clear item flgs from cube/crate
		}
		else
		{
			f = 4 + random() * 4;
			while (f > 0)
			{
				W_FireClusterGren(); // uses ammo, but we dont care here
				item_eject(newmis, ' 400 400 400');
				f = f - 1;
			}
		}

		if (y) remove(y);
	}

// IDEA: tele-sphere, portal, explosive regular item, nail bomb, chaos effect
	self = sv;

};

//:-( cube owner didnt open it

void() abandoned_cube =
{
	local entity c;
	c = self;

	if (c.owner)
	if ((c.count < time) || (c.owner.eweapon != c))
	{
		c.effects = 0;
		if (c.count < time) sprint(c.owner, "Your cube was left alone too long and abanoned you. You rat.\n");
		c.touch = painkeep_touch;
		self = c.owner;
		c.owner = world;
		cube_rearm(); // re arm player
		self = c;
		return;
	}

	c.nextthink = time + 3 + random();

};

// used by pk & morphic cubes
float BOT_NOUSE_PKCUBE = 0.3;
float BOT_NOUSE_MCUBE = 0.8;

void() cube_touch =
{
	local entity e;

// clear power required for morph - morph cubes do not give archon points

	if (self.wad == "morph_cube") self.archon = 0;
 
// initial control for bots using evolution cubes
	if (self.wad == "morph_cube")
	if (other.class_select == "class_bot")
	{
		if (other.wad == "pk*bot") // see if server admin denied either bot morphic upgrades
		{
			if (!MORPH_BOT & 2) return;
		}
		else // frik test
		{
			if (!MORPH_BOT & 1) return;
		}
		
		if (self.mask_x == MORPH_ARCHON) return; // not bot Archons yet

		if (other.mask_x & CB_HUMAN) // if bot score is low, stay human for now
		{
			if (other.frags < (high_score * 0.11)) return;
			if (other.frags < 0) return;
		}
		if (!MORPH_FREE)
		if (other.archon < 500) // make bots wait till they can morph to any - need a separate test for bot archon case
			return;
	}

	if (self.owner) // shouldnt happen
		return;

	if (sphere_a.owner == other) // no cubes while controlling sphere
	{
#ifdef warning
if (WARNING & 2) bprint("\b *** warning: nocubes: SOA\n");
#endifdef
		return;
	}

	if (other.dropent) // dont touch while inventory controlling
		return;

	if (MORPH_LOCK) // already morphed and morph lock is engaged - hit impulse 50 to clear
	if (self.wad == "morph_cube")
	if (other.state) // this locks morph state - player toggle to 0 allows more morphing
	{
		if (other.class_select == "class_player") return;
		else if (random() > 0.08) return;
	}

	if (other.eweapon) // other has a cube and is touching different one
	{
		if (other.eweapon.wad == "pk_cube")
		{
			if (other.eweapon.duration > time) return;
			other.eweapon.duration = time + 3;
//			sprint(other, "You already control a Painkeep Cube - you must use it or change weapons.\n");
			return;
		}
		if (other.eweapon.wad == "morph_cube")
		{
			if (other.eweapon.duration > time) return; // debouncer
			other.eweapon.duration = time + 3;
//			sprint(other, "You already merged with an ");
//			sprint(other, other.eweapon.netname);
//			sprint(other, " - you must use it or change weapons.\n");
			return;
		}
	}

	if (self.wad == "morph_cube")
	if (!MORPH_FREE || self.mcode == -666)
	if (other.archon < ARCHON_MORPH_MIN) //not enough power yet
	{
		if (self.theowner != other) // debounce
			stuffcmd(other, "hud_message \"You need more Archon power for Evolution\"\n");
//			sprint(other, "You need more Archon power for Evolution.\n"); // IMP: hud_message
		self.theowner = other;
		return;
	}

	if (self.duration < time) // dont let bots hit cube too much
	if (other.class_select == "class_bot")
	{
		self.duration = time + 2;
		if (self.wad == "pk_cube")
		if (random() < BOT_NOUSE_PKCUBE) return;

		if (self.wad == "morph_cube")
		if (random() < BOT_NOUSE_MCUBE) return;
	}

//	if ((self.wad == "morph_cube") && (self.mcode != -666))
//	{
//		sprint(other, "you merged with this ");
//		sprint(other, self.netname);
//	}
//	else
//	if (self.wad == "pk_cube")
//		sprint(other, "You control this Painkeep Cube");
//	sprint(other, "! ");
//	if (self.wad == "pk_cube")
//		sprint(other, "hit fire to open - you must be in range");
//	else
	if (self.wad == "morph_cube")
	{
		other.cnt = -1;
		other.state = other.morphy; // set morph_lock
		if (other.class_select == "class_player") // not a bot
		{
 // you wont see this sequence because of morph menu display

//			if (self.mcode != -666) // poly spell - no cube instruction
//			if (autocvar_it_cubes_info)
//			if ((autocvar_it_cubes_info < 0) || (! autocvar_it_cubes_morph))
//			stuffcmd(other, "exec cfg/menu/instr_morph_cube.cfg\n");

			stuffcmd(other, "exec cfg/hook_release.cfg\n"); // make sure they have wheel select here

			other.impulse = 10; // display first item
			self.lefty = 8388608; // start bit will be 1
			if (self.ammo_nails != FL_MONSTER)
			{
				stuffcmd(other, "usergamma\n");
				stuffcmd(other, "admin_centertime\n");
//				admin_timer(FALSE, USER_TIMEOUT);
			}
		}
	}
	else
		if (other.class_select == "class_player") // not a bot
		if (autocvar_it_cubes_info)
		if ((autocvar_it_cubes_info < 0) || (! autocvar_it_cubes_pk))
			stuffcmd(other, "exec cfg/menu/instr_pk_cube.cfg\n");

	if (other.class_select == "class_player")
	if (cvar("r_ambient") > 0)
		other.light_lev = cvar("r_ambient"); // because of cube re-arm

//	if (self.mcode != -666)
//	sprint(other, "\nIf you select another weapon the item will be free...\n");
	self.owner = other;
	other.prevweapon = other.weapon; // save for pack on morphic
	other.theowner = other.eweapon;

	self.style = FL_MELEE_WEP; // use melee frames - they look better
	self.eweapon = self;

	other.weapon = 0;
	e = other.eweapon = self;
	self.effects = self.effects | EF_DIMLIGHT;
	self.touch = SUB_Null;

	self.think = abandoned_cube;
	self.count = time + 60 + random() * 10; // abandoned then
	self.nextthink = time + 3 + random();

	if (other.class_select == "class_bot")
	{
		self.owner = world; // clear this now, only used for messages
		self = other;
		if (self.eweapon.wad == "pk_cube")
			painkeep_cube_use();
		else if (self.eweapon.wad == "morph_cube")
		{
			local float sf;
			sf = 17;
			while ((self.state == self.morphy) && (sf > 0))
			{
				self.lefty = rnd_bit_mask(self.eweapon.mask_x);
				self.state = cb_morph(self.lefty);
				sf = sf - 1;
			}
			polymorph_check(self.state, 0);

			if (!MORPH_FREE)
			if (self.state == self.morphy)
				self.archon = self.archon - e.archon; // bot archon pts

			remove(e);
			cube_rearm();
		}
		self = e;
		return;
	}
};

/*QUAKED func_pk_cube  (0 .5 .8) (-16 -16 0) (16 16 32)
--------  CAT  --------

to use as map item - they will respawn
wad = "pk_cube"

"items" - mapcode of item to create
"stdev" - add random this to items mapcode for a custom series

nothing - pick a random item from pk_cube list
*/
void() pk_cube =
{
	setmodel(self, "progs/pk_cube.bsp");
	self.mdl = self.model;
	self.netname = "Painkeep Cube";
	self.touch = painkeep_touch;
	self.pk_touch = cube_touch;
	self.noise = "items/r_item2.wav";
	self._attack = painkeep_cube_use; // fire button to use
	self._fr_attack = SUB_Null;
	self.attack_finished = 3;
	self.mask_x = MORPH_ALL;

	self.punchangle = '210 210 240'; // for ejector
//	item_eject(self, '210 210 240'); // done by pk_place_item with punchangle set

	setsize (self,'-16 -16 0','16 16 32');
	StartItem ();

};

// map item wrapper (so  radiant doesnt have the one pk_ entry)

void() func_pk_cube =
{
	pk_cube();
};

void() crate_touch =
{
// idea - open a crate in 2 harpoon hits
	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return;
	}

	if (other.class_select == "class_bot")
		return;

	if (other.health <= 0)
		return;

	if (self.duration > time) return;

	self.duration = time + 2 + random();

	if (self.deathtype != null_string) // custom touch message for map crates - .message is opened string
	{
		centerprint(other, self.deathtype);
		return;
	}

	if (!self.cnt)
		centerprint(other, "Hit (or shoot) the crate to bust it open\n");
	else if (random() < 0.5)
		centerprint(other, "Come on bust 'er open\n");
	else if (random() < 0.5)
		centerprint(other, "This crate could have a BFG in it!\n");
	else if (random() < 0.5)
		centerprint(other, "Contents: stuff\n");
	self.cnt = self.cnt + 1;

	if (self.cnt > 4) self.touch = SUB_Null;
};

void() crate_init =
{
	if (!deathmatch)
	if (self.classname == "func_crate") // dont respawn
	{
		remove(self);
		return;
	}

// make it openable
	self.solid = SOLID_BBOX; // block, can climb on
	self.health = 50 + random() * 50;
	self.th_die = painkeep_cube_use;
	self.takedamage = DAMAGE_AIM;
	self.touch = crate_touch;
	self.cnt = 0;
	setmodel(self, self.mdl); // for respawn crates

/*
	if (random() < 0.5)
		self.noise = "chaos/crate1.wav";
	else
		self.noise = "chaos/crate2.wav";
*/

	self.think = self.th_stand;
	self.nextthink = time + 30 + PK_CUBE_TIME + random() * PK_CUBE_DV;
};

void() pk_crate =
{
	setmodel(self, "progs/crate.bsp");

	if (random() < 0.11)
		setmodel(self, "progs/crate_lg.bsp");

	self.mdl = self.model;
	self.netname = "Crate";
//	self.noise = "chaos/crate1.wav";

	item_eject(self, '180 180 210');

	self.touch = crate_touch;
	self.th_stand = SUB_Remove;
	self.think = crate_init; // think to this so we can toss it out and then solidify it
	self.nextthink = time + 1 + random();
	AddToSplashBig(self); // Cataboligne - 11.12.13 - crates werent in this - no splash & no solid checks
};

/*QUAKED func_crate  (0 .5 .8) (-16 -16 0) (16 16 32) LARGE RESPAWN REMOVE
--------  CAT  --------

Breakable crates for your map

LARGE - large crate = dimensions (-32 -32 0) (32 32 64)
RESPAWN - respawn this crate
REMOVE - remove items made after dynamic timeout

-------- NOTES --------

"target" - points to info_notnull with additional crate item flags
			- these can chain for multi item crates
         - wad = "pk_crate"

nothing - pick a random item from pk_cube list

"message" - string to center print after crate is opened
"deathtype" - string to center print when crate is touched - over rides crate generic touch messages

"items" - mapcode of item to create
"stdev" - add random this to items mapcode for a custom series

"map" - used as spawn func - i.e. monster_dog, weapon_lightning, etc.

"wait" - use func_make codes = special value listed below

"mean" - set time for removal if selected in flags

special values of .wait - select random item from:
-1 = q1 items, no runes if RUNES
-2 = q1 items, ignore RUNES
-3 = pk items, no art if !PK_ART
-4 = pk items, ignore PK_ART
-5 = all items, ignoring rules

-6 = doom items
-7 = wolf items
-8 = q2 items
-9 = q3 items

-10 = monsters, bit mask in mask, or by map_code once they are done
						.cnt = % chance of mask_y monster over mask_x if both
*/


void() func_crate =
{
	precache_model ("progs/crate.bsp");
	precache_model ("progs/crate_lg.bsp");
	precache_model ("progs/crate_lg_o1.bsp");
	precache_model ("progs/crate_o1.bsp");
	precache_model ("progs/crate_o2.bsp");
	precache_model ("progs/crate_o3.bsp");

	setmodel(self, "progs/crate.bsp");
	if (self.spawnflags & 1)
		setmodel(self, "progs/crate_lg.bsp");
	self.mdl = self.model;

	if (self.spawnflags & 2)
		self.th_stand = crate_init;
	else
	{
		self.th_stand = SUB_Null; // used for doing things besides regen
		self.event = "dynamic_item"; // just in case?
//		pk_ditems = pk_ditems + 1; // just became dyn item - but, this ent doesnt sub_regen, so nevermind
	}

	self.wad = "pk_crate";
	self.netname = "Crate";
	self.touch = crate_touch;
//	self.noise = "chaos/crate1.wav";

// make it openable
	self.solid = SOLID_BBOX; // block, can climb on
	self.health = 50 + random() * 50;
	self.th_die = painkeep_cube_use;
	self.takedamage = DAMAGE_AIM;
	AddToSplashBig(self); // Cataboligne - 11.12.13 - crates werent in this - no splash & no solid checks
};



// all quake 1 key load outs

/*QUAKED item_keyX (0 .5 .8) (-16 -16 -24) (16 16 32)

Any key on any map!

cnt - key code

GOLD key = 20
SILVER key = 10

		+

0: medieval
1: metal
2: base
*/

void (float ksv) item_keyX =
{
	float ks;

	ks = ksv;
	if (self.cnt) ks = self.cnt;
//	else self.cnt = ksv;

	if (ks == 10)
	{
		setmodel (self,"progs/w_s_key.mdl");
		self.netname = "silver key";
		self.items = IT_KEY1;
		if (self.event == "dynamic_item")
			self.wad = "item_key1_0";
		else
		self.classname = "item_key1_0";
	}
	else if (ks == 11)
	{
		setmodel (self,"progs/m_s_key.mdl");
		self.netname = "silver runekey";
		self.items = IT_KEY1;
		if (self.event == "dynamic_item")
			self.wad = "item_key1_1";
		else
		self.classname = "item_key1_1";
	}
	else if (ks == 12)
	{
		setmodel (self,"progs/b_s_key.mdl");
		self.netname = "silver keycard";
		self.items = IT_KEY1;
		if (self.event == "dynamic_item")
			self.wad = "item_key1_2";
		else
		self.classname = "item_key1_2";
	}
	else if (ks == 20)
	{
		setmodel (self,"progs/w_g_key.mdl");
		self.netname = "gold key";
		self.items = IT_KEY2;
		if (self.event == "dynamic_item")
			self.wad = "item_key2_0";
		else
		self.classname = "item_key2_0";
	}
	else if (ks == 21)
	{
		setmodel (self,"progs/m_g_key.mdl");
		self.netname = "gold runekey";
		self.items = IT_KEY2;
		if (self.event == "dynamic_item")
			self.wad = "item_key2_1";
		else
		self.classname = "item_key2_1";
	}
	else if (ks == 22)
	{
		setmodel (self,"progs/b_g_key.mdl");
		self.netname = "gold keycard";
		self.items = IT_KEY2;
		if (self.event == "dynamic_item")
			self.wad = "item_key2_2";
		else
		self.classname = "item_key2_2";
	}
	else
	{
		setmodel (self,"progs/w_s_key.mdl");
		self.netname = "silver key";
		self.items = IT_KEY1;
		if (self.event == "dynamic_item")
			self.wad = "item_key1_0";
		else
		self.classname = "item_key1_0";
	}
	if (ks == 10 || ks == 20)
	{
		self.noise = "misc/medkey.wav";
	}
	else if (ks == 11 || ks == 21)
	{
		self.noise = "misc/runekey.wav";
	}
	else if (ks == 12 || ks == 22)
	{
		self.noise = "misc/basekey.wav";
	}
	else
	{
		self.noise = "misc/medkey.wav";
	}
	self.touch = key_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.mask_x = MORPH_ALL; // everyone can get keys
	StartItem ();
};

// generate a string for key on an x_item door (if netname not set on door) based on map mode & x_item bit

// for map mode door, self is door - .map is map mode code

string(float xi) x_key_print =
{
	local float xxi;
	local string drm;

	if (self.classname == "door") drm = self.map;

	xxi = xi;
	if (MAP_MODE == "D" || drm == "D")
	{
		xxi = xi & X_D_KEY_BIT;
		if (xxi & X_D_KEY_CRED) return ("Red card key");
		if (xxi & X_D_KEY_CBLUE) return ("Blue card key");
		if (xxi & X_D_KEY_CYEL) return ("Yellow card key");
		if (xxi & X_D_KEY_SKRED) return ("Red Skull key");
		if (xxi & X_D_KEY_SKBLUE) return ("Blue Skull key");
		if (xxi & X_D_KEY_SKYEL) return ("Yellow Skull key");
	}
	if (MAP_MODE == "Q2" || drm == "Q2")
	{
		xxi = xi & X_Q2_KEY_BIT;
		if (xxi & X_Q2_KEY_RED) return ("Red Key");
		if (xxi & X_Q2_KEY_BLUE) return ("Blue Key");
		if (xxi & X_Q2_KEY_PYRAMID) return ("Pyramid Key");
		if (xxi & X_Q2_KEY_CUBE) return ("Power Cube");
		if (xxi & X_Q2_KEY_PASS) return ("Pass Key");
		if (xxi & X_Q2_KEY_AIRSTRK) return ("Airstrike Target");
		if (xxi & X_Q2_KEY_DATACD) return ("Data CD");
		if (xxi & X_Q2_KEY_CDSPIN) return ("Data Spinner");
		if (xxi & X_Q2_KEY_CHEAD) return ("Commanders Head");
	}
	return(null_string);
};

// fn_make - make an item from map code value

// mc - map code
// vo - location, will randomize if = v0

// note: this makes respawnable items

void(float mc, vector vo, string wd) fn_make =
{
	local string sc;
	local entity e, sv;

	newmis = world;
	sv = self;
	sc = wd;
	if (sc == null_string)
		sc = item_by_mcode(mc);

	if (sc != null_string)
	{
		v1 = vo;
		if (vo == v0) // no origin sent, get random one around some other object
		{
			e = dyn_rndloc();
			if (!e) e = findradius(world.origin, 256000);
			if (!e) 
			{
#ifdef warning
				if (WARNING & 2) bprint("*** warning: fn_make could not find a random (or any) location - giving up\n");
#endifdef
				return; // crap - no location
			}
			v1 = e.origin + '0 0 16';
			if (e.flags & FL_ITEM) // randomize away from other map items
				v1 = stdv_rndloc(e.origin + '0 0 16', 50, 100);
		}

		newmis = self = spawn();

		self.wad = sc;

		setorigin(self, v1);
		item_call(sc);

		item_eject(self, GEN_BOUNCE);

		if (self.map == "rune") self.map = null_string; // rune server deal

	  if (DYN_SHOW)
	  {
			bprint("\b*** fn_make item spawned: ");
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

		self = sv;

	}
#ifdef warning
	else if (WARNING & 2)
	{
		bprint("\b *** fn_make: map code or func call with no item translation:\n");
		bprint(" -------------->  ");
		bprint(ftos(mc));
		if (wd)
		{
			bprint(" - func: ");
			bprint(wd);
		}
		bprint("\n");
	}
#endifdef
};

/*QUAKED func_make (0 .5 .8) (-8 -8 -8) (8 8 8) RNDLOC RESPAWN REMOVE OLREM
--------  CAT  --------
Cataboligne - 6.13.10

spawn a mapcode item

RNDLOC (spawnflags = 1) - use a random location
RESPAWN - items created will respawn, unless monsters
REMOVE - remove this item with dyn_remove
OLREM - use old remove, even if not a monster

wait: any valid mapcode - see mcode.qc for details, or one of these special values
      -1 - spawn a random q1 ent, ignores runes if server on
      -2 - spawn any random q1 ent
      -3 - spawn a random pk ent, ignores plus if turned off
      -4 - spawn any random pk ent
      -5 - spawn any random ent

      -6 = doom items
      -7 = wolf items
      -8 = q2 items
      -9 = q3 items
      -10 = monsters by mask shown below

count: if not 0 spawn this many items and go away
       if delay is 0 this will happen every 30 rels

delay: if not 0 wait this long and spawn another ent.
       you might want random locations for this

mean: time to dynamic removal - 180 sec default
stdev: deviation from removal time

--- monster bits ---

if more than one bit is set monsters will be selected randomly
cnt = % chance of mask_y monster over mask_x if both set, default = 0.3, 30%

mask_x:

ARMY				= 1
FISH				= 2
KNIGHT			= 4
DOG				= 8
DEMON				= 16
ENF				= 32
HKNIGHT			= 64
OGRE				= 128
SHALR				= 256
SHAMBL			= 512
SCRAG				= 1024
ZOMBY				= 2048
CTHON				= 4096 // boss
TARBABY			= 8192
SCOURGE			= 16384
SHUBS				= 32768
SVORE				= 65536 // super vore
GREMLIN			= 131072
VOMIT				= 262144 // guy id left out

mask_y:

BLARG				= 1
RAPTOR			= 2
SPIDER			= 4
MANGA				= 8
BOSSMAN			= 16
*/
  
void() func_make =
{
	local float d, f;

	if (self.spawnflags & 1) self.origin = v0;

	d = self.wait;
	f = MC_RNDITM - 2;
	if (RUNES && self.wait == -1) f = MC_NR_RNDITM - 2; // dont rndize runes if server on
//	if (self.wait == -1 || self.wait == -2) 
	if (self.wait <=0)
		d = MC_SUPER_SHOTGUN + rint(random() * f); // now default

	f = MC_PK_RNDITM;
	if (PK_ART || self.wait == -4) f = MC_PKP_RNDITM;
	if (self.wait == -3 || self.wait == -4) d = MC_PULSE_NAILGUN + rint(random() * f);

	f = MC_D_RNDITM;
	if ((self.wait == -6) && ULOKD) d = MC_D_SAW + rint(random() * f);

	f = MC_W_RNDITM;
	if ((self.wait == -7) && ULOKW) d = MC_W_KNIFE + rint(random() * f);

	f = MC_Q2_RNDITM;
	if ((self.wait == -8) && ULOK2) d = MC_Q2_BLASTER + rint(random() * f);

	f = MC_Q3_RNDITM;
	if ((self.wait == -9) && ULOK3) d = MC_Q3_GAUNTLET + rint(random() * f);

//		if (RUNES) f = MC_NR_RNDITM - 2; // dont rndize runes if server on

	f = MC_T_RNDITM;
	if ((self.wait == -5) && XMOD)
	{
		d = MC_SUPER_SHOTGUN + rint(random() * f);
	}

	self.wad = null_string;
	if (self.wait == -10)
	{
		f = MON_FUNC_REG;
		d = rnd_bit_mask(self.mask_x);
		if (!d) // no mask_x monsters
		{
			if (!self.mask_y) d = rnd_bit_mask(MONSTER_Q1); // no mask_y - use any q1 monster
			else
			{
				d = rnd_bit_mask(self.mask_y);
				f = MON_FUNC_II;
			}
		}
		else
		if (self.mask_y)
		{
			if (!self.cnt) self.cnt = 0.3;
			if (random() < self.cnt)
			{
				d = rnd_bit_mask(self.mask_y);
				f = MON_FUNC_II;
			}
		}
		self.classname = self.wad = monster_id(d, f); // get spawn func - note: will not be dyn_monster
		d = 0;
	}

	fn_make(d, self.origin, self.wad);

	if (!self.spawnflags & 2)
	if (newmis.class_select != "class_monster")
	{
		newmis.event = "dynamic_item";
		pk_ditems = pk_ditems + 1; // do here because call already made
	}

	if (self.spawnflags & 12)
	{
		f = self.mean;
		if (!f) f = 180; // FUNC_MAKE_DFRTO = 180

		if (newmis.class_select == "class_monster" || (self.spawnflags & 8))
			dyn_remove(newmis, f + (crandom() * self.stdev), dyn_rem); // monsters think & have to go old style
		else
			dyn_remove(newmis, f + (crandom() * self.stdev), SUB_Null);
	}

	if (newmis) // make sure we made it
	if (self.charmer) // IDEA: if targeted this func could easily spawn charmed monsters just by detecting targeting player
	{
		newmis.charmer = self.charmer;
		newmis.charmed = 1;
	}

//	if (newmis.flags & FL_MONSTER)
//		spawn_tdeath(newmis.origin, newmis); // issue: has eject velocity - flag isnt set till *_go think

	if (self.button4 != -666)
// dont make  non melee items under this rule
	if (TR_ALL == FL_TR_MELEE) item_translate(self, TR_ALL);


	if (self.count > 0)
	{
		if (self.count > 0)
		if (self.delay < 1) self.delay = 30;
	
		self.count = self.count - 1;
		if (self.count < 1) self.delay = 0;
	}

	if (self.delay > 0)
	{
		self.nextthink = time + self.delay;
		self.think = func_make;
	}
};

// mcode for barrels

void(entity e, string md, float dm, float hl, float mt) misc_explodbox_set;


// fn(barrel_regen) - heh heh, respawn exploding boxes

void() barrel_regen =
{
	if (self.event == "dynamic_item")
	{
		remove(self);
		return;
	}
	SUB_regen();
	if (self.model == "progs/barrel.mdl")
		d_barrel();
	else
		misc_explodbox_set(self, self.mdl, self.currentammo, self.armorvalue, self.movetype);
	if (self.model == "progs/q2_barrel.mdl")
		setsize (self, '-16 -16 0', '16 16 40');
};

void() q2_barrel1 = [ 1, q2_barrel2 ] { self.nextthink = time + 0.05; };
void() q2_barrel2 = [ 2, q2_barrel3 ] { self.nextthink = time + 0.05; };
void() q2_barrel3 = [ 3, barrel_explode ] { self.nextthink = time + 0.05; };

// This fixes a bug in which barrel explosions cancel other explosions. - Patrick Martin - 9.14.97 - box fix

// TEST: is this true?  cound have been an engine bug in findradius long since fixed - need to investigate multiple radius damage in same frame

void() barrel_damage =
{
  setorigin(self, self.origin + '0 0 32');
//	Explode(0, bdmg, e, 0, 0, BecomeExplosion); // chaos mod replacement for this code
	T_RadiusDamage (self, self, self.dmg, world);
//  self.effects = self.effects | EF_MUZZLEFLASH;
	BecomeExplosion ();
}

void() barrel_explode =
{
	local entity boombox;
//	local vector flg;
	local float bdmg;
	local string bsnd;

	self.mdl = self.model;
	self.solid = SOLID_NOT;
	self.model = null_string;
	
	bdmg = self.currentammo;
	bsnd = self.noise;
	self.takedamage = DAMAGE_NO;

//	e = world;
//	if (self.classname == "chaos_item") e = self.owner; // this made no sense in the chaos code - it meant owner gets direct damage!


	boombox = spawn();
	boombox.origin = self.origin;

	boombox.takedamage = DAMAGE_NO;
	boombox.classname = "explo_box";

	sound (boombox, CHAN_VOICE, bsnd, 1, ATTN_NORM);
	particle (boombox.origin, '0 0 0', 75, 255); // ?? realli
//	boombox.origin_z = boombox.origin_z + 32;
//	Explode(0, bdmg, e, 0, 0, BecomeExplosion); // chaos mod replacement for this code
//	T_RadiusDamage (boombox, boombox, bdmg, world);
//	BecomeExplosion ();
	boombox.dmg = bdmg;
	boombox.think = barrel_damage;
	boombox.nextthink = time + 0.2;


//	if (self.classname == "chaos_item" && random() > CI_EXPLBOX_RES)
//		self.think = SUB_Remove;
//	else
	if (!deathmatch || deathmatch == 2 || deathmatch == 4)
		SUB_Remove();
//	else if (self.th_stand != SUB_Null && self.th_stand != (void()) 0)
	else if (self.th_stand != SUB_Null && self.th_stand)
		self.th_stand();
	else
	if (EXPLBOX_RESP)
	{
		self.nextthink = time + RSP_TIME;
		self.think = barrel_regen;
	}
	else
		SUB_Remove();
};



// Chaos code
// fn(misc_explobox_set) - set data for explode box...dang, can we get a doom barrel? - enhanced for chaos items as noted below
// e - entity to set, create if null
// md - string for model 					def: "maps/b_exbox2.bsp" (yes this could be _anything_)
// dm - damage for explosion				def: 100
// hl - health of box						def: 20
// mt - move type

void(entity e, string md, float dm, float hl, float mt) misc_explodbox_set =
{
	local float	oldz;

//	map_precache();
	precache_model ("maps/b_explob.bsp");
	precache_model ("maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");

//	if (e == world) e = spawn();
	if (e == world) return;

//	e.class_select = "class_explosive";
	e.solid = SOLID_BBOX;
	e.movetype = mt; // NOTE: movetype is why an explodbox cant be picked up

	if (md != null_string)
	{
		setmodel (e, md);
		e.mdl = md;
	}
	else
	{
		setmodel (e, "maps/b_exbox2.bsp");
		e.mdl = "maps/b_exbox2.bsp";
	}

	if (hl > 0)
		e.health = hl;
	else
		e.health = 20;
	e.armorvalue = e.health; // for respawns

	if (dm > 0)
		e.currentammo = dm;
	else
		e.currentammo = 100;

	e.th_stand = SUB_Null; // used for doing things besides regen
	e.th_die = barrel_explode;
	e.takedamage = DAMAGE_AIM;
	e.noise = "weapons/r_exp3.wav";

//	if (map_load_flg | FL_MAPITEM) // loading on map
//	{
	e.origin_z = e.origin_z + 2;
	oldz = e.origin_z;
//	droptofloor(0,0); // likely only works on self
	if (oldz - e.origin_z > 250)
	{
#ifdef warning
		if (WARNING)
		{
			bprint ("Barrel fell out of level at ");
			bprint (vtos (self.origin));
			bprint ("\n");
		}
#endifdef

		dtf_handle(); // randomize somewhere on level
	}
//	map_load_flg = map_load_flg - (map_load_flg | FL_MAPITEM);
//	}
	pic_test();

	if (self.wad == "q1")
		master_item_control(self, 0);

	if (deathmatch)
	if (EXPLBOX_RESP < 0) // new mode 2.25.11
	{
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}
};


/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void () misc_explobox =
{
//	local float oldz;

//		q10-_misc_explobox();

	misc_explodbox_set(self, "maps/b_explob.bsp", 160, 20, MOVETYPE_NONE);
	droptofloor(0,0);
	if (self.class_select == null_string) self.class_select = "quake_item";
};

/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void () misc_explobox2 =
{
//	local float oldz;

//		q10-_misc_explobox2();

	misc_explodbox_set(self, "maps/b_exbox2.bsp", 160, 20, MOVETYPE_NONE);
	droptofloor(0,0);
	if (self.class_select == null_string) self.class_select = "quake_item";
};

// rndize (or map item) created pack

void() rnd_pack_ammo = 
{
	local float f, k;

// clear old values - there may be some items this musses up (like doom & q2 packs? - I think not)
	self.ammo_nails = self.ammo_rockets = self.ammo_cells = self.ammo_bullet = self.ammo_slug = self.ammo_gaspr = 0;
	self.pk_gravitywellammo = self.pk_turretammo = self.pk_canpabammo = self.pk_beartrapammo = self.pk_explode_ammo = 0;
	self.pkplus_egoammo = self.pkplus_tombammo = self.pkplus_actorammo = self.pkplus_phoneammo = 0;

	f = rint(random() * 6);
	k = rint(random()) + 1;
	if (f == 0) self.ammo_bullet = 50 * k;
	else if (f == 1) self.ammo_shells = 50 * k;
	else if (f == 2) self.ammo_cells = 100 * k;
	else if (f == 3) self.ammo_rockets = 35 * k;
	else if (f == 4) self.ammo_nails = 100 * k;
	else if (f == 5) self.ammo_slug = 20 * k;
	else if (f == 6) self.ammo_gaspr = 100 * k;

	if (random() < 0.3)
	{
		f = rint(random() * 10);
		k = rint(random() * 2) + 1;
		if (f == 0) self.pk_gravitywellammo = 1;
		else if (f == 1) self.pk_turretammo = k;
		else if (f == 2) self.pk_beartrapammo = k;
		else if (f == 3) self.pk_explode_ammo = 5 * k;
		else if (f == 4) self.pkplus_egoammo = 1;
		else if (f == 5) self.pkplus_tombammo = 2;
		else if (f == 6) self.pkplus_phoneammo = 1;
		else if (f == 7) self.pk_canpabammo = 1;

		f = rint(random() * 13);
		k = rint(random() * 2) + 1;
		if (f == 0) self.pk_gravitywellammo = 1;
		else if (f == 1) self.pk_turretammo = k;
		else if (f == 2) self.pk_beartrapammo = k;
		else if (f == 3) self.pk_explode_ammo = 5 * k;
		else if (f == 4) self.pkplus_egoammo = 1;
		else if (f == 5) self.pkplus_tombammo = 2;
		else if (f == 6) self.pkplus_phoneammo = 1;
		else if (f == 7) self.pk_canpabammo = 1;
	}
};

void() fn_bpack_seq;

//  - may want to set wait to -666 for map loaded pack spawner
// - delay != 0, ammo set by map fn, dont randomize
// - small chance of an exploding pack

void() fn_backpack =
{
	if (!self.ammo_shells) self.ammo_shells = 5; // so pack gets made

	if (self.wait != -666) // rndized map item
	{
		rnd_pack_ammo();
// hide converted item - its now a pack spawner
		self.touch = SUB_Null;
		setmodel (self,null_string);
		chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, null_string, null_string, SUB_Null, 120, fn_bpack_seq, SUB_Null, self, world);
	}
	else
	{
		if (!self.delay) rnd_pack_ammo();
// make new pack when old expires
		self.think = fn_backpack;
		self.nextthink = newmis.nextthink;
	}

	DropBackpack(); // create a backback as newmis, set stats

	if (random() < 0.06)
	{
		misc_explodbox_set(newmis, "progs/backpack.mdl", 10 + random() * 20, 5 + random() * 10, MOVETYPE_TOSS);
		newmis.touch = barrel_explode;
		newmis.th_stand = SUB_Remove; // dont want to regen
	}
};

// so items from rndize can keep spawning packs

void() fn_bpack_seq =
{
	if (self.owner.model != null_string) // done with pack spawning - go away
	{
		remove(self);
		return;
	}

	fn_backpack();
	self.nextthink = newmis.nextthink;
};
