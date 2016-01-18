/*
		+---------------------------------------+
		|  Runes code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement runes for pk



void(entity e, float f, float r) rune_print =
{
	local float rul;

	rul = cvar("sv_c_rune"); // see -2 for q1 only models & not techs in rule 2
	if (!RULOK2) 
	if (rul == 2) // note: rule 3, 4 
		rul = -2; // models not avail

	if (f < 0)
	{
		if (rul > 1)
		{
			if (fabs(f) == R_EARTH) 			bprint("Blue -        ");
			else if (fabs(f) == R_BLACK)		bprint("Red -         ");
			else if (fabs(f) == R_HELL)		bprint("Yellow -      ");
			else if (fabs(f) == R_ELDER)		bprint("Green -       ");
			else if (fabs(f) == R_VAMPIRE) 	bprint("Purple -      ");
			else if (fabs(f) == T_DSH)			bprint("Blue Gear -   ");
			else if (fabs(f) == T_ADOC)		bprint("Red Cross -   ");
			else if (fabs(f) == T_TEIM)		bprint("Wings -       ");
			else if (fabs(f) == T_AMP)			bprint("Green Spike - ");
//			else if (fabs(f) == R_AMMO) 		bprint("Ammo Pack - ");
//			else if (fabs(f) == R_FLY) 		bprint("Flight - ");
			else bprint("Unkown - ");
			return;
		}
		if (fabs(f) == R_EARTH) 				bprint("Earth rune -   ");
		else if (fabs(f) == R_BLACK) 			bprint("Black rune -   ");
		else if (fabs(f) == R_HELL) 			bprint("Hell rune -    ");
		else if (fabs(f) == R_ELDER) 			bprint("Elder rune -   ");
		else if (fabs(f) == R_VAMPIRE) 		bprint("Vampire rune - ");
		else bprint("Unkown rune - ");
		return;
	}

	if (e)
	{
		if (r)
		{
			if (rul > 1)
			{
				if (fabs(f) == R_EARTH) 		sprint(e, "Blue -        ");
				else if (fabs(f) == R_BLACK) 	sprint(e, "Red -         ");
				else if (fabs(f) == R_HELL) 	sprint(e, "Yellow -      ");
				else if (fabs(f) == R_ELDER) 	sprint(e, "Green -       ");
			else if (fabs(f) == R_VAMPIRE)	sprint(e, "Purple -      ");
				else if (fabs(f) == T_DSH) 	sprint(e, "Blue Gear -   ");
				else if (fabs(f) == T_ADOC) 	sprint(e, "Red Cross -   ");
				else if (fabs(f) == T_TEIM) 	sprint(e, "Wings -       ");
				else if (fabs(f) == T_AMP) 	sprint(e, "Green Spike - ");
//			else if (fabs(f) == R_AMMO) 	sprint(e, "Ammo Pack - ");
//			else if (fabs(f) == R_FLY) 	sprint(e, "Flight - ");
				else sprint(e, "Unkown - ");
			}
			else
			{
			if (f == R_EARTH) 					sprint(e, "Earth rune -   ");
			else if (f == R_BLACK) 				sprint(e, "Black rune -   ");
			else if (f == R_HELL) 				sprint(e, "Hell rune -    ");
			else if (f == R_ELDER) 				sprint(e, "Elder rune -   ");
			else if (f == R_VAMPIRE) 			sprint(e, "Vampire rune - ");
			else sprint(e, "Unkown rune - ");
			}
		}

		if (f == RUNE_FLG_RS) sprint(e, "Resistance = 1/2 damage all attacks.\n");
		else if (f == RUNE_FLG_DM)
		{
			if (rul > 1)
			{
				sprint(e, "Strength = 2 x damage.\n");
			}
			else
			{
				if (RUNES < 2) 	sprint(e, "Damage = 2 x damage for 30 secs.  8 x damage if combined with quad.\n");
				else sprint(e, "Damage = 2 x damage.\n");
			}
		}
		else if (f == RUNE_FLG_HS) sprint(e, "Haste - double fire rate for most weps.\n");
		else if (f == RUNE_FLG_RG) sprint(e, "Regeneration - add 5 health | armor every 1/2 second\n");
		else if (f == RUNE_VAMPIRE) sprint(e, "Vampire - add 25% damage dealt to health\n");
		else if (f == TECH_DSH) sprint(e, "Disruptor Shield - 1/2 damage\n");
		else if (f == TECH_AMP) sprint(e, "Power Amplifier - 2 x damage\n");
		else if (f == TECH_TEIM) sprint(e, "Time Accelerator - 2 x fire, move faster\n");
		else if (f == TECH_ADOC) sprint(e, "Auto Doc - add 5 health / sec\n");
//		else if (f == RUNE_AMMO) sprint(e, "Ammo - hold more ammo\n");
//		else if (f == RUNE_FLG_FLY) sprint(e, "Flight - fly over everyones head\n");
		else sprint(e, "Rune not identified - unknown power!\n");

		return;
	}

	if (f == RUNE_FLG_RS) bprint("Resistance = 1/2 damage all attacks.\n");
	else if (f == RUNE_FLG_DM)
	{
		if (rul > 1)
		{
			bprint("Strength = 2 x damage.\n");
		}
		else
		{
			if (RUNES < 2) 	bprint("Damage = 2 x damage for 30 secs.\n"); //  8 x damage if combined with quad.\n");
			else bprint("Damage = 2 x damage.\n");
		}
	}
	else if (f == RUNE_FLG_HS) bprint("Haste - double fire rate most weps.\n");
	else if (f == RUNE_FLG_RG) bprint("Regenerate 5 health | armor per .5 sec\n");
	else if (f == RUNE_VAMPIRE) bprint("Vampire - add 25% damage dealt to health\n");
	else if (f == TECH_DSH) bprint("Disruptor Shield - 1/2 damage\n");
	else if (f == TECH_AMP) bprint("Power Amplifier - 2 x damage\n");
	else if (f == TECH_TEIM) bprint("Time Accelerator - 2 x fire, move faster\n");
	else if (f == TECH_ADOC) bprint("Auto Doc - add 5 health / sec\n");
//		else if (f == RUNE_AMMO) bprint("Ammo - hold more ammo\n");
//		else if (f == RUNE_FLG_FLY) bprint("Flight - fly over everyones head\n");
	else bprint("Rune not identified - unknown power!\n");
};

// return a rune bit mask for given map code or a map code for given rune bit mask

float(float mc, float bc) rune_bit_code =
{
	local float f;

	f = 0;
	if (mc == MC_SIGIL1) f = R_EARTH; //RUNE_FLG_RS; // these can be randomly assigned now
	else if (mc == MC_SIGIL2) f = R_BLACK; //RUNE_FLG_DM;
	else if (mc == MC_SIGIL4) f = R_HELL; //RUNE_FLG_HS;
	else if (mc == MC_SIGIL8) f = R_ELDER; //RUNE_FLG_RG;

	else if (mc == MC_SIGIL64) f = R_VAMPIRE; //RUNE_VAMPIRE;
	
	else if (mc == MC_Q2_TECH_RES) f = T_DSH;
	else if (mc == MC_Q2_TECH_DOC) f = T_ADOC;
	else if (mc == MC_Q2_TECH_AMP) f = T_AMP;
	else if (mc == MC_Q2_TECH_TM) f = T_TEIM;

	else if (bc == R_EARTH) f = MC_SIGIL1;
	else if (bc == R_EARTH) f = MC_SIGIL1;
	else if (bc == R_BLACK) f = MC_SIGIL2;
	else if (bc == R_HELL) f = MC_SIGIL4;
	else if (bc == R_ELDER) f = MC_SIGIL8;

	else if (bc == R_VAMPIRE) f = MC_SIGIL64;

	else if (bc == T_DSH) f = MC_Q2_TECH_RES;
	else if (bc == T_ADOC) f = MC_Q2_TECH_DOC;
	else if (bc == T_AMP) f = MC_Q2_TECH_AMP;
	else if (bc == T_TEIM) f = MC_Q2_TECH_TM;
	
	return(f);
};

// for rule 2 - give right name to color pyramid

string(float b) rune2_name =
{
	if (b == RUNE_FLG_RS) return("Resistance");
	if (b == RUNE_FLG_DM) return("Strength");
	if (b == RUNE_FLG_HS) return("Haste");
	if (b == RUNE_FLG_RG) return("Regeneration");
	if (b == RUNE_VAMPIRE) return("Vampire");
	return("Unknown magic");
}

string(float b) rune_name =
{
	if (b == TECH_DSH) return("Disruptor Shield");
	if (b == TECH_AMP) return("Power Amplifier");
	if (b == TECH_TEIM) return("Time Accelerator");
	if (b == TECH_ADOC) return("Auto Doc");

	if (cvar("sv_c_rune") > 1 && RULOK2) return(rune2_name(b));

	if (b == R_EARTH) return("Earth magic");
	if (b == R_BLACK) return("Black magic");
	if (b == R_HELL) return("Hell magic");
	if (b == R_ELDER) return("Elder magic");
	if (b == R_VAMPIRE) return("Vampire magic");
	return("Unknown magic");
}

float nonserver_rune_found;

void(float b) rune_map_print =
{
	local float f, rbc;
	local entity e;
	local string rs;

	f = 0 - b;
	rune_print(world, f, FALSE);
	bprint("(mc:");
	rbc = rune_bit_code(0, b);
	bprint(ftos(rbc));
	if (rbc < 100) bprint(" ");
	if (rbc < 10) bprint(" ");
	bprint(" bit:");
	bit_print(RUNE_MASK_ALL, b);
	e = find(world, netname, rune_name(b));
	while (e && e.map != "rune")
	{
		nonserver_rune_found = TRUE; // found a map spawned / func_dynamic / func_make rune
		e = find(e, netname, rune_name(b));
	}
	if (e)
	{
		if (e.solid == SOLID_NOT)
			bprint(" regen-- ");
		else
			bprint(" spawned ");
	}
	else
	{
		if (RUNES > 1)
		{
			rs = " ------- ";
			e = find(world, classname, "player");
			while (e)
			{
				if (e.rune_flag & b) rs = " potent- ";
				e = find(e, classname, "player");
			}
			e = find(world, class_select, "class_bot");
			while (e)
			{
				if (e.rune_flag & b) rs = " potent- ";
				e = find(e, class_select, "class_bot");
			}
		}
		bprint(rs);
	}
	bprint(") ");
	rune_print(world, b, FALSE);
};

// one cvar implementation of manual rune cfg

// 1 - set sv_c_rune_set to a valid rune map code
// 2 - set sv_c_rune_set to a valid rune power bit code

// IMP: update for all runes --- not sure what this means now

void() mk_rune_set =
{
	if (!rune_set)
	{
		if (cvar("sv_c_rune_set"))
		{
			rune_set = cvar("sv_c_rune_set");
			if (rune_set < MC_SIGIL1 || rune_set > MC_SIGIL8) rune_set = 0;
			cvar_set("sv_c_rune_set", "0");
		}
	}
	else
	{
		if (cvar("sv_c_rune_set"))
		{
			if (RUNE_RANDOM) bprint("\b*** warning: manual rune config with rune random set!\n");
			if (rune_set == MC_SIGIL1) R_EARTH = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			else if (rune_set == MC_SIGIL2) R_BLACK = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			else if (rune_set == MC_SIGIL4) R_HELL = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			else if (rune_set == MC_SIGIL8) R_ELDER = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			cvar_set("sv_c_rune_set", "0");
			rune_set = 0;
		}
		if (!R_EARTH) R_EARTH = RUNE_FLG_RS; // any fail get assigned std. powers
		else if (!R_BLACK) R_BLACK = RUNE_FLG_DM;
		else if (!R_HELL) R_HELL = RUNE_FLG_HS;
		else if (!R_ELDER) R_ELDER = RUNE_FLG_RG;
	}
};


// pull a rune forcefully from player

// TDO: harp can grab ejected rune - will be in newmis if exists
// TDO: level 3 rules that have incremental - will not pull a whole rune, but a series of increments

// drop a single rune - in bit order 1 - 2 - 4 - 8 - 16 - 32 - 64 - 131072 - 262144 - 524288 - 1048576

void(entity e) rune_drop =
{
	local float f, k, rp;
	local string ms;

	rp = RUNE_PULL;
	RUNE_PULL = FALSE; // always clear

	if (RUNES < 2) return;

	if (!e.rune_flag) return;

	f = 1;
	while (f < RUNE_MASK_ALL)
	{
		if (f & e.rune_flag)
		if (!k)
		{
			k = f;
		}
		f = f * 2;
	}

	if (k & RUNE_MASK) // drop a rune - wont drop if it was disabled by admin
	{
		if (!rp) ms = "Rune drop failure - clear menus and try again\n";

		if (force_drop_set(e, ms)) return;
		drop_setup(e, 0);

		if (e.dropent.dmg != k) // should be this rune bit - idea: more validation
		{
			if (!rp)
			sprint(e, "Rune drop failure - oh no\n");
//			remove(e.dropent);
//			e.dropent = world;
			return;
		}

		drop_inventory(1, e, anti_bounce); // must have anti bounce  here - rune could have been ejected manually with impulse
		if (e.dropent.map)
		{
			if (rp)
				sprint(e," You \bLOST\b: ");
			else
			sprint(e," You dropped: ");
			sprint(e, e.dropent.map);
			sprint(e,"\n");
		}
		remove(e.dropent);
		e.dropent = world;
	}
};

// test for a forced rune eject

// entity - player or bot
// pr - percentage test

void(entity e, float pr) rune_pull =
{
// MUST always be set because of code (like harpoon) that tries to snag a rune
	newmis = world;

	if (!ENHANCED) return;
	if (!e) return;

// only players & bots for now
	if (e.class_select != "class_player" && e.class_select != "class_bot") return;

// no can has rune - go back
	if (!e.rune_flag & RUNE_MASK_ALL) return;

// not in the cards
	if (random() > (pr * DBL_PULL)) return;

// pull a rune - this tests rune rule set value (no drop for rules 1)
	RUNE_PULL = TRUE;
	rune_drop(e);
	if (newmis) item_eject(newmis, GEN_BOUNCE);
};

// handle runes when player dies

// note: rule 3 might be special

void(entity e) dead_runes =
{
	local float f;

	if (RUNES < 2) // rule one, or zero - no rune toss
	{
		e.rune_flag = 0;
		return;
	}

	f = 1;
	while (f < RUNE_MASK_ALL)
	{
		newmis = world;
		rune_drop(e); // ???: qualify with rune_flag test?
		if (newmis) item_eject(newmis, GEN_BOUNCE);
		f = f  * 2;
	}
	
};

// server runes were released on previous level - spawn them on new levels till retaken

void() server_rune_follow =
{
	local float f, k, a;
	local vector v;
	local entity e;

	f = 1;
	k = SVR1;
	if (serverflags & SVRF)
	while (k < SVRF)
	{
		if ((k & serverflags) && !(f & serverflags))
		{
			e = find_tdest(FL_RSALL, null_string);
			v = e.origin;

			e = spawn();
			e.spawnflags = f;
			item_call_save(e, "item_sigil");
			setorigin(e, v);
			item_eject(e, GEN_BOUNCE);
			a = 1;
		}
		else
			serverflags = serverflags - (serverflags & k);

		f = f * 2;
		k = k * 2;
	}
	if (a)
		bprint("\n***   \bRunes\b of power are following and have spawned on the map\n\n");
}

// died, or special morph - eject artifacts

void(entity e) dead_artifact =
{
	local float f, a;

//	if (force_drop_set(e, null_string)) return;

	if (e.items & IT_ARTIFACT)
	{
		f = IT_SUPERHEALTH;

		while (f <= IT_QUAD)
		{

			if (f == IT_SUPERHEALTH)
			{
//				drop_string("Mega Health", IT_SUPERHEALTH, world);
				drop_one(e, "Mega Health", IT_SUPERHEALTH, world, null_string, MED_BOUNCE_NOW, 0);
			}

			else if (f == IT_INVISIBILITY)
			{
				drop_one(e, "Limited Invisibility", IT_INVISIBILITY, world, null_string, MED_BOUNCE_NOW, 0);
			}

// make sure the next two arent actors when tossing out artifact!
			else if (f == IT_INVULNERABILITY) // note: could only happen with real invuln if admin kick comes thru here
			{
				if (!e.pkplus_actortype)
					drop_one(e, "Invulerability", IT_INVULNERABILITY, world, null_string, MED_BOUNCE_NOW, 0);
			}

			else if (f == IT_QUAD)
			{
				if (!e.pkplus_actortype)
					drop_one(e, "Quad Damage", IT_QUAD, world, null_string, MED_BOUNCE_NOW, 0);
			}

			else if ( (f == IT_SUIT) && !e.wetsuit_finished)
			{
				drop_one(e, "Hazmat Suit", IT_SUIT, world, null_string, MED_BOUNCE_NOW, 0);
			}

			else if ( (f == IT_SUIT) && e.wetsuit_finished)
			{
				drop_one(e, "Diving Suit", IT_SUIT, world, null_string, MED_BOUNCE_NOW, 0);
			}
/*
			if (e.dropent.cnt == 2)
			{
				drop_inventory(1, e, MED_BOUNCE);
			}*/
			f = f * 2;
		}
	}

	if (e.empathy_finished)
	{
		drop_one(e, "Empathy Shields", 0, world, null_string, MED_BOUNCE_NOW, 0);
	}

	a = RUNE_FLG_FLY;
	if (!(a & RUNE_MASK_ALL))
	if (e.rune_flag & RUNE_FLG_FLY)
	{
		drop_one(e, "Flying Rune", RUNE_FLG_FLY, world, null_string, MED_BOUNCE_NOW, 0);
	}

	a = RUNE_AMMO;
	if (!(a & RUNE_MASK_ALL)) // ammo pack not in runes
	if (e.rune_flag & RUNE_AMMO)
	{
		drop_one(e, "Ammo Pack", RUNE_AMMO, world, null_string, MED_BOUNCE_NOW, 0);
	}

	if (e.dropent)
	if (e.dropent.vwepmdl == "forcedrop")
	{
		remove(e.dropent);
		e.dropent = world;
	}
};


