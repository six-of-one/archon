/* ::-::
 *
 * Cataboligne
 *
 * file: morph.defs.qc
 *
 * date: 9/14/11
 *
 * qc - support chaos mod morph ability
 *
 */

// tell server to allow morphs

float MORPHIC; // if 1 allow morphs and morphing, if > 1 - spawn this many morph cubes -1 (so 2 makes 1 cube)

float MORPH_CUBE_TIME; // time to spawn & respawn cubes
float MORPH_CUBE_DV;
float MORPH_FF;                             // true = allow morph friendly fire (ogre can hurt another ogre, etc.)
float MORPH_FLY;
float MORPH_HOOK; // morphs that have built in hook - mostly for jump & get stuck issues
float MORPH_CHAIN_LEN			= 320; // built in hook is for escape - shorter length
float MORPH_SARMOR; // morphs with healable (scourge) armor built in
float MORPH_BOT; // allow bots to morph -- 0 = no bots, 1 = frik bots, 2 = pk bots, 3 = all bots
float MORPH_FREE; // if true, no points to morph - all morph cube allows can be taken at will

.float morphy; // morphic code number from list below
.vector mask; // inventory a player can pickup by class - mask for item, class for player

float MORPH_ALL; //every morph bit in mask 1


// monsters in dm - so morphs have friends

entity random_monster_spawn;

float A_MONSTER				= -555777; // allow monsters in dm - monster_* called from code
float M_MONSTER; // bit mask to allow map monsters in dm
float S_MONSTER; // bit mask of monsters to respawn when dead (map monsters only, no random ones) - works in single player too!
float C_MONSTER; // bit mask of monsters to spawn randomly
float R_MONSTER				= 1; // if 1 and loading a map in dm, remove the monster ent - if 0 save for a live control update loop that can recreate the monster
float DM_MONSTER;	// true if any option allows monsters in dm
float HUB_MONSTER;	// true if monsters will appear on hub maps - "sv_monster_hub"

// monster enhancements

float ENH_Q1_MAP_MONSTERS 		= 1; // if true some q1 map monsters get weapon upgrades - grunt, enforcer

float MAP_LAVABABY				= 0.5; // chance map babys will be lava monsters
float RND_LAVABABY				= 0.3; // chance random babys will be lava monsters


// spike mine launcher  controls - mines are launched while idle

void() SShalSpikeMine;

float SV_SETMINE = 0.15; // chance to summon a spike mine
float SV_CKTIME = 15; // how frequently we check - 15 secs
float SV_MINELIM = 3; // max mines one monster can make

// supervore = 65536
// super 3x scrag = 1024
// death knight = 64
float SV_MINEALLOW = 66624; // allow monsters to set mines by bitmask


// fast and slow monsters
//void(float fst, float slw, string mcls, origin vm) fast_slow_monster;
void(string sp, string mcls, vector vm) speed_monster;

float FAST_MONSTER; // monster bits set here will always be fast monsters
float SLOW_MONSTER; // monster bits set here will always be slow monsters
float R_FAST_MONSTER; // randomly generate fast monsters when regular map monsters (of these bits) spawn
float R_SLOW_MONSTER; // randomly generate slow monsters when regular map monsters (of these bits) spawn
float C_FS_MONSTER; // chance to make a fast / slow monster

// speed contants for monsters
// slowing down too much or speeding up too much looks "funny" (admittedly chaotic tho), try to say in limits

float MON_NORM = 0.1; // base think speed for animation frames
float MON_FAST = 0.07; // 1.429 times faster
float MON_SLOW = 0.16; // 0.625 times slower
// divisor - divide monsters speed up by this value --- > 1 slows monsters, < 1 speeds up monsters
// shoot poison potions to slow monsters down
// note: this is a global effect that happens to all .speed controled monsters - .lip is an individual monster speed divisor
float MON_SPEED_DIV;

