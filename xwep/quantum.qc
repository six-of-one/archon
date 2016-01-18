/* ::-::
 *
 * Cataboligne
 *
 * file: quantum.qc
 *
 * date: 9/1/11
 *
 * Howard Roy portal gun updated to CMmkII
 *
 */

//.float portal_busy; // moved to defs - fell out deal
.entity master;
.entity portal_entrance; // used by player ent for mode 2 portals to store entry (blue) portal for exit (red) portal
.vector portal_entrance_pos;
.entity portal_exit;
.vector portal_exit_pos;
.float portal_failed;
.float portal_opened;

float PORTAL_ONEWAY = 0; // set true for a one way portal
float PORTAL_DEBOUNCE = 1; // debounce time in case we get a portal the player doesnt properly eject from
float PORTAL_ALLOW = 1; // 0 - only allow players / monsters, 1 - allow all moving ents
float PORTAL_M3START = 1; // if true - allow mode 3 portal to include player start positions
float PORTAL_M3RND = 1; // if true - mode 3 portal picks random destinations every time

string PORTAL_TELEFRAG = "md4";
float PORTAL_FRAGMODE = 24; // - 2 bits, 8 + 16

string PORTAL_FAIL; // alt fail msg

// portals seem to dump players outside the level - this saves them

void() PortalSaver =
{
	local float p;

	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}

	if (self.cnt > 10)
	{
		centerprint (self.owner, "QUANTUM TUNNEL failure: xFF2C1b7A - researcher trapped in dimensional flux\nretrieving!\n");
		setorigin(self.owner, self.origin + ' 0 0 16');
		self.owner.velocity = v0;
		remove(self);
		return;
	}

	self.nextthink = time + 0.5;

	p = pointcontents (self.owner.origin);
	if (p == CONTENT_SOLID)
	{
		self.cnt = self.cnt + 1;
		self.nextthink = time + 0.1;
	}
};

void () PortalTouch;

void() portal_multi_frag =
{
	other = self.master;
	PortalTouch();
};

// IMP: monsters & items - may need different reject quals

