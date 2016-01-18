/*
		+---------------------------------------+
		|  Flame thrower code                   | SEC-HEAD
		+---------------------------------------+
*/
// Original code by Steve Bond


float FLAME_CHECK = FALSE; // set true to see flame check messages

void() flamer_precache =
{
	precache_model ("progs/g_flamer2.mdl");
	precache_model ("progs/v_flamer2.mdl");
	precache_model ("progs/vw_flamer2.mdl");
	precache_model ("progs/vw_gascyl.mdl");
	precache_model ("progs/g_gas.mdl");

	precache_sound ("flm/ft_fire.wav");
	precache_sound ("flm/ft_hum.wav");
	precache_sound ("flm/burning.wav");
	precache_sound ("flm/airhiss1.wav");
//	precache_sound ("flamethrower/.wav");
};



// fn(gas_gauge) - calculate gauge indication level

// returns weaponframe for indicator
// cammo - current ammo

float(float cammo) gas_gauge =
{
	local float lvl;
	if      (cammo  <  40) lvl = rint((cammo / 38) * 7.4);
	else if (cammo  < 120) lvl = rint(((cammo - 40)/ 79) * 7.4) + 8;
	else if (cammo  < 150) lvl = 16;
	else if (cammo  < 200) lvl = 17;
	else if (cammo  < 210) lvl = 18;
	else if (cammo  < 220) lvl = 19;
	else if (cammo == 220) lvl = 20;

	return(lvl);
};

// fn(player_flamer1) - animate fire sequence

void () player_flamer1 = [ 31, player_flamer2 ]
{
	self.weaponframe = 21;
};

void () player_flamer2 = [ 36, player_flamer3 ]
{
	self.weaponframe = 22;
};

void () player_flamer3 = [ 35, player_flamer4 ]
{
	self.weaponframe = 23;
};

void () player_flamer4 = [ 31, player_run ]
{
	self.weaponframe = self.firecontrol = gas_gauge(self.currentammo);
};


void () DeathBubblesSpawn;

// Slightly varied version of DeathBubbles
void(float num_bubbles, vector bub_origin) NewBubbles =
{
	local entity  bubble_spawner;
	
	bubble_spawner = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, bub_origin, '0 0 0', '0 0 0', '0 0 0', '0 0 0', "bubblespawn", null_string, SUB_Null, 0.1, DeathBubblesSpawn, SUB_Null, self, world);

	bubble_spawner.bubble_count = num_bubbles;
	return;
};

// fn(grab_fire) - some dummy tried to pick up a fire
// IDEA: handle static fires?

// e is being picked up and should be a fire
// self is ent doing pick

float(entity e) grab_fire =
{
	local entity sv;

	if (e == world) return(FALSE);
	if (IS_LAVA(self)) return(FALSE); // hotties can play with fire

	sv = self;
	if (e.classname == "fire") // hot things burn when picked up  FIX: use a different string (sFloating = sEnv)
		{
		if (e.owner == self) e.owner = world; // owner of fire is trying to get it - only chaos and cthon can play with thier own fire
		other = self;
		self = e;
		if (e.touch != SUB_Null) e.touch(); // fire has defined a touch or default to flame touch
		else FlameTouch();
		}
	self = sv;
	return(TRUE); // forest fires are started by dummies like this one...
};

void (vector fireorg) SpawnTouchFlame =
{
	newmis = chaos_spawn(MOVETYPE_FLYMISSILE, SOLID_NOT, 0, 0, fireorg, '0 0 0', '0 0 0', '0 0 0', '0 0 75', "fire", "progs/s_explod.spr", SUB_Null, 0, s_explode1, SUB_Null, self, world);

//	newmis.grab_callback = grab_fire;
};

float ST_HEALFIRE = 0.1;

void () BurnThem =
{
	// water level check first
	if (self.enemy.waterlevel >= 1)
	{
#ifdef warning
																											if (WARNING & 32) if (FLAME_CHECK) bprint("fire out - water\n");
#endifdef

		NewBubbles(6,self.enemy.origin);

// make extinguish noise
		sound (self.enemy, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONFIRE);
	}
	else if (self.enemy.items & IT_SUIT)
	{
#ifdef warning
																												if (WARNING & 32) if (FLAME_CHECK) bprint("fire out - suit\n");
#endifdef
		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONFIRE);
	}
	else if (self.enemy.health <= 0 || self.enemy.deadflag) // NOTE: could turn into burning corpse - doesnt seem too - also makes burning deathcam effect
	{
		if (random() < 0.5) {self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONFIRE); // NOTE: must xfer to corpse in morph die
#ifdef warning
																														if (WARNING & 32) if (FLAME_CHECK) bprint("fire out - dead\n");
#endifdef
			}
