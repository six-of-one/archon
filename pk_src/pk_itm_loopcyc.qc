/* ::-::
 *
 * Cataboligne
 *
 * file: pk_itm_loopcyc.qc
 *
 * date: 5/28/10
 *
 * qc - support painkeep 2.0 item loop cycles
 *
 */


// run loop cycles

// .target - timer string
// .noise - 0 str
// .noise1-4 1-4 string
// .target1-2 5-6 string
// .theowner - ent loop

void(entity e, string l0, string l1, string l2, string l3, string l4, string l5, string l6, string t0) loop_var =
{
	e.noise = l0;			// store access value of "it_cyc_{*}" parm loop vars in set of .string ent fields
	e.noise1 = l1;			// so same loop think can run all cyc vars
	e.noise2 = l2;
	e.noise3 = l3;
	e.noise4 = l4;
	e.target1 = l5;
	e.target2 = l6;
	e.target = t0;
}

// try to find the next map code in the loop vars, given the current mcode
// if called with search 0 - verify there are loop values

float(entity e, float p) loop_next =
{
	local float f, rp, sf;
	
	if (!p)
	{
	if (cvar(e.noise) == -666)
		return(0);
	else if (!cvar(e.noise1) && !cvar(e.noise2) && !cvar(e.noise3) && !cvar(e.noise4) && !cvar(e.target1) && !cvar(e.target2))
		return(0);
	else
		return(102); // default here in case
	}

	if (p == cvar(e.noise)) rp = 1;
	else if (p == cvar(e.noise1)) rp = 2;
	else if (p == cvar(e.noise2)) rp = 3;
	else if (p == cvar(e.noise3)) rp = 4;
	else if (p == cvar(e.noise4)) rp = 5;
	else if (p == cvar(e.target1)) rp = 6;
	else if (p == cvar(e.target2)) rp = 1;
	else return(0); // value p not found

	sf = 15;
	f = 0;

	while (!f && sf > 0)
	{
		if (rp == 1)
		{
			f = cvar(e.noise1);
			if (!f) rp = 2;
		}
		if (rp == 2)
		{
			f = cvar(e.noise2);
			if (!f) rp = 3;
		}
		if (rp == 3)
		{
			f = cvar(e.noise3);
			if (!f) rp = 4;
		}
		if (rp == 4)
		{
			f = cvar(e.noise4);
			if (!f) rp = 5;
		}
		if (rp == 5)
		{
			f = cvar(e.target1);
			if (!f) rp = 6;
		}
		if (rp == 6)
		{
			f = cvar(e.target2);
			if (!f) rp = 1;
		}
		sf = sf - 1;
	}
	return(f);
};

// 7.16.13 - fixed issue where hidden wad==q1 items could be collected after they were rotated to diff items by loopcyc

void(entity e, string cl) lc_item_call_save =
{
	if (e.map == "repic") return; // dont modify these
	
	item_call_save(e, cl);
};

