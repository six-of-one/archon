/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: tomb.qc
 *
 * date: Wed Aug 12 05:11:44 UTC 2009
 *
 * 
 *
 */

void () corpsefollow;
void () corpse_drag1 =  [ 56, corpse_drag2  ] { 	corpsefollow (); };
void () corpse_drag2 =  [ 57, corpse_drag3  ] { };
void () corpse_drag3 =  [ 58, corpse_drag4  ] { 	corpsefollow (); };
void () corpse_drag4 =  [ 59, corpse_drag5  ] { };
void () corpse_drag5 =  [ 60, corpse_drag6  ] { 	corpsefollow (); };
void () corpse_drag6 =  [ 93, corpse_drag7  ] { };
void () corpse_drag7 =  [ 92, corpse_drag8  ] { 	corpsefollow (); };
void () corpse_drag8 =  [ 91, corpse_drag9  ] { };
void () corpse_drag9 =  [ 90, corpse_drag10 ] { 	corpsefollow (); };
void () corpse_drag10 = [ 91, corpse_drag11 ] { };
void () corpse_drag11 = [ 92, corpse_drag12 ] { 	corpsefollow (); };
void () corpse_drag12 = [ 93, corpse_drag13 ] { };
void () corpse_drag13 = [ 84, corpse_drag14 ] { 	corpsefollow (); };
void () corpse_drag14 = [ 83, corpse_drag15 ] { };
void () corpse_drag15 = [ 82, corpse_drag16 ] { 	corpsefollow (); };
void () corpse_drag16 = [ 81, corpse_drag17 ] { };
void () corpse_drag17 = [ 80, corpse_drag18 ] { 	corpsefollow (); };
void () corpse_drag18 = [ 79, corpse_drag19 ] { };
void () corpse_drag19 = [ 80, corpse_drag20 ] { 	corpsefollow (); };
void () corpse_drag20 = [ 81, corpse_drag21 ] { };
void () corpse_drag21 = [ 82, corpse_drag22 ] { 	corpsefollow (); };
void () corpse_drag22 = [ 83, corpse_drag23 ] { };
void () corpse_drag23 = [ 84, corpse_drag24 ] { 	corpsefollow (); };
void () corpse_drag24 = [ 93, corpse_drag25 ] { };
void () corpse_drag25 = [ 60, corpse_drag26 ] { 	corpsefollow (); };
void () corpse_drag26 = [ 59, corpse_drag27 ] { };
void () corpse_drag27 = [ 58, corpse_drag28 ] { 	corpsefollow (); };
void () corpse_drag28 = [ 57, corpse_drag1  ] { };

void () tombdie =
{
	sound (self,CHAN_AUTO,"tomb/tombdie.wav",1,ATTN_NORM);
	self.tomb_touchable.nextthink = (time + 0.1);
	self.tomb_touchable.think = SUB_Remove;
	self.skin = 1;
	self.nextthink = ((time + 1) + (random () * 2));
	self.think = SUB_Remove;
	self.tomb_touchable.nextthink = (time + 0.1);
	self.tomb_touchable.think = SUB_Remove;
};

void () corpsedie =
{
	sound (self,CHAN_VOICE,"zombie/z_gib.wav",1,ATTN_NORM);
	ThrowHead ("progs/h_zombie.mdl",self.health);
	ThrowGib ("progs/gib1.mdl",self.health);
	ThrowGib ("progs/gib2.mdl",self.health);
	ThrowGib ("progs/gib3.mdl",self.health);
	remove (self);
};

