/* ::-::
 *
 * Cataboligne
 *
 * file: m-anode.qc
 *
 * date: 9/16/11
 *
 * qc - support chaos mod morph ability
 *
 */
 

$cd /Quake/qlnx/newmdl
$origin 0 0 24
$base base
$skin skin
$scale 1

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5 

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12

void() m_precache_anode =
{
//// anode morph
	precache_model2 ("progs/anode_x.mdl");

//	precache_sound2 ("anode/fired.wav");
};

void() player_anode_stand = [ $walk1, player_stand1 ] { };

void() player_anode_run =
{
//	if(self.walkframe >= 12)
//		self.walkframe = 0;
//	if (self.walkframe == 6) morph_sound(0.2, "anode/idle.wav", 4);
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() player_anode_pain1 = [ $pain1, player_stand1 ] {};

/*
================
anode shot
================
*/
void() anode_shot =
{
	local vector org;
	local float e, f, k;

	self.effects = self.effects | EF_MUZZLEFLASH;

	e = 0;
	k = f = 1;
	if (self.lefty == ALT_FIRE_IMP) // fire reverse
	{
		e = 180;
	}
	else
	if (self.lefty == 9) // fire left
	{
		e = 270;
		f = -1;
	}
	else
	if (self.lefty == 11) // fire right
	{
		e = 90;
		f = -1;
		k = -3;
	}

	self.lefty = 0;

	org = self.v_angle;
	org_x = 0;

	if (org_y >= -135 && org_y < -45) org_y = -90 + e * f;
	else if (org_y >= -45 && org_y < 45) org_y = 360 - e;
	else if (org_y >= 45 && org_y < 135) org_y = 90 - e * k;
	else if (org_y < -135 || org_y >= 135) org_y = 180 + e * f;

	makevectors	(org);

	fire_missile(2000, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin + v_forward * VWX_LASER, org, "laser", "progs/laser_m.mdl", "enforcer/enfire.wav", Laser_Blast, 5, SUB_Remove, Laser_Blast);
	newmis.skin = 1;
	newmis.frame = 10;
	newmis.effects = EF_DIMLIGHT;

/*
	fire_missile(SHALRATH_SHT_VEL, MOVETYPE_FLYMISSILE, FL_RUNEHST, RM_SKY | FLT_LAVA | MLT_LAVA | FL_NOPART, self.origin + '0 0 10', org, "missile", "progs/v_spike.mdl", "shalrath/attack2.wav", ShalMissileTouch, 0.4, ShalHome, SUB_Null);

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
*/
};

void() player_anode_attack1 = [ $attack1, player_anode_attack2 ]
{
//	sound (self, CHAN_VOICE, "anode/attack.wav", 1, ATTN_NORM);

	if (rune_haste(0.15))
	self.attack_finished=time+0.3;
	self.lefty = self.impulse; // have to save so we see it later

/*
	shalrath bomb tracking
	local vector v;
	local float e,f;
	
	e = f = 0;
	if (self.impulse == ALT_FIRE_IMP)
	{
		e = 180;
		f = 90;
	}

	v = self.v_angle;
	v_x = 0;
	if (v_y >= -135 && v_y < -45) v_y = -90 + e;
	else if (v_y >= -45 && v_y < 45) v_y = 360 - e;
	else if (v_y >= 45 && v_y < 135) v_y = 90 - e;
	else if (v_y < -135 || v_y >= 135) v_y = 180 - e;

	makevectors(v);

//	makevectors(self.v_angle);
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
*/
};
void() player_anode_attack2 = [ $attack2, player_anode_attack3 ] {};
void() player_anode_attack3 = [ $attack4, player_anode_attack4 ] {};
void() player_anode_attack4 = [ $attack8, player_anode_attack5 ] {};
void() player_anode_attack5 = [ $attack10, player_stand1 ] { anode_shot(); };

void() player_anode_lightning1 = [ $attack1, player_anode_lightning2 ] {};
void() player_anode_lightning2 = [ $attack2, player_anode_lightning3 ]
{
	local	vector org;
	local float wdmg;
	local float B_SPLIT = 54;

	if (random() < 0.2) wdmg = 5 + 15 * random();

	org = self.v_angle;
	org_x = 0;
	if (org_y > -45 && org_y < 45) org_y = 0;
	else if (org_y > 45 && org_y < 135) org_y = 90;
	else if (org_y > -135 && org_y < -45) org_y = -90;
	else if (org_y < -135 || org_y > 135) org_y = 180;
	
	makevectors	(org);

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

void() player_anode_lightning3 = [ $attack11, player_stand1 ] {};


void() player_anode_attack =
{
	if (sphere_a.owner == self && sphere_a.state != ST_FREEZE)
		sphere_attack();
	else
	 {
		if (self.weapon == SEL_SHAL_LTN)
		{
			if (rune_haste(0.3))
			self.attack_finished = time + 0.6;
			player_anode_lightning1(); // lightning
		}
		else
		{
			player_anode_attack1(); // spiked bomb
		}
	}
	self.impulse = 0; // clear attack impulses
};

// fn(player_anode_impulse) - for extra balance weps


void() player_anode_impulse =
{

	if (self.impulse == 9 || self.impulse == 11) // side shots
	{
		player_anode_attack1();
		return; // handled by attack
	}

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	if (self.weapon == IT_AXE)
		{
		sprint(self, "anode using ( Power Bolt )\n");
		self.items = self.items | IT_CELLS;
		}
};

string() player_anode_killmsg = {
	return " was exploded by ";
};

string() player_anode_killmsg2 = {
	return ".\n";
};

void(float silent) player_anode_become =
{
	self._stand=player_anode_stand;
	self._run=player_anode_run;
	self._pain=player_anode_pain1;
	self._die=SUB_Null;
	self._jump=SUB_Null;
	self._jump2=SUB_Null;
	self._attack=player_anode_attack;
	self._impulse=player_anode_impulse;

//	self._can_get_p=SUB_False;
//	self._killmsg=player_anode_killmsg;
//	self._killmsg2=player_anode_killmsg2;

	setmodel(self,"progs/null.mdl");

local entity e;
	e = spawn();
	setmodel(e,"progs/anode_x.mdl");
	setorigin(e, self.origin);
	e.angles = self.angles; // relative angles

//	e.movetype = MOVETYPE_FOLLOW; // make the e.follow
	e.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
	e.aiment = self; // make the e.follow bmodel
	e.punchangle = self.angles; // the original angles of bmodel
	e.view_ofs = e.origin - self.origin; // relative origin
	e.v_angle = e.angles - self.angles; // relative angles
	self.movetarget = e;

	self.items = self.items | IT_AXE;
	self.builtin = self.items & WEP_MASK;
	self.weapon = IT_AXE;

//	self.msight = "anode/sight.wav";
//	self.noise2 = "anode/pain.wav";
	self.noise3 = "";
	self.view_ofs = '0 0 34'; // raised 8
	self.cam_z = 0.1;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.health = self.health * MSHALR_HEALMOD / self.health_modifier;
	self.health_modifier = MSHALR_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become Anode X.\n");
		}
};
