/*
		+---------------------------------------+
		|  Railgun code                         | SEC-HEAD
		+---------------------------------------+
*/

void() rail_precache =
{
	precache_model ("progs/beambit.spr");
//	precache_model ("progs/pt_beam.mdl");
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


void() railsnd_think =
{
	self.owner.chaosweptime = 0;
	remove(self);
};

void() X_FireRailgun =
{
	local	vector org, destination, v1, v2, vp;
	local	float	i, j, k, m, vl, damage, aj,ak, af, al, cn;
	local	entity startent, impactent;
	local entity e;

//	self.lefty = self.movetype; // temp str
//	move_stop(self, ""); // mostly for beam appearances
	ominous_hum(EWEAP.noise3, 0);
	chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "", "", SUB_Null, EWEAP.endtime, railsnd_think, SUB_Null, self, world);

	self.effects = self.effects | EF_MUZZLEFLASH;
	self.punchangle_x = -4;

	org = self.origin + v_up * VWZ_RAILGUN + v_right * VWY_RAILGUN + v_forward * VWX_RAILGUN;

	traceline (org, org + v_forward*2048, TRUE, self);

	if (EWEAP)
	if (EWEAP.lip == AMMO_SLUGS)
		self.currentammo = self.ammo_slug = self.ammo_slug - ammo_con(EWEAP.dmg_save, self, ""); // use ammo


	makevectors(self.v_angle);
	v1 = org;
//	i = vlen(v1 - trace_endpos);
//	i = 0;
	i = pointcontents(v1);
	vl = vlen(trace_endpos - org);
	af = 1;
	j =1;
	cn = k = 0;
	aj = -0.1;
	ak = 0.1;
//	while (i < 2000)//(i > 100) // (i != CONTENT_SOLID)
//	while (i > 100)
//	while (i < 500)
	while (i != CONTENT_SOLID)
	{
		if (af < 10) af = af + 0.2;
		v2 = (v_up * j + v_right * k);
		vp = normalize(v2) * af;
//		particle (v1 + vp, vp, 208, 1);
		if (random() < 0.2) particle (v1, v_forward * 30, 250, 2);

		e = chaos_spawn(MOVETYPE_FLY, SOLID_NOT, 0, 0, v1 + vp, v0, v0, v0, vp + self.velocity, "", "progs/beambit.spr", SUB_Remove, 0.5, SUB_Remove, SUB_Null, self, world);
		if (e)
		{
			cn = cn + 1;
			e.alpha = 0.4;
		}
/*
bprint("pos v_u = ");
bprint(vtos(v_up * j));
bprint(" pos v_r = ");
bprint(vtos(v_right * k));
bprint(".\n");
*/

		j = j + aj;
		k = k + ak;

		if (fabs(j) < 0.02 || fabs(k) < 0.02)
		{
			if (aj == -0.1 && ak == 0.1) // took k to 1, j to 0
			{
				ak = -0.1;
			}
			else if (aj == -0.1 && ak == -0.1) // took k to 0, j to -1
			{
				aj = 0.1;
			}
			else if (aj == 0.1 && ak == -0.1) // took k to -1, j to 0 
			{
				ak = 0.1;
			}
			else if (aj == 0.1 && ak == 0.1) // took k to 0, j to  1
			{
				aj = -0.1;
			}
		}
		i = 2 + (1 / af) * 0.5;
		if (vl > 600) i = i + (vl / 600);
		if (cn > 200) i = i + (cn / 100);
		if (cn > 300) i = i + (cn / 150);
		if (cn > 400) i = i + (cn / 100);
//		if (af > 8) i = 2;
		v1 = v1 + v_forward * i;
//		i = i + 1;
//		i = vlen(v1 - trace_endpos);
		i = pointcontents(v1);
	}
/*
bprint(" cn = ");
bprint(ftos(cn));
bprint(" len = ");
bprint(ftos(vlen(trace_endpos - org)));
bprint(".\n");
*/
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
/* CHECK: blocked, no rubble fn yet - restore later
			k = 2 + random() * 3;
			while(k > 0)
			{
				rubble_debris(trace_endpos, v_forward * -100 + randdir()*50, 2 + random() * 4, 0);
//				SpawnRubble(trace_endpos, v_forward * -100 + randdir()*50);
				k = k - 1;
			}
*/
		}

		if(!j || vlen(org - destination) < 5)
			return; // hit something solid or finished

		org = trace_endpos;
		startent = impactent;
		damage = damage * 0.75;
		i = i - 1;
	}
};
