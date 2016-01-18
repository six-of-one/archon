/* ::-::
 *
 * Cataboligne
 *
 * file:m-wizard.qc
 *
 * date: 9/21/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/

/*
==============================================================================

WIZARD

==============================================================================
*/

$cd /raid/quake/id1/models/a_wizard
$origin 0 0 24
$base wizbase	
$skin wizbase

$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7
$frame attack8 attack9 attack10 attack11 attack12 attack13

$frame pain1 pain2 pain3 pain4

$frame death1 death2 death3 death4 death5 death6 death7 death8

void() m_precache_wizard =
{
//// Wizard morph
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
};

void() player_wizard_stand = [ $hover1, player_stand1 ] {
	if(self.walkframe >= 15)
		self.walkframe = 0;
	if (self.walkframe == 6)
		{
		if (random() < 0.6)
			morph_sound(0.2, "wizard/widle2.wav", 4);
		else
			morph_sound(0.2, "wizard/widle1.wav", 3);
		}
	self.frame = $hover1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() player_wizard_run = [ $fly1, player_run ] {
	if(self.walkframe >= 14)
		self.walkframe=0;
	self.frame = $fly1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	if ( !(self.hook & HOOK_IN) )
		if ( !(self.flags & FL_ONGROUND) ) self.flags = self.flags | FL_ONGROUND;
	// fix teleport hack - needs to be called in teleport code
};

void() player_wizard_jump = {
	self.velocity_z = 200;
	Wiz_idlesound();
};

////////////////////////////////////////////
// 4 frames of pain for player_wizard, going to player_stand1
////////////////////////////////////////////

void() player_wizard_pain1 = [ $pain1, player_wizard_pain2 ]
{
	self.pain_finished = time + 1.2;
	morph_sound (0.8, self.noise2, 1);
};
void() player_wizard_pain2 = [ $pain2, player_wizard_pain3 ] { };
void() player_wizard_pain3 = [ $pain3, player_wizard_pain4 ] { };
void() player_wizard_pain4 = [ $pain4, player_stand1 ] { };

// fn(player_Wiz_FastFire) - fire wizard spikes & spike bombs
// fn(Wiz_MissileTouch) - blow spike bombs, handles other creatures missiles, shoots sub missiles
// fn(Wiz_fireBolt) - fire off a regular wizard bolt
// fn(pointer_Wiz_fireBolt) - wizard bolt fire_burst call
// fn(pointer_hk_fire_spike) - hk_fire_spike fire_burst call
// fn(Wiz_fireBomb) - fire off the wizard explosive of choice...ok its the _only_ explosive

void() Wiz_MissileTouch;
void(vector or1) hk_fire_spike;

void(vector dir) Wiz_fireBolt =
{
	fire_missile(SCRAGG_SHT_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, self.origin, dir, "wizspike", "progs/w_spike.mdl", "", spike_touch, 6, SUB_Remove, spike_touch);
};

void() pointer_Wiz_fireBolt =
{
	Wiz_fireBolt(v0);
};

void() pointer_hk_fire_spike =
{
	hk_fire_spike(v0);
};

void() Wiz_fireBomb =
{
	fire_missile(SCRAGG_SHT_VEL * 0.8, MOVETYPE_FLYMISSILE, 0 , RM_SKY | PF_LAVA, self.origin, v0, "missile", "progs/w_spike.mdl", "", Wiz_MissileTouch, ROCKET_FUSE,  Wiz_MissileTouch, Wiz_MissileTouch);
	newmis.frame = 1;
	newmis.dmg = 75;
};





// TDO: put in imp
void() imp_firePlasma =
{
	fire_missile(PLASMA_VEL + 200, MOVETYPE_FLYMISSILE, FL_MSL | FL_PUNCH , RM_SKY | PF_LAVA, self.origin + v_forward* 16.0 + v_right * 16  + ' 0 0 18', ' 0 0 0', "missile", "progs/d_plasma_sht.mdl", "imp/fire.wav", Plasma_MissileTouch, ROCKET_FUSE,  plasmaexplode1, Plasma_MissileTouch);
	newmis.skin = 2; // imp plasma ball red skin
	newmis.frame = 2;
	newmis.dmg = 15;
//	newmis.avelocity_x = (crandom () * 300);
//	newmis.avelocity_y = (crandom () * 300);
};

void() imp_fireBomb =
{
	fire_missile(ROCKET_VEL, MOVETYPE_FLYMISSILE, FL_MSL | FL_PUNCH , RM_SKY | PF_LAVA, self.origin + v_forward* 16.0 + v_right * 16  + ' 0 0 18', ' 0 0 0', "missile", "progs/d_plasma_sht.mdl", "imp/fire.wav", Wiz_MissileTouch, ROCKET_FUSE,  plasmaexplode1, Wiz_MissileTouch);
	newmis.skin = 2; // imp plasma ball red skin
	newmis.frame = 1;
	newmis.dmg = 85;
};








void() Wiz_MissileTouch =
{
	local float wdmg;
	local vector org;
	local string mon;

	if (other)
	if (other == self.owner)
	{
		return;
	}

	if (sky_touch("", v0, self))
	{
		SUB_Remove();
		return;
	}

	if (!self.dmg) {self.dmg = 60; if (WARNING) bprint("wiz missle touch set def damage\n");}

	org = v0;
	v_forward = normalize(self.velocity);
	org = lava_shot(self.origin, LAVA_SHOT * 2.4, v0, self.dmg / 10);
	if (org != v0)
	{
		self.origin = org;
/*
		if (random() < LAVA_PLASMA_MLT)
		{ if (WARNING) bprint("wiz plasma bomb failed in lava\n");
			content_clear(self);
			self.th_stand = self.touch = SUB_Null;
			move_stop(self, "misc/null.wav");
			self.think = meltthink;
			self.nextthink = time + random() * 3;
			return;
		}
*/
	}

	if (self.model == "progs/w_spike.mdl")
		mon = "monster_wizard";
	else if (self.model == "progs/k_spike.mdl")
		mon = "monster_hell_knight";
	else
		mon = "monster_imp";

	if ((other.classname == mon) || other.morphy == self.owner.morphy) // NOTE: this code will allow shots to BOUNCE OFF friendlys!
	{
		return;
	}

	org = normalize(self.velocity) * -4; // back away from strike surface a bit

	if (mon == "monster_wizard")
	{
		if (random() > 0.05)
			fire_burst (pointer_Wiz_fireBolt, self.origin + org, 0, 0, "", "", 0, 6, 8, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_FRCORG | FL_OWNOWN, world);
		else
			fire_burst (Wiz_fireBomb, self.origin + org, 0, 0, "", "", 0, 2, 1, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND | FL_FRCORG | FL_OWNOWN, world);
	}
	else if (mon == "monster_hell_knight")
			fire_burst (pointer_hk_fire_spike, self.origin + org, 0, 0, "", "", 0, 6, 8, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_FRCORG | FL_OWNOWN, world);
	else if (mon == "monster_imp" && random() < 0.4)
	{
		if (random() > 0.1)
			fire_burst (imp_firePlasma, self.origin + org, 0, 0, "", "", 0, 6, 8, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_FRCORG | FL_OWNOWN, world);
		else
			fire_burst (imp_fireBomb, self.origin + org, 0, 0, "", "", 0, 3, 1, ' 0 0 0', ' 360 360 360', SUB_Null, FL_ANGADR | FL_VELRND | FL_FRCORG | FL_OWNOWN, world);
	}

	if (random() < 0.05) wdmg = random() * 50;
//	if (other) if (other.solid == SOLID_SLIDEBOX) other.dmg = wdmg + 50 + random() * 20;
//	Explode(wdmg + 50 + random() * 20, self.dmg + random() * 20 + wdmg, other, TE_EXPLOSION, 0, BecomeExplosion); // TDO: plasma explosive def dmg

		// stand in for above fn
					T_RadiusDamage (self,self.owner,self.dmg + random() * 20 + wdmg,world);

					WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
					WriteByte (MSG_BROADCAST,TE_EXPLOSION);
					WriteCoord (MSG_BROADCAST,self.origin_x);
					WriteCoord (MSG_BROADCAST,self.origin_y);
					WriteCoord (MSG_BROADCAST,self.origin_z);

					BecomeExplosion ();
};

void() player_Wiz_FastFire =
{
	local float offset, offmlt;
	local vector dir;

	offmlt = 2; //super spikes have less spread
	if (self.weapon == IT_SHOTGUN) offmlt = 10;
	
	if(random()>0.75) offset=0;
	else if(random()>0.5) offset=0-(random()*offmlt);
	else offset=random()*offmlt;

	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		Wiz_fireBomb();
		newmis.avelocity_z = (crandom () * 300);
	}
	else
	{
		dir=self.v_angle;
		dir_y=dir_y+offset;

		Wiz_fireBolt(dir);
	}
};