// print rune info on impulse from e to p's console

// only admin is supposed to print where e != p


void(entity e, entity p) rune_id =
{
	local float f, k, g;

	stuffcmd(p, "con_notify 22\n"); // for this o/p
	stuffcmd(p, "con_notifytime 10\n");

	if (serverflags & 15) // end of level runes acq by a player and stored for server
	{
		sprint(p, "\nThese \bRunes\b are gathered on the server:\n");

		if (serverflags & 1) 
		{
			sprint(p, "Earth Magic Rune");
			if (serverflags & 14) sprint(p, ", ");
		}

		if (serverflags & 2)
		{
			sprint(p, "Black Magic Rune");
			if (serverflags & 12) sprint(p, ", ");
		}

		if (serverflags & 4)
		{
			sprint(p, "Hell Magic Rune");
			if (serverflags & 8) sprint(p, ", ");
		}
		if (serverflags & 8) sprint(p, "Elder Magic Rune");
		sprint(p, "\n");
	}


	if (WARNING)
	if (!RUNES)
	{
		sprint(p, "*** Rune server is turned off.\n\n");
	}

	if (e == p) sprint(p, "\nYou have");
	else
	{
		sprint(p, e.netname);
		sprint(p, " has");
	}
	
	f = RUNE_FLG_FLY;
	if (!(f & RUNE_MASK_ALL))
	if (e.rune_flag & RUNE_FLG_FLY) g = 1; //didnt show flight as rune, show it below

	f = RUNE_AMMO;
	if (!(f & RUNE_MASK_ALL))
	if (e.rune_flag & RUNE_AMMO) k = 1; //didnt show pack as rune, show it below

	f = e.items & IT_ARTIFACT;

	if (!(e.rune_flag & RUNE_MASK_ALL) && (!g))
	{
		sprint(p, " no Runes ");
		if (!f)
		{
			sprint(p, "and no Artifacts.\n\n");
		}
	}
	else	
	{
		sprint(p, " the following Runes of power:\n\n");

		f = 1;
		while (f < RUNE_MASK_ALL)
		{
			if (!g || f != RUNE_FLG_FLY)
			if (!k || f != RUNE_AMMO)
			if (f & e.rune_flag) rune_print(p, f, TRUE); 
			f = f * 2;
		}

		if (g) sprint(p, "The power of flight\n");

		sprint(p, "\n");

	}

	f = e.items & IT_ARTIFACT;
	if (f)
	sprint(p, "and the following Artifacts:\n");
	if  ((self.pkplus_actortype == PKPLUS_ACTORPENT) && (self.pkplus_actortype == PKPLUS_ACTORQUAD))
	{
		f = 0; // dont show other msgs
		sprint(p, "Acting:\nPenta-Quad - dontcha wish you had the real thing?\n");
		
	}
	else if  (self.pkplus_actortype == PKPLUS_ACTORPENT)
	{
		f = 0; // dont show other msgs
		sprint(p, "Acting:\nPentagram of Protection - syke!\n");
	}
	else if (self.pkplus_actortype == PKPLUS_ACTORQUAD)
	{
		f = 0;
		sprint(p, "Acting:\nQuad Damage and wishin in one hand!\n");
	}
	if (f == IT_ARTIFACT)
	{
		if (e.wetsuit_finished && e.empathy_finished && e.silencer_finished && (e.rune_flag & RUNE_AMMO) && (e.rune_flag & RUNE_FLG_FLY))
		{
			if (e.rune_flag == RUNE_MASK_ALL)
				sprint(p, "   EVERYTHING!    \bCriminy\b - how did you get all this stuff!?\n");
			else
				sprint(p, "   WHOA!    \bCriminy\b - where did you get all this stuff!?\n");
		}

		sprint(p, "\nALL artifacts!!!\n\n \bQUAKE GOD\b - go kill everyone now, fast!\n\n");
	}
	else if (f && (e.items & IT_QUAD) && (e.items & IT_INVULNERABILITY) )
	{
		sprint(p, "\bPENTA-QUAD\b !!\n(shoot quick they're all running away...)\n");
		if (e.items & IT_SUPERHEALTH) sprint(p, "Mega Health\n");
		if (e.items & IT_INVISIBILITY) sprint(p, "Limited Invisibility\n");
		if (e.items & IT_SUIT) 
		if (!e.wetsuit_finished)
			sprint(p, "Hazmat Suit\n");
		if (!e.items & (IT_SUIT | IT_INVISIBILITY | IT_SUPERHEALTH) ) sprint(p, "\n");
	}
	else
	{
		if (e.items & IT_SUPERHEALTH) sprint(p, "Mega Health\n");
		if (e.items & IT_INVISIBILITY) sprint(p, "Limited Invisibility\n");
		if (f && (e.items & IT_INVULNERABILITY)) sprint(p, "\bPENTAGRAM of Protection !!\n");
		if (e.items & IT_SUIT) 
		if (!e.wetsuit_finished)
			sprint(p, "Hazmat Suit\n");
		if (f && (e.items & IT_QUAD)) sprint(p, "\bQuad\b freakin Damage !\n");
		sprint(p, "\n");
	}

// these items shade into inventory type stuff
	if (!f)
	if (e.wetsuit_finished || e.empathy_finished || e.silencer_finished || k)
		sprint(p, "and the following items:\n");
	if (e.wetsuit_finished)
	{
		if (e.items & IT_SUIT) 
			sprint(p, "Wetsuit\n");
		else
			sprint(p, "Re-breather\n");
	}
	if (e.empathy_finished)
		sprint(p, "Empathy Shields\n");
	if (e.silencer_finished)
		sprint(p, "Silencer\n");

	if (k)
		sprint(p, "Ammo Pack\n");

	if (self.archon) archon_pprint(self);
};

