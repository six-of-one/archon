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

void(vector org) grid_m_shot =
{
	fire_missile(2000, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + v_forward * VWX_LASER, org, "laser", "progs/laser_m.mdl", "enforcer/enfire.wav", Laser_Blast, 5, SUB_Remove, Laser_Blast);
	newmis.skin = 1;
	newmis.frame = 10;
	newmis.effects = EF_DIMLIGHT;
};

// target 1 to target 2
void() grid_m_hidenpeek;

void() grid_m_port =
{
	self.movetarget2 = find(world, targetname, self.target2);

	if (!self.movetarget2)
	{
		self.think = grid_m_hidenpeek;
		self.nextthink = time + 10 + random() * 30;

		return; // no where to go
	}

	if (self.movetarget2.classname == "player" || self.movetarget2.flags & FL_CLIENT)
	{
		self.think = grid_m_hidenpeek;
		self.nextthink = time + 10 + random() * 30;

		return;
	}

	setorigin(self, self.movetarget2.origin + ' 0 0 2');

};

// test - move grid monster from hiding to target one
float GRID_M_DOT = 0.2; // pretty tight for now

void() grid_m_hidenpeek;

void() grid_m_attack1 =
{
	local vector v;
	local float f;

	self.nextthink = time + 0.2;
	if (self.delay < time)
	{
		self.think = grid_m_hidenpeek;
	}
	if (!self.enemy) self.enemy = find(world, classname, "player");

	if (self.currentammo > 0)
	if (self.attack_finished < time)
	if (self.enemy)
	{
		v = self.angles;
		v_x = 0; // no pitch yet
		makevectors(v);
		f = infront (self.enemy, GRID_M_DOT, v_forward, v0);
		if (f)
		if (random() < 0.5)
		{
			grid_m_shot(v_forward);
			self.currentammo = self.currentammo - 1;
			self.attack_finished = time + 2;
		}
	}
	
};

void() grid_m_hidenpeek =
{

	self.nextthink = time + 10 + random() * 20;

	if (!self.movetarget2)
		self.movetarget2 = find(world, targetname, self.target);

	if (!self.movetarget2) return; // no where to go

	if (self.movetarget2.classname == "player" || self.movetarget2.flags & FL_CLIENT)
	{
		self.movetarget2 = world;
		return;
	}

	if (self.cnt <= 0) self.cnt = 2 + rint(random() * 2);

	if ( (self.origin_x != self.movetarget2.origin_x) || (self.origin_y != self.movetarget2.origin_y) )
	{
		self.cnt = self.cnt - 1;
		setorigin(self, self.movetarget2.origin + ' 0 0 2');
		if (self.cnt <= 0)
		{
			self.nextthink = time + 5 + random() * 3;
			self.think = grid_m_port; // go into grid
		}
		else
		{
			self.delay = time + 3 + random() * 3;
			self.nextthink = time + 0.2;
			self.think = grid_m_attack1;
		}
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
	self.cnt = 3 + rint(random() * 2);
	self.currentammo = 15 + random() * 15;
	self.frags = 100;

	self.think = grid_m_hidenpeek;
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