// super monsters have a chance to speed up on thier own during pain frames
float mon_superspeed_chn = 0.1; // chance per pain frame a super monster will speed up
float mon_superspeed_fact = 0.001; // speed up factor per instance
float mon_superspeedup_max = 0.085; // 1.176 times faster - max super monsters can speed up

string CFAST = "fast";
string CSLOW = "slow";

void(vector rdl) random_monster_location;

// remove map monsters in singleplayer when sv_monster_map < 0
void() remove_monster;

// these need to happen after other map spawn items & special server items
// secs to randomize monster removal spread on top of time + 2
float REMOVE_MON_SPREAD = 5;

// timings
float S_MONSTER_WAIT; // min wait till we respawn a dead mosnter
float S_MONSTER_DEV;

float C_MONSTER_WAIT; // how long till we spawn another random mosnter
float C_MONSTER_DEV;
float C_MONSTER_CNT;	// random monster total
float monster_rnd_cnt; // random monsters on level

float MONSTER_NOWAY	= 1; // if true kill monsters out of noway bounds - excludes flyers

void() lavaball_shot;
void(entity e) chaos_mdlsize;

// monster bit flags - still use mask_x
void() random_monster;
void() monster_respawn;

float MONSTER_MASK; // all monster bits
float MONSTER_Q1; // base q1 monster bits
float pk_monster_set; // admin var to store bits for setting monster values

string(float mb, float mode) monster_id;
void() random_monster_wakey;

entity monster_respawner;

float CB_M_ARMY					= 1;
float CB_M_FISH					= 2;
float CB_M_KNIGHT					= 4;
float CB_M_DOG						= 8;
float CB_M_DEMON					= 16;
float CB_M_ENF						= 32;
float CB_M_HKNIGHT				= 64;
float CB_M_OGRE					= 128;
float CB_M_SHALR					= 256; // + super vore ?
float CB_M_SHAMBL					= 512;
float CB_M_SCRAG					= 1024;
float CB_M_ZOMBY					= 2048;
float CB_M_CTHON					= 4096; // boss
float CB_M_TARBABY				= 8192;
float CB_M_SCOURGE				= 16384;
float CB_M_SHUBS					= 32768;
float CB_M_SVORE					= 65536; // super vore
float CB_M_GREMLIN				= 131072;
float CB_M_VOMIT					= 262144; // guy id left out
float CB_M_SPIKEMINE				= 524288;	// Hipnotic spiked mine

/*
float CB_M_					= 1048576;
float CB_M_					= 2097152;
float CB_M_					= 4194304;
float CB_M_					= 8388608;
*/

float MON_NAME_REG				= 0;
float MON_FUNC_REG				= 1;


// add in monster set from vars mods

float C_MONSTER_II_RND			= 0.6; // chance of spawning a monster from 2nd random mask

float M_MONSTER_II; // bit mask to allow map monsters in dm
float S_MONSTER_II; // bit mask of monsters to respawn when dead (map monsters only, no random ones) - works in single player too!
float C_MONSTER_II; // bit mask of monsters to spawn randomly

float MONSTER_MASK_II; // all monster 2 bits


float CB_M_BLARG					= 1;
float CB_M_RAPTOR					= 2;
float CB_M_SPIDER					= 4;	// first 3 featured in ultimate mod
float CB_M_MANGA					= 8;
float CB_M_BOSSMAN				= 16; // Bossman by Wendigo - from Blahbalicious
float CB_M_CLING					= 32; // alien infestation by Lord Havoc
float CB_M_HEXIMP					= 64;	// Hexen2 Imp by Claus Kruuskopf AKA WiCKeD

float MON_NAME_II					= 2;
float MON_FUNC_II					= 3;

// end monster spec section

/* special - will use something else
float CB_M_GUNNEY					= 64;
float CB_M_SUPTANK				= 128;
float CB_M_TANK					= 256;
float CB_M_IMP						= 2097152;
float CB_M_ARACHN					= 4194304;
float CB_M_CYBER					= 8388608;
*/

// selection
void() morph_cube;
void() morph_setup;
void() morphic_impulse;

// ops