// rune 1 rules - runes expire in pow time

void () rune_1_expire =
{
	if (self.owner.rune_flag & self.rune_flag)
	{
		if (self.group)
		{
			sprint (self.owner, self.group);
			self.group = null_string;
			if (self.aflag > 0)
			{
				self.aflag = 0;
				self.nextthink = time + self.aflag;
				return;
			}
		}

		if (self.rune_flag & RUNE_FLG_FLY)	
			self.owner.movetype = MOVETYPE_WALK;
		self.owner.rune_flag = self.owner.rune_flag - (self.owner.rune_flag & self.rune_flag);
		if (self.wad == "art_shell")
		{
			self.owner.volume = 0;
		}
		else // for now not printing final message on q3 arts - q1 arts dont final message
		{
			sprint(self.owner, "The power of the ");
			sprint(self.owner, self.netname);
//			if (self.wad == "art_shell")
//				sprint(self.owner, " has expired.\n");
//			else
			sprint(self.owner, " rune has expired.\n");
		}
	}
	remove(self);
};

// because map runes still need to serverflag and random can change spawnflags

void () rune_sigil_touch =
{
	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

	centerprint (other,"You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other,"bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (self.duration) // random runes - map run val goes here
		serverflags = serverflags | (self.duration & 15);
	else
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = null_string;		// so rune doors won't find it		Cat: ??? - huh?

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// IDEA: rule 1 sfx here, 3 runes - 10+ secs, 4 runes - 1+ min or till death

void () rune_touch =
{
	local entity e;

	if (other.classname != "player")
	if (other.classname != "pk*bot")
			return;
	if (other.health <= 0)
		return ;

	if (self.map == "pic_item")
	if (!deathmatch) rune_sigil_touch(); // map rune in sp must allow touch even if rules prevent getting rune

	if (RUNES < 3)
	if (!RUNE_AR1M) // allow rule 1 / 2 multiple runes  -- if not, only 1 each of rune & tech
	{
		if (self.spawnflags & TECH_MASK_ALL)
		if (other.rune_flag & TECH_MASK_ALL) // has a tech already
			return;

		if (self.spawnflags & RUNE_FULL)
		if (other.rune_flag & RUNE_FULL)
			return;
	}

	if ( (RUNES != 3) || (self.spawnflags & TECH_MASK_ALL) )
	if (other.rune_flag & self.spawnflags) // already got one & not in rule 3 | a tech
		return;

	if (self.map == "pic_item") rune_sigil_touch(); // map rune (should have pic_item set), do a touch for qstart map serverflags floor op

	if (! (self.spawnflags & RUNE_MASK)) // rune not allowed - prob map rune
		return;

	if (ENHANCED)
	{
		if (other.rune_flag & RUNE_VAMPIRE)
		if (self.spawnflags & RUNE_FLG_RG || self.spawnflags & TECH_ADOC)
		{
			if (other.duration < time)
			sprint(other,"Suck heads cant get Regeneration\n");
			other.duration = time + 2 + random();
			return;
		}

		if (self.spawnflags & RUNE_VAMPIRE)
		if (other.rune_flag & RUNE_FLG_RG || other.rune_flag & TECH_ADOC)
		{
			if (other.duration < time)
			sprint(other,"You have Regeneration - you cant become a Suck head\n");
			other.duration = time + 2 + random();
			return;
		}
	}

	centerprint3 (other,"You got the ",self.netname," Rune!");
	sprint(other,"You have the power of ");
	rune_print(other, self.spawnflags, FALSE);

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other,"bf\n");

	other.rune_flag = other.rune_flag | (self.spawnflags & RUNE_MASK_ALL);

	if (RUNES == 1)
	{
		e = spawn();
		if (e)
		{
			e.classname = "rune_1_expiry";
			e.netname = self.netname;
			e.rune_flag = self.spawnflags & RUNE_MASK_ALL;
			e.think = rune_1_expire;
			e.nextthink = time + POW_TIME;
			e.owner = other;
		}
	}
	if (RUNES == 3)
	{
		if (self.spawnflags & RUNE_FLG_RS) other.rune_3_resist = other.rune_3_resist + RUNE_3_ACM;
		if (self.spawnflags & RUNE_FLG_DM) other.rune_3_dmg = other.rune_3_dmg + RUNE_3_ACM;
		if (self.spawnflags & RUNE_FLG_HS) other.rune_3_haste = other.rune_3_haste + RUNE_3_ACM;
		if (self.spawnflags & RUNE_FLG_RG) other.rune_3_rgn = other.rune_3_rgn + RUNE_3_ACM;
		if (self.spawnflags & RUNE_VAMPIRE) other.rune_3_vamp = other.rune_3_vamp + RUNE_3_ACM;
	}

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	self.cnt = 0;
	self.count = self.count + 0.13; // increment for each grab - more activity = less chance of rune moving

//	serverflags = serverflags | (self.spawnflags & 15);

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets

	if (RUNES == 1 || RUNES == 3) // NOTE rule 4 will be special here - extra code
	{
//	if (deathmatch !=  2) // this is likely a meaningless deal for runes
		self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
	}
	else
		remove(self); // rule 2, rule 4 normal - its gone from the map

};

// bounce a created rune
// note: could be used for other items, with .hook

void() rune_bounce =
{
	if (self.map  == "rune" && self.classname == "item_sigil")
	{
		if (self.punchangle != v0)
			item_eject(self, self.punchangle);
		self.punchangle = v0; // dont bounce with every respawn in rule 1
	}
};

// make runes for runeserver

// NOTE: other code making runes should NEVER set .delay - this would allow this code to remove the rune if server is turned off live

float rune_map; // runes on level


void() rune_maker =
{
	local entity e;
	local float sf, f, rm, tm;

// periodic check once all runes made
	tm = 120 + random() * 60;

	if (rune_count < RUNE_CNT) // set timing now so checker can see it
	{
		f = RUNE_CNT / 2;
		if (rune_count < f) // make at least 1/2 sort of quicker
			tm = random() * 10;
		else
			tm = 5 + random() * 43;
	}

	self.nextthink = time + tm;


// fix leak - leak is stopped (apparently not) - now catch sit, where r_c < R_C but rune_map is full

	if (rune_count >= RUNE_CNT || tm > 60 || self.aflag > 5)
	if (RUNES == 2) // && 4
	{
		self.aflag =
		f = 0;
		e = find(world, map, "rune"); // excludes q3 items
		while (e)
		{
			if (e.spawnflags & RUNE_MASK)
			{
				rm = rm | e.spawnflags;
				f = f + 1;
			}
			e = find(e, map, "rune");
		}
		e = find(world, classname, "player"); // can include q3 items from flag set
		while (e)
		{
			if (!e.deadflag)
			if (e.classname != OBSERVER)
			if (e.rune_flag & RUNE_MASK)
			{
				rm = rm | e.rune_flag;
				f = f + 1;
			}
			e = find(e, classname, "player");
		}
		e = find(world, class_select, "class_bot");
		while (e)
		{
			if (!e.deadflag)
			if (e.rune_flag & RUNE_MASK)
			{
				rm = rm | e.rune_flag;
				f = f + 1;
			}
			e = find(e, class_select, "class_bot");
		}
		if (f != rune_count)
		{
			self.cnt = self.cnt + 1;
			if (rune_count >= RUNE_CNT || self.cnt > 4 || tm > 60)
			if (f < rune_count)
			{
				self.cnt = 0;
				rune_count = f;
				rune_map = rm; // need rebuilt rune map too
			}
		}
	}

	if (rune_count < RUNE_CNT)
	{
// make a rune
		e = spawn();
		if (e)
		{
			sf = 111;
			while (sf > 0)
			{
				f = rnd_bit_mask(RUNE_MASK);
				if (!(f & rune_map)) sf = 0;
				else f = 0;
				sf = sf - 1;
			}

			if (!f)
			{
				self.aflag = self.aflag + 1;
				if (WARNING) bprint("*** warning: rune_make could not find a rune that fit mask rules - giving up\n");
				remove(e);
//				remove(self);
				return;
			}
				
			e.mcode = rune_bit_code(0, f);

			self = e;
/*
			self.mcode = MC_SIGIL1 + rint(random() * 3.3);

			sf = 111;
			if (rune_count < 4) // spawn 4 uinque runes on a map when starting
			while (sf > 0)
			{
				f = rune_bit_code(self.mcode, 0) & RUNE_MASK;
				if (f && !(f & rune_map))
					sf = 0;
				else
					self.mcode = MC_SIGIL1 + rint(random() * 3.3);
				sf = sf - 1;
			}

			sf = 111;
			while (sf > 0)
			{
				f = rune_bit_code(self.mcode, 0);
				if (f & RUNE_MASK)
					sf = 0;
				else
					self.mcode = MC_SIGIL1 + rint(random() * 3.3);
				if (sf == 1)
				{
					f = 1;
					while (!( f & RUNE_MASK) && f < RUNE_MASK_ALL)
						f = f * 2;
					if (f > RUNE_MASK_ALL) // failed somehow to make any rune that fit rules
					{
						if (WARNING) bprint("*** warning: rune_make could not find a rune that fit mask rules - giving up\n");
						remove(self);
						return;
					}
				}
				sf = sf - 1;
			}
*/
			self.wad = item_by_mcode(self.mcode);

//			e = dyn_rndloc();
			e = find_tdest(FL_RSALL, null_string);

			if (!e) e = findradius(world.origin, 256000);
			if (!e) 
			{
				if (WARNING) bprint("*** warning: rune_make could not find a random (or any) location - giving up\n");
				remove(self);
				return; // crap - no location
			}
			v1 = e.origin + ' 0 0 8';
//			if (e.flags & FL_ITEM) // randomize away from other map items - 
//				v1 = stdv_rndloc(e.origin + ' 0 0 8', 50, 100); // uses ejector
			setorigin(self, v1);

			item_call(self.wad);

			self.punchangle = MED_BOUNCE; // for rune_bounce

			if (Q_100 || PK_100) // if *100 - need this here
			{
				SUB_regen(); // note: does not use positioning code correctly
//				item_eject(self, MED_BOUNCE);
//				self.think = SUB_regen; // dont go thru place_item - use regen method
//				self.nextthink = time + 1 + 3 * random(); // spread em out
//				self.model = string_null;
			}
//			else
//			item_eject(self, MED_BOUNCE);

			AddToSplash(self); // splash code kills lava immersed runes

			rune_map = rune_map | self.spawnflags;
			self.count = 2 + random() * 3.8; // controls no-touch reposition code in check movement deal
			self.delay = self.cnt = 0;

		  if (DYN_SHOW || !RUNE_SHOW)
		  {
				bprint("\n"); // RUNE_MSG_ISO
				if (self.spawnflags & TECH_MASK_ALL)
					bprint("\b*** TECH spawned: ");
				else
					bprint("\b*** RUNE spawned: ");
				bprint(self.netname);
				if (e)
				{
					bprint(" near: ");
					bprint(e.classname);
				}
				else
				bprint(" on the map");
				bprint("\n");
				bprint("\n"); // RUNE_MSG_ISO
			}

			rune_count = rune_count + 1;
		}
	}
};

// relocation code - called by ip_checkForMovement & from splash.qc

// could move anything, effect should prob be client sided

void() fade_relocate =
{
	if (!self.alpha) self.alpha = 1.03; // make sure the fade doesnt hit 0 and fire this again

	self.think = fade_relocate;
	self.nextthink = time + 0.1;

	if (self.alpha < 0.6) self.touch = SUB_Null;
	else self.touch = painkeep_touch;

	self.alpha = self.alpha + self.lip;

	if (self.lip < 0)
	if (self.alpha < 0.05)
	{
		self.lip = 0.05;
		setorigin(self, self.ip_orgOrigin);
		item_eject(self, MED_BOUNCE);		
	}

	if (self.lip > 0)
	if (self.alpha > 1)
	{
		self.alpha = 1.03;
		self.lip = 0;
		self.think = self.th_stand; // done - back to the usual
		self.th_stand = SUB_Null;
		self.nextthink = self.lefty;
	}
};

void() rune_relocate =
{
	local entity e;

	if (self.think == fade_relocate) return; // heh heh - dont relocate while relocating

	self.cnt = self.cnt + 1;
	self.delay = self.delay + 1;
	if (self.cnt > self.count || self.delay > RUNE_MOVE || self.hook) // not touched in 2 - 6 mins or > 10 mins, or force relocate with .hook
	{
		self.hook = FALSE;
		if (self.delay > RUNE_MOVE) // reload val
		{
			RUNE_MOVE = 10 + rint(random() * 2.5 + random() * 2.5);
			self.delay = 0;
		}
		e = dyn_rndloc();
		if (!e) e = findradius(world.origin, 256000); // if nothing, it wont move

		self.th_stand = self.think;
		self.lefty = self.nextthink;
		self.think = fade_relocate;
		self.nextthink = time + 0.1;
		self.lip = -0.05;

//			setorigin(self, v1);
//			item_eject(self, MED_BOUNCE);
		self.ip_orgOrigin = self.origin; // if no location found it will bounce here
		self.count = 2 + random() * 3.8; // reset for new location
		self.cnt = 0;

		if (e)
		{
			self.ip_orgOrigin = e.origin + ' 0 0 4'; // something found - move rune here
		  if (DYN_SHOW || !RUNE_SHOW)
		  {
				bprint(RUNE_MSG_ISO);
				bprint("\b*** RUNE relocating: ");
				bprint(self.netname);
				bprint(" near: ");
				bprint(item_ident(e));
				bprint("\n");
				bprint(RUNE_MSG_ISO);
			}
		}
	}
};

// count chg - remove rune(s) - must NOT remove non server made runes!

void(float r1, float p) remove_rune =
{
	local float f;
	local entity e;

	f = ceil(r1);
	e = find(world, map, "rune");

	while (e && f > 0)
	{
		f = f - 1;
		if (f < 1)
		{
			if (e.classname == "item_sigil")
			{
				if (p)
				{
				bprint("\b*** RUNE removed: ");
				bprint(e.netname);
				bprint("\n");
				}
				remove(e);
				e = world;
			}
		}
		e = find(e, map, "rune");
	}
};

/*
base rule set

1.
Original rune quake.
4 end episode runes will randomly spawn to the tune of sv_c_rune_cnt.
Runes operate just like quad damage - 30 secs of power, then the rune respawns at its location.
You can only have 1 rune at a time so there are no combind effects or perils.
(unless rule 1 multi is true.)

earth magic	(end1.mdl)	Resistance = 1/2 damage all attacks
black magic	(end2.mdl)	Damage = 2 x damage for 30 secs.  8 x damage if combined with quad.
hell magic	(end3.mdl)	Haste - double fire rate most weps
elder magic	(end4.mdl)	Regeneration - regen 5 health | armor ever 1/2 second

2.
Ctf (lithium) style runes.
Standard 4 end of episode rules with new powers + up to 4 new runes as spec'ed by sv_c_rune_cnt.
More like the lithium system from Quake 2.  Once you get a rune its yours till you die.  It gets tossed out then.
Runes can also be freed from a player by: powerful blast damage, air cannon blast, pulled by harpoon, pulled
loose by gravity well.  Lava (or falling into a sky brush) will destroy a rune causing it to respawn somewhere.
Runes can combine to give holders more powers, or detrimental effects. You can also throw out runes
at this rule level.
Damage = 2 x damage.  Will not combine with quad - quad has no effect.

runes will not use lith models if - ULOK2 is false, or rule == -2

(if rule 1 multi is false you can only hold 1 rune and 1 tech.)

*/
// run runes

void() run_runes =
{
	local entity e;
	local float f, k, sf, r;

	r = cvar("sv_c_rune"); // because we need a sneek peak

	RULOK2 = ULOK2;

	if (DARKPLACES) RULOK2 = 1;
	if (!RULOK2)
	if (r == 2) // note: rule 3, 4 
		r = -2;

	f = RUNE_VAMPIRE; // add in vampire for rules -2
	if (r == -2) RUNE_MASK_ALL = RULE1_MASK | f;
	else if (r < 2) RUNE_MASK_ALL = RULE1_MASK; // set all mask for rules
	else if (r > 1) RUNE_MASK_ALL = RULE2_MASK;

	RUNE_MASK = cvar("sv_c_rune_mask") & RUNE_MASK_ALL;
	if (RUNE_MASK < 1 || RUNE_MASK > RUNE_MASK_ALL)
	{
		RUNE_MASK = RUNE_MASK_ALL;
	}

	RUNE_AR1M = cvar("sv_c_rune_allowrule1multi");
	RUNE_R1SFX = 0;
	if (RUNE_AR1M)
		RUNE_R1SFX = cvar("sv_c_rune_rule1sfx"); // if true and multi -  3 | 4 runes in 1 player have side effects

	RUNE_3_ACM = cvar("sv_c_rune_3acm");

	if (RUNE_MASK < 1)
	{
		bprint("\n***   \bRunes\b of power misconfigured - nothing to do, exiting...\n");
		return;
	}

	if (r == -2) RUNE_VAMPIRE_PER = 0.25; // old
	else RUNE_VAMPIRE_PER = 0.5; // lith
	
	NO_TECH = FALSE;
	f = TECH_MASK_ALL;
	f = f & RUNE_MASK;
	if (!f)	NO_TECH = TRUE; // rune mask disallowed techs
	if (r < 2) NO_TECH = TRUE;

	if (r < 2)
	{
		rune_resist_sound = "items/protect3.wav";
		rune_strength_sound = "items/damage3.wav";
		rune_haste_sound = "boss1/sight1.wav";
		rune_regen_sound = "items/r_item1.wav";
		rune_vampire_sound = "q2_snd/makr_pain2.wav"; // TDO: appr q1 sound
	}
	else
	{
		rune_resist_sound = "q2_snd/force2.wav";
		rune_strength_sound = "q2_snd/damage3.wav";
		rune_haste_sound = "q2_snd/x_light.wav";
		rune_regen_sound = "q2_snd/s_health.wav";
		rune_vampire_sound = "q2_snd/makr_pain2.wav";
		tech_adoc_sound = "q2_snd/tech4.wav";
		tech_amp_sound = "q2_snd/tech2.wav"; // tech2x - comb with quad
		tech_dsh_sound = "q2_snd/tech1.wav";
		tech_tiem_sound = "q2_snd/tech3.wav";
	}

	e = find(world, classname, "player"); // add archon pts for runes
	while (e)
	{
		if (e.rune_flag)
		{
			f = bit_cnt(e.rune_flag, FALSE);
			e.archon = e.archon + (ARCHON_RUNE * f);
		}
		e = find(e, classname, "player");
	}
	e = find(world, class_select, "class_bot");
	while (e)
	{
		if (e.rune_flag)
		{
			f = bit_cnt(e.rune_flag, FALSE);
			e.archon = e.archon + (ARCHON_RUNE * f);
		}
		e = find(e, class_select, "class_bot");
	}

 	if (RUNE_RANDOM != cvar("sv_c_rune_random")) // changed random state
	{
		RUNE_RANDOM = cvar("sv_c_rune_random");

		R_EARTH = RUNE_FLG_RS; // normal cfg
		R_BLACK = RUNE_FLG_DM;
		R_HELL = RUNE_FLG_HS;
		R_ELDER = RUNE_FLG_RG;

		R_VAMPIRE = RUNE_VAMPIRE; // lith + extra
		R_AMMO = RUNE_AMMO; // here for items - not enabled yet
		R_FLY = RUNE_FLG_FLY;

		T_DSH = TECH_DSH; // lith techs
		T_AMP = TECH_AMP;
		T_TEIM = TECH_TEIM;
		T_ADOC = TECH_ADOC;

		if (RUNE_RANDOM)
		{
			if (!NO_TECH)
			{
				T_DSH = 0; // random techs
				T_AMP = 0;
				T_TEIM = 0;
				T_ADOC = 0;

				sf = 100;
	//			f = TECH_MASK_ALL; // already done
	//			f = f & RUNE_MASK;
				while (f != 0 && sf > 0) // try to make a nice "one of each" deal
				{
					k = rnd_bit_mask(f);
					if (!T_DSH) T_DSH = k;
					else if (!T_AMP) T_AMP = k;
					else if (!T_TEIM) T_TEIM = k;
					else if (!T_ADOC) T_ADOC = k;

					f = f - (f & k);
					sf = sf - 1;
				}

				if (!T_DSH) T_DSH = rnd_bit_mask(TECH_MASK_ALL); // any fail get assigned random powers
				if (!T_AMP) T_AMP = rnd_bit_mask(TECH_MASK_ALL);
				if (!T_TEIM) T_TEIM = rnd_bit_mask(TECH_MASK_ALL);
				if (!T_ADOC) T_ADOC = rnd_bit_mask(TECH_MASK_ALL);
			}

			R_EARTH = 0; // random runes
			R_BLACK = 0;
			R_HELL = 0;
			R_ELDER = 0;
			R_VAMPIRE = 0;

			sf = 100;
			f = RULE1_MASK;//RUNE_MASK_ALL;
			if (RUNES > 1) f = f | RUNE_VAMPIRE; // add in vampire for rules 2
			f = f & RUNE_MASK;
			while (f != 0 && sf > 0) // try to make a nice "one of each" deal
			{
				k = rnd_bit_mask(f);
				if (!R_EARTH) R_EARTH = k;
				else if (!R_BLACK) R_BLACK = k;
				else if (!R_HELL) R_HELL = k;
				else if (!R_ELDER) R_ELDER = k;
				else
				{
					if (r > 1)
					if (!R_VAMPIRE) R_VAMPIRE = k;
				}
				f = f - (f & k);
				sf = sf - 1;
			}

			if (!R_EARTH) R_EARTH = rnd_bit_mask(RUNE_MASK); // any fail get assigned random powers
			if (!R_BLACK) R_BLACK = rnd_bit_mask(RUNE_MASK);
			if (!R_HELL) R_HELL = rnd_bit_mask(RUNE_MASK);
			if (!R_ELDER) R_ELDER = rnd_bit_mask(RUNE_MASK);
			if (!R_VAMPIRE) R_VAMPIRE = rnd_bit_mask(RUNE_MASK);

			bprint("***   Runes randomly selected from pool of available rune powers\n");
		}
	}

	mk_rune_set(); // manual config

	if (RUNES != fabs(cvar("sv_c_rune"))) // changed, off or on - controls rune server
	{
		RUNES = fabs(cvar("sv_c_rune")); // neg. value additional sequence

		e = find(world,map,"rune"); // off or on, rid map of runes & makers
		while (e)
		{
			if (e.classname == "item_sigil")
				remove(e);
			e = find(e,map,"rune");
		}
		e = find(world, classname, "rune_maker");
		while (e)
		{
			remove(e);
			e = find(e, classname, "rune_maker");
		}
		rune_count = 0;

		if (RUNES) // turning runes on
		{
			e = spawn();
			if (e)
			{
				e.classname = "rune_maker";
				e.think = rune_maker;
				e.nextthink = time + PIC_TO + 2 + 23 * random(); // do this well after items spawn - PIC_TO
			}
			bprint("\n***   \bRunes\b of power will spawn on this map - keep an eye out\n");
			rune_new_map = TRUE;
			rune_map = 0; // clear this - IMP: clear any rune flags players might have
		}
		else
			bprint("\n***   \bRune\b server - turned off and all spawned runes removed\n");

		if (!cvar("sv_c_rune_cnt")) // defaults - must check any time rule is changed
		{
			RUNE_CNT  = 4;
			if (r == -2) RUNE_CNT = 5;
			else if (RUNES > 1) RUNE_CNT = 9;
		}
	}
	else if (RUNES)
	if (!rune_new_map)
	{
		bprint("\n***   \bRunes\b of power will spawn on this map - keep an eye out\n");
		rune_new_map = TRUE;
	}


 	if (cvar("sv_c_rune_cnt")) // defaults
 	if (RUNE_CNT != cvar("sv_c_rune_cnt"))
	{
		RUNE_CNT = cvar("sv_c_rune_cnt");
		rune_count = cnt_ent(world, "map", "rune");
		if (RUNE_CNT < 1)
		{
			bprint("\n***   \bRune\b server - manually configured < 1 rune - no runes will exist!\n");
		}
		if (rune_count > 0)
		{
			while (rune_count > RUNE_CNT)
			{
				f = random() * rune_count;
				remove_rune(f, TRUE);
				rune_count = cnt_ent(world, "map", "rune");
			}
			if (rune_count < RUNE_CNT)
			{
				e = find(world, classname, "rune_maker");
				if (e) e.nextthink = time + 10 + random() * 60;
			}
		}
	}

	if (autocvar_pk_runemap) // display rune info on console (network - all players see this)
	{
		stuffcmd(self, "con_notify 22\n"); // for this op
		stuffcmd(self, "con_notifytime 10\n");

		bprint("\n\bRunes:\n\n");
		if (RUNES) bprint("Runes will appear in random locations\n");
		else bprint("Rune server is deactivated\n"); // NOTE: runes can still appear on map from func_dyn, rndize
		bprint("total rune count : ");
		bprint(ftos(RUNE_CNT));
		if (!cvar("sv_c_rune_cnt"))
			bprint(" -- using defualt count");
		bprint("\n");
		bprint("runes on map : ");
		bprint(ftos(rune_count));
		bprint("\n");

		if (RUNE_RANDOM) bprint("runes are selecting random powers\n");
		bprint("\nallowed runes mask: ");
		bit_print(RUNE_MASK_ALL, RUNE_MASK);
		bprint(", of total : ");
		bit_print(RUNE_MASK_ALL, RUNE_MASK_ALL);
		bprint("\nwhere 0 indicates a forbidden rune\n\n");

		rune_map_print(R_EARTH);
		rune_map_print(R_BLACK);
		rune_map_print(R_HELL);
		rune_map_print(R_ELDER);
		if (RUNES > 1) rune_map_print(R_VAMPIRE);
		if (!NO_TECH)
		{
			rune_map_print(T_DSH);
			rune_map_print(T_AMP);
			rune_map_print(T_TEIM);
			rune_map_print(T_ADOC);
		}

		bprint("\n");
		if (nonserver_rune_found)
			bprint("* non server Runes are loaded on this map.\n\n");
//		cvar_set("pk_runemap", "0"); // ideally want a stuffcmd, but this is called from a think - no idea which player set this.
		autocvar_pk_runemap = 0;
	}

};

.float rg_time;
.float regeneration_sound;
.float haste_sound;

void() RegenerationSound =
{
// RUNE play healing sound if player has regen rune
	if (self.regeneration_sound < time)
	{
		self.regeneration_sound = time + 1;
		sound(self, CHAN_BODY, rune_regen_sound, 1, ATTN_NORM);
	}
};

void() rune_regen =
{
	local float f, h, r;
//	local entity e;

	if (self.deadflag)
		return;

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	if (self.rg_time > time)
		return;

	r = cvar("sv_c_rune");

	f = 5;
	h = 100;
	if (self.rune_flag & TECH_ADOC) // has tech
	{
		h = 150;
		if (self.rune_flag & RUNE_FLG_RG) // has both!
			f = 10;
	}

	if (RUNES > 1)
	if (self.rune_flag & RUNE_FLG_RG) // has to have rune, excludes tech
		h = 200;
/*
note how fcktard complicated the lith regen rune is:

max = 200
cap = 3.5
null_string = 0.25 // rune_regen->value

	if(player->rune & RUNE_REGEN && player->health < rune_regenmax->value) {
		float health = player->health + player->client->regen_remainder;
		float newhealth = rune_regenmax->value / health;
		if(newhealth > rune_regencap->value)
			newhealth = rune_regencap->value;
		newhealth *= rune_regen->value * 0.625;
		health += newhealth;
		player->health = (int)health;
		player->client->regen_remainder = health - (float)player->health;
*/

// note: q3 regen item is not combind with runes

	if (self.wad == "art_shell") // q3 regen takes health to 200
	{
		f = 5; // incase of tech overlap
		if (self.volume > 100) // set for player during item touch q3_pwr_touch
			h = self.volume;
		else
			h = 200; // dont have access to q3 ent here cant use = self.volume; - fixed during touch
	}

	if (self.health < (h * self.health_modifier) )
	{
		self.health = self.health + f; // NOTE: violates T_Heal rule (implied from t_dmg rule) of only fn to add health - relates to morphs & needs morph tweak here
		if (self.health > (h * self.health_modifier))
			self.health = (h * self.health_modifier);
		RegenerationSound();
	}

	pk_setDamageSkin(self);
	self.rg_time = time + 0.5;

	armorsave_rev(self);

	if (r > 1)
	{
		if (self.rune_flag & TECH_ADOC)
		{
			h = 150;
			f = 5;
			if (self.armorvalue < h)
			{
				self.armorvalue = self.armorvalue + f;
				if (self.armorvalue > h) self.armorvalue = h;
				if (self.armortype < DEF_DOC_ARMORTYPE) self.armortype = DEF_DOC_ARMORTYPE;
				if (!self.items & IT_ARMOR_BITS) self.items = self.items | IT_ARMOR2;
			}
		}
		return;
	}

//	if (self.target2 != "progs/q3_art.mdl") // apparently q3 doesnt regen armor
	if (!stack_search(self, "item_regen")) // apparently q3 doesnt regen armor
	if (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3))
	if (self.armorvalue < 200) // q2 allows values over 200
	{
		self.armorvalue = self.armorvalue + f;
		if ((self.items & IT_ARMOR3) && (self.armorvalue > 200)) // NOTE: increments q2 armor beyond local max limit in some cases (q2 jacket)
			self.armorvalue = 200;
		else if ((self.items & IT_ARMOR2) && (self.armorvalue > 150)) // note: these need to be chaos change able
		  self.armorvalue = 150;
		else if ((self.items & IT_ARMOR1) && (self.armorvalue > 100))
			self.armorvalue = 100;
		else
			RegenerationSound();
	}
};