void () corpsefollow =
{
	local float quiktemp;
	local vector backdir;
	if ( ((!self.tomb_target.tomb_time || self.disconnectPlayer) || self.tomb_target.deadflag) )
	{
		remove (self);
		return ;
	}
	if ( (self.oldorigin != self.tomb_target.origin) )
	{
		self.oldorigin = self.tomb_target.origin;
		makevectors (self.tomb_target.v_angle);
		backdir = v_forward;
		quiktemp = vlen (backdir);
		if ( (quiktemp != 0) )
		{
			backdir = ((-40 * backdir) * (1 / quiktemp));
		}
		setorigin (self,(self.tomb_target.origin + backdir));
		self.dodmg = 1;
	}
	if ( (self.angles != (self.tomb_target.angles + '0 0 0')) )
	{
		self.angles = (self.tomb_target.angles + '0 0 0');
		self.dodmg = 1;
	}
	if (self.tomb_target.class_select == "class_bot") // Cataboligne - 10.3.11 - just for stationary bots
	if (random() < 0.3)
		self.dodmg = 1;
		
	self.tomb_time = (self.tomb_time + 0.1);
	self.tombdmg_time = (self.tombdmg_time + 0.1);
	if ( (self.tombsoundtime < time) )
	{
		self.tombsoundtime = (time + 4);
		if ( ((self.tomb_time + 4) <= PKPLUS_TOMB_TIMETOFOLLOW) )
		{
			sound (self,CHAN_VOICE,"tomb/heart.wav",1,ATTN_NORM);
		}
	}
	if ( (self.tombdmg_time >= 1) )
	{
		if ( self.dodmg )
		{
			T_Damage (self.tomb_target,self,self.owner,PKPLUS_TOMB_DMG);
			self.dodmg = 0;
		}
		self.tombdmg_time = 0;
	}
	quiktemp = self.tomb_target.velocity_z;
	self.tomb_target.velocity = normalize ((self.tomb_target.velocity * 0.750));
	self.tomb_target.velocity_z = quiktemp;
	if ( (self.tomb_time > PKPLUS_TOMB_TIMETOFOLLOW) )
	{
		self.think = corpsedie;
	}
};

void () tombtouch =
{
	local entity holdowner;

/*
	if (!deathmatch) // Cataboligne - 5.20.10 - tomb single player code - allow monster target
	{
//		if (other.classname == "player" && cvar("sv_sp_bt_noplayer")) return;
//		else 
		if (other.classname != "player" && ! other.flags & FL_MONSTER) return;
	}
	else
*/
	if (other.classname != "player" && other.classname != "pk*bot")
#ifdef enhanced
	if (! other.flags & FL_MONSTER)
	  return;

	if (other.charmer && other.charmer == self.owner.owner) // dont target owners helpers
#endifdef
		return ;

	if ( ((other == self.owner.owner) && (self.tomb_time > time)) )
		return ;

	if ( (other.tomb_immune_time > time) )
		return ;

	
#ifdef enhanced
//	if (ENHANCED)
	if (other.mask_x & CB_ZOMBY || other.model == "progs/zombie.mdl")
	{
		if (self.enemy != other)
		if (other.flags & FL_CLIENT)
		if (other.class_select == "class_player")
		{
			if (random() < 0.5)
				sprint(other, "Stop for a visit, why not stay for a while?...\n");
			else
				sprint(other, "There is an old friend down there...\n");
			self.enemy = other;
		}
		return ;
	}
#endifdef
	holdowner = self.owner;
	self.owner = holdowner.owner;
	sound (self,CHAN_AUTO,"tomb/tombopen.wav",1,ATTN_NORM);
	if (self.class_select)
		setmodel (self,self.class_select);
	else
		setmodel (self,"progs/player.mdl");
	self.classname = "corpse";
	self.skin = 4;
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_TRIGGER;
	self.oldorigin = self.origin;
	other.tomb_time = 1;
	self.tomb_target = other;
	self.tomb_time = 0;
	self.takedamage = 1;
	self.health = 225;
	self.th_die = corpsedie;
	self.tombdmg_time = 0;
	self.tombsoundtime = (time - 1);
	self.think = corpse_drag1;
	self.nextthink = (time + 0.1);
	self.touch = SUB_Null;
	holdowner.think = SUB_Remove;
	holdowner.nextthink = (time + 0.1);
};

