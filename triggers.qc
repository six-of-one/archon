/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: triggers.qc
 *
 * date: Fri Apr  4 04:31:45 UTC 2008
 *
 * final qc
 *
 */

// pk stuff moved in the adaptive code
float SOUND_GOT	 ;
string normalsound;
string reversesound;

//entity stemp, otemp, s, old;


void () trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

float SPAWNFLAG_NOMESSAGE	 = 1;
float SPAWNFLAG_NOTOUCH	 = 1;

// the wait time has passed, so set back up for another activation
void () multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void () multi_trigger =
{
	if (self.nextthink > time)
	{
		return;		// already been triggered
	}

	if (!m_score_rel1)
	if (self.target1 == "score_rel1")
		return;

	if (!m_score_rel2)
	if (self.target1 == "score_rel2")
		return;

	if (m_score_rel1)
	if (self.target1 == "!score_rel1")
		return;

	if (m_score_rel2)
	if (self.target1 == "!score_rel2")
		return;

	if (deathmatch)
	if (self.cnt > 0)
	{
		if (ply_count < self.cnt)
		if (self.target1 == "player_count")
			return;

		if (ply_count >= self.cnt)
		if (self.target1 == "!player_count")
			return;
	}

	if (self.classname == "trigger_secret")
	{
	if (self.enemy.classname != "pk*bot")
	if (self.enemy.classname != "player")
		return ;
		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL,SVC_FOUNDSECRET);
	}

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;

	if (activator.classname == "pk*bot")
		bot_triggered (activator);
	SUB_UseTargets ();

	if (self.wait > 0)
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void () multi_killed =
{
	self.enemy = damage_attacker;
	self.solid = SOLID_NOT; // stop blocking when dead - Cataboligne - 11.6.12 - CHECK: find out if this borks any existing maps
	multi_trigger ();
};

void () multi_use =
{
	self.enemy = activator;
	multi_trigger ();
};

void () multi_touch =
{
	if (other.classname != "pk*bot")
	if (other.classname != "player")
		return ;

	if (other.classname == "pk*bot")
	{
		self.enemy = other;
		bot_touched ();
		multi_trigger ();
		return ;
	}
// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}

	self.enemy = other;
	multi_trigger ();
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void () trigger_multiple =
{
// Cataboligne - 4.21.11 - triggerss not in mod maps
	if (notmod(self)) return;

	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}

	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	self.th_weight = triggerweight; // *bot
	self.istrigger = 1;
	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_NOTOUCH))
		{
			self.touch = multi_touch;
		}
	}
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void () trigger_once =
{
// Cataboligne - 4.21.11 - triggerss not in mod maps
	if (notmod(self)) return;

	self.wait = -1;
	trigger_multiple ();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void () trigger_relay =
{
// Cataboligne - 4.21.11 - triggerss not in mod maps
	if (notmod(self)) return;

	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void () trigger_secret =
{
	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = 1;

	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	trigger_multiple ();
};

//=============================================================================


void () counter_use =
{
//	local string junk;

	self.count = self.count - 1;
	if (self.count < 0)
		return ;

	if (self.count != 0)
	{
		if (activator.classname == "player"
		&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= 4)
				centerprint (activator, "There are more to go...");
			else if (self.count == 3)
				centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint (activator, "Only 2 more to go...");
			else
				centerprint (activator, "Only 1 more to go...");
		}
		return;
	}

	if (activator.classname == "player"
	&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		centerprint (activator,"Sequence completed!");
	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void () trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};


/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/

float PLAYER_ONLY	 = 1;
float T_SILENT	 = 2;
float T_RANDOM = 4;
float T_STEALTH = 8;
//float NONDIR = 16; // Note: zerstorer used this for something - ref: dd
float T_NODEATH = 32;
float ALT_TARGET = 64;
//float NOVEL = 128; // dont add velocity - archon moves especially

void () play_teleport =
{
	local	float v;
	local	string tmpstr;

	v = random() * 5;
	if (v < 1)
		tmpstr = "misc/r_tele1.wav";
	else if (v < 2)
		tmpstr = "misc/r_tele2.wav";
	else if (v < 3)
		tmpstr = "misc/r_tele3.wav";
	else if (v < 4)
		tmpstr = "misc/r_tele4.wav";
	else
		tmpstr = "misc/r_tele5.wav";

	if (PK || (world.wad == "q2.wad")) // NOTE:
	{
	if (!SOUND_GOT)
		get_teleport_sounds();
	else
		SOUND_GOT = FALSE;	// So we get new sounds the next time
	tmpstr = normalsound;
	}
	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
	telesnd = world;
};

void (vector org) spawn_tfog =
{
	local entity s;
	telesnd = s = spawn (); // Cataboligne - 9.3.11 - let holdable kill this sound.
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	signalnoise (other,s); // *bot
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_TELEPORT);
	WriteCoord (MSG_BROADCAST,org_x);
	WriteCoord (MSG_BROADCAST,org_y);
	WriteCoord (MSG_BROADCAST,org_z);
};


void () tdeath_touch =
{
	if (other == self.owner)
		return ;

	if (other.admin)
	if (other.admin != LIVE_ADMIN)
	if (other.admin != USER_MENU) // Cataboligned - 5.4.10 - dont let admin be telefragged either
	{
		local entity e;

		if (other.aiment) return;
		other.aiment = e = spawn ();  // and get them out of here
		e.owner = self;
		e.think = phone_teleport;
		e.nextthink = (time + 0.5);
		return;
	}

// frag anyone who teleports in on top of an invincible player
	if ((other.classname == "player") || (other.classname == "pk*bot"))
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";
		if (self.owner.classname != "pk*bot")
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			if (self.owner.health)
			T_Damage (self.owner,self,self,50000);
			return ;
		}
	}
	if (other.classname == OBSERVER)
	{
//		other.takedamage = DAMAGE_NO;
		return;
	}
	if (other.classname == "beartrap") // *pk - dont telefrag beartraps
		return;

	if (other.health)
	{
		T_Damage (other,self,self,50000);
	}
};


