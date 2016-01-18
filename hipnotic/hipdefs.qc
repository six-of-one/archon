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

float discharged; // wet suit controls

float visible_distance;


.float struck_by_mjolnir;

void() player_laser1;

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

// scourge code
.void() th_turn; // NOTE - not really used
float AS_DODGING     = 5;

// hipnotic gremlin code
.float stoleweapon
.float gorging

// wall stains

entity nullstain;
entity stain_set;
entity last_stain;

float num_stains;

