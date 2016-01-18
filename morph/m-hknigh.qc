/* ::-::
 *
 * Cataboligne
 *
 * file: m-scourge.qc
 *
 * date: 9/14/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/


$cd /raid/quake/id1/models/knight2
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

void() m_precache_hknight =
{
//// Hell knight morph
	precache_model ("progs/hknight.mdl");
	precache_model ("progs/k_spike.mdl");
	precache_model ("progs/h_hellkn.mdl");
	
	precache_sound ("hknight/attack1.wav");
	precache_sound ("hknight/death1.wav");
	precache_sound ("hknight/pain1.wav");
	precache_sound ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound ("hknight/slash1.wav");
	precache_sound ("hknight/idle.wav");
	precache_sound ("hknight/grunt.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
};

void() player_hknight_stand = [ $stand1, player_stand1 ] {
	if(self.walkframe >= 9)	
		self.walkframe = 0;
	if (self.walkframe == 2) morph_sound(0.2, "hknight/idle.wav", 3);
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() player_hknight_run = [ $run1, player_run ]
{
	vector sp;
	local float walk, frm;

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 20) self.walkframe = 0;
		}
	else
		{
		frm = $run1;
		if (self.walkframe >= 8) self.walkframe = 0;
		}

	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

////////////////////////////////////////////
// 5 frames of pain for player_hknight, going to player_stand1
////////////////////////////////////////////

void() player_hknight_pain1 = [ $pain1, player_hknight_pain2 ] { };
void() player_hknight_pain2 = [ $pain2, player_hknight_pain3 ] { };
void() player_hknight_pain3 = [ $pain3, player_hknight_pain4 ] 
{
	if (random() < 0.4) sound (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
};
void() player_hknight_pain4 = [ $pain4, player_hknight_pain5 ] { };
void() player_hknight_pain5 = [ $pain5, player_stand1 ] { };

void() player_hknight_pain =
{
	self.pain_finished = time + 1;
	player_hknight_pain1();
};

void(vector or1) hk_fire_spike =
{
	fire_missile(FIREBALL_WEP_VEL, MOVETYPE_FLYMISSILE, 0, RM_SKY | PF_LAVA, or1, ' 0 0 0', "knightspike", "progs/k_spike.mdl", "hknight/attack1.wav", spike_touch, 6,  SUB_Remove, spike_touch);
	newmis.morphy = self.morphy;
};

void(float offset) player_hknight_shot =
{
	local	vector	offang;
	local	vector	org, vec;

	if (self.weapon != IT_ROCKET_LAUNCHER)
	{
		offang = self.v_angle;
		offang_y = offang_y + offset * 6;
		if (offset == 0) offang_z = offang_z + 4 * random(); // vertical diff for focus shot
		
		makevectors (offang);
	}
	else if (offset == 0) return; // explosive shot only happens once

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
// set missile speed
	vec = normalize (v_forward);

	if (self.weapon != IT_ROCKET_LAUNCHER) vec_z = vec_z + (random() - 0.5)*0.1;

	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		fire_missile(SHALRATH_SHT_VEL, MOVETYPE_FLYMISSILE, 0 , RM_SKY | PF_LAVA, org, ' 0 0 0', "missile", "progs/k_spike.mdl", "hknight/attack1.wav", Wiz_MissileTouch, ROCKET_FUSE,  Wiz_MissileTouch, Wiz_MissileTouch);
//		fire_missile(SHALRATH_SHT_VEL, MOVETYPE_FLYMISSILE, 0 , RM_SKY | PF_LAVA, org, ' 0 0 0', "missile", "progs/k_spike.mdl", "hknight/attack1.wav", SUB_Remove, ROCKET_FUSE,  SUB_Remove, SUB_Remove);
		newmis.avelocity_z = (crandom () * 300);
		newmis.frame = 1;
		newmis.dmg = 80;
		newmis.morphy = self.morphy;
		return;
	}

	hk_fire_spike(org);
	newmis.velocity = vec*300;
//	fire_missile(300, MOVETYPE_FLYMISSILE, FL_MSL , RM_SKY | PF_LAVA, org, ' 0 0 0', "knightspike", "progs/k_spike.mdl", "hknight/attack1.wav", spike_touch, 6,  SUB_Remove, SUB_Remove);

};

void(string miss, string whit, string fhit) player_hknight_sword =
{
	W_FireAxe(); // FIX:
//	melee_damage(self.origin + '0 0 16', self.origin + '0 0 16' + v_forward*96, 20, 20, 0, TE_GUNSHOT, miss, whit, fhit);
};
////////////////////////////////////////////
// 10 frames of slice for player_hknight, going to player_stand1
////////////////////////////////////////////

void() player_hknight_slice1 = [ $slice1, player_hknight_slice2 ] { };
void() player_hknight_slice2 = [ $slice2, player_hknight_slice3 ] { };
void() player_hknight_slice3 = [ $slice3, player_hknight_slice4 ] { };
void() player_hknight_slice4 = [ $slice4, player_hknight_slice5 ] { player_hknight_sword("weapons/ax1.wav", "player/axhit2.wav", "zombie/z_hit.wav"); };
void() player_hknight_slice5 = [ $slice5, player_hknight_slice6 ] { };
void() player_hknight_slice6 = [ $slice6, player_hknight_slice7 ] { player_hknight_sword("", "", ""); };
void() player_hknight_slice7 = [ $slice7, player_hknight_slice8 ] { };
void() player_hknight_slice8 = [ $slice8, player_hknight_slice9 ] { };
void() player_hknight_slice9 = [ $slice9, player_hknight_slice10 ] { };
void() player_hknight_slice10 = [ $slice10, player_stand1 ] { };

////////////////////////////////////////////
// 11 frames of smash for player_hknight, going to player_stand1
////////////////////////////////////////////

void() player_hknight_smash1 = [ $smash1, player_hknight_smash2 ] { };
void() player_hknight_smash2 = [ $smash2, player_hknight_smash3 ] { };
void() player_hknight_smash3 = [ $smash3, player_hknight_smash4 ] { };
void() player_hknight_smash4 = [ $smash4, player_hknight_smash5 ] { };
void() player_hknight_smash5 = [ $smash5, player_hknight_smash6 ] { player_hknight_sword("weapons/ax1.wav", "player/axhit2.wav", "zombie/z_hit.wav"); };
void() player_hknight_smash6 = [ $smash6, player_hknight_smash7 ] { };
void() player_hknight_smash7 = [ $smash7, player_hknight_smash8 ] { player_hknight_sword("", "", ""); };
void() player_hknight_smash8 = [ $smash8, player_hknight_smash9 ] { };
void() player_hknight_smash9 = [ $smash9, player_hknight_smash10 ] { player_hknight_sword("", "", ""); };
void() player_hknight_smash10 = [ $smash10, player_hknight_smash11 ] { };
void() player_hknight_smash11 = [ $smash11, player_stand1 ] { };

////////////////////////////////////////////
// 14 frames of magica for player_hknight, going to player_stand1
////////////////////////////////////////////

void() player_hknight_magica1 = [ $magica1, player_hknight_magica2 ] { };
void() player_hknight_magica2 = [ $magica2, player_hknight_magica3 ] { };
void() player_hknight_magica3 = [ $magica3, player_hknight_magica4 ] { };
void() player_hknight_magica4 = [ $magica4, player_hknight_magica5 ] { };
void() player_hknight_magica5 = [ $magica5, player_hknight_magica6 ] { };
void() player_hknight_magica6 = [ $magica6, player_hknight_magica7 ] { };
void() player_hknight_magica7 = [ $magica7, player_hknight_magica8 ] { player_hknight_shot(-2);};
void() player_hknight_magica8 = [ $magica8, player_hknight_magica9 ] { player_hknight_shot(-1);};
void() player_hknight_magica9 = [ $magica9, player_hknight_magica10 ] { player_hknight_shot(0);};
void() player_hknight_magica10 = [ $magica10, player_hknight_magica11 ] { player_hknight_shot(1);};
void() player_hknight_magica11 = [ $magica11, player_hknight_magica12 ] { player_hknight_shot(2);};
void() player_hknight_magica12 = [ $magica12, player_hknight_magica13 ] { player_hknight_shot(3);};
void() player_hknight_magica13 = [ $magica13, player_hknight_magica14 ] { };
void() player_hknight_magica14 = [ $magica14, player_stand1 ] { };

////////////////////////////////////////////
// 13 frames of magicb for player_hknight, going to player_stand1
////////////////////////////////////////////

void() player_hknight_magicb1 = [ $magicb1, player_hknight_magicb2 ] { };
void() player_hknight_magicb2 = [ $magicb2, player_hknight_magicb3 ] { };
void() player_hknight_magicb3 = [ $magicb3, player_hknight_magicb4 ] { };
void() player_hknight_magicb4 = [ $magicb4, player_hknight_magicb5 ] { };
void() player_hknight_magicb5 = [ $magicb5, player_hknight_magicb6 ] { }; // switching to focused shot
void() player_hknight_magicb6 = [ $magicb6, player_hknight_magicb7 ] { }; // needs impulsed in
void() player_hknight_magicb7 = [ $magicb7, player_hknight_magicb8 ] { player_hknight_shot(0.1);};
void() player_hknight_magicb8 = [ $magicb8, player_hknight_magicb9 ] { player_hknight_shot(0);};
void() player_hknight_magicb9 = [ $magicb9, player_hknight_magicb10 ] { player_hknight_shot(0);};
void() player_hknight_magicb10 = [ $magicb10, player_hknight_magicb11 ] { player_hknight_shot(0);};
void() player_hknight_magicb11 = [ $magicb11, player_hknight_magicb12 ] { player_hknight_shot(0);};
void() player_hknight_magicb12 = [ $magicb12, player_hknight_magicb13 ] { player_hknight_shot(0);};
void() player_hknight_magicb13 = [ $magicb13, player_stand1 ] { };


// IDEA - many more attack frames to look at

void() player_hknight_attack = 
{
	if (rune_haste(0.5))
	self.attack_finished=time+1; // (eh, or so)
	if(self.weapon == IT_AXE) {
		// A sword attack
//		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		if (random() > 0.66) player_hknight_slice1();
		else player_hknight_smash1();
	} else {
		// A magic attack
//		if (random() > 0.5)
		if (self.weapon == IT_SHOTGUN)
			player_hknight_magica1();
		else
			player_hknight_magicb1();
	}
};

// fn(player_hknight_impulse) - hell knight has a 3rd weapon builtin

void() player_hknight_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		sprint(self, "Hell Knight using ( Sword )\n");
	}
	if (self.weapon == IT_SHOTGUN)
	{
		sprint(self, "Hell Knight using ( Spikes )\n");
		self.items = self.items | IT_CELLS;
	}
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		sprint(self, "Hell Knight using ( Focused Spikes )\n");
		self.items = self.items | IT_CELLS;
	}
	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		sprint(self, "Hell Knight using ( Explosive Spikes )\n");
		self.items = self.items | IT_CELLS;
	}
};

string(entity targ, entity attacker) player_hknight_killmsg =
{
	if (targ == attacker) // doesnt happen - suicide by missile
		return " goes back home to hell";

	if (!ENHANCED) return " was slain by a Death Knight\n";

	if(attacker.weapon & IT_AXE)
		return " was slashed by ";
	else
	if (random () < 0.7)
		return " felt the red hot magic of ";		
	else
		return " was fried by ";
};

string(entity targ, entity attacker) player_hknight_killmsg2 =
{
	if (!ENHANCED) return "noname";
	return ".\n";
};

/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_hknight_become =
{
	self._stand=player_hknight_stand;
	self._run=player_hknight_run;
	self._pain=player_hknight_pain;
	self._die=hknight_die;
	self._jump=SUB_Null; // Default player jump
	self._jump2=SUB_Null;
	self._attack=player_hknight_attack;
	self._impulse=player_hknight_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_hknight_killmsg;
	self._killmsg2=player_hknight_killmsg2;

	self.cam_z = 15 / 100;
	self.cam_y = 12;

	stuffcmd(self, "exec cfg/morph/m-hellknight.cfg\n");

	setmodel(self,"progs/hknight.mdl");

	self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_ROCKET_LAUNCHER;
	self.builtin = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_ROCKET_LAUNCHER;
	self.weapon = IT_SUPER_SHOTGUN;

	self.msight = "hknight/sight1.wav";
	self.noise2 = "hknight/pain1.wav";
	self.noise3 = "";
	self.view_ofs = ' 0 0 34'; // raised 12
	self.cam_z = 0.1;
//	if(!deathmatch)
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
//	 	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = self.health * MHKNIGHT_HEALMOD / self.health_modifier;
	self.health_modifier = MHKNIGHT_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);


	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become a hell knight.\n");
		player_hknight_impulse();
		if (self.armortype == 0) //knight has some base armor
			{
			player_scourge_armor(self, 50, GIVEARMOR);
			}
		else
			self.armortype = ARM_SCRG;
		}
};
