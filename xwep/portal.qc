.float portal_busy;
.entity master; // TDO: replace with existing
.entity portal_entrance;
.vector portal_entrance_pos;
.entity portal_exit;
.vector portal_exit_pos;
.float portal_failed;
.float portal_opened;
 
void () PortalTouch =
{
	if (((other.classname != "player") || !(other.flags & FL_CLIENT)))
	{
		return;
	}
	if (!self.portal_opened)
	{
		return;
	}
	makevectors (other.angles);
	if ((self.classname == "portal_entrance"))
	{
		other.origin = (self.portal_exit.origin + (v_forward * 20));
	}
	else
	{
		if ((self.classname == "portal_exit"))
		{
			other.origin = (self.portal_entrance.origin + (v_forward * 20));
		}
		else
		{
			return;
		}
	}
};

void () PortalThink =
{
	if (((self.attack_finished < time) || self.portal_failed))
	{
		if ((self.portal_opened && (self.classname == "portal_entrance")))
		{
			centerprint (self.master, "Portal expired\n");
		}
		self.master.portal_busy = FALSE;
		remove (self);
		return;
	}
	if (self.weapon)
	{
		self.skin = (self.skin - 1);
	}
	else
	{
		self.skin = (self.skin + 1);
	}
	if ((self.skin >= 3))
	{
		self.weapon = TRUE;
	}
	else
	{
		if ((self.skin <= 0))
		{
			self.weapon = FALSE;
		}
	}
	if (self.portal_opened)
	{
		self.frame = (self.frame + 1);
		if ((self.frame >= 8))
		{
			self.frame = 4;
		}
	}
	self.think = PortalThink;
	self.nextthink = (time + 0.1);
};

entity (vector pos, entity entrance) OpenPortalExit =
{
	local entity portal;

	portal = spawn ();
	portal.movetype = MOVETYPE_FLYMISSILE;
	portal.velocity = '0 0 0';
	portal.avelocity = '0 0 0';
	portal.classname = "portal_exit";
	portal.solid = SOLID_BBOX;
	portal.skin = 0;
	portal.frame = 0;
	portal.weapon = 0;
	portal.effects = (portal.effects | EF_DIMLIGHT);
	portal.portal_opened = TRUE;
	portal.portal_failed = FALSE;
	portal.portal_entrance = entrance;
	portal.angles = entrance.angles;
	portal.touch = PortalTouch;
	portal.attack_finished = entrance.attack_finished;
	portal.nextthink = (time + 0.1);
	portal.think = PortalThink;
	setmodel (portal, "progs/portal.mdl");
	setsize (portal, '0 0 0', '0 0 0');
	setorigin (portal, pos);
	return (portal);
};

void () PortalPathThink =
{
	local float pntc;

	if ((self.attack_finished < time))
	{
		self.portal_entrance.portal_failed = TRUE;
		centerprint (self.master, "Portal failed\n");
		self.master.portal_busy = FALSE;
		remove (self);
		return;
	}
	pntc = pointcontents (self.origin);
	if ((pntc != CONTENT_SOLID))
	{
		self.portal_exit = OpenPortalExit ((self.origin + (self.velocity * 0.01)), self.portal_entrance);
		self.portal_exit.master = self.master;
		self.portal_entrance.portal_exit = self.portal_exit;
		self.portal_entrance.portal_opened = TRUE;
		sound (self.portal_entrance, CHAN_WEAPON, "weapons/shdoff.wav", 1, ATTN_NORM);
		sound (self.portal_exit, CHAN_WEAPON, "weapons/shdoff.wav", 1, ATTN_NORM);
		centerprint (self.master, "Portal opened\n");
		self.master.portal_busy = TRUE;
		remove (self);
		return;
	}
	self.think = PortalPathThink;
	self.nextthink = (time + 0.1);
};