#ifdef warning
																														else if (WARNING & 32) if (FLAME_CHECK) bprint("corpse on fire\n");
#endifdef
	}
	else if (self.enemy.health > 0) // NOTE: remove d_b when all things die
	{

		if (self.enemy.healtype > HEAL_NORM) // stopped by any special heal - IDEA: includes d_berserk and q2_adrenaline
		{
#ifdef warning
																													if (WARNING & 32) if (FLAME_CHECK) bprint("fire out - mega heal\n");
#endifdef
//		self.enemy.healtype = -1; box stops all plague ents
			self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONFIRE);
		}	
		else if (self.enemy.healtype == HEAL_ROT || self.enemy.healtype == HEAL_NORM)
		{
//	if ((random() * 100) < (self.healamount * 0.5))
			if (random() < ST_HEALFIRE) // % chance reg health puts out fire - base 10%
			{
#ifdef warning
																														if (WARNING & 32) if (FLAME_CHECK) { bprint("fire out - heal type: "); bprint(ftos(self.enemy.healtype)); bprint("\n"); }
#endifdef
				self.enemy.healtype = -1; // box only stops one flame ent
				self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONFIRE);
			}
			else if (random() < 0.7)
				self.enemy.healtype = -1; // not many chances per box
		}


		SpawnTouchFlame(self.enemy.origin);
		T_FireDamage (self.enemy, self, self.owner, 1);
		self.nextthink = time + 0.25;
	}
	else // default case - should not get here
	{
		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONFIRE);
#ifdef warning
																														if (WARNING & 32) if (FLAME_CHECK) bprint("put out fire - dont know why!\n");
#endifdef
	}

	if (!self.enemy.flags & FL_ONFIRE) // fire was put out
	{
		self.enemy.effects = self.enemy.effects - (self.enemy.effects & EF_DIMLIGHT);
		remove(self);
	}

};

// fn(FlameTouch) - handle fire / hot ents touching other ents
// self - hot item, other - toucher
// *** if FL_REMOVE is set self ent can be removed or become BurnThem thinker
// if called as fn and not a think, if other.takedamage is FALSE, a movestop can occur which plays burning.wav
// IDEA: handle static fires?

void () FlameTouch =
{
	local   float   rn;
	local entity fire;

	if (other)
	{
	if (other == self.owner)
		return;
	else if (other.classname == "monster_dragon") // IDEA: do this in T_FireDamage
		return;
	else if (other.waterlevel > 1)
		return;
	else if (other.invincible_finished >= time || other.invincible_finished < 0)
		return;
	else if (other.items & IT_SUIT)
		return;
	else if (other.flags & FL_ONFIRE) // already burning away
		return;
	}

	if (other.takedamage)
	{
		fire = self; // this is self if FL_REMOVE is set
		if (!self.flags & FL_REMOVE) // lava puddle or some other hot ent
			{
#ifdef warning
																														if (WARNING & 32) if (FLAME_CHECK) bprint("spawned flame touch fire ent\n");
#endifdef
			fire = spawn();
			fire.owner = self.owner;
			fire.dmg = self.dmg;
			}
		rn = random();
		// 20% chance
		if (rn <= 0.2 && !(other.flags & FL_ONFIRE) ) // IDEA: set chance by ents .* float value
		{
			// Fire stays with whatever it hits
			if (other.classname == "player")
			{
				centerprint(other,"You are on fire! Find water!\n");
				stuffcmd (other,"bf\n");
			}
			other.flags = other.flags | FL_ONFIRE;
			fire.enemy = other;
			fire.think = BurnThem;
			fire.nextthink = time;
			fire.solid = SOLID_NOT;
			setmodel (fire,null_string);
			other.effects = other.effects | EF_DIMLIGHT;
		}
		else // didnt catch on fire, do some burn damage & extinguish any flames
		{
			SpawnTouchFlame(other.origin);
			T_FireDamage (other, fire, fire.owner, fire.dmg );
			remove (fire);
		}
	}
	else if (other.classname == "worldspawn") // stop napalm and other shot fires at world (i.e. exclude other stuff that calls flametouch)
	{
		if (sky_touch(null_string, v0, self))
		{
			SUB_Remove();
		}	
		else
		if (!(self.flags & (FL_FLARE | FL_SUBFLARE)))
			{
				if (pointcontents(self.origin + '0 0 4') == CONTENT_SLIME) // because so many seem to slip by the content check if moving fast
				{
					self.watertype = CONTENT_SLIME;
					flame_check();
				}
				else
					move_stop(self, self.noise4);//"flm/burning.wav");
			}
	}
};