void() loopcyc_think =
{
	local float f, rp, rn, dr, svm;
	local entity e;
	local string mmc;

	svm = cvar("it_cyc_master");
	f = cvar(self.noise);
	rp = cvar(self.noise1);
	self.cnt = dr = rn = FALSE;

	if (!f && !rp) // 1 & 0 are zeroed - restore items & remove
	{
		rn = TRUE;
	}

	if (svm && self.wait != -666)
	{
		mmc = item_by_mcode(self.delay);
		e = find( world, classname, mmc);
	}
	else
		e = self.theowner;

	if (mmc) // 8.2.13 - catching things it should not with blank search string, still need to know how that happens -- chaos vector if FL_MONSTER - cool effects, attacks as monster, collectible as item
	while (e)
	{



#ifdef warning
if (WARNING & 2)
if (!e.flags & FL_ITEM)
{
bprint("***     warning: loopcyc - no FL_ITEM set on = ");
bprint(item_ident(e));
bprint(" - searched: ");
bprint(mmc);
bprint(" - code: ");
bprint(ftos(self.delay));
bprint("\n");
e.button12 = 65536+random();
}
#endifdef




		if (!e.scode) e.scode = e.mcode;
		if (!self.cnt) self.cnt = e.mcode;
		if (cvar("it_cyc_halt") || rn)
		{
			lc_item_call_save(e, item_by_mcode(e.scode));
		}
		else if (e.event == "dynamic_item" && e.mcode != self.cnt)
			dr = TRUE;
		else
		{
			f = loop_next(self, 0); // check all 0's
			if (!f) // keep these ents gone, code0 = -666 goes here
			{
				e.model = null_string;
				e.nextthink = -1;
				e.pk_touch = e.touch = SUB_Null;
			}
			else // cycle according to rules
			{

// IMP: mass replace here for all loop x.theowner, else below

				self.delay = f = loop_next(self, e.mcode);
//				e.pk_touch = (void()) 0;
				e.pk_touch = SUB_Void;
				if (self.killtarget != null_string)
					item_call_save(e, self.killtarget);
				else
				if (!f)
				{
#ifdef warning
					if (WARNING & 2) bprint("\b*** warning: loop code changed on live item loop - restoring item.\n");
#endifdef
					lc_item_call_save(e, item_by_mcode(e.scode));
				}
				else
					lc_item_call_save(e, item_by_mcode(f)); // set replacement item
				if (self.map == "rune") self.map = null_string; // rune server deal - this is a just in case - map runes should be pic or nopic
			}
		}

		if (dr) e = find( e, event, "dynamic_item");
		else 
		{
			if (svm && self.wait != -666)
				e = find( e, classname, mmc);
			else
				e = e.theowner;
		}

		if (!dr && !e && cvar("it_cyc_dyn"))
		{
			e = find( world, event, "dynamic_item");	
			dr = TRUE;
		}
	}


	if (rn)
	{
		remove(self);
		return;
	}

	f = cvar(self.target);
	if (f < 0) // negative - 20% + random() 80%
	{
		f = fabs(f);
		rp = 0.2 * f;
		f = f - rp;
		rn = random() * f;
		f = rn + rp;
	}

	self.nextthink = time + f;
};

void(entity e) init_loopcyc =
{
	local entity sr, s2;
	local string cl;
	local float f0, f1, fr, sf;

	e.theowner = world;
	cl = null_string;
	f0 = cvar(e.noise);
	f1 = cvar(e.noise1);
	if (!f0 && !f1)
	{
		remove(e);
		return; // failed - no 0 or 1
	}
	if (f0)
	{
		e.delay = f0;
		cl = item_by_mcode(f0);
	}
	if (cl == null_string)
	{
		if (f0 < 0) // detect mass replace
		{
			cl = item_by_mcode(fabs(f0));
			if (cl != null_string)
			{
				e.killtarget = cl;
				fr = f1;
				e.wait = -666; // so we dont master server these!
			}
		}
		e.delay = f1;
		cl = item_by_mcode(f1);
	}
	if (cl == null_string)
	{
		remove(e);
		return; // failed - 0 or 1 (or both) not valid map codes
	}

	if (!cvar(e.target)) cvar_set(e.target, "-60"); // default timer


// IMP: mass replace here for all listed items - wait must be -666, check all levels
// have to set cl for each listed mc & ignore f1 not finding a sr
	sf = 1;

	if (f0 > -1 || f0 == -666 || fr)
	{
		while (sf > 0 || fr)
		{
			if (!cvar("it_cyc_master") || fr)
			{
				if (!e.theowner)
				{
					if (cl != null_string)
						e.theowner = s2 = sr = find( world, classname, cl);
				}
				if (!sr && !fr)
				{
					remove(e);
					return; // none on map right now
				}

			  while (s2) // chain em up
				{
				s2 = sr.theowner = find( sr, classname, cl);
		//		if (cl != "dyn_item")
		//			sr = sr.theowner;
				if (s2)
				if (s2.mcode == f0 || s2.mcode == f1)
					sr = sr.theowner;
				else
					s2 = sr.theowner = find( sr, classname, cl);

		//		if (cvar("it_cyc_dyn") && !sr) cl = "dyn_item"; // include dynamics - must have 1 reg item to start loop.
				}
				if (fr)
				{
					f1 = loop_next(e, f1);
					cl = item_by_mcode(f1);
					if (f1 == fr) fr = 0; // done drop out
					else s2 = sr;
				}
			}
			sf = sf - 1;
		}
	}
	else // create a series of random cycle items
	{
		e.wait = -666; // so we dont master server these!
		f0 = fabs(f0);
		while (f0 > 0)
		{
			sr = spawn();
			if (!e.theowner) e.theowner = sr;
			else s2.theowner = sr;
			if (sr)
			{
				s2 = dyn_rndloc();
				if (!s2) s2 = findradius(world.origin, 256000);
				if (!s2)
				{
					remove(e);
					return; // no location - fail!
				}
				v1 = s2.origin + '0 0 8';
				if (s2.flags & FL_ITEM)
					v1 = stdv_rndloc(s2.origin + '0 0 8', 50, 100);
				setorigin(sr, v1);
				sr.wad = cl;
				item_call_save(sr, cl); // make first one
				s2 = sr; // for the chain up
			}
			f0 = f0 - 1;
		}
	}

	f0 = cvar(e.target);
	if (f0 < 0) // negative - 20% + random() 80%
	{
		f0 = fabs(f0);
		f1 = 0.2 * f0;
		f0 = f0 - f1;
		f0 = f1 +  random() * f0;
	}

	e.think = loopcyc_think;
	e.nextthink = time + f0;
};

