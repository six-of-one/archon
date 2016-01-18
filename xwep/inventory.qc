/* ::-::
 *
 * Cataboligne
 *
 * file: inventory.qc
 *
 * date: 9/30/11
 *
 * qc - support chaos mod inventory contols
 *
 */

/*
		+---------------------------------------+
		|  inventory defaults and loading       | SEC-HEAD
		+---------------------------------------+
*/

// fn(xwep_fakeload) - extra weapon fake load - carried something between levels and it doesnt exist on new level

// self - map weapon ent (fake loaded) NOTE: code does not load for self! 
//...or 1 of these 2... --- what code really does
// mcd - map code - overrides spf
// spf - spawn func, in either case this code handles load up
// islot - inventory slot (weapon bit 1 - 128, 4096)

// ve - viswep ent
// camct - current ammo cnt

void(entity ve, float camct, float mcd, string spf, float islot) xwep_fakeload =
{
	local string spt; // spawn this temp
	local entity sv;
	local float camctp; // value to pass - sending negative as code

	if (!ve) return;

	sv = self;
	spt = spf;

	if (mcd)
	{
		spt = item_by_mcode(mcd);
	}
	if (spt) // spawn this
	{
		self = spawn();
		self.event = "dynamic_item"; // stop item_call from doing a bunch of stuff - if not removed this will spawn the item somewhere
		item_call(spt);
		self.think = SUB_Remove;
		self.nextthink = time + 10;
		self.event = ""; // so pk_mcode will give us valid mcode
		self.mcode = pk_mcode(spt, self); // put map code on ent

		if (camct < 1) camctp = -0.5;
		else camctp = 0 - camct;

		x_wep_store(ve, islot, camctp);
		remove(self);
	}

	self = sv;
}

// fn(set_q1w_defammo) if new q1 defs are set by bit and no ammo is added for that wep, set base amount

void(float wb, entity e) set_q1w_defammo =
{
	if (wb & (IT_SHOTGUN | IT_SUPER_SHOTGUN)) if (e.ammo_shells < 1) e.ammo_shells = DEF_AMMO_BASE;	// 25
	if (wb & IT_MJOLNIR) if (e.ammo_cells < 1) e.ammo_cells = DEF_AMMO_BASE * 3;
	if (wb & IT_LIGHTNING) if (e.ammo_cells < 1) e.ammo_cells = DEF_AMMO_BASE * 2;	
	if (wb & (IT_ROCKET_LAUNCHER | IT_GRENADE_LAUNCHER)) if (e.ammo_rockets < 1) e.ammo_rockets = DEF_AMMO_BASE / 2.5;	
	if (wb & (IT_NAILGUN | IT_SUPER_NAILGUN)) if (e.ammo_nails < 1) e.ammo_nails = DEF_AMMO_BASE * 2;	
};

// fn(new_q1w_defammo) see if more q1 weps got set after set_xweap, if so check def ammo

void(float wb, float ic, entity e) new_q1w_defammo =
{
	local float f;

	if (!wb) return;
	if (!e) return;
	f = 1;
	while (f != 256)
	{
		if ((wb & f) && !(ic & f))
			set_q1w_defammo(f, e);
		f = f * 2;
	}
};

void(entity xw, entity e) set_xw_defammo =
{
	if (xw.lip == AMMO_BULLETS) if (e.ammo_bullet < 1) e.ammo_bullet = DEF_AMMO_BASE * 2;	
	if (xw.lip == AMMO_SHELLS) if (e.ammo_shells < 1) e.ammo_shells = DEF_AMMO_BASE;	// 25
	if (xw.lip == AMMO_CELLS) if (e.ammo_cells < 1) e.ammo_cells = DEF_AMMO_BASE * 2;	
	if (xw.lip == AMMO_NAILS) if (e.ammo_nails < 1) e.ammo_nails = DEF_AMMO_BASE * 2;	
	if (xw.lip == AMMO_ROCKETS) if (e.ammo_rockets < 1) e.ammo_rockets = DEF_AMMO_BASE / 2.5;	
	if (xw.lip == AMMO_GRENADES) if (e.ammo_rockets < 1) e.ammo_rockets = DEF_AMMO_BASE / 2.5;	
	if (xw.lip == AMMO_SLUGS) if (e.ammo_slug < 1) e.ammo_slug = DEF_AMMO_BASE / 2.5;	
};

// fn(set_defaults) - server control of player/bot load defaults
// fn(set_xweap) - attemp to load an xweap or q1 wep by map code
// fn(xw_bit_loop) - given a bit set loop thru getting map codes and calling set_xweap for a give map mode

// e - ent to load (player or bot)
// smc - set map code

void(entity e, float smc) set_xweap =
{
	local float wbt;
	local entity tr;
	local string ssc;

	if (!e) return;
	wbt = valid_wep_mcode(smc); // make sure this is a valid weapon & get inv. bit

	if (!wbt || wbt & e.items) return; // no bit or already got one - IDEA: code an axe swap ??

	if ((smc >= MC_AXE && smc <= MC_THUNDER) || smc == MC_HIP_MJOLNIR) // NOTE: q1 weapon map codes MUST be sequential for condition here
	{
		e.items = e.items | wbt;
		set_q1w_defammo(wbt, e);
		return;
	}
	ssc = item_by_mcode(smc);
	if (ssc) tr = vload(e, wbt);
	if (tr)
	{
		xwep_fakeload (tr, 0, 0, ssc, wbt);
		e.items = e.items | tr.items;
		if (! e.pk_items & tr.pk_currentitem)
			e.pk_items = e.pk_items | tr.pk_currentitem;
		set_xw_defammo(tr, e); // make sure we have ammo
	}

};

// fn(xw_parm) - handle xweps for level chg

// e - player / bot to handle

// bit information is continuously maintained in player / bot .mcode & .scode
// scode - bits to remove from items so xweap are not converted into regular weps
// mcode - map code of unholstered xweap to reload after level change

void (entity e) xw_parm =
{
	local entity tr;

	tr = e.vwepent;
	e.scode = 0;

	if (X_CHGLVL)
	if (e.eweapon)
		e.mcode = e.eweapon.mcode; // last unholstered eweap kept over lvl change

	while (tr)
	{
		if (tr != e.eweapon)
		{
			if (tr.netname == "Grappling hook") e.scode = e.scode | 512; // special - grapples
			else
			if (tr.eweapon) e.scode = e.scode | (tr.weapon & 254); // only clear std weps - must have axe & shotgun on new level
		}
		tr = tr.vwepent;
	}
};

void(entity e, float bl) xw_bit_loop =
{
	local float f, b, mc;

	if (!bl) return;
	if (!e) return;
	f = 1;
	while (f != 8192)
	{
		b = bl & f;
		mc = wepbit_mcode(b, MAP_MODE);
		if (mc)
			set_xweap(e, mc);
		f = f * 2;
		if (f == 256) f = IT_AXE;
	}
}

// e - ent to set (player or bot)
// defaults read from server var *


// NOTE: q1 & pk mode wep add can be without ammo

