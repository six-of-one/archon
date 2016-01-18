/* ::-::
 *
 * Cataboligne
 *
 * file: m-shalra.qc
 *
 * date: 9/16/11
 *
 * qc - support chaos mod morph ability
 *
 */
 

$cd /raid/quake/id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5 

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12

void() m_precache_shalrath =
{
//// Shalrath morph
	precache_model ("progs/shalrath.mdl");
	precache_model ("progs/h_shal.mdl");
	precache_model ("progs/v_spike.mdl");
	
	precache_sound ("shalrath/attack.wav");
	precache_sound ("shalrath/attack2.wav");
	precache_sound ("shalrath/death.wav");
	precache_sound ("shalrath/idle.wav");
	precache_sound ("shalrath/pain.wav");
	precache_sound ("shalrath/sight.wav");
};

void() player_shalrath_stand = [ $walk1, player_stand1 ] { };
void() player_shalrath_run =
{
	if(self.walkframe >= 12)
		self.walkframe = 0;
	if (self.walkframe == 6) morph_sound(0.2, "shalrath/idle.wav", 4);
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() player_shalrath_pain1 = [ $pain1, player_shalrath_pain2 ]
{
	self.pain_finished = time + 2.4;
	morph_sound (0.8, self.noise2, 1);
};
void() player_shalrath_pain2 = [ $pain1, player_shalrath_pain3 ] {};
void() player_shalrath_pain3 = [ $pain1, player_shalrath_pain4 ] {};
void() player_shalrath_pain4 = [ $pain1, player_shalrath_pain5 ] {};
void() player_shalrath_pain5 = [ $pain1, player_stand1 ] {};

// void() player_shalrath_jump = { self.velocity_z=10; };

/* deprecated - monster shalrath missile touch is now same code
void() player_ShalMissileTouch =
{
	if (other)
	if (other == self.owner)
		return;		// don't explode on owner

	if (sky_touch(null_string, v0, self))
	{
		SUB_Remove();
		return;
	}

	if (other.classname == "monster_zombie")
		T_Damage (other, self, self, 110);	
/*
//	T_RadiusDamage (self, self.owner, 80, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
* /
	Explode(self.dmg, world, TE_EXPLOSION, random() * 0.02, BecomeExplosion);
};
*/
/*
================
player_ShalMissile
================
*/
void() ShalHome;
void() ShalMissileTouch;
void() player_ShalMissile =
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	fire_missile(SHALRATH_SHT_VEL, MOVETYPE_FLYMISSILE, FL_RUNEHST, RM_SKY | FLT_LAVA | MLT_LAVA | FL_NOPART, self.origin + '0 0 10', ' 0 0 0', "missile", "progs/v_spike.mdl", "shalrath/attack2.wav", ShalMissileTouch, 0.4, ShalHome, SUB_Null);

	if(self.enemy.classname == "worldspawn")
	{
		traceline (self.origin, self.origin + v_forward * 2048, FALSE, self);
		self.enemy=trace_ent;
	}

	if(self.enemy.classname == "worldspawn")
	{
		newmis.enemy = world;
	}
	else
	{
		newmis.enemy = self.enemy;
	}

	newmis.dest_y = 16;
	newmis.avelocity = '300 300 300';
	newmis.dmg = 80;
	newmis.morphy = self.morphy;
};

// fire a shalrath spike (purple version of knight spike) from v2
// 	- target = trace_endpos

void(vector v2) shal_spike =
{
	v2_x = v2_x + crandom() * 10;
	v2_y = v2_y + crandom() * 10;
	v2_z = v2_z + crandom() * 10;
	hk_fire_spike(v2);
	newmis.skin = 1;
	newmis.modelflags = MF_TRACER3;
	newmis.velocity = normalize(trace_endpos - v2);
	newmis.angles  = vectoangles(newmis.velocity);
	newmis.velocity = newmis.velocity * (300 + crandom() * 50);
	makevectors(newmis.angles);
	newmis.origin = newmis.origin + random() * 40 * v_forward;
};


