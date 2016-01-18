/* ::-::
 *
 * Cataboligne
 *
 * file: proxmine.qc
 *
 * date: 2/15/11
 *
 * qc - support hipnotic
 *
 */
 
/*
		+---------------------------------------+
		|  proximity mine code                | SEC-HEAD
		+---------------------------------------+
*/

float NumProximityGrenades;

void() proximity_precache =
{
	precache_model ("progs/proxbomb.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/v_prox.mdl");
	precache_model ("progs/vw_gren.mdl");

	precache_sound ("weapons/prox/proxbomb.wav");
	precache_sound ("weapons/prox/proxwarn.wav");
};

// fn(ProximityExplode) - blow up the proxmine - this is grenadeexplode with a diff. radius dmg
// hipnotic code - modified for variable radius dmg
// IDEA: increase radius based on # of mines exploding in a given area
// .dmg - variable damage

void() ProximityExplode =
{
	if (self.dmg < 1) self.dmg = 95;

// CHECK: what explode fn does
//	Explode(0, self.dmg, world, TE_EXPLOSION, 0.02 + random() * 0.02, BecomeExplosion);
	T_RadiusDamage (self, self.owner, self.dmg, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

// fn(ProximityGrenadeExplode) - start detonation sequence, used for th_die fn also
// hipnotic code

void() ProximityGrenadeExplode =
{
	self.dmg = 95;
	self.takedamage = DAMAGE_NO;
	NumProximityGrenades = NumProximityGrenades - 1;
	self.deathtype = "exploding";
	self.nextthink = time + 0.1;
//	self.owner = self.lastvictim; CHECK - do we need this, answer may be in demo code
//	self._stand = 
	self.think = ProximityExplode;
	if (pointcontents(self.origin) == CONTENT_LAVA) self.nextthink = time;
};


// fn (ProximityGrenadeTouch) - check whatever a proxmine hits for poss. detonation
// hipnotic code - modified

void() ProximityGrenadeTouch =
{

   if (other == self)
      return;
   if (other.classname == self.classname) //dont blow on touching another mine
      return;
	if (sky_touch("", v0, self))
	{
		SUB_Remove();
		return;
	}
//   self.movetype = MOVETYPE_TOSS;
   if (self.state == 1)
      return;
   if (vlen(other.velocity) > 0)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   if (other.takedamage == DAMAGE_AIM)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound
   self.movetype = MOVETYPE_NONE;
   setsize (self, '-8 -8 -8', '8 8 8');
   self.state = 1;  // armed
   self.enemy = other;
};

// fn(ProximityBom) - main think fn, timer fuse detonate, proximity detonate, too many detonate.
// hipnotic code - modified

void() ProximityBomb =
{
   local entity   head;
   local float    blowup;

   if ((time > self.delay) || (NumProximityGrenades > PROX_MAX) || (vlen(self.enemy.velocity)>0) )
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   self.owner = world;
   self.takedamage = DAMAGE_YES;
   head = findradius(self.origin, 140);
   blowup = 0;

   while (head)
      {
      if ((head != self) && (head.health > 0) && (head.flags & (FL_CLIENT|FL_MONSTER)) && (head.classname!=self.classname))
         blowup = 1;
      if ((head.classname == self.classname) && (head.state==0) && vlen(self.origin - head.origin) < 20)
         blowup = 1;
      traceline(self.origin,head.origin,TRUE,self);
      if (trace_fraction != 1.0)
         blowup = 0;
      if (blowup==1)
         {
         sound (self, CHAN_WEAPON, self.target, 1, ATTN_NORM);
         ProximityGrenadeExplode();
         self.nextthink = time + 0.5;
         return;
         }
      head = head.chain;
      }
   self.nextthink = time + 0.25;
};

// fn(W_Fire_Proxmine) - fire proximity mines

void() W_Fire_Proxmine =
{
	local vector org;

	org = self.origin + v_up * 16 + v_forward * 4; // scourge tail shot, chaos, no eweap def
	if (EWEAP) org = self.origin + v_up * VWZ_PROXMINE+ v_forward * VWX_PROXMINE + v_right * VWY_PROXMINE;
	NumProximityGrenades = NumProximityGrenades + 1;

	fire_missile(GRENADE_VEL, MOVETYPE_TOSS, FL_GRN | FL_USEAMMO | FL_PUNCH , RM_SKY | PF_LAVA, org, ' 0 0 0', "proximity_grenade", "progs/proxbomb.mdl", self.eweapon.noise3, ProximityGrenadeTouch, 2.0, ProximityBomb, ProximityGrenadeExplode);

// prox specific stuff
//	newmis.mode_x = IV_PROX; // for det
	if (EWEAP) newmis.target = EWEAP.target;
	else newmis.target = "weapons/prox/proxwarn.wav";
	newmis.firecontrol = EXPLOSIVE;
	newmis.takedamage = DAMAGE_NO;
	newmis.health = 5;
	newmis.state = 0;
	newmis.avelocity = ' 100 600 100';
	newmis.delay = time + PROX_TIMER + (PROX_TIMER*random());  // time fuse - orig = time + 15 + (10*random());
	setsize (newmis, '-1 -1 -1', ' 1 1 1');

};
