/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };


/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;

// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
//	local entity 	ent, otemp, stemp;

// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void() walkmonster_start_go =
{
//local string	stemp;
//local entity	etemp;

	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor(0,0); // Cataboligne 9.17.3 - fixed this compiler warning

	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;
	self.max_health = self.health;

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};


void() walkmonster_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + 1;
	AddToSplashBig(self); // *pk - Make this entity splash
	if (self.class_select == null_string) self.class_select = "class_monster"; // Cataboligne - let mod know this is a monster

	self.archon = self.health / ARCHON_MONSTER;
	if (self.archon <= 0) self.archon = 1;


#ifdef warning
if (WARNING & 4)
{
	bprint("\b*** walkmonster\b: ");
	bprint(self.classname);
	bprint(" - nom: ");
	bprint(self.netname);
	bprint(" - sflags: ");
	bprint(ftos(self.spawnflags));
	bprint(" - wds: ");
	bprint(self.wad);
	bprint(" - hl: ");
	bprint(ftos(self.health));
	bprint(" - XP: ");
	bprint(ftos(self.archon));
	bprint(" - wframe: ");
	bprint(ftos(self.walkframe));
	bprint("\n");
}
#endifdef


};



void() flymonster_start_go =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	self.max_health = self.health;

	if (!walkmove(0,0))
	{
		dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
};

void() flymonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = flymonster_start_go;
	total_monsters = total_monsters + 1;
	AddToSplashBig(self); // *pk - Make this entity splash
	if (self.class_select == null_string) self.class_select = "class_monster";

	self.archon = self.health / (ARCHON_MONSTER - 20);
	if (self.archon <= 0) self.archon = 1.2;


#ifdef warning
if (WARNING & 4)
{
	bprint("\b*** flymonster\b: ");
	bprint(self.classname);
	bprint(" - nom: ");
	bprint(self.netname);
	bprint(" - sflags: ");
	bprint(ftos(self.spawnflags));
	bprint(" - wds: ");
	bprint(self.wad);
	bprint(" - hl: ");
	bprint(ftos(self.health));
	bprint(" - XP: ");
	bprint(ftos(self.archon));
	bprint(" - wframe: ");
	bprint(ftos(self.walkframe));
	bprint("\n");
}
#endifdef


};


void() swimmonster_start_go =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;
//	total_monsters = total_monsters + 1; - this double counts all fish

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;

	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
	self.max_health = self.health;

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};

void() swimmonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = swimmonster_start_go;
	total_monsters = total_monsters + 1;
	if (self.class_select == null_string) self.class_select = "class_monster";

	self.archon = self.health / ARCHON_MONSTER;
	if (self.archon <= 0) self.archon = 1;


#ifdef warning
if (WARNING & 4)
{
	bprint("\b*** swimmonster\b: ");
	bprint(self.classname);
	bprint(" - nom: ");
	bprint(self.netname);
	bprint(" - sflags: ");
	bprint(ftos(self.spawnflags));
	bprint(" - wds: ");
	bprint(self.wad);
	bprint(" - hl: ");
	bprint(ftos(self.health));
	bprint(" - XP: ");
	bprint(ftos(self.archon));
	bprint(" - wframe: ");
	bprint(ftos(self.walkframe));
	bprint("\n");
}
#endifdef


};


/*
================
SummonMonster

Badder monsters (super & super extra mad) have a chance to summon help

mark I - Super Shalrath could summon up to 3 spike mines when idle
		 - 0.1 - gave deathknight, 6 spike wizard same power
mark II - added more monsters (wizard & fluffy) and extended to calling for various help while on the move
		  - 0.2 - tfog & tdeath added for non spike mines, better random away from summoner
================
*/

// NOTE: called by other monsters
// set spike mines, or summon other monsters

// ms - if not null, summon this - must be a valid spawn func classname

// - if null, uses spike mine limit - 2 + skill
// - if non null, limit is not checked here

void(string ms) SummonMonster =
{

	local entity e;
	local vector v;

// mine limit in aflag for mine makers
// can make 3 mines on skill 1

	if (ms == null_string) // default to spike mine & check limits
	{
		ms = "trap_spike_mine";

		if (self.aflag >= 2 + skill) // SV_MINELIM
		{
// count them - some could have exploded
			self.aflag = cnt_ent(world, "owner",  ms);

// fail - he has made max number of mines
			if (self.aflag >= 2 + skill) return; // SV_MINELIM - 3 mines
		}
	}

// luck was not his this time, go back
	if (skill > 2) if (random() > 0.5) return;
	else if (random() > 0.15) return; // SV_SETMINE - 0.15 % chance

// make a new mine - YAY!

	e = spawn();
	e.classname = e.wad = ms; //monster_id(CB_M_SPIKEMINE, MON_FUNC_REG); // get spawn func
	item_call_save(e, e.classname);

	if (self.charmer) // charmed monsters that summon make minons charmed as well
	{
		e.charmer = self.charmer;
		e.charmed = 1;
		e.effects = e.effects | self.effects; // copy dimlight or other effects if on
	}
	e.owner = self; // so we can count them

// IMP: when gathering all random loc fn(), nearby in a radius & not in solid, monster or player
	v = self.origin;
	v_z = v_z + 32;
	v_x = v_x + crandom() * 60;
	if (v_x < self.origin_x) v_x = v_x - 50; // make sure we clear the summoner
	else v_x = v_x + 40;
	v_y = v_y + crandom() * 60;
	if (v_y < self.origin_y) v_y = v_y - 50;
	else v_y = v_y + 40;
	setorigin(e, v);
//	random_monster_location(v); // no good - this moves self

	if (ms != "trap_spike_mine")
	{
		spawn_tfog (e.origin);
		spawn_tdeath(e.origin, e); // test - make sure he doesnt telefrag his summoner!
	}

	self.aflag = self.aflag + 1;
	self.count = self.count + 1;
};








