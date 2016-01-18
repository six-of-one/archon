/* ::-::
 *
 * Cataboligne
 *
 * file: m-shambl.qc
 *
 * date: 9/22/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/


$cd /raid/quake/id1/models/shams
$origin 0 0 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame	run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11

void() m_precache_shambler =
{
//// Shambler morph
	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
//	precache_model ("progs/bolt.mdl");
	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");
};

void() player_shambler_stand = [ $stand1, player_stand1 ] {
	if(self.walkframe >=  17)
		self.walkframe = 0;
	if (self.walkframe == 8) morph_sound(0.2, "shambler/sidle.wav", 3);
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};
	 
void() player_shambler_run = [ $run1, player_run ]
{
	vector sp;
	float walk, frm;

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 12) self.walkframe = 0;
		}
	else
		{
		frm = $run1;
		if (self.walkframe >= 6) self.walkframe = 0;
		}

	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

////////////////////////////////////////////
// 5 frames of pain for player_shambler, going to player_stand1
////////////////////////////////////////////

void() player_shambler_pain1 = [ $pain1, player_shambler_pain2 ] { };
void() player_shambler_pain2 = [ $pain2, player_shambler_pain3 ] { };
void() player_shambler_pain3 = [ $pain3, player_shambler_pain4 ] { };
void() player_shambler_pain4 = [ $pain4, player_shambler_pain5 ] { };
void() player_shambler_pain5 = [ $pain5, player_stand1 ] { };

void(entity attacker, float damage)	player_shambler_pain =
{
	if (random()*400 > damage)
		return;		// didn't flinch

	morph_sound (0.8, self.noise2, 1);

	self.pain_finished = time + 2.75;
		
	player_shambler_pain1 ();
};

void() player_CastLightning =
{
	local	vector	org, dir;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	if(self.waterlevel > 1 && (Q_100 || self.watertype != CONTENT_LAVA)) {
		T_RadiusDamage(self, self, self.health, world); /* We all die! */
		return;
	}

	org = self.origin + '0 0 40';

//	makevectors (self.v_angle);
	dir = normalize (v_forward);

	traceline (org, self.origin + dir*4096, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage_x(FALSE, org, trace_endpos, self, 10);
};

