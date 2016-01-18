/*

visible weapon support

Cataboligne 9.26.9
*/

//.float viswframe; // special framing - drop / pull [not used yet]
.entity exteriormodeltoclient; // dp var -- viswep deal - good solution (only) for dp


string VW_DEFGUN = "progs/vw_qgun.mdl";

// fn(viswep_pre) - precache - standard weps

void() viswep_pre =
{
// quake 1 weps
	precache_model ("progs/vw_qgun.mdl");
	precache_model ("progs/vw_axe.mdl");
	precache_model ("progs/vw_shot.mdl");
	precache_model ("progs/vw_dblshot.mdl");
	precache_model ("progs/vw_nailg.mdl");
	precache_model ("progs/vw_snailg.mdl");
	precache_model ("progs/vw_gren.mdl");
	precache_model ("progs/vw_rock.mdl");
	precache_model ("progs/vw_light.mdl");
// pk weps
	precache_model ("progs/vw_pnailg.mdl");
	precache_model ("progs/vw_cube.mdl");
	precache_model ("progs/vw_sentry.mdl");
	precache_model ("progs/vw_canpab.mdl");
	precache_model ("progs/vw_harp.mdl");
	precache_model ("progs/vw_airgun2.mdl");
	precache_model ("progs/vw_clight.mdl");
	precache_model ("progs/vw_beartrap.mdl");
	precache_model ("progs/vw_pkp_actor.mdl");
	precache_model ("progs/vw_pkp_ego.mdl");
	precache_model ("progs/vw_pkp_phone.mdl");
	precache_model ("progs/vw_pkp_tomb.mdl");
// armor
	precache_model ("progs/vw_armor.mdl");

};

// fn(FL_MELEE) - detect melee weps
// fn(FL_RANGE) - detect range weps

// qw - quake wep bit
// pkw - pkwep bit

float(entity e, float qw, float pkw) FL_MELEE =
{
	local float Q_MELEE, PK_MELEE;
	local float c;

	Q_MELEE = IT_AXE;
	PK_MELEE = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;

	if (PK_100 || !VW) PK_MELEE = PK_IT_AXE;

	c = FALSE;

	if (pkw && !Q_100)
	{
		if (pkw & PK_MELEE) c = TRUE;
		return(c);
	}

	if (qw & Q_MELEE) c = TRUE;

	if (e.eweapon)
	if (e.eweapon.style == FL_MELEE_WEP)
		c = TRUE;

//	if (mc >= MC_CARRYABLE) c = TRUE; // demolition inventory bits hack
	return(c);
};

float(entity e, float qw, float pkw) FL_RANGE =
{
	local float Q_RANGE, PK_RANGE;
	local float c;

	Q_RANGE = IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	PK_RANGE = PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT;

	if (PK_100 || !VW) PK_RANGE = PK_RANGE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;

	c = FALSE;

	if ((pkw & PK_RANGE) && !Q_100) c = TRUE;
	else if (qw & Q_RANGE) c = TRUE;

	if (e.eweapon)
	{
	if (e.eweapon.style == FL_MELEE_WEP)
		c = FALSE;
	else
		c = TRUE;
	}

	return(c);
};

// fn(mk_pkbits) - put pkbits together for vis wep ops

// need this because pk_items have carryable bits always set


float(entity e) mk_pkbits =
{
	local float cpkweps, nbits;

	cpkweps = PK_IT_AXE | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT; // collectable pk weps
	nbits = e.pk_items & cpkweps;

	if(e.pk_gravitywellammo > 0) nbits = nbits | PK_IT_GRAVITYWELL;
	if(e.pk_turretammo > 0) nbits = nbits | PK_IT_TURRET;
	if(e.pk_canpabammo > 0) nbits = nbits | PK_IT_CANPAB;
	if(e.pk_beartrapammo > 0) nbits = nbits | PK_IT_BEARTRAP;
//	if(e.pk_explode_ammo > 0) nbits = nbits | 
	if(e.pkplus_egoammo > 0) nbits = nbits | PKPLUS_IT_EGO;
	if(e.pkplus_tombammo > 0) nbits = nbits | PKPLUS_IT_TOMB;
	if(e.pkplus_actorammo > 0) nbits = nbits | PKPLUS_IT_ACTOR ;
	if(e.pkplus_phoneammo > 0) nbits = nbits | PKPLUS_IT_PHONE;

	return(nbits);
};

// fn(vw_chain) - chain up viswep for an ent, rebuild vwepent list(s)

// e - ent we want viswep for

entity(entity e) vw_chain =
{
	local entity f, c, ch;
	local float rck, sf;

	c = world;
	ch = e;
	f = find(world,classname,"viswep");
	sf = 50;
	rck = FALSE;

	while (f && sf > 0)
	{
		if (f.owner.deadflag || f.owner.classname == OBSERVER || f.owner.view_ofs == '0 0 0' || f.owner.model == "") // wep found with non owner - should not happen
		{
//			f.model = "";
			f.vwepent = world;
			if (f.wad != "packwep") // pack deal
				remove(f);
			rck = TRUE;
		}
		else
		if (f.owner == e)
		{
			if (!c) c = f;
//			else
//			{
//				ch.chain = f; // NOTE: use vwepent?
//			}
				// chain up any viswep with owner = world
			if (ch) ch.vwepent = f; // this becomes a list rebuild
			ch = f;
//			ch.eweapon = ch; // found when relinking eweapons were wrong
			f.vwepent = world; // unlink old stuff
		}

		f = find(f,classname,"viswep");

		if (!f && rck) // do a recheck because we failed owner deleted some vw
		{
			f = find(world,classname,"viswep");
			sf = sf - 1;
		}
	}
	return (c);
};

// fn(viswep_ofs) - set viswep offsets for some morphs - gremlin repos deal
// e - viswep entity
// l - load entity
// flg - op condition
/*
float SET_ARMED =		1; // ready weps
float SET_STORED =		2; // stored weps
*/
vector(entity e, entity l /*, float flg */) viswep_ofs =
{
	local vector v;

	v = ' 0 0 0';

	if (l.mask_x & CB_GREMLIN)
		{
/*
		if (flg == SET_ARMED)
			{
			v = ' 0 0 0';
			}
		else
			{ */
		if (FL_MELEE(e, e.weapon, e.pk_currentitem))
			v = ' 6 -4 4';
		else
			{
			if (e.weapon == IT_ROCKET_LAUNCHER) // NOTE: not a total assumpt here - all weps need verified for this now TDO:
				v = ' 5.4 0 4';  // IDEA - per frame adjustment for bite attack?
			else
				v = ' 5.4 0 0';
			}
//			}
		}
	return(v);
}

// fn([pk]vload) - load up vwepent for an ent

float(float bt, string md) wepbit_mcode;

// e - ent loading to
// fl - flag of wep to load
// Cataboligne - 9.11.11 - added negative flag for specials

entity(entity e, float fl) vload =
{
	local entity tr;
	local string md;

	md = "";
	tr = e;
	while (tr.vwepent)
		tr = tr.vwepent;

	tr.vwepent = spawn();
	setorigin(tr.vwepent, e.origin);
	tr.vwepent.vwepent = world;
	tr.vwepent.owner = e;
	tr.vwepent.classname = "viswep";
	setsize (tr.vwepent, v0, v0);
	tr.vwepent.finaldest = viswep_ofs(tr.vwepent, e); // gremlin adjust init
//	tr.vwepent.touch = touch_theft; // sticky little gremlin claws abound // TDO:

	tr.vwepent.weapon = fl;
	tr.vwepent.pk_currentitem = 0;
	tr.vwepent.eweapon = world;

	if (fl == IT_AXE) md = "progs/vw_axe.mdl";
	else if (fl == IT_SHOTGUN) md = "progs/vw_shot.mdl";
	else if (fl == IT_SUPER_SHOTGUN) md = "progs/vw_dblshot.mdl";
	else if (fl == IT_NAILGUN && PK) md = "progs/vw_pnailg.mdl";
	else if (fl == IT_NAILGUN) md = "progs/vw_nailg.mdl";
	else if (fl == IT_SUPER_NAILGUN) md = "progs/vw_snailg.mdl";
	else if (fl == IT_GRENADE_LAUNCHER) md = "progs/vw_gren.mdl";
	else if (fl == IT_ROCKET_LAUNCHER) md = "progs/vw_rock.mdl";
	else if (fl == IT_LIGHTNING) md = "progs/vw_light.mdl";
	else if (fl == IT_MJOLNIR)
	{
		md = "progs/vw_mjolnir.mdl";
		if (self.vwepmdl != md)
			xwep_fakeload (tr.vwepent, 0, 0, "weapon_mjolnir", IT_MJOLNIR);
	}
	else if (fl == IT_ARMOR1) md = "progs/vw_armor.mdl";
	else if (fl < 0) md = "progs/null.mdl"; // special cases - set own model
	if (md == "") md = VW_DEFGUN;
	tr.vwepent.mdl = md;
	if (fl >0 && fl != IT_AXE && !VW) md = VW_DEFGUN;
	setmodel(tr.vwepent, md);

	if (fl > 0) tr.vwepent.mcode = wepbit_mcode(fl, "Q");


if (cvar("saved1") == -888)
{
bprint("viswep loaded: ");
bprint(md);
bprint("\n");
}


/*  you'd think that because this is engine driver it would be smooth as glass - tried it on a -listen server - major fail
	if (DARKPLACES) // TEST: - trying movement deal - movetype 12
	{
		tr.vwepent.movetype = MOVETYPE_FOLLOW; // make the tr.vwepent follow
		tr.vwepent.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
		tr.vwepent.aiment = e; // make the tr.vwepent follow e
		tr.vwepent.punchangle = e.angles; // the original angles of e
		tr.vwepent.view_ofs = '0 0 0'; //tr.vwepent.origin - e.origin; // relative origin
		tr.vwepent.v_angle = '0 0 0'; //tr.vwepent.angles - e.angles; // relative angles
		tr.vwepent.angles = e.angles;
	}
*/
	return(tr.vwepent);
};