void() player_shalrath_attack1 = [ $attack1, player_shalrath_attack2 ]
{
	local vector v;
	sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	if (rune_haste(0.5))
		self.attack_finished=time+1;
	makevectors(self.v_angle);
	v = v_forward; //gun_aim(self, v0);
	traceline(self.origin+ self.view_ofs, self.origin+v * 2048 + self.view_ofs, FALSE, self);
	if((trace_ent.classname != "worldspawn") && (trace_ent.takedamage & DAMAGE_AIM))
	{
		self.enemy = trace_ent;
	} 
	else if(self.enemy)
	{
		if(!visible(self.enemy)) self.enemy=world;
		if(!infront(self.enemy, MONSTER_DEFDOT, v0, v0)) self.enemy=world;
		if(self.enemy.health <=0) self.enemy=world;
		if(self.enemy.takedamage != DAMAGE_AIM) self.enemy=world;
	}
};
void() player_shalrath_attack2 = [ $attack2, player_shalrath_attack3 ] {};
void() player_shalrath_attack3 = [ $attack4, player_shalrath_attack4 ] {};
void() player_shalrath_attack4 = [ $attack8, player_shalrath_attack5 ] {};
void() player_shalrath_attack5 = [ $attack10, player_stand1 ] { player_ShalMissile(); };

void() player_shalrath_lightning1 = [ $attack1, player_shalrath_lightning2 ] {};
void() player_shalrath_lightning2 = [ $attack2, player_shalrath_lightning3 ]
{
	local	vector org;
	local float wdmg;
	local float B_SPLIT = 54;

	if (random() < 0.2) wdmg = 5 + 15 * random();

	v1 = org = self.origin + ' 0 0 14' + v_forward * 11 + v_right * 22;				// right half y split
	traceline (org, self.origin + v_forward* B_SPLIT, TRUE, self);
	if (self.weapon == IT_LIGHTNING) multi_beam(org, trace_endpos,  0);

	norm = org = self.origin + ' 0 0 14' + v_forward * 11 + v_right * -19;			// left half y split
	traceline (org, self.origin + v_forward* B_SPLIT, TRUE, self);
	if (self.weapon == IT_LIGHTNING) multi_beam(org, trace_endpos,  0);

	org = self.origin + ' 0 0 14' + v_forward *  B_SPLIT * 0.6;									// main strike beam
	traceline (org, self.origin + v_forward*600, TRUE, self);
	if (self.weapon == IT_LIGHTNING)
	{
		multi_beam(org, trace_endpos,  0);

		LightningDamage_x(FALSE, org, trace_endpos + v_forward*4, self, 20 + wdmg);
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
	}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		shal_spike(v1);
		shal_spike(norm);
		shal_spike(v1);
		shal_spike(norm);
		shal_spike(v1);
		if (random() < 0.7) shal_spike(norm);
		if (random() < 0.3) shal_spike(v1);
		if (random() < 0.3) shal_spike(norm);
		if (random() < 0.13) shal_spike(norm);
		if (random() < 0.13) shal_spike(v1);			
	}
};
void() player_shalrath_lightning3 = [ $attack11, player_stand1 ] {};


void() player_shalrath_attack =
{
	if (sphere_a.owner == self && sphere_a.state != ST_FREEZE)
		sphere_attack();
	else
	 {
		if (sphere_a.owner == self)
		if (vlen(sphere_a.origin - sphere_a.owner.origin) > SP_MAXDIST) self.mcode = -504; // oor
		else self.volume = -250;

		if ((self.weapon == IT_AXE) && (self.volume < 0)) // note: volume setting for regaining sphere control!
		{
			if (self.class_select == "class_bot") // TEST: block bots from using sphere, see if bad wolf bug goes away
			{
				if (rune_haste(0.4))
					self.attack_finished = time + 0.75;
				player_shalrath_lightning1(); // lightning
				return;
			}

			if (sphere_a != world)
			{
				if (sphere_a.owner == self && self.impulse == ALT_FIRE_IMP) // case of own idle sphere - this regains control
					sphere_attack();
				else
					sprint(self,"Sphere of annihilation already summoned!\n"); // IDEA: attempt (at risk) take control of not own idle sphere
				return;
			}
			stuffcmd(self, "exec cfg/morph/m-shalrath-soa.cfg\n");
			sprint(self,"You summoned a Sphere of Annihilation!\n");
			self.attack_finished = time + 1;
			sphere_annihilation_spawn();
			self.mcode = sphere_a.state; // tells HUD sphere state
// use archon power
			if (self.volume < 0)
				self.archon = self.archon + self.volume;
			self.volume = -250; // can banish imm. if power is there
		}
		else if (self.weapon == IT_LIGHTNING)
		{
			if (rune_haste(0.4))
				self.attack_finished = time + 0.75;
			player_shalrath_lightning1(); // lightning
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			if (rune_haste(0.4))
				self.attack_finished = time + 0.75;
			player_shalrath_lightning1(); // spikes, same framing
		}
		else
		{
			player_shalrath_attack1(); // spiked bomb
		}
	}
};

