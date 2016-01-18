/* ::-::
 *
 * Cataboligne
 *
 * file: q3items.qc
 *
 * date: 10/16/08
 *
 * qc - support q3 stuff so darkplaces can run q3 maps for painkeep
 *
 */

// q3 values

float Q3_DEFW					= 123;
float Q3_DEFA					= 100;

// ammo skins in mdl
float q3_bfg_amsk				= 0;
float q3_rail_amsk			= 1;
float q3_plasma_amsk			= 2;
float q3_lightn_amsk			= 3;
float q3_rocket_amsk			= 4;
float q3_grenade_amsk		= 5;
float q3_shot_amsk			= 6;
float q3_mach_amsk			= 7;

// artifact frames / skins in mdl
float q3_quad_fsk				= 0;
float q3_regn_fsk				= 1;
float q3_env_fsk				= 2;
float q3_hst_fsk				= 3;
float q3_flt_fsk				= 4;
float q3_inv_fsk				= 5;

float Q3_BFG_AMMO				= 150; // 15 - adj =10 cells per shot -- using cell ammo for now
float Q3_SLUG_AMMO			= 10;
float Q3_CELL_AMMO			= 30;
float Q3_ELEX_AMMO			= 60;
float Q3_ROCK_AMMO			= 5;
float Q3_GREN_AMMO			= 5;
float Q3_SHOT_AMMO			= 10;
float Q3_BULLET_AMMO			= 50;

float Q3_MAX_BULLETS			= 200;	// max val without pack / rune
float Q3_MAX_SHELLS			= 200;
float Q3_MAX_ROCKETS			= 200;
float Q3_MAX_CELLS			= 200;
//float Q3_MAX_BFG				= 200;
//float Q3_MAX_LIGHTNING		= 200;
float Q3_MAX_SLUGS			= 200;
float Q3_MAX_GRENADES		= 200;

float Q3_ARM_RED				= 100;
float Q3_ARM_YEL				= 50;
float Q3_ARM_SHARD			= 5;
float Q3_ARM_MAX				= 200;

float Q3_WEP_WAIT				= 5;
float Q3_AMMO_WAIT			= 40;
float Q3_HEAL_WAIT			= 35;
float Q3_ARM_WAIT				= 25;

float Q3_HA_MAX				= 100;  // health and armor base max

float Q3_HEALLG				= 0; // skin ? - not needed for now
float Q3_HEALMD				= 1;
float Q3_HEAL5					= 2;
float Q3_HEALM					= 3;
float Q3_MAX_HEAL				= 200;

float Q3_HEALLG_A				= 50;
float Q3_HEALMD_A				= 25;
float Q3_HEAL5_A				= 5;
float Q3_HEALM_A				= 100;

float Q3_BARREL_BLAST		= 120;


vector Q3_LIFT					= '0 0 10'; // q3 models sit too "low" - lift them by this on spawn

//string Q3_BOBHOFF				= "cl_itembobheight 0\n"; // q3 item bob height off setting
//string Q3_BOBH					= "cl_itembobheight 8\n"; // q3 item bob height default - compile as 0 to disable (server cfg parm?)
//string Q3_BOBHALIAS			= "q3bobheight\n"; // q3 item bob height alias to run

/*
{name} entered the game

known obits

{name} was pummeled by {name}
{name} was machinegunned by {name}
{name} was gunned down by {name}
{name} ate {name}'s grenade
{name} ate {name}'s rocket
{name} was electrocuted by {name}
{name} was railed by {name}
{name} was melted by {name}'s plasmagun
{name} was blasted by {name}'s BFG

{name} tripped on her own grenade.
{name} blew herself up.
{name} melted herself.
{name} should have used a smaller gun.


{name} does a back flip into the lava.
*/
void() q3_precache =
{
// all ammo
// weps
// 1pv
// carry
	precache_model ("progs/q3_ammobox.mdl");
	precache_model ("progs/q3_arm.mdl");
	precache_model ("progs/q3_arm_shard.mdl");
	precache_model ("progs/q3_art.mdl");
	precache_model ("progs/q3_bfg.mdl");
	precache_model ("progs/q3_gauntlet.mdl");
	precache_model ("progs/q3_gl.mdl");
	precache_model ("progs/q3_grapple.mdl");
	precache_model ("progs/q3_health.mdl");
	precache_model ("progs/q3_hld_med.mdl");
	precache_model ("progs/q3_hld_tel.mdl");
	precache_model ("progs/q3_lg.mdl");
	precache_model ("progs/q3_mgun.mdl");
	precache_model ("progs/q3_plg.mdl");
	precache_model ("progs/q3_rail.mdl");
	precache_model ("progs/q3_rl.mdl");
	precache_model ("progs/q3_shot.mdl");
	precache_model ("progs/v_q3_bfg.mdl");
	precache_model ("progs/v_q3_gl.mdl");
	precache_model ("progs/v_q3_hawk.mdl");
	precache_model ("progs/v_q3_lg.mdl");
	precache_model ("progs/v_q3_mgun.mdl");
	precache_model ("progs/v_q3_mini.mdl");
	precache_model ("progs/v_q3_plg.mdl");
	precache_model ("progs/v_q3_rail.mdl");
	precache_model ("progs/v_q3_rl.mdl");
	precache_model ("progs/v_q3_shot.mdl");
	precache_model ("progs/vw_q3_bfg.mdl");
	precache_model ("progs/vw_q3_gl.mdl");
	precache_model ("progs/vw_q3_lg.mdl");
	precache_model ("progs/vw_q3_mg.mdl");
	precache_model ("progs/vw_q3_plg.mdl");
	precache_model ("progs/vw_q3_rail.mdl");
	precache_model ("progs/vw_q3_rl.mdl");
	precache_model ("progs/vw_q3_ssg.mdl");
	precache_model ("progs/vw_q3_gauntlet.mdl");
	precache_model ("progs/vw_q3_tel.mdl");
	precache_model ("progs/vw_q3_med.mdl");
	precache_model ("progs/player_sh.mdl");

// hear it
// art
// fire
	precache_sound ("sound/q3_snd/plasmx1a.wav");
	precache_sound ("sound/q3_snd/hyprbf1a.wav");
	precache_sound ("sound/q3_snd/ar3_pkup.wav");
	precache_sound ("sound/q3_snd/ar2_pkup.wav");
	precache_sound ("sound/q3_snd/ar1_pkup.wav");
	precache_sound ("sound/q3_snd/airout.wav");
	precache_sound ("sound/q3_snd/use_medkit.wav");
	precache_sound ("sound/q3_snd/regeneration.wav");
	precache_sound ("sound/q3_snd/regen.wav");
	precache_sound ("sound/q3_snd/quaddamage.wav");
	precache_sound ("sound/q3_snd/poweruprespawn.wav");
	precache_sound ("sound/q3_snd/invisibility.wav");
	precache_sound ("sound/q3_snd/holdable.wav");
	precache_sound ("sound/q3_snd/haste.wav");
	precache_sound ("sound/q3_snd/flight.wav");
	precache_sound ("sound/q3_snd/s_health.wav");
	precache_sound ("sound/q3_snd/n_health.wav");
	precache_sound ("sound/q3_snd/m_health.wav");
	precache_sound ("sound/q3_snd/l_health.wav");
	precache_sound ("sound/q3_snd/hgrenb1a.wav");
	precache_sound ("sound/q3_snd/rocklx1a.wav");
	precache_sound ("sound/q3_snd/lg_hum.wav");
	precache_sound ("sound/q3_snd/bfg_hum.wav");
	precache_sound ("sound/q3_snd/rg_hum.wav");
	precache_sound ("sound/q3_snd/gaunthum.wav");
	precache_sound ("sound/q3_snd/gauntrun.wav");
	precache_sound ("sound/q3_snd/lg_fire.wav");
	precache_sound ("sound/q3_snd/railgf1a.wav");
	precache_sound ("sound/q3_snd/bfg_fire.wav");
	precache_sound ("sound/q3_snd/grenlf1a.wav");
	precache_sound ("sound/q3_snd/machgf1b.wav");
	precache_sound ("sound/q3_snd/rocklf1a.wav");
	precache_sound ("sound/q3_snd/sshotf1b.wav");
	precache_sound ("sound/q3_snd/w_pkup.wav");
	precache_sound ("sound/q3_snd/am_pkup.wav");
	precache_sound ("sound/q3_snd/respawn1.wav");
	precache_sound ("sound/q3_snd/dr1_end.wav");
	precache_sound ("sound/q3_snd/dr1_strt.wav");
	precache_sound ("sound/q3_snd/pt1_end.wav");
	precache_sound ("sound/q3_snd/pt1_mid.wav");
	precache_sound ("sound/q3_snd/pt1_strt.wav");
	precache_sound ("sound/q3_snd/telein.wav");
	precache_sound ("sound/q3_snd/teleout.wav");
// lightning hook
	precache_sound ("q3_snd/lg_hit3.wav");
	precache_sound ("q3_snd/gauntrun.wav");

};

