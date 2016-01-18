/* ::-::
 *
 * Cataboligne
 *
 * file: hammer.qc
 *
 * date: 2/13/11
 *
 * qc - support hipnotic
 *
 */
 
/*
		+---------------------------------------+
		|  thor's hammer code                   | SEC-HEAD
		+---------------------------------------+
*/

void() hammer_precache =
{
	precache_model ("progs/g_hammer.mdl");
	precache_model ("progs/v_hammer.mdl");
	precache_model ("progs/vw_mjolnir.mdl");

	precache_sound ("thors_hammer/mjolhit.wav");	// mjolnir
	precache_sound ("thors_hammer/mjolslap.wav");	// mjolnir
	precache_sound ("thors_hammer/mjoltink.wav");	// mjolnir
	precache_sound ("thors_hammer/mjoltap.wav");	// morphs
};


/*
=================
HIP_HammerDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage =
{
	local entity		e1, e2;
	local vector		f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished && (trace_ent.items & IT_SUIT) )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
//		T_LightningDamage(TRUE, trace_ent, from, from, damage); // chaos mod code
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage && !trace_ent.wetsuit_finished && (trace_ent.items & IT_SUIT) )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
//		T_LightningDamage(TRUE, trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage && !trace_ent.wetsuit_finished && (trace_ent.items & IT_SUIT) )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
//		T_LightningDamage(TRUE, trace_ent, from, from, damage);
	}
};

/*
void() HIP_DiversionLightningThink =
	{
	local vector	org,end;

	if (time > self.delay)
		{
		remove(self);
		return;
		}

	makevectors(self.v_angle);
	org = self.origin;
	end = org + v_forward*200;
//	end = end + (((200*random()) - 100) * v_up);
	end = end + (((400*random()) - 200) * v_right);

	traceline (org, end, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	self.nextthink = time + 0.1;
	};
*/

//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void() HIP_LightningThink =
{
	local vector org, end, dst, vec;
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local float dot;
	local float oldstate;
	local float dam;


	if (time > self.delay)
		{
		if (self.enemy != world)
			self.enemy.struck_by_mjolnir = 0;
		remove(self);
		return;
		}
	oldstate = self.state;
	if (self.state==0)
		{
		// look in our immediate vicinity
		self.enemy = world;
		selected = world;
		cur_dist = self.distance;
		head = findradius(self.owner.origin, self.distance);
		while(head)
			{
			if(!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT))) // CHECK: pk*bot no cli flg deal?
				{
				if ((visible(head)) && (head!=self.owner.owner) && (head.health>0))
					{
					head_dist = vlen(head.origin - self.lastvictim.origin);
					if ((head_dist<cur_dist) && (head.struck_by_mjolnir==0))
						{
						selected = head;
						cur_dist = head_dist;
						}
					}
				}
			head = head.chain;
			}
		if (selected != world)
			{
			self.state = 1;
			self.enemy = selected;
			self.enemy.struck_by_mjolnir = 1;
			}
		else
			{
			makevectors(self.v_angle);
			org = self.owner.origin;
			end = org + v_forward*200;
			end = end + (((400*random()) - 200) * v_right);

			traceline (org, end, TRUE, self);

			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity (MSG_BROADCAST, self);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
			WriteCoord (MSG_BROADCAST, trace_endpos_x);
			WriteCoord (MSG_BROADCAST, trace_endpos_y);
			WriteCoord (MSG_BROADCAST, trace_endpos_z);

			self.nextthink = time + 0.1;
//			self.think = HIP_DiversionLightningThink;
//			self.nextthink = time;
//			self.delay = time + 0.30;
//			self.origin = self.owner.origin;
//			self.think();
			return;
			}
		}
	org = self.lastvictim.origin;
	dst = self.enemy.absmin + 0.25*(self.enemy.absmax-self.enemy.absmin);
	dst = dst + (random()*0.5*(self.enemy.absmax-self.enemy.absmin));
	traceline (org, dst, TRUE, self.owner.owner);

	if (trace_fraction != 1.0 || self.enemy.health<=0)
		{
		self.enemy.struck_by_mjolnir = 0;
		self.state = 0;
		self.nextthink = time + 0.1;
		return;
		}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	vec = normalize(self.enemy.origin - self.owner.origin);
	dot = vec * self.owner.movedir;
	head = self;
	self = self.owner.owner;
	if (oldstate==0)
		dam = 80;
	else
		dam = 30;
	if (dot>0.3)
		HIP_HammerDamage (org, trace_endpos, self, dam);
//		LightningDamage(FALSE, org, trace_endpos, self, dam);
	else
		HIP_HammerDamage (org, trace_endpos, self, dam*0.5);
//		LightningDamage(FALSE, org, trace_endpos, self, dam*0.5);
	self = head;

	self.nextthink = time + 0.2;
};

