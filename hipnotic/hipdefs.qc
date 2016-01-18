/* ::-::
 *
 * Cataboligne
 *
 * file: hipdefs.qc
 *
 * date: 2/13/11
 *
 * qc - support hipnotic
 *
 */

float MIN_ANGLE_DELTA		= 10;

float PROX_TIMER = 20; // proximity mine timer base, orig = 15 (+10 * rnd)
float PROX_MAX = 50; // orig = 15

float visible_distance;

.float struck_by_mjolnir;

void() player_laser1;

// wet suit controls
float discharged; 
void(float num_bubbles) DeathBubbles;
.float wetsuit_finished; // used by hip wetsuit & q2 rebreather

// horn of conjuring
float CHARMED_RADIUS = 1500;
float MAX_CHARMER_DISTANCE = 200;
float MIN_CHARMER_DISTANCE = 150;
float TOOCLOSE_CHARMER_DISTANCE = 120;
.float      charmed;
.entity     charmer;
.float      huntingcharmer;
float horn_active;
entity horn_charmer;

// spawn - used by native horn & hip map code
float SVC_UPDATESTAT = 3;
float STAT_TOTALMONSTERS = 12;

// spawn variables
.void()     spawnfunction;
.string     spawnclassname;
.float      spawnsolidtype;
.string     spawnmodel;
.void()     spawnthink;
.entity     spawnmaster;
.vector     spawnmins;
.vector     spawnmaxs;
.float      spawnsilent;
.float      spawnmulti;

// pathy shields
float empathy_dmg; // damage taken is from empathy shield reflection
.float empathy_finished;
.float empathy_time;
.float empathy_sound;

// scourge code
.void() th_turn; // NOTE - not really used
float AS_DODGING     = 5;
.float spawnsilent;
.float spawnmulti;

// hipnotic gremlin code
.float stoleweapon;
.float gorging;

// wall stains

float num_stains;