void(float cmd, float pls) polymorph_check;
void(entity f, float all) morph_clearparms;
float(float sel) cb_morph;
float(entity chk) morph_clichk;
void() morph_die;
void(float r1, string sn, float lts ) morph_sound;

float(entity targ, float sdot, vector vang, vector vorg) infront;
float(entity ck, float hl) morph_heal;
//float(entity e) human_model;
void(string ws, float rtime ) morph_walksound;
float(entity o) morph_chasecam_fpv;

void(float dx) morph_CycleWeaponCommand;
float(entity e) shotgun_check;

.void() _stand;
.void(entity attacker, float take) _pain; // so we can use native monster calls
.void() _run;
.void() _impulse;
.float() _hk_lesser;
.float() _hk_major;
.void() _attack;
.void() _jump;
.float() _jump2;
.void() _die;
.void() _summon;
.string(entity targ, entity attacker) _killmsg;
.string(entity targ, entity attacker) _killmsg2;

.float modelindex_morph; // cant use a global when all players can use diff models

.float health_modifier;
.string msight;
.float soundlock; // limit some sounds - set to -1 to prevent idle / sight sounds
.float soundoff; // idle & sight sounds seem to repeat if you dont turn them off

.float builtin; // morph builtin wep mask

// impulses

float IMP_MFLY						= 15; // switch flight mode / ground mode
float IMP_MSIGHT					= 14; // shout out
float IMP_MSELECT					= 16; // select a morph

// inventory
float IMP_INV						= 53; // list inventory
float IMP_DROPI;
float IMP_DROPI_ACT				= 54; // drop inventory - activate impulse
.entity dropent;

// flag masks - how cube knows what to offer

float MORPH_ARCHON;

// morph bit flags

//archons
float CB_CHAOS						= 1;
float CB_ORDER						= 2;
//humans
float CB_HUMAN						= 4;
//medievals
float CB_SHAPESHIFT				= 8;
float CB_WRAITH					= 16;
float CB_DRAGON					= 32;
// q2
float CB_GUNNEY					= 64;
float CB_SUPTANK					= 128;
float CB_TANK						= 256;

//beasties
float CB_DEMON						= 512;
float CB_ENF						= 1024;
float CB_HKNIGHT					= 2048;
float CB_OGRE						= 4096;
float CB_SHALR						= 8192;
float CB_SHAMBL					= 16384;
float CB_SCRAG						= 32768;
float CB_ZOMBY						= 65536;
float CB_CTHON						= 131072;
float CB_GREMLIN					= 262144;
float CB_SCOURGE					= 524288;
// doom
float CB_IMP						= 2097152;
float CB_ARACHN					= 4194304; // mode bits = 4 modes
float CB_CYBER						= 8388608;


// code numbers - store in .morphy
// cant use 1, 2, 4, 8, 16, 32, 64, 128 ... etc

float IMP_MCHAOS					= 6;	// string STI_MCHAOS			= "impulse 6";
float IMP_MORDER					= 7;	// string STI_MORDER			= "impulse 7";
//float USE_PULSE_SPIKES			= -257368;
//Techs:
float IMP_MHUMAN					= 12;	// string STI_MHUMAN			= "impulse 12"; // NOTE: char_q - standard quake guy

//.float char_mode; // genre of player character - set by selection to vars morph states
// cant be 1, 2, 4, 8, 16, 32
float CHAR_W						= 10;
float CHAR_D						= 11;
float CHAR_Q						= 12;
float CHAR_PK						= 13;
float CHAR_Q2						= 14;
float CHAR_Q3						= 15;


float IMP_MSPECIAL				= 62;	// string STI_MSPECIAL		= "impulse 62";
float IMP_MTECH					= 63;	// string STI_MTECH			= "impulse 63";

// NOTE: 64 can NOT be used here - it matches the bit value 64