// flame made of neat burning sprites - may look awesome on engines that replace these sprites with a fire shader

// fn(s_flameburn0) - make napalm burn out
// fn(s_flameburn1) - make napalm burn for a bit

void()	s_flameburn0	=	[3,	s_explode5]
{
sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
/* if (self.flags & FL_HELD) if (self.enemy.holdent == self) // item_held() - we are held (chaos, lava), force drop
	{
	self = self.enemy;
	item_pick(v0);
	}*/
};
void()	s_flameburn1	=	[0,	s_flameburn2]
{
if ((self.flags & (FL_FLARE | FL_SUBFLARE)) && (self.rad_time < time))
	slime_flare();
};
void()	s_flameburn2	=	[1,	s_flameburn3]
{
//if ((self.flags & (FL_FLARE | FL_SUBFLARE)) && (self.rad_time < time))
//	slime_flare();
};
void()	s_flameburn3	=	[2,	s_flameburn1]
{
	if (self.dmgtime < time && self.state < 1  &&
	  !(self.enemy && self.flags & FL_HELD))			// item_held() test - assumes chaos | cthon holding fire and feeding it energy directly
			self.think = s_flameburn0;
	self.lip = self.lip + 1;
	if (self.lip > MAX_FLAME_CYC) self.think = s_flameburn0;
};

// fn(spawn_napalm) - create a napalm flame - normal flame thrower action
// self = spawning item, (player)
// org - flame origin

// IDEA: limit napalm growth with radius check

entity(vector org) spawn_napalm =
{

	fire_missile(GRENADE_VEL * 0.833335, MOVETYPE_BOUNCE, FL_MSL | FL_USEAMMO , RM_SKY | PF_WATER | FLT_IMM | FLT_LAVA | PF_LAVA | PF_SLIME,// | FLT_SLIME,
					 org, '0 0 0', "fire", "progs/s_explod.spr", null_string, FlameTouch, 0.15, s_flameburn1, flame_check);

	if (!newmis) return(world); // what happened here?
	newmis.solid = SOLID_TRIGGER;
	newmis.class_select = "class_fire";
	newmis.enemy = world; // held test
//	newmis.grab_callback = grab_fire;
	newmis.dmg = 10;
	newmis.effects = EF_DIMLIGHT;
	newmis.state = newmis.wait = 0; // flare controls
	newmis.count = time;
	newmis.lip = 0;
	newmis.dmgtime = time + 1 + random() * 2;
	newmis.noise4 = "flm/burning.wav";

	return(newmis);
};

// fn(slime_flare) - check for flareup in slime, fire off flare
// setf - fires to start

