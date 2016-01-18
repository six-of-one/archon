/* ::-::
 *
 * Cataboligne
 *
 * file: m-demon.qc
 *
 * date: 9/16/11
 *
 * qc - support chaos mod morph ability
 *
 */
 
 
/*
		+---------------------------------------+
		|  Frame code                           | SEC-HEAD
		+---------------------------------------+
*/

$cd /raid/quake/id1/models/demon3
$scale	0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

void() m_precache_demon =
{
//// Demon morph
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
};

void(float side) player_demon_melee = {
        local   vector  source;
        local   vector  org;
        local   float   ldmg;

        sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);

        source = self.origin + '0 0 4';
        makevectors (self.angles);
        traceline (source, source + v_forward*64, FALSE, self);
        if (!trace_ent.takedamage)
                traceline (source, source + v_forward*64 + v_right*30, FALSE, self);
        if (!trace_ent.takedamage)
                traceline (source, source + v_forward*64 - v_right*30, FALSE, self);

        if (trace_fraction == 1.0)
                return;

        org = trace_endpos - v_forward*4;
        if (trace_ent.takedamage)
        {
            sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
            ldmg = 40 + 10*random();
            T_Damage (trace_ent, self, self, ldmg);
				if (trace_ent.solid == SOLID_SLIDEBOX)  // BLOODCHECK - in case some other bit of gib / dead body can make blood
                SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
        }
};

