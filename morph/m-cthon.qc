/* ::-::
 *
 * Cataboligne
 *
 * file: m-cthon.qc
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

$cd id1/models/boss1
$origin 0 0 -15
$base base
$skin skin
$scale 5

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8
$frame shockc9 shockc10

void() lavablob_eject;
void(vector p) lavacthon_fire;
void() cthon_outoflava;

/*
		+---------------------------------------+
		|  Frame operation code                 | SEC-HEAD
		+---------------------------------------+
*/

// fn(level_cthon) - brings model up to level found in house of cthon - for deeper lavas

void() level_cthon =
{
	local vector v1;

	if (!LEVEL_CTHON) return;

	v1 = ' 0 0 0';
	v1_z = hoc_level;

	if (pointcontents(self.origin + v1) == CONTENT_LAVA)
		{
		self.mins_z = self.mins_z - 1;
		setsize(self, self.mins, self.maxs);
		}
//		setorigin(self, self.origin + ' 0 0 1');
};

void() player_lavacthon_stand = [ $walk1, player_stand1 ]
{
	if (self.walkframe > 4 || self.walkframe < 0) self.walkframe = 0;
	if (self.walkframe == 4 && self.lip == 1) self.lip = -1;
	if (self.walkframe == 0) self.lip = 1;

	if (self.walkframe == 2)
		{
		morph_sound (0.08, "chaos/lavabidle.wav", 2);
//		if (random() < 0.1) chaos_fire_fly();
		}
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + self.lip;

	level_cthon();
	cthon_outoflava();
};

void() player_lavacthon_run = [ $walk1, player_run ] 
{
	cthon_outoflava();

	if (self.walkframe > 30 || self.walkframe < 0) self.walkframe = 0;
	if (self.walkframe == 2 || self.walkframe == 20)
		{
		morph_sound (0.2, "chaos/lavabidle.wav", 2);
//		if (random() < 0.20) chaos_fire_fly();
		}
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	level_cthon();
	cthon_outoflava();
};

// appear from lava

void() lavacthon_rise1  = [ $rise1, lavacthon_rise2 ]
{
	sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);

   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
   WriteCoord (MSG_BROADCAST, self.origin_x);
   WriteCoord (MSG_BROADCAST, self.origin_y);
   WriteCoord (MSG_BROADCAST, self.origin_z);
};
void() lavacthon_rise2  = [ $rise2, lavacthon_rise3 ] {
sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
};
void() lavacthon_rise3  = [ $rise3, lavacthon_rise4 ] {};
void() lavacthon_rise4  = [ $rise4, lavacthon_rise5 ] {};
void() lavacthon_rise5  = [ $rise5, lavacthon_rise6 ] {};
void() lavacthon_rise6  = [ $rise6, lavacthon_rise7 ] {};
void() lavacthon_rise7  = [ $rise7, lavacthon_rise8 ] {};
void() lavacthon_rise8  = [ $rise8, lavacthon_rise9 ] {};
void() lavacthon_rise9  = [ $rise9, lavacthon_rise10 ] {};
void() lavacthon_rise10 = [ $rise10, lavacthon_rise11 ] {};
void() lavacthon_rise11 = [ $rise11, lavacthon_rise12 ] {};
void() lavacthon_rise12 = [ $rise12, lavacthon_rise13 ] {};
void() lavacthon_rise13 = [ $rise13, lavacthon_rise14 ] {};
void() lavacthon_rise14 = [ $rise14, lavacthon_rise15 ] {};
void() lavacthon_rise15 = [ $rise15, lavacthon_rise16 ] {};
void() lavacthon_rise16 = [ $rise16, lavacthon_rise17 ] {};
void() lavacthon_rise17 = [ $rise17, player_stand1 ] {};

// return to blob form
void() reblob =
{
	player_lavablob_become(NO_TFOG);
};