void() slime_flare =
{
	local float setf;
	local entity fl, pwn;

//if ((self.wait < time) || (self.flags & FL_SUBFLARE))
//	{
//	self.wait = time + 0.3;

// limits on flares
	setf = cnt_ent(self, "class_select", "class_fire_flare");
	if (setf > MAX_FLARE) return; // too many fires / level
	setf = 0;
	fl = self.chain;
	while (fl)
	{
		if (vlen(self.origin - fl.origin) < FLARE_CK_RAD) setf = setf + 1;
		fl = fl.chain;
	}
	if (setf > MAX_AREA_FLARE) return;

	setf = 0.33 * (time - self.count); // upped from .25, doesnt seem to happen often enough
	if (setf > MAX_FLARE_CHANCE) setf = MAX_FLARE_CHANCE;
#ifdef warning
													if (WARNING & 32)
													if (!(self.flags & FL_SUBFLARE) && FLAME_CHECK)
													{
														bprint("flare chance ");
														bprint(ftos(setf));
														bprint("\n");
													}
#endifdef
	if ((self.flags & FL_SUBFLARE) | ((self.flags & FL_FLARE) && self.state)  | (random() < setf)) // create the flare
		{
#ifdef warning
													if (WARNING & 32)
													if (FLAME_CHECK)
													if (!(self.flags & FL_SUBFLARE)) 
														{
														bprint("success at chance: ");
														bprint(ftos(setf));
														bprint("\n");
														}
#endifdef

		setf = 1 + rint(random() * 3); // start more fires
#ifdef warning
														if (WARNING & 32)
														if (FLAME_CHECK && !self.aflag)
														{
															if (self.flags & FL_SUBFLARE) bprint("sub flare ");
															bprint("starting: ");
															bprint(ftos(setf));
															bprint(" fires\n");
														}
#endifdef

		if (self.flags & FL_FLARE && !self.aflag)  // we started the flare up
			{
//			self.watertype = CONTENT_EMPTY;//th_stand = SUB_Null; // no more flare up, for now
//			self.count = time; // reset time on master fire
			if (!self.state)
				{
				self.state = rint(10 + random() * (time - self.count)) - setf;
				}
			else
				{
				self.state = self.state - setf; // main flare started fires after first rnd
				}
			if (self.state <= 0) // done setting fires
			{
				setf = setf + self.state;
				self.flags = self.flags - (self.flags & FL_FLARE);
			}
			self.aflag = setf;
//			self.rad_time = time + 0.5 + random() * 0.5; // before we can start more fires
			pwn = self; // self is owner
#ifdef warning
														if (WARNING & 32)
														if (FLAME_CHECK)
														{
															bprint("total fires left: ");
															bprint(ftos(pwn.state));
															bprint("\n");
														}
#endifdef
			}

		if (self.flags & FL_SUBFLARE && !self.aflag) 
			{
			if (self.noise4 != null_string) sound (self, CHAN_WEAPON, self.noise4, 1, ATTN_NORM);
			self.noise4 = null_string;
//			self.th_stand = flame_check; // after flare duties, got to regular test
//			content_cycle(self, self.content_flag, CONTENT_CHKTM);
			pwn = self.owner;
			if (pwn && pwn.state > 0 && (pwn.flags & FL_FLARE))
				{
				pwn.state = pwn.state - setf;
				}
			else // owner gone, take over setting fires
				{
//				if (self.state < 0) return;
//				self.flags = (self.flags - FL_SUBFLARE) | FL_FLARE;
//														if (WARNING & 32) if (FLAME_CHECK) bprint("took over for owner\n");
				self.flags = self.flags - (self.flags & FL_SUBFLARE);
				if (random() < 0.1) self.flags = self.flags | FL_FLARE;
				self.rad_time = time + 1 + random() * 0.6; // before we can start more fires
				self.count = time;
				return;
				}
//			self.rad_time = time + 0.5 + random() * 0.8; // before we can start more fires
			self.aflag = setf;
			}
//		while (setf > 0)
//			{
#ifdef warning
														if (WARNING & 32)
														if (FLAME_CHECK)
														{
															bprint("loop fires left: ");
															bprint(ftos(self.aflag));
															bprint("\n");
														}
#endifdef
			fl = spawn_napalm(self.origin);
			if (!fl) return;
//			content_clear(fl);
			fl.watertype = 0;
			fl.rad_time = time + 0.3 + random() * 0.3; // before we can start more fires
			fl.class_select = "class_fire_flare";
			fl.owner = pwn;
			fl.flags = fl.flags | FL_SUBFLARE;
//			droprnd(v0, fl);
			item_eject(fl, v0);
//			floaterEnable(fl, -2);
			fl.bubble_count = NO_BUBBLES;
//			setf = setf - 1.0;
			self.aflag = self.aflag - 1;
			if (self.aflag > 0) self.rad_time = 0.2 + random() * 0.6;
			else self.aflag = 0;
//			}
		}
//	}
};

// fn(flame_check) - extend burn time in lava, extinguish in water