void () PortalTouch =
{
	local entity e;
	local float v, m, p;

//	m = IS_MISSILE(other); // test for missiles

//if (m) bprint("missile in portal touch\n");


	if (!PORTAL_ALLOW) // NOTE: there do need to be qualifications on ANY mode
	if (!m)
	if (((other.classname != "player") && (other.classname != "pk*bot") || !(other.flags & FL_CLIENT)))
	{
		return;
	}
	if (!self.portal_opened)
	{
		return;
	}
	if (self.ltime > time) // debounce delay
		return;

	if (other.map == "nonmove") // 7.22.13 - func_models we should not port
		return;

//	if (self.portal_entrance.target == PORTAL_TELEFRAG) // no telefragging with missiles
//	if (m) return;

	makevectors (other.angles);

	if ((other.classname == "player") || (other.classname == "pk*bot") || (other.flags & FL_CLIENT))
	{
		p = TRUE;

		e = spawn(); // in case the portal dumps player outside level - this saves em;
		e.owner = other;
		e.origin = other.origin - v_forward * 64;
		e.think = PortalSaver;
		e.nextthink = time + 0.2;
		e.attack_finished = time + 10;
		other.cam_x = other.cam_x | CAM_TELE; // for the short move
	}

	v = vlen(other.velocity); // IDEA: cap this?
	if (v < 48) v = 48;

	if (self.classname == "portal_entrance")
	{
		if (self.target == "md3") // out thru tele - follow those rules
		{
			local vector org;
			e = find_tdest(FL_RSTELE, "");
			if (!e && PORTAL_M3START) e = find_tdest(FL_RSSTART, "");
			if (!e) e = self.portal_exit; // failed - use one it opened with

			if (PK) ClearSpawnPoint(e);
			other.fixangle = 1;		// turn this way immediately
			other.angles = e.mangle;
			makevectors (e.mangle);
			org = e.origin + 32 * v_forward;

			spawn_tfog (org);
			if (p || (other.flags & FL_MONSTER))
				spawn_tdeath (e.origin,other);
			setorigin (other,e.origin);

			other.teleport_time = time + 0.7;
			other.bt_immune_time = time + BT_BUFFER; // *pk - beartrap
			if (other.flags & FL_ONGROUND)
				other.flags = other.flags - FL_ONGROUND;

			if (!m) v = 300;
			other.velocity = v_forward * v;
			return;
		}
		if (self.portal_exit.mangle == ' 0 0 1')
		{
//			item_eject(other, ' 210 210 300'); // up from floor - need some velo so we dont fall back
			if (!m)
				other.velocity_z = 150 + random() * 150;
		}
		else if (self.portal_exit.mangle != ' 0 0 -1') // not out of ceiling
		{
			other.fixangle = 1;		// turn this way immediately
			other.angles = vectoangles(self.portal_exit.mangle);
			other.velocity = self.portal_exit.mangle * v;
		}
//		other.portal_failed = time + PORTAL_DEBOUNCE;
		self.portal_exit.ltime = time + PORTAL_DEBOUNCE;

		other.origin = (self.portal_exit.origin + (self.portal_exit.mangle * 24));
	}
	else
	if (self.classname == "portal_exit" && ( !PORTAL_ONEWAY || self.portal_entrance.target == PORTAL_TELEFRAG) )
	{
		if (self.portal_entrance.target == PORTAL_TELEFRAG)
		{
			if (!self.portal_entrance.enemy) return;
			setorigin(self.portal_entrance, self.portal_entrance.enemy.origin);
			spawn_tfog (self.portal_entrance.origin);
			if (p || (other.flags & FL_MONSTER))
				spawn_tdeath (self.portal_entrance.origin, self.master);
			newmis.classname = "portalteledeath";
			makevectors(self.portal_entrance.enemy.v_angle);
			self.portal_entrance.mangle = v_forward;
			centerprint (self.owner, "QUANTUM TUNNEL frag: xFFFF1a99 - \b portal-telefrag +1\n");
			if (self.portal_entrance.portal_entrance)
			{
				if (self.portal_entrance.portal_entrance.enemy) // TDO: fix kill chain
				{
					e = self.portal_entrance;
					other.portal_entrance = self.portal_entrance = self.portal_entrance.portal_entrance;
					remove(e);
					self.classname = "multi-frag-chain";
					self.nextthink = time + PORTAL_DEBOUNCE + 0.2;
					self.think = portal_multi_frag;
					other.attack_finished = time + 1.5;
				}					
			}
		}
		else if (self.portal_entrance.mangle == ' 0 0 1')
		{
//			item_eject(other, ' 210 210 300'); // up from floor - need some velo so we dont fall back
			if (!m)
				other.velocity_z = 150 + random() * 150;
		}
		else if (self.portal_entrance.mangle != ' 0 0 -1')
		{
			other.fixangle = 1;		// turn this way immediately
			other.angles = vectoangles(self.portal_entrance.mangle);
			other.velocity = self.portal_entrance.mangle * v;
		}
//		other.portal_failed = time + PORTAL_DEBOUNCE;
		self.portal_entrance.ltime = time + PORTAL_DEBOUNCE;

		other.origin = (self.portal_entrance.origin + (self.portal_entrance.mangle * 24));
	}
	else
	{
		return;
	}
	other.hook = 0; // VERIFY: other things like this that need to be done
};

float RED_PORTAL = 4; // add this for red portal skins - test