void() lavacthon_reblob1  = [ $rise11, lavacthon_reblob2 ] {};
void() lavacthon_reblob2  = [ $rise10, lavacthon_reblob3 ] {};
void() lavacthon_reblob3  = [ $rise9,   lavacthon_reblob4 ] {};
void() lavacthon_reblob4  = [ $rise8,   lavacthon_reblob5 ] {};
void() lavacthon_reblob5  = [ $rise7,   lavacthon_reblob6 ] {};
void() lavacthon_reblob6  = [ $rise6,   lavacthon_reblob7 ] {};
void() lavacthon_reblob7  = [ $rise5,   lavacthon_reblob8 ] {};
void() lavacthon_reblob8  = [ $rise4,   lavacthon_reblob9 ]
{
	sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);
};
void() lavacthon_reblob9  = [ $rise3,   lavacthon_reblob10 ] {};
void() lavacthon_reblob10 = [ $rise2, lavacthon_reblob11 ] {};
void() lavacthon_reblob11 = [ $rise1,  reblob ] {};


// fn(blobme) - change back to blob
 
void(entity e) lavacthon_blobme =
{
	local entity sv;

	sv = self;
	if (e) self = e;
	if (self.watertype != CONTENT_LAVA) // not in lava - just transform back, no sink frames
	{
		lavablob_eject(); // eject some material since we are not in lava
		if (random() < 0.2) lavablob_eject(); // even more - cthon is a big beast
		player_lavablob_become(NO_TFOG);
		self = sv;
		return;
	}
	else
		lavacthon_reblob1();
	self = sv;
}

// fire frames

void() lavacthon_missile12;

void() lavacthon_missile1  = [ $attack1, lavacthon_missile2 ]
{
	if (self.impulse == ALT_FIRE_IMP)
	{
		lavacthon_blobme(world);
		return;
	}

	if (rune_haste(0.45))
	self.attack_finished = time + 0.9;
};
void() lavacthon_missile2  = [ $attack2, lavacthon_missile3 ] {};
void() lavacthon_missile3  = [ $attack3, lavacthon_missile4 ] {};
void() lavacthon_missile4  = [ $attack4, lavacthon_missile5 ] {};
void() lavacthon_missile5  = [ $attack5, lavacthon_missile6 ] {};
void() lavacthon_missile6  = [ $attack6, lavacthon_missile7 ] {};
void() lavacthon_missile7  = [ $attack7, lavacthon_missile8 ] {};
void() lavacthon_missile8  = [ $attack8, lavacthon_missile9 ] {};
void() lavacthon_missile9  = [ $attack9, lavacthon_missile10 ] {lavacthon_fire(' 66 66 160');};
void() lavacthon_missile10 = [ $attack10, lavacthon_missile11 ] {};
void() lavacthon_missile11 = [ $attack11, player_stand1 ]
{
self._attack = lavacthon_missile12;
};

void() lavacthon_missile12 = [ $attack12, lavacthon_missile13 ]
{
	if (self.impulse == ALT_FIRE_IMP)
	{
		lavacthon_blobme(world);
		return;
	}

	if (rune_haste(0.45))
	self.attack_finished = time + 0.9;
};
void() lavacthon_missile13 = [ $attack13, lavacthon_missile14 ] {};
void() lavacthon_missile14 = [ $attack14, lavacthon_missile15 ] {};
void() lavacthon_missile15 = [ $attack15, lavacthon_missile16 ] {};
void() lavacthon_missile16 = [ $attack16, lavacthon_missile17 ] {};
void() lavacthon_missile17 = [ $attack17, lavacthon_missile18 ] {};
void() lavacthon_missile18 = [ $attack18, lavacthon_missile19 ] {};
void() lavacthon_missile19 = [ $attack19, lavacthon_missile20 ] {};
void() lavacthon_missile20 = [ $attack20, lavacthon_missile21 ] {lavacthon_fire('66 -66 160');};
void() lavacthon_missile21 = [ $attack21, lavacthon_missile22 ] {};
void() lavacthon_missile22 = [ $attack22, lavacthon_missile23 ] {};
void() lavacthon_missile23 = [ $attack23, player_stand1 ]
{
self._attack = lavacthon_missile1;
};

// death frames, as unlikely as it is

void() lavacthon_death1 = [$death1, lavacthon_death2]
{
sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
};
void() lavacthon_death2 = [$death2, lavacthon_death3] {};
void() lavacthon_death3 = [$death3, lavacthon_death4] {};
void() lavacthon_death4 = [$death4, lavacthon_death5] {};
void() lavacthon_death5 = [$death5, lavacthon_death6] {};
void() lavacthon_death6 = [$death6, lavacthon_death7]
{
if (self.owner.watertype != CONTENT_LAVA)
	{
	self.skin = 1;
	sound (self,CHAN_WEAPON,"chaos/freeze.wav",1,ATTN_NORM);
	self.nextthink = MAXFL;
	}
};
void() lavacthon_death7 = [$death7, lavacthon_death8] {};
void() lavacthon_death8 = [$death8, lavacthon_death9] {};
void() lavacthon_death9 = [$death9, lavacthon_death10]
{
	sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
};

