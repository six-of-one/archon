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

	if (!VW) PK_MELEE = PK_IT_AXE;

	c = FALSE;

	if (e.eweapon)
	if (e.eweapon.style == FL_MELEE_WEP) // moved above pkw because of harpoon slot use by other graps
		c = TRUE;

	if (pkw)
	{
		if (pkw & PK_MELEE) c = TRUE;
		return(c);
	}

	if (qw & Q_MELEE) c = TRUE;

//	if (mc >= MC_CARRYABLE) c = TRUE; // demolition inventory bits hack
	return(c);
};

float(entity e, float qw, float pkw) FL_RANGE =
{
	local float Q_RANGE, PK_RANGE;
	local float c;

	Q_RANGE = IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	PK_RANGE = PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT;

	if (!VW) PK_RANGE = PK_RANGE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;

	c = FALSE;

	if (pkw & PK_RANGE) c = TRUE;
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

	if(e.pk_gravitywellammo != 0) nbits = nbits | PK_IT_GRAVITYWELL;
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

// remove all vw ents - intermission, finale

void() vw_remove =
{
	local entity f;
	f = find(world,classname,"viswep");
	while (f)
	{
		setattachment(f, world, null_string); // clear attachs - in case
		remove(f);
		f = find(f,classname,"viswep");
	}
};

// fn(vw_chain) - chain up viswep for an ent, rebuild vwepent list(s)

// e - ent we want viswep for

entity(entity e) vw_chain =
{
	local entity f, c, ch;
	local float rck;

	c = world;
	ch = e;
	f = find(world,classname,"viswep");
//	sf = 50;
	rck = FALSE;

	while (f) // && sf > 0)
	{
		if (f.owner.deadflag || f.owner.classname == OBSERVER) // wep found with non owner - should not EVAR happen...evar!
		{
			f.owner.vwepent = world;
			f.vwepent = world;
			setattachment(f, world, null_string); // clear attachs
			if (f.wad != "packwep") // pack deal
				remove(f);				
			else
				f.owner = world; // should never - when converted this should be fixed
		}
		else
		if (f.owner == e)
		{
			if (!c) c = f;
			if (ch) ch.vwepent = f; // this becomes a list rebuild
			ch = f;
			f.vwepent = world; // unlink old stuff
		}

		f = find(f,classname,"viswep");
//		sf = sf - 1;
	}
	return (c);
};

/*

fn(viswep_ofs) - set viswep offsets for some morphs - gremlin repos deal

// e - viswep entity
// l - load entity
// flg - op condition

float SET_ARMED =		1; // ready weps
float SET_STORED =		2; // stored weps
*/

vector(entity e, entity l /*, float flg */) viswep_ofs =
{
	local vector v;

	v = '0 0 0';

	if (l.mask_x & CB_GREMLIN)
		{
/*
		if (flg == SET_ARMED)
			{
			v = '0 0 0';
			}
		else
			{ */
		if (FL_MELEE(e, e.weapon, e.pk_currentitem))
			v = ' 6 -4 4';
		else
			{
			if (e.weapon == IT_ROCKET_LAUNCHER) // NOTE: not a total assumpt here - all weps need verified for this now IMP: perhaps use a bit mask?
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

	md = null_string;
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
//	tr.vwepent.touch = touch_theft; // sticky little gremlin claws abound // IMP: gremlin theft, some way or other

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
	else if (fl < 0) md = null_model; // special cases - set own model
	if (md == null_string) md = VW_DEFGUN;
	tr.vwepent.mdl = md;
	if (fl >0 && fl != IT_AXE && !VW) md = VW_DEFGUN;
	setmodel(tr.vwepent, md);

	if (fl > 0) tr.vwepent.mcode = wepbit_mcode(fl, "Q");


#ifdef warning
		if (WARNING & 16384)
		{
			bprint("   *** warning: vw loading - ");
			bprint(e.netname);
			if (!pkvl)
			{
			bprint(" - md: ");
			bprint(md);
			bprint(" - mc: ");
			bprint(ftos(tr.vwepent.mcode));
			bprint(" - flg: ");
			bprint(ftos(fl));
			bprint("\n");
			}
		}
		pkvl = 0;
#endifdef


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


#ifdef warning
			pkvl = 1;
#endifdef


	tr = vload(e, IT_AXE);

	md = null_string;
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

	if (md == null_string ) md = VW_DEFGUN;
	tr.mdl = md;
	if (!VW) md = VW_DEFGUN;
	setmodel(tr, md);

	if (fl == PK_IT_GRAVITYWELL)
	if (e.pk_gravitywellammo == -1)
		tr.skin = 1;

	tr.mcode = wepbit_mcode(fl, "PK2");

#ifdef warning
		if (WARNING & 16384)
		{
			bprint(" - md: ");
			bprint(md);
			bprint(" - mc: ");
			bprint(ftos(tr.mcode));
			bprint(" - flg: ");
			bprint(ftos(fl));
			bprint("\n");
		}
		pkvl = 0;
#endifdef


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

	e.weaponmodel = null_string; // for morphs that dont make vwep from pki
	vw_chain(e); // fired carryable, pre chain
	f = vchk(IT_AXE, pkbt, e.vwepent);

	if (f)
	{
		f.vwepent = world;
		setattachment(f, world, null_string);
		remove(f);
		vw_chain(e); // cary item removed - rechain
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

	if (cd < 0)
	{
		if (e) // because we may come here with self = first viswep ent
		{
			if (e.classname != "viswep") // NOTE: if cond fails, we have a viswep left!
				e.vwepent = world;
		}

		while (tr)
		{
			pr = tr;
			tr = tr.vwepent;
//			pr.mdl = null_string;
			setattachment(pr, world, null_string); // clear attachs
			pr.vwepent = world;
			if (pr.wad != "packwep") // pack deal
				remove(pr);
		}


//		if (cd == -3)
//		{
//			self.vwepent = spawn();
//			self.vwepent.delay = time + 1;
//		}
		return;
	}
	
	pkbits = mk_pkbits(e);

// have items & check for inventory
	while (tr)
	{
		pr = world;
		if (tr.armortype && VW_ARMOR) // armor visuals
		{
			at = e.armortype;
			if (!at)
			{
//				tr.mdl = null_string;
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = null_string;
				pr = tr.vwepent;
				tr.vwepent = world;
				setattachment(tr, world, null_string);
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
					setattachment(tr, world, null_string); // clear attachs
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
//				tr.mdl = null_string;
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = null_string;
//				pr.vwepent = tr.vwepent;
				pr = tr.vwepent;
				tr.vwepent = world;
				setattachment(tr, world, null_string); // clear attachs
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
	if (rmv) vw_chain(e); // removed something during viswep_ld - add / check

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
		if (!self.mask_x & (CB_GREMLIN | CB_HUMAN)) return; // CHECK: back - will any morph ever have pki vws?

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
//	string wmr;

	if (wpm == "progs/v_w_mortar.mdl") return(TRUE);
	else if (wpm == "progs/v_d_rock.mdl") return(TRUE);
//	else if (wpm == null_string) return(TRUE);

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

void() viswep_post =
{
	local entity vhead;
	local float qld, pkbits, vwc, hr1, drw;
	local string vmdl;

//	if (!self.flags & FL_CLIENT) return;
	self.vw_frame = framecount;

//	vw_chain(self);

														// NOTE: check this vs. invisibility for norm & morphs
	if (self.deadflag || self.classname == OBSERVER || self.view_ofs == '0 0 0' || self.model == null_string) //(self.admin && self.admin != USER-MENU)) //intermission_running)
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

	if (!vhead)
		viswep_ld(self, 1);
	else
	{
		if (self.items & qweps != vhead.items) qld = TRUE;
		if (!qld && vhead.armorvalue != self.armortype) qld = VW_ARMOR; // if vw armor display - update on armor changes

		if (vhead.pk_items != pkbits || qld) viswep_ld(self, 1);
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
		if (vhead.owner) // Cataboligne - 10.10.11 - REMOVE: interim - world is getting viswframe set to this val
			vhead.owner.viswframe = -1; // NOTE: remove to use visframe code anywhere - ? what does this mean ?
//		else
//			bprint(" ---------- NOTE: vhead.owner == world\n"); // REMOVE:
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

			// for csqc hud - set players mcode to the mcode in the vwepent of the currently held weapon - this *should* always work
			if (vhead.mcode != MC_PULSE_NAILGUN)
			if (vhead.model == "progs/vw_pnailg.mdl")
				vhead.mcode = MC_PULSE_NAILGUN; // hack, but HUD needs to see this
	
			vhead.owner.mcode = vhead.mcode;

			if (self.class_select == "class_player")
			if ( !(self.cam_x & CHSCAM_ON))
			{
				if (vhead.owner.eweapon)
				{
					if (vhead.owner.eweapon.grap_state != 666000)
					if (vhead.owner.eweapon.weaponmodel != vhead.owner.weaponmodel) PK_SetCurrentAmmo();
				}
				else
					if (ver_weaponmodel(vhead.owner.weaponmodel)) PK_SetCurrentAmmo();
//							if (wm != vhead.owner.weaponmodel) vhead.owner.weaponmodel = wm;
				if ((vhead.owner.prevweapon != vhead.owner.weapon) || (vhead.owner.pkprevweapon != vhead.owner.pk_currentitem) || (vhead.owner.forcewchange == 1)) PK_SetCurrentAmmo();
			}
			else	if ((vhead.owner.prevweapon != vhead.owner.weapon) || (vhead.owner.pkprevweapon != vhead.owner.pk_currentitem) || (vhead.owner.forcewchange == 1)) PK_SetCurrentAmmo();
		}
		else
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
				if (!vwc) vhead.model = null_string;
			}
			else if (!VW_HOLSTER) // dont show holstered weps / items
			{
				vwc = FALSE; // dont updated this viswep (only held gun)
				vhead.model = null_string;
			}
		}

		if (!self.mask_x & CB_GREMLIN)
		if (!self.mask_x & CB_HUMAN)
		{
			if (vhead.wad != "art_shell")
			{
				vhead.model = null_string;
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
		if (vhead.owner.items & IT_INVISIBILITY) vhead.model = null_string; // heh heh, player invisible - NOTE: art shells may be still visible when invisible
		else if (vhead.owner.eweapon.model == "progs/vw_w_2chaing.mdl" && vhead.mdl == "progs/vw_w_chaing.mdl") vhead.model = null_string; // hack to get rid of single chain gun vw_ when dbl chg selected
//		else if (vhead.vv_draw != (void()) 0) // new vw paradigm - code set models
		else if (vhead.vv_draw) // new vw paradigm - code set models
		{
			if (0) // off for now IMP: fix rotate issues
			if (DARKPLACES)
			if (!vhead.tag_entity)
			{
				vhead.origin = vhead.angles = v0;
				setattachment(vhead, vhead.owner, null_string);
			}

			if (vhead.model == null_string || (((vhead.oldorigin + vofs) != vhead.owner.origin || vhead.mangle != vhead.owner.angles) && (!vhead.tag_entity) ) || vhead.weaponframe != vhead.owner.frame) // update track
			{
				if (vhead.model == null_string) setmodel(vhead, vmdl);

				vhead.oldorigin = vhead.owner.origin; // track player data, but viswep values are all diffferent
				vhead.mangle = vhead.owner.angles;
				vhead.weaponframe = vhead.owner.frame;

				vv_pa = vhead.owner.angles_x; // set pitch detect adjust
				if (drw) vhead.vv_draw(vhead.owner.frame);
//				else if (vhead.vv_holster != (void()) 0) vhead.vv_holster(vhead.owner.frame);
				else if (vhead.vv_holster) vhead.vv_holster(vhead.owner.frame);
				else vwc = FALSE; // no display - no frames!

				if (vwc)
				{
					if( ! (vhead.owner.cam_x & CHSCAM_ON) ) vhead.exteriormodeltoclient = vhead.owner; // darkplaces - works for dp!
					else vhead.exteriormodeltoclient = world;


					if (drw) vofs = v0;
					local vector v2, v3, v4;

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
					vhead.model = null_string;
			}
		}
		else // old method - brute force animated models
		{
			if (DARKPLACES)
			if (!vhead.tag_entity)
			{
				vhead.origin = vhead.angles = v0;
				setattachment(vhead, vhead.owner, null_string);
			}
			if (vhead.model == null_string || ((vhead.origin + vofs) != vhead.owner.origin || (vhead.angles != vhead.owner.angles) && (!vhead.tag_entity) ) || vhead.weaponframe != vhead.owner.frame) // update track
			{
				if (vhead.model == null_string) setmodel(vhead, vmdl);
				vhead.weaponframe = vhead.owner.frame; // track player frame, vw .frame may not match

				vframe = vhead.owner.frame;
																			// adjust for gremlin flying frames & carried gun
				if (vhead.owner.model == "progs/gremlin-fly.mdl" && vhead.owner._stand == gremlin_hover && vhead.owner.frame >= grem_fly_frame) gremlin_frame_adjust = grem_fly_frame;
		
				if( ! (vhead.owner.cam_x & CHSCAM_ON) ) vhead.exteriormodeltoclient = vhead.owner; // darkplaces - works for dp!
				else vhead.exteriormodeltoclient = world;

				if (!VW)
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
	local vector v2, v3, v4;

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
	newmis.classname = "thrownwep";
	newmis.mask_x = CB_HUMAN + CB_GREMLIN;

	if (e.eweapon) // note: even though newmis is spawned for the thrown item, eweapon is kept around, because threw weps use backpack touch code
	{


#ifdef warning
		if (WARNING & 16384)
		{
			bprint(" *** warning: dead threw - ");
			bprint(e.netname);
			bprint(" - slot: ");
			bprint(ftos(e.weapon));
			bprint("\n");
		}
#endifdef


		newmis.eweapon = e;
		newmis.noise = e.noise;
		newmis.eweapon.wad = "packwep";
		newmis.eweapon.model = null_string;
		newmis.eweapon.owner = newmis;
		newmis.eweapon.think = 
		newmis.eweapon.touch = SUB_Null;
		newmis.eweapon.nextthink = -1;
		newmis.eweapon.stack1 = "threw"; // left in to id these
		newmis.eweapon.exteriormodeltoclient = world;
		newmis.eweapon.classname = item_by_mcode(newmis.eweapon.mcode); // for touch
		newmis.netname = newmis.eweapon.netname;
		newmis.eweapon.items = e.weapon;
		setattachment(e, world, null_string); // clear attachs
		if (p) xwep_ammo(newmis.eweapon, p);
		newmis.mask_x = e.mask_x;
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

// better set masks or any morph can get them
			if (newmis.items & (IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING))
				newmis.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;
			else
			if (newmis.items & (IT_NAILGUN | IT_SUPER_NAILGUN))
				newmis.mask_x = CB_HUMAN+ CB_GREMLIN + CB_OGRE;
		}
		else // pki
		{
//			if (newmis.items == IT_AXE)
			newmis.pk_currentitem = newmis.pk_items = e.pk_currentitem; // Cataboligne - 9.6.11 - fixes a bug in the pk1.1 source!
			newmis.mask_x = CB_HUMAN + CB_GREMLIN;

			if (newmis.pk_items == PK_IT_CLIGHT)
			{
				newmis.lip = e.lip = wepbit_mcode(IT_LIGHTNING, "QA");
				newmis.ammo_cells = newmis.currentammo = e.currentammo = wepbit_mcode(IT_LIGHTNING, "QAC") * 2;
				newmis.mask_x = CB_HUMAN + CB_ENF + CB_GREMLIN;
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
			if (newmis.pk_items & PKID)
			{
				newmis.mask_x = MORPH_ALL;
				newmis.noise = "misc/pickup/tone2.wav";
			}
		}


#ifdef warning
		if (WARNING & 16384)
		{
			bprint(" *** warning: dead threw - ");
			bprint(ftos(newmis.lip));
			bprint(" - w-mc: ");
			bprint(ftos(e.mcode));
			bprint(" - slot: ");
			bprint(ftos(e.weapon));
			bprint("\n");
		}
#endifdef


	}

//	newmis.flags = FL_ITEM; // not making these large
	newmis.solid = SOLID_TRIGGER;
	newmis.movetype = MOVETYPE_TOSS;
	if (e.owner)
		setorigin(newmis, e.owner.origin); // fix morph toss issues
	else
		setorigin(newmis, e.origin);

	setmodel (newmis, md);
	setsize (newmis, '-12 -12 -6', '12 12 12');

// Cataboligne - 11.11.12 - fix morphs beng able to pickup weps they shouldnt
//	- also may have fixed some un-ided bot issues
	newmis.touch = painkeep_touch;
	newmis.pk_touch = BackpackTouch;

	item_eject(newmis, '210 210 240'); // velocity to toss - IDEA: use directional of corpse moving (blast, etc)
	newmis.think = remove_fade; //SUB_Remove; // dont just blink, fade or melt out of level
	if (DEAD_THROW_TIME)
	{
		newmis.nextthink = time + DEAD_THROW_TIME;
		if (newmis.eweapon)
			dyn_remove(newmis.eweapon, DEAD_THROW_TIME + 1, SUB_Null); // set up an eventual remove if wep uncollected
	}

	AddToSplash(newmis); // *pk - splash tossed items
};

// fn(DeadThrowWeps) - handel throwing weapons out on death

// DEAD_THROW - sv_dead_throw
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

void(entity pack, vector pv1) DeadThrowWeps =
{
	local entity e;
	local float w, pkid, pd;

	e = self.vwepent;

	if (!e || !DEAD_THROW) return;


#ifdef warning
		if (WARNING & 16384)
		{
			bprint(" *** warning: dead throwing for - ");
			bprint(self.netname);
			bprint("\n");
		}
#endifdef


	if (!DEAD_THROW_PKI || DEAD_THROW_PKI == 2) // not throwning or just gone - set mask
		pkid = PKID;

//	pkw = PK_IT_GRAPGUN + PK_IT_AIRGUN + PK_IT_CLIGHT;
//	pkpid = PKPLUS_IT_EGO + PKPLUS_IT_TOMB + PKPLUS_IT_ACTOR;

	while (e)
	{
		pd = w = FALSE;
		while (pkid & e.pk_currentitem || e.weapon < 0) e = e.vwepent; // skip painkeep items as detailed by bit mask

		if (!e) return; // ran off end of card

		if (pack && (!pack.flags & FL_CLIENT))
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

		if (DEAD_THROW_NOWAY)
		if (noway_below)
		if (e.origin_z < noway_below) pd = FALSE;
		if (noway_above)
		if (e.origin_z > noway_above) pd = FALSE;

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
//			if (vhead.vv_draw != (void()) 0) // IMP: dead throw framing or animation for these
//			else
//				if (e.vv_draw == (void()) 0) // not the alternate vw animation - so it should have deadthrow frames
				if (!e.vv_draw) // not the alternate vw animation - so it should have deadthrow frames
				{
					e.frame = $dthrow1 + rint(random() * 4);
				}

				if (!w) // not live
				{
					DeadThrew(e, e.mdl, world);
					newmis.touch = SUB_Null;
				}
				else												{
					DeadThrew(e, e.mdl, pack);
}


				newmis.frame = e.frame;
				if (newmis.origin == v0) setorigin(newmis, pv1);
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










