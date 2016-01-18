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
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");
	
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");
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

	if (sky_touch("", v0, self))
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

	org = self.origin + ' 0 0 14' + v_forward * 11 + v_right * 22;				// right half y split
	traceline (org, self.origin + v_forward* B_SPLIT, TRUE, self);
	multi_beam(org, trace_endpos,  0);

	org = self.origin + ' 0 0 14' + v_forward * 11 + v_right * -19;			// left half y split
	traceline (org, self.origin + v_forward* B_SPLIT, TRUE, self);
	multi_beam(org, trace_endpos,  0);

	org = self.origin + ' 0 0 14' + v_forward *  B_SPLIT * 0.6;									// main strike beam
	traceline (org, self.origin + v_forward*600, TRUE, self);
	multi_beam(org, trace_endpos,  0);

	LightningDamage_x(FALSE, org, trace_endpos + v_forward*4, self, 20 + wdmg);
	sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
};
void() player_shalrath_lightning3 = [ $attack11, player_stand1 ] {};


float SEL_SHAL_ANH;
float SEL_SHAL_BOMB;
float SEL_SHAL_LTN;
float SEL_SHAL_SPIKE;

void() player_shalrath_attack =
{
	if (sphere_a.owner == self && sphere_a.state != ST_FREEZE)
		sphere_attack();
	else
	 {
		if(self.weapon == SEL_SHAL_ANH)
		{
			if (sphere_a != world)
			{
				if (sphere_a.owner == self && self.impulse == ALT_FIRE_IMP) // case of idle sphere - this regains control
					sphere_attack();
				else
					sprint(self,"Sphere of annihilation already summoned!\n"); // IDEA take control of idle sphere
				return;
			}
			sprint(self,"You summoned a Sphere of Annihilation!\n");
			self.attack_finished = time + 1;
			sphere_annihilation_spawn();
		}
		else if (self.weapon == SEL_SHAL_LTN)
		{
			if (rune_haste(0.45))
				self.attack_finished = time + 0.9;
			player_shalrath_lightning1(); // lightning
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

	if (self.weapon == SEL_SHAL_ANH)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		self.items = self.items | IT_CELLS;
		sprint(self, "Press fire to summon / dismiss Sphere of annihilation\n"); 
	}
	if (self.weapon == SEL_SHAL_BOMB)
	{
		self.items = self.items | IT_ROCKETS;
		sprint(self, "Shalrath firing ( Spiked bomb )\n"); 
	}

	if (self.weapon == SEL_SHAL_LTN)
		{
		sprint(self, "Shalrath using ( Lightning )\n");
		self.items = self.items | IT_CELLS;
		}

		if (self.weapon == SEL_SHAL_SPIKE)
		{
		sprint(self, "Shalrath using ( Spikes )\n");
		self.items = self.items | IT_NAILS;
		}
};

string() player_shalrath_killmsg = {
	return " was exploded by ";
};

string() player_shalrath_killmsg2 = {
	return ".\n";
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
	stuffcmd(self, "chase_up 15\n");
	stuffcmd(self, "chase_back 22\n");
	stuffcmd(self, "exec m-shalrath.cfg\n");

	setmodel(self,"progs/shalrath.mdl");

	//	self.modelindex_morph=self.modelindex;
//	self.mask_x = CB_SHALR;
	self.items = self.items | IT_AXE | IT_SUPER_NAILGUN | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	self.builtin = self.items & WEP_MASK;
	SEL_SHAL_BOMB = IT_ROCKET_LAUNCHER;
	SEL_SHAL_LTN = IT_LIGHTNING;
	SEL_SHAL_SPIKE = IT_SUPER_NAILGUN;
	SEL_SHAL_ANH = IT_AXE;
	self.weapon = SEL_SHAL_BOMB;

	self.msight = "shalrath/sight.wav";
	self.noise2 = "shalrath/pain.wav";
	self.noise3 = "";
	self.view_ofs = '0 0 34'; // raised 8
	self.cam_z = 0.1;
	//setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
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
		bprint(" has become a vore.\n");
//		morph_impulse(); // for one wep morphs we only need this once
		}
};
