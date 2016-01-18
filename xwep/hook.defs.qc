/*
		+---------------------------------------+
		|  hook code                            | SEC-HEAD
		+---------------------------------------+
*/

// Bort's swinging hook

// hook is now only used for limited z movement morphs (no / odd jump - zombie, scourge, lava) and flyers
// these morphs are likely to get in trouble spots where a limited range hook is a bonus

// this code will also cover laser hook

.float hook;

// hook bit flags
float HOOK_ON 					= 1;		// set if hook command is active
float HOOK_IN					= 2;		// set if hook has attached
float SHRINK_ON 				= 4;		// set if shrink chain is active
float GROW_ON 					= 8;		// set if grow chain is active
float MODE2 					= 16;		// Cataboligne MOD 9.10.3	

// impulse constants
float I_HOOK 					= 98;
float I_GROW 					= 97;
float I_SHRINK	 				= 96;
float I_STOP					= 95;

// Cataboligne MOD 9.10.3
// old style 1 key operation
float I_HOOK2 					= 94;

// constants
float MIN_CHAIN_LEN 			= 40;		// minimum chain length
float MAX_CHAIN_LEN;// 		= 1000;	// maximum chain length - now limited by code 256 game, 2000 test
float CHAIN_LINK_LEN			= 55;		// length between chain link origins

float GROW_RATE				= 16;
float SHRINK_RATE				= -20;

float HOOK; // give away - everyone gets a free hook
float HOOK_DMG;	// default hook damage
float HOOK_RANGE;
float HOOK_TIME;
float HOOK_URTO;
float HOOK_SPEED;
float HOOK_DAMP; //server option to prevent wild swings at end of hook ride
float HOOK_DAMPING 			= 0.5;

float LASER_HOOK; // used on q2 maps for give away hook, or q2_weapon_grapple
float LTN_HOOK; // ditto

float HOOK_OUT_FRM			= 5; // must be so - in all models that have hook out frames

float SEL_S_HOOK				= 70000; // standard hook behavior - for item hooks
float SEL_LTN_HOOK			= 78005; //let an item set ltn mode
float SEL_LASER_HOOK			= 718005; //let an item set laser mode

void() hook_dmg_check;
void() hook_precache;
void() CheckGrapHookJump;
