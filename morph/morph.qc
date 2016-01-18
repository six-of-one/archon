/* ::-::
 *
 * Cataboligne
 *
 * file: morph.qc
 *
 * date: 9/14/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
 // morphic method 1 - the cube

void() morph_cube_use =
{
	
};

void() morph_cube_touch =
{
	
};
 
void() morphic_cube =
{
	setmodel(self, "progs/morph_cube.bsp");
	self.netname = "Morphic Cube";
	self.touch = painkeep_touch;
	self.pk_touch = morph_cube_touch;
	self.noise = "items/r_item2.wav";
	self._attack = morph_cube_use; // fire button to use
	self._fr_attack = SUB_Null; // fire button to use
	self.attack_finished = 3;

	self.punchangle = ' 210 210 240'; // for ejector
//	item_eject(self, ' 210 210 240'); // done by pk_place_item with punchangle set

	setsize (self,'-16 -16 0','16 16 32');
	StartItem ();
};