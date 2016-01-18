/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: combat.qc
 *
 * date: Fri Apr  4 04:31:43 UTC 2008
 *
 * final qc
 *
 */

void () T_MissileTouch;
void () info_player_start;
void(entity targ, entity attacker) ClientObituary;

void () monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float (entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};


/*
============
Killed
============
*/

// fn(Killed) - a living thing has been killed, handles things, schedules viewing, calls morturary, collects insurance, fixes probate, etc...


void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

	if (self.class_select == "class_player")
	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

//MED
	if (self.charmed)
	{
		self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

	if (self.event == "dyn_monster") monster_rnd_cnt = monster_rnd_cnt - 1;
	if (monster_rnd_cnt < 0) monster_rnd_cnt = 0;

	if (! self.flags & (FL_CLIENT | FL_MONSTER)) // because some elements of chaos mod mk I used movetype none

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return ;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL,SVC_KILLEDMONSTER);
	}

	if (self.classname == "pk*bot" || attacker.classname == "pk*bot") 
		bot_kill(self, attacker); // *bot - tie in to count bot kills / deaths
	else
	if (!Q_100) PK_ClientObituary(self, damage_inflictor, attacker);
	else
	ClientObituary(self, attacker);

	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	if (self.vwepent) vw_chain(self); // re chain any vweps before death - which can throw weps

	monster_death_use ();

	if (self.th_die != (void()) 0) // something got thru with 0 th_die on server test 10.28.11
	self.th_die ();

	if (self.vwepent) viswep_ld(self, -2); // still have visweps

	if (self.class_select == "class_player") // Cataboligne 9.19.11 - monsters were calling - just never saw because werent using dp cam
		dead_cam_set(); // Cataboligne 9.11.3 purify - chase cam

	self = oself;
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage =
{
	local vector dir;
	local entity oldself;
	local float save, pwr_save, r;
	local float take;

	if (!targ.takedamage)
		return;

   if (discharged && targ.wetsuit_finished && (targ.items & IT_SUIT)) // lightning underwater & wearing suit
      return;

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (!( (RUNES > 1) && ( (attacker.rune_flag & RUNE_FLG_DM) || (attacker.rune_flag & TECH_AMP) ) ) || ( RUNE_QUAD_COMB || !ENHANCED ) ) // rune overpowers quad on higher rule sets 
	if (attacker.super_damage_finished > time)
	if (attacker.pkplus_actortype != PKPLUS_ACTORQUAD) // pk art code here
		damage = damage * 4;  // IMP: doom berserk even more special - 4x only for fists

	r = cvar("sv_c_rune");
	if (attacker.rune_flag & RUNE_FLG_DM) // dmg rune - idea: could do more under rules > 2
	{
		if (r > 1)
		if (targ == attacker) return; // lith rules

		damage = damage * 2;

		if (attacker.rune_flag & TECH_AMP) // combind with dmg tech!
		if (RUNE_TECH_DMG_COMB || !ENHANCED)
			damage = damage * 2;
	}
	else
	if (attacker.rune_flag & TECH_AMP) // dmg tech
		damage = damage * 2;

//MED
//check for empathy shields
	if ((targ.empathy_finished) && !(inflictor.empathy_finished) && (targ != attacker))
	{
		empathy_dmg = 1;
		damage = damage/2;
		T_Damage (attacker,targ,targ,damage); // ha - back damage
		empathy_dmg = 0;
	}

// save damage based on the target's armor level

	// PAINKEEP_START Ignore armor stuff, used for drowning
	if (Q_100 || !ignorearmor)
	{
		pwr_save = power_armor(targ, inflictor, damage); // calc damage taken by power armor

		if (pwr_save < damage)
		save = ceil(targ.armortype * (damage - pwr_save));

		if (save >= targ.armorvalue)
			save = targ.armorvalue;
	}
	else
	{
		save = 0;
	}

	take = ceil(damage - save - pwr_save);

	if ( (targ.rune_flag & RUNE_FLG_RS) || (targ.rune_flag & TECH_DSH) ) // idea: resist should do more under rules > 2, but not tech
	{
		take = floor(take / 2);
		save = floor(save / 2);
		if (( RUNE_TECH_RS_COMB || !ENHANCED ) && (targ.rune_flag & RUNE_FLG_RS) && (targ.rune_flag & TECH_DSH))
		{
			take = floor(take / 2);
			save = floor(save / 2);			
		}
		if (targ.invincible_sound < time)
		{
			if ( (self.rune_flag & TECH_DSH) && !(self.rune_flag & RUNE_FLG_RS) )
				sound (self, CHAN_BODY, tech_dsh_sound, 1, ATTN_NORM);
			else
				sound (targ, CHAN_ITEM, rune_resist_sound, 1, ATTN_NORM);
			targ.invincible_sound = time + 2;
		}
	}

	targ.armorvalue = ceil(targ.armorvalue - save);

	if (targ.armorvalue < 1)
	{
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if ((inflictor != world) && (targ.movetype == MOVETYPE_WALK || targ.classname == "pk*bot"))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize (dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return ;
	if (targ.invincible_finished >= time)
	{
		if (targ.invincible_sound < time) // Cataboligne - 10.1.11 - the targ was self
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			targ.invincible_sound = time + 2;
		}
		if (targ.pkplus_actortype != PKPLUS_ACTORPENT) // pk art code here
		return ;
	}


//MED
   if (targ.empathy_finished)
	{
      if (targ.empathy_sound < time) // Cataboligne - 10.1.11 - the targ was self
		{
         sound (targ, CHAN_ITEM, "hipitems/empathy2.wav", 1, ATTN_NORM);
         targ.empathy_sound = time + 0.5;
		}
	}

// team play damage avoidance
	if ((teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team))
		return ;

// we have a suck head
   if (attacker.rune_flag & RUNE_VAMPIRE) // a bit of vampire action
   if (!targ.empathy_finished)
   if ((!targ.rune_flag & RUNE_VAMPIRE) || ! ENHANCED)
   if ((!targ.rune_flag & RUNE_FLG_RG) || ! ENHANCED) // regen immune to feeders
   if ((!targ.rune_flag & TECH_ADOC) || ! ENHANCED)
   if (targ.flags & (FL_CLIENT | FL_MONSTER)) // only these get vamped for now - excludes all doors, triggers, crates, etc
	{
		if (! ENHANCED && (r > 1)) // lith code
		{
			if (attacker.health < (attacker.max_health * attacker.health_modifier * 2))
			{
	local float f;
				f = take; // vdamage = damage;
				r = ceil(targ.health - take); // targ->health
				if(r < -40) f = f - (-40 - r); //if(targ->health < -40) vdamage -= -40 - targ->health;

				r = rint(f + 0.5); // add = (int)((float)vdamage * rune_vampire->value + 0.5);
				if (r > 0)
				{
					attacker.health = attacker.health + r; // if(add > 0) { attacker->health += add;

					if (attacker.health > (attacker.max_health * attacker.health_modifier * 2)) // if(attacker->health > rune_vampiremax->value) attacker->health = rune_vampiremax->value;
						attacker.health = attacker.max_health * attacker.health_modifier * 2; // 200 for a human
				}
			}
		}
		else
		if (targ.health < take) attacker.health = attacker.health + RUNE_VAMPIRE_PER * targ.health; // only get RUNE_VAMPIRE_PER% of actual damage, excludes armor & other saves
		else attacker.health = attacker.health + RUNE_VAMPIRE_PER * take;
	}

// *** do the damage
	targ.health = ceil(targ.health - take);

	ax_dmg = take; // Cataboligne - 10.11.11 - bot endless axe war preventative deal

	if (!Q_100) pk_setDamageSkin(targ); // *pk damage skin support

// crate being busted open - hear it now
	if (targ.netname == "Crate")
	if ((targ.aflag < time) || (targ.health <= 0))
	{
		targ.aflag = time + 1; // NOTE: does anything else use player .aflag?
		r = random();
		if (targ.health <= 0)
			sound (targ, CHAN_AUTO, CRATE_OPENED, 1, ATTN_NORM);
		else if (r < 0.33)
			sound (targ, CHAN_AUTO, CRATE_OPEN1, 1, ATTN_NORM);
		else if (r < 0.66)
			sound (targ, CHAN_AUTO, CRATE_OPEN2, 1, ATTN_NORM);
		else //if (r < 0.3)
			sound (targ, CHAN_AUTO, CRATE_OPEN3, 1, ATTN_NORM);		
	}

	if (targ.health <= 0)
	{
		damage_inflictor = inflictor; // *pk used by the player gib functions to calculate the direction of the gib to go in.
		Killed (targ, attacker);
		damage_inflictor = world; // *pk used by the player gib functions
		return ;
	}

// react to the damage
	oldself = self;
	self = targ;
	if (self.classname == "pk*bot")
	{
		if (attacker != world && inflictor != world)
		{
// xreaper code - looks good
			if ((attacker != self) && !coop)
			{
				if (self.enemy)
				{
					secondEnemy (attacker);
				}
				else
				{
					self.enemy = attacker;
					BotFoundTarget ();
				}
			}
		}
	}
	else
	{

		if ((self.flags & FL_MONSTER) && attacker != world)
		{
	// get mad unless of the same class (except for soldiers)
			if (self != attacker && attacker != self.enemy && (self.charmer != attacker))
			{
				if ( (self.classname != attacker.classname)
				|| (self.classname == "monster_army" ) || (self.classname == "monster_armagon" )  )
				{
					if (self.enemy.classname == "player")
						self.oldenemy = self.enemy;
					self.enemy = attacker;
					FoundTarget ();
				}
			}
		}
	}

	if (self.pkplus_actortype != PKPLUS_ACTORPENT || random() < 0.1) // pk art code here - fake it for pent acting most of the time
	if (self.th_pain)
	{
		self.th_pain (attacker,take);
	// nightmare mode monsters don't go into pain frames often
		if (skill == 3)
			self.pain_finished = time + 5;
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void (entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local float points;
	local entity head;
	local vector org;

	head = findradius(inflictor.origin, damage+40);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			if (head.wad != "q1" || PK_100 || Q_100) // dont damage hidden replacement stuff 2.21.11 -i.e. barrels!
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head,inflictor))
					{	// shambler takes half damage from all explosions
//						if (head.classname == "monster_shambler")
							T_Damage (head, inflictor, attacker, points * BlastProof(head)); //0.5);
//						else
//							T_Damage (head,inflictor,attacker,points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_BeamDamage
============
*/
void (entity attacker, float damage) T_BeamDamage =
{
	local float points;
	local entity head;

	head = findradius(attacker.origin, damage+40);

	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head,attacker))
				{
					if (head.classname == "monster_shambler" || head.morphy == IMP_MSHAMBLR)
						T_Damage (head, attacker, attacker, points*0.5);
					else
						T_Damage (head,attacker,attacker,points);
				}
			}
		}
		head = head.chain;
	}
};