////////////////////////////////////////////
// 13 frames of attack for player_wizard, going to player_stand1
////////////////////////////////////////////

/*
void() player_wizard_attack1 = [ $attack1, player_wizard_attack2 ] { self.attack_finished = time + 1.5; };
void() player_wizard_attack2 = [ $attack2, player_wizard_attack3 ] { };
void() player_wizard_attack3 = [ $attack3, player_wizard_attack4 ] { };
void() player_wizard_attack4 = [ $attack4, player_wizard_attack5 ] { };
void() player_wizard_attack5 = [ $attack5, player_wizard_attack6 ] { };
void() player_wizard_attack6 = [ $attack6, player_wizard_attack7 ] { };
void() player_wizard_attack7 = [ $attack7, player_wizard_attack8 ] { };
void() player_wizard_attack8 = [ $attack8, player_wizard_attack9 ] { };
void() player_wizard_attack9 = [ $attack9, player_wizard_attack10 ] { };
void() player_wizard_attack10 = [ $attack10, player_wizard_attack11 ] { };
void() player_wizard_attack11 = [ $attack11, player_wizard_attack12 ] { sound(self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);};
void() player_wizard_attack12 = [ $attack12, player_wizard_attack13 ] {player_Wiz_FastFire(-10); };
void() player_wizard_attack13 = [ $attack13, player_stand1 ] { player_Wiz_FastFire(-10);};
*/