// bob em - needs called from client capable of stuff cmd

// IDEA: consider recrafted q3 maps with wad == "q3.wad"

void() q3_bob_height =
{
	if (!self.flags & FL_CLIENT) return;
	if (self.class_select == "class_bot") return; // already tested, but just in case

	if ((MAP_MODE != "Q3") || ((TR_Q3 > 0) && (TR_Q3 != FL_TR_Q3))) // dont bob if not q3 map or translating all q3 items
	{
		stuffcmd(self, "cl_itembobheight 0\n"); //Q3_BOBHOFF);
		stuffcmd(self, "q3bobheight\n"); // Q3_BOBHALIAS); // run this alias - lets players individually turn on or off bobheight
		return;
	}

	stuffcmd(self, "cl_itembobheight 8\n"); //Q3_BOBH); // bob q3 items, heh heh
	stuffcmd(self, "q3bobheight\n"); // Q3_BOBHALIAS); // run this alias - lets players individually turn on or off bobheight
};

/*
deprecating for full support - need this in translate

q3 support via translation

*/

float SUSPENDED = 1; // some q3 items "float" in the air - hope this works

// fn(q3_suspend) - make q3 items suspended as per q3 map spawnflag SUSPEND

// NOTE: possible issue if pk grap interacts with these - IDEA: mod grap to temp change movetype & restore with ip repos

void() q3_suspend =
{
	self.map = "Q3";
	self.movetype = MOVETYPE_NONE;
};

// fn(X_FireGauntlet) - fire gauntlet & maybe other x weps

void () X_FireGauntlet =
{
	local vector source;
	local vector org;
	local float gdmg;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16'; // TWEAK: adjust for actual gauntlet blade pos!
	if (self.classname == "pk*bot")
	{
		source = botaim ();
	}

	gdmg = 25;
	if (EWEAP)
	{
		if (EWEAP.dmg > 0) gdmg = EWEAP.dmg;
		if (EWEAP.noise3) sound (self, CHAN_BODY, EWEAP.noise3, 1, ATTN_NORM);
	}

	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (trace_ent, org, '0 0 0', gdmg);
		T_Damage (trace_ent,self,self,gdmg);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}
};

// fn(player_gauntlet1) - fire q3 gaunglet melee weapon (an possibly other xwep melee devices

// axatt1 axatt2 axatt3 axatt4 axatt5 axatt6
// fire frames
// 84 - main - axatt2 - wait here
// 85 - slice frame - axatt3
// 86 - slice down frame - axatt4
// 83 - release, hold .4

// exit set - holds gauntlet up for 0.4 - which happens to be att fin as well

void() player_gauntlet4 = [$axatt1, player_gauntlet5] { };
void() player_gauntlet5 = [$axatt1, player_gauntlet6] { };
void() player_gauntlet6 = [$axatt1, player_gauntlet7] { };
void() player_gauntlet7 = [$axatt1, player_gauntlet8] { };
void() player_gauntlet8 = [$axstnd12, player_stand1] { };

void() player_gauntlet1 =
{
	self.nextthink = time + 0.1;
	self.think = player_gauntlet1;

	if (self.tomb_time > GUN_BASE)
	{
		if (self.weaponframe > 1)
			self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe >= 6)
			self.weaponframe = 1;
		self.frame = $axatt2;
		self.tomb_time = self.tomb_time - 1;
		if (self.tomb_time <= GUN_BASE) // done - go back
		{
			self.tomb_time = 0;
			player_gauntlet4();
		}
		if (!self.button0)
		{
			if (self.velocity_x || self.velocity_y)
			{
				self.tomb_time = 0;
				player_run();
			}
			return;
		}
		else
		{
			self.tomb_time = 0;
			self.weaponframe = 0;
//			if (self.eweapon)
//				setorigin(self.eweapon, self.eweapon.origin + '0 0 1.33');  // kicked gun up - not using for now
		}
	}

	if (self.weaponframe > 3)
		self.weaponframe = 0;

// NOTE: need to take gauntlet vw model thru blade rotate frames & little elex bolts

	if (self.weaponframe == 3) // fire!
	{
		self.frame = $axatt3;
		EWEAP = self.eweapon;
		SuperDamageSound();
		if (EWEAP.mdl == "progs/vw_q3_gauntlet.mdl")
			X_FireGauntlet();
		else
		W_FireAxe();

		self.nextthink = time + EWEAP.attack_finished;
		if (!rune_haste(EWEAP.attack_finished / 2))
			self.nextthink = time + EWEAP.attack_finished / 2;

		EWEAP = world;
		self.tomb_time = GUN_WAIT;
		return;
	}

	self.weaponframe = self.weaponframe + 1;

	if (self.weaponframe <= 1) // bring pistol up to fire
	{
		if (self.frame < $axatt2)
			self.frame = $axstnd8;
		return;
	}
	else
	{
		self.frame = $axatt2;		
	}
};

// fn(player_q3grap) - fire or release q3 grap

void() player_q3grap =
{
	self.button0 = 0;
	self.impulse = 94;
	hook_impulse_check();
};


// kill messages

// bfg
string(entity targ, entity attacker) q3bfg_killmsg =
{
	if (targ == attacker) return " should have used a smaller gun.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was blasted by ";
};

string(entity targ, entity attacker) q3bfg_killmsg2 =
{
	if (targ == attacker) return null_string;
	return "'s BFG\n";
};

// rail
//string(entity targ, entity attacker) q3rail_killmsg =
string() q3rail_killmsg =
{
//	if (targ == attacker) return "should have used a smaller gun.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was railed by ";
};

//string(entity targ, entity attacker) q3rail_killmsg2 =
string() q3rail_killmsg2 =
{
//	if (targ == attacker) return null_string;
	return "\n";
};

// plasma
string(entity targ, entity attacker) q3plasma_killmsg =
{
	if (targ == attacker) return " melted himself.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was melted by ";
};

string(entity targ, entity attacker) q3plasma_killmsg2 =
{
	if (targ == attacker) return null_string;
	return "'s plasmagun\n";
};

// lightning
string(entity targ, entity attacker) q3ltn_killmsg =
{
	if (targ == attacker) return " blew himself up.\n"; // note: q3 lg doestn blow under water
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was electrocuted by ";
};

string(entity targ, entity attacker) q3ltn_killmsg2 =
{
	if (targ == attacker) return null_string;
	return "\n";
};

// rocket
string(entity targ, entity attacker) q3rock_killmsg =
{
	if (targ == attacker) return " blew himself up.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " ate ";
};

string(entity targ, entity attacker) q3rock_killmsg2 =
{
	if (targ == attacker) return null_string;
	return "'s rocket\n";
};

// grenade
string(entity targ, entity attacker) q3gren_killmsg =
{
	if (targ == attacker) return " tripped on his own grenade.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " ate ";
};

string(entity targ, entity attacker) q3gren_killmsg2 =
{
	if (targ == attacker) return null_string;
	return "'s grenade\n";
};

// shotgun
string() q3sg_killmsg =
{
//	if (targ == attacker) return " tripped on his own grenade.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was gunned down by ";
};

string() q3sg_killmsg2 =
{
//	if (targ == attacker) return null_string;
	return "\n";
};