void(entity e) set_defaults =
{
	local float ic, i0;

// here in case chase cam code doesnt get run - setnewparms may not hit these
	e.eweapon = world;
	e.pkprevweapon = e.pklastweapon = e.prevweapon = e.lastweapon = 0;

	e.x_items = x_item_dm_giveaway; // for door keys in dm - only set by doors in dm

	e.ammo_bullet = e.ammo_slug = e.ammo_gaspr = e.ammo_hgrenade = 0;
	e.pkplus_egoammo = e.pkplus_tombammo = e.pkplus_actorammo = e.pkplus_phoneammo = 0;
	e.pk_gravitywellammo = e.pk_turretammo = e.pk_canpabammo = e.pk_beartrapammo = e.pk_explode_ammo = 0;

	if (Q_100 || PK_100) return;

// NOTE: muddy area for morphs.  how to handle all this - maybe convert health by modifier?
//					check to see if morph can use any of the give away eweaps?
	if (!self.mask_x & CB_HUMAN) return;


	if (DEF_HEALTH) e.health = fabs(DEF_HEALTH);
	if (DEF_ARMOR)
	{
		e.armorvalue = fabs(DEF_ARMOR);
		e.armortype = DEF_ATYPE;
		if (e.armorvalue > 100)
		{
			e.armortype = DEF_ATYPE * 2;
			e.items = e.items | IT_ARMOR2;
		}
		else
			e.items = e.items | IT_ARMOR1;
	}

	if (DEF_WEAPON & DEF_REMWEP) // remove any default weps set by code
	{
		e.items = e.items - (e.items & WEP_MASK);
		e.weapon = 0; 
	}

	if (DEF_WEAPON & DEF_REMAMMO) // remove any default ammo set by code
	{
		e.ammo_shells = 0;
		e.ammo_nails = 0;
		e.ammo_rockets = 0;
		e.ammo_cells = 0;
		e.ammo_nails = 0;
		e.ammo_slug = 0;
		e.ammo_gaspr = 0;
	}

	if (DEF_AMMO_BULLETS) e.ammo_bullet = fabs(DEF_AMMO_BULLETS);
	if (DEF_AMMO_SHELLS) e.ammo_shells = fabs(DEF_AMMO_SHELLS);
	if (DEF_AMMO_CELLS) e.ammo_cells = fabs(DEF_AMMO_CELLS);
	if (DEF_AMMO_ROCKETS) e.ammo_rockets = fabs(DEF_AMMO_ROCKETS);
	if (DEF_AMMO_NAILS) e.ammo_nails = fabs(DEF_AMMO_NAILS);
	if (DEF_AMMO_SLUGS) e.ammo_slug = fabs(DEF_AMMO_SLUGS);
	if (DEF_AMMO_GAS) e.ammo_gaspr = fabs(DEF_AMMO_GAS);

	DEF_WEAPON = DEF_WEAPON & WEP_MASK; // mask off remove bits

// x weapon inits

	if (INIT_CON)
	{
		i0 = e.items & WEP_MASK; // if init changes def weps we need to allow for a default it_axe
		if (INIT_CON & FL_INIT_ARB_MC)
		{
			if (INIT_0_W > 0) set_xweap(e, INIT_0_W);
			if (INIT_1_D > 0) set_xweap(e, INIT_1_D);
			if (INIT_2_Q > 0) set_xweap(e, INIT_2_Q);
			if (INIT_3_PK > 0) set_xweap(e, INIT_3_PK);
			if (INIT_4_Q2 > 0) set_xweap(e, INIT_4_Q2);
			if (INIT_5_Q3 > 0) set_xweap(e, INIT_5_Q3);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP);
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_MGEN_BIT) // genre by map using bits
		{
			if (MAP_MODE == "W") xw_bit_loop(e, INIT_0_W);
			if (MAP_MODE == "D") xw_bit_loop(e, INIT_1_D);
			if (MAP_MODE == "Q") xw_bit_loop(e, INIT_2_Q);
			if (MAP_MODE == "PK") xw_bit_loop(e, INIT_3_PK); // really same weps as q1, but allows setting other weps for pk maps
			if (MAP_MODE == "Q2") xw_bit_loop(e, INIT_4_Q2);
			if (MAP_MODE == "Q3") xw_bit_loop(e, INIT_5_Q3);
	//		if (MAP_MODE == "HP") xw_bit_loop(INIT_6_HP);
	//		if (MAP_MODE == "") xw_bit_loop(INIT_7);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); // 2 extra map code weps
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_MGEN_MC) // genre by map using code - 1 per + 2 for all
		{
			if (INIT_0_W > 0 && MAP_MODE == "W") set_xweap(e, INIT_0_W);
			if (INIT_1_D > 0 && MAP_MODE == "D") set_xweap(e, INIT_1_D);
			if (INIT_2_Q > 0 && MAP_MODE == "Q") set_xweap(e, INIT_2_Q);
			if (INIT_3_PK > 0 && MAP_MODE == "PK") set_xweap(e, INIT_3_PK);
			if (INIT_4_Q2 > 0 && MAP_MODE == "Q2") set_xweap(e, INIT_4_Q2);
			if (INIT_5_Q3 > 0 && MAP_MODE == "Q3") set_xweap(e, INIT_5_Q3);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); //  && MAP_MODE == "HP") set_xweap(e, INIT_6_HP); // goes to all for now
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_CGEN_BIT) // genre by char using bits
		{
			if (e.morphy == CHAR_W) xw_bit_loop(e, INIT_0_W);
			if (e.morphy == CHAR_D) xw_bit_loop(e, INIT_1_D);
			if (e.morphy == CHAR_Q) xw_bit_loop(e, INIT_2_Q);
//			if (e.morphy == CHAR_PK) xw_bit_loop(e, INIT_3_PK); // not going to have pk char mode - maybe some other morph class
			if (INIT_3_PK > 0) set_xweap(e, INIT_3_PK);
			if (e.morphy == CHAR_Q2) xw_bit_loop(e, INIT_4_Q2);
			if (e.morphy == CHAR_Q3) xw_bit_loop(e, INIT_5_Q3);
	//		if (e.morphy == "") xw_bit_loop(INIT_7);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); // 2 extra map code weps
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}
		else if (INIT_CON & FL_INIT_CGEN_MC) // genre by char using code - 1 per + 2 for all
		{
			if (INIT_0_W > 0 && e.morphy == CHAR_W) set_xweap(e, INIT_0_W);
			if (INIT_1_D > 0 && e.morphy == CHAR_D) set_xweap(e, INIT_1_D);
			if (INIT_2_Q > 0 && e.morphy == CHAR_Q)set_xweap(e, INIT_2_Q);
//			if (INIT_3_PK > 0 && e.morphy == CHAR_PK) set_xweap(e, INIT_3_PK);
			if (INIT_3_PK > 0) set_xweap(e, INIT_3_PK);
			if (INIT_4_Q2 > 0 && e.morphy == CHAR_Q2) set_xweap(e, INIT_4_Q2);
			if (INIT_5_Q3 > 0 && e.morphy == CHAR_Q3) set_xweap(e, INIT_5_Q3);
			if (INIT_6_HP > 0) set_xweap(e, INIT_6_HP); //  && e.morphy == "HP") set_xweap(e, INIT_6_HP); // goes to all for now
			if (INIT_7 > 0) set_xweap(e, INIT_7);
		}

		ic = e.items & WEP_MASK; // weps set by init - have to see q1 weps added outside of set_xweap
		if (ic != i0)
		if (!DEF_WEAPON)
		if (ic & IT_AXE) DEF_WEAPON = IT_AXE; // allow replacement x weps to default axe bit if present - otherwise we add a q1 shotgun
	}

	if (DEF_ITEMS) e.items = e.items | DEF_ITEMS; // NOTE: this is an add in, might need vw coding later

	if (DEF_WEAPON) // NOTE: happens after weapons inits to be coded
	{
		if (! e.items & DEF_WEAPON) // see if item bit is set
			e.items = e.items | DEF_WEAPON;
		e.weapon = return_bit(DEF_WEAPON, 255, BIT_HIGH, 0); // pick 1 bit - highest
		if (!e.weapon && (e.items & IT_AXE) && (DEF_WEAPON & IT_AXE)) e.weapon = IT_AXE; // can init & def weapon axe as only weapon
	}
	new_q1w_defammo(e.items & WEP_MASK, ic, e);

	if (DEF_X_ITEMS) e.x_items = e.x_items | DEF_X_ITEMS; // NOTE: this might entail vw adds later

	if (!(INIT_CON & FL_INIT_PKO) || (MAP_MODE == "PK")) // can restrict pk items to pk mode only with flag in init_con
	if (DEF_PK_ITEMS & PK_ITEM_MASK) // pk items works differently
	{
		if (DEF_PK_ITEMS & PK_IT_BEARTRAP) e.pk_beartrapammo = 2;
		if (DEF_PK_ITEMS & PK_IT_TURRET) e.pk_turretammo = 2;
		if (DEF_PK_ITEMS & PK_IT_GRAVITYWELL) e.pk_gravitywellammo = 1;
		if (DEF_PK_ITEMS & PK_IT_CANPAB) e.pk_canpabammo = 1;
		if (DEF_PK_ITEMS & PKPLUS_IT_EGO) e.pkplus_egoammo = 1;
		if (DEF_PK_ITEMS & PKPLUS_IT_TOMB) e.pkplus_tombammo =2;
		if (DEF_PK_ITEMS & PKPLUS_IT_ACTOR) e.pkplus_actorammo = 1;
		if (DEF_PK_ITEMS & PKPLUS_IT_PHONE) e.pkplus_phoneammo = 1;
		e.pk_items = e.pk_items | (DEF_PK_ITEMS & (PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT));
	}

	if(! e.items & IT_AXE) e.items = e.items | IT_AXE; // MUST have an axe slot item for pk items & wep cycles!

	if (! e.weapon) // didnt set a default 
	{
		if (e.pk_items & PK_IT_CLIGHT) // have clg - default it
		{
			e.weapon = IT_AXE;
			e.pk_currentitem = PK_IT_CLIGHT;
			set_q1w_defammo(IT_LIGHTNING, e); // check ammo
			return;
		}
		e.weapon = return_bit(e.items, 255, BIT_HIGH, 0);
		if (!e.weapon) // for now no one is without a range weapon def if DEF_WEAPON doesnt say otherwise
		{
			e.weapon = 1;
			e.items = e.items | 1;
			set_q1w_defammo(IT_SHOTGUN, e);
			if (!(INIT_CON & 15)) // no genre controls, pick a shotgun at random - TEST: effects of ULOK* on this code set
			{
				if (random() < 0.3) set_xweap(e, MC_D_SHOTGUN);
				else if (random() < 0.2) set_xweap(e, MC_Q2_SHOTGUN);
				else if (random() < 0.45) set_xweap(e, MC_Q3_SHOTGUN);
			}
		}
	}
	e.eweapon = vchk(e.weapon, e.pk_currentitem, e.vwepent);

};


