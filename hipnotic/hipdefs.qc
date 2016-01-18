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

float PROX_TIMER = 20; // proximity mine timer base, orig = 15 (+10 * rnd)
float PROX_MAX = 50; // orig = 15

float discharged; // wet suit controls

.float struck_by_mjolnir;

void() player_laser1;


// wall stains

entity nullstain;
entity stain_set;
entity last_stain;

float num_stains;