// mg
string() q3mg_killmsg =
{
//	if (targ == attacker) return " tripped on his own grenade.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was machinegunned by ";
};

string() q3mg_killmsg2 =
{
//	if (targ == attacker) return null_string;
	return "\n";
};

// melee
string() q3g_killmsg =
{
//	if (targ == attacker) return " tripped on his own grenade.\n";
		
//	if (ENHANCED)
//		return(rnd_string('90.0 60.0 60.0'," "," ",null_string,null_string," "));

	return " was pummeled by ";
};

string() q3g_killmsg2 =
{
//	if (targ == attacker) return null_string;
	return "\n";
};

/*
q3 wep inventory slots

slot		weapon
1				gauntlet / grapple (when done) *
2				shotgun *
3				machine gun
4				plasma gun
5				railgun
6				grenade launcher
7				rocket launcher
8				bfg / lightning #

* = touch fn will replace other slot 1 & 2 weps with these
# = items are currently exclusive in touch - you can only get one

*/


/*QUAKED weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q3_weapon_bfg =
{
	q100_weapon_lightning();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		weapon_chainlg();
		self.touch = painkeep_touch;
		self.pk_touch = painkeep_weapon_touch;
		self.classname = "weapon_chainlg";
		return;
	}

	self.netname = "BFG";

	self.touch = x_weapon_touch;
	self._attack = X_Fire3BFG;
	self._fr_attack = player_shot1;

	self.items = IT_EXTRA_WEAPON;
	self.currentammo = 200; // 20 - adj =10 cells per shot -- using cell ammo for now
	self.lip = AMMO_BFG; // cells
	self.volume = Q3_MAX_CELLS;
	self.aflag = IGN_INV; // swap with *
	self.attack_finished = 0.2;
	self.dmg = 100;
	self.dodmg = 120;
	self.dmg_save = 10;
	self.dmg_take = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_bfg.mdl");
	self.weaponmodel = "progs/v_q3_bfg.mdl";
	self.vwepmdl = "progs/vw_q3_bfg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/bfg_fire.wav";
	self.noise2 = "q3_snd/bfg_hum.wav";
//	self.target = "q3_snd/plasmx1a.wav"; // q3 in game sound seems to be rocket smack
	self.target = "q3_snd/rocklx1a.wav";
	self.chaosweptime = 0.93;
	self.duration = SND_OVER;

	self._killmsg = q3bfg_killmsg;
	self._killmsg2 = q3bfg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

/*QUAKED weapon_plasmagun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_plasmagun =
{
	q100_weapon_lightning();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

	self.netname = "Plasma Gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_plasma1;

	self.items = IT_SUPER_NAILGUN;
	self.currentammo = 50;
	self.lip = AMMO_CELLS;
	self.volume = Q3_MAX_CELLS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 20;
	self.dodmg = 15;
	self.dmg_save = 1;
	self.dmg_take = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_plg.mdl");
	self.weaponmodel = "progs/v_q3_plg.mdl";
	self.vwepmdl = "progs/vw_q3_plg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.target = "q3_snd/plasmx1a.wav";
	self.duration = SND_OVER;
	self._killmsg = q3g_killmsg;
	self._killmsg2 = q3g_killmsg2;

	self._killmsg = q3plasma_killmsg;
	self._killmsg2 = q3plasma_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

/*QUAKED weapon_machinegun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

// doing the same way even tho q3 doesnt offer a dbl yet
void() q3_mg_base =
{
// stats
	self.items = IT_SHOTGUN;
	self.currentammo = 100;
	self.lip = AMMO_BULLETS;
	self.volume = Q3_MAX_BULLETS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 7;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.bulletspread = '0.025 0.025 0';
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.netname = "Machine Gun";

	setmodel (self, "progs/q3_mgun.mdl");
	self.weaponmodel = "progs/v_q3_mgun.mdl";
	self.vwepmdl = "progs/vw_q3_mg.mdl";
};

void() q3_weapon_machinegun =
{
	weapon_supernailgun();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_supernailgun";
		return;
	}

	q3_mg_base();
	self.touch = x_weapon_touch;//wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/machgf1b.wav";

	self._killmsg = q3mg_killmsg;
	self._killmsg2 = q3mg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() q3_weapon_shotgun =
{
	q100_weapon_supershotgun();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_supershotgun";
		return;
	}

	self.netname = "Shotgun";

	self.touch = x_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q3_SHOT_AMMO;
	self.aflag = IGN_INV;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.volume = Q3_MAX_SHELLS;
	self.attack_finished = 1;
	self.dmg = 10;
	self.dmg_save = 2;
	self.dmg_take = 11; // shot cnt
	self.bulletspread = '0.14 0.08 0'; // bullet spread out -- TDO: get q3 value, this is q1
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_shot.mdl");
	self.weaponmodel = "progs/v_q3_shot.mdl";
	self.vwepmdl = "progs/vw_q3_ssg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/sshotf1b.wav";
	self.duration = SND_OVER;

	self._killmsg = q3sg_killmsg;
	self._killmsg2 = q3sg_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void() q3_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_rocketlauncher";
		return;
	}

	self.netname = "Rocket Launcher";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 10;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.volume = Q3_MAX_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 100;
	self.dodmg = 120; // splash
	self.dmg_save = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

// appearances
	setmodel (self, "progs/q3_rl.mdl");
	self.weaponmodel = "progs/v_q3_rl.mdl";
	self.vwepmdl = "progs/vw_q3_rl.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/rocklf1a.wav";
	self.target = "q3_snd/rocklx1a.wav";
	self.duration = SND_OVER;

	self._killmsg = q3rock_killmsg;
	self._killmsg2 = q3rock_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void () q3_weapon_grenadelauncher =
{
	q100_weapon_grenadelauncher();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_grenadelauncher";
		return;
	}

	self.netname = "Grenade Launcher";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_FireGrenade;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 10;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_GRENADES;
	self.volume = Q3_MAX_GRENADES;
	self.attack_finished = 0.8;
	self.dmg = 100;
	self.dodmg = 150; // splash
	self.dmg_save = 1;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

// appearances
	setmodel (self, "progs/q3_gl.mdl");
	self.weaponmodel = "progs/v_q3_gl.mdl";
	self.vwepmdl = "progs/vw_q3_gl.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/grenlf1a.wav";
	self.target = "q3_snd/hgrenb1a.wav";
	self.duration = SND_OVER;

	self._killmsg = q3gren_killmsg;
	self._killmsg2 = q3gren_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;// + CB_SCOURGE;
};


void () weapon_gauntlet =
{
	weapon_axe();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = x_weapon_touch;
		self.classname = "weapon_axe";
		return;
	}

	self.netname = "Gauntlet";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_gauntlet1;

	self.currentammo = 0;
	self.aflag = IGN_INV; // swap with axe
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_AXE; // axe replacement
	self.lip = 0;
	self.attack_finished = 0.4;
	self.dmg = 50;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
	self.style = FL_MELEE_WEP;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.vv_draw = vw_q3_gaunt;

	setmodel (self, "progs/q3_gauntlet.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
	self.vwepmdl = "progs/vw_q3_gauntlet.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/gauntrun.wav";
	self.noise2 = "q3_snd/gaunthum.wav"; // gun hum
	self.chaosweptime = 1.99;

	self._killmsg = q3g_killmsg;
	self._killmsg2 = q3g_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};


/*QUAKED weapon_grapplinghook (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void () weapon_grapgun;

void () weapon_grapplinghook =
{
	weapon_grapgun();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = painkeep_weapon_touch;
		self.classname = "weapon_grapgun";
		return;
	}

	self.netname = "Grappling hook";

	self.touch = x_weapon_touch;
	self._attack = player_q3grap;
	self._fr_attack = SUB_Null;

	self.currentammo = 0;
	self.lip = 0;
	self.attack_finished = 0.5;
	self.lefty = SEL_LTN_HOOK;
	self.items = IT_AXE;
	self.pk_currentitem = PK_IT_GRAPGUN; // grap replacement
/*
	self.dmg = 5;  // CHECK: if ltn hook does dmg from gun
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
*/
	self.style = FL_MELEE_WEP;
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	self.vv_draw = vw_q3_grap;

	setmodel (self, "progs/q3_grapple.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
	self.vwepmdl = "progs/vw_q3_grap.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
//	self.noise3 = "q3_snd/gauntrun.wav"; // same as targetname, so using that

// grap specials

	self.killtarget =  null_model;
	self.target = "q3_snd/lg_hit3.wav"; // hook hit a solid - not damaged
	self.noise1 = null_string; // drop
	self.target1 = null_string; // in + out
	self.target2 = null_string; // in + out
	self.targetname = "q3_snd/gauntrun.wav"; // launch snd
	self.bulletspread_x = 0.5; // damp

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN;
};