/*
		+---------------------------------------+
		|  inventory dispay                     | SEC-HEAD
		+---------------------------------------+
*/

float IT_BULLETS = 4096;
float IT_SLUGS = 8192;
float IT_GAS = 16384;

float am_type;
string pk_pr;

void(entity e, float am, string pr) eweap_am =
{
//	if (am_type == am) return;
//	am_type = am;


	if (am == AMMO_BULLETS && !(am_type & IT_BULLETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_bullet)));
		sprint(e, " bullets");
		am_type = am_type | IT_BULLETS;
	}
	else if (am == AMMO_SHELLS && !(am_type & IT_SHELLS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_shells)));
		sprint(e, " shells");
		am_type = am_type | IT_SHELLS;
	}
	else if (am == AMMO_CELLS && !(am_type & IT_CELLS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_cells)));
		sprint(e, " cells");
		am_type = am_type | IT_CELLS;
	}
	else if (am == AMMO_ROCKETS && !(am_type & IT_ROCKETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_rockets)));
		sprint(e, " rockets");
		am_type = am_type | IT_ROCKETS;
	}
	else if (am == AMMO_GRENADES && !(am_type & IT_ROCKETS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_rockets)));
		sprint(e, " grenades");
//		am_type = am_type | IT_ROCKETS;
	}
	else if (am == AMMO_NAILS && !(am_type & IT_NAILS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_nails)));
		sprint(e, " nails");
		am_type = am_type | IT_NAILS;
	}
	else if (am == AMMO_SLUGS && !(am_type & IT_SLUGS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_slug)));
		sprint(e, " slugs");
		am_type = am_type | IT_SLUGS;
	}
	else if (am == AMMO_GAS && !(am_type & IT_GAS))
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(rint(e.ammo_gaspr)));
		sprint(e, " lbs gas pressure");
		am_type = am_type | IT_GAS;
	}
	else if (am == PK_IT_GRAPGUN && e.pk_items & am)
	{
	local entity f;
	local string nt;

		if (pr != "") sprint(e, pr);
/*
		nt = "Harpoon gun";
		f = vchk(IT_AXE, am, e.vwepent);
		if (f)
		if (f.netname)
		{
			nt = f.netname;
		}

		sprint(e, nt);
		sprint(e, "\n");
*/
		sprint(e, "Harpoon gun\n");
		pk_pr = "";
	}
	else if (am == PK_IT_AIRGUN && e.pk_items & am)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, "Air cannon\n");
		pk_pr = "";
	}
	else if (am == PK_IT_CLIGHT && e.pk_items & am)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, "Chain Thunderbolt cannon");
		eweap_am(self, AMMO_CELLS, "   -> ");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_GRAVITYWELL && e.pk_gravitywellammo != 0)
	{
		if (pr != "") sprint(e, pr);
		if (e.pk_gravitywellammo == -1)
		{
			sprint(e, " super gravity well");			
		}
		else
		{
			sprint(e, ftos(e.pk_gravitywellammo));
			sprint(e, " gravity well");
			if (e.pk_gravitywellammo > 1) sprint(e, "s");
		}
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_TURRET && e.pk_turretammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_turretammo));
		sprint(e, " turret");
		if (e.pk_turretammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_CANPAB && e.pk_canpabammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_canpabammo));
		sprint(e, " pork and beans can");
		if (e.pk_canpabammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PK_IT_BEARTRAP && e.pk_beartrapammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_beartrapammo));
		sprint(e, " bear trap");
		if (e.pk_beartrapammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == 4096 && e.pk_explode_ammo > 0) // shells dont have a PK_IT # - jacking this one for the inventory fn
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pk_explode_ammo));
		sprint(e, " explode shell");
		if (e.pk_explode_ammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_EGO && e.pkplus_egoammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_egoammo));
		sprint(e, " ego");
		if (e.pkplus_egoammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_TOMB && e.pkplus_tombammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_tombammo));
		sprint(e, " tomb");
		if (e.pkplus_tombammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_ACTOR && e.pkplus_actorammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_actorammo));
		sprint(e, " actors mask");
		if (e.pkplus_actorammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
	else if (am == PKPLUS_IT_PHONE && e.pkplus_phoneammo > 0)
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.pkplus_phoneammo));
		sprint(e, " cellular phone tele-hack");
		if (e.pkplus_phoneammo > 1) sprint(e, "s");
		sprint(self, "\n");
		pk_pr = "";
	}
/*	else if (am == )
	{
		if (pr != "") sprint(e, pr);
		sprint(e, ftos(e.));
		sprint(e, " t");
		if (e. > 1) sprint(e, "s");
	}*/
};

// ammo with no wep