// IMP: other suck head issues
// more things that prevent suck head leech -
// - archons are immune


void() rune_vamp =
{
	local float f;

	if (self.health_modifier < 2)
	if (self.health <= (self.max_health * self.health_modifier * 2)) return; // same as 200 from lith

	if (self.health_modifier >= 2)
	if (self.health <= (self.max_health * self.health_modifier * 1.25)) return; // already have > 200

	if (self.regeneration_sound > time) return;

	self.regeneration_sound = time + 1;

	f = 1;
	
// suck head has too much health - do an upper bleed out
	if (ENHANCED)
	{
		if (self.rune_flag & TECH_DSH) // tech cuts upper bleed out in half
			f = 0.5;

		self.health = self.health - 1;

		if (random() < 0.2)
		if (self.health > (1.5 * self.max_health * self.health_modifier))
		{
			if (!self.rune_flag & TECH_DSH) // tech cuts bleed out
				self.health = self.health - 0.5;
		}
		if (self.health > (2 * self.max_health * self.health_modifier))
			self.health = self.health - (1 * f);
		if (self.health > (4 * self.max_health * self.health_modifier))
			self.health = self.health - (1 * f);
		if (self.health > (8 * self.max_health * self.health_modifier))
			self.health = self.health - (2 * f);
	}
};