void (entity e, float fl) pkvload =
{
	local entity tr;
	local string md;

	tr = e.vwepent;
	if (fl == PK_IT_AXE)
	while (tr)
	{
		if (tr.pk_currentitem == PK_IT_AXE) return; // dont add extra vw axes
		tr = tr.vwepent;
	}

	tr = vload(e, IT_AXE);

	md = "";
//	tr = e;
//	while (tr.vwepent)
//		tr = tr.vwepent;

	tr.pk_currentitem = fl;
	if (fl == PK_IT_AXE) md = "progs/vw_axe.mdl";
	else if (fl == PK_IT_GRAVITYWELL) md = "progs/vw_cube.mdl";
	else if (fl == PK_IT_TURRET) md = "progs/vw_sentry.mdl";
	else if (fl == PK_IT_CANPAB) md = "progs/vw_canpab.mdl";
	else if (fl == PK_IT_GRAPGUN) md = "progs/vw_harp.mdl";
	else if (fl == PK_IT_AIRGUN) md = "progs/vw_airgun2.mdl";
	else if (fl == PK_IT_CLIGHT) md = "progs/vw_clight.mdl";
	else if (fl == PK_IT_BEARTRAP) md = "progs/vw_beartrap.mdl";
	else if (fl == PKPLUS_IT_EGO) md = "progs/vw_pkp_ego.mdl";
	else if (fl == PKPLUS_IT_TOMB) md = "progs/vw_pkp_tomb.mdl";
	else if (fl == PKPLUS_IT_ACTOR) md = "progs/vw_pkp_actor.mdl";
	else if (fl == PKPLUS_IT_PHONE) md = "progs/vw_pkp_phone.mdl";

	if (md == "" ) md = VW_DEFGUN;
	tr.mdl = md;
	if (!VW) md = VW_DEFGUN;
	setmodel(tr, md);

	tr.mcode = wepbit_mcode(fl, "PK2");

};

// fn (vchk) - check for a given item & return ent pointer if found

// can be used for vw special

// qw - quake wep bit
// pkw - pk wep bit
// vh - first vwep of chain

entity(float qw, float pkw, entity vh) vchk =
{
	local entity f;

	f = vh;
	while (f)
	{
		if (f.weapon == qw && (f.pk_currentitem == pkw || pkw == 0)) return (f);
		f = f.vwepent;
	}
	return(world);
};

// fn (vwep_firecary) - fired a carryable, remove viswep if last one

// called from pk_weapon  / pk_artifacts
// pkbt - pk bit of weapon
// e - ent firing wep

void(entity e, float pkbt) vwep_firecary =
{
	local entity f;
	local float pkbits;

	pkbits = mk_pkbits(e);

	if (pkbits & pkbt) return; // e' still got one

	e.weaponmodel = ""; // for morphs that dont make vwep from pki
	vw_chain(e);
	f = vchk(IT_AXE, pkbt, e.vwepent);

	if (f)
	{
		f.vwepent = world;
//		if (f.wad != "packwep") // pack deal
		remove(f);
		vw_chain(e);
	}
};

// fn (viswep_ld) - load or unload viswep models

// TWEAKED: for xwep in pack (effects throw and remove) if wad == "packwep" no remove
// vh - head ent
// e - player ent
// cd - 1 = load em up, -1 = unload em
//			future expansion: -1 dead throw em, -2 unload em
//			-3 - init, unload then countdown set

void(entity e, float cd) viswep_ld =
{
	local entity tr, pr;
	local float pkbits, bts, pkts, f, at, rmv;

	tr = e.vwepent;
	pr = e;
	rmv = at = pkts = bts = 0;

	pkbits = mk_pkbits(e);

	if (cd < 0)
	{
		while (tr)
		{
			pr = tr;
			tr = tr.vwepent;
//			pr.mdl = "";
			pr.vwepent = world;
			if (pr.wad != "packwep") // pack deal
				remove(pr);
		}
		if (e) // because we may come here with self = first viswep ent
		{
			vw_chain(e);
			if (e.classname != "viswep") // NOTE: if cond fails, we have a viswep left!
				e.vwepent = world;
		}


//		if (cd == -3)
//		{
//			self.vwepent = spawn();
//			self.vwepent.delay = time + 1;
//		}
		return;
	}
	
// have items & check for inventory
	while (tr)
	{
		pr = world;
		if (tr.armortype && VW_ARMOR) // armor visuals
		{
			at = e.armortype;
			if (!at)
			{
//				tr.mdl = "";
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = "";
				pr = tr.vwepent;
				tr.vwepent = world;
				remove(tr);
				rmv = TRUE;
			}
			if (at > 0.6) tr.skin = 2;
			else if (at <= 0.6) tr.skin = 1;
			else if (at <= 0.3) tr.skin = 0;
			tr.armortype = at;
		}
		// else if ( )// IDEA: x_items test - extra visual stuff like tanks for flamer, wetsuit / etc
		else
		if (!tr.pk_currentitem) // non pk item wep
		{
			if (tr.weapon > 0)
			{
				if (! tr.weapon & e.items) // dont have this item - remove vwepent
				{
					pr = tr.vwepent;
					tr.vwepent = world;
					if (tr.wad != "packwep") // pack deal
						remove(tr);
					rmv = TRUE;
					}
				else
					bts = bts | tr.weapon;
			}
		}
		else if (tr.weapon == IT_AXE) // pk item test
		{
			if (tr.noise != "q3_snd/holdable.wav")
			if (! tr.pk_currentitem & pkbits)
			{
//				tr.mdl = "";
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = "";
//				pr.vwepent = tr.vwepent;
				pr = tr.vwepent;
				tr.vwepent = world;
				if (tr.wad != "packwep") // pack deal
					remove(tr);
				rmv = TRUE;
			}
			else
				pkts = pkts | tr.pk_currentitem;
		}

//		pr = tr;
		if (pr) tr = pr;
		else if (tr) tr = tr.vwepent;
	}
	if (rmv) vw_chain(e);

	if (VW_ARMOR)
	if (e.armortype && !at)
	{
		tr = vload(e, IT_ARMOR1);
		tr.armortype = at = e.armortype;
		if (tr.armortype > 0.6) tr.skin = 2;
		else if (tr.armortype <= 0.6) tr.skin = 1;
		else if (tr.armortype <= 0.3) tr.skin = 0;
	}
//	if (!pkbits)
//	if ((self.items & IT_AXE) && !(bts & IT_AXE))
//		vload(self, IT_AXE);

	f = 1;
	while ( f & qweps && f < 8388609 ) // NOTE: this will not load an axe
	{
		if ((e.items & f) && !(bts & f))
		if (!(f & e.builtin )) // dont load builtin as vwep
			vload(e, f);
		f = f * 2;
	}

	f = 1;
	while ( f & pkweps && f < 8388609 )
	{
		if (!self.mask_x & CB_GREMLIN)
		if (!self.mask_x & CB_HUMAN) return; // CHECK: back - will any morph ever have vws?

		if ((pkbits & f) && !(pkts & f))
		if (!(f == PK_IT_AXE && (e.builtin & IT_AXE)  )) // dont load axe for builtin wep 1
			pkvload(e, f);
		f = f * 2;
	}
};


// verify this for new weps that use eweapon - huh?

// this checks v_* for non eweapons

float (string wpm) ver_weaponmodel =
{
	string wmr;

	if (wpm == "progs/v_w_mortar.mdl") return(TRUE);
	else if (wpm == "progs/v_d_rock.mdl") return(TRUE);
//	else if (wpm == "") return(TRUE);

	return(FALSE);
};

// fn(viswep_pkbot) - viswep set for pk*bots

void() viswep_pkbot =
{
	local entity sv;

	vw_bot_frame = framecount;

	sv = self;
	self = find(world,classname,"pk*bot");
	while (self)
	{
		viswep_post();

		self = find(self,classname,"pk*bot");
	}

	self = sv;
};

// fn(viswep_post) - postthink viswep run code

// self - player ent

float vw_frame; // once per frame