void() flame_check =
{

if (self.watertype == CONTENT_LAVA)
	{
	self.dmgtime = self.dmgtime + random() * 3;
	if (random() < 0.2) self.dmgtime = self.dmgtime + 3 + random() * 9;
	self.content_flag = self.content_flag - (self.content_flag & PF_LAVA);
	}
else if (self.watertype == CONTENT_WATER)
	{
	s_flameburn0();
	self.think = s_flameburn0;
	self.content_flag = self.content_flag - (self.content_flag & PF_WATER);
	}
else if (self.watertype == CONTENT_SLIME)
	{
	if (self.noise4 != null_string) sound (self, CHAN_WEAPON, self.noise4, 1, ATTN_NORM);
	self.noise4 = null_string;
	if ((self.flags & FL_SUBFLARE) && self.owner && self.owner.state > 0) return; // subflare cant flare till all fires are started
	if (random() < 0.2) self.dmgtime = self.dmgtime + 1 + random() * 3;
//	content_clear(self);
	self.watertype = 0;
	self.rad_time = time + 0.5 + random() * 0.5;
	self.dmgtime = self.dmgtime + random();
	self.count = time;
	self.flags = FL_FLARE;
	self.class_select = "class_fire_flare";
	self.owner = world; // no longer belong to a player -- belong to the slime god now
//	floaterEnable(self, -2);
	self.bubble_count = NO_BUBBLES;
	if (self.velocity_z < -80) self.velocity_z = -20;
	}
};

void() W_FireFlamer =
{
	if (self.waterlevel > 2)
	{
		makevectors (self.v_angle);
		NewBubbles(2, self.origin+v_forward*64);

		sound (self, CHAN_WEAPON, "flm/airhiss1.wav", 1, ATTN_NORM);
//	local   float rn;
//		rn = random();
//		if (rn < 0.5)
//			sound (self, CHAN_WEAPON, "flamethrower/airhiss1.wav", 1, ATTN_NORM);
//		else
//			sound (self, CHAN_WEAPON, "misc/water2.wav", 1, ATTN_NORM);

		self.chaosweptime = MAXFL;
		self.attack_finished = time + 1;
		return;
	}

	EWEAP = self.eweapon;

	self.chaosweptime = 0;
	ominous_hum(EWEAP.noise3, EWEAP.chaosweptime);
	spawn_napalm(self.origin + v_forward * VWX_FLAMER + v_right * VWY_FLAMER + v_up * VWZ_FLAMER); // fire, fire, heheheh!

	EWEAP = world;
};

// fn(flamer_pull) - drop | pull vmodel framing

void (float frcnt) flamer_pull =
{
self.weaponframe = frcnt + 23;
};

// fn(V_FlamerAnim) - animate new flamer vmodel gauge

void() V_FlamerAnim =
{
	local float d;

//	if (self.flags & (FL_PULL | FL_DROP)) return;
	if (!(self.cam_x & CHSCAM_ON))
	if (self.dmgtime < time)
	{
		self.dmgtime = time + 1;
		self.flags = self.flags | FL_VANM;
		self.firecontrol = gas_gauge(self.currentammo);
		if (self.weaponframe == 21) self.weaponframe = 0;
		if (self.firecontrol < self.weaponframe) d = -1; 	
		else if (self.firecontrol > self.weaponframe) d = 1;
		self.weaponframe = self.weaponframe + d;
		if (d) self.dmgtime = time + 0.2;
	}
};

void () weapon_flamer =
{
	q100_weapon_lightning();
	self.netname = "Flame thrower";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireFlamer;
	self._fr_attack = player_flamer1;

// stats
	self.currentammo = 50;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_GAS;
	self.attack_finished = 0.1;
	self.dmg = 10;
	self.dmg_save = 1;

// appearances
	setmodel (self, "progs/g_flamer2.mdl");
	self.weaponmodel = "progs/v_flamer2.mdl";
	self.vwepmdl = "progs/vw_flamer2.mdl";
//	self.target1 = "progs/";
//	self.noise = ".wav";
	self.noise3 = "flm/ft_fire.wav";
	self.noise2 = "flm/ft_hum.wav";
//	self.noise4 = ".wav";
//	self.target = ".wav";
	self.chaosweptime = 1.2;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "x_item";
};

void() ammo_gas =
{
	item_spikes();
	self.touch = pk_ammo_touch;
	self.netname = "Gas cylinders";

	self.lip = AMMO_GAS;
	self.currentammo = 24;
	if (self.spawnflags & 1)
	{
		self.currentammo = 48;
		self.frame = 1;
		self.skin = 1;
	}

	self.classname = "ammo_gas";
	setmodel (self, "progs/g_gas.mdl");
//	self.map = " lbs gas cylinder pressure";
//	self.volume = MAX_GAS;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "x_item";
};

void() ammo_gas_lg =
{
	self.spawnflags = self.spawnflags | 1;
	ammo_gas();
};