float (vector dir) PreparePortalEntrance =
{
	local entity tline;
	local entity portal;
	local vector org;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	if (trace_ent.takedamage)
	{
		return (FALSE);
	}
	else
	{
		if ((trace_ent != world))
		{
			return (FALSE);
		}
	}
	org = (trace_endpos - (dir * 8));
	tline = spawn ();
	tline.master = self;
	portal = spawn ();
	portal.master = self;
	tline.movetype = MOVETYPE_NOCLIP;
	tline.solid = SOLID_BBOX;
	tline.classname = "portalpath";
	tline.portal_entrance = portal;
	tline.velocity = (dir * 380);
	tline.v_angle = dir;
	tline.touch = SUB_Null;
	tline.attack_finished = (time + 3.8);
	tline.nextthink = (time + 0.1);
	tline.think = PortalPathThink;
	setmodel (tline, "");
	setsize (tline, '0 0 0', '0 0 0');
	setorigin (tline, trace_endpos);
	portal.movetype = MOVETYPE_FLYMISSILE;
	portal.velocity = '0 0 0';
	portal.avelocity = '0 0 0';
	portal.angles = vectoangles (dir);
	portal.classname = "portal_entrance";
	portal.solid = SOLID_BBOX;
	portal.skin = 0;
	portal.frame = 0;
	portal.weapon = 0;
	portal.effects = (portal.effects | EF_DIMLIGHT);
	portal.portal_opened = FALSE;
	portal.portal_failed = FALSE;
	portal.touch = PortalTouch;
	portal.attack_finished = (time + 10);
	portal.nextthink = (time + 0.1);
	portal.think = PortalThink;
	setmodel (portal, "progs/portal.mdl");
	setsize (portal, '0 0 0', '0 0 0');
	setorigin (portal, org);
	return (TRUE);
};

void () W_FirePortal =
{
	local vector dir;
	local vector src;
	local vector finish;
	local vector sdir;
	local float success;
	local float loop;

	if (self.portal_busy)
	{
		centerprint (self, "Charging warp energy\n");
		sound (self, CHAN_WEAPON, "portal/portfail.wav", 1, ATTN_NORM);
		self.attack_finished = (time + 0.1);
		return;
	}
	makevectors (self.v_angle);
	sound (self, CHAN_WEAPON, "portal/portfire.wav", 1, ATTN_NORM);
	loop = 0;
	while ((loop < 68))
	{
		sdir = (((self.origin + ((v_forward * 80) * random ())) + ((v_right * 60) * (0.5 - random ()))) + ((v_up * 60) * (0.5 - random ())));
		particle (sdir, '0 0 2', 1, 8);
		loop = (loop + 1);
	}
	src = (self.origin + (v_forward * 10));
	src_z = (self.absmin_z + (self.size_z * 0.7));
	finish = (src + (v_forward * 600));
	dir = (finish - src);
	dir = normalize (dir);
	traceline (src, (src + (dir * 2048)), TRUE, self);
	if ((trace_fraction != 1))
	{
		success = PreparePortalEntrance (dir);
	}
	if (success)
	{
		self.portal_busy = TRUE;
	}
	else
	{
		self.portal_busy = FALSE;
		centerprint (self, "Cannot open portal there\n");
	}
};

void () player_portal1 = [ $lightfatt1, player_portal2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.attack_finished = (time + 2);
	sound (self, CHAN_WEAPON, "portal/chargeup.wav", 1, ATTN_NORM);
};

void () player_portal2 = [ $lightfatt2, player_portal3 ] { self.weaponframe = 2; };

void () player_portal3 = [ $lightfatt1, player_portal4 ]
{
	self.weaponframe = 3;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_portal4 = [ $lightfatt2, player_portal5 ] { self.weaponframe = 4; };

void () player_portal5 = [ $lightfatt1, player_portal6 ]
{
	self.weaponframe = 5;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_portal6 = [ $lightfatt2, player_portalstart1 ] { self.weaponframe = 6; };

void () player_portalstart1 = [ $shotatt2, player_portalstart2 ]
{
	if (self.portal_busy)
	{
		W_FirePortal ();
		player_run ();
		return;
	}
	self.weaponframe = 7;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_portalstart2 = [ $shotatt3, player_portalstart3 ] { self.weaponframe = 8; };
void () player_portalstart3 = [ $shotatt4, player_portalstart4 ] { self.weaponframe = 9; };
void () player_portalstart4 = [ $shotatt5, player_portalstart5 ] { self.weaponframe = 10; };
void () player_portalstart5 = [ $shotatt6, player_run ]
{
	self.weaponframe = 11;
	W_FirePortal ();
};

