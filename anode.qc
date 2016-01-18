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

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16


void() grid_m_attack1;

void() grid_m_walk1	=[	$walk1 ,	grid_m_walk2	] {
ai_walk(8);};
void() grid_m_walk2		=[	$walk1 ,		grid_m_walk3	] {ai_walk(8);};
void() grid_m_walk3		=[	$walk2 ,		grid_m_walk4	] {ai_walk(8);};
void() grid_m_walk4		=[	$walk3 ,		grid_m_walk5	] {ai_walk(8);};
void() grid_m_walk5		=[	$walk4 ,		grid_m_walk6	] {ai_walk(8);};
void() grid_m_walk6		=[	$walk5 ,		grid_m_walk7	] {ai_walk(8);};
void() grid_m_walk7		=[	$walk6 ,		grid_m_walk8	] {ai_walk(8);};
void() grid_m_walk8		=[	$walk7 ,		grid_m_walk9	] {ai_walk(8);};
void() grid_m_walk9		=[	$walk8 ,		grid_m_walk10	] {ai_walk(8);};
void() grid_m_walk10	=[	$walk9 ,		grid_m_walk11	] {ai_walk(8);};
void() grid_m_walk11	=[	$walk10 ,	grid_m_walk12	] {ai_walk(8);};
void() grid_m_walk12	=[	$walk11 ,	grid_m_walk13	] {ai_walk(8);};
void() grid_m_walk13	=[	$walk12 ,	grid_m_walk14	] {ai_walk(8);};
void() grid_m_walk14	=[	$walk13 ,	grid_m_walk15	] {ai_walk(8);};
void() grid_m_walk15	=[	$walk14 ,	grid_m_walk16	] {ai_walk(8);};
void() grid_m_walk16	=[	$walk15 ,	grid_m_walk17	] {ai_walk(8);};
void() grid_m_walk17	=[	$walk16 ,	grid_m_walk1	] {ai_walk(8);};

/*
void() grid_m_run1		=[	$run1  ,	grid_m_run2	] {ai_run(16);};
void() grid_m_run2		=[	$run1  ,	grid_m_run3	] {ai_run(32);};
void() grid_m_run3		=[	$run1  ,	grid_m_run4	] {ai_run(32);};
void() grid_m_run4		=[	$run1  ,	grid_m_run5	] {ai_run(20);};
void() grid_m_run5		=[	$run1  ,	grid_m_run6	] {ai_run(64);};
void() grid_m_run6		=[	$run1  ,	grid_m_run7	] {ai_run(32);};
void() grid_m_run7		=[	$run1  ,	grid_m_run8	] {ai_run(16);};
void() grid_m_run8		=[	$run1  ,	grid_m_run9	] {ai_run(32);};
void() grid_m_run9		=[	$run1  ,	grid_m_run10	] {ai_run(32);};
void() grid_m_run10	=[	$run1  ,	grid_m_run11	] {ai_run(20);};
void() grid_m_run11	=[	$run1  ,	grid_m_run12	] {ai_run(64);};
void() grid_m_run12	=[	$run1  ,	grid_m_run1	] {ai_run(32);};
*/

void() grid_m_run1		=[	$run1  ,	grid_m_run2	] {ai_run(10);};
void() grid_m_run2		=[	$run2  ,	grid_m_run3	] {ai_run(10);};
void() grid_m_run3		=[	$run3  ,	grid_m_run4	] {ai_run(10);};
void() grid_m_run4		=[	$run4  ,	grid_m_run5	] {ai_run(10);};
void() grid_m_run5		=[	$run5  ,	grid_m_run6	] {ai_run(10);};
void() grid_m_run6		=[	$run6  ,	grid_m_run7	] {ai_run(10);};
void() grid_m_run7		=[	$run7  ,	grid_m_run8	] {ai_run(10);};
void() grid_m_run8		=[	$run8  ,	grid_m_run9	] {ai_run(10);};
void() grid_m_run9		=[	$run9  ,	grid_m_run10	] {ai_run(10);};
void() grid_m_run10	=[	$run10  ,	grid_m_run1	] {ai_run(10);};


float GRID_M_DOT = 0.2; // pretty tight for now

void(vector org) grid_m_shot =
{
	fire_missile(2000, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + v_forward * VWX_LASER, org, "laser", "progs/laser_m.mdl", "enforcer/enfire.wav", Laser_Blast, 5, SUB_Remove, Laser_Blast);
	newmis.skin = 1;
	newmis.frame = 10;
	newmis.effects = EF_DIMLIGHT;
};