void() player_wizard_painleech =  [ $attack1, player_wizard_painleech2 ] {};
void() player_wizard_painleech2 = [ $pain1,   player_wizard_painleech3 ] {};
void() player_wizard_painleech3 = [ $pain2,   player_wizard_painleech4 ]
{
	float FULL_EFFECT_DIST = 50; // effect increases at < this dist - decreases outside this range
	float MAX_EFFECT_DIST = 300; // no effect at all beyond this dist
	float dist, ext;					// particle spray cnt, dist to vic, mlt to add
	local entity head;
	
	dist = 4 + random() * 4;
	while (dist > 0) // particle effects
	{
		dist = dist - 1;
		chaos_particle(self.origin, 100, 1, 56 + random() * 6);
	}
	// IDEA: some short range lbolts?

	head = findradius(self.origin, MAX_EFFECT_DIST);
	while (head) // IDEA - clear these (arachno too) when attack stops
	{
		if (head != self)
		if (head.solid == SOLID_SLIDEBOX)  // BLOODCHECK - this is one for sure that we might want FL_CLIENT, FL_MONSTER so its more inclusive
		{
			ext = !IS_ZOMBIE(head); // exclusion test
			if (ext) // doh - no life here
			if (head.takedamage)
			{
				dist = vlen(head.origin - self.origin);
				if (head.lastvictim != self || head.cnt < 2)
				{
					head.lastvictim = self;
					head.cnt = 1;
				}
				T_Damage (head, self, self, head.cnt * (FULL_EFFECT_DIST / dist));
				if (!morph_ffchk(self,head))
				{
					if (head.cnt * (FULL_EFFECT_DIST / dist) > 8)
						SpawnBlood (head.origin, ' 0 0 0', head.cnt * (FULL_EFFECT_DIST / dist));
					if (self.health < self.max_health * self.health_modifier) T_Heal(self, head.cnt * 0.8 * (FULL_EFFECT_DIST / dist), FALSE);	// 50% heal from damage if < max health
					else if (random() < 0.35) T_Heal(self, head.cnt * 0.05 * (FULL_EFFECT_DIST / dist), TRUE);																			// 5% heal, ignore max
				}
if (WARNING)
{
bprint("p vic: ");
bprint(head.classname);
bprint(" dmg: ");
bprint(ftos(head.cnt * (FULL_EFFECT_DIST / dist)));
bprint("\n");
}
				dist = 1 + random() * 1.7;
//				if (random() < 0.1) mlt = 2 + random() * 9;
				head.cnt = head.cnt * dist;
				if (head.cnt > 16) head.cnt = 16; // IDEA - backfire (rev heal add/loss) & overload lockout
			}
		}
		head = head.chain;
	}
};
void() player_wizard_painleech4 = [ $pain1,   player_stand1            ] {};
	