void() HasteSound =
{
// RUNE play haste (Chthon's roar) sound if player has Haste rune
		if (self.haste_sound < time)
		{
			self.haste_sound = time + 2;
			if ( (self.rune_flag & TECH_TEIM) && !(self.rune_flag & RUNE_FLG_HS) )
				sound(self, CHAN_BODY, tech_tiem_sound, 1, ATTN_NORM);
			else
			sound(self, CHAN_BODY, rune_haste_sound, 1, ATTN_NORM);			
		}
};

void() rune_dmg_sound =
{
	if (self.rune_flag & RUNE_FLG_DM || self.rune_flag & TECH_AMP)
	{
		if (RUNE_QUAD_COMB)
		if (self.rune_flag & TECH_AMP)
//		if (cvar("sv_c_rune") > 1 && RULOK2) // quad & rune
		if (self.items & IT_QUAD)
		if (self.super_sound == (time + 1))
		{
			sound (self, CHAN_BODY, "q2_snd/tech2x.wav", 1, ATTN_NORM);
			return;
		}

		if (self.super_sound < time) // note - quad sound blocks this
		{
			self.super_sound = time + 1;
			if (RUNE_TECH_DMG_COMB && (self.rune_flag & TECH_AMP) && (self.rune_flag & RUNE_FLG_DM))
				sound (self, CHAN_BODY, "q2_snd/tech2x.wav", 1, ATTN_NORM);
			else
			if ( (self.rune_flag & TECH_AMP) && !(self.rune_flag & RUNE_FLG_DM) )
				sound (self, CHAN_BODY, tech_amp_sound, 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, rune_strength_sound, 1, ATTN_NORM);
		}
	}
};

