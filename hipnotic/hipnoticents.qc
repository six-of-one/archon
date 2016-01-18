/* ::-::
 *
 * Cataboligne
 *
 * file: hipnoticents.qc
 *
 * date: 2/13/11
 *
 * qc - support hipnotic stuff,
 *
 */

/*
all map spawn func - from hipnotic sources

flag.qc:						qed		 item_deathball (.3 .3 1) (0 0 0) (32 32 32)
hip_brk.qc:				qed		 trigger_damagethreshold (0 .5 .8) ? MULTI_USE INVISIBLE
hip_brk.qc:				qed		 func_breakawaywall (0 .5 .8) ?
hip_expl.qc:				qed		 func_exploder (0.4 0 0) (0 0 0) (8 8 8) particles
hip_expl.qc:				qed		 func_multi_exploder (0.4 0 0) ?
hip_part.qc:				qed		 func_particlefield (0 .5 .8) ? USE_COUNT
hip_part.qc:				qed		 func_togglewall (0 .5 .8) ? START_OFF
hip_push.qc:				qed		 func_pushable (0 .5 .8) ?
hiparma.qc:				qed		 monster_armagon (1 0 0) (-32 -32 -24) (32 32 64) Ambush
hipclock.qc:				qed		 func_clock (0 0 0.5) (0 0 0) (32 32 32)
hipcount.qc:				qed		 func_counter (0 0 0.5) (0 0 0) (32 32 32) TOGGLE LOOP STEP RESET RANDOM FINISHCOUNT START_ON
hipcount.qc:				qed		 func_oncount (0 0 0.5) (0 0 0) (16 16 16)
hipdecoy.qc:				qed		 monster_decoy (1 0 0) (-16 -16 -24) (16 16 40)
hipgrem.qc:				qed		 monster_gremlin (1 0 0) (-32 -32 -24) (32 32 64) Ambush
hipholes.qc:				qed		 wallsprite (0 1 0) (-8 -8 -8) (8 8 8)
hipitems.qc:				qed		 item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
hipitems.qc:				qed		 item_hornofconjuring (0 .5 .8) (-16 -16 0) (16 16 32)
hipitems.qc:				qed		 item_artifact_empathy_shields (0 .5 .8) (-16 -16 0) (16 16 32)
hipitems.qc:				qed		 weapon_mjolnir (0 .5 .8) (-16 -16 0) (16 16 32)
hipitems.qc:				qed		 weapon_laser_gun (0 .5 .8) (-16 -16 0) (16 16 32)
hipitems.qc:				qed		 weapon_proximity_gun (0 .5 .8) (-16 -16 0) (16 16 32)
hipitems.qc:				qed		 trap_spike_mine (0 .5 .8) (-16 -16 0) (16 16 32)
hipitems.qc:				qed		 trap_lightning_triggered (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
hipitems.qc:				qed		 trap_lightning (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
hipitems.qc:				qed		 trap_lightning_switched (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
hipitems.qc:				qed		 trap_tesla_coil (0 .5 .8) (-8 -8 -8) (8 8 8) targetenemies
hipitems.qc:				qed		 trap_gods_wrath (0 .5 .8) (-8 -8 -8) (8 8 8) targetenemies
hipitems.qc:				qed		 trap_gravity_well (.8 .5 0) (-8 -8 -8) (8 8 8) targetenemies UNDERWATER
hipmisc.qc:				qed		 play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
hipmisc.qc:				qed		 play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
hipmisc.qc:				qed		 random_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 random_thunder_triggered (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) toggle
hipmisc.qc:				qed		 ambient_humming (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 ambient_rushing (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 ambient_running_water (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 ambient_fan_blowing (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 ambient_waterfall (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 ambient_riftpower (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 info_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hipmisc.qc:				qed		 effect_teleport (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
hipmisc.qc:				qed		 path_camera (0.5 0.3 0) (-8 -8 -8) (8 8 8)
hipmisc.qc:				qed		 effect_finale (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) useplayer nodecoy
hipmisc.qc:				qed		 info_startendtext (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
hipquake.qc:			qed		 func_earthquake (0 0 0.5) (0 0 0) (32 32 32)
hiprot.qc:					qed		 info_rotate (0 0.5 0) (-4 -4 -4) (4 4 4)
hiprot.qc:					qed		 func_rotate_entity (0 .5 .8) (-8 -8 -8) (8 8 8) TOGGLE START_ON
hiprot.qc:					qed		 path_rotate (0.5 0.3 0) (-8 -8 -8) (8 8 8) ROTATION ANGLES STOP NO_ROTATE DAMAGE MOVETIME SET_DAMAGE
hiprot.qc:					qed		 func_rotate_train (0 .5 .8) (-8 -8 -8) (8 8 8)
hiprot.qc:					qed		 func_movewall (0 .5 .8) ? VISIBLE TOUCH NONBLOCKING
hiprot.qc:					qed		 rotate_object (0 .5 .8) ?
hiprot.qc:					qed		 func_rotate_door (0 .5 .8) (-8 -8 -8) (8 8 8) STAYOPEN
hiprubbl.qc:				qed		 func_rubble (0.4 0.4 0.2) (0 0 0) (32 32 32)
hiprubbl.qc:				qed		 func_rubble1 (0.4 0.4 0.2) (0 0 0) (8 8 8)
hiprubbl.qc:				qed		 func_rubble2 (0.4 0.4 0.2) (0 0 0) (16 16 16)
hiprubbl.qc:				qed		 func_rubble3 (0.4 0.4 0.2) (0 0 0) (32 32 32)
hipscrge.qc:				qed		 monster_scourge (1 0 0) (-16 -16 -24) (16 16 40) Ambush
hipspawn.qc:			qed		 func_spawn (0 .5 .8) (-32 -32 -24) (32 32 64) big/ambush megahealth
hipspawn.qc:			qed		 func_spawn_small (0 .5 .8) (-16 -16 -24) (16 16 40) big/ambush megahealth
hiptrain.qc:				qed		 func_train2 (0 .5 .8) ?
hiptrig.qc:					qed		 trigger_usekey (0 .5 0) ? USE_GOLD_KEY
hiptrig.qc:					qed		 trigger_remove (.5 .5 .5) ? ignoremonsters ignoreplayers
hiptrig.qc:					qed		 trigger_setgravity (.5 .5 .5) ?
hiptrig.qc:					qed		 trigger_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
hiptrig.qc:					qed		 trigger_decoy_use (.5 .5 .5) ?
hiptrig.qc:					qed		 trigger_waterfall (.2 .5 .2) ?
hipwater.qc:				qed		 func_bobbingwater (0 .5 .8) ?

*/