void () q3_weapon_lightning =
{
	q100_weapon_lightning();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		return;
	}

	self.netname = "Lightning Gun";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_light1;

	self.currentammo = 100;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_LIGHTNING; // really cells
	self.volume = Q3_MAX_CELLS;
	self.attack_finished = 0.1; // IDEA: separate from q1 lg fire ??
	self.dmg = 8;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	if (!self.wait) self.wait = RSP_TIME * 0.1666;

	setmodel (self, "progs/q3_lg.mdl");
	self.weaponmodel = "progs/v_q3_lg.mdl";
	self.vwepmdl = "progs/vw_q3_lg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/lg_fire.wav";
//	self.noise2 = "q3_snd/lg_hum.wav"; // ? - could have been 1 lg used to use - CHECK
	self.chaosweptime = 0.964;

	self._killmsg = q3ltn_killmsg;
	self._killmsg2 = q3ltn_killmsg2;

	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;// + CB_SCOURGE;
};

void () q3_weapon_railgun =
{
	q100_weapon_lightning();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = weapon_touch;
		self.classname = "weapon_lightning";
		if (random() < 0.5)
		{
			weapon_chainlg();
			self.pk_touch = painkeep_weapon_touch;
			self.classname = "weapon_chainlg";
		}
		return;
	}

	self.netname = "Rail Gun";

	self.touch = x_weapon_touch;
	self._attack = X_FireRailgun;
	self._fr_attack = player_rocket1;

	self.currentammo = Q3_SLUG_AMMO;
	self.aflag = IGN_INV;
	self.items = IT_NAILGUN; // swapped with mg so gremlin can get raily
	self.lip = AMMO_SLUGS;
	self.volume = Q3_MAX_SLUGS;
	self.attack_finished = 1.5;
	self.dmg = 100;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	if (!self.wait) self.wait = RSP_TIME * 0.1666;
	self.lefty = Q3_RAILBEAM;

	setmodel (self, "progs/q3_rail.mdl");
	self.weaponmodel = "progs/v_q3_rail.mdl";
	self.vwepmdl = "progs/vw_q3_rail.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/railgf1a.wav"; // IDEA: impact site snd
	self.noise2 = "q3_snd/rg_hum.wav"; // gun hum
	self.chaosweptime = 1.16;
	self.endtime = 1.55;

	self._killmsg = q3rail_killmsg;
	self._killmsg2 = q3rail_killmsg2;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};

void() q3_ammo_bullets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_spikes();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_BULLET_AMMO;
		return;
	}

	self.netname = "Bullets";

	self.lip = AMMO_BULLETS;
	self.volume = Q3_MAX_BULLETS;
	self.currentammo = Q3_BULLET_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_mach_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
}

void() q3_ammo_grenades =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_rockets();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_GREN_AMMO;
		return;
	}

	self.netname = "Grenades";

	self.lip = AMMO_GRENADES;
	self.volume = Q3_MAX_GRENADES;
	self.currentammo = Q3_GREN_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_grenade_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
}

void() ammo_lightning =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Cells";

	self.lip = AMMO_LIGHTNING; // cells
	self.volume = Q3_MAX_CELLS;
	self.currentammo = Q3_ELEX_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_lightn_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
}

void() ammo_bfg =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Cells";

	self.lip = AMMO_BFG; // cells - amount adjusted to fire proper count of bfg shots
	self.volume = Q3_MAX_CELLS;
	self.currentammo = Q3_BFG_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_bfg_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
}

// spawnfunc_ - because quake already has variables ammo_* and the function names cannot be used
//  -- darkplaces has a special call mode for map items that appends spawnfunc_ to cover stuff like this

//ammo_shells
//ammo_rockets
//ammo_cells

void() q3_ammo_shells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_SHOT_AMMO;
		return;
	}

	self.netname = "Shells";

	self.lip = AMMO_SHELLS;
	self.volume = Q3_MAX_SHELLS;
	self.currentammo = Q3_SHOT_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_shot_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
}

void() q3_ammo_rockets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_rockets();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_ROCK_AMMO;
		return;
	}

	self.netname = "Rockets";

	self.lip = AMMO_ROCKETS;
	self.volume = Q3_MAX_ROCKETS;
	self.currentammo = Q3_ROCK_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_rocket_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
}

void() q3_ammo_cells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Cells";

	self.lip = AMMO_CELLS;
	self.volume = Q3_MAX_CELLS;
	self.currentammo = Q3_CELL_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_plasma_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF + CB_SCOURGE;
}

//ammo_slugs

void() q3_ammo_slugs =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_cells();
	self.touch = pk_ammo_touch;

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.aflag = Q3_ELEX_AMMO;
		return;
	}

	self.netname = "Slugs";

	self.lip = AMMO_SLUGS;
	self.volume = Q3_MAX_SLUGS;
	self.currentammo = Q3_SLUG_AMMO;
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_rail_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
}

// armors + healths

// Cataboligne - 9.7.11 - fix for conflict between q3 & other ex-up health & armor conflicts

// rotting health | armor down

// owner - player | bot ent
// enemy - item ent

void() q3_ha_rot_thk =
{
	local float f, tv1, tv2;

	f = FALSE;
	tv1= Q3_HA_MAX  * self.owner.health_modifier; // Cat - conflict fixes - 9.18.11 - morphic adjust
	tv2 = Q3_HA_MAX; // Cat - conflict fixes
	if (self.health > Q3_HA_MAX) tv1 = self.health;
	if (self.armorvalue > Q3_HA_MAX) tv2 = self.armorvalue;

#ifdef enhanced
//	if ((!self.owner.rune_flag & TECH_ADOC) || !ENHANCED)
//	if ((!self.owner.rune_flag & RUNE_VAMPIRE) || !ENHANCED)
	if (! self.owner.rune_flag & TECH_ADOC)
	if (! self.owner.rune_flag & RUNE_VAMPIRE)
#endifdef
	if (!self.owner.rune_flag & RUNE_FLG_RG) // no rot when regen item or rune is set
	if (self.owner.health > tv1)
	{
		self.owner.health = self.owner.health - 1;
		if (self.enemy)
			self.enemy.duration = self.enemy.duration - 1; // for drop inv
		f = TRUE;
	}

#ifdef enhanced
//	if ((!self.owner.rune_flag & TECH_ADOC) || !ENHANCED)
	if (! self.owner.rune_flag & TECH_ADOC)
#endifdef
	if (self.owner.armorvalue > tv2)
	{
//		armorsave_rev(self.owner);
		self.owner.armorvalue = self.owner.armorvalue - 1;
		f = TRUE;
	}

	if ((f && self.super_time > time) && (self.owner.items & IT_SUPERHEALTH))
		self.nextthink = time + 1;
	else
	{
		if (self.enemy)
		{
			if (self.enemy.wait)
				self.enemy.nextthink = time + self.enemy.wait;
			else
				self.enemy.nextthink = time + 20;
			self.enemy.think = SUB_regen;
			self.enemy.map = null_string;
			self.enemy.owner = world;
		}
		self.owner.items = self.owner.items - (self.owner.items & IT_SUPERHEALTH);
		remove(self);
	}
};

float Q3_ROT_TMAX = 300; // 5 mins - max time a rot can hang around

// in case rot gets lost, we put this back

void() q3_megahealth_restore =
{
	self.nextthink = time + 1;
	self.think = SUB_regen;
};