void() viswep_post =
{
	local entity vhead;
	local float qld, pkbits, vwc, hr1, drw;
	local string vmdl;

//	if (!self.flags & FL_CLIENT) return;

	vw_chain(self);

														// NOTE: check this vs. invisibility for norm & morphs
	if (self.deadflag || self.classname == OBSERVER || self.view_ofs == '0 0 0' || self.model == "") //(self.admin && self.admin != USER_MENU)) //intermission_running)
	{
		if (self.vwepent)
		{
			viswep_ld(self, -2); // unload all weps - for now just removes ent, later deadthrow what's not put in pack if died
		}
		return;
	}

	pkbits = mk_pkbits(self);
	if (!self.vwepent && !pkbits &&  (self.builtin == (self.items & WEP_MASK))) // no pk items, & only builtins - no vw to do
	{
		return;
	}

	vhead = self.vwepent;

//	qld = FALSE;

	if (PK_100 || Q_100)
	{
		if (!vhead)
		{
			vload(self, 8388608);
			if (!FL_RANGE(self.eweapon, self.weapon, self.pk_currentitem))
//			if (self.weapon == IT_AXE && (Q_100 || !PK || self.pk_currentitem == PK_IT_AXE))
				vload(self, IT_AXE);
		}
		else
		{
			if (!FL_RANGE(self.eweapon, self.weapon, self.pk_currentitem))
//			else if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AXE)
//			if (self.weapon == IT_AXE && (Q_100 || !PK || self.pk_currentitem == PK_IT_AXE))
//			if (self.weapon == IT_AXE && (Q_100 || PK && self.pk_currentitem == PK_IT_AXE))
			{
				if (!self.vwepent.vwepent) vload(self, IT_AXE);
			}
			else
			{
				if (self.vwepent.vwepent.weapon == IT_AXE)
				{
					remove(self.vwepent.vwepent);
					self.vwepent.vwepent = world;
				}
				else if (self.vwepent.weapon == IT_AXE)
				{
					self.vwepent = vhead.vwepent;
					remove(vhead);
					self.vwepent.vwepent = world;
				}
			}
		}
	}
	else
	{

	if (!vhead)
		viswep_ld(self, 1);
	else
		{
		if (self.items & qweps != vhead.items) qld = TRUE;
		if (!qld && vhead.armorvalue != self.armortype) qld = VW_ARMOR; // if vw armor display - update on armor changes

		if (vhead.pk_items != pkbits || qld) viswep_ld(self, 1);
		}
	
	}

	if (!self.mask_x & CB_HUMAN) // because non humans dont have vwepents for pki - test never happens below
		if (self.pkprevweapon != self.pk_currentitem) PK_SetCurrentAmmo();

	if (!self.vwepent)
	{
		return;
	}

// detect changes later
	vhead = self.vwepent;
	vhead.items = self.items & qweps;
	vhead.pk_items = pkbits;
	vhead.armorvalue = self.armortype;

// run viswep frame match

	local float vadd, vframe, dwep, gremlin_frame_adjust, grap_frame_adjust, pkdwep;
	local vector vofs, vang; // gremlin vwep offsets

	if (vhead)
		{
		vhead.owner.viswframe = -1; // NOTE: remove to use visframe code anywhere - ? what does this mean ?
		vang = v_forward;
		vang_z = 0;
//		makevectors(vang);
		}

//	vhead.owner.eweapon = world;
	dwep = vhead.owner.weapon; // active wep, or pulled
	pkdwep = vhead.owner.pk_currentitem;
//	if (vhead.owner.flags & FL_DROP) dwep = vhead.owner.prev_weapon; // drop this down first
	hr1 = TRUE; // only display one holstered range wep when !vw

	while (vhead) // IDEA: do this in engine & test above for chaos = CHAOS_ENGINE
	{
		qld = grap_frame_adjust = gremlin_frame_adjust = vadd = 0;
		vofs = vhead.finaldest_x * normalize(vang) + vhead.finaldest_y * normalize(v_right); // NOTE: for gremlin - stored only, cleared for unholstered wep
		vofs_z = vhead.finaldest_z;
		vwc = TRUE; // viswep control -  == VW for holstered weps
		vmdl = vhead.mdl; // for return from invisible
		drw = FALSE; // weapon is drawn
		if (dwep > 0)
		if (vhead.weapon == dwep && (vhead.pk_currentitem == pkdwep || vhead.weapon != IT_AXE))
		{
			drw = TRUE;
			vhead.owner.eweapon = vhead.eweapon;

			if (self.ishuman)
			if ( !(self.cam_x & CHSCAM_ON))
			{
				if (vhead.owner.eweapon)
				{
					if (vhead.owner.eweapon.weaponmodel != vhead.owner.weaponmodel) PK_SetCurrentAmmo();
				}
				else
					if (ver_weaponmodel(vhead.owner.weaponmodel)) PK_SetCurrentAmmo();
//							if (wm != vhead.owner.weaponmodel) vhead.owner.weaponmodel = wm;
				if ((vhead.owner.prevweapon != vhead.owner.weapon) || (vhead.owner.pkprevweapon != vhead.owner.pk_currentitem) || (vhead.owner.forcewchange == 1)) PK_SetCurrentAmmo();
			}
			else	if ((vhead.owner.prevweapon != vhead.owner.weapon) || (vhead.owner.pkprevweapon != vhead.owner.pk_currentitem) || (vhead.owner.forcewchange == 1)) PK_SetCurrentAmmo();
		}
		else if (!PK_100 && !Q_100)
		{
			if (!VW)
			{
				vwc = FALSE; // dont updated this viswep (only held gun and axe holstered)
				if (dwep == IT_AXE && pkdwep == PK_IT_AXE) // holding an axe - leave one holstered range wep
				if (hr1)
				if (vhead.model == VW_DEFGUN)
				{
					vwc = TRUE; // viswep control -  == VW for holstered weps
					hr1 = FALSE;
				}
				if (!vwc) vhead.model = "";
			}
			else if (!VW_HOLSTER) // dont show holstered weps / items
			{
				vwc = FALSE; // dont updated this viswep (only held gun)
				vhead.model = "";
			}
		}

		if (!self.mask_x & CB_GREMLIN)
		if (!self.mask_x & CB_HUMAN)
		{
			if (vhead.wad != "art_shell")
			{
				vhead.model = "";
				vwc = FALSE; // non humans / non gremlins with wep / x_wep do not display visweps - but we need the eweapon entries
			}
		}
//いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい//

		if (!VW)
		if (vhead.weapon > 0) // make sure its a weapon - other things use viswep code like the q3 artifact shells - other weapon enhancements (like the air tanks & flamer tanks) should disappear in !VW, !vwc, & *100
		if (!(vhead.weapon == IT_AXE && vhead.pk_currentitem == PK_IT_AXE))
		if (vhead.mdl != "progs/vw_q2_hgr.mdl")
		if (vhead.mdl != "progs/vw_axe.mdl" && vhead.mdl != "progs/vw_mjolnir.mdl") vmdl = VW_DEFGUN; // ret from invisible - set non axe to qgun

		if (vwc)
		if (vhead.owner.items & IT_INVISIBILITY) vhead.model = ""; // heh heh, player invisible - NOTE: art shells may be still visible when invisible
		else if (vhead.owner.eweapon.model == "progs/vw_w_2chaing.mdl" && vhead.mdl == "progs/vw_w_chaing.mdl") vhead.model = ""; // hack to get rid of single chain gun vw_ when dbl chg selected
		else if (vhead.vv_draw != (void()) 0) // new vw paradigm - code set models
		{
			if (0) // for now TDO: fix rotate issues
			if (DARKPLACES) // TEST: - trying movement deal
			if (!vhead.tag_entity)
			{
				vhead.origin = vhead.angles = v0;
				setattachment(vhead, vhead.owner, "");
			}

			if (vhead.model == "" || (((vhead.oldorigin + vofs) != vhead.owner.origin || vhead.mangle != vhead.owner.angles) && (!vhead.tag_entity) ) || vhead.weaponframe != vhead.owner.frame) // update track
			{
				if (vhead.model == "") setmodel(vhead, vmdl);

				vhead.oldorigin = vhead.owner.origin; // track player data, but viswep values are all diffferent
				vhead.mangle = vhead.owner.angles;
				vhead.weaponframe = vhead.owner.frame;

				vv_pa = vhead.owner.angles_x; // set pitch detect adjust
				if (drw) vhead.vv_draw(vhead.owner.frame);
				else if (vhead.vv_holster != (void()) 0) vhead.vv_holster(vhead.owner.frame);
				else vwc = FALSE; // no display - no frames!

				if (vwc)
				{
					if( ! (vhead.owner.cam_x & CHSCAM_ON) ) vhead.exteriormodeltoclient = vhead.owner; // darkplaces - works for dp!
					else vhead.exteriormodeltoclient = world;


					if (drw) vofs = v0;
					local vector v1, v2, v3, v4;

					v1 = vhead.owner.angles;
					v1_x = 0 - v1_x; // must reverse pitch for proper position from v_fwd calc
					makevectors( v1 );

					v2 = (vv_o_000_x) * v_forward;
					v3 = (0 - (vv_o_000_y)) * v_right;
					v4 = (vv_o_000_z) * v_up;

					vhead.frame = vv_x_000_y;

					if (vhead.tag_entity)
					{
						vhead.origin = v2 + v3 + v4 + vofs; // relative origin
						vhead.angles = vv_a_000;
//						vhead.origin = vhead.origin - vhead.owner.origin; // relative origin
//						vhead.angles = vhead.angles - vhead.owner.angles;
//						if (vv_x_000_x) vhead.v_angle_x = vhead.owner.angles_x + vv_a_000_x + (vhead.owner.angles_x * vv_x_000_x);
//						if (vv_x_000_z) vhead.v_angle_z = vhead.owner.angles_z + vv_a_000_z + (vhead.owner.angles_x * vv_x_000_z);
						if (cvar("saved1") == -888888) // TEST: seems better without this pitch adjust
						{
							if (vv_x_000_x) vhead.angles_x = vhead.owner.angles_x + vv_a_000_x + (vhead.owner.angles_x * vv_x_000_x);
							if (vv_x_000_z) vhead.angles_z = vhead.owner.angles_z + vv_a_000_z + (vhead.owner.angles_x * vv_x_000_z);
						}
					}
					else
					{
						setorigin(vhead, vhead.owner.origin  + v2 + v3 + v4 + vofs); // ... sync visible weapon model
						vhead.angles = vhead.owner.angles + vv_a_000;
						if (vv_x_000_x) vhead.angles_x = vhead.owner.angles_x + vv_a_000_x + (vhead.owner.angles_x * vv_x_000_x);
						if (vv_x_000_z) vhead.angles_z = vhead.owner.angles_z + vv_a_000_z + (vhead.owner.angles_x * vv_x_000_z);
					}


				}
				else 
					vhead.model = "";
			}
		}
		else // old method - brute force animated models
		{
			if (DARKPLACES) // TEST: - trying movement deal
			if (!vhead.tag_entity)
			{
				vhead.origin = vhead.angles = v0;
				setattachment(vhead, vhead.owner, "");
			}
			if (vhead.model == "" || ((vhead.origin + vofs) != vhead.owner.origin || (vhead.angles != vhead.owner.angles) && (!vhead.tag_entity) ) || vhead.weaponframe != vhead.owner.frame) // update track
			{
				if (vhead.model == "") setmodel(vhead, vmdl);
				vhead.weaponframe = vhead.owner.frame; // track player frame, vw .frame may not match

				vframe = vhead.owner.frame;
																			// adjust for gremlin flying frames & carried gun
				if (vhead.owner.model == "progs/gremlin-fly.mdl" && vhead.owner._stand == gremlin_hover && vhead.owner.frame >= grem_fly_frame) gremlin_frame_adjust = grem_fly_frame;
		
				if( ! (vhead.owner.cam_x & CHSCAM_ON) ) vhead.exteriormodeltoclient = vhead.owner; // darkplaces - works for dp!
				else vhead.exteriormodeltoclient = world;

				if (PK_100 || Q_100 || !VW)
				{
					if (vhead.weapon != IT_AXE && dwep != IT_AXE) qld = TRUE;
					else if (vhead.pk_currentitem != PK_IT_AXE && pkdwep != PK_IT_AXE) qld = TRUE;
					else if (vhead.weapon == IT_AXE && dwep == IT_AXE || pkdwep == PK_IT_AXE) qld = TRUE;
// ???: set eweapon by code - have forgotten what this meant
				}
				else if (dwep > 0)
				{
					if ((vhead.weapon == dwep) && (dwep != IT_AXE)) qld = TRUE; // main weapon - not holstered
					else if ((vhead.weapon == dwep) && (vhead.pk_currentitem == pkdwep)) qld = TRUE;
				}

				if (qld)
					{
																			// grap hook out - adjust run / stand frameset - this also syncs first rope seg out of gun with end of gun vw location
						if (vhead.mdl == "progs/vw_harp.mdl" && vhead.owner.grap_cornerchainNext != world && (vhead.owner.frame - gremlin_frame_adjust)< 11) // $pain1
						{
							grap_frame_adjust = VW_HARP_FRADJ;
							local entity e;
							e = vhead.owner.grap_cornerchainNext.enemy; // harpoon itself -> last rope seg
							if (e)
							{
								v3 = grap_vw_adj(vhead.owner) + vhead.owner.origin; // point of rope start - end of harp gun
								v1 = normalize(e.origin - v3); // dir to move rope piece
								setorigin(e, v3 + (v1 * ROPE_FWD));
							}
						}
						vofs = v0; // none if held
						if (vhead.owner.viswframe > -1) vframe = vhead.owner.viswframe;
						if (FL_MELEE(vhead, vhead.weapon, vhead.pk_currentitem))
						{
							if ( (vhead.owner.frame - gremlin_frame_adjust) >= melee_frames) vadd = viswaddf - melee_frames;
						}
						else if (FL_RANGE(vhead, vhead.weapon, vhead.pk_currentitem) || (vhead.mdl == VW_DEFGUN))
						{
							if ( (vhead.owner.frame - gremlin_frame_adjust) < range_frames) vadd = viswaddf;
						}

					} // IDEA: viswframe weps on gremlins back for special frames





				vhead.frame = vframe + vadd - gremlin_frame_adjust - grap_frame_adjust;
				if (!vhead.tag_entity)
				{
					setorigin(vhead, vhead.owner.origin + vofs); // ... sync visible weapon model
					vhead.angles = vhead.owner.angles;
				}
			}
		}
		vhead = vhead.vwepent;
	}

};