// hip values

float HIP_DEF_LASER			= 30;
float HIP_DEF_MJOLNIR			= 30;
float HIP_DEF_GRENADE			= 6;

float HIP_MAX_CELLS			= 200;
float HIP_MAX_GRENADES		= 50; // may not match hp100

float LASERCAN_VEL		= 1000;

void() hip_precache =
{
// weps
	hammer_precache();
	lasercannon_precache();
	proximity_precache();

	precache_model ("progs/g_rock.mdl");
// view models
	precache_model ("progs/v_prox.mdl");
// viswep
	precache_model ("progs/vw_gren.mdl");
// ammo


// horn
// emp shield
// wet suit
   precache_sound ("items/suit2.wav");

	precache_model ("progs/g_lasercannon.mdl");
	precache_model ("progs/g_mjolnir.mdl");
	precache_model ("progs/empathy.mdl");
	precache_model ("progs/horn.mdl");
	precache_model ("progs/proxbomb.mdl");
	precache_model ("progs/wetsuit.mdl");
	precache_model ("progs/v_prox.mdl");
	precache_model ("progs/v_lasercannon.mdl");
	precache_model ("progs/v_mjolnir.mdl");
	precache_model ("progs/vw_mjolnir.mdl");
	precache_model ("progs/vw_lasercannon.mdl");
	precache_model ("progs/laser_m.mdl");
	precache_model ("progs/rubble_m.mdl");

	precache_sound ("sound/hipitems/wetsuit.wav");
	precache_sound ("sound/hipitems/weton.wav");
	precache_sound ("sound/hipitems/empathy.wav");
	precache_sound ("sound/hipitems/empathy2.wav");
	precache_sound ("sound/hipitems/horn.wav");
	precache_sound ("sound/hipitems/spikmine.wav");
	precache_sound ("sound/weapons/lasercannon/laserg.wav");
	precache_sound ("sound/weapons/lasercannon/laserric.wav");
	precache_sound ("sound/weapons/prox/proxwarn.wav");
	precache_sound ("sound/weapons/prox/proxbomb.wav");
	precache_sound ("sound/weapons/thors_hammer/mjolhit.wav");
	precache_sound ("sound/weapons/thors_hammer/mjolslap.wav");
	precache_sound ("sound/weapons/thors_hammer/mjoltap.wav");
	precache_sound ("sound/weapons/thors_hammer/mjoltink.wav");
	precache_sound ("sound/weapons/thors_hammer/mjolwam.wav");

// stains
	precache_model ("progs/s_rlspg.spr");
	precache_model ("progs/s_plspg.spr");
	precache_model ("progs/s_plspg2.spr");

};