float IMP_MENG						= 65;	// string STI_MENG			= "impulse 65";
//Medieval:
float IMP_MSHAPESHIFT			= 69;	// string STI_MDEMO			= "impulse 61";
float IMP_MWRAITH					= 70;	// string STI_MWRAITH		= "impulse 70";
float IMP_MTHAM					= 71;	// string STI_MTHAM			= "impulse 71";
float IMP_MDRACON 				= 72;	// string STI_MDRACON		= "impulse 72";
float IMP_MTHIEF					= 73;	// string STI_MTHIEF			= "impulse 73";
float IMP_MJUMP					= 81; // jump over undefined morph states in select
//Quake 2:
float IMP_MGUNNEY			 		= 81;	// string STI_MGUNNEY		= "impulse 81";
float IMP_MTANK	 				= 82;	// string STI_MTANK			= "impulse 82";
float IMP_MSUPTANK				= 83;	// string STI_MSUPTANK		= "impulse 83";
//Doomer:
float IMP_MIMP	 					= 84;	// string STI_MIMP			= "impulse 84";
float IMP_MCYBER	 				= 85;	// string STI_MCYBER			= "impulse 85";
float IMP_MARACHN			 		= 86;	// string STI_MARACHN		= "impulse 86";
//Beastie:
float IMP_MENF	 					= 87;	// string STI_MENF			= "impulse 87";
float IMP_MZOMBIE					= 88;	// string STI_MZOMBIE		= "impulse 88";
float IMP_MWIZARD					= 89;	// string STI_MSCRAG			= "impulse 89";
float IMP_MOGRE					= 90;	// string STI_MOGRE			= "impulse 90";
float IMP_MHKNIGHT				= 91;	// string STI_MHKNIGHT		= "impulse 91";
float IMP_MSHALR					= 92;	// string STI_MSHALR			= "impulse 92";
float IMP_MSHAMBLR				= 93;	// string STI_MSHAMBLR		= "impulse 93";
float IMP_MDEMON					= 94;	// string STI_MDEMON			= "impulse 94";
float IMP_MCTHON					= 95;	// string STI_MCTHON			= "impulse 95";
float IMP_MDRAGON					= 96;	// string STI_MDRAGON		= "impulse 96";
float IMP_MSCOURGE				= 97;	// string STI_MSCOURGE		= "impulse 97";
float IMP_MGREMLIN_F				= 98;	// string STI_MGREMLIN		= "impulse 98"; // flying gremlin
float IMP_MGREMLIN_L				= 99;	// landlubber gremlin
float IMP_MVOMIS					= 100;// string STI_MCTHON			= "impulse 95";

// head skin map

float HEADSKN_Q					= 0;
float HEADSKN_W					= 1;
float HEADSKN_D					= 2; // 2;
float HEADSKN_PK					= 3;
float HEADSKN_Q2					= 4;
float HEADSKN_Q3					= 3; // 5;

// evolution
void(float silent) player_scourge_become;
void(float silent) player_shalrath_become;
void(float silent) player_enforcer_become;
void(float silent) player_demon_become;
void(float silent) player_zombie_become;
void(float silent) player_hknight_become;
void(float silent) player_wizard_become;
void(float silent) player_ogre_become;
void(float silent) player_shambler_become;
void(float silent) player_lavablob_become;
void(float silent) player_gremlin_become;

//morph health modifiers            original code
float MHUMAN_HEALMOD				= 1.0;	// 100 = 1.0
float MZOMBIE_HEALMOD			= 0.75;	// 60  = 0.6
float MSHALR_HEALMOD				= 3.0;	// 400 = 4.0
float MWIZARD_HEALMOD			= 2.0;	// 80  = 0.8
float MHKNIGHT_HEALMOD			= 2.50;	// 250 = 2.5
float MSHAMBLR_HEALMOD			= 4.0;	// 600 = 6.0
float MDEMON_HEALMOD 			= 5.0;	// 300 = 3.0
float MOGRE_HEALMOD				= 2.75;	// 200 = 2.0
float MSCOURGE_HEALMOD			= 3.0;	// 300 = 3.0
float MLAVAB_HEALMOD 			= 3.0;	// 300 = 3.0
float MENF_HEALMOD				= 1.2;	// 80  = 0.8 ?
float MCHAOS_HEALMOD				= 3.0;
float MGREMLIN_HEALMOD			= 1.2;
float MCYBER_HEALMOD				= 8.0;	// 4000 = 40.0 !!
float MARACHN_HEALMOD			= 4.0; 	// 500 = 5.0
float MIMP_HEALMOD				= 1.25;
float MGUNNEY_HEALMOD			= 3;
float MTANK_HEALMOD				= 7.5;
float MSUPTANK_HEALMOD			= 10.0;
float MWRAITH_HEALMOD			= 10.0;