void() grid_m_attack1 =
{
	local vector v;
	local float f;

	if (self.currentammo > 0)
	if (self.attack_finished < time)
	if (self.enemy)
	{
		v = self.angles;
		v_x = 0; // no pitch yet
		makevectors(v);
		f = infront (self.enemy, GRID_M_DOT, v_forward, v0);
		if (f)
		if (random() < 0.8)
		{
			grid_m_shot(v_forward);
			self.currentammo = self.currentammo - 1;
			self.attack_finished = time + 2;
		}
	}
//	grid_m_run1();
};

// target 1 to target 2
void() grid_m_hidenpeek;

void() grid_m_port =
{
	local entity f;

	self.movetarget2 = find(world, targetname, self.target2);

	if (!self.movetarget2)
	{
		self.think = grid_m_hidenpeek;
		self.delay = time + 10 + random() * 30;
		self.nextthink = time + 0.4;

		return; // no where to go
	}

	if (self.movetarget2.classname == "player" || self.movetarget2.flags & FL_CLIENT)
	{
		self.think = grid_m_hidenpeek;
		self.delay = time + 10 + random() * 30;
		self.nextthink = time + 0.4;

		return;
	}

	f = find(world, classname, "player");

	if (f)
	{
		self.enemy = self.goalentity = f;	// target entity f
		self.nextthink = time + 2 + random() * 2;
		self.think = grid_m_run1;
	}
	else
	{
		f = findradius(self.origin, PK_DYNRAD);
		if (f)
		{
			self.goalentity = f;
			self.nextthink = time + 2 + random() * 2;
			self.think = grid_m_run1;
		}
		else
		{
			self.think = grid_m_hidenpeek;
			self.delay = time + 10 + random() * 30;
			self.nextthink = time + 0.4;

			return;
		}			
	}

	setorigin(self, self.movetarget2.origin + ' 0 0 2'); // now on the grid

	self.th_pain = 
	self.th_stand = 
	self.th_walk = grid_m_run1; //grid_m_walk1;
	self.th_run = grid_m_run1;
	self.th_melee = 
	self.th_missile = grid_m_attack1;
};


void() grid_m_hidenpeek;

// take a shot from the hidey hole entry - go back after timeout

void() grid_m_peek_attack1 =
{
	local vector v;
	local float f;

	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 15) self.walkframe = 0;
	self.frame = self.walkframe + $walk1;

	self.nextthink = time + 0.2; // how often we see if we can shoot the player from hidey hole

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
	self.nextthink = time + 0.4;

	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 15) self.walkframe = 0;
	self.frame = self.walkframe + $walk1;

	if (self.delay > time) return;

	self.delay = time + 10 + random() * 20;

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
			self.delay = time + 2 + random() * 3;
			self.think = grid_m_port; // go into grid
		}
		else
		{
			self.delay = time + 3 + random() * 3; // time to peek & attack
			self.nextthink = time + 0.2;
			self.think = grid_m_peek_attack1;
		}
	}
	else
		setorigin(self, self.finaldest);
};

void() grid_m_die =
{
	if (damage_attacker)
	if (damage_attacker.classname == "player")
	{
		damage_attacker.xp = damage_attacker.xp + self.frags;
		sprint(damage_attacker,ftos(self.frags));
		sprint(damage_attacker," + score = ");
		sprint(damage_attacker,ftos(damage_attacker.xp));
		sprint(damage_attacker,"\n");
	}

	self.count = self.count + 1;
	if (self.count == 9) remove(self); // tdo: end of level when all monsters gone deal

	self.frags = self.count * self.xp;
	self.health = self.count * self.max_health;
	self.takedamage = DAMAGE_AIM;

	setorigin(self, self.finaldest);
	self.angles = self.finalangle;
	self.fixangle = 1;		// turn this way immediately

	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_missile = SUB_Null;

	self.think = grid_m_hidenpeek;

	self.nextthink = time + 0.4;
	self.delay = time + 5 + random() * 10;
};

void() grid_monster_start =
{
	self.takedamage = DAMAGE_AIM;

//	self.ideal_yaw = self.angles * '0 1 0';
//	if (!self.yaw_speed)
//		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;

	self.finaldest = self.origin; // save these for restore to hidey hole
	self.finalangle = self.angles;

	self.cnt = 2 + rint(random() * 1); // number of pop outs till he goes to grid
	self.currentammo = 15 + random() * 15;
	self.xp = self.frags = 100;
	self.count = 1; // monster level

	self.think = grid_m_hidenpeek;
	self.nextthink = time + 0.4;
	self.delay = time + 5 + random() * 20; // time to first peek
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
	precache_model ("progs/zboson.mdl");

	precache_sound ("wizard/wsight.wav");
}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/zboson.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');
	self.health = 20;
	self.max_health = 20;

	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null; 
	self.th_run = SUB_Null;
	self.th_missile = SUB_Null;

	self.th_pain = SUB_Null;
	self.th_die = grid_m_die;

	walkmonster_start ();
	grid_monster_start ();

}