// fn(player_shalrath_impulse) - for extra balance weps


void() player_shalrath_impulse =
{

	if (sphere_a.owner == self && sphere_a.state != ST_FREEZE)
	{
		sphere_control();
		return;
	}

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	self.volume = 0;

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		if ((self.archon > 1000 && !sphere_a) || (sphere_a && sphere_a.owner == self))
		{
//			sprint(self, "Press fire to summon / dismiss Sphere of annihilation\n"); 
			self.mcode = sphere_a.state; // tells HUD sphere state
			if (!sphere_a) self.volume = -1000;
			else if (vlen(sphere_a.origin - sphere_a.owner.origin) > SP_MAXDIST) self.mcode = -504; // oor
			else self.volume = -250;
		}
		else
		{
			self.mcode = -505; // tells HUD bomb in slot 1
			self.items = self.items | IT_ROCKETS;
//			sprint(self, "Shalrath firing ( Spiked bomb )\n"); 
		}
	}

	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.items = self.items | IT_ROCKETS;
//		sprint(self, "Shalrath firing ( Spiked bomb )\n"); 
	}

	if (self.weapon == IT_LIGHTNING)
		{
//		sprint(self, "Shalrath using ( Lightning )\n");
		self.items = self.items | IT_CELLS;
		}

		if (self.weapon == IT_SUPER_NAILGUN)
		{
//		sprint(self, "Shalrath using ( Spikes )\n");
		self.items = self.items | IT_CELLS;
		}
};

string() player_shalrath_killmsg =
{
	if (!ENHANCED) return " was exploded by a Vore\n";
	if (random() < 0.5) return " felt the deep existential magic of ";
	return " was exploded by ";
};

string() player_shalrath_killmsg2 =
{
	if (!ENHANCED) return "noname";

	return "\n";
};

void(float silent) player_shalrath_become =
{
	self._stand=player_shalrath_stand;
	self._run=player_shalrath_run;
	self._pain=player_shalrath_pain1;
	self._die=shalrath_die;
	self._jump=SUB_Null;
	self._jump2=SUB_Null;
	self._attack=player_shalrath_attack;
	self._impulse=player_shalrath_impulse;

//	self._can_get_p=SUB_False;
	self._killmsg=player_shalrath_killmsg;
	self._killmsg2=player_shalrath_killmsg2;

	self.cam_z = 15 / 100;
	self.cam_y = 22;

	stuffcmd(self, "exec cfg/morph/m-shalrath.cfg\n");

	setmodel(self,"progs/shalrath.mdl");

	self.builtin = IT_AXE | IT_SUPER_NAILGUN | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	self.items = self.items | self.builtin;
	self.weapon = IT_SUPER_NAILGUN;
	self.mcode = 0;

	self.msight = "shalrath/sight.wav";
	self.noise2 = "shalrath/pain.wav";
	self.noise3 = null_string;
	self.view_ofs = '0 0 34'; // raised 8

//	if(!deathmatch)
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
//	 	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	self.health = self.health * MSHALR_HEALMOD / self.health_modifier;
	self.health_modifier = MSHALR_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!silent) // silent for starting new level as this beasty
	{
		bprint(self.netname);
		bprint(" has become "); // vore
		bprint(polymorph_id(self.morphy));
		bprint(".\n");
//		morph_impulse();
	}
};