void() start_loopcyc =
{
	local entity e;

	self.nextthink = time + 15; // recheck every 10 rels?

// no sense in cycling removed items or constantly rndize items
	if (cvar("it_place_item") == 1) return;
	if (cvar("it_place_item") == 2 && cvar("it_place_item_reload")) return;
	
	if (!find(world, noise, "it_cyc_lg_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_lg_0", "it_cyc_lg_1", "it_cyc_lg_2", "it_cyc_lg_3", "it_cyc_lg_4", "it_cyc_lg_5", "it_cyc_lg_6", "it_cyc_lg_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_rl_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_rl_0", "it_cyc_rl_1", "it_cyc_rl_2", "it_cyc_rl_3", "it_cyc_rl_4", "it_cyc_rl_5", "it_cyc_rl_6", "it_cyc_rl_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_gl_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_gl_0", "it_cyc_gl_1", "it_cyc_gl_2", "it_cyc_gl_3", "it_cyc_gl_4", "it_cyc_gl_5", "it_cyc_gl_6", "it_cyc_gl_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_sng_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_sng_0", "it_cyc_sng_1", "it_cyc_sng_2", "it_cyc_sng_3", "it_cyc_sng_4", "it_cyc_sng_5", "it_cyc_sng_6", "it_cyc_sng_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_ng_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_ng_0", "it_cyc_ng_1", "it_cyc_ng_2", "it_cyc_ng_3", "it_cyc_ng_4", "it_cyc_ng_5", "it_cyc_ng_6", "it_cyc_ng_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_ssg_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_ssg_0", "it_cyc_ssg_1", "it_cyc_ssg_2", "it_cyc_ssg_3", "it_cyc_ssg_4", "it_cyc_ssg_5", "it_cyc_ssg_6", "it_cyc_ssg_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_pkw_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_pkw_0", "it_cyc_pkw_1", "it_cyc_pkw_2", "it_cyc_pkw_3", "it_cyc_pkw_4", "it_cyc_pkw_5", "it_cyc_pkw_6", "it_cyc_pkw_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_pkc_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_pkc_0", "it_cyc_pkc_1", "it_cyc_pkc_2", "it_cyc_pkc_3", "it_cyc_pkc_4", "it_cyc_pkc_5", "it_cyc_pkc_6", "it_cyc_pkc_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_art_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_art_0", "it_cyc_art_1", "it_cyc_art_2", "it_cyc_art_3", "it_cyc_art_4", "it_cyc_art_5", "it_cyc_art_6", "it_cyc_art_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_ammo_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_ammo_0", "it_cyc_ammo_1", "it_cyc_ammo_2", "it_cyc_ammo_3", "it_cyc_ammo_4", "it_cyc_ammo_5", "it_cyc_ammo_6", "it_cyc_ammo_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "it_cyc_itm_0"))
	{
	e = spawn();
	loop_var(e, "it_cyc_itm_0", "it_cyc_itm_1", "it_cyc_itm_2", "it_cyc_itm_3", "it_cyc_itm_4", "it_cyc_itm_5", "it_cyc_itm_6", "it_cyc_itm_t");
	init_loopcyc(e);
	}
};

 // IMP: should warn if !pk_art and pk art codes are used, likewise any x codes and not having that x mode available