void(entity e, float v) q3_ha_rot =
{
	local entity f;
	local float ta;

	if (!e) return;

	ta = fabs(v);
	newmis = world;

	if (v > Q3_HA_MAX || v < 0)
	{
		f = find(world,classname,"q3_rot");
		while (f)
		{
			if (f.owner == e)
			{
				if (v < 0)
				{
					if (Q3_HAH_TMP > 0) f.health = f.health + Q3_HAH_TMP;
					if (Q3_HAA_TMP > 0) f.armorvalue = f.armorvalue + Q3_HAA_TMP;

					if (f.health > Q3_MAX_HEAL || f.owner.health < Q3_HA_MAX)
					if (f.armorvalue > Q3_MAX_HEAL || f.owner.armorvalue < Q3_HA_MAX) // gone beyond capacity of rot - lose it
					{
						f.owner.items = f.owner.items - (f.owner.items & IT_SUPERHEALTH);
						if (f.enemy)
						{
							if (f.enemy.wait)
								f.enemy.nextthink = time + f.enemy.wait;
							else
								f.enemy.nextthink = time + 20;
							f.enemy.think = SUB_regen;
							f.enemy.map = null_string;
							f.enemy.owner = world;
						}
						remove(self);
					}
					Q3_HAH_TMP = Q3_HAA_TMP = 0;
				}
				else
				f.nextthink = time + 5; // reset with new acq
				return;
			}
			f = find(f,classname,"q3_rot");
		}

		if (v > Q3_HA_MAX)
		{
			newmis = chaos_spawn(0, 0, 0, 0, v0, v0, v0, v0, v0, "q3_rot", null_string, SUB_Null, 5, q3_ha_rot_thk, SUB_Null, e, world);
			newmis.super_time = time + Q3_ROT_TMAX;
			newmis.health = newmis.armorvalue = Q3_HA_MAX;
			if (!other.items & IT_SUPERHEALTH) // we might already be rotting from another mega heal - if so rot down limit set to normal max
			if (Q3_HAH_TMP > Q3_HA_MAX) newmis.health = Q3_HAH_TMP;
			if (Q3_HAA_TMP > Q3_HA_MAX) newmis.armorvalue = Q3_HAA_TMP;
		}
	}
	Q3_HAH_TMP = Q3_HAA_TMP = 0;
};


void() q3_item_armor_combat =
{
	item_armor2();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armor1";
		return;
	}

	self.netname = "Armor";

	self.volume = 200; // max add
	self.currentammo = Q3_ARM_YEL; // 50 units
	self.style = 0.6;
	self.items = IT_ARMOR2;
	if (!self.wait) self.wait = RSP_TIME * 0.8333;

	setmodel (self, "progs/q3_arm.mdl");
	self.noise = "q3_snd/ar2_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = 0;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_ENF;
};

void() q3_item_armor_body =
{
	item_armorInv();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.touch = painkeep_touch;
		self.pk_touch = armor_touch;
		self.classname = "item_armorInv";
		return;
	}

	self.netname = "Heavy Armor";

	self.volume = 200; // max add
	self.style = 0.6;
	self.currentammo = Q3_ARM_RED; // 100 units
	self.items = IT_ARMOR3;
	if (!self.wait) self.wait = RSP_TIME * 0.8333;

	setmodel (self, "progs/q3_arm.mdl");
	self.noise = "q3_snd/ar3_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = 1;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN + CB_ENF;
};

void() q3_item_armor_shard =
{
	item_armor1();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, FALSE, null_string))
	{
		self.classname = "item_armor1";
		self.wad = "armor_toss"; // for alt value
		self.noise = "items/armor1.wav";
		self.items = IT_ARMOR1;
		self.volume = 200; // max add
		self.currentammo = Q3_ARM_SHARD;
		return;
	}

	self.netname = "Armor shard";

	setmodel (self, "progs/q3_arm_shard.mdl");
	self.volume = 200; // max add
	self.style = 0.3;
	self.items = IT_ARMOR1;
	self.currentammo = Q3_ARM_SHARD; // 5 units
	if (!self.wait) self.wait = RSP_TIME * 0.8333;

	self.noise = "q3_snd/ar1_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.effects = self.effects | EF_FULLBRIGHT;

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

void() q3_item_health_small =
{
	q100_item_health();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.healamount = Q3_HEAL5_A;
		return;
	}

	self.netname = "5 health";

	self.healamount = Q3_HEAL5_A;
	self.healtype = HEAL_BOT;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/s_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEAL5;
	self.volume = Q3_MAX_HEAL; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.1666;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