void()  player_demon_attack1 = [$attacka1, player_demon_attack2 ] {if (rune_haste(0.5)) self.attack_finished=time+1; if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 8';};
void()  player_demon_attack2 = [$attacka2, player_demon_attack3 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 16';};
void()  player_demon_attack3 = [$attacka3, player_demon_attack4 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 25';};
void()  player_demon_attack4 = [$attacka4, player_demon_attack5 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 23';};
void()  player_demon_attack5 = [$attacka5, player_demon_attack6 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 21'; player_demon_melee(200);};
void()  player_demon_attack6 = [$attacka6, player_demon_attack7 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 23';};
void()  player_demon_attack7 = [$attacka7, player_demon_attack8 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 24';};
void()  player_demon_attack8 = [$attacka8, player_demon_attack9 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 25';};
void()  player_demon_attack9 = [$attacka9, player_demon_attack10 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 24';};
void()  player_demon_attack10 = [$attacka10, player_demon_attack11 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 23';};
void()  player_demon_attack11 = [$attacka11, player_demon_attack12 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 21'; player_demon_melee(-200);};
void()  player_demon_attack12 = [$attacka12, player_demon_attack13 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 16';};
void()  player_demon_attack13 = [$attacka13, player_demon_attack14 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 12';};
void()  player_demon_attack14 = [$attacka14, player_demon_attack15 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 8';};
void()  player_demon_attack15 = [$attacka15, player_stand1 ] {if (! self.cam_x & CHSCAM_ON) self.view_ofs = '0 0 12';};

void()  player_demon_spike1 = [$attacka1, player_demon_spike2 ] {};
void()  player_demon_spike2 = [$pain1, player_demon_spike3 ] {};
void()  player_demon_spike3 = [$pain2, player_demon_spike4 ]
{
	fire_missile(DEF_VEL, MOVETYPE_FLYMISSILE, 0, PF_LAVA | RM_SKY, self.origin + ' 0 0 16', ' 0 0 0', "spike", "progs/spike.mdl", "gatling/ric1.wav", spike_touch, 6, SUB_Remove, SUB_Nop);
	newmis.dmg = 40 + random() * 40; // owwie
	newmis.frame = 1;
	newmis.morphy = self.morphy;
};
void()  player_demon_spike4 = [$pain1, player_demon_spike5 ] {};
void()  player_demon_spike5 = [$attacka1,  player_stand1  ] {};

void() player_demon_jumptouch =
{
        local float ldmg;

        if(other.takedamage)
        {
                ldmg = 40 + 10*random();
                T_Damage(other, self, self, ldmg);
				if (other.solid == SOLID_SLIDEBOX)  // BLOODCHECK - in case some other bit of gib / dead body can make blood
				{
					SpawnMeatSpray (self.origin + v_forward*20,  100* v_forward);
					SpawnMeatSpray (self.origin + v_forward*20,  50* v_forward);
				}
        }

        self.touch = SUB_Null;
};

void() player_demon_jump1 = [ $leap1, player_demon_jump1 ] {
        if (self.walkframe >= 12)
                self.walkframe = 11;
        self.frame = $leap1 + self.walkframe;
        self.walkframe = self.walkframe + 1;
        if (self.flags & FL_ONGROUND) {
		self.touch = SUB_Null;
                player_stand1();
	}
};


// fn(demon_explode_plague) - demon chunks can be plague ridden

void() demon_explode_plague =
{
	if (random() < CK_PLAGUE_ZGIB) newmis.touch = PlagueTouch;
};

// fn(demon_explode_gibs) - think this so blast move doesnt erase the gib shower

//void() demon_explode_gibs =
//{
//	self = self.owner;
//	fire_burst (player_ZombieFireGrenade, self.origin + ' 0 0 20', 0, 0, null_string, null_string, 0, 6, 8, ' 120 0 0', ' 300 360 360', demon_explode_plague, FL_ANGADR, world);
//};

// fn(player_demon_explode) - enraged demon on overload...go BOOM!

void() player_demon_explode =
{
	local entity sv, e;
	local float f, k, v;

//	if (!self.flags & FL_DEMONBOOM) return;

	if (self.attack_finished < time)
	{
//		if (self.class_select != "dead_body") setmodel(self, null_string);							// dont allow for corpse after explosion
		self.volume = 0;
		self.flags = self.flags - (self.flags & FL_DEMONBOOM);
		if ((self.items & IT_INVULNERABILITY) && !self.rune_flag)
		{
			self.pk_explode_ammo = -506;
			self.weapon = IT_AXE;
			return;
		}
		self.pk_explode_ammo = -504;

		f = 1; // health multiplier
		if (self.items & IT_SUPERHEALTH) f = 2;
		if (self.items & IT_QUAD) f = 4;
		if (self.items & IT_SUIT) f = f * 0.5; // env protect power contains half of blast

		if (RUNES)
		if (ENHANCED)
		{
			if ( (self.rune_flag & RUNE_FLG_RS) || (self.rune_flag & TECH_DSH) ) f = f * 0.8;
			if (self.rune_flag & RUNE_FLG_DM) f = f * 1.333;
			if (self.rune_flag & TECH_AMP) f = f * 1.21;
		}

		sv = self;
		self = spawn(); // cant blow a client ent
		self.classname = "demonboom";
		self.owner = sv;
		sv.deathtype = self.deathtype = "rage";
		self.origin = sv.origin + ' 0 0 20';

//		Explode(0, random() * 100 + sv.health, world, TE_TAREXPLOSION, 0, BecomeExplosion);
		if (sv.health < 50)
			k = 50 + random() * 50 + (sv.health * f) + sv.armorvalue;
		else
		k = random() * 100 + (sv.health * f) + sv.armorvalue;

		if (sv.items & IT_INVULNERABILITY)
		{
			bprint("\n\n\n\nRune Powered - ");
			if (sv.items & IT_QUAD) bprint("Quad + ");
			bprint("Pentagram Fiend Super BOOM - you're all gonna DIE!\n");
			f = 0;
			if ((sv.rune_flag & RUNE_FULL) && (sv.rune_flag & TECH_MASK_ALL)) f = 1;
			k = k * (5 + f);

 			e = findradius(self.origin, DEMONBOOM_RADIUS);
			while (e)
			{

				f = k;
				v = vlen(self.origin - e.origin);
				if (v > DEMONBOOM_FALLOFF) f = k * (DEMONBOOM_FALLOFF / v);

				if (e != sv)
				if (e.classname != OBSERVER)
				if (!e.mask_x & MORPH_ARCHON) // note: archons immune
				if (e.takedamage && e.health > 0)
				{
					v = 0.1;
					if (k > 20000) v = 0.4;
					else if (k > 10000) v = 0.3;
					else if (k > 5000) v = 0.2;

					if (e.classname == "door") // cuase secrets always have 10K health set
						k = k - 50;
					else
					k = k -  e.health * v;

					T_Damage(e, self, self.owner, f);
				}
				e = e.chain;
			}
		}
		else
		{
 		// stand in for above fn
					T_RadiusDamage (self,self.owner,k,sv); // note: when restoring explode - now doesnt hit owner
		}

					WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
					WriteByte (MSG_BROADCAST,TE_TAREXPLOSION);
					WriteCoord (MSG_BROADCAST,self.origin_x);
					WriteCoord (MSG_BROADCAST,self.origin_y);
					WriteCoord (MSG_BROADCAST,self.origin_z);

					BecomeExplosion ();

		self = sv;
		dead_drop(self); // Cataboligne - 10.7.11 - drop runes+ - otherwise, protected from damage maybe
		self.model = null_string; // no body

		self.armorvalue = self.health = 0;
		damage_inflictor = self;
		Killed (self, self);
		damage_inflictor = world;

// note: wonky obit possible here
		fire_burst (player_ZombieFireGrenade, self.origin + ' 0 0 20', 0, ZOMBIE_FLSH_VEL, null_string, null_string, 0, 8, 12, ' 120 0 0', ' 300 360 360', demon_explode_plague, FL_ANGADR, world);
//		if (self.class_select == "dead_body") SUB_Remove(); // already dead, remove corpse
		self.nextthink = -1;
		return;
	}

	if ((self.attack_finished - self.AIRG_FireCount) < time ) // announce to self approximate countdown
	{
		SuperDamageSound();

		self.AIRG_FireCount = self.AIRG_FireCount - 1;
		if ( (self.rune_flag & RUNE_FLG_HS) || (self.rune_flag & TECH_TEIM) )
		{
//			self.AIRG_FireCount = self.AIRG_FireCount - 0.333;
			if (random() < 0.06)
				self.AIRG_FireCount = self.AIRG_FireCount - (random() * 0.5);
		}
//		if (self.AIRG_FireCount < 0) self.AIRG_FireCount = random() * 2;

//		if ((self.items & IT_INVULNERABILITY) && self.rune_flag)
//		if (self.attack_finished < (time + 2))
//			sprint(self, "Everyone will be blown straight to HELL - ");

		self.pk_explode_ammo = ceil(self.AIRG_FireCount);
/*
		sprint(self, "Gonna pop in ");
		sprint(self,ftos(ceil(self.AIRG_FireCount)));
		sprint(self, " or less");
		if ( (self.rune_flag & RUNE_FLG_HS) || (self.rune_flag & TECH_TEIM) )
		if (self.attack_finished < (time + 3))
			sprint(self, " - HURRY");
		sprint(self, "!\n");
*/
	}
// use archon power
	if (self.volume < 0)
		self.archon = self.archon + self.volume;
};

void() player_demon_jump =
{
	makevectors(self.v_angle);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 800 + '0 0 350';
	sound(self, CHAN_BODY, "demon/djump.wav", 1, ATTN_NORM);
	self.touch = player_demon_jumptouch;
	player_demon_jump1();
	self.map = "demon_jump"; // fixed dmg & rune drop on landing - want better solution
};

void() player_demon_stand = [ $stand1, player_stand1 ] {
	if(self.walkframe >= 13)
		self.walkframe=0;
	if (self.walkframe == 4) morph_sound(0.2, "demon/idle1.wav", 3);
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	if (self.flags & FL_DEMONBOOM) player_demon_explode();
};

void() player_demon_run = [ $run1, player_run ]
{
	vector sp;
	float walk, frm;

	sp = self.velocity;
	sp_z = 0;
	walk = (vlen(sp) < 250);

	if (walk)
		{
		frm = $walk1;
		if (self.walkframe >= 8) self.walkframe = 0;
		}
	else
		{
		frm = $run1;
		if (self.walkframe >= 6) self.walkframe = 0;
		}
	self.frame = frm + self.walkframe;
	self.walkframe = self.walkframe + 1;
	if (self.flags & FL_DEMONBOOM) player_demon_explode();
};

void() player_demon_pain = [       $pain5, player_demon_pain1    ]
{
//	if(self.pain_finished > time) return;
	self.pain_finished = time + 3;

	self.walkframe = 1;
	self.frame = $pain5;

	PainSound();
};

void()  player_demon_pain1 =  [      $pain1, player_demon_pain1    ]
{
        if (self.walkframe >=10)
                player_stand1();
        if (self.walkframe < 6)
                self.frame = $pain5 + self.walkframe;
        else self.frame = $pain5 + (10 - self.walkframe);
        self.walkframe = self.walkframe + 1;
		  if (self.walkframe == 2) morph_sound(0.4,self.noise2,2);
};

void() player_demon_attack =
{
	if (self.weapon == IT_AXE)
	{
		if (rune_haste(0.25))
		self.attack_finished = time + 0.5;
		player_demon_attack1();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		if (rune_haste(0.6))
		self.attack_finished = time + 1.2;
		player_demon_spike1();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.AIRG_FireCount = 5 + random() * 10;
		self.attack_finished = self.AIRG_FireCount + time;
		self.flags = self.flags | FL_DEMONBOOM; // demon go boom!
		if (self.AIRG_FireCount > 9) self.AIRG_FireCount = 10;
		self.pk_explode_ammo = -503;
//		sprint(self,"Rage has overcome you...\n");
		self.volume = -1;
	}
};

// fn(player_demon_impulse) - for extra balance weps

void() player_demon_impulse =
{

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	morph_impulse();

	self.volume = 0;
	self.pk_explode_ammo = 0;

	if (self.weapon == IT_AXE)
	if (self.pk_currentitem == PK_IT_AXE)
	{
//		sprint(self, "Demon using ( Hack & Slash )\n"); 
	}

	if (self.weapon == IT_SHOTGUN)
	{
//		sprint(self, "Demon using ( Head Spike )\n");
		self.items = self.items | IT_NAILS;
	}

	if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		if (((self.items & IT_INVULNERABILITY) && !self.rune_flag) || self.archon < 150)
		{
			if (self.archon > 149)
				self.pk_explode_ammo = -501;
//				sprint(self, "Pentagrams power surges beyond rage");
//				if (random() < 0.3)
//					sprint(self, " - try Hack & Slash & Jump");
//				sprint(self, "\n");
			else
				self.pk_explode_ammo = -505;
				
			self.weapon = IT_AXE;
		}
		else
		{
			self.volume = -150; // potential cost - its 1 pt per 1/10 sec
//			if (self.items & IT_INVULNERABILITY)
//				sprint(self, "Fiendish onslaught of DOOM!");
//			else
//			sprint(self, "Fiend getting enraged");
			if (self.rune_flag) self.pk_explode_ammo = -502;
//			if (self.rune_flag) self.stack1 = " * - you will lose runes of power";
			self.items = self.items | IT_ROCKETS;
//			if (self.items & IT_INVULNERABILITY) player_demon_attack(); // unstoppable
		}
	}
};

string(entity targ, entity attacker) player_demon_killmsg =
{
	if (!ENHANCED) return " was eviscerated by a Fiend\n";
	else if (attacker.deathtype == "rage")
	{
		if (attacker.items & IT_INVULNERABILITY) return " was sent straight to HELL by ";
		return " was blasted by ";
	}
	else if (random () < 0.75) 	return " was eviscerated by ";
	return " was slashed by "; 
};

string(entity targ, entity attacker) player_demon_killmsg2 =
{
	if (!ENHANCED) return "noname";
	else if (attacker.deathtype == "rage") return "'s violent rage\n";
	return "\n";
};

void(float silent) player_demon_become = 
{
	self._stand=player_demon_stand;
	self._run=player_demon_run;	
	self._pain=player_demon_pain;
	self._die=demon_die;
	self._jump=SUB_Null;
	self._jump2=player_demon_jump;
	self._attack=player_demon_attack;
	self._impulse=player_demon_impulse;
//	self._can_get_p=SUB_False;
	self._killmsg=player_demon_killmsg;
	self._killmsg2=player_demon_killmsg2;

	self.cam_z = 20 / 100;
	self.cam_y = 10;	

	stuffcmd(self, "exec cfg/morph/m-fiend.cfg\n");

	setmodel(self,"progs/demon.mdl");

	self.builtin = IT_AXE | IT_SHOTGUN | IT_GRENADE_LAUNCHER;
	self.items = self.items | self.builtin;
	self.weapon = IT_SHOTGUN;
	self.volume = 0;
	self.pk_explode_ammo = 0;

	self.msight = "demon/sight2.wav";
	self.noise2 = "demon/dpain1.wav";
	self.noise3 = null_string;
	self.view_ofs = '0 0 12'; // lowered by 10

//	if(!deathmatch)
//		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	else
		setsize (self, '-16 -16 -24', '16 16 20');
	self.health = self.health * MDEMON_HEALMOD / self.health_modifier;
	self.health_modifier = MDEMON_HEALMOD;
	makevectors(self.v_angle);
	spawn_tfog(self.origin + 20 * v_forward);


	if (!silent) // silent for starting new level as this beasty
	{
		bprint(self.netname);
		bprint(" has become "); // fiend
		bprint(polymorph_id(self.morphy));
		bprint(".\n");
		morph_impulse();
	}
};