void (vector org, entity death_owner) spawn_tdeath =
{
	local entity death;

	newmis = death = spawn ();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death,org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;

	force_retouch = 2;		// make sure even still objects get hit

	if (other.admin)
	if (other.admin != LIVE_ADMIN)
	if (other.admin != USER_MENU) // dont let admin telefrag anyone
		death.touch = tfragadmin_touch;

// cam fix
	if (other) other.cam_x = other.cam_x | CAM_TELE;
};

void () teleport_touch =
{
	local entity t,e;
	local vector org;
	local string targ;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "pk*bot")
		if (other.classname != "player")
			return ;
	}

	if (self.aflag != -6) // archon forced teleport, but only once
// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return ;

	SUB_UseTargets ();

// put a tfog where the player was
	if (!(self.spawnflags & T_STEALTH))
	{
		if (PK || (world.wad == "q2.wad")) spawn_tfog2(other.origin, null_string); // *pk - new teleport sounds
		else
		spawn_tfog (other.origin);
	}

	if (self.classname == "chaos_teleport") // chaos teleport sets movetarget - Cataboligne 1.23.8
	{
		if (self.aflag == -6)
		{
			other = self.enemy; // forced - must have correct target
			self.touch = SUB_Null;
		}
		t = self.movetarget;
		if (random() < self.aflag) self.movetarget = find_tdest(FL_RSALL, null_string);
		if (!t) return;
	}
	else
	{
		targ = self.target;

		if (self.spawnflags & ALT_TARGET) // Cataboligne - 11.2.12 - alternate target teleport, for the Castle
		{
			e = find (world,targetname,self.path);
			if (e)
			{
				if (self.group == "origin")
				if (e.origin == v0) targ = self.target1;
			}
		}

		t = find (world,targetname,targ);
		if (!t)
		{
			if (WARNING) bprint("\n*** warning:\nTeleporter target not found!\n");
			return;
		}
	}

	if (PK) ClearSpawnPoint(t);
// spawn a tfog flash in front of the destination
	if (self.classname == "chaos_teleport" && t.classname != "info_teleport_destination") // - Cataboligne 1.23.8 - because chaos going to non tdest has no mangle
		makevectors (other.angles);
	else
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	if (self.classname == "chaos_teleport") // chaos teleport attemp to avoid fallen into void - Cataboligne 9.23.13
	{
		org_z = org_z + other.mins_z;
		gsf = 250;
		while ((pointcontents(org) == CONTENT_SOLID) && gsf > 0)
		{
			org_z = org_z + 2;
			gsf = gsf - 1;
		}
	}

	if (!(self.spawnflags & T_STEALTH))
		spawn_tfog (org);

	if (!(self.spawnflags & T_NODEATH))
		spawn_tdeath (t.origin,other);

	if (other.enemy.classname == "pk*bot")
	{
		enemy_touched ();
	}