// fn(viswep_togl) - toggle VW option on or off

// goes thru all viswep models and sets visual to .mdl (vis storage) or VW_DEFGUN depending on VW
// axes (& replacements) and mjolnir are excluded

void() viswep_togl =
{
	local entity e;

	e = find (world, classname, "viswep");
	while (e)
	{
		if (e.weapon > 0)
		if (!(e.weapon == IT_AXE && e.pk_currentitem == PK_IT_AXE)) // any axe replacement
		if (e.mdl != "progs/vw_q2_hgr.mdl") /// too much trouble to change (for now)
		if (e.mdl != "progs/vw_axe.mdl" && e.mdl != "progs/vw_mjolnir.mdl")
		{
			if (VW) setmodel(e, e.mdl);
			else setmodel(e, VW_DEFGUN);
		}
		e = find (e, classname, "viswep");
	}
};

// fn(grap_vw_adj) - adjust start position for viswep location

// hent - holding entity - player

vector(entity hent) grap_vw_adj =
{
	local vector vwa;
	local vector v1, v2, v3, v4;

	vwa = v0;
	if (!hent) return (vwa);

	vw_harpoon_pnt(hent.frame);

	v1 = hent.angles;
	v1_x = 0 - v1_x; // must reverse pitch for proper position from v_fwd calc
	makevectors( v1 );

	v2 = (vv_o_000_x) * v_forward;
	v3 = (0 - (vv_o_000_y)) * v_right;
	v4 = (vv_o_000_z) * v_up;

//	vwa = hent.origin  + v2 + v3 + v4;
	vwa = v2 + v3 + v4;

	return(vwa);

/*

// depricated - old vw positioning code
	
//	if (hent.flags & FL_CLIENT)
	makevectors(hent.v_angle);
	if (hent.frame > 10) // retr | shoot frames
	{
		vwa = VWX_HARP_RETR * v_forward + VWY_HARP_RETR * v_right + VWZ_HARP_RETR * v_up;
	}
	else
	{
		vwa = VWX_HARP_IDLE * v_forward + VWY_HARP_IDLE * v_right + VWZ_HARP_IDLE * v_up;
	}
	return(vwa);
*/
};

// dead threw protos

float PR_THREW = 1; // TEST: master print

void(entity e, entity p) xwep_ammo;
void(entity e, string cl) item_call_save;
void () painkeep_weapon_touch;
string(float itm, entity e) swep_id;

// fn(DeadThrew) - create drop ent

// e - viswep entity
// md - model string
// p - pack ent if exists

void(entity e, string md, entity p) DeadThrew =
{
	newmis = spawn();

	newmis.items = e.weapon;
	newmis.pk_items = 0;

	if (e.eweapon)
	{
		newmis.eweapon = e;
		newmis.noise = e.noise;
		newmis.eweapon.wad = "packwep";
		newmis.eweapon.model = "";
		newmis.eweapon.classname = item_by_mcode(newmis.eweapon.mcode); // for touch
		newmis.netname = newmis.eweapon.netname;
		newmis.eweapon.items = e.weapon;
		if (p) xwep_ammo(newmis.eweapon, p);
	}
	else // standard weapon
	{
		newmis.netname = swep_id(newmis.items, e);
		if (!e.pk_currentitem)
		{
			newmis.lip = e.lip = wepbit_mcode(e.weapon, "QA"); // NOTE: set in viswep ent
			newmis.currentammo = e.currentammo = wepbit_mcode(e.weapon, "QAC");
			if (p) xwep_ammo(newmis, p);
// ammo
			if (newmis.items == IT_LIGHTNING) newmis.ammo_cells = newmis.currentammo;
			else if (newmis.items == IT_ROCKET_LAUNCHER) newmis.ammo_rockets = newmis.currentammo;
			else if (newmis.items == IT_GRENADE_LAUNCHER) newmis.ammo_rockets = newmis.currentammo;
			else if (newmis.items == IT_SUPER_NAILGUN) newmis.ammo_nails = newmis.currentammo;
			else if (newmis.items == IT_NAILGUN) newmis.ammo_nails = newmis.currentammo;
			else if (newmis.items == IT_SUPER_SHOTGUN) newmis.ammo_shells = newmis.currentammo;
			else if (newmis.items == IT_SHOTGUN) newmis.ammo_shells = newmis.currentammo;
		}
		else // pki
		{
//			if (newmis.items == IT_AXE)
			newmis.pk_currentitem = newmis.pk_items = e.pk_currentitem; // Cataboligne - 9.6.11 - fixes a bug in the pk1.1 source!

			if (newmis.pk_items == PK_IT_CLIGHT)
			{
				newmis.lip = e.lip = wepbit_mcode(IT_LIGHTNING, "QA");
				newmis.ammo_cells = newmis.currentammo = e.currentammo = wepbit_mcode(IT_LIGHTNING, "QAC") * 2;
			}

// pki
			if (e.pk_currentitem == PK_IT_GRAVITYWELL) newmis.pk_gravitywellammo = 1;
			else if (e.pk_currentitem == PK_IT_CANPAB) newmis.pk_canpabammo = 1;
			else if (e.pk_currentitem == PK_IT_TURRET) newmis.pk_turretammo = 1;
			else if (e.pk_currentitem == PK_IT_BEARTRAP) newmis.pk_beartrapammo = 1;
// pk plus
			else if (e.pk_currentitem == PKPLUS_IT_PHONE) newmis.pkplus_phoneammo = 1;
			else if (e.pk_currentitem == PKPLUS_IT_EGO) newmis.pkplus_egoammo = 1;
			else if (e.pk_currentitem == PKPLUS_IT_TOMB) newmis.pkplus_tombammo = 1;
			else if (e.pk_currentitem == PKPLUS_IT_ACTOR) newmis.pkplus_actorammo = 1;

			if (p) xwep_ammo(newmis, p);
			if (newmis.pk_items & PKID) newmis.noise = "misc/pickup/tone2.wav";
		}
	}

//	newmis.flags = FL_ITEM; // not making these large
	newmis.solid = SOLID_TRIGGER;
	newmis.movetype = MOVETYPE_TOSS;
	setorigin(newmis, e.origin);
	setmodel (newmis, md);
	setsize (newmis, '-12 -12 0', '12 12 56');
	newmis.touch = BackpackTouch;

	item_eject(newmis, ' 210 210 240'); // velocity to toss - IDEA: use directional of corpse moving (blast, etc)
	newmis.think = SUB_Remove; // TDO: fade or melt
	if (DEAD_THROW_TIME) newmis.nextthink = time + DEAD_THROW_TIME;

	AddToSplash(newmis); // *pk - splash tossed items

};

// fn(DeadThrowWeps) - handel throwing weapons out on death