void() lavacthon_death10 = [$death9, SUB_Nop] { };

/*
		+---------------------------------------+
		|  attack code                          | SEC-HEAD
		+---------------------------------------+
*/


// fn(lavacthon_fire) - fire a cthon missile for player

void(vector p) lavacthon_fire =
{
	local vector  org, vec;

	org = self.origin + ' 0 0 80'; // + v_forward * 10;
	traceline( org,  org + v_forward * 2048, FALSE, self);
	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
// FIX - targeting sometimes wrong
	fire_missile(FIREBALL_WEP_VEL, MOVETYPE_FLYMISSILE, FL_CTHONF, RM_SKY | FLT_IMM | MLT_LAVA | FLT_LAVA, org, trace_endpos - org, "fireballmissle", "progs/lavaball.mdl", "boss1/throw.wav", T_MissileTouch, 5 + (random() * 4), meltthink, fire_fly_adj);

	newmis.avelocity = ' 200 100 300';
	newmis.dest_y = 16;
};

/*
		+---------------------------------------+
		|  Input code                           | SEC-HEAD
		+---------------------------------------+
*/

/*
		+---------------------------------------+
		|  physics code                         | SEC-HEAD
		+---------------------------------------+
*/

// fn(cthon_outoflava) - check to see if cthon got thrown or pulled out of lava

void() cthon_outoflava =
{
	if (self.movetype == MOVETYPE_NOCLIP) return; // player cheating - shhh...just ignore this

	if (self.watertype != CONTENT_LAVA)
		{
		if (self.count == 0)
			{
			sprint(self,"\n\n\bHURRY!\b  Find more Lava fast!\n");
			self.count = 101; // only have 10 secs to get back in lava!
			}
		else if (self.count > 1)
		{
			self.count = self.count - 1;
			if (random() < 0.1) sprint(self,"\n\n\bHURRY!\b  Find more Lava fast!\n");
		}
		else if (self.count == 1)
			{
			if (random() < 0.2) sprint(self,"Cthon cannot exist away from Lava\n");
			T_Damage (self, world, world, self.health + 2);
			}
		}
	else
		self.count = 0;
};


string() player_cthon_killmsg =
{
	if (!ENHANCED) return " died\n";

	return rnd_string(' 60.0 50.0 40.0'," met Cthon in battle\n","",""," was blasted by living Lava\n"," was sacraficed to the Volcano God!\n");
};
string() player_cthon_killmsg2 =
{
//	if (!ENHANCED) 
		return "noname";

//	return "\n";
};


/*
		+---------------------------------------+
		|  create code                          | SEC-HEAD
		+---------------------------------------+
*/

void() player_lavacthon_become = 
{
	self._stand=player_lavacthon_stand;
	self._run=player_lavacthon_run;
	self._pain=SUB_Nop; // IDEA - pain sound & frames
	self._die=lavacthon_death1;
	self._jump=SUB_Nop;
	self._jump2=SUB_Nop;
	self._attack=lavacthon_missile1;
	self._impulse=SUB_Nop;

	self._killmsg=player_cthon_killmsg;
	self._killmsg2=player_cthon_killmsg2;

	self.cam_z = 108 / 100;
	self.cam_y = 36;
	stuffcmd(self, "chase_up 108\n");
	stuffcmd(self, "chase_back 36\n");
	stuffcmd(self, "exec m-cthon.cfg\n");

	setmodel(self,"progs/cthon.mdl");
	self.modelindex_morph = self.modelindex;

	self.skin = 0;

	self.msight = "boss1/sight1.wav";
//	self.noise2 = "enforcer/pain1.wav";
	self.noise3 = "";
	self.view_ofs = ' 0 0 120';
	self.cam_z = 1.4;  //cam - FIX may need tweaked
	setsize (self, '-64 -64 -24', ' 64 64 128');

	sprint(self,"You are emergent...CTHON!!\n");

	self.builtin = self.items = self.items | IT_SHOTGUN;
	self.weapon = IT_SHOTGUN;

	lavacthon_rise1();
};

