/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: pkpitems.qc
 *
 * date: Wed Aug 12 05:11:43 UTC 2009
 *
 * 
 *
 */

// painkeep artifacts support


void () pkplus_touch =
{
	local entity stemp;
	if (!PK_ART) return;

	if (other.classname != "player") //&& other.classname != "pk*bot")
	{
		if (self.touch != painkeep_touch)
		if (other.classname == "Harpoon")
			grap_checkIfGrap();
		return ;
	}

	if (other.builtin)
	if (!other.builtin & IT_AXE) // no axe, cant use pki
		return;

	if (self.pk_items == PKPLUS_IT_EGO)
	{
		if (other.pkplus_egoammo >= PKPLUS_EGOAMMO_MAX) return ;
		other.pkplus_egoammo = (other.pkplus_egoammo + 1);
	}
	if (self.pk_items == PKPLUS_IT_TOMB)
	{
		if (other.pkplus_tombammo >= PKPLUS_TOMBAMMO_MAX) 	return ;
		other.pkplus_tombammo = (other.pkplus_tombammo + 1);
	}
	if (self.pk_items == PKPLUS_IT_ACTOR)
	{
		if (other.pkplus_actorammo >= PKPLUS_ACTORAMMO_MAX) return ;
		other.pkplus_actorammo = (other.pkplus_actorammo + 1);
	}
	if (self.pk_items == PKPLUS_IT_PHONE)
	{
	local entity e;

		e = vchk(IT_AXE, PKPLUS_IT_PHONE, other.vwepent);
		if (e.eweapon) return; // holdable tele

		if (other.pkplus_phoneammo >= PKPLUS_PHONEAMMO_MAX) return ;
		other.pkplus_phoneammo = (other.pkplus_phoneammo + 1);
	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	sound (other,CHAN_ITEM,"misc/pickup/tone2.wav",1,ATTN_NORM);
	stuffcmd (other,"bf\n");

	stemp = self;
	self = other;
	W_SetCurrentAmmo ();
	self = stemp;

	self.solid = SOLID_NOT;
	self.model = null_string;

	if (deathmatch == 1 || deathmatch == 3)
	{
		if ((self.pk_items == PKPLUS_IT_EGO) || (self.pk_items == PKPLUS_IT_PHONE))
		{
			self.nextthink = (time + (RSP_TIME * 4));
		}
		else
		{
			self.nextthink = (time + RSP_TIME * 2);
		}
		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets ();
};

// handle live pk_art on startup

void(entity e) pkplus_item_control =
{
	if (e.classname == "func_make") return; // override

// no sense in working removed items or constantly rndize items
	if (cvar("it_place_item") == 1)
	if (e.think == pic_restore_item) // still check dynamics and live map ents
		return;

// if pk_art is turned off, this hijacks the items rndize think and force thinks it
	if (!PK_ART)
	if (cvar("it_place_item") == 2 || cvar("it_place_item") == 3) // when turning on - this should never get here
	{
//		if (!PK_ART)
//		{
//			if (cvar("it_place_item_reload")) // turning off & in rndize_item control
	//		if (cvar("it_place_item_reload") < 60) return;
//			{
				local entity k;
				k = find(world,classname,"rndize_item");
				while (k)
				{
					if (k.owner == e) // do we need to verify this isnt a dynamic_item ??
					{
						k.event = "pkpitem"; // so we can find when art back on
						k.think = rndize_item;
						k.nextthink = time + random() * 5; // force quick re-think to rndize again
					}
					k = find(k,classname,"rndize_item");
				}			
//			}
//		}
		return;
	}

	if (PK_ART) // turned back on - come here from loop
	{
		if (e.mcode != e.scode)
		{
			e.mcode = e.scode;
			e.wad = item_by_mcode(e.mcode);
			item_call_save(e, e.wad);
		}
		else
		{
			setmodel (e,e.mdl);
			e.touch = painkeep_touch;
			e.pk_touch = pkplus_touch;
		}
		return;
	}

#ifdef warning
	if (e.event == "dynamic_item")
		{
			if (WARNING & 2) bprint("*** Warning - dynamic items: pk_art is off and dynamic made a pkplus item - hiding\n");
		}
//		else
//		if (WARNING & 2) bprint("*** Warning - pk_art is off and code made a pkplus item - hiding\n");
#endifdef

	if (!cvar("pk_art_rep"))
		{
			setmodel (e,null_string);
			e.touch = SUB_Null;
		}
	else
		{
			local float f;
			f = MC_PK_RNDITM;
//			if (e.mcode > 149 && e.mcode < MC_PK)
			e.mcode = MC_PULSE_NAILGUN + rint(random() * f); // NOTE: starts with pulse gun - this could change if item order in mcode is changed!
			e.wad = item_by_mcode(e.mcode);
			if (e.wad != null_string)
			{
//				e.pk_touch = (void()) 0; // so we can touch the new things
				e.pk_touch = SUB_Void;
				item_call_save(e, e.wad);
			}
			else
			{
				e.mcode = e.scode;
				setmodel (e,null_string);
				e.touch = SUB_Null;
			}
		}
};

// twiddled after map load



// only called when pk_art toggled

void() pkplus_item_control_loop =
{
	local entity e;//, sv;

// note: disabled - if rndize makes any that get clobbered we want to restore them
//	if (cvar("it_place_item") != 0)
//		return;

	if (PK_ART)
	if (cvar("it_place_item") == 2 || cvar("it_place_item") == 3)
	{
		e = find(world, event, "pkpitem"); // looking for rndize_* control ents for pkp items
		while (e)
		{
			e.owner.mcode = MC_TOMB + rint(random() * 3);
			e.owner.wad = item_by_mcode(e.owner.mcode);
			item_call_save(e.owner, e.owner.wad);
//			e.wad = null_string;
			e = find(e, event, "pkpitem");
		}
		return;
	}

	e = find(world, class_select, "pkplus_item");
	while (e)
	{
		pkplus_item_control(e);
		e = find(e, class_select, "pkplus_item");
	}

// additional search if rndize active - look for any pk item randomly turned into a pkplus item
	if (cvar("it_place_item") == 2 || cvar("it_place_item") == 3)
	if (!PK_ART)
	{
		e = find(world, event, "pkpitem");
		while (e)
		{
			pkplus_item_control(e);
			e = find(e, event, "pkpitem");
		}	
	}

};

void () item_pkplus_ego =
{
	self.touch = pkplus_touch;
	precache_model ("progs/ego.mdl");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/ego.mdl");
	self.netname = "EGO";
	self.pk_items = PKPLUS_IT_EGO;
	setsize (self,'-16 -16 -24','16 16 32');
	self.mask_x = MORPH_ALL;
	StartItem ();
	if (self.class_select == null_string) self.class_select = "pkplus_item";
	if (!PK_ART) pkplus_item_control(self);

	self.archon = ARCHON_WEP + 0.1;
};

void () item_pkplus_tomb =
{
	self.touch = pkplus_touch;
	precache_model ("progs/tomb.mdl");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/tomb.mdl");
	self.netname = "Tomb";
	self.pk_items = PKPLUS_IT_TOMB;
	setsize (self,'-16 -16 -24','16 16 32');
	self.mask_x = MORPH_ALL;
	StartItem ();
	if (self.class_select == null_string) self.class_select = "pkplus_item";
	if (!PK_ART) pkplus_item_control(self);

	self.archon = ARCHON_WEP + 0.1;
};

void () item_pkplus_actor =
{
	self.touch = pkplus_touch;
	precache_model ("progs/actor.mdl");
	setmodel (self,"progs/actor.mdl");
	self.netname = "Actor";
	self.pk_items = PKPLUS_IT_ACTOR;
	setsize (self,'-16 -16 -24','16 16 32');
	self.mask_x = MORPH_ALL; // everyone can get arts
	StartItem ();
	if (self.class_select == null_string) self.class_select = "pkplus_item";
	if (!PK_ART) pkplus_item_control(self);

	self.archon = 0.02;
};

void () item_pkplus_phone =
{
	self.touch = pkplus_touch;
	precache_model ("progs/phone.mdl");
	setmodel (self,"progs/phone.mdl");
	self.netname = "Cellular Phone";
	self.pk_items = PKPLUS_IT_PHONE;
	setsize (self,'-16 -16 -24','16 16 32');
	self.mask_x = MORPH_ALL;
	StartItem ();
	if (self.class_select == null_string) self.class_select = "pkplus_item";
	if (!PK_ART) pkplus_item_control(self);

	self.archon = ARCHON_WEP + 0.05;
};