/*
hip wep inventory slots

slot		weapon
1				blaster *
2				shotgun *
3				doublebarrel
4				machine gun
5				chain gun
6				grenade launcher / hand grenades / railgun #
7				rocket launcher
8				bfg / hyperblaster #

* = touch fn will replace other slot 1 & 2 weps with these
# = items are currently exclusive in touch - you can only get one

*/


/*QUAKED weapon_mjolnir (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_mjolnir =
{
   self.netname = "Thor's Hammer"; // "Mjolnir";

// fn
	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mjolnir1;

// stats
	self.currentammo = HIP_DEF_MJOLNIR;
	self.items = IT_MJOLNIR;
	self.lip = AMMO_CELLS;
	self.volume = HIP_MAX_CELLS;
	self.attack_finished = 0.4;
	self.dmg = 50; // melee hit
	self.dodmg = 30; // lightning strike per beam - note: 80 val in fire code, use factor 2.6667
//	if (!deathmatch) self.dodmg = 50; // - HP100
	self.dmg_save = 15;
	self.dmg_take = 4; // shot cnt - beams
	self.style = FL_MELEE_WEP;
	self.wait = RSP_TIME;
// ?
	self.weapon = IT_MJOLNIR;
	
// appearances
   setmodel (self, "progs/g_mjolnir.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.weaponmodel = "progs/v_mjolnir.mdl";
	self.vwepmdl = "progs/vw_mjolnir.mdl";

//	self.noise = "*/w_pkup.wav";
//	self.noise4 = "*/respawn1.wav";
	self.noise2 = "weapons/thors_hammer/mjolslap.wav";
	self.noise3 = "weapons/thors_hammer/mjolhit.wav";
	self.target = "weapons/thors_hammer/mjoltink.wav";

	if (self.class_select == "") self.class_select = "hip_item";
	StartItem ();
};