// fn(rune_haste) - implement haste rune effect on [ weapon ] attacks

// op haste - ret true if att_fin needs set
// returns false if haste rune in effect

// atf - attack finished time to add - this must be the hasted value

float(float atf) rune_haste =
{
	local float f;

	f = 0;
	if (self.rune_flag & RUNE_FLG_HS) f = 1;
	if (self.rune_flag & TECH_TEIM) f = f + 1;
	if (!f) return(TRUE);

	self.attack_finished = time + (atf / f); 
	HasteSound();
	return(FALSE); // IMP: double haste in other code - where o/p from this is just a flag = return value of f - means all conditional on this needs reversed
};

void() rune_precache =
{
	precache_model ("progs/end1.mdl");
	precache_model ("progs/end2.mdl");
	precache_model ("progs/end3.mdl");
	precache_model ("progs/end4.mdl");

	precache_sound ("misc/runekey.wav");
	precache_sound ("items/r_item1.wav"); // regen
	precache_sound ("boss1/sight1.wav"); // haste
};

/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

// NOTE: q100 code never used because q100 can run a rune server - think on this

// fix initial server map load runes where random is on

void () item_sigil_set =
{
	if (RUNE_RANDOM)
	{
		if (self.owner.duration & 1) self.owner.spawnflags = rune_bit_code(MC_SIGIL1, 0);
		else if (self.owner.duration & 2) self.owner.spawnflags = rune_bit_code(MC_SIGIL2, 0);
		else if (self.owner.duration & 4) self.owner.spawnflags = rune_bit_code(MC_SIGIL4, 0);
		else if (self.owner.duration & 8) self.owner.spawnflags = rune_bit_code(MC_SIGIL8, 0);
	}
	remove(self);
};

