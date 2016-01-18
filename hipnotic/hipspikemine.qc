/* ::-::
 *
 * Cataboligne
 *
 * file: hipspikemine.qc
 *
 * date: 11/20/13
 *
 * qc - support hipnotic stuff - spike mine traps
 *
 */

// 4 mine sizes

$frame spike1 spike2 spike3 spike4 spike5 spike6 spike7 spike8 spike9

$frame minspike1 minspike2 minspike3 minspike4 minspike5 minspike6 minspike7 minspike8 minspike9

$frame microspike1 microspike2 microspike3 microspike4 microspike5 microspike6 microspike7 microspike8 microspike9

$frame lgspike1 lgspike2 lgspike3 lgspike4 lgspike5 lgspike6 lgspike7 lgspike8 lgspike9

// skins = std (ball stitched), cracked rock, orange (hl), red rock, black, aa lava, pk lava, hellaport, blue


// IDEA: vorerel can make spike mines - so can chaos

void() spikemine_Home =
   {
   local entity head;
   local entity selected;
   local float cur_dist;
   local float head_dist;
   local vector dir;

   self.frame = self.frame + 1;
   if (self.frame==9) self.frame = 0;
   self.nextthink = time + 0.2;
   self.think = spikemine_Home;

// look in our immediate vicinity

   if (self.search_time < time)
      {
      selected = world;
      cur_dist = 2000;
      head = findradius(self.origin, 2000);
      while(head)
         {
         if(!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
            {
            if (visible(head) && (head.health > 0))
               {
               head_dist = vlen(head.origin-self.origin);
               if (head_dist < cur_dist)
                  {
                  selected = head;
                  cur_dist = head_dist;
                  }
               }
            }
         head = head.chain;
         }
//      if (selected != world && selected != self.enemy)
      if (selected != world)
         sound (self, CHAN_VOICE, "hipitems/spikmine.wav", 1, ATTN_NORM);
      self.enemy = selected;
      self.search_time = time + 1.3;
      }
   if (self.enemy == world)
      {
      sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
      self.velocity = '0 0 0';
      return;
      }
   self.dest = self.enemy.origin + '0 0 10';
	dir = normalize(self.dest - self.origin);
   if (infront(self.enemy, 0, v0, v0))
      {
      self.velocity = dir * ((skill*50) + 50);
      }
   else
      {
      self.velocity = dir * ((skill*50) + 150);
      }
   };

// mod: use self.dmg, so random mines can have var damage

void() spikemine_Touch =
{
	if (self.health>0)
      {
      if (other.classname == "trap_spike_mine")
         return;
      if (other.classname == "missile")
         return;
      if (other.classname == "grenade")
         return;
      if (other.classname == "hiplaser")
         return;
      if (other.classname == "proximity_grenade")
         return;

      T_Damage(self,self,self,self.health+10);
//      killed_monsters = killed_monsters + 1;
//      WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
      }
//   self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.dmg) self.dmg = 110;

   T_RadiusDamage (self, self, self.dmg, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

   sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
   self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

/*
spike_mine_first_think
*/

void() spike_mine_first_think =
   {
   self.think = spikemine_Home;
   self.nextthink = time + 0.1;
   self.search_time = 0;
   self.takedamage = DAMAGE_AIM;
	self.use = monster_use;
   };

/*QUAKED trap_spike_mine (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void(float ign) trap_spike_mine =
{
if (ign != A_MONSTER)
{
	if (M_MONSTER < 0)
	{
		self.think = remove_monster;
		self.nextthink = time + 2 + (random() * REMOVE_MON_SPREAD);
		return;
	}
	
	if (!M_MONSTER_II & CB_M_SPIKEMINE)
	if (deathmatch)
	{
		if (R_MONSTER)
			remove(self);
		return;
	}

   precache_model ("progs/spikmine.mdl");
   precache_sound ("weapons/r_exp3.wav");
   precache_sound ("hipitems/spikmine.wav");
   precache_sound ("misc/null.wav");
}
   setmodel (self, "progs/spikmine.mdl");

   setsize (self, self.mins, self.maxs);
   self.classname = "trap_spike_mine";
   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_FLYMISSILE;
//   setsize (self, '0 0 0', '0 0 0');
//   self.avelocity = '-100 100 -100';
   self.avelocity = '-50 100 150';
   if (cvar("skill") <= 1)
      self.health = 200;
   else
      self.health = 400;
   self.frame = 0;
   self.think = spike_mine_first_think;
   self.touch = spikemine_Touch;
   self.th_die = spikemine_Touch;
   self.th_stand = spikemine_Home;
   self.th_walk = spikemine_Home;
   self.th_run = spikemine_Home;
   self.th_melee = spikemine_Home;
   self.th_missile = spikemine_Home;
   self.nextthink = time + 0.2;
   total_monsters = total_monsters + 1;
   self.flags = self.flags | FL_MONSTER;
//   self.deathtype = "was blasted by a spike mine";

	self.class_select = "class_monster";
};