void() weapon_laser_gun =
{
   self.netname = "Laser Cannon";

// fn
	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_laser1;

// stats
	self.currentammo = HIP_DEF_LASER;
	self.items = IT_SUPER_NAILGUN;
	self.lip = AMMO_CELLS;
	self.volume = HIP_MAX_CELLS;
	self.attack_finished = 0.1;
	self.dmg = 18;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	self.lefty = 5; // laser flight time - override by LASER_FLY
	self.wait = RSP_TIME;
	self.vv_draw = vw_range_base;
	
// appearances
   setmodel (self, "progs/g_lasercannon.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.weaponmodel = "progs/v_lasercannon.mdl";
	self.vwepmdl = "progs/vw_lasercannon.mdl";

//	self.noise2 = "weapons/lasercannon/.wav";
	self.noise3 = "weapons/lasercannon/laserg.wav";
	self.target = "weapons/lasercannon/laserric.wav";

	if (self.class_select == "") self.class_select = "hip_item";
	StartItem ();
};


// TDO: place holders - codes need finished

void() weapon_proximity_gun =
{
   self.netname = "Proximity Gun";

// fn
	self.touch = x_weapon_touch;
	self._attack = W_Fire_Proxmine;
	self._fr_attack = player_rocket1;

// stats
	self.currentammo = HIP_DEF_GRENADE;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.volume = HIP_MAX_GRENADES;
	self.attack_finished = 0.6;
	self.dmg = 95;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt
	self.wait = RSP_TIME;
	
// appearances
   setmodel (self, "progs/g_rock.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.weaponmodel = "progs/v_prox.mdl";
	self.vwepmdl = "progs/vw_gren.mdl";
	self.skin = 1; // g_ & vw_

//	self.noise2 = "weapons/lasercannon/.wav";
	self.noise3 = "weapons/prox/proxbomb.wav";
	self.target = "weapons/prox/proxwarn.wav";

	if (self.class_select == "") self.class_select = "hip_item";
	StartItem ();
};

/*
void() horn_touch =
{
	local	float amount;
   local float value;

	if (other.classname != "player")
		return;

   if (deathmatch)
	{
		self.mdl = self.model;

      self.nextthink = time + 60;

		self.think = SUB_regen;
	}

	self.solid = SOLID_NOT;
	self.model = string_null;
   sprint (other, "You got the Horn of Conjuring\n");
   sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	stuffcmd (other, "bf\n");
   activator = other;
   horn_active = 1;
   horn_charmer = other;
	SUB_UseTargets();				// fire all targets / killtargets
   horn_active = 0;
};
*/

/*QUAKED item_hornofconjuring (0 .5 .8) (-16 -16 0) (16 16 32)
Horn of Conjuring.
You must make func_spawn entities connected to this entity
to spawn the charmed creature.
*/
void() item_hornofconjuring =
{
   self.netname = "Horn of Conjuring";
	self.wait = RSP_TIME;

   setmodel(self, "progs/horn.mdl");
   setsize (self, '-16 -16 0', '16 16 32');
   self.noise = "hipitems/horn.wav";

	if (self.class_select == "") self.class_select = "hip_item";
	StartItem ();
};


/*
void() hip_powerup_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;

      self.nextthink = time + 60;

		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
   other.items2 = other.items2 | self.items2;
	self.model = string_null;

// do the apropriate action
   if ( self.classname == "item_artifact_wetsuit" )
	{
		other.wetsuit_time = 1;
		other.wetsuit_finished = time + 30;
	}
   if ( self.classname == "item_artifact_empathy_shields" )
	{
      other.empathy_time = 1;
      other.empathy_finished = time + 30;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};
*/

/*QUAKED item_artifact_empathy_shields (0 .5 .8) (-16 -16 0) (16 16 32)
Empathy Shield.
*/
void() item_artifact_empathy_shields =
{
   self.netname = "Empathy Shields";
	self.wait = RSP_TIME;

   setmodel(self, "progs/empathy.mdl");
   setsize (self, '-16 -16 0', '16 16 32');
   self.noise = "hipitems/empathy.wav";

	if (self.class_select == "") self.class_select = "hip_item";
	StartItem ();
};

/*QUAKED item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from electrical attacks and swims faster for 30 seconds
*/
void() item_artifact_wetsuit =
{
	self.netname = "Wetsuit";
	self.wait = RSP_TIME;

   setmodel (self, "progs/wetsuit.mdl");
   setsize (self, '-16 -16 -24', '16 16 32');
   self.noise = "misc/weton.wav";

	if (self.class_select == "") self.class_select = "hip_item";
	StartItem ();
};

/*
void() hip_item_ =
{
	q100_item_health();
	setmodel(self, "progs/q2_heal_stimpak.mdl");
	self.noise = "q2_snd/s_health.wav";
	self.noise4 = "q2_snd/respawn1.wav"; // doom respawn sound
	self.netname = "Stimpack";
	self.healamount = Q2_DEF_HBOTTLE;
	self.healtype = HEAL_BOT;
	self.volume = -1; // max add
	self.wait = RSP_TIME;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "hip_item";
};

void() hip_item_a =
{
	item_armorInv();
	setmodel (self, "progs/q2_armorbody.mdl");
	self.noise = "q2_snd/ar3_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Body armor";
	self.volume = 200; // max add
	self.style = Q2_ARM_TBDY;
	self.items = IT_ARMOR3;
	self.currentammo = Q2_ARM_BODY; // 100 units
	self.wait = RSP_TIME * 0.666;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "hip_item";
};

*/


//=========================
//
// SUB_CopyEntity
//
//=========================

void (entity srcent, entity destent) SUB_CopyEntity =
{
	destent.modelindex=srcent.modelindex;
	destent.absmin=srcent.absmin;
	destent.absmax=srcent.absmax;
	destent.ltime=srcent.ltime;
	destent.movetype=srcent.movetype;
	destent.solid=srcent.solid;
	destent.origin=srcent.origin;
	destent.oldorigin=srcent.oldorigin;
	destent.velocity=srcent.velocity;
	destent.angles=srcent.angles;
	destent.avelocity=srcent.avelocity;
	destent.punchangle=srcent.punchangle;
	destent.classname=srcent.classname;
	destent.model=srcent.model;
	destent.frame=srcent.frame;
	destent.skin=srcent.skin;
	destent.effects=srcent.effects;
	destent.mins=srcent.mins;
	destent.maxs=srcent.maxs;
	destent.size=srcent.size;
	destent.touch=srcent.touch;
	destent.use=srcent.use;
	destent.think=srcent.think;
	destent.blocked=srcent.blocked;
	destent.nextthink=srcent.nextthink;
	destent.groundentity=srcent.groundentity;
	destent.health=srcent.health;
	destent.frags=srcent.frags;
	destent.weapon=srcent.weapon;
	destent.weaponmodel=srcent.weaponmodel;
	destent.weaponframe=srcent.weaponframe;
	destent.currentammo=srcent.currentammo;
	destent.ammo_shells=srcent.ammo_shells;
	destent.ammo_nails=srcent.ammo_nails;
	destent.ammo_rockets=srcent.ammo_rockets;
	destent.ammo_cells=srcent.ammo_cells;
	destent.items=srcent.items;
	destent.takedamage=srcent.takedamage;
	destent.chain=srcent.chain;
	destent.deadflag=srcent.deadflag;
	destent.view_ofs=srcent.view_ofs;
	destent.button0=srcent.button0;
	destent.button1=srcent.button1;
	destent.button2=srcent.button2;
	destent.impulse=srcent.impulse;
	destent.fixangle=srcent.fixangle;
	destent.v_angle=srcent.v_angle;
	destent.idealpitch=srcent.idealpitch;
	destent.netname=srcent.netname;
	destent.enemy=srcent.enemy;
	destent.flags=srcent.flags;
	destent.colormap=srcent.colormap;
	destent.team=srcent.team;
	destent.max_health=srcent.max_health;
	destent.teleport_time=srcent.teleport_time;
	destent.armortype=srcent.armortype;
	destent.armorvalue=srcent.armorvalue;
	destent.waterlevel=srcent.waterlevel;
	destent.watertype=srcent.watertype;
	destent.ideal_yaw=srcent.ideal_yaw;
	destent.yaw_speed=srcent.yaw_speed;
	destent.aiment=srcent.aiment;
	destent.goalentity=srcent.goalentity;
	destent.spawnflags=srcent.spawnflags;
	destent.target=srcent.target;
	destent.targetname=srcent.targetname;
	destent.dmg_take=srcent.dmg_take;
	destent.dmg_save=srcent.dmg_save;
	destent.dmg_inflictor=srcent.dmg_inflictor;
	destent.owner=srcent.owner;
	destent.movedir=srcent.movedir;
	destent.message=srcent.message;
	destent.sounds=srcent.sounds;
	destent.noise=srcent.noise;
	destent.noise1=srcent.noise1;
	destent.noise2=srcent.noise2;
	destent.noise3=srcent.noise3;
	destent.wad=srcent.wad;
	destent.map=srcent.map;
	destent.worldtype=srcent.worldtype;
	destent.killtarget=srcent.killtarget;
	destent.light_lev=srcent.light_lev;
	destent.style=srcent.style;
	destent.th_stand=srcent.th_stand;
	destent.th_walk=srcent.th_walk;
	destent.th_run=srcent.th_run;
	destent.th_missile=srcent.th_missile;
	destent.th_melee=srcent.th_melee;
	destent.th_pain=srcent.th_pain;
	destent.th_die=srcent.th_die;
//	destent.th_turn=srcent.th_turn;
	destent.oldenemy=srcent.oldenemy;
	destent.speed=srcent.speed;
	destent.lefty=srcent.lefty;
	destent.search_time=srcent.search_time;
	destent.attack_state=srcent.attack_state;
	destent.walkframe=srcent.walkframe;
	destent.attack_finished=srcent.attack_finished;
	destent.pain_finished=srcent.pain_finished;
	destent.invincible_finished=srcent.invincible_finished;
	destent.invisible_finished=srcent.invisible_finished;
	destent.super_damage_finished=srcent.super_damage_finished;
	destent.radsuit_finished=srcent.radsuit_finished;
	destent.invincible_time=srcent.invincible_time;
	destent.invincible_sound=srcent.invincible_sound;
	destent.invisible_time=srcent.invisible_time;
	destent.invisible_sound=srcent.invisible_sound;
	destent.super_time=srcent.super_time;
	destent.super_sound=srcent.super_sound;
	destent.rad_time=srcent.rad_time;
	destent.fly_sound=srcent.fly_sound;
	destent.axhitme=srcent.axhitme;
	destent.show_hostile=srcent.show_hostile;
	destent.jump_flag=srcent.jump_flag;
	destent.content_flag=srcent.content_flag;
	destent.air_finished=srcent.air_finished;
	destent.bubble_count=srcent.bubble_count;
	destent.deathtype=srcent.deathtype;
	destent.mdl=srcent.mdl;
	destent.mangle=srcent.mangle;
	destent.oldorigin=srcent.oldorigin;
	destent.t_length=srcent.t_length;
	destent.t_width=srcent.t_width;
	destent.dest=srcent.dest;
	destent.dest1=srcent.dest1;
	destent.dest2=srcent.dest2;
	destent.wait=srcent.wait;
	destent.delay=srcent.delay;
	destent.trigger_field=srcent.trigger_field;
	destent.noise4=srcent.noise4;
	destent.pausetime=srcent.pausetime;
	destent.movetarget=srcent.movetarget;
	destent.aflag=srcent.aflag;
	destent.dmg=srcent.dmg;
	destent.cnt=srcent.cnt;
	destent.think1=srcent.think1;
	destent.finaldest=srcent.finaldest;
	destent.finalangle=srcent.finalangle;
	destent.count=srcent.count;
	destent.lip=srcent.lip;
	destent.state=srcent.state;
	destent.pos1=srcent.pos1;
	destent.pos2=srcent.pos2;
	destent.height=srcent.height;
	destent.waitmin=srcent.waitmin;
	destent.waitmax=srcent.waitmax;
	destent.distance=srcent.distance;
	destent.volume=srcent.volume;
	destent.gorging=srcent.gorging;
	destent.stoleweapon=srcent.stoleweapon;
//	destent.spawnfunction=srcent.spawnfunction;
//	destent.spawnthink=srcent.spawnthink;
//	destent.spawnmodel=srcent.spawnmodel;
//	destent.spawnsolidtype=srcent.spawnsolidtype;
//	destent.spawnmins=srcent.spawnmins;
//	destent.spawnmaxs=srcent.spawnmaxs;
//	destent.spawnclassname=srcent.spawnclassname;
};