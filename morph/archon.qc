/* ::-::
 *
 * Cataboligne
 *
 * file: m-cthon.qc
 *
 * date: 9/29/13
 *
 * qc - support chaos mod archon being
 *
 */
 
 // return an archon to its previous form, previous morph or human state if archon power is ever < 0

// fn(de_archon_thk) - keep checking to see when an Archon has enough power to return to archon form, return is automatic

void() de_archon_thk =
{
	if (self.owner.archon > CHAOS_BEAM_MIN)
	{
		if (self.owner.goalentity == self) self.owner.goalentity = world;
		polymorph_check(self.owner.height, 0);
		remove(self);
	}
	else
	if (self.owner.disconnectPlayer)
		remove(self);
	else
		self.nextthink = time + 10;
};

// lost power - no longer a god among mortals - he can be  hurt, even killed now

void(entity e) de_archon =
{
	newmis = self;
	self = e;

	if (self.state == 0) self.state = IMP_MHUMAN;
	if (self.state == IMP_MCHAOS) self.state = IMP_MHUMAN;
	else if (self.state == IMP_MORDER) self.state = IMP_MHUMAN;
	polymorph_check(self.state, 0);

	self.goalentity = chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "archon_morph", "", SUB_Null, 10, de_archon_thk, SUB_Null, self, world);
	self = newmis;
};