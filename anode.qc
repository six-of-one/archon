/* ::-::
 *
 * Cataboligne
 *
 * file: m-anode.qc
 *
 * date: 9/20/11
 *
 * qc - anode independent game
 *
 */

// test - move grid monster from hiding to target one

void() grid_m_think =
{
	self.nextthink = time + 10 + random() * 30;

	if (!self.movetarget2)
		self.movetarget2 = find(world, targetname, self.target);

	if (!self.movetarget2) return; // no where to go

	if (self.movetarget2.classname == "player" || self.movetarget2.flags & FL_CLIENT)
	{
		self.movetarget2 = world;
		return;
	}

	if ( (self.origin_x != self.movetarget2.origin_x) || (self.origin_y != self.movetarget2.origin_y) )
	{
		setorigin(self, self.movetarget2.origin + ' 0 0 2');
	}
	else
		setorigin(self, self.finaldest);
};

void() grid_monster_start =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;

	self.finaldest = self.origin;

	self.think = grid_m_think;
	self.nextthink = time + 10 + random() * 30;
};

void(float ign) monster_grid =
{

if (ign != A_MONSTER)
{
	if (!M_MONSTER & CB_M_SCRAG)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound ("wizard/widle1.wav");
	precache_sound ("wizard/widle2.wav");
	precache_sound ("wizard/wpain.wav");
	precache_sound ("wizard/wsight.wav");
}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/wizard.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 20;

	self.th_stand = wiz_stand1;
	self.th_walk = SUB_Null; // wiz_walk1;
	self.th_run = SUB_Null; // Wiz_run1;
	self.th_missile = SUB_Null; // Wiz_Missile;
	self.th_pain = SUB_Null; // wiz_Pain;
	self.th_die = wiz_die;

	flymonster_start ();
	grid_monster_start ();

}