void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning =
{
	local entity slight;
	// spawn actual lightning
	slight = spawn();
	slight.delay = time + 0.8;
	slight.state = 0;
	slight.lastvictim = prev;
	slight.distance = dst;
	slight.owner = own;
	slight.v_angle = self.angles;
	slight.v_angle_x = 0;
	slight.v_angle_z = 0;
	slight.origin = own.origin;
	slight.think = HIP_LightningThink;
	slight.nextthink = time;
};

void() HIP_SpawnMjolnirBase =
{
	local entity slight;
	// spawn slightning base
	slight = spawn();
//	slight.origin = self.origin - '0 0 24' + (32*v_forward);
	slight.origin = trace_endpos;
	slight.flags = 0;
	slight.owner = self;
	slight.struck_by_mjolnir = 1;
	slight.think = SUB_Remove;
	slight.nextthink = time + 1;
	if (self.eweapon)
	{
		sound (slight, CHAN_AUTO, self.eweapon.noise2, 1, ATTN_NORM);			// "weapons/thors_hammer/mjolslap.wav"
		sound (slight, CHAN_WEAPON, self.eweapon.noise3, 1, ATTN_NORM);	// "weapons/thors_hammer/mjolhit.wav"
	}
	else
		sound (slight, CHAN_AUTO, "weapons/thors_hammer/mjolslap.wav", 1, ATTN_NORM);

	makevectors(self.v_angle);
	slight.movedir = v_forward;
	HIP_SpawnMjolnirLightning( slight, slight, 350 );
	HIP_SpawnMjolnirLightning( slight, slight, 350 );
	HIP_SpawnMjolnirLightning( slight, slight, 350 );
	HIP_SpawnMjolnirLightning( slight, slight, 350 );
};

void() HIP_FireMjolnirLightning =
{
	local vector	org;
	local	float		cells;

	if (self.eweapon)
 {
// explode if under water
	if (self.waterlevel > 1 && (Q_100 || PK_100 || self.watertype != CONTENT_LAVA))
	{
		cells = self.ammo_cells;
		self.currentammo = self.ammo_cells = 0;
		discharged = 1;
		T_RadiusDamage (self, self, 35*cells, world); // FIX - L damage
		discharged = 0;
		W_SetCurrentAmmo ();
		return;
	}

	self.currentammo = self.ammo_cells = self.ammo_cells - ammo_con(self.eweapon.dmg_save, self, "");
 }

	HIP_SpawnMjolnirBase();
};


void() HIP_FireMjolnir =
{
	local vector	org;
	local	float		cells;
	local float	 damage;
	local vector	source;
	local vector	ang;


	self.attack_finished = time + self.eweapon.attack_finished;
	source = self.origin + '0 0 16';
	makevectors(self.v_angle);
	traceline (source, source + v_forward*32, FALSE, self); // strike range?
	if (trace_fraction == 1.0 && (self.ammo_cells >= ammo_con(self.eweapon.dmg_save, self, "")))
		{
		source = source + v_forward*32;
		traceline (source , source - v_up*50, FALSE, self);
		if (trace_fraction > 0.3 && trace_fraction< 1.0)
			{
			HIP_FireMjolnirLightning();
			self.attack_finished = time + 1.5; // IMP: inventory contol implement
			return;
			}
		}
	org = trace_endpos - v_forward*4;

   if (trace_ent.takedamage)
	{
      damage = 50;
      if (trace_ent.classname == "monster_zombie")
         damage = 70;
//	melee_damage(self.origin + '0 0 16', self.origin + '0 0 16' + v_forward*64, damage, 50, 0, TE_GUNSHOT, self.eweapon.noise1, self.eweapon.noise3, self.eweapon.noise4); // was chaos mod code
//			self.noise1 = "hknight/slash1.wav"; // missed
//			self.noise3 = "thors_hammer/mjoltink.wav"; // hit wall &| solid
//			self.noise4 = "zombie/z_hit.wav"; // hit flesh
		trace_ent.axhitme = 1;
		SpawnBlood (org, v_forward, damage);
		T_Damage (trace_ent, self, self, damage);
	}
   else
	{  // hit wall
      if (trace_fraction != 1.0)
		{
//         sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
         sound (self, CHAN_WEAPON, self.eweapon.target, 1, ATTN_NORM); // tink sound when spanking a wall
         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
		}
      else
		{
         sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM); // swish
		}
	}

};

void() player_mjolnir1b;
void() player_hammer1;

// fn(player_hammer1) - call fire frames

void()	player_mjolnir1 =
{
	if (self.ammo_cells >= ammo_con(self.eweapon.dmg_save, self, "") && !(self.mask_x & CB_GREMLIN)) // melee wep deal
		player_mjolnir1b(); // lightning strike
	else
		player_hammer1();
};