// non living object
	if (!other.health)
	{
		other.origin = t.origin;
		if (!(self.spawnflags & 128))
			other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

// move the player and lock him down for a little while
	setorigin (other,t.origin);

	if (! self.spawnflags & 16) other.angles = t.mangle; // Cataboligne - 10.31.12 - non directional landing - keep current facing, great with stealth - NONDIR = 16
	if (other.movetarget.movetarget)
	{
		addTarget (other.movetarget.movetarget,self);
		other.movetarget.movetarget = self;
	}
	if (other.classname == "pk*bot")
	{
		bot_touched ();
	}
	if ((other.classname == "player") || (other.classname == "pk*bot") || (other.classname == OBSERVER))
	{
		if (! self.spawnflags & 16) // NONDIR = 16
			other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		other.bt_immune_time = time + BT_BUFFER; // *pk - beartrap - Note: ssnn issue here
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		if (!(self.spawnflags & 128))
			other.velocity = v_forward * 300; // Note: ssnn issue here - causes "jump"
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void () info_teleport_destination =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = null_string;
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
		objerror ("no targetname");
};

void () teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY T_SILENT T_RANDOM T_STEALTH NONDIR T_NODEATH
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.

Flags:
"player_only"		 		only players will teleport
"silent"				 		silences teleporting - still has flash & tele sound
"random" (Zerstorer)		sent to a random desination (info_teleport_random).  Must set
"count"						flag to number of  info_teleport_random in map.
"stealth" (Zerstorer)  	eliminates the particle flash and noise when an entity is teleported (still has hum)
"nondir" (chaos)			dont change direction, works well with stealth
"nodeath"					dont spawn a tele death - no telefrag (this could have issues!)

to make a teleport give the appearance of contiguous map space in 2 different areas use:
silent, stealth, nondir, nodeath
going both ways
*/

void () trigger_teleport =
{
	local vector o;

// Cataboligne - 4.21.11 - triggers not appearing in mod maps
	if (notmod(self)) return;

	InitTrigger ();
	self.touch = teleport_touch;
	// find the destination
	if (!self.target)
	{
		if (WARNING) bprint("Teleporter - no target -- removed\n");
		remove(self);
		return;
	}
	self.use = teleport_use;

	if (!(self.spawnflags & T_SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o,"ambience/hum1.wav",0.5,ATTN_STATIC);
	}
};

/*
==============================================================================

trigger_setskill

==============================================================================
*/

void () trigger_skill_touch =
{
	if (other.classname != "player")
		return ;

	cvar_set ("skill",self.message);
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void () trigger_setskill =
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void () trigger_onlyregistered_touch =
{
		if (other.classname != "pk*bot")
		if (other.classname != "player")
			return ;
	if (self.attack_finished > time)
		return ;

	self.attack_finished = time + 2;
	if (cvar ("registered"))
	{
		self.message = null_string;
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != null_string)
		{
			centerprint (other,self.message);
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void () trigger_onlyregistered =
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
	self.istrigger = 1;
	self.th_weight = triggerweight; // *bot
};

//============================================================================

void () hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void () hurt_touch =
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		if (self.deathtype) other.deathtype = self.deathtype; // Cataboligne - 10.19.12 - obit message special
		if (self.deathtype == "lavadead")  // Cataboligne - 10.28.12 - handle lava beings when trigger damage is lava
			T_FireDamage (other,self,self,self.dmg);
		else
		T_Damage (other,self,self,self.dmg);
		self.think = hurt_on;
		self.nextthink = time + 1;
	}

	return ;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void () trigger_hurt =
{
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

//============================================================================

float PUSH_ONCE	 = 1;

void () trigger_push_touch =
{
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
		else
		{
			if (other.classname == "pk*bot")
			{
				if ((self.movedir_x < 0.1) && (self.movedir_y < 0.1))
				{
					other.velocity_x = ((other.velocity_x + (80 * random ())) - 40);
					other.velocity_y = ((other.velocity_y + (80 * random ())) - 40);
				}
				if (other.fly_sound < time)
				{
					other.fly_sound = (time + 1.5);
					sound (other,CHAN_AUTO,"ambience/windfly.wav",TRUE,ATTN_NORM);
				}
			}
		}
		if (other.enemy.classname == "pk*bot")
		{
			enemy_touched ();
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void () q100_trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	self.istrigger = 1;
	self.th_weight = trigpushweight; // *bot
	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void () trigger_monsterjump_touch =
{
	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return ;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;

	if (!(other.flags & FL_ONGROUND))
		return ;

	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
*/
void () trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