//	bit				rule
// 0			no weps thrown
// 1			throw weaps, none worky
// 2			throw weaps, some no worky
// 4			throw weaps, all worky
// 8			randomize throwing (every wep is not thrown)
// 16		throw weps when gibbed

// self = player / bot
// pack (if exists) is backpack just thrown out - need to load ammo for retrievable weps
// v1 - alternate origin for attach ent vweps

// $frame dthrow1 dthrow2 dthrow3 dthrow4 dthrow5

void(entity pack, vector v1) DeadThrowWeps =
{
	local entity e, sv;
	local float w, pkid, pd;

	e = self.vwepent;

	if (!e || !DEAD_THROW) return;

	if (!DEAD_THROW_PKI || DEAD_THROW_PKI == 2)
		pkid = PKID;

//	pkw = PK_IT_GRAPGUN + PK_IT_AIRGUN + PK_IT_CLIGHT;
//	pkpid = PKPLUS_IT_EGO + PKPLUS_IT_TOMB + PKPLUS_IT_ACTOR;

	while (e)
	{
		pd = w = FALSE;
		while (pkid & e.pk_currentitem || e.weapon < 0) e = e.vwepent; // skip painkeep items as detailed by bit mask

		if (!e) return; // ran off end of card

		if (pack)
		{
			if (e.wad != "packwep") // pack deal
			{
				if (pack.eweapon)  pd = TRUE;
				else if (e.pk_currentitem <= PK_IT_AXE)
				{
					if (e.weapon != pack.items) pd = TRUE;
				}
				else if (pack.pk_items != e.pk_currentitem) pd = TRUE;
//				else if ((pack.pk_items != e.pk_currentitem) && (e.weapon == pack.items)) pd = TRUE;
			}
		}
		else
			pd = TRUE;
		
		if (e.pk_currentitem <= PK_IT_AXE)
		if (e.weapon & self.builtin) pd = FALSE; // in case morphs come here - dont throw builtin



if (PR_THREW)
{
bprint("throw loop check: ");
bprint(item_ident(e));
bprint(" - pki:  ");
bprint(ftos(e.pk_currentitem));
bprint(" - pd test:  ");
bprint(ftos(pd));
bprint("\n");
}



		if (pd)
		{
			if (DEAD_THROW & 4) w = TRUE;

			else if (DEAD_THROW & 2)
			{
				if (random() < DEAD_THROW_LIVERND) w = TRUE;
			}

			if (DEAD_THROW & 8)
			if (random() < DEAD_THROW_CNTRND) 
				pd = FALSE;

			if (pd)
			{
//			if (vhead.vv_draw != (void()) 0) // TDO: dead throw framing or animation for these
//			else
				if (e.vv_draw == (void()) 0) // not the alternate vw animation - so it should have deadthrow frames
				{
					e.frame = $dthrow1 + rint(random() * 4);
				}

				if (!w) // not live
				{
					DeadThrew(e, e.model, world);
					newmis.touch = SUB_Null;



if (PR_THREW)
{
bprint("dead thr wep: ");
bprint(newmis.netname);
bprint("\n");
}


				}
				else												{
					DeadThrew(e, e.model, pack);



if (PR_THREW)
{
bprint("live thr wep: ");
bprint(newmis.netname);
bprint("\n");
}
}


				newmis.frame = e.frame;
				if (newmis.origin == v0) setorigin(newmis, v1);
			}
/*
				xwep_ammo(e, pack); // adjust ammo in pack for retrievable wep
				e.classname = item_by_mcode(e.mcode);
				e.pk_touch = x_weapon_touch;
				if (e.mcode != MC_Q3_HOLDMEDKIT && e.mcode != MC_Q3_HOLDTELE) // dont do for holdable
				if (PKID & e.pk_currentitem)
				{
					if (pkpid & e.pk_currentitem) e.pk_touch = pkplus_touch;
					else e.pk_touch = painkeep_touch;
					e.pk_items = e.pk_currentitem;
					e.netname = swep_id(e.items, e);
				}
				if (e.mcode != MC_HOOK && e.mcode != MC_Q2_GRAPPLE && e.mcode != MC_Q3_GRAPPLE) // dont do for hook
				if (pkw & e.pk_currentitem) e.pk_touch = painkeep_weapon_touch;
				if (!e.eweapon) e.netname = swep_id(e.weapon, e);
				e.touch = painkeep_touch;
				e.solid = SOLID_TRIGGER;
*/
//				bot_item_linx(e); // *bot - item tie in
		}
		e = e.vwepent;
	}
};


// in game editor - increment

float vv_incr;


// fn for general wep load
void(float v_frm) vv_load_0 =
{

// must clear when loading zero frames
	vv_o_000 = v0;
	vv_a_000 = v0;
	vv_x_000 = v0;

// animate q2 weps


	if (v_frm == 0)
	{
		vv_o_000 = '-4.2  -8.5   5.0';
		vv_a_000 = '-8.0  -9.4 -15.6';
		vv_x_000 = ' 0.0   8.0   0.0';
	}











	vv_pa = 0;

	return;
};