float MAX_HEALTH					= 999; // max health for any thing - this limit is solely for std stats bar view
float MAX100						= TRUE; // use (add heal * healmod if .health < max * %) rule --- sv_
float MH_LOW						= 0.5; // low range morph healmod point (full boost below this * max)
float MH_HIGH						= 0.8; // high range morph healmod point (no boost above this * max, scaled below)
float CHAOS_H2_RET				= 0.1; // chance chaos will change form if health < 1/2 max



// vars

float MORPH_LOCK					= 1; // if true, once morph is selected, cubes are ignored.  impulse 50 toggles this

float WALKSOUND					= 1; // sv_

float ZOMBIE_FLSH_VEL			= 600;
float SCRAGG_SHT_VEL				= 800;
float SHALRATH_SHT_VEL			= 400;
float FIREBALL_WEP_VEL			= 300;

string DEF_MORPH_DEATH1			= " was killed by ";
string DEF_MORPH_DEATH2			= " some way, nobody knows for sure\n";

// gremlin

float ST_CLAW						= 1;
float ST_BITE						= 2;
float GREM_AASPAWN				= FALSE; // if true always allow monster gremlin to spawn in water
float GREM_MAX;                                 // = 64; // arbitrary - need per level cnt by mapname, moved to code
float GREM_FLY_MAXWEP			= 3; // cant fly with more than 3 weps - dont really want flyers heavily armed IDEA - use .mass
float FL_STEAL						= 524288; // flag for player stealing things

void(float st) W_FireClawBite;
void() gremlin_spawning;
void() gremlin_hover;
void() gremlin_takeoff;
float grem_fly_frame; // for proper viswep position while in flight
void(float cn) gremlin_spawn;

// lava

void(entity e) lavacthon_blobme;
void() lavablob_slimeflare;
float LEVEL_CTHON					= TRUE; // bring cthon up to lava level found in house of cthon
float hoc_level					= 16; // default house of cthon level
float NO_TFOG						= -2222; // no telefog when transforming
float(entity e) IS_LAVA;

//scourges

float (entity p, float heala, float ign) player_scourge_armor;
void() player_scourge_impulse;
void() player_scourge_attack;

float SCOURGE_ARMORMAX			= 100;
float GIVEARMOR					= 333;
float ARM_SCRG						= 0.35; // scourge morph built in def armor

// fiends

float DEMONBOOM_RADIUS			= 8192; // pent rune super blow - max radius
float DEMONBOOM_FALLOFF			= 512; // damage falloff beyond this

float FL_DEMONBOOM				= 65536; // demon on overload!
void() player_demon_explode;

// wratihs

float WRAITH_USE_CAM				= FALSE; // if true wraith can use chase cam - NOTE: cam does not work when wraith penetrates solids

// shambler, cyberd

float(entity o) BlastProof;

// humans

float(string mm) set_char_num;

float BIOSUIT						= 5; // skin 5 bio suit
float WETSUIT						= 6;
float RADSUIT						= 7;

float(entity e) IS_ZOMBIE;

// precaches

void() morph_precache;
void() m_precache_scourge;
void() m_precache_shalrath;
void() m_precache_enforcer;
void() m_precache_demon;
void() m_precache_zombie;
void() m_precache_hknight;
void() m_precache_wizard;
void() m_precache_ogre;
void() m_precache_shambler;
void() m_precache_lavablob;
void() m_precache_gremlin;