void() loose_ammo =
{
	local string pr;

	pr = "-\nammo:\n";

	if (self.ammo_shells  && !(am_type & IT_SHELLS))
	{
		eweap_am(self, AMMO_SHELLS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_cells  && !(am_type & IT_CELLS))
	{
		eweap_am(self, AMMO_CELLS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_nails  && !(am_type & IT_NAILS))
	{
		eweap_am(self, AMMO_NAILS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_rockets  && !(am_type & IT_ROCKETS))
	{
		eweap_am(self, AMMO_ROCKETS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_bullet  && !(am_type & IT_BULLETS))
	{
		eweap_am(self, AMMO_BULLETS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_slug  && !(am_type & IT_SLUGS))
	{
		eweap_am(self, AMMO_SLUGS, pr);
		sprint(self, "\n");
		pr = "";
	}
	if (self.ammo_gaspr  && !(am_type & IT_GAS))
	{
		eweap_am(self, AMMO_GAS, pr);
		sprint(self, "\n");
		pr = "";
	}
};

void(float wp) q1_inv_print =
{
	local float f;

	f = TRUE;
	if (wp & self.builtin) f = FALSE; // dont call these for builtin bits

	if (wp == IT_AXE && f) sprint(self, "War Axe\n");
	else if (wp == IT_SHOTGUN && f)
	{
		sprint(self, "Pump shotgun");
		eweap_am(self, AMMO_SHELLS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_SUPER_SHOTGUN && f)
	{
		sprint(self, "Double barrel shotgun");
		eweap_am(self, AMMO_SHELLS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_NAILGUN && f)
	{
		sprint(self, "Fletchet (nail) gun");
		eweap_am(self, AMMO_NAILS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_SUPER_NAILGUN && f)
	{
		sprint(self, "High rate Fletchet (nail) gun");
		eweap_am(self, AMMO_NAILS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_GRENADE_LAUNCHER && f)
	{
		sprint(self, "Grenade launcher");
		eweap_am(self, AMMO_ROCKETS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_ROCKET_LAUNCHER && f)
	{
		sprint(self, "Rocket launcher");
		eweap_am(self, AMMO_ROCKETS, "   -> ");
		sprint(self, "\n");
	}
	else if (wp == IT_LIGHTNING && f)
	{
		sprint(self, "Thunderbolt cannon");
		eweap_am(self, AMMO_CELLS, "   -> ");
		sprint(self, "\n");
	}
/*	else if (wp == IT_MJOLNIR)
	{
		sprint(self, "Thor's Hammer");
		eweap_am(self, AMMO_CELLS, "   -> ");
		sprint(self, "\n");
	}*/

	else if (wp == IT_ARMOR3) sprint(self, "Body armor (code red)\n");
	else if (wp == IT_ARMOR2) sprint(self, "Combat armor (code yellow)\n");
	else if (wp == IT_ARMOR1) sprint(self, "Jacket armor (code green)\n");
	else if (wp == IT_KEY2) sprint(self, "a Gold key\n");
	else if (wp == IT_KEY1) sprint(self, "a Silver key\n");
	else if (wp == IT_SUPERHEALTH) sprint(self, "Mega health!\n");
	else if (wp == IT_QUAD) sprint(self, "Quad damage\n");
	else if (wp == IT_INVULNERABILITY) sprint(self, "Pentagram power\n");
	else if (wp == IT_SUIT) sprint(self, "Hazmat protection suit\n");
	else if (wp == IT_INVISIBILITY) sprint(self, "Ring of shadows\n");
//	else if (wp == IT_) sprint(self, "\n");
};



/*
		+---------------------------------------+
		|  inventory control                    | SEC-HEAD
		+---------------------------------------+
*/

// handle player inventory impulses

// 52 = list inv + set drop item
// 53 = drop mode

// ops:

// if 53 is called with no inventory select, it calls up drop menu

// if list is called a second time before timeout, it sets drop item from players inventory
// calling 53 with drop item set drops that item
// guns drop with default ammo, or % of ammo load, whichever is smaller
// ammo drop is  small box amount or % of ammo load, whichever is smaller

float AMMO_PER = 0.2; // percent of ammo load to drop if inventory does not contain 2 x req. amount

// item is tossed out along v_angle
// thrown guns will not rotate

void() inventory =
{
	local float f, k, IT_DET;
	local entity e;

// detect items for title header print
	IT_DET = IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3 | IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD | IT_SUPERHEALTH;
	am_type = 0;
	if (self.impulse == IMP_INV)
	{
		stuffcmd(self, "con_notify 22\n"); // for this op
		stuffcmd(self, "con_notifytime 10\n");

		sprint(self, "\n* Inventory *\n");
		sprint(self, "-\nWeapons:\n");
		f = 1;
		while (f <= IT_QUAD)
		{
			e = world;
			if (f <= IT_MJOLNIR || f == IT_AXE)
			{
				k = 0;
				if (f == IT_AXE) k = PK_IT_AXE;
				e = vchk(f, k, self.vwepent);
			}
			if (e)
			{
				if (e.eweapon)
				{
					sprint(self, e.netname);
					eweap_am(self, e.lip, "   -> ");
					sprint(self, "\n");
				}
				else
					if (self.items & f) q1_inv_print(f);
			}
			else
				if (self.items & f) q1_inv_print(f);

			if (f == IT_MJOLNIR) // skip bits 256 - 2048
				f = IT_AXE;
			else
				f = f * 2;
			if (f == IT_ARMOR1)
			{
				if (PK_INV)
				{
					pk_pr = "-\npainkeep Items:\n";
					k = 2;
					while (k < 8192)
					{
						e = world;
						e = vchk(IT_AXE, k, self.vwepent);
						if (e)
						{
							if (e.eweapon)
							{
								sprint(self, e.netname);
								eweap_am(self, e.lip, "   -> ");
								sprint(self, "\n");
							}
							else
								eweap_am(self, k, pk_pr);
						}
						else
							eweap_am(self, k, pk_pr);
						k = k * 2;
					}
				}
				loose_ammo();
				if (self.rune_flag & RUNE_AMMO)
				if (self.target1 != "ammorune")
					sprint(self, "Ammo Pack\n");
				if (self.items & IT_DET)
					sprint(self, "-\nItems:\n");
			}
		}
		if (self.x_items & X_INV) sprint(self, "-\nX Items:\n");
		if (self.x_items & X_PWR_ARM_INV)
		{
			sprint(self, "Powered armor\n");
		}
		if (self.x_items & X_Q2_KEY_BIT) // IDEA: bit list or key list (dep on map genre)?
		{
			sprint(self, "extra key(s)\n");
		}
		if (self.x_items & X_D_MAP)
		{
			sprint(self, "an automap\n");
		}
		if (self.x_items & X_D_VIS)
		{
			sprint(self, "night vision goggles\n");
		}
		if (self.rune_flag & RUNE_MASK_ALL) sprint(self, "-\nRunes of power\n");
	}

	am_type = 0;
}

// for tossed items

// fn(dropinview) - set vector for tossed stuff
// de - ent doing tossing (player) - if world, pick a random location
// ve - ent being tossed
// vb - bounce item with item eject

void(entity de, entity ve, vector vb) dropinview =
{
	local vector vec;
	local float at;
	local entity e;

	ve.nextthink = time + 5; // no touch for a bit - assuming item_call make

	if (ve.event == "dynamic_item")
	{
		at = TRUE; // allow long throw - note: throw back to chaos mod 1, where this was a player tossed ent only
		
		if (vb == MED_BOUNCE_NOW)  // bounce it now
		{
			item_eject(newmis, MED_BOUNCE);
			ve.punchangle = anti_bounce;
		}
		else
			ve.punchangle = vb; // these are bounced by place code
	}
	else if (vb != anti_bounce)
		item_eject(newmis, vb);

	if (!de) // called with world, need location now
	{
		e = find_tdest(FL_RSALL, "");
		if (!e) return; // might not be good - this ent will be at v0
		setorigin(ve, e.origin);
		return;
	}
//	if (ve.classname == "gravity_armed") at = TRUE; // ur? fails to land

	if (ve.origin == v0)
		setorigin(ve, de.origin);

	if (vb != anti_bounce) return;

	makevectors(de.v_angle);
	vec = normalize(v_forward);
	if (de.angles_x > 2.0 && at) // throw up in air
		{
		ve.velocity = (400 + ((de.angles_x / 23.0) * 200) ) * vec;
//		ve.movetype = MOVETYPE_FLY; // still fails!
		}
	else // toss on ground
		{
		ve.velocity = 250 * vec;
		ve.velocity_z = 250 + ((de.angles_x / 26.0) * 200);
		if (de.angles_x < -8.0) ve.velocity_z = ve.velocity_z - (60 + de.angles_x);
		}
}

// set bounce up for dropped inventory
/*
void(entity e, vector vb) drop_setbounce =
{
	if (e.event == "dynamic_item")
		e.punchangle = vb;
	else
		if (vb != anti_bounce) item_eject(e, vb);
		
};
*/

// drop arbitrary item

// mc - valid map code
// cls - classname - overrides map code
// de - drop ent (for origin, v_angle)
// vb - random bounce vector

entity(float mc, string cls, entity de, vector vb) drop_item =
{
	local entity e;
	local string scls;

	scls = cls;
	if (!scls)
		scls = item_by_mcode(mc);

	if (!scls)
	{
		if (WARNING) bprint("*** warning: drop_item did not get a valid function - giving up\n");
		return(world);
	}

	e = spawn(); // for tossed item
	e.event = "dynamic_item";
	item_call_save(e, scls);
	dropinview(de, e, vb);

	return(e);
};

// dropping imventory - the complicated method

float DROP_NOTST; // just drop it, no testing

// p - ent to drop inv - player
// im - selection from menu
// vb - bounce item with item eject

void(float im, entity p, vector vb) drop_inventory =
{
	local string sel, ic;
	local float b, f, nt;
	local entity e, d;

	nt = DROP_NOTST;
	DROP_NOTST = FALSE;

	if (!im) return;

	if (!p.dropent) return;
	if (p.dropent.classname != "dropinv") return;

	if (im == 1)
	{
		sel = p.dropent.noise;
		b = p.dropent.dmg;
		d = p.dropent.eweapon; // eweap
	}
	if (im == 2)
	{
		sel = p.dropent.noise1;
		b = p.dropent.lefty;
		d = p.dropent.vwepent; // eweap
	}
	if (im == 3)
	{
		sel = p.dropent.noise2;
		b = p.dropent.lip;
		d = p.dropent.charmer; // eweap
	}
	if (p.dropent.cnt == 4)
	{
		sel = p.dropent.noise3;
		b = p.dropent.wait;
		d = p.dropent.enemy;
	}
	if (p.dropent.cnt == 5)
	{
		sel = p.dropent.noise4;
		b = p.dropent.aflag;
		d = p.dropent.oldenemy;
	}
	if (p.dropent.cnt == 5)
	{
		sel = p.dropent.target1;
		b = p.dropent.delay;
		d = p.dropent.goalentity;
	}
	if (p.dropent.cnt == 7)
	{
		sel = p.dropent.target2;
		b = p.dropent.volume;
		d = p.dropent.owner;
	}

	newmis = e = spawn(); // for tossed item
	e.event = "dynamic_item";
	f = 0;

// ---: check self.target2 for d / q2 /q3 items - pretty sure stack_search does this - REMOVE comment

// note: for rules 1, time left is in expiry ent

// dropping a rune

	if (sel == "Haste " ||
		 sel == "Regeneration " ||
		 sel == "Resistance" ||
		 sel == "Strength" ||
		 sel == "Haste" ||
		 sel == "Regeneration" ||
		 sel == "Vampire" ||
		 sel == "Disruptor Shield" ||
		 sel == "Power Amplifier" ||
		 sel == "Time Accelerator" ||
		 sel == "Auto Doc" ||
		 sel == "Earth magic" ||
		 sel == "Black magic" ||
		 sel == "Hell magic" ||
		 sel == "Elder magic")
	{
		e.spawnflags = b;
		ic = "item_sigil";

		if (sel == "Haste ")
		{
			ic = "item_haste";
			stack_delete(p, ic);
			stack_compress(p);
		}

		if (sel == "Regeneration ")
		{
			ic = "item_regen";
			stack_delete(p, ic);
			stack_compress(p);
		}

		item_call_save(e, ic);

		if (RUNES != 1) // CHECK: does run toss need to turn of dyn_item
		if (ic == "item_sigil")
			e.event = ""; // not dyn_item - for relocation control code
//		if (ic == "item_sigil") e.classname = ic; // make a real item

		if (ic != "item_sigil")
			p.rune_flag = p.rune_flag - (p.rune_flag & b); // remove rune item
		else if (RUNES)
			p.rune_flag = p.rune_flag - (p.rune_flag & b); // remove rune
		else if (ic == "item_sigil")
		{
			serverflags = serverflags - (serverflags & b); // remove server rune
			serverflags = serverflags | (SVR1 * b); // so we know it was collected and pooted out
		}
		dropinview(p, e, vb);
		p.dropent.map = sel;

		return;
	}

// dropping an artifact
	if (sel == "Invulerability" && (nt || (p.items & b)))
	{
		ic = "item_artifact_invulnerability";
		if (stack_search(p, "item_invulnerability"))  ic = "item_invulnerability";
		else if (stack_search(p, "d_art_invulnerable"))  ic = "d_art_invulnerable";
		item_call_save(e, ic);
		f = p.invincible_finished;
		p.invincible_finished = -1;
		if (f < 1) f = time + 10;
	}

	if (sel == "Quad Damage" && (nt || (p.items & b)))
	{
		ic = "item_artifact_super_damage";
		if (stack_search(p, "q2_item_quad"))  ic = "q2_item_quad";
		else if (stack_search(p, "q3_item_quad"))  ic = "q3_item_quad";
		else if (stack_search(p, "d_art_berserker"))  ic = "d_art_berserker";
		item_call_save(e, ic);
		f = p.super_damage_finished;
		p.super_damage_finished = -1;
		if (f < 1) f = time + 10;
	}

	if (sel == "Limited Invisibility" && (nt || (p.items & b)))
	{
		ic = "item_artifact_invisibility";
		if (stack_search(p, "item_invis"))  ic = "item_invis";
		else if (stack_search(p, "d_art_invisible"))  ic = "d_art_invisible";
		item_call_save(e, ic);
		f = p.invisible_time;
		p.invisible_finished = -1;
		if (f < 1) f = time + 10;
	}

	if (sel == "Hazmat Suit" && (nt || (p.items & b)))
	{
		ic = "item_artifact_envirosuit";
		if (stack_search(p, "q2_item_enviro"))  ic = "q2_item_enviro";
		else if (stack_search(p, "q3_item_enviro"))  ic = "q3_item_enviro";
		else if (stack_search(p, "d_art_radsuit"))  ic = "d_art_radsuit";
		item_call_save(e, ic);
		f = p.radsuit_finished;
		p.radsuit_finished = -1;
		if (f < 1) f = time + 10;
	}

	if (sel == "Diving Suit" && (nt || (p.items & b)))
	{
		item_call_save(e, "item_artifact_envirosuit");
		f = p.wetsuit_finished;
		p.wetsuit_finished = -1;
		if (f < 1) f = time + 10;
	}

	if (sel == "Empathy Shields" &&(nt ||  (p.empathy_finished)))
	{
		item_call_save(e, "item_artifact_empathy_shields");
		f = p.empathy_finished;
		p.empathy_finished = -1;
		if (f < 1) f = time + 10;
	}

// artifact common
	if (f)
	{
		p.items = p.items - (p.items & b);
		f = f - time;
		if (f < 10) f = 10;
		e.dmgtime = f;
		dropinview(p, e, vb);
		p.dropent.map = sel;
		if (sel == "Limited Invisibility") viswep_post(); // reset viswep
		stack_delete(p, ic);
		stack_compress(p);
		return;
	}

// note: when droping search .map for mega_health_rot & get value in duration for next add - goes in .healamount & take away from player

	if (sel == "Mega Health" && (nt || (p.items & b)))
	{
		ic = "item_health_mega";
//		if (stack_search(p, "d_art_megasphere"))  ic = "d_art_megasphere"; // note: this is not mega health!
//		else 
		if (stack_search(p, "q2_item_health_mega"))  ic = "q2_item_health_mega";
		else if (stack_search(p, "q3_item_health_mega"))  ic = "q3_item_health_mega";
		item_call_save(e, ic);
		p.items = p.items - (p.items & b);

		dropinview(p, e, vb);
		p.dropent.map = sel;
		stack_delete(p, ic);
		stack_compress(p);
		
		d = find(world, map, "mega_health_rot");
		while (d)
		{
			if (d.owner == p)
			{
				e.healamount = d.duration;
				if (p.health > (p.max_health * p.health_modifier))
				{
					f = p.health - (p.max_health * p.health_modifier);
					p.health = p.health - d.duration;
					if (p.health < (p.max_health * p.health_modifier))
						p.health = p.max_health * p.health_modifier;
					if (f < e.healamount) e.healamount = f;
				}
				return; // only one rot processed - should only be one anyway
			}
			d = find(d, map, "mega_health_rot");
		}
		return;
	}

	if (sel == "Ammo Pack" && (nt || (p.rune_flag & RUNE_AMMO)))
	{
		item_call_save(e, "d_item_pack");
		p.rune_flag = p.rune_flag - (p.rune_flag & b);
		dropinview(p, e, vb);
		p.dropent.map = sel;
		return;
	}

// q3 flight
	if (sel == "Flying Rune" && (nt || (p.rune_flag & RUNE_FLG_FLY))) // note: flight time left is in expiry
	{
		item_call_save(e, "item_flight");
		p.rune_flag = p.rune_flag - (p.rune_flag & b);
		p.movetype = MOVETYPE_WALK;
		dropinview(p, e, vb);
		p.dropent.map = sel;
		return;
	}

	if (sel == "Armor" && (nt || (p.armorvalue * p.armortype)))
	{
		ic = "item_armor1";
		if (stack_search(p, "d_item_armorgreen"))  ic = "d_item_armorgreen";
		else if (stack_search(p, "d_item_armorblue"))  ic = "d_item_armorblue";
		else if (stack_search(p, "d_item_spiritarmor"))  ic = "d_item_armorblue"; // note: spirit armors & shards convert to reg. armors
		else if (stack_search(p, "q2_item_armor_body"))  ic = "q2_item_armor_body";
		else if (stack_search(p, "q2_item_armor_combat"))  ic = "q2_item_armor_combat";
		else if (stack_search(p, "item_armor_jacket"))  ic = "item_armor_jacket";
		else if (stack_search(p, "q2_item_armor_shard"))  ic = "q2_item_armor_body";
		else if (stack_search(p, "q3_item_armor_body"))  ic = "q3_item_armor_body";
		else if (stack_search(p, "q3_item_armor_combat"))  ic = "q3_item_armor_combat";
		else if (stack_search(p, "q3_item_armor_shard"))  ic = "q3_item_armor_body";
		else if (p.items & IT_ARMOR2) ic = "item_armor2";
		else if (p.items & IT_ARMOR3) ic = "item_armorInv";

		item_call_save(e, ic);

		e.wad = "armor_toss"; // for get
		e.currentammo = p.armorvalue;
		if (nt && (e.currentammo < 1)) e.currentammo = 150; // default for weird possibilities

// note: this ups the max add allowed to match armor thrown out
		if (e.volume > 0) // q2 deal
		if (e.currentammo > e.volume) e.volume = e.currentammo; // note: max should be set by item_call
		p.armorvalue = p.armortype = 0;

		dropinview(p, e, vb);
		p.dropent.map = sel;
		stack_delete(p, ic);
		stack_compress(p);
		return;
	}

	remove(e); // nothing tossed out
	newmis = world;
};


void(string sl, float b, entity e) drop_string =
{
	if (self.dropent.cnt == 1)
	{
		self.dropent.noise = sl;
		self.dropent.dmg = b;
		self.dropent.eweapon = e;
	}
	if (self.dropent.cnt == 2)
	{
		self.dropent.noise1 = sl;
		self.dropent.lefty = b;
		self.dropent.vwepent = e;
	}
	if (self.dropent.cnt == 3)
	{
		self.dropent.noise2 = sl;
		self.dropent.lip = b;
		self.dropent.charmer = e;
	}
	if (self.dropent.cnt == 4)
	{
		self.dropent.noise3 = sl;
		self.dropent.wait = b;
		self.dropent.enemy = e;
	}
	if (self.dropent.cnt == 5)
	{
		self.dropent.noise4 = sl;
		self.dropent.aflag = b;
		self.dropent.oldenemy = e;
	}
	if (self.dropent.cnt == 6)
	{
		self.dropent.target1 = sl;
		self.dropent.delay = b;
		self.dropent.goalentity = e;
	}
	if (self.dropent.cnt == 7)
	{
		self.dropent.target2 = sl;
		self.dropent.volume = b;
		self.dropent.owner = e;
	}

	self.dropent.cnt = self.dropent.cnt + 1;
};

// used

// cnt
// weapon - current item
// count - bit flags of eweaps so we can find reg weps

// p - player
// pg - page code, 1 - next page, 0 setup, -1 - same page

void(entity p, float pg) drop_setup =
{
	local float a, d, e, f, k, l, m, n;
	local string sel, ic;
	local entity de;

	de = p.dropent;
	if (!de) return;
	if (de.classname != "dropinv") return;

	de.grap_firetest = 0; // redo menu
	de.weapon = 0;
	de.wad = "";

	de.noise = "";
	de.noise1 = "";
	de.noise2 = "";
	de.noise3 = "";
	de.noise4 = "";
	de.target1 = "";
	de.target2 = "";

	if (!pg) // set place holders
	{
		d = e = f = k = //l = m = n =

		de.button7 =
		de.button8 =
		de.button9 =
		de.button10 =
//		de.button11 =
//		de.button12 =
//		de.button13 =

		de.button0 = 
		de.button1 = 
		de.button2 = 
		de.button3 =
//		de.button4 =
//		de.button5 =
//		de.button6 =
										1; //init
	}
	else if (pg < 0) // redo same page - but diff stuff
	{
		d = de.button7;
		e = de.button8;
		f = de.button9;
		k = de.button10;
//		l = de.button11;
//		m = de.button12;
//		n = de.button13;
	}
	else
	{
		de.button7  = d = de.button0; // save pos for next page
		de.button8  = e = de.button1;
		de.button9  = f = de.button2;
		de.button10 = k = de.button3;
//		de.button11 = l = de.button4;
//		de.button12 = m = de.button5;
//		de.button13 = n = de.button6;
	}

	de.cnt = 1;
	sel = "";

	while (de.cnt < 8)
	{
		if (d <= 8388608)
		{
			if (d < 16) // start at top - runes
			{
				if (!RUNES) // if rune server is off any player can drop serverflags runes
				{
					if (p.rune_flag & d)
					{
						ic = "";
						if (d & RUNE_FLG_HS)
		//					if (p.target2 == "progs/q3_art.mdl")
						if (stack_search(p, "item_haste"))
							ic = "Haste ";

						if (d & RUNE_FLG_RG)
						if (stack_search(p, "item_regen"))
							ic = "Regeneration ";

						if (ic != "") drop_string(ic, d, world);
					}

					a = d & 15; // in case runes are ever > bit 8
					if (serverflags & a)
					{
						drop_string(rune_name(a), d, world);
						de.msight = " *: server runes can be released";
					}
				}
				else
				if (RUNES > 1) // rule 1 - cant drop rune
				if (p.rune_flag & d)
				{
					ic = rune_name(d);
					if (d & RUNE_FLG_HS)
//					if (p.target2 == "progs/q3_art.mdl")
					if (stack_search(p, "item_haste")) // TDO: when getting run, delete this from stack ?? not sure what this is about, maybe "run" should be "rune"
						ic = "Haste ";

					if (d & RUNE_FLG_RG)
					if (stack_search(p, "item_regen"))
						ic = "Regeneration ";

					drop_string(ic, d, world);
				}
			}

			if (d == 16)
			{
				a = RUNE_AMMO;
				if (!(a & RUNE_MASK_ALL)) // ammo pack not in runes
				if (p.rune_flag & RUNE_AMMO)
					drop_string("Ammo Pack", RUNE_AMMO, world);
			}

			if (d == 32)
			{
				a = RUNE_FLG_FLY;
				if (!(a & RUNE_MASK_ALL))
				if (p.rune_flag & RUNE_FLG_FLY)
					drop_string("Flying Rune", RUNE_FLG_FLY, world); // note: if rune ever exists will need to id q3 item
			}

			if (d == 64)
			if (p.rune_flag & R_VAMPIRE)
				drop_string(rune_name(R_VAMPIRE), R_VAMPIRE, world);

			if (d == 128)
			if (p.rune_flag & T_DSH)
				drop_string(rune_name(T_DSH), T_DSH, world);

			if (d == 256)
			if (p.rune_flag & T_AMP)
				drop_string(rune_name(T_AMP), T_AMP, world);

			if (d == 512)
			if (p.rune_flag & T_TEIM)
				drop_string(rune_name(T_TEIM), T_TEIM, world);

			if (d == 1024)
			if (p.rune_flag & T_ADOC)
				drop_string(rune_name(T_ADOC), T_ADOC, world);

			if (d == 2048)
			if (p.items & IT_INVULNERABILITY) drop_string("Invulerability", IT_INVULNERABILITY, world);

			if (d == 4096)
			if (p.items & IT_QUAD) drop_string("Quad Damage", IT_QUAD, world);

			if (d == 8192)
			if (p.items & IT_INVISIBILITY) drop_string("Limited Invisibility", IT_INVISIBILITY, world);

			if (d == 16384)
			if ((p.items & IT_SUIT) && !p.wetsuit_finished) drop_string("Hazmat Suit", IT_SUIT, world);

			if (d == 32768)
			if ((p.items & IT_SUIT) && p.wetsuit_finished) drop_string("Diving Suit", IT_SUIT, world);

			if (d == 65536)
			if (p.empathy_finished) drop_string("Empathy Shields", 0, world);

			if (d == 131072)
			if (p.items & IT_SUPERHEALTH) drop_string("Mega Health", IT_SUPERHEALTH, world);

// note: protect builtin armors
			if (d == 262144)
			{
				if (!((p.mask_x & MORPH_SARMOR) || p.armortype == ARM_SCRG)) // builtin type armor is not thrown
				if (p.armorvalue * p.armortype)
					drop_string("Armor", 0, world);
			}
 


			d = d * 2;
		}
		else if (e <= 8388608)
		{
//			if (e == 1)
				
			e = e * 2;
		}
		else if (f < 8388608)
		{
//			if (f == 1)
				
			f = f * 2;
		}
		if (f == 8388608) 
			de.cnt = 8;
	}

	de.button0 = d; // continue
	de.button1 = e;
	de.button2 = f;
	de.button3 = k;
//	de.button4 = l;
//	de.button5 = m;
//	de.button6 = n;

};

float DROPMENU_TIME = 60;
float DROPMENU_SIZE = 15;

void() drop_menu =
{
	string head, foot, nf;
	local float f;
//	string ln1, ln2, ln3, ln4, ln5;

//	ln1 = ln2 = ln3 = ln4 = ln5 = "";

	if (!self.dropent)
	{
		self.dropent = spawn();
		self.dropent.classname = "dropinv";
		drop_setup(self, 0);

// save notify stats
		self.dropent.grap_state = cvar("con_notifytime");
		self.dropent.grap_length = cvar("con_notify");
// setup menu display

		stuffcmd(self, "con_notifytime "); // restore notify
		stuffcmd(self, ftos(DROPMENU_TIME));
		stuffcmd(self, "\ncon_notify ");
		stuffcmd(self, ftos(DROPMENU_SIZE));
		stuffcmd(self, "\n");

	}
	if (self.dropent.classname != "dropinv")
	{
		centerprint(self,"Drop inventory failure, exiting menu\n");
		self.button1 = 1;
		return;
	}

	if (self.dropent.grap_firetest) return; // displayed
	self.dropent.grap_firetest = TRUE;


	if (self.dropent.weapon)
	{
		if (self.dropent.weapon == 1)
		{
			if (!self.dropent.noise) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.noise;
		}

		if (self.dropent.weapon == 2)
		{
			if (!self.dropent.noise1) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.noise1;
		}

		if (self.dropent.weapon == 3)
		{
			if (!self.dropent.noise2) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.noise2;
		}

		if (self.dropent.weapon == 4)
		{
			if (!self.dropent.noise3) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.noise3;
		}

		if (self.dropent.weapon == 5)
		{
			if (!self.dropent.noise4) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.noise4;
		}

		if (self.dropent.weapon == 6)
		{
			if (!self.dropent.target1) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.target1;
		}

		if (self.dropent.weapon == 7)
		{
			if (!self.dropent.target2) self.dropent.weapon = 0;
			else self.dropent.wad = self.dropent.target2;
		}
//		if (self.dropent.weapon == 4) self.wad = self.dropent.noise3;
//		if (self.dropent.weapon == 5) self.wad = self.dropent.noise4;		
	}

	head =
					 "\n\n\n\n\n\n\n\n"
					 "\b   Drop Inventory Menu:   \n"
					 "\b+------------------------+\n";

	foot = 
						"  all other buttons exit  \n"
					 "\b+------------------------+\n";

	nf = 
					   "   Nothing found!         \n"
					   "           .              \n"
					   "           .              \n"
					   "           .              \n";

	sprint(self, head);

	if (self.dropent.noise != "")
	{
		sprint(self,"  1: ");
		sprint(self,self.dropent.noise);
		sprint(self,"\n");
		f = TRUE;
	}
	if (self.dropent.noise1 != "")
	{
		sprint(self,"  2: ");
		sprint(self,self.dropent.noise1);
		sprint(self,"\n");
		f = TRUE;
	}
	if (self.dropent.noise2 != "")
	{
		sprint(self,"  3: ");
		sprint(self,self.dropent.noise2);
		sprint(self,"\n");
		f = TRUE;
	}
	if (self.dropent.noise3 != "")
	{
		sprint(self,"  4: ");
		sprint(self,self.dropent.noise3);
		sprint(self,"\n");
		f = TRUE;
	}
	if (self.dropent.noise4 != "")
	{
		sprint(self,"  5: ");
		sprint(self,self.dropent.noise4);
		sprint(self,"\n");
		f = TRUE;
	}
	if (self.dropent.target1 != "")
	{
		sprint(self,"  6: ");
		sprint(self,self.dropent.target1);
		sprint(self,"\n");
		f = TRUE;
	}
	if (self.dropent.target2 != "")
	{
		sprint(self,"  7: ");
		sprint(self,self.dropent.target2);
		sprint(self,"\n");
		f = TRUE;
	}

	if (!f)
		sprint(self, nf);
	else
		sprint(self, "  8: next inventory page  \n");

	if (self.dropent.msight)
	{
		sprint(self, self.dropent.msight);
		sprint(self,"\n");
	}

	sprint(self, foot);

	if (self.dropent.wad != "")
	{
		sprint(self,"\b <ENTER> or <FIRE> confirm drop of:\n");
		sprint(self,self.dropent.wad);
		sprint(self,"\n");
		
	}
	else
	{
		if (self.dropent.map)
		{
			sprint(self," You dropped: ");
			sprint(self, self.dropent.map);
			sprint(self,"\n");
		}
		if (f)
			sprint(self,"\b Enter code: \n");
	}

/*	
	if (self.dropent.noise == "")
	{
	head =
					 "\b   Drop Inventory Menu:   \n"
					 "\b+------------------------+\n"
					   "   Nothing found!         \n"
					   "           .              \n"
					   "           .              \n"
					   "           .              \n"
						"    any button exits      \n"
					 "\b+------------------------+\n";
	}
	else
	{
	head =
					 "\b   Drop Inventory Menu:   \n"
					 "\b+------------------------+\n"
						"1: ";
	}

	if (self.dropent.weapon == 1)
	{
	foot = 
						"\n"
						"  4: next inventory page  \n"
						"    any button exits      \n"
					 "\b+------------------------+\n"
					 "\b <ENTER> confirm drop #1  ";
	}
	else
	if (self.dropent.weapon == 2)
	{
	foot = 
						"\n"
						"  4: next inventory page  \n"
						"    any button exits      \n"
					 "\b+------------------------+\n"
					 "\b <ENTER> confirm drop #2  ";
	}
	else
	if (self.dropent.weapon == 3)
	{
	foot = 
						"\n"
						"  4: next inventory page  \n"
						"    any button exits      \n"
					 "\b+------------------------+\n"
					 "\b <ENTER> confirm drop #3  ";
	}
	else if (self.dropent.noise != "")
	{
	foot = 
						"\n"
						"  4: next inventory page  \n"
						"    any button exits      \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}

	if (self.dropent.noise1 != "") ln2 = "\n2: ";
	if (self.dropent.noise2 != "") ln3 = "\n3: ";
//	if (self.dropent.noise3 != "") ln4 = "\n4: ";
//	if (self.dropent.noise4 != "") ln5 = "\n5: ";


//	centerprint8(self, head, self.dropent.noise, ln2, self.dropent.noise1, ln3, self.dropent.noise2, ln4, self.dropent.noise3, ln5, self.dropent.noise4, foot, self.wad);
	centerprint7(self, head, self.dropent.noise, ln2, self.dropent.noise1, ln3, self.dropent.noise2, foot);
*/
};

// redisplay menu if something printed to console that was detected - like cube notes

void() drop_inv_check =
{
	local entity e;

	e = find(world, classname, "player");
	while (e)
	{
		if (e.class_select == "class_player")
		if (e.dropent)
		if (e.dropent.classname == "dropinv")
			e.dropent.grap_firetest = 0;

		e = find(e, classname, "player");
	}
};

// sequences an item drop from inventory outside of menu - used for dead drop

// set a temp dropent, and mark it for reuse

float(entity e, string ms) force_drop_set =
{
	if (!e.dropent)
	{
		e.dropent = spawn();
		e.dropent.classname = "dropinv";
		e.dropent.vwepmdl = "forcedrop"; // set so we can reuse ent

// save notify stats
		e.dropent.grap_state = cvar("con_notifytime");
		e.dropent.grap_length = cvar("con_notify");
	}
	else if (e.dropent.vwepmdl != "forcedrop")
	{
		if (ms != "") sprint(e, ms);
		return(TRUE);
	}
	return(FALSE);
};

// drop the specified item from player inventory - if world is sent, can drop any valid inventory item

// returns true on sucess

// p - player ent or world

// ds - descriptor - must match drop_inventory test value
// bv - bit value of item - removed from flag
// ew - eweapon pointer
// fm - fail message
// vb - bounce vector
// ke - if true remove dropent link

float(entity p, string ds, float bv, entity ew, string fm, vector vb, float ke) drop_one =
{
	local entity e;
	local string ss;

	ss = fm;
	if (p) e = p;
	else
	{
		e = spawn(); // note: no record keeping here, and test fail!
					e.stack1 = "insta spawn drop_one"; // test: nothing spawn test
		ss = ""; // no fail message possible
		DROP_NOTST = TRUE; // because there are no real player bits to test
	}

	if (force_drop_set(e, ss))
	{
		if (!p) remove(e);
		return(FALSE); // setup fail
	}

	e.dropent.cnt = 1;
	drop_string(ds, bv, ew);
	drop_inventory(1, e, vb);

	if (!p || ke)
	{
		remove(e.dropent);
		e.dropent = world;
		if (!p) remove(e);
	}

	return(TRUE);
};

// died & need to check dropping stuff

// e is dead ent

void(entity e) dead_drop =
{
	if (e.dropent)
	{
		remove(e.dropent);
		e.dropent = world;
	}

	if (DEAD_THROW_ARTIFACT)
		dead_artifact(e);

	if (e.rune_flag) // because you can have runes in q100 for some reason
		dead_runes(e);


/*
if (1)
bprint("***     warning: haste check - ");
rune_map_print(4);
//	bprint("\n");
*/


};


// touched item stack - so inventory drop & dead throws can toss out the correct item - this works most of the time
// note: this might require more string space, perhaps done on command line with -zone

// idea: when item is dropped, remove from stack

// put classname or other strings of some player touched ents in a string stack

.string stack2, stack3, stack4, stack5, stack6, stack7, stack8, stack9, stack10, stack11, stack12, stack13, stack14, stack15, stack16;


// remove empties
float(entity e) stack_compress =
{
	local float f;

	f = FALSE;
	if ((e.stack1 == "") && (e.stack2 != ""))
	{
		e.stack1 = e.stack2;
		e.stack2 = "";
		f = TRUE;
	}
	if ((e.stack2 == "") && (e.stack3 != ""))
	{
		e.stack2 = e.stack3;
		e.stack3 = "";
		f = TRUE;
	}
	if ((e.stack3 == "") && (e.stack4 != ""))
	{
		e.stack3 = e.stack4;
		e.stack4 = "";
		f = TRUE;
	}
	if ((e.stack4 == "") && (e.stack5 != ""))
	{
		e.stack4 = e.stack5;
		e.stack5 = "";
		f = TRUE;
	}
	if ((e.stack5 == "") && (e.stack6 != ""))
	{
		e.stack5 = e.stack6;
		e.stack6 = "";
		f = TRUE;
	}
	if ((e.stack6 == "") && (e.stack7 != ""))
	{
		e.stack6 = e.stack7;
		e.stack7 = "";
		f = TRUE;
	}
	if ((e.stack7 == "") && (e.stack8 != ""))
	{
		e.stack7 = e.stack8;
		e.stack8 = "";
		f = TRUE;
	}
	if ((e.stack8 == "") && (e.stack9 != ""))
	{
		e.stack8 = e.stack9;
		e.stack9 = "";
		f = TRUE;
	}
	if ((e.stack9 == "") && (e.stack10 != ""))
	{
		e.stack9 = e.stack10;
		e.stack10 = "";
		f = TRUE;
	}
	if ((e.stack10 == "") && (e.stack11 != ""))
	{
		e.stack10 = e.stack11;
		e.stack11 = "";
		f = TRUE;
	}
	if ((e.stack11 == "") && (e.stack12 != ""))
	{
		e.stack11 = e.stack12;
		e.stack12 = "";
		f = TRUE;
	}
	if ((e.stack12 == "") && (e.stack13 != ""))
	{
		e.stack12 = e.stack13;
		e.stack13 = "";
		f = TRUE;
	}
	if ((e.stack13 == "") && (e.stack14 != ""))
	{
		e.stack13 = e.stack14;
		e.stack14 = "";
		f = TRUE;
	}
	if ((e.stack14 == "") && (e.stack15 != ""))
	{
		e.stack14 = e.stack15;
		e.stack15 = "";
		f = TRUE;
	}
	if ((e.stack15 == "") && (e.stack16 != ""))
	{
		e.stack15 = e.stack16;
		e.stack16 = "";
//		f = TRUE; - nothing more to do
	}

// recurse for double blank - should not happen yet
//	if (f) stack_compress(e); // need safety ?

	return(f);
};

void(entity e, string ss) stack_delete =
{
	if (ss == "") return;

	if (e.stack1 == ss) e.stack1 = "";
	if (e.stack2 == ss) e.stack2 = "";
	if (e.stack3 == ss) e.stack3 = "";
	if (e.stack4 == ss) e.stack4 = "";
	if (e.stack5 == ss) e.stack5 = "";
	if (e.stack6 == ss) e.stack6 = "";
	if (e.stack7 == ss) e.stack7 = "";
	if (e.stack8 == ss) e.stack8 = "";
	if (e.stack9 == ss) e.stack9 = "";
	if (e.stack10 == ss) e.stack10 = "";
	if (e.stack11 == ss) e.stack11 = "";
	if (e.stack12 == ss) e.stack12 = "";
	if (e.stack13 == ss) e.stack13 = "";
	if (e.stack14 == ss) e.stack14 = "";
	if (e.stack15 == ss) e.stack15 = "";
	if (e.stack16 == ss) e.stack16 = "";
};

float(entity e, string ss) stack_search =
{
	if (e.stack1 == ss) return(TRUE);
	if (e.stack2 == ss) return(TRUE);
	if (e.stack3 == ss) return(TRUE);
	if (e.stack4 == ss) return(TRUE);
	if (e.stack5 == ss) return(TRUE);
	if (e.stack6 == ss) return(TRUE);
	if (e.stack7 == ss) return(TRUE);
	if (e.stack8 == ss) return(TRUE);
	if (e.stack9 == ss) return(TRUE);
	if (e.stack10 == ss) return(TRUE);
	if (e.stack11 == ss) return(TRUE);
	if (e.stack12 == ss) return(TRUE);
	if (e.stack13 == ss) return(TRUE);
	if (e.stack14 == ss) return(TRUE);
	if (e.stack15 == ss) return(TRUE);
	if (e.stack16 == ss) return(TRUE);
	return(FALSE);
};

void(entity e, string ss) stack_string =
{
	if (stack_search(e, ss)) return; // already in there

	e.stack16 = e.stack15;
	e.stack15 = e.stack14;
	e.stack14 = e.stack13;
	e.stack13 = e.stack12;
	e.stack12 = e.stack11;
	e.stack11 = e.stack10;
	e.stack10 = e.stack9;
	e.stack9 = e.stack8;
	e.stack8 = e.stack7;
	e.stack7 = e.stack6;
	e.stack6 = e.stack5;
	e.stack5 = e.stack4;
	e.stack4 = e.stack3;
	e.stack3 = e.stack2;
	e.stack2 = e.stack1;
	e.stack1 = ss;
};

// idea: replace some classnames with an ascending order system

void (entity e, entity p) stack_touch =
{
	if (e.model == "progs/q3_art.mdl") stack_string(p, e.classname);
	else if ( (e.items & IT_ARTIFACT) && (e.mcode >= MC_D_SAW ) ) stack_string(p, e.classname);
	else if ( (e.items & IT_ARMOR_BITS) && (e.mcode >= MC_D_SAW ) ) stack_string(p, e.classname);
	else if ( (e.items & (IT_KEY1 | IT_KEY2)) && (e.mcode >= MC_D_SAW ) && !e.x_items ) stack_string(p, e.model);
	else if ((e.mcode >= MC_D_BERS) && (e.mcode <= MC_D_MEGASPH) ) stack_string(p, e.classname);
	if (e.model == "progs/g_fnail.mdl") stack_string(p, e.model);
	if (e.netname == "Ammo Pack") stack_string(p, e.classname);
	
};