void(float f) vv_load =
{
	if (!f || f > 50 || f < -50) return; // invalid edit - v0 vals

	if (f == 1)
	{
		vv_o_0 = vv_o_1;
		vv_a_0 = vv_a_1;
		vv_x_0 = vv_x_1;
	}
	else
	if (f == 2)
	{
		vv_o_0 = vv_o_2;
		vv_a_0 = vv_a_2;
		vv_x_0 = vv_x_2;
	}
	else
	if (f == 3)
	{
		vv_o_0 = vv_o_3;
		vv_a_0 = vv_a_3;
		vv_x_0 = vv_x_3;
	}
	else
	if (f == 4)
	{
		vv_o_0 = vv_o_4;
		vv_a_0 = vv_a_4;
		vv_x_0 = vv_x_4;
	}
	else
	if (f == 5)
	{
		vv_o_0 = vv_o_5;
		vv_a_0 = vv_a_5;
		vv_x_0 = vv_x_5;
	}
	else
	if (f == 6)
	{
		vv_o_0 = vv_o_6;
		vv_a_0 = vv_a_6;
		vv_x_0 = vv_x_6;
	}
	else
	if (f == 7)
	{
		vv_o_0 = vv_o_7;
		vv_a_0 = vv_a_7;
		vv_x_0 = vv_x_7;
	}
	else
	if (f == 8)
	{
		vv_o_0 = vv_o_8;
		vv_a_0 = vv_a_8;
		vv_x_0 = vv_x_8;
	}
	else
	if (f == 9)
	{
		vv_o_0 = vv_o_9;
		vv_a_0 = vv_a_9;
		vv_x_0 = vv_x_9;
	}
	else
	if (f == 10)
	{
		vv_o_0 = vv_o_10;
		vv_a_0 = vv_a_10;
		vv_x_0 = vv_x_10;
	}
	else
	if (f == 11)
	{
		vv_o_0 = vv_o_11;
		vv_a_0 = vv_a_11;
		vv_x_0 = vv_x_11;
	}
	else
	if (f == 12)
	{
		vv_o_0 = vv_o_12;
		vv_a_0 = vv_a_12;
		vv_x_0 = vv_x_12;
	}
	else
	if (f == 13)
	{
		vv_o_0 = vv_o_13;
		vv_a_0 = vv_a_13;
		vv_x_0 = vv_x_13;
	}
	else
	if (f == 14)
	{
		vv_o_0 = vv_o_14;
		vv_a_0 = vv_a_14;
		vv_x_0 = vv_x_14;
	}
	else
	if (f == 15)
	{
		vv_o_0 = vv_o_15;
		vv_a_0 = vv_a_15;
		vv_x_0 = vv_x_15;
	}
	else
	if (f == 16)
	{
		vv_o_0 = vv_o_16;
		vv_a_0 = vv_a_16;
		vv_x_0 = vv_x_16;
	}
	else
	if (f == 17)
	{
		vv_o_0 = vv_o_17;
		vv_a_0 = vv_a_17;
		vv_x_0 = vv_x_17;
	}
	else
	if (f == 18)
	{
		vv_o_0 = vv_o_18;
		vv_a_0 = vv_a_18;
		vv_x_0 = vv_x_18;
	}
	else
	if (f == 19)
	{
		vv_o_0 = vv_o_19;
		vv_a_0 = vv_a_19;
		vv_x_0 = vv_x_19;
	}
	else
	if (f == 20)
	{
		vv_o_0 = vv_o_20;
		vv_a_0 = vv_a_20;
		vv_x_0 = vv_x_20;
	}
	else
	if (f == 21)
	{
		vv_o_0 = vv_o_21;
		vv_a_0 = vv_a_21;
		vv_x_0 = vv_x_21;
	}
	else
	if (f == 22)
	{
		vv_o_0 = vv_o_22;
		vv_a_0 = vv_a_22;
		vv_x_0 = vv_x_22;
	}
	else
	if (f == 23)
	{
		vv_o_0 = vv_o_23;
		vv_a_0 = vv_a_23;
		vv_x_0 = vv_x_23;
	}
	else
	if (f == 24)
	{
		vv_o_0 = vv_o_24;
		vv_a_0 = vv_a_24;
		vv_x_0 = vv_x_24;
	}
	else
	if (f == 25)
	{
		vv_o_0 = vv_o_25;
		vv_a_0 = vv_a_25;
		vv_x_0 = vv_x_25;
	}
	else
	if (f == 26)
	{
		vv_o_0 = vv_o_26;
		vv_a_0 = vv_a_26;
		vv_x_0 = vv_x_26;
	}
	else
	if (f == 27)
	{
		vv_o_0 = vv_o_27;
		vv_a_0 = vv_a_27;
		vv_x_0 = vv_x_27;
	}
	else
	if (f == 28)
	{
		vv_o_0 = vv_o_28;
		vv_a_0 = vv_a_28;
		vv_x_0 = vv_x_28;
	}
	else
	if (f == 29)
	{
		vv_o_0 = vv_o_29;
		vv_a_0 = vv_a_29;
		vv_x_0 = vv_x_29;
	}
	else
	if (f == 30)
	{
		vv_o_0 = vv_o_30;
		vv_a_0 = vv_a_30;
		vv_x_0 = vv_x_30;
	}
	else
	if (f == 31)
	{
		vv_o_0 = vv_o_31;
		vv_a_0 = vv_a_31;
		vv_x_0 = vv_x_31;
	}
	else
	if (f == 32)
	{
		vv_o_0 = vv_o_32;
		vv_a_0 = vv_a_32;
		vv_x_0 = vv_x_32;
	}
	else
	if (f == 33)
	{
		vv_o_0 = vv_o_33;
		vv_a_0 = vv_a_33;
		vv_x_0 = vv_x_33;
	}
	else
	if (f == 34)
	{
		vv_o_0 = vv_o_34;
		vv_a_0 = vv_a_34;
		vv_x_0 = vv_x_34;
	}
	else
	if (f == 35)
	{
		vv_o_0 = vv_o_35;
		vv_a_0 = vv_a_35;
		vv_x_0 = vv_x_35;
	}
	else
	if (f == 36)
	{
		vv_o_0 = vv_o_36;
		vv_a_0 = vv_a_36;
		vv_x_0 = vv_x_36;
	}
	else
	if (f == 37)
	{
		vv_o_0 = vv_o_37;
		vv_a_0 = vv_a_37;
		vv_x_0 = vv_x_37;
	}
	else
	if (f == 38)
	{
		vv_o_0 = vv_o_38;
		vv_a_0 = vv_a_38;
		vv_x_0 = vv_x_38;
	}
	else
	if (f == 39)
	{
		vv_o_0 = vv_o_39;
		vv_a_0 = vv_a_39;
		vv_x_0 = vv_x_39;
	}
	else
	if (f == 40)
	{
		vv_o_0 = vv_o_40;
		vv_a_0 = vv_a_40;
		vv_x_0 = vv_x_40;
	}
	else
	if (f == 41)
	{
		vv_o_0 = vv_o_41;
		vv_a_0 = vv_a_41;
		vv_x_0 = vv_x_41;
	}
	else
	if (f == 42)
	{
		vv_o_0 = vv_o_42;
		vv_a_0 = vv_a_42;
		vv_x_0 = vv_x_42;
	}
	else
	if (f == 43)
	{
		vv_o_0 = vv_o_43;
		vv_a_0 = vv_a_43;
		vv_x_0 = vv_x_43;
	}
	else
	if (f == 44)
	{
		vv_o_0 = vv_o_44;
		vv_a_0 = vv_a_44;
		vv_x_0 = vv_x_44;
	}
	else
	if (f == 45)
	{
		vv_o_0 = vv_o_45;
		vv_a_0 = vv_a_45;
		vv_x_0 = vv_x_45;
	}
	else
	if (f == 46)
	{
		vv_o_0 = vv_o_46;
		vv_a_0 = vv_a_46;
		vv_x_0 = vv_x_46;
	}
	else
	if (f == 47)
	{
		vv_o_0 = vv_o_47;
		vv_a_0 = vv_a_47;
		vv_x_0 = vv_x_47;
	}
	else
	if (f == 48)
	{
		vv_o_0 = vv_o_48;
		vv_a_0 = vv_a_48;
		vv_x_0 = vv_x_48;
	}
	else
	if (f == 49)
	{
		vv_o_0 = vv_o_49;
		vv_a_0 = vv_a_49;
		vv_x_0 = vv_x_49;
	}
	else
	if (f == -1)
	{
		vv_o_1 = vv_o_0;
		vv_a_1 = vv_a_0;
		vv_x_1 = vv_x_0;
	}
	else
	if (f == -2)
	{
		vv_o_2 = vv_o_0;
		vv_a_2 = vv_a_0;
		vv_x_2 = vv_x_0;
	}
	else
	if (f == -3)
	{
		vv_o_3 = vv_o_0;
		vv_a_3 = vv_a_0;
		vv_x_3 = vv_x_0;
	}
	else
	if (f == -4)
	{
		vv_o_4 = vv_o_0;
		vv_a_4 = vv_a_0;
		vv_x_4 = vv_x_0;
	}
	else
	if (f == -5)
	{
		vv_o_5 = vv_o_0;
		vv_a_5 = vv_a_0;
		vv_x_5 = vv_x_0;
	}
	else
	if (f == -6)
	{
		vv_o_6 = vv_o_0;
		vv_a_6 = vv_a_0;
		vv_x_6 = vv_x_0;
	}
	else
	if (f == -7)
	{
		vv_o_7 = vv_o_0;
		vv_a_7 = vv_a_0;
		vv_x_7 = vv_x_0;
	}
	else
	if (f == -8)
	{
		vv_o_8 = vv_o_0;
		vv_a_8 = vv_a_0;
		vv_x_8 = vv_x_0;
	}
	else
	if (f == -9)
	{
		vv_o_9 = vv_o_0;
		vv_a_9 = vv_a_0;
		vv_x_9 = vv_x_0;
	}
	else
	if (f == -10)
	{
		vv_o_10 = vv_o_0;
		vv_a_10 = vv_a_0;
		vv_x_10 = vv_x_0;
	}
else
	if (f == -11)
	{
		vv_o_11 = vv_o_0;
		vv_a_11 = vv_a_0;
		vv_x_11 = vv_x_0;
	}
	else
	if (f == -12)
	{
		vv_o_12 = vv_o_0;
		vv_a_12 = vv_a_0;
		vv_x_12 = vv_x_0;
	}
	else
	if (f == -13)
	{
		vv_o_13 = vv_o_0;
		vv_a_13 = vv_a_0;
		vv_x_13 = vv_x_0;
	}
	else
	if (f == -14)
	{
		vv_o_14 = vv_o_0;
		vv_a_14 = vv_a_0;
		vv_x_14 = vv_x_0;
	}
	else
	if (f == -15)
	{
		vv_o_15 = vv_o_0;
		vv_a_15 = vv_a_0;
		vv_x_15 = vv_x_0;
	}
	else
	if (f == -16)
	{
		vv_o_16 = vv_o_0;
		vv_a_16 = vv_a_0;
		vv_x_16 = vv_x_0;
	}
	else
	if (f == -17)
	{
		vv_o_17 = vv_o_0;
		vv_a_17 = vv_a_0;
		vv_x_17 = vv_x_0;
	}
	else
	if (f == -18)
	{
		vv_o_18 = vv_o_0;
		vv_a_18 = vv_a_0;
		vv_x_18 = vv_x_0;
	}
	else
	if (f == -19)
	{
		vv_o_19 = vv_o_0;
		vv_a_19 = vv_a_0;
		vv_x_19 = vv_x_0;
	}
	else
	if (f == -20)
	{
		vv_o_20 = vv_o_0;
		vv_a_20 = vv_a_0;
		vv_x_20 = vv_x_0;
	}
	else
	if (f == -20)
	{
		vv_o_20 = vv_o_0;
		vv_a_20 = vv_a_0;
		vv_x_20 = vv_x_0;
	}
	else
	if (f == -21)
	{
		vv_o_21 = vv_o_0;
		vv_a_21 = vv_a_0;
		vv_x_21 = vv_x_0;
	}
	else
	if (f == -22)
	{
		vv_o_22 = vv_o_0;
		vv_a_22 = vv_a_0;
		vv_x_22 = vv_x_0;
	}
	else
	if (f == -23)
	{
		vv_o_23 = vv_o_0;
		vv_a_23 = vv_a_0;
		vv_x_23 = vv_x_0;
	}
	else
	if (f == -24)
	{
		vv_o_24 = vv_o_0;
		vv_a_24 = vv_a_0;
		vv_x_24 = vv_x_0;
	}
	else
	if (f == -25)
	{
		vv_o_25 = vv_o_0;
		vv_a_25 = vv_a_0;
		vv_x_25 = vv_x_0;
	}
	else
	if (f == -26)
	{
		vv_o_26 = vv_o_0;
		vv_a_26 = vv_a_0;
		vv_x_26 = vv_x_0;
	}
	else
	if (f == -27)
	{
		vv_o_27 = vv_o_0;
		vv_a_27 = vv_a_0;
		vv_x_27 = vv_x_0;
	}
	else
	if (f == -28)
	{
		vv_o_28 = vv_o_0;
		vv_a_28 = vv_a_0;
		vv_x_28 = vv_x_0;
	}
	else
	if (f == -29)
	{
		vv_o_29 = vv_o_0;
		vv_a_29 = vv_a_0;
		vv_x_29 = vv_x_0;
	}
	else
	if (f == -30)
	{
		vv_o_30 = vv_o_0;
		vv_a_30 = vv_a_0;
		vv_x_30 = vv_x_0;
	}
	else
	if (f == -31)
	{
		vv_o_31 = vv_o_0;
		vv_a_31 = vv_a_0;
		vv_x_31 = vv_x_0;
	}
	else
	if (f == -32)
	{
		vv_o_32 = vv_o_0;
		vv_a_32 = vv_a_0;
		vv_x_32 = vv_x_0;
	}
	else
	if (f == -33)
	{
		vv_o_33 = vv_o_0;
		vv_a_33 = vv_a_0;
		vv_x_33 = vv_x_0;
	}
	else
	if (f == -34)
	{
		vv_o_34 = vv_o_0;
		vv_a_34 = vv_a_0;
		vv_x_34 = vv_x_0;
	}
	else
	if (f == -35)
	{
		vv_o_35 = vv_o_0;
		vv_a_35 = vv_a_0;
		vv_x_35 = vv_x_0;
	}
	else
	if (f == -36)
	{
		vv_o_36 = vv_o_0;
		vv_a_36 = vv_a_0;
		vv_x_36 = vv_x_0;
	}
	else
	if (f == -37)
	{
		vv_o_37 = vv_o_0;
		vv_a_37 = vv_a_0;
		vv_x_37 = vv_x_0;
	}
	else
	if (f == -38)
	{
		vv_o_38 = vv_o_0;
		vv_a_38 = vv_a_0;
		vv_x_38 = vv_x_0;
	}
	else
	if (f == -39)
	{
		vv_o_39 = vv_o_0;
		vv_a_39 = vv_a_0;
		vv_x_39 = vv_x_0;
	}
	else
	if (f == -40)
	{
		vv_o_40 = vv_o_0;
		vv_a_40 = vv_a_0;
		vv_x_40 = vv_x_0;
	}
	else
	if (f == -41)
	{
		vv_o_41 = vv_o_0;
		vv_a_41 = vv_a_0;
		vv_x_41 = vv_x_0;
	}
	else
	if (f == -42)
	{
		vv_o_42 = vv_o_0;
		vv_a_42 = vv_a_0;
		vv_x_42 = vv_x_0;
	}
	else
	if (f == -43)
	{
		vv_o_43 = vv_o_0;
		vv_a_43 = vv_a_0;
		vv_x_43 = vv_x_0;
	}
	else
	if (f == -44)
	{
		vv_o_44 = vv_o_0;
		vv_a_44 = vv_a_0;
		vv_x_44 = vv_x_0;
	}
	else
	if (f == -45)
	{
		vv_o_45 = vv_o_0;
		vv_a_45 = vv_a_0;
		vv_x_45 = vv_x_0;
	}
	else
	if (f == -46)
	{
		vv_o_46 = vv_o_0;
		vv_a_46 = vv_a_0;
		vv_x_46 = vv_x_0;
	}
	else
	if (f == -47)
	{
		vv_o_47 = vv_o_0;
		vv_a_47 = vv_a_0;
		vv_x_47 = vv_x_0;
	}
	else
	if (f == -48)
	{
		vv_o_48 = vv_o_0;
		vv_a_48 = vv_a_0;
		vv_x_48 = vv_x_0;
	}
	else
	if (f == -49)
	{
		vv_o_49 = vv_o_0;
		vv_a_49 = vv_a_0;
		vv_x_49 = vv_x_0;
	}
	
};