void () PortalThink =
{
//	if (self.classname != "portal_exit")
//	if (self.portal_entrance) // chain
	if (self.classname != "portal_exit")
	if (self.target == PORTAL_TELEFRAG) // chain
	{
		self.nextthink = time + 2;
		return;
	}

	if (((self.attack_finished < time) || self.portal_failed))
	{
		if ((self.portal_opened && (self.classname == "portal_entrance")))
		{
			centerprint (self.master, "QUANTUM TUNNEL closed: xFF567c3E - expired\n");
		}
		self.master.portal_busy = FALSE;
		self.master.portal_entrance = world;
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

	if ((self.skin >= (3 + self.aflag)))
	{
		self.weapon = TRUE;
	}
	else
	{
		if ((self.skin <= (0 + self.aflag)))
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
	local vector norm;

	portal = spawn ();
	portal.movetype = MOVETYPE_FLYMISSILE;
	portal.velocity = '0 0 0';
	portal.avelocity = '0 0 0';
	portal.classname = "portal_exit";
	portal.solid = SOLID_BBOX;
	portal.skin = 0 + portal.aflag;
	portal.frame = 0;
	portal.weapon = 0;
	portal.effects = (portal.effects | EF_DIMLIGHT);
	portal.portal_opened = TRUE;
	portal.portal_failed = FALSE;
	portal.portal_entrance = entrance;

	norm = trace_plane_normal;
	portal.mangle = norm; //alize(pos + (norm * -100) - pos);
   norm_x = 0 - norm_x;
   norm_y = 0 - norm_y;
   portal.angles = vectoangles( norm );

	portal.touch = PortalTouch;
	portal.attack_finished = entrance.attack_finished;
	portal.nextthink = (time + 0.1);
	portal.think = PortalThink;
	setmodel (portal, "progs/quantum.mdl");
	setsize (portal, '0 0 0', '0 0 0');
//	setsize (portal, '-2 -2 -2', ' 2 2 2');
	setorigin (portal, pos);
	return (portal);
};

void () PortalPathThink =
{
	local float pntc;
	local vector o2;

	if ((self.attack_finished < time))
	{
		self.portal_entrance.portal_failed = TRUE;
		centerprint (self.master, "QUANTUM TUNNEL failure: xFF8E1a99 - tunnel error\n");
		self.master.portal_busy = FALSE;
		remove (self);
		return;
	}
	pntc = pointcontents (self.origin);
	if ((pntc != CONTENT_SOLID))
	{
		v1 = normalize(self.velocity);
		o2 = self.origin + (self.v_angle * 100);
		traceline (o2,self.origin + self.v_angle * -1024, TRUE, self); // for tpn

		self.portal_exit = OpenPortalExit ((self.origin + (v1 * 4)), self.portal_entrance);

		if (trace_fraction == 1)
		{
			self.portal_exit.mangle = self.v_angle; // use this for the exit angle if we dont hit a wall with the trace
			self.portal_exit.angles = vectoangles(self.v_angle); // use this for the portal angle if we dont hit a wall with the trace
		}

		self.portal_exit.master = self.master;
		self.portal_entrance.portal_exit = self.portal_exit;
		self.portal_entrance.portal_opened = TRUE;
		sound (self.portal_entrance, CHAN_WEAPON, "quantum/shdoff.wav", 1, ATTN_NORM);
		sound (self.portal_exit, CHAN_WEAPON, "quantum/shdoff.wav", 1, ATTN_NORM);
		centerprint (self.master, "QUANTUM TUNNEL: opened\n");
		self.master.portal_busy = TRUE;
		remove (self);
		return;
	}
	self.think = PortalPathThink;
	self.nextthink = (time + 0.1);
};

// Cataboligne - 9.12.11 - added mode3, 9.24.11 - adapted for mode 4

float () PortalExit3 =
{
	local entity portal;

	portal = find_tdest(FL_RSTELE, "");
	if (!portal && PORTAL_M3START) portal = find_tdest(FL_RSSTART, "");
	if (!portal) return(FALSE);

	self.portal_entrance.target = "md3";
	self.portal_entrance.portal_exit = portal;
	self.portal_entrance.portal_opened = TRUE;
	sound (self.portal_entrance, CHAN_WEAPON, "quantum/shdoff.wav", 1, ATTN_NORM);
	sound (portal, CHAN_WEAPON, "quantum/shdoff.wav", 1, ATTN_NORM);
	centerprint (self, "QUANTUM TUNNEL: opened\n");
	self.portal_busy = TRUE;
	return (TRUE);
};

// Cataboligne - 9.10.11 - added md2 - mode2

float (vector dir) PortalExit2 =
{
	local vector org;
	local entity portal;

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
	if (!self.portal_entrance)
	{
		PORTAL_FAIL = "QUANTUM TUNNEL failure: xFF56Ab3E - device unknown error!\n";
		return (FALSE);
	}

	org = (trace_endpos - (dir * 8));

	portal = OpenPortalExit (org, self.portal_entrance);
	portal.master = self;
	portal.aflag = RED_PORTAL; // make it a red portal
	portal.skin = 0 + portal.aflag;
	self.portal_entrance.portal_exit = portal;
	portal.target = self.portal_entrance.target;
	self.portal_entrance.portal_opened = TRUE;
	sound (self.portal_entrance, CHAN_WEAPON, "quantum/shdoff.wav", 1, ATTN_NORM);
	sound (portal, CHAN_WEAPON, "quantum/shdoff.wav", 1, ATTN_NORM);
	centerprint (self, "QUANTUM TUNNEL: opened\n");
	self.portal_busy = TRUE;
	return (TRUE);
};

float PORTAL_ALT_FIRE;

float (vector dir, float md2) PreparePortalEntrance =
{
	local entity tline;
	local entity portal;
	local vector org, norm;
	local string ts;
	local float f;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	if (trace_ent.takedamage && trace_ent.solid == SOLID_SLIDEBOX) // here we want to check a telefrag able ent for mode 8
	{
		if (md2 == 17) // opening frag portal & selected next target - chain up
			SUB_Nop();
		else if (md2 == 9) // opening frag portal & selected another target - retarget
			remove(self.portal_entrance);
		else
		if (!self.eweapon.cnt & PORTAL_FRAGMODE)
			return (FALSE);
	}
	else
	{
		if ((trace_ent != world))
		{
			if (md2 == 17) return (TRUE); // cant fail out
			return (FALSE);
		}
		else if (md2 == 9 || md2 == 17)
		{
			if (!PORTAL_ALT_FIRE)
			if (md2 == 17) return (TRUE); // alt fire to open exit
			f = PortalExit2 (dir); // set frag portal on world brush
			self.portal_entrance = world;
			return(f);
		}
		else
		if (self.eweapon.cnt & PORTAL_FRAGMODE)
		{
			PORTAL_FAIL =  "QUANTUM TUNNEL failure: xFF91Ba77 - device target not acquired\n";
			return (FALSE);
		}
	}
	org = (trace_endpos - (dir * 4));
	portal = spawn ();
	portal.master = self;
	if (md2 == 17)
	if (self.portal_entrance)
		portal.portal_entrance = self.portal_entrance;
	if (md2 < 2) // mode2 - the fancy choose the second portal exit deal
	{
		tline = spawn ();
		tline.master = self;
		tline.movetype = MOVETYPE_NOCLIP;
		tline.solid = SOLID_BBOX;
		tline.classname = "portalpath";
		tline.portal_entrance = portal;
		tline.velocity = (dir * 380);
		tline.v_angle = dir;
		tline.touch = SUB_Null;
		tline.attack_finished = (time + 3.8); // how long this bit flies
		tline.nextthink = (time + 0.1);
		tline.think = PortalPathThink;
		setmodel (tline, "");
		setsize (tline, '0 0 0', '0 0 0');
		setorigin (tline, trace_endpos);
	}
	else
		self.portal_entrance = portal; // save for mode 2

	portal.movetype = MOVETYPE_FLYMISSILE;
	portal.velocity = '0 0 0';
	portal.avelocity = '0 0 0';

	norm = trace_plane_normal;
	portal.mangle = norm; //alize(org + (norm * -100) - org);
   norm_x = 0 - norm_x;
   norm_y = 0 - norm_y;
   portal.angles = vectoangles( norm );

	portal.classname = "portal_entrance";
	portal.solid = SOLID_BBOX;
	portal.skin = 0;
	portal.frame = 0;
	portal.weapon = 0;
	portal.effects = (portal.effects | EF_DIMLIGHT);
	portal.portal_opened = FALSE;
	portal.portal_failed = FALSE;
	portal.attack_finished = (time + 10);
	if (md2)
		portal.attack_finished = (time + 20);
	portal.nextthink = (time + 0.1);
	portal.think = PortalThink;

	if (!md2 & PORTAL_FRAGMODE)
	{
		portal.touch = PortalTouch;
		setmodel (portal, "progs/quantum.mdl");
		setsize (portal, '0 0 0', '0 0 0');
//		setsize (portal, '-2 -2 -2', ' 2 2 2');
		setorigin (portal, org);
	}
	else
	{
		portal.enemy = trace_ent;
		portal.target = PORTAL_TELEFRAG;
		ts = trace_ent.netname;
		if (!ts) ts = trace_ent.classname;
		centerprint3 (self, "QUANTUM TUNNEL frag: xFF91Bd4E - device target: ",ts,"\n");
	}

	return (TRUE);
};

// IDEA: flee portal - pops up behind running player
float PORTAL_MODE; // allow non wep mode+ portal fire

void () W_FirePortal =
{
	local vector dir;
	local vector src;
	local vector finish;
	local vector sdir;
	local float success;
	local float loop, f;

	if (self.eweapon) f = self.eweapon.cnt;
	else f = PORTAL_MODE;
	PORTAL_MODE = 0; // always clear this, one shot deal only - NOTE: this will need set on first & second entry for 2x portal
	PORTAL_FAIL = "";

	if (!f || !self.portal_entrance)
	if (self.portal_busy)
	{
		centerprint (self, "Charging warp energy\n");
		sound (self, CHAN_WEAPON, "quantum/qntfail.wav", 1, ATTN_NORM);
		self.attack_finished = (time + 0.1);
		return;
	}
	makevectors (self.v_angle);
	sound (self, CHAN_WEAPON, "quantum/qntfire.wav", 1, ATTN_NORM);
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
	traceline (src, (src + (dir * 2048)), FALSE, self);

	if ((trace_fraction != 1))
	{
		if (f < 2 || !self.portal_busy)
			success = PreparePortalEntrance (dir, f);
		if ((f == 2) && self.portal_busy) // open 2nd portal
		{
			success = PortalExit2 (dir);
			self.portal_entrance = world;
		}
		if (f == 4 && success)
		{
			success = PortalExit3();
		}
		if ((f  & PORTAL_FRAGMODE) && self.portal_busy) // open 2nd portal
		{
			success = PreparePortalEntrance (dir, self.eweapon.cnt + 1); // PortalExit2 (dir);
//			self.portal_entrance = world;
		}
	}
	if (success)
	{
		self.portal_busy = TRUE;
	}
	else
	{
		self.portal_entrance = world;
		self.portal_busy = FALSE;
		if (PORTAL_FAIL)
			centerprint (self, PORTAL_FAIL);
		else
			centerprint (self, "QUANTUM TUNNEL failure: xFFB78d15 - not open\n");
	}
	PORTAL_ALT_FIRE = FALSE;
};

void () player_portal1 = [ $lightfatt1, player_portal2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.attack_finished = (time + 2);
	sound (self, CHAN_WEAPON, "quantum/chargeup.wav", 1, ATTN_NORM);
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

// portal has multiple modes
float HIGH_PORTAL_MODE = 16; // highest portal mode - power of 2

// modes
// 1 - original fire once & tunnel to open space
// 2 - fire twice creates blue & red portals
// 3 - fire once - opens to available teleport on level
// 4 - fire at live ent - telefrag on portal access

void() weap_portal_multi =
{
	if (self.portal_busy)
	{
		sprint(self, "mode change fail: xFF2C9e18 - quantum tunnel active\n");
		return;
	}

	if (self.eweapon.cnt < 1) self.eweapon.cnt = 1;
	self.eweapon.cnt = self.eweapon.cnt * 2;
	if (self.eweapon.cnt > HIGH_PORTAL_MODE) self.eweapon.cnt = 1;
	sprint(self, self.eweapon.netname);
	sprint(self, " mode set to");
//	sprint(self, ftos(self.eweapon.cnt)); // dont show mode 1 as 0
	sprint(self, " - ");

	if (self.eweapon.cnt == 16)
		sprint(self, "quantum multi-frag");
	else if (self.eweapon.cnt == 8)
		sprint(self, "quantum telefrag");
	else if (self.eweapon.cnt == 4)
		sprint(self, "quantum to teleport");
	else if (self.eweapon.cnt == 2)
		sprint(self, "entry / exit quantum tunnel");
	else
		sprint(self, "quantum \"bore\" tunnel");
	sprint(self, "\n");
};

void() portal_alt_fire =
{
	if (!self.portal_busy) weap_portal_multi();
	else if (self.eweapon.cnt & PORTAL_FRAGMODE)
	{
		PORTAL_ALT_FIRE = TRUE;
		W_FirePortal(); // note: lacks framing
	}
};

void() weapon_quantum =
{
	q100_weapon_supershotgun();
	self.netname = "Quantum tunnel apparatus";

	self.touch = x_weapon_touch;
	self._attack = SUB_Null;
	self._alt_fire = portal_alt_fire;
	self._fr_attack = player_portal1;

	self.currentammo = 0;
	self.aflag = IGN_INV;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_NONE;
	self.attack_finished = 1;
	self.dmg = 0;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt
	self.th_melee = weap_portal_multi;
	self.vv_draw = vw_range_base;

	setmodel (self, "progs/m_quantum.mdl");
	self.weaponmodel = "progs/v_quantum.mdl";
	self.vwepmdl = "progs/vw_quantum.mdl";
//	self.noise = "doom/dswpnup.wav";
	self.noise3 = "quantum/qntfire.wav";
//	self.noise4 = "doom/dsitembk.wav";
//	self.duration = SND_OVER;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "x_item";
	self.mask_x = CB_HUMAN + CB_GREMLIN + CB_ENF;
};


/* vector test from origin along trace_plane_normal


local entity e;
e = spawn();
setmodel(e, "progs/beambit.spr");
setorigin(e, org);
makevectors(portal.mangle);
e = spawn();
setmodel(e, "progs/beambit.spr");
setorigin(e, org + trace_plane_normal * 10);
e = spawn();
setmodel(e, "progs/beambit.spr");
setorigin(e, org + trace_plane_normal * 20);
e = spawn();
setmodel(e, "progs/beambit.spr");
setorigin(e, org + trace_plane_normal * 30);
e = spawn();
setmodel(e, "progs/beambit.spr");
setorigin(e, org + trace_plane_normal * 40);
e = spawn();
setmodel(e, "progs/hook.mdl");
setorigin(e, org + trace_plane_normal * 50);

*/