void() player_wizard_attack1 = [ $attack1, player_wizard_attack3 ]
	{
	if (self.weapon == IT_SHOTGUN) self.attack_finished = time + 1.0;				// plain old spikes
	else
		{
		self.attack_finished = time + 0.4;
		if (self.weapon == IT_ROCKET_LAUNCHER) self.attack_finished = time + 1.1;
		player_Wiz_FastFire();  																// concentrated spikes || spike bomb
		}
	};
void() player_wizard_attack2 = [ $attack3, player_wizard_attack3 ] { };
void() player_wizard_attack3 = [ $attack5, player_wizard_attack4 ] 
	{
	if (self.weapon == IT_SUPER_SHOTGUN) player_Wiz_FastFire(); 							// concentrated spikes
	};
void() player_wizard_attack4 = [ $attack7, player_wizard_attack5 ] 
	{ sound(self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM); };
void() player_wizard_attack5 = [ $attack9, player_wizard_attack6 ]
	{ if (self.weapon != IT_ROCKET_LAUNCHER) player_Wiz_FastFire(); };							// concentrated  || reg. spikes
void() player_wizard_attack6 = [ $attack11, player_wizard_attack7 ]
	{ if (self.weapon == IT_SHOTGUN) player_Wiz_FastFire(); };							//  reg. spikes
void() player_wizard_attack7 = [ $attack13, player_stand1 ]
	{ if (self.weapon != IT_ROCKET_LAUNCHER) player_Wiz_FastFire();};							// concentrated  || reg. spikes


void() player_wizard_attack =
{
	if(self.weapon == IT_AXE)
	{
		self.attack_finished = time + 0.5;
		player_wizard_painleech();
	}
	else
	{
		player_wizard_attack1();
	}
};

// fn(player_wizard_impulse) - for extra balance weps

void() player_wizard_impulse =
{
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	if (self.pk_currentitem != PK_IT_AXE) return; // selected a pk goody - dont re-message

	if (self.weapon == IT_AXE)
	{
		sprint(self, "Scragg  using ( Pain field )\n");
	}
	if (self.weapon == IT_SHOTGUN)
	{
		sprint(self, "Scragg using ( Spikes )\n");
		self.items = self.items | IT_CELLS;
	}
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		sprint(self, "Scragg using ( Super Spikes )\n");
		self.items = self.items | IT_CELLS;
	}
	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		sprint(self, "Scragg using ( Explosive spike )\n");
		self.items = self.items | IT_CELLS;
	}
};



string() player_wizard_killmsg = {
	return " was scragged by ";
};

string() player_wizard_killmsg2 = {
	return ".\n";
};

void(float silent) player_wizard_become = {
	self._stand=player_wizard_stand;
	self._run=player_wizard_run;
	self._pain=player_wizard_pain1;
	self._die=wiz_die;
	self._jump=player_wizard_jump;
	self._jump2=player_wizard_jump;
	self._attack=player_wizard_attack;
	self._impulse=player_wizard_impulse;
//	self._can_get_p=SUB_False;
//	self._killmsg=player_wizard_killmsg;
//	self._killmsg2=player_wizard_killmsg2;
	setmodel(self,"progs/wizard.mdl");

	self.builtin = self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_ROCKET_LAUNCHER;
	self.weapon = IT_SUPER_SHOTGUN;

//	self.mask_x = CB_SCRAG;
//	W_SetCurrentAmmo(self);
//	self._hk_major = morph_major;
//	self._hk_lesser = morph_lesser;
	self.msight = "wizard/wsight.wav";
	self.noise2 = "wizard/wpain.wav";
	self.noise3 = "";
	self.movetype = MOVETYPE_FLY;
//	if(!deathmatch)
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
//	 	setsize (self, '-16 -16 -24', '16 16 40');
	self.view_ofs = '0 0 28'; // raised 6
	self.cam_z = 0.32;
	self.health = self.health * MWIZARD_HEALMOD / self.health_modifier;
	self.health_modifier = MWIZARD_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become a scrag.\n");
		}
};