void () item_sigil =
{
	local float f, rune, rul;

	if (!RUNES)
	if (time < PIC_TO) // note: for successful op with this code time out must be > 2
	{
		if (time < 2) // delay till we can read cvar (run_runes) - if this isnt done for an initial server start map load rune has sigil_touch set and things fail
		{
			self.nextthink = time + 1;
			self.think = item_sigil;
			return;
		}
		rune = FALSE;
		if (RUNES != fabs(cvar("sv_c_rune"))) rune = cvar("sv_c_rune"); // map load issue - 1st map loaded has no RUNES val here for map load runes
		chaos_spawn(0, 0, 0, 0,  v0, v0, v0, v0, v0, null_string, null_string, SUB_Null, PIC_TO, item_sigil_set, SUB_Null, self, world); // random rune spawnflags fix
	}

	if (!self.spawnflags)
//		objerror ("no spawnflags");
	{
		if (Q_100 && Q_100_OBJERR) objerror("no spawnflags");
		else
		{
			if (WARNING)
			{
				if (Q_100 || PK_100)
					bprint("\n*** warning:\nsigil with no spawnflags - removed.\n");
				else
					bprint("\n*** warning:\nsigil with no spawnflags - randomizing.\n");
			}
			if (Q_100 || PK_100)
			{
				remove(self);
				return;
			}
			else
			self.spawnflags = rnd_bit_mask(15);
		}
	}

	rul = cvar("sv_c_rune"); // see -2 for q1 only models in rule 2
	if (!RULOK2) 
	if (rul == 2) // note: rule 3, 4 
		rul = -2; // models not avail

	self.noise = "misc/runekey.wav";
	self.noise4 = "misc/null.wav"; // CHECK: q2 code - see if pooted out runes make noise
	precache_sound ("misc/runekey.wav");

	self.duration = 0;
	if (time < PIC_TO) // make sure map runes load the correct appearance even if powers change
	{
		self.duration = self.spawnflags & RUNE_MASK_ALL;
		if (self.spawnflags & 1) f = rune_bit_code(MC_SIGIL1, 0);
		else if (self.spawnflags & 2) f = rune_bit_code(MC_SIGIL2, 0);
		else if (self.spawnflags & 4) f = rune_bit_code(MC_SIGIL4, 0);
		else if (self.spawnflags & 8) f = rune_bit_code(MC_SIGIL8, 0);
		else f = rnd_bit_mask(15); // fail! no spawnflag - just pick one at random
		self.spawnflags = f;
	}
	self.mask_x = MORPH_ALL; // everyone can get runes
	self.archon = ARCHON_ART;

	if (rul < 2 || time < PIC_TO)
	{
		if (self.spawnflags & R_EARTH)
		{
			precache_model ("progs/end1.mdl");
			setmodel (self,"progs/end1.mdl");
			self.netname = "Earth magic"; // Cataboligne - 5.32.10 - for rune server		

			if (R_EARTH == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY);
		}
		if (self.spawnflags & R_BLACK)
		{
			precache_model ("progs/end2.mdl");
			setmodel (self,"progs/end2.mdl");
			self.netname = "Black magic"; // Cataboligne - 5.32.10 - for rune server

			if (R_BLACK == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_HELL)
		{
			precache_model ("progs/end3.mdl");
			setmodel (self,"progs/end3.mdl");
			self.netname = "Hell magic"; // Cataboligne - 5.32.10 - for rune server

			if (R_HELL == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_ELDER)
		{
			precache_model ("progs/end4.mdl");
			setmodel (self,"progs/end4.mdl");
			self.netname = "Elder magic"; // Cataboligne - 5.32.10 - for rune server

			if (R_ELDER == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_VAMPIRE) // bit 64
		{
			precache_model ("progs/g_axe.mdl");
			setmodel (self,"progs/g_axe.mdl"); // hur?
			self.netname = "Vampire magic";
			self.effects = EF_DIMLIGHT;

			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
	}
	else
	{
		setmodel (self,"progs/q2_keypyramid.mdl");
		self.noise = "q2_snd/pkup.wav";
		if (self.spawnflags & R_EARTH)
		{
			self.netname = rune2_name(R_EARTH); //"Resistance";
			self.frame = 1;
			self.skin = 2;

			if (R_EARTH == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_BLACK)
		{
			self.netname = rune2_name(R_BLACK); // "Strength";
			self.frame = 1;
			self.skin = 1;

			if (R_BLACK == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_HELL)
		{
			self.netname = rune2_name(R_HELL); // "Haste";
			self.frame = 1;
			self.skin = 3;

			if (R_HELL == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_ELDER)
		{
			self.netname = rune2_name(R_ELDER); // "Regeneration";
			self.frame = 1;
			self.skin = 4;

			if (R_ELDER == RUNE_FLG_RG)
			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
		if (self.spawnflags & R_VAMPIRE) // bit 64
		{
			self.netname = rune2_name(R_VAMPIRE); // "Vampire";
			self.frame = 1;
			self.skin = 6;

			if (ENHANCED) self.mask_x = MORPH_ALL - (MORPH_ALL & CB_ZOMBY) ;
		}
	}


	if (!NO_TECH) // do techs
	{
		self.noise = "q2_snd/pkup.wav";
		if (self.spawnflags & T_DSH) // bit 131072
		{
			self.netname = "Disruptor Shield";
			setmodel (self,"progs/q2_ctf_resist.mdl");
		}
		if (self.spawnflags & T_AMP) // bit 262144
		{
			self.netname = "Power Amplifier";
			setmodel (self,"progs/q2_ctf_stren.mdl");
		}
		if (self.spawnflags & T_TEIM) // bit 524288
		{
			self.netname = "Time Accelerator";
			setmodel (self,"progs/q2_ctf_haste.mdl");
		}
		if (self.spawnflags & T_ADOC) // bit 1048576
		{
			self.netname = "Auto Doc";
			setmodel (self,"progs/q2_ctf_regen.mdl");
		}
	}


	if (time > PIC_TO)
	if(self.map == null_string)
		self.map = "rune"; // Cataboligne - 5.32.10 - for rune server

	if (RUNES || rune)
		self.touch = rune_touch;
	else
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};