void() q3_item_health =
{
	q100_item_health();
	
	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
		return;

	self.netname = "25 health";

	self.healamount = Q3_HEALMD_A;
	self.healtype = HEAL_NORM;
	self.volume = Q_NORM_MAX; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.1666;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/n_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEALMD;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

void() q3_item_health_large =
{
	q100_item_health();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		self.healamount = Q3_HEALLG_A;
		return;
	}

	self.netname = "50 health";

	self.healamount = Q3_HEALLG_A;
	self.healtype = HEAL_NORM;
	self.volume = Q_NORM_MAX; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.1666;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/l_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEALLG;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

void() q3_item_health_mega =
{
	self.spawnflags = self.spawnflags | 2;
	q100_item_health();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_health_mega"))
	{
		return;
	}

	self.netname = "Mega health";

	self.items = IT_SUPERHEALTH;
	self.healamount = Q3_HEALM_A;
	self.healtype = HEAL_MEGA;
	self.volume = Q3_MAX_HEAL; // max add
	if (!self.wait) self.wait = RSP_TIME * 1.333;

	setmodel(self, "progs/q3_health.mdl");
	self.noise = "q3_snd/m_health.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.skin = Q3_HEALM;
	self.frame = 1;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

void() q3_item_quad =
{
	item_artifact_super_damage();
	
	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		return;
	}

	self.netname = "Quad Damage";

	self.touch = x_pwr_touch;
	self.items = IT_QUAD;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/quaddamage.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_quad_fsk;
	self.skin = q3_quad_fsk;
	self.alpha = 0.9;

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

// code for q3 arts that use rune effects

void() q3_art_shell =
{
	local float f;
	
	if (self.items) f = !(self.items & self.owner.items);
	if (self.enemy.skin == Q3_SH_HASTE) f = !(self.owner.rune_flag & RUNE_FLG_HS);

	if (!self.enemy || self.owner.health <= 0 || f )
	{
		stack_delete(self.owner, self.teamname); // remove classname from stack - Cataboligne - 10.31.12 
		if (self.enemy)
		{
			self.enemy.vwepent = world;
			remove(self.enemy);
		}
		vw_chain(self.owner); // removed artifact shell
		remove(self);
		return;
	}
	self.nextthink = time + 0.5;
};

void() regen_shell_exp =
{
	local float h, f;

	f = (self.owner.rune_flag & (RUNE_FLG_RG | RUNE_FLG_HS));
	if (!f || !self.enemy || self.owner.health <= 0)
	{
		if (self.enemy)
		{
			self.enemy.vwepent = world;
			remove(self.enemy);
		}
		stack_delete(self.owner, self.teamname); // remove classname from stack - Cataboligne - 10.31.12 
		vw_chain(self.owner); // removed artifact shell
		self.owner.volume = 0;
		remove(self);
		return;
	}
	self.nextthink = time + 1;

	if (self.owner.volume > 100)
		h = self.owner.volume;
	else
		h = 200; // q3 default val

		if (self.enemy.mdl != null_model || (self.owner.health >= h)) 
			self.enemy.mdl = null_model;
		else
			self.enemy.mdl = "progs/player_sh.mdl";
		setmodel(self.enemy, self.enemy.mdl);
};

void() q3_pwr_touch =
{
	local entity e;

	if (other.classname != "player") // bot handled by pk_touch
			return;
	if (other.health <= 0)
		return ;

	if (other.rune_flag & self.spawnflags) // already using this rune power - just go back
	{
		stack_delete(other, self.classname); // failed - remove classname from stack - Cataboligne - 10.16.12 - clear up issue where haste rune was getting lost from server
		return;
	}

	if (self.spawnflags & RUNE_FLG_FLY)
	if (other.mdl == "progs/gremlin-fly.mdl") // in case he's also invisible
		return;

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	self.mdl = self.model;

	if (deathmatch != 4) // *pk - my new rule, logical extrapolation
	if (deathmatch)
	{
		if (self.wait && self.class_select == "q3_item")
			self.nextthink = time + self.wait;
		else
		self.nextthink = time + RSP_TIME * 2; // = 60 default
		self.think = SUB_regen;
	}

	other.rune_flag = other.rune_flag | (self.spawnflags);// -- flight & mask deal -- & RUNE_MASK_ALL); // still qualify one of the valid runes
//	other.target2 = self.model; // moved to touch
	if (self.volume) other.volume = self.volume; // regen rune

	if (self.spawnflags & RUNE_FLG_FLY) other.movetype = MOVETYPE_FLY;

	if (other.mask_x & CB_HUMAN)
	if (self.spawnflags & (RUNE_FLG_RG | RUNE_FLG_HS))
	{
		e = spawn();
		e.teamname = self.classname; // for stack fix
		e.think = regen_shell_exp;
		e.nextthink = time + 0.5;
		e.owner = other;
		e.enemy = vload(other, -1);
//		e.volume = self.volume;
		setmodel(e.enemy, "progs/player_sh.mdl");
		e.enemy.mdl = e.enemy.model;
		e.enemy.skin = Q3_SH_REGEN;
		if (self.spawnflags & RUNE_FLG_HS)
		{
			e.enemy.skin = Q3_SH_HASTE;
			e.think = q3_art_shell;
			e.nextthink = time + 1; //POW_TIME - 1; // have to check all the time in case of drop 
		}
		e.wad = "art_shell";
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = null_string;

	e = spawn();
	if (e) // code contingent for fail
	{
		e.classname = "rune_1_expiry";
		e.netname = self.netname;
		e.teamname = self.classname; // for stack fix
		e.rune_flag = self.spawnflags; // & RUNE_MASK_ALL; // NOTE: not really needed as long as bit for inv item is set right
		e.think = rune_1_expire;
		e.aflag = 0;
		if (self.group) // give a 3 rel warning
		{
			e.aflag = 3;
			e.group = self.group;
		}
		if (self.dmgtime)
			e.nextthink = time + self.dmgtime - e.aflag;
		else
		e.nextthink = time + POW_TIME - e.aflag;
		e.owner = other;
//		e.noise4 = self.noise4; // included with below
		e.wad = "art_shell";
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
};

void() item_regen =
{
	if (self.class_select == null_string) self.class_select = "q3_item";

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_artifact_invulnerability")) // IDEA: random possibilities via str func
	{
		return;
	}

	self.spawnflags = RUNE_FLG_RG;
	self.duration = 0;
	self.volume = Q3_MAX_HEAL; // max add
//	item_sigil();
	self.netname = "Regeneration";
	self.group = "Pain is returning to your life";

	self.touch = q3_pwr_touch;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/regeneration.wav";
	self.noise3 = "q3_snd/regen.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_regn_fsk;
	self.skin = q3_regn_fsk;
	self.alpha = 0.9;

	if (self.spawnflags & SUSPENDED) q3_suspend();
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ART + 0.2;
};

void() item_invis =
{
	item_artifact_invisibility();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		return;
	}

	self.netname = "Invisibility";
	self.group = "Invisibility power is fading";

	self.touch = x_pwr_touch;
	self.items = IT_INVISIBILITY;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/invisibility.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_inv_fsk;
	self.skin = q3_inv_fsk;
	self.alpha = 0.5;

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL;
};

void() q3_item_enviro =
{
	item_artifact_envirosuit();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		return;
	}

	self.netname = "Battle Suit";
	self.group = "Battle suit is about to shut down";

	self.touch = x_pwr_touch;
	self.items = IT_SUIT;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/airout.wav"; // CHECK: this doesnt make sense
	self.noise3 = "q3_snd/airout.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_env_fsk;
	self.skin = q3_env_fsk;
	self.alpha = 0.9;

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = MORPH_ALL - (MORPH_ALL & CB_CTHON);
};

void() item_haste =
{
	if (self.class_select == null_string) self.class_select = "q3_item";

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_artifact_invulnerability"))
	{
		return;
	}

	self.spawnflags = RUNE_FLG_HS;
	self.duration = 0;
//	item_sigil();
	self.netname = "Haste";
	self.group = "Speedster powers deactivate";

	self.touch = q3_pwr_touch;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/haste.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_hst_fsk;
	self.skin = q3_hst_fsk;
	self.alpha = 0.9;

	if (self.spawnflags & SUSPENDED) q3_suspend();
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
	self.mask_x = MORPH_ALL;

	self.archon = ARCHON_ART + 0.1;
};

void() item_flight =
{
	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, "item_artifact_super_damage"))
	{
		return;
	}

	item_spikes();
	self.netname = "Flight";
	self.group = "\bSecure for landing!";

	self.touch = q3_pwr_touch;
	self.spawnflags = RUNE_FLG_FLY;
	self.dmgtime = Q3_POWER_TIME;
	if (!self.wait) self.wait = Q3_POWER_WAIT;

	setmodel(self, "progs/q3_art.mdl");
	self.noise = "q3_snd/flight.wav";
	self.noise4 = "q3_snd/poweruprespawn.wav";
	self.frame = q3_flt_fsk;
	self.skin = q3_flt_fsk;
	self.alpha = 0.9;

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_GREMLIN | (MORPH_ALL - ( MORPH_ALL & MORPH_FLY)); // flyers dont get goody

	self.archon = ARCHON_ART;
};

// holdables
void() player_q3held =
{
	local entity e;
	local float f;

	if (!self.eweapon) return; // nothing to fire apparently

	if (self.eweapon.pk_currentitem == PK_IT_CANPAB)
	if (self.health < 100 * self.health_modifier)
	{
		other = self;
		T_Heal(other, 100, 0); // first get 100
		T_Heal(other, 25, 1); // then take to 125 - we cant just add 125 here
		Q3_HAH_TMP = 0;
		Q3_HAA_TMP = other.armorvalue;
		q3_ha_rot(other, other.health); // make sure we rot the extra 25

		if (self.eweapon.noise3)
			sound (self, CHAN_AUTO, self.eweapon.noise3, 1, ATTN_NORM);
		f = TRUE;
	}

	if (self.eweapon.pk_currentitem == PKPLUS_IT_PHONE)
	{
		e = spawn ();
		e.owner = self;
		e.think = phone_teleport;
		e.nextthink = (time + 0.5);
		e.noise1 = self.eweapon.noise1;
		e.noise3 = self.eweapon.noise3;
		e.pk_currentitem = -1;

		f = TRUE;
	}

	if (f) // fired this weap
	{
		e =  vchk(IT_AXE, self.eweapon.pk_currentitem, self.vwepent);
		if (e)
		{
			e.vwepent = world;
			remove(e);
			vw_chain(self); // removed holdable ent
		}

		self.weapon = W_BestWeapon();
		self.pk_currentInventory = self.pk_currentitem = W_BestPKWeapon();
		W_SetCurrentAmmo();
	}
};

void() item_painkeep_can;
void() item_pkplus_phone;

void() holdable_medkit =
{
	item_painkeep_can();

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		return;
	}

	self.netname = "Holdable Medkit";
	self.touch = x_pwr_touch;
	self.pk_currentitem = PK_IT_CANPAB;
	self.items = IT_AXE;
	self.stack1 = "q3_hold";

	self._attack = player_q3held;
	self._fr_attack = SUB_Null;

	self.currentammo = 1;
	self.lip = 0;
	self.attack_finished = 1;

	self.style = FL_MELEE_WEP;
	self.vv_draw = vw_melee_base;

	if (!self.wait) self.wait = RSP_TIME * 2;

	setmodel(self, "progs/q3_hld_med.mdl");
	self.vwepmdl = "progs/vw_q3_med.mdl";
	self.weaponmodel = "progs/v_q3_med.mdl";

	self.noise = "q3_snd/holdable.wav";
	self.noise3 = "q3_snd/use_medkit.wav";
	self.noise4 = "q3_snd/respawn1.wav";

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN | CB_GREMLIN;

	self.archon = ARCHON_ART;
};