float vv_chg, vv_prf, vv_cpy, x1, z1;
entity vv;

void(float f) vv_print =
{
	local string pr;

	vv_load(vv.vwepent.viswframe + f - vv.frame);
	vv_load_0(f);

	bprint("	if (v_frm == ");
	bprint(ftos(f));
	bprint(")\n");
	bprint("	{\n");
	bprint("		vv_o_000 = ");
	bprint(vtos(vv_o_0 + vv_o_000));
	bprint(";\n");
	bprint("		vv_a_000 = ");
	bprint(vtos(vv_a_0 + vv_a_000));
	bprint(";\n");
	bprint("		vv_x_000 = ");
	bprint(vtos(vv_x_0 + vv_x_000));
	bprint(";\n");
	bprint("	}\n");
};


void() vw_config = 
{
	if (cvar("saved1") == -999)
	{
		WARNING = FALSE;
		if (!vv)
		{
			vv_cpy = 0; // default - copy from 1 ahead, any other value copys from that frame
			stuffcmd(self, "admin_centertime\n");
			stuffcmd(self, "sv_c_warning 0\n");
			registercvar("vv_incr", "0");
			registercvar("vv_set", "0");
			registercvar("vv_pitch", "0");
		}


		if (cvar("vv_incr") != 0)
		{
			vv_incr = cvar("vv_incr");
			cvar_set("vv_incr","0");
		}
		else
		if (self.impulse == 2) // change value increment & decrement
		{
			if (vv_incr == 1)
			{
//				vv_incr = 2;
				vv_incr = 0.1;
			}
/*
			else
			if (vv_incr == 2)
			{
				vv_incr = 5;
			}
			else
			if (vv_incr == 5)
			{
				vv_incr = 0.1;
			}
*/
			else
			if (vv_incr == 0.1)
			{
				vv_incr = 0.01;
			}
			else
			if (vv_incr == 0.01)
			{
				vv_incr = 1;
			}
			else
			{
				vv_incr = 1;
			}
			centerprint5(self, "incr:  ", ftos(vv_incr)," -- decr:  ", ftos(vv_incr), "\n");
		}
		
		if (self.impulse == 3) // change value edit
		{
			vv_chg = vv_chg + 1;
			if (vv_chg > 5) vv_chg = 0;
//			centerprint3(self, "edit:  ", ftos(vv_chg), "\n");
		}
		if (self.impulse == 23) // change value edit
		{
			vv_chg = vv_chg - 1;
			if (vv_chg < 0) vv_chg = 5;
//			centerprint3(self, "edit:  ", ftos(vv_chg), "\n");
		}
		if (self.impulse == 22) // change value edit
		{
			if (vv_chg < 6) vv_chg = 6;
			else
			vv_chg = vv_chg + 1;
//			if (vv_chg > 9) vv_chg = 6;
			if (vv_chg > 11) vv_chg = 6; // pitch / rotate adj
//			centerprint3(self, "edit:  ", ftos(vv_chg), "\n");
		}

		if (self.impulse == 3 || self.impulse == 23 || self.impulse == 22) // change value edit
		{
			if (vv_chg == 0)
			{
				centerprint3(self, " --- o_X:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 1)
			{
				centerprint3(self, " --- o_Y:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 2)
			{
				centerprint3(self, " --- o_Z:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 3)
			{
				centerprint3(self, " --- a_X:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 4)
			{
				centerprint3(self, " --- a_Y:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 5)
			{
				centerprint3(self, " --- a_Z:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 6)
			{
				centerprint3(self, " --- (frame) x_X:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 7)
			{
				centerprint3(self, " --- v slot:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 8)
			{
				centerprint3(self, " --- cpy frame:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 9)
			{
				centerprint3(self, " --- store frame:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 10)
			{
				centerprint3(self, " --- model y (rotate) angle:  ", ftos(vv_chg), "\n");
			}
			else if (vv_chg == 11)
			{
				centerprint3(self, " --- model x (pitch) angle:  ", ftos(vv_chg), "\n");
			}
		}
/*
		else
		if (cvar("vv_set") != 0)
		{
			if (vv_chg < 3) vv_o_0 = cvar("vv_set");
			else if (vv_chg < 6) vv_a_0 = cvar("vv_set");
			else vv_x_0 = cvar("vv_set");
//			vv_set = cvar("vv_set");
			cvar_set("vv_set","0");
		}
*/	
		else if (self.impulse == 10)
		{
			if (vv_chg == 0)
			{
				vv_o_0_x = vv_o_0_x + vv_incr;
				centerprint3(self, " --- o_X:  ", ftos(vv_o_0_x), "\n");
			}
			else if (vv_chg == 1)
			{
				vv_o_0_y = vv_o_0_y + vv_incr;
				centerprint3(self, " --- o_Y:  ", ftos(vv_o_0_y), "\n");
			}
			else if (vv_chg == 2)
			{
				vv_o_0_z = vv_o_0_z + vv_incr;
				centerprint3(self, " --- o_Z:  ", ftos(vv_o_0_z), "\n");
			}
			else if (vv_chg == 3)
			{
				vv_a_0_x = vv_a_0_x + vv_incr;
				centerprint3(self, " --- a_X:  ", ftos(vv_a_0_x), "\n");
			}
			else if (vv_chg == 4)
			{
				vv_a_0_y = vv_a_0_y + vv_incr;
				centerprint3(self, " --- a_Y:  ", ftos(vv_a_0_y), "\n");
			}
			else if (vv_chg == 5)
			{
				vv_a_0_z = vv_a_0_z + vv_incr;
				centerprint3(self, " --- a_Z:  ", ftos(vv_a_0_z), "\n");
			}
			else if (vv_chg == 6)
			{
				vv_x_0_y = vv_x_0_y + 1; // frame only changes by 1
				centerprint3(self, " --- (frame) x_X:  ", ftos(vv_x_0_y), "\n");
			}
			else if (vv_chg == 7)
			{
				vv.vwepent.viswframe = vv.vwepent.viswframe + 1; // frame only changes by 1
				if (vv.vwepent.viswframe > 49) vv.vwepent.viswframe = 1;
				if (vv.vwepent.viswframe < 1) vv.vwepent.viswframe = 49;
				centerprint3(self, " --- v slot:  ", ftos(vv.vwepent.viswframe), "\n");
				vv_load(vv.vwepent.viswframe);
			}
			else if (vv_chg == 8)
			{
				vv_cpy = vv_cpy + 1;
				centerprint3(self, " --- copy from frame:  ", ftos(vv_cpy), "\n");
			}
			else if (vv_chg == 10)
			{
				vv.angles_y = vv.angles_y + vv_incr;
				centerprint3(self, " --- (vv rotate) vv_Y:  ", ftos(vv.angles_y), "\n");
			}
			else if (vv_chg == 11)
			{
				vv.angles_x = vv.angles_x + vv_incr;
				centerprint3(self, " --- (vv pitch) vv_X:  ", ftos(vv.angles_x), "\n");
			}

			if (vv_chg < 7)
				vv_load(0 - vv.vwepent.viswframe);
		}
		else if (self.impulse == 12)
		{
			if (vv_chg == 0)
			{
				vv_o_0_x = vv_o_0_x - vv_incr;
				centerprint3(self, " --- o_X:  ", ftos(vv_o_0_x), "\n");
			}
			else if (vv_chg == 1)
			{
				vv_o_0_y = vv_o_0_y - vv_incr;
				centerprint3(self, " --- o_Y:  ", ftos(vv_o_0_y), "\n");
			}
			else if (vv_chg == 2)
			{
				vv_o_0_z = vv_o_0_z - vv_incr;
				centerprint3(self, " --- o_Z:  ", ftos(vv_o_0_z), "\n");
			}
			else if (vv_chg == 3)
			{
				vv_a_0_x = vv_a_0_x - vv_incr;
				centerprint3(self, " --- a_X:  ", ftos(vv_a_0_x), "\n");
			}
			else if (vv_chg == 4)
			{
				vv_a_0_y = vv_a_0_y - vv_incr;
				centerprint3(self, " --- a_Y:  ", ftos(vv_a_0_y), "\n");
			}
			else if (vv_chg == 5)
			{
				vv_a_0_z = vv_a_0_z - vv_incr;
				centerprint3(self, " --- a_Z:  ", ftos(vv_a_0_z), "\n");
			}
			else if (vv_chg == 6)
			{
				vv_x_0_y = vv_x_0_y - 1; // frame only changes by 1
				centerprint3(self, " --- (frame) x_X:  ", ftos(vv_x_0_y), "\n");
			}
			else if (vv_chg == 7)
			{
				vv.vwepent.viswframe = vv.vwepent.viswframe - 1; // frame only changes by 1
				if (vv.vwepent.viswframe > 49) vv.vwepent.viswframe = 1;
				if (vv.vwepent.viswframe < 1) vv.vwepent.viswframe = 49;
				centerprint3(self, " --- v slot:  ", ftos(vv.vwepent.viswframe), "\n");
				vv_load(vv.vwepent.viswframe);
			}
			else if (vv_chg == 8 && vv_cpy > 0)
			{
				vv_cpy = vv_cpy - 1;
				centerprint3(self, " --- copy from frame:  ", ftos(vv_cpy), "\n");
			}
			else if (vv_chg == 10)
			{
				vv.angles_y = vv.angles_y - vv_incr;
				centerprint3(self, " --- (vv rotate) vv_Y:  ", ftos(vv.angles_y), "\n");
			}
			else if (vv_chg == 11)
			{
				vv.angles_x = vv.angles_x - vv_incr;
				centerprint3(self, " --- (vv pitch) vv_X:  ", ftos(vv.angles_x), "\n");
			}

			if (vv_chg < 7)
				vv_load(0 - vv.vwepent.viswframe);
		}
		else if (self.impulse == 1)
		{
			if (vv == world)
			{
				vv = spawn();
				setmodel(vv, "progs/player.mdl");
//				setmodel(vv, "progs/baseq2/players/male/tris.md2");
				setorigin(vv, self.origin);
				vv.vwepent = spawn();
//				setmodel(vv.vwepent, "progs/vw_bear.1.mdl");
//				setmodel(vv.vwepent, "progs/vw_axe.1.mdl");
//				setmodel(vv.vwepent, "progs/shovel.md3");
//				setmodel(vv.vwepent, "progs/vw_shovel.mdl");
//				setmodel(vv.vwepent, "progs/vw_q2_rock2.mdl");
//				setmodel(vv.vwepent, "progs/vw_airgun2b.mdl");
				setmodel(vv.vwepent, "progs/vw_q3_grap.mdl");
//				setmodel(vv.vwepent, "progs/lzrbm_seg.mdl");
//				setmodel(vv.vwepent, "maps/vs_vent_main_.bsp");
//				vv.vwepent.skin = 2;
//				setmodel(vv.vwepent, "progs/bit.mdl");
				setorigin(vv.vwepent, self.origin);
				vv.vwepent.viswframe = 1; // get / save data for this var slot
				vv_load(vv.vwepent.viswframe);
				if (0)
				{
					vv.eweapon = spawn();
					setmodel(vv.eweapon, "progs/vw_harp.mdl");
//					setmodel(vv.eweapon, "progs/baseq2/players/male/w_rlauncher.md2");
//					setmodel(vv.eweapon, "progs/vw_q2_rock.mdl");
//					setmodel(vv.eweapon, "progs/vw_axe.mdl");
					setorigin(vv.eweapon, self.origin);
					vv.eweapon.alpha = 0.85;
				}
			}
		}
		else if (self.impulse == 4) // print data by frame val
		{
//			vv_load_0(vv.frame); - get current stored data
			vv_print(vv_prf);
			vv_prf = vv_prf + 1;
		}
		if (self.impulse == 5 || ((self.impulse == 10) && vv_chg == 9)) // frame inc
		{
			vv_prf = vv.frame = vv.frame + 1; // frame only changes by 1
			vv.vwepent.viswframe = vv.vwepent.viswframe + 1; // frame only changes by 1
			if (vv.vwepent.viswframe > 49) vv.vwepent.viswframe = 1;
			if (vv.vwepent.viswframe < 1) vv.vwepent.viswframe = 49;
			vv.vwepent.noise1 = ftos(vv.frame);
			centerprint5(self, " --- mdl frame:  ", vv.vwepent.noise1," --- v slot:  ", ftos(vv.vwepent.viswframe), "\n");
			vv_load(vv.vwepent.viswframe);
		}
		else if ((self.impulse == 6 || ((self.impulse == 12) && vv_chg == 9)) && vv.frame > 0) // frame dec
		{
			vv_prf = vv.frame = vv.frame - 1; // frame only changes by 1
			vv.vwepent.viswframe = vv.vwepent.viswframe - 1; // frame only changes by 1
			if (vv.vwepent.viswframe > 49) vv.vwepent.viswframe = 1;
			if (vv.vwepent.viswframe < 1) vv.vwepent.viswframe = 49;
			vv.vwepent.noise1 = ftos(vv.frame);
			centerprint5(self, " --- mdl frame:  ", vv.vwepent.noise1," --- v slot:  ", ftos(vv.vwepent.viswframe), "\n");
			vv_load(vv.vwepent.viswframe);
		}
		else if (self.impulse == 8) // copy val fwd one - or copy from
		{
			if (!vv_cpy)
				vv_load(0 - (vv.vwepent.viswframe + 1));
			else // get val from frame vv_cpy
			{
				local float f;

				f = vv.vwepent.viswframe + vv_cpy - vv.frame;
				if (f >0)
				{
					vv_load(f);
					if (vv_o_000 == v0 && vv_o_000 == v0 && vv_o_000 == v0) // get base frame if this frame is 0'ed
					{
						vv_load_0(vv_cpy);
						vv_o_0 = vv_o_0 + vv_o_000;
						vv_a_0 = vv_a_0 + vv_a_000;
						vv_x_0 = vv_x_0 + vv_x_000;
					}
				}
				vv_load(0 - vv.vwepent.viswframe); // save where we are
			}

			vv_load_0(vv.frame); // reload
			
//			if (cvar("saved2") > 0) vv.vwepent.frame = cvar("saved2"); // testing vwep frames - have to disable below

		}
		else if (self.impulse == 13) 
		{
			bprint("\n-----------------\n");
			bprint("   1 - init models\n");
			bprint("   2 - loop increment\n");
			bprint("   3 - value edit loop\n");
			bprint("   4 - print data to console for current frame & incr print frame\n");
			bprint("   5 - mdl frame increment\n");
			bprint("   6 - mdl frame dec\n");
			bprint("   8 - copy cur data down 1 slot or from any slot\n");
			bprint("   10  val incr - wheel up\n");
			bprint("   12  val dec - wheel down\n");
			bprint("-----------------\n");
		}

		local vector v1, v2, v3, v4;

		vv_pa = vv.angles_x; // set pitch adjust
//		vv_load_0(vv.frame); // get current stored data
//		vw_melee_base(vv.frame); // get actual data - generic
//		vw_q3_gaunt(vv.frame); // get actual data - specific
		vw_q3_grap(vv.frame); // get actual data - specific

		v1 = vv.angles;
		v1_x = 0 - v1_x; // must reverse pitch for proper position from v_fwd calc
		makevectors( v1 );

		v2 = (vv_o_0_x + vv_o_000_x) * v_forward;
		v3 = (0 - (vv_o_0_y + vv_o_000_y)) * v_right;
		v4 = (vv_o_0_z + vv_o_000_z) * v_up;

		setorigin(vv.vwepent, vv.origin + v2 + v3 + v4); 
		vv.vwepent.angles = vv.angles + vv_a_0 + vv_a_000;

		if (cvar("vv_pitch"))
		{
//		vv.vwepent.angles_x = vv_a_0_x + vv_a_000_x; // default - remove effect of pitch - works good on certain frames

			if (cvar("vv_pitch") < 2) 

			if (vv_x_000_x == -666) vv.vwepent.angles_x = vv_a_0_x + vv_a_000_x - vv.angles_x;
			else
			{
				if (vv_x_000_x) vv.vwepent.angles_x = vv.angles_x + vv_a_0_x + vv_a_000_x + (vv.angles_x * vv_x_000_x);
				if (vv_x_000_z) vv.vwepent.angles_z = vv.angles_z + vv_a_0_z + vv_a_000_z + (vv.angles_x * vv_x_000_z);
			}


if (cvar("vv_pitch") == 2)
if (vv_a_0_x != x1 || vv_a_0_z != z1)
{
	x1 = vv_a_0_x;
	z1 = vv_a_0_z;
bprint(" --- pitch:  ");
bprint(ftos(vv.angles_x));
bprint(" --- frame:  ");
bprint(ftos(vv.frame));
bprint(" - mod - x:  ");
bprint(ftos( vv_a_0_x / vv.angles_x));
bprint(" - mod - z:  ");
bprint(ftos( vv_a_0_z / vv.angles_x));
bprint("\n");
}


		}
		vv.vwepent.frame = vv_x_0_y + vv_x_000_y;
		setorigin(vv.eweapon, vv.origin);
		vv.eweapon.angles = vv.angles;
//		vv.eweapon.frame = vv.frame + 233; // run fired
//		vv.eweapon.frame = vv.frame + viswaddf - melee_frames;
		vv.eweapon.frame = vv.frame + viswaddf;
//		vv.eweapon.frame = vv.frame; // q2  set

		self.impulse = 0;
	}

};













