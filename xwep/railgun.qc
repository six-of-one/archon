/*
		+---------------------------------------+
		|  Railgun code                         | SEC-HEAD
		+---------------------------------------+
*/

void() rail_precache =
{
	precache_model ("progs/pt_beam.mdl");
	precache_model ("progs/rubble_m.mdl");
	precache_model ("progs/smoke.mdl");
};

vector() randdir =
{
	local vector dir;
	dir_x = crandom();
	dir_y = crandom();
	dir_z = crandom();

	return dir;
};

void() rubble_touch =
{
//	self.nextthink = time + RUBBLE_TIME + crandom()* RUBBLE_DEV;
	if(self.velocity == ' 0 0 0')
		self.avelocity = ' 0 0 0';
	else
		self.velocity = self.velocity * 0.8;
};



void()	smoke1		=	[0,		smoke2] {};
void()	smoke2		=	[1,		smoke3] {};
void()	smoke3		=	[2,		SUB_Remove] {};

void()	smoke_s1		=	[0,		smoke_s2] {self.nextthink = time + 0.3;};
void()	smoke_s2		=	[2,		SUB_Remove] {};

/*
	deprecated for rubble_debris
void(vector org, vector vel) SpawnRubble =
{
//	chaos_spawn(0, 0, 0, 0, org, ' 0 0 0', ' 0 0 0', ' 0 0 0', vel, "temp_ent", "", SUB_Null, 0.01, EffectSpawnRubble, SUB_Null, self, world);

	local string md;
	local float rand;
	local entity e;

	if (sky_touch("", org, world)) return;

	
	e = chaos_spawn(MOVETYPE_BOUNCE, SOLID_BBOX, 0, FLT_LAVA | MLT_LAVA | CK_EARTHQUAKE | PF_SOLID | PF_WATER | PF_SLIME | FL_NOPART, org, ' 0 0 0', ' 0 0 0', ' 0 0 0',
					vel, "rubble", "progs/rubble_m.mdl", rubble_touch, RUBBLE_TIME + crandom()* RUBBLE_TDEV, meltthink, SUB_Null, self, world);

	rand = ceil(random()*3);
	e.avelocity = randdir()*300;
	if (rand == 1)
		e.frame = 0;
	else if (rand == 2)
	{
		e.frame = 2;
		e.touch = hipRubbleTouch; // big chunks do damage
		e.dmg = 4 + crandom() * 3;
	}
	else
	{
		e.frame = 22;
		e.touch = hipRubbleTouch; // big chunks do damage
		e.dmg = RUBBLE_DMGDEF + crandom() * 4;
	}
	e.skin = floor(random() * 2.4);
	e.class_select = "class_rubble";
};
*/

//========================================================


void(vector org, vector vel) SpawnSmoke =
{
	if (sky_touch("", org, world)) return;

//	chaos_spawn(0, 0, 0, 0, org, ' 0 0 0', ' 0 0 0', ' 0 0 0', vel, "smoke", "", SUB_Null, 0.01, EffectSpawnRubble, SUB_Null, self, world);
	chaos_spawn(MOVETYPE_NOCLIP, SOLID_NOT, 0, 0, org, ' 0 0 0', ' 0 0 0', ' 0 0 0', vel, "smoke", "progs/smoke.mdl", SUB_Null, 0, smoke1, SUB_Null, self, world);
};

//========================================================


void(vector org, vector vel, float livetm, float mtype) SpawnExitWound =
{
	newmis = chaos_spawn(mtype, SOLID_NOT, 0, RM_SKY, org, ' 0 0 0', ' 0 0 0', ' 0 0 0', vel, "", "progs/gib1.mdl", SUB_Remove, livetm, SUB_Remove, SUB_Null, self, world);

// *** this code has not been tested in game yet

	newmis.avelocity = ' 3000 1000 2000';

};


//========================================================


void() railbeam_think =
{
	setmodel(self, "");
	self.owner.movetype = self.owner.lefty;
	self.nextthink = time + 1.2;
	if (self.cnt)
		{
		self.cnt = 0;
		return;
		}
	self.think = SUB_Remove;
	self = self.owner;
	self.chaosweptime = 0;
//	ominous_hum("railgun/rail_relo.wav", 1.2);
	self = self.enemy;
};

void() X_FireRailgun =
{
	local	vector org, destination;
	local	float	i, j, k, damage;
	local	entity startent, impactent;

//	self.currentammo = wep_ref(WMOD_ADDA,self.weapon & 255,0 - self.eweapon.dmg_save,self,self.eweapon.weaponframe);

	self.lefty = self.movetype; // temp str
	move_stop(self, ""); // mostly for beam appearances
	self.chaosweptime = 0;
	ominous_hum(self.eweapon.noise3, 1.5);
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.punchangle_x = -4;

	org = self.origin + v_up * VWZ_RAILGUN + v_right * VWY_RAILGUN + v_forward * VWX_RAILGUN;

	traceline (org, org + v_forward*2048, TRUE, self); //600

	fire_missile(1, MOVETYPE_FLY, FL_MSL | FL_USEAMMO | FL_2PUNCH , 0, org, ' 0 0 0', "beam", "progs/pt_beam.mdl", "", SUB_Nop, 0.3, railbeam_think, SUB_Nop);

	newmis.skin = 1;
	newmis.angles_z = random() * 360;
	newmis.velocity = ' 0 0 0';
	newmis.cnt = 1;

	self.enemy = startent;

	i = 10;
	startent = self;
	destination = trace_endpos + v_forward*8;

	damage = 130 + random()*5; //110//85 + random()*5;

	while(i > 0)
	{
		traceline (org, destination, FALSE, startent);

		if(trace_fraction >= 1 && !trace_ent.takedamage) // hit solid
			return;

		if(trace_ent == self) // on self
			return;

		j = (trace_ent.takedamage == DAMAGE_AIM);
		impactent = trace_ent;

		trace_endpos = trace_endpos - v_forward*16;
		if(trace_ent.takedamage)
		{
			T_Damage (trace_ent, self, self, damage);
			if(j)
				SpawnExitWound (trace_endpos, v_forward * 1200, 0.2, MOVETYPE_FLY);
		}
		else
		{
			SpawnSmoke(trace_endpos, ' 0 0 20');
			k = 2 + random() * 3;
			while(k > 0)
			{
				rubble_debris(trace_endpos, v_forward * -100 + randdir()*50, 2 + random() * 4, 0);
//				SpawnRubble(trace_endpos, v_forward * -100 + randdir()*50);
				k = k - 1;
			}
		}

		if(!j || vlen(org - destination) < 5)
			return; // hit something solid or finished

		org = trace_endpos;
		startent = impactent;
		damage = damage * 0.75;
		i = i - 1;
	}
};