void() holdable_teleporter =
{
	if (!self.netname)
	{
		item_pkplus_phone();
		self.class_select = "q3_item";
	}

	if (!ULOK3)
//	if (!XMOD)
	if (noxtr_item_control(self, TRUE, null_string))
	{
		return;
	}

	self.netname = "Holdable Teleport";

	self.touch = x_pwr_touch;
	self.pk_currentitem = PKPLUS_IT_PHONE;
	self.items = IT_AXE;
	self.stack1 = "q3_hold";
	
	self._attack = player_q3held;
	self._fr_attack = SUB_Null;

	self.currentammo = 1;
	self.lip = 0;
	self.attack_finished = 1;

	self.style = FL_MELEE_WEP;
	self.vv_draw = vw_melee_base;

	if (!self.wait) self.wait = RSP_TIME * 2;

	setmodel(self, "progs/q3_hld_tel.mdl");
	self.vwepmdl = "progs/vw_q3_tel.mdl";
	self.weaponmodel = "progs/v_q3_tel.mdl";

	self.noise = "q3_snd/holdable.wav";
	self.noise1 = "q3_snd/teleout.wav";
	self.noise3 = "q3_snd/telein.wav";
	self.noise4 = "q3_snd/respawn1.wav";

	if (self.class_select == null_string) self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
	self.mask_x = CB_HUMAN | CB_GREMLIN;

	self.archon = ARCHON_ART;
};

// hack just to match others - q3 has no explode boxes - and appearances can be deceiving

// IDEA: box model or some such

void() q3_misc_explobox =
{
	local float r;
	self.netname = "Barrel";
	if (self.class_select == null_string) self.class_select = "q3_item";
	misc_explodbox_set(self, "progs/barrel.mdl", Q3_BARREL_BLAST, 80, MOVETYPE_NONE);
	droptofloor(0,0);

	r = rint(3 * random());
	if (r == 1)
	{
	setmodel (self, "progs/q3_ammobox.mdl");
	self.frame = 0;
	self.skin = q3_bfg_amsk;
	}
	else if (r == 2)
	{
	setmodel (self, "progs/q3_arm.mdl");
	self.frame = 0;
	self.skin = 1;
	}
	else if (r == 3)
	{
	setmodel(self, "progs/q3_health.mdl");
	self.frame = 1;
	self.skin = Q3_HEALM;
	}
	else //if (r == 0)
	{
	setmodel(self, "progs/q3_art.mdl");
	self.frame = q3_regn_fsk;
	self.skin = q3_regn_fsk;
	}
//	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "q3_snd/respawn1.wav";

	if (!self.wait) self.wait = RSP_TIME;
//	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// enable other q3 map ents

/*		q3 ---
	QUAKED info_player_intermission (1 0 1) (-16 -16 -16) (16 16 16)
Camera for intermission screen between matches. This also automatically generates the podium for bot arena matches (see Notes). Can be aimed by setting the "angles" key or targeting an pointing to an aiming entity. Use only one per level.
-------- KEYS --------
angles: alternate "pitch, yaw, roll" angles method of aiming intermission camera (default 0 0 0).
target : point this to an info_notnull or target_position entity to set the camera's pointing angles.
-------- NOTES --------
In genuine bot arena matches, the podium for the 1st, 2nd and 3rd place players at the end of the match is generated by this entity. The podium's origin will automatically be located 128 units in the direction of the camera's view and 84 units down from the y height of the view line at that point. It will also always be generated on a level plane regardless of the pointing angle of the camera so if that angle is too steep, part of the podium model might not be visible. Make sure you leave at least 106 units of free space in front of where the camera points to otherwise the podium model won't be visible at all.
*/

void() info_player_intermission =
{

};

// push for q3

// IMP: q3 sounds

void () q3_trigger_push_think =
{

	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}

	if (vlen(self.owner.origin - self.goalentity.origin) < 64)
	{
//		self.owner.velocity = self.speed * self.movedir * 10 * 0.2;
		self.nextthink = time + 10; // incase its in link set middle
		self.think = SUB_Remove;
//		remove(self);
		return;
	}
	else
		self.owner.velocity = self.speed * self.movedir * 10;

	self.nextthink = time + 0.2;

	if (self.owner.classname == "player")
	{
		if (self.owner.fly_sound < time)
		{
			self.owner.fly_sound = time + 1.5;
			sound (self.owner, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
		}
	}
	if (self.owner.classname == "pk*bot")
	{
		if ((self.movedir_x < 0.1) && (self.movedir_y < 0.1))
		{
			self.owner.velocity_x = ((self.owner.velocity_x + (80 * random ())) - 40);
			self.owner.velocity_y = ((self.owner.velocity_y + (80 * random ())) - 40);
		}
		if (self.owner.fly_sound < time)
		{
			self.owner.fly_sound = (time + 1.5);
			sound (self.owner,CHAN_AUTO,"ambience/windfly.wav",TRUE,ATTN_NORM);
		}
	}

};

void () q3_trigger_push_touch =
{
	local entity e;

	if (!self.goalentity)
	if (self.target)
	{
		e = find (world,targetname,self.target);
		self.goalentity = e;
		if (e)
			self.movedir = normalize(e.origin - self.origin);
	}

	e = self.vwepent;

	if (Q3_JP_INSTANT)
	{
		if (self.goalentity)
		{
			sound (other,CHAN_AUTO,"ambience/windfly.wav",TRUE,ATTN_NORM);
			setorigin(other, self.goalentity.origin);
		}
		return;
	}

	while (e) // see if we already jumped him
	{
		if (e.owner == other) return;
		e = e.vwepent;
	}

	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.enemy.classname == "pk*bot")
		{
			enemy_touched ();
		}
	}

	e = spawn();
	e.classname = "q3_pusher";
	e.owner = other;
	e.goalentity = self.goalentity; // target
	e.think = q3_trigger_push_think;
	e.nextthink = time + 0.2;
	e.attack_finished = time + self.wait; // end push after this
	e.vwepent = self.vwepent; // push down stack
	self.vwepent = e;
	
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};

/*		q3 ---
	QUAKED target_position (0 .5 0) (-8 -8 -8) (8 8 8)
Aiming target for entities like light, misc_portal_camera and trigger_push (jump pads) in particular.
-------- KEYS --------
targetname : the entity that requires an aiming direction points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
To make a jump pad, place this entity at the highest point of the jump and target it with a trigger_push entity.
*/

void() target_position =
{
//	setmodel(self, "progs/hook.mdl");
};

/*QUAKED q3_trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player - q3 style
*/
void () q3_trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = q3_trigger_push_touch;
	self.istrigger = 1;
	self.th_weight = trigpushweight; // *bot
	if (!self.speed)
		self.speed = 80;
	if (!self.wait) self.wait = 60; // time push can run
	if (!self.target)
	{
		self.wait = 15; // just a guess - this objects 15 mins of faim
		self.movedir = '0 -1 0'; // didnt have a target - default to up
	}
};

/*QUAKED misc_model (1 0 1) (-16 -16 -24) (16 16 32)
--------  CAT  -------
Chaos Mod MK II

prototype a model for viewing on test levels

-------- KEYS --------
usual parms: origin, model, angle, skin, solid (2 blocking)

"model"         "filename" - model to load

run frames:

"count" 		"#"		- first frame
"state" 		"#"		- last frame loops to first
"delay" 		"#"		- frame display time - default = 0.1 sec
"cnt" 		    "#"		- first skin
"dmg"   		"#"		- last skin - > 0 loop to first, < 0 reverse loop (inclusive)
"map"			"move"	- allow game items (grav well) to move this model

-------- NOTES --------
func_model wrapper
*/

void() misc_model =
{
	func_model();
	self.classname = "func_model"; // all called func_model for biomes
};

/*		q3 ---
	QUAKED misc_teleporter_dest (1 .5 .25) (-32 -32 -24) (32 32 -16)

Teleport destination location point for trigger_teleporter entities.
-------- KEYS --------
angle : direction in which player will look when teleported.
targetname : make the trigger_teleporter point to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
*/