void() player_shambler_magic1     =[      $magic1,       player_shambler_magic2    ] {
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
	if (rune_haste(0.55))
	self.attack_finished=time+1.1;
};
void() player_shambler_magic2     =[      $magic2,       player_shambler_magic3    ] {};
void() player_shambler_magic3     =[      $magic3,       player_shambler_magic4    ] {
	local entity o;
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.owner = spawn();
	o = self.owner;
	setmodel (o, "progs/s_light.mdl");
	setorigin (o, self.origin);
	o.angles = self.angles;
	o.nextthink = time + 0.7;
	o.think = SUB_Remove;
};
void() player_shambler_magic4     =[      $magic4,       player_shambler_magic5    ]
{ self.effects = self.effects | EF_MUZZLEFLASH; self.owner.frame = 1; };
void() player_shambler_magic5     =[      $magic5,       player_shambler_magic6    ]
{ self.effects = self.effects | EF_MUZZLEFLASH; self.owner.frame = 2; };
void() player_shambler_magic6     =[      $magic6,       player_shambler_magic9    ] {
	remove (self.owner);
	player_CastLightning();
	sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void() player_shambler_magic9     =[      $magic9,       player_shambler_magic10   ]
{player_CastLightning();};
void() player_shambler_magic10    =[      $magic10,      player_shambler_magic11   ]
{player_CastLightning();};
void() player_shambler_magic11    =[      $magic11,      player_shambler_magic12   ]
{player_CastLightning();};
void() player_shambler_magic12    =[      $magic12,      player_stand1	   ] {};

void() player_shambler_swingr1;

void(float side) player_ShamClaw =
{
	W_FireAxe(); // FIX:
//	melee_damage(self.origin + '0 0 16', self.origin + '0 0 16' + v_forward*128, (random() + random() + random()) * 20, 20, side, TE_GUNSHOT, "hknight/slash1.wav", "grapple/grapf_1.wav" , "shambler/smack.wav"); // whit - "player/axhit2.wav"
};

void() player_shambler_smash1     =[      $smash1,       player_shambler_smash2    ] {
sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
};
void() player_shambler_smash2     =[      $smash2,       player_shambler_smash3    ] {};
void() player_shambler_smash3     =[      $smash3,       player_shambler_smash4    ] {};
void() player_shambler_smash4     =[      $smash4,       player_shambler_smash5    ] {};
void() player_shambler_smash5     =[      $smash5,       player_shambler_smash6    ] {};
void() player_shambler_smash6     =[      $smash6,       player_shambler_smash7    ] {};
void() player_shambler_smash7     =[      $smash7,       player_shambler_smash8    ] {};
void() player_shambler_smash8     =[      $smash8,       player_shambler_smash9    ] {};
void() player_shambler_smash9     =[      $smash9,       player_shambler_smash10   ] {player_ShamClaw(150); };
void() player_shambler_smash10    =[      $smash10,      player_shambler_smash11   ] {player_ShamClaw(150);};
void() player_shambler_smash11    =[      $smash11,      player_shambler_smash12   ] {player_ShamClaw(150);};
void() player_shambler_smash12    =[      $smash12,      player_run	   ] {};

void() player_shambler_swingl1	=[      $swingl1,      player_shambler_swingl2   ] {
sound (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
};
void() player_shambler_swingl2 =[      $swingl2,      player_shambler_swingl3   ] {};
void() player_shambler_swingl3 =[      $swingl3,      player_shambler_swingl4   ] {};
void() player_shambler_swingl4 =[      $swingl4,      player_shambler_swingl5   ] {};
void() player_shambler_swingl5 =[      $swingl5,      player_shambler_swingl6   ] {};
void() player_shambler_swingl6 =[      $swingl6,      player_shambler_swingl7   ] {};
void() player_shambler_swingl7 =[      $swingl7,      player_shambler_swingl8   ] { player_ShamClaw(250);};
void() player_shambler_swingl8 =[      $swingl8,      player_shambler_swingl9   ] {};
void() player_shambler_swingl9 =[      $swingl9,      player_run  ] {};

void() player_shambler_swingr1	=[      $swingr1,      player_shambler_swingr2   ] {
sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
};
void() player_shambler_swingr2	=[      $swingr2,      player_shambler_swingr3   ] {};
void() player_shambler_swingr3 =[      $swingr3,      player_shambler_swingr4   ] {};
void() player_shambler_swingr4 =[      $swingr4,      player_shambler_swingr5   ] {};
void() player_shambler_swingr5 =[      $swingr5,      player_shambler_swingr6   ] {};
void() player_shambler_swingr6 =[      $swingr6,      player_shambler_swingr7   ] {};
void() player_shambler_swingr7 =[      $swingr7,      player_shambler_swingr8   ] { player_ShamClaw(-250);};
void() player_shambler_swingr8 =[      $swingr8,      player_shambler_swingr9   ] {};
void() player_shambler_swingr9 =[      $swingr9,      player_run  ] { };

void() player_shambler_attack =
{
	if(self.weapon == IT_AXE) {
		if(random()>0.9) {
			if (rune_haste(0.55))
			self.attack_finished = time + 1.1;
			player_shambler_smash1();
		} else if(random()>0.5) {
			if (rune_haste(0.4))
			self.attack_finished = time + 0.8;
			player_shambler_swingl1();
		} else {
			if (rune_haste(0.4))
			self.attack_finished = time + 0.8;
			player_shambler_swingr1();
		}
	} else {
		player_shambler_magic1();
	}
};


// fn(player_hknight_impulse) - hell knight has a 3rd weapon builtin

void() player_shambler_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	if (self.pk_currentitem != PK_IT_AXE) return; // selected a pk goody - dont re-message

	if (self.weapon == IT_AXE)
	{
		sprint(self, "Shambler using ( Claws )\n");
	}
	if (self.weapon == IT_LIGHTNING)
	{
		sprint(self, "Shambler using ( Lightning )\n");
		self.items = self.items | IT_CELLS;
	}

};


string(entity targ, entity attacker) player_shambler_killmsg =
{
	if(attacker.weapon == IT_AXE) return " was smashed by ";
	else return " was zapped by ";
};

string() player_shambler_killmsg2 = { return "\n"; };


/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void(float silent) player_shambler_become = {
	self._stand=player_shambler_stand;
	self._run=player_shambler_run;
	self._pain=player_shambler_pain1;
	self._die=sham_die;
	self._jump=SUB_Null;
	self._jump2=SUB_Null;
	self._attack=player_shambler_attack;
	self._impulse=player_shambler_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_shambler_killmsg;
	self._killmsg2=player_shambler_killmsg2;
	setmodel(self,"progs/shambler.mdl");

		self.builtin = self.items = self.items | IT_AXE | IT_LIGHTNING;
	self.weapon = IT_LIGHTNING;

	self.msight = "shambler/ssight.wav";
	self.noise2 = "shambler/shurt2.wav";
	self.noise3 = "";
//	if(!deathmatch)
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
//		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.view_ofs = '0 0 54'; // raised by 22
	self.cam_z = 0.34;
	self.health = self.health * MSHAMBLR_HEALMOD / self.health_modifier;
	self.health_modifier = MSHAMBLR_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);

	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become a shambler.\n");
		}
};
