/* ::-::
 *
 * Cataboligne
 *
 * file: m-scourge.qc
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

$cd /raid/quake/id1/models/ogre_c
$origin 0 0 24
$base base		
$skin base

$frame	stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7
$frame swing8 swing9 swing10 swing11 swing12 swing13 swing14

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12 smash13 smash14

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6

$frame pain1 pain2 pain3 pain4 pain5

$frame painb1 painb2 painb3

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13 paind14 paind15 paind16

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11 death12
$frame death13 death14

$frame bdeath1 bdeath2 bdeath3 bdeath4 bdeath5 bdeath6
$frame bdeath7 bdeath8 bdeath9 bdeath10

$frame pull1 pull2 pull3 pull4 pull5 pull6 pull7 pull8 pull9 pull10 pull11

void() m_precache_ogre =
{
//// Ogre morph
	precache_model ("progs/ogre.mdl");
	precache_model ("progs/h_ogre.mdl");
//	precache_model ("progs/grenade.mdl");

	precache_sound ("ogre/ogdrag.wav");
	precache_sound ("ogre/ogdth.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogsawatk.wav");
	precache_sound ("ogre/ogwake.wav");
};

void() player_ogre_stand = [ $stand1, player_stand1 ]
{
	if(self.walkframe >= 9) self.walkframe = 0;
	if (self.walkframe == 3) 
		{
		if (random() < 0.8)
			morph_sound(0.2, "ogre/ogidle.wav", 4);
		else
			morph_sound(0.2, "ogre/ogidle2.wav", 3);
		}
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() player_ogre_run = [ $run1, player_run ]
{
	vector sp;
	float walk, frm;

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 16) self.walkframe = 0;
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
// 5 frames of pain for player_ogre, going to player_stand1
////////////////////////////////////////////

void() player_ogre_pain1 = [ $pain1, player_ogre_pain2 ]
{
	self.pain_finished = time + 2.5;
	morph_sound(0.8,self.noise2, 1);
};
void() player_ogre_pain2 = [ $pain2, player_ogre_pain3 ] { };
void() player_ogre_pain3 = [ $pain3, player_ogre_pain4 ] { };
void() player_ogre_pain4 = [ $pain4, player_ogre_pain5 ] { };
void() player_ogre_pain5 = [ $pain5, player_stand1 ] { };

void(float side) player_chainsaw =
{
	local float sd1;
	string miss, whit, fhit;
	miss = whit = fhit = "";
	if (side)
	{
		whit = "player/axhit2.wav";
		fhit = "shambler/smack.wav";
	}

	sd1 = side;
	if (side == 1) sd1 = crandom() * 100;
	W_FireAxe(); // FIX:
//	melee_damage(self.origin, self.origin+ v_forward*100, (random() + random() + random()) * 4, 10, sd1, TE_GUNSHOT, miss, whit, fhit);

};

void() player_ogre_swing1	=[	$swing1,		player_ogre_swing2	] {
sound (self, CHAN_AUTO, "ogre/ogsawatk.wav", 1, ATTN_NORM);
};
void() player_ogre_swing2	=[	$swing2,		player_ogre_swing3	] {};
void() player_ogre_swing3	=[	$swing3,		player_ogre_swing4	] {};
void() player_ogre_swing4	=[	$swing4,		player_ogre_swing5	] {};
void() player_ogre_swing5	=[	$swing5,		player_ogre_swing6	] { player_chainsaw(0);self.angles_y = self.angles_y + random()*25;};
void() player_ogre_swing6	=[	$swing6,		player_ogre_swing7	] {player_chainsaw(200);self.angles_y = self.angles_y + random()* 25;};
void() player_ogre_swing7	=[	$swing7,		player_ogre_swing8	] {player_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() player_ogre_swing8	=[	$swing8,		player_ogre_swing9	] {player_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() player_ogre_swing9	=[	$swing9,		player_ogre_swing10 ] {player_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() player_ogre_swing10	=[	$swing10,		player_ogre_swing11 ] {player_chainsaw(-200);self.angles_y = self.angles_y + random()* 25;};
void() player_ogre_swing11	=[	$swing11,		player_ogre_swing12 ] {player_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() player_ogre_swing12	=[	$swing12,		player_ogre_swing13 ] {};
void() player_ogre_swing13	=[	$swing13,		player_ogre_swing14 ] {};
void() player_ogre_swing14	=[	$swing14,		player_stand1	] {};

void() player_ogre_smash1	=[	$smash1,	       player_ogre_smash2 ] {
sound (self, CHAN_AUTO, "ogre/ogsawatk.wav", 1, ATTN_NORM);
};
void() player_ogre_smash2	=[	$smash2,		player_ogre_smash3	] {};
void() player_ogre_smash3	=[	$smash3,		player_ogre_smash4	] {};
void() player_ogre_smash4	=[	$smash4,		player_ogre_smash5	] {};
void() player_ogre_smash5	=[	$smash5,		player_ogre_smash6	] {};
void() player_ogre_smash6	=[	$smash6,		player_ogre_smash7	] { player_chainsaw(0);};
void() player_ogre_smash7	=[	$smash7,		player_ogre_smash8	] { player_chainsaw(0);};
void() player_ogre_smash8	=[	$smash8,		player_ogre_smash9	] { player_chainsaw(0);};
void() player_ogre_smash9	=[	$smash9,		player_ogre_smash10 ] { player_chainsaw(0);};
void() player_ogre_smash10	=[	$smash10,		player_ogre_smash11 ] {player_chainsaw(1);};
void() player_ogre_smash11	=[	$smash11,		player_ogre_smash12 ] { player_chainsaw(0);};

void() player_ogre_smash12	=[	$smash12,		player_ogre_smash13 ] {};
void() player_ogre_smash13	=[	$smash13,		player_ogre_smash14 ] {};
void() player_ogre_smash14	=[	$smash14,		player_stand1 ] {};

////////////////////////////////////////////
// 6 frames of shoot for player_ogre, going to player_stand1
////////////////////////////////////////////

void() player_ogre_shoot1 = [ $shoot1, player_ogre_shoot2 ] { };
void() player_ogre_shoot2 = [ $shoot2, player_ogre_shoot3 ] { };
void() player_ogre_shoot3 = [ $shoot3, player_ogre_shoot4 ]
{
	local float fr;
	self.effects = self.effects | EF_MUZZLEFLASH;
	fr = TRUE;
	if (!self.eweapon)
	{
//		if (self.eweapon.weapon == MC_THUNDER) W_FireLightning();
//		else if (self.eweapon.weapon == MC_LASERCAN) HIP_FireLaser(stat);
//		else 
		if (self.weapon & (IT_NAILGUN | IT_SUPER_NAILGUN))
			{
				W_FireSpikes(-12);
				self.attack_finished = time + 0.2;
				if (self.button0) self.think = player_ogre_shoot2;
			}
		else fr = FALSE;
		if (self.cam_x & CHSCAM_ON) self.punchangle_x = 0;
		if (fr) return;
	}
	else
	{
//		if (self.eweapon.weapon == MC_THUNDER) W_FireLightning();
//		else if (self.eweapon.weapon == MC_LASERCAN) HIP_FireLaser(stat);
//		else
		if (self.eweapon._attack != SUB_Null) self.eweapon._attack();
		else fr = FALSE;
		if (fr) return;	
	}
	W_FireGrenade();
	if (self.weapon == IT_ROCKET_LAUNCHER) // cluster bomb
	{
		newmis.think = newmis.th_die = newmis.th_stand = chaos_bomb;
		newmis.aflag = MOVETYPE_BOUNCE;
		newmis.weapon = IMP_MOGRE;
		if (rune_haste(1.3))
		self.attack_finished = time + 2.6;
	}

};
void() player_ogre_shoot4 = [ $shoot4, player_ogre_shoot5 ] { };
void() player_ogre_shoot5 = [ $shoot5, player_ogre_shoot6 ] { };
void() player_ogre_shoot6 = [ $shoot6, player_stand1 ] { };

void() player_ogre_attack =
{
	if(self.weapon == IT_AXE)
	{
//		if(random()>0.66) {
//			self.attack_finished = time + 1.2;
//			player_ogre_smash1();
//		} else {
		if (rune_haste(0.5))
		self.attack_finished = time + 1.0;
		if (random() < 0.3) player_ogre_smash1();
		else player_ogre_swing1();
//		}
	}
	else
	{
		if (rune_haste(0.25))
		self.attack_finished = time + 0.5 + (crandom() * 0.2);
		player_ogre_shoot1();
	}
};

void() player_ogre_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	split_morph_impulse();

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
		sprint(self, "Ogre using ( Chainsaw )\n");
	}
	if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		sprint(self, "Ogre using ( Grenades )\n");
		self.items = self.items | IT_ROCKETS;
	}

	if (self.weapon == IT_ROCKET_LAUNCHER)
		{
		sprint(self, "Ogre using ( Cluster Grenade )\n");
		self.items = self.items | IT_ROCKETS;
		}
};



string(entity targ, entity attacker) player_ogre_killmsg = {
	if(attacker.weapon == IT_AXE) return " was sawed to death by "; // FIX: doesnt give correct msgs
	else return " eats ";
};
	
string(entity targ, entity attacker) player_ogre_killmsg2 = {
	if(attacker.weapon == IT_AXE) return "\n";
	else return "'s pineapple\n";
};

void(float silent) player_ogre_become =
{
	self._stand = player_ogre_stand;
	self._run = player_ogre_run;	
	self._pain = player_ogre_pain1;
	self._die = ogre_die;
	self._jump  =  SUB_Null;
	self._jump2  =  SUB_Null;
	self._attack = player_ogre_attack;
	self._impulse = player_ogre_impulse;
	self._hk_lesser  =  player_ogre_smash1;
//	self._can_get_p = SUB_False;
	self._killmsg = player_ogre_killmsg;
	self._killmsg2 = player_ogre_killmsg2;

	self.cam_z = 15 / 100;
	self.cam_y = 12;
	stuffcmd(self, "chase_up 15\n");
	stuffcmd(self, "chase_back 12\n");
	stuffcmd(self, "exec m-ogre.cfg\n");

	setmodel(self,"progs/ogre.mdl");

	self.builtin = self.items = self.items | IT_AXE | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER;
	self.weapon = IT_GRENADE_LAUNCHER;
	
	self.msight = "ogre/ogwake.wav";
	self.noise2 = "ogre/ogpain1.wav";
	self.noise3 = ""; //gasp
	self.view_ofs = ' 0 0 34'; // raised by 2
	self.cam_z = 0.1;

//	if(!deathmatch)
//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
	 	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = self.health * MOGRE_HEALMOD / self.health_modifier;
	self.health_modifier = MOGRE_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);


	if (!silent) // silent for starting new level as this beasty
		{
		bprint(self.netname);
		bprint(" has become an ogre.\n");
		}
};