void () touchtomb_think =
{
	self.angles = self.owner.angles;
	self.v_angle = self.owner.v_angle;
	setorigin (self,self.owner.origin);
	self.nextthink = (time + 0.2);
};

void () tomb_think =
{
	if ( self.tomb_death_time && (self.tomb_death_time < time) )
	{
		self.think = tombdie;
		self.nextthink = (time + 0.1);
	}
	else
	{
		self.skin = (self.skin + 1);
		if ( (self.skin >= 12) )
		{
			self.skin = 0;
		}
		self.nextthink = (time + 0.4);
	}
	if ( (self.tomb_touchable.classname == "corpse") )
	{
		self.think = SUB_Remove;
		self.nextthink = (time + 0.1);
	}
};

void () tomb_checkonground =
{
	if ( (self.flags & FL_ONGROUND) )
	{
		setorigin (self,(self.origin + '0 0 1'));
		self.flags = (self.flags - 512);
		sound (self,CHAN_AUTO,"tomb/tombdrop.wav",1,ATTN_NORM);
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		self.think = tomb_think;
	}
	self.nextthink = (time + 0.2);
};

void () tomb_launch =
{
	local entity tomb;
	if ( (self.pkplus_tombammo <= 0) )
	{
		return ;
	}
	if ( !self.button0 )
	{
		player_run ();
		return ;
	}

	if (!PK_TOMB_SET)
	{
		PK_TOMB_SET = TRUE;
// defs
		PKPLUS_TOMB_TIME = 90;

		if (DARKPLACES || chaos)
		{
			PKPLUS_TOMB_TIME = cvar("pk_tomb_time");
			if (PKPLUS_TOMB_TIME < 0) PKPLUS_TOMB_TIME = 90;
		}
	}
		

	tomb = spawn ();
	tomb.owner = self;
	tomb.movetype = MOVETYPE_TOSS;
	tomb.solid = SOLID_BBOX;
	tomb.classname = "tomb";
	tomb.takedamage = DAMAGE_AIM;
	tomb.health = 350;
	tomb.th_die = tombdie;
	tomb.netname = "Tomb";
	tomb.pk_currentitem = PKPLUS_IT_TOMB;
	tomb.weapon = IT_AXE;
	setmodel (tomb,"progs/tomb2.mdl");
	setsize (tomb,'-16 -16 0','16 16 44');
	tomb.skin = 1;
	setorigin (tomb,self.origin);
	makevectors (self.angles);
	tomb.velocity = ((v_forward * (100 + (random () * 50))) + (v_up * (150 + (random () * 75))));
	tomb.angles = self.angles;
	tomb.angles_z = 0;
	tomb.v_angle = self.v_angle;
	tomb.v_angle_z = 0;
	if (PKPLUS_TOMB_TIME)
		tomb.tomb_death_time = (time + PKPLUS_TOMB_TIME);
	tomb.think = tomb_checkonground;
	tomb.nextthink = (time + 0.5);
	AddToSplash (tomb);
	tomb.tomb_touchable = spawn ();
	tomb.tomb_touchable.owner = tomb;
	tomb.tomb_touchable.movetype = MOVETYPE_TOSS;
	tomb.tomb_touchable.solid = SOLID_TRIGGER;
	tomb.tomb_touchable.classname = "touchtomb";
	setsize (tomb.tomb_touchable,'-18 -18 -6','18 18 46');
	tomb.tomb_touchable.angles = tomb.angles;
	tomb.tomb_touchable.v_angle = tomb.v_angle;
	setorigin (tomb.tomb_touchable,tomb.origin);
	tomb.tomb_touchable.touch = tombtouch;
	tomb.tomb_touchable.tomb_time = (time + 2);
	tomb.tomb_touchable.think = touchtomb_think;
	tomb.tomb_touchable.nextthink = (time + 0.2);
};