void() misc_teleporter_dest =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = null_string;
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
	{
		bprint("q3 - misc_teleporter_dest missing name! please repair the map...\n");
		self.targetname = ftos(floor(random() * 65535));
	}

};

// altarbetas teleporter for some reason - works in q3

void() target_teleporter =
{
	misc_teleporter_dest();
};

// some q3 triggers may be like this ??

void() misc_teleporter =
{
	trigger_teleport();
	if (world.wad == "q2.wad")
	{
		chaos_spawn(0, 0, 0, 0,  self.origin, v0, v0, v0, v0, null_string, null_string, SUB_Null, 1, q2_teleport_particles, SUB_Null, self, world);
		ambientsound (self.origin + '0 0 32', "q2_snd/telehum.wav", 1, ATTN_STATIC);
	}
};

// fn(q3_play_sound) - play a sound for target_speaker, repeating or by activator
// fn(q3_sound_think) - periodic repeating sound for target speaker

//float Q3_LOOPON				= 1;
//float Q3_LOOPOFF				= 2;
//float Q3_GLOBAL				= 4;
//float Q3_ACTIVATOR			= 8;

void() q3_play_sound =
{
	sound (self, CHAN_AUTO, self.noise, self.volume, self.aflag);
};

void() q3_sound_think =
{
	q3_play_sound();
	self.nextthink = time + self.wait + self.delay * crandom();
};

/*		q3 ---
	QUAKED target_speaker (0 .7 .7) (-8 -8 -8) (8 8 8) LOOPED_ON LOOPED_OFF GLOBAL ACTIVATOR
Sound generating entity that plays .wav files. Normal non-looping sounds play each time the target_speaker is triggered. Looping sounds can be set to play by themselves (no activating trigger) or be toggled on/off by a trigger.
-------- KEYS --------
noise : path/name of .wav file to play (eg. sound/world/growl1.wav - see Notes).
wait : delay in rels between each time the sound is played ("random" key must be set - see Notes).
random : random time variance in rels added or subtracted from "wait" delay ("wait" key must be set - see Notes).
targetname : the activating button or trigger points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- SPAWNFLAGS --------
LOOPED_ON : sound will loop and initially start on in level (will toggle on/off when triggered).
LOOPED_OFF : sound will loop and initially start off in level (will toggle on/off when triggered).
GLOBAL : sound will play full volume throughout the level.
ACTIVATOR : sound will play only for the player that activated the target.
-------- NOTES --------
The path portion value of the "noise" key can be replaced by the implicit folder character "*" for triggered sounds that belong to a particular player model. For example, if you want to create a "bottomless pit" in which the player screams and dies when he falls into, you would place a trigger_multiple over the floor of the pit and target a target_speaker with it. Then, you would set the "noise" key to "*falling1.wav". The * character means the current player model's sound folder. So if your current player model is Visor, * = sound/player/visor, if your current player model is Sarge, * = sound/player/sarge, etc. This cool feature provides an excellent way to create "player-specific" triggered sounds in your levels.

The combination of the "wait" and "random" keys can be used to play non-looping sounds without requiring an activating trigger but both keys must be used together. The value of the "random" key is used to calculate a minimum and a maximum delay. The final time delay will be a random value anywhere between the minimum and maximum values: (min delay = wait - random) (max delay = wait + random).
*/
void() target_speaker =
{
	if (time < 2) precache_sound (self.noise);

	self.aflag = ATTN_NORM;
	if (self.spawnflags & 4) self.aflag = ATTN_NONE; // Q3_GLOBAL

	if (!self.volume) self.volume = 1;

	self.use = q3_play_sound;

	if (self.flags & 1) // Q3_LOOPON - translated to q1 ambient - note: can not be turned off
	{
		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER); // FIX - want this for loopoff - problem is we need the sound length
//		remove(self);
	}
//	else if (self.flags & Q3_LOOPOFF) // finish this
//	{
//		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER);
//	}
	else if (self.wait)
	{
		self.think = q3_sound_think;
		self.nextthink = time + self.wait + self.delay * crandom();
	}
};

// fn(q3trap_shooter_target) - finds target for q3 trap shooter if it has one, otherwise returns preset .movedir

vector() q3trap_shooter_target =
{
	local entity t;

// no target string
	if (self.target == null_string) return (self.movedir);

	t = find (world, targetname, self.target);
// target ent not found
	if (!t) return (self.movedir);
// found and targeted
	return (t.origin - self.origin);
};

// fn(q3_spikeshooter_use) - implement q3 shooters setup below

void() q3_spikeshooter_use =
{
	if (self.noise3 == null_string) self.noise3 = "weapons/spike2.wav";
	if (self.mdl == null_string) self.mdl = "progs/spike.mdl";
	if (self.delay < 100) self.delay = 500;

	sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	launch_spike (self.origin, q3trap_shooter_target());
	newmis.velocity = self.movedir * self.delay;
	setmodel (newmis, self.mdl);

	if (self.classname == "shooter_grenade")
	{
		newmis.classname = "grenade";
		newmis.movetype = MOVETYPE_BOUNCE;
		newmis.touch = GrenadeTouch;
		newmis.nextthink = time + 2.5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_rocket")
	{
		newmis.classname = "rocket";
		newmis.touch = T_MissileTouch;
		newmis.nextthink = time + 5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_plasma")
	{
		newmis.classname = "plasma";
		newmis.touch = spike_touch;
		newmis.nextthink = time + 5;
		newmis.think = SUB_Remove;
	}
	else
#ifdef enhanced
		{
			setmodel (newmis,"progs/s_spike.mdl");					// superspike_tch replace code
			setsize (newmis, v0, v0);
			newmis.touch = spike_touch;
			newmis.dmg = 18;
		}
#else
		newmis.touch = superspike_touch;
#endifdef
	
};

// fn(q3trap_shooter) - implement any of the q3 shooter traps

void() spikeshooter_use;

void() q3trap_shooter =
{
	SetMovedir ();
	self.use = q3_spikeshooter_use;

	precache_model ("progs/spike.mdl");
	precache_sound ("weapons/spike2.wav"); // defaults to a nail shooter trap if its buf'd up
};

/*		q3 ---
	QUAKED shooter_grenade (1 0 .5) (-8 -8 -8) (8 8 8)
This will shoot a grenade each time it's triggered. Aiming is done by setting the "angles" key or by targeting an info_notnull or target_position entity.
-------- KEYS --------
angles: this sets the pitch and yaw aiming angles of shooter (default 0 0). The roll angle does not apply.
targetname : activating trigger points to this.
target : this points to a target_position entity for aiming the grenades.
random : random aiming variance in degrees from the straight line to the targeted entity (default 0 - see Notes).
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
When the random key is set, its value is used to calculate a maximum angle deviation from the normal trajectory formed by a straight line between the shooter and the aiming entity it targets. The final trajectory will be a random value anywhere between no deviation at all (0) to maximum deviation (value of the random key).

Both the setting "angles" key or "targeting a target_position" methods can be used to aim the shooter. However, the target_position method is simpler.*/

// IMP: q3 sounds | models, implement target

void() shooter_grenade =
{
	precache_model ("progs/grenade.mdl");
	precache_sound ("weapons/grenade.wav");
	precache_sound ("weapons/bounce.wav");
	q3trap_shooter();
	self.mdl = "progs/grenade.mdl";
	self.noise2 = "weapons/bounce.wav";
	self.noise3 = "weapons/grenade.wav";
	self.delay = 400;
};

/*QUAKED shooter_plasma (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_plasma =
{
	precache_model ("progs/d_plasma_sht.mdl"); // IMP: q3 plasma model
	precache_sound ("q3_snd/hyprbf1a.wav");
	precache_sound ("q3_snd/plasmx1a.wav");
	q3trap_shooter();
	self.mdl = "progs/d_plasma_sht.mdl";
	self.noise2 = "q3_snd/plasmx1a.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.delay = 800;
};

/*QUAKED shooter_rocket (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_rocket =
{
	precache_model ("progs/missile.mdl");
	precache_sound ("weapons/sgun1.wav");
	q3trap_shooter();
	self.mdl = "progs/missile.mdl";
	self.noise3 = "weapons/sgun1.wav";
	self.delay = 1000;
};

