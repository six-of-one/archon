/* splish splash */

float SOLID_TIME = 120; // rels certain things can spend in solids

float NOT_IN_WATER = 0;
float pc;								// The content type the last entity to be checked just entered
float pcc;								// solid check below
float splash_count;			// The amout of splashes around. Used to keep the number down so we do'nt get any "No Free Edicts" messages

.float inwater;					// The water type the entity was in at last check
.string water_notify;		// Set to "yes" to make a splash
.void() splash_func;		// The function to call to make the splash
void() beartrapDie;	   // So we can remove bt's when in lava
void() turret_deathAnim;	  // So we can remove turrents whon in lava


// Remove a splash entity
void() Remove_Splash =
{
	splash_count = splash_count - 1;
	remove(self);
};

$frame splash1 splash2 splash3 splash4 splash5

void()	do_small_splash1 = [$splash1, do_small_splash2	] {};
void()	do_small_splash2 = [$splash1, do_small_splash3  ] {};
void()	do_small_splash3 = [$splash2, do_small_splash4  ] {};
void()	do_small_splash4 = [$splash2, do_small_splash5  ] {};
void()	do_small_splash5 = [$splash3, do_small_splash1  ] {Remove_Splash();};

void()	do_large_splash1 = [$splash1, do_large_splash2	] {};
void()	do_large_splash2 = [$splash2, do_large_splash3	] {};
void()	do_large_splash3 = [$splash3, do_large_splash4	] {};
void()	do_large_splash4 = [$splash4, do_large_splash5  ] {};
void()	do_large_splash5 = [$splash5, do_large_splash1  ] {Remove_Splash();};

// All lava splashes are big splashes, so they can be seen easily

void()	do_lava_splash1 = [$splash1, do_lava_splash2	] {};
void()	do_lava_splash2 = [$splash2, do_lava_splash3	] {};
void()	do_lava_splash3 = [$splash3, do_lava_splash4	] {};
void()	do_lava_splash4 = [$splash4, do_lava_splash1	] {Remove_Splash();};

/*
void()	do_lava_splash1 = [$splash1, do_lava_splash2	] {};
void()	do_lava_splash2 = [$splash1, do_lava_splash3	] {};
void()	do_lava_splash3 = [$splash2, do_lava_splash4	] {};
void()	do_lava_splash4 = [$splash2, do_lava_splash5	] {};
void()	do_lava_splash5 = [$splash3, do_lava_splash6	] {};
void()	do_lava_splash6 = [$splash3, do_lava_splash7	] {};
void()	do_lava_splash7 = [$splash4, do_lava_splash8	] {};
void()	do_lava_splash8 = [$splash4, do_lava_splash1	] {Remove_Splash();};
*/


// Make a splash at entity e
void(entity e) MakeSplash =
{
	if (splash_count < 20)
	{
		local entity newent;

		newent = spawn();

		setorigin(newent, e.origin);
		newent.solid = SOLID_NOT;
		newent.movetype = MOVETYPE_NONE;

		newent.nextthink = time + 0.1;

		if (pc == CONTENT_LAVA || e.inwater == CONTENT_LAVA)
		{
			setmodel(newent, "progs/s_splava.spr");
			newent.think = do_lava_splash1;
		}
		else
		{
			setmodel(newent, "progs/s_splash.spr");
			newent.think = e.splash_func;
		}

		splash_count = splash_count + 1;
	}
};

// Used to tell if an entity is in water
float(entity e) inWater =
{
	pcc = pc = pointcontents(e.origin);

	if (e.flags & FL_ITEM)
	if (pc == CONTENT_SOLID)
		pcc = pc = pointcontents(e.origin + '0 0 4'); // extra check because some items have origin at 0 z in model - sitting on floor can detect as solid

	if (!(pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA))
		pc = NOT_IN_WATER;

	return pc;
};

// Makes splashes of an entity has meved in / out of water. Called in PlayerPreThink
// notes:
// handles any checked ent stuck in solid
// checks items in lava & slime
// handles rune noway checks

void() CheckWaterLevels =
{
	local entity e, f;
//	local float now;

// run every other frame if enhanced - done in client
//	if (cc_frame & 1) return;

#ifdef enhanced
	cc_frame = 2;
#else
	cc_frame = framecount; // call only once per frame
#endifdef


	e = find(world, water_notify, "yes");

	while (e != world)
	{
// bit of fn above - delooped
		pcc = pc = pointcontents(e.origin + '0 0 2'); // special for item test - see InWater fn code

// clear any op states if in these contents
		if (pc == CONTENT_EMPTY || pc == CONTENT_WATER)
		{
	//		if (!e.flags & FL_CLIENT) e.revotemsg = 0;
			e.revotemsg = 0;
		}

		if (!(pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA))
			pc = NOT_IN_WATER;

// need an extra rune test - they dont always vacate lava
		if (pc == CONTENT_LAVA)
		if (e.map  == "rune" && e.classname == "item_sigil")
		if (!e.hook)
			e.inwater = 0; // re-check

//		if (inWater(e) != e.inwater) // de-looping this call - this is call heavy
		if (pc != e.inwater)
		{
			if (e.classname == "drop")
			{
				sound(self, CHAN_AUTO, "misc/drip/drip_1.wav", 1, ATTN_NORM);
				remove(e);
			}
			else
			{
				if ((! pk_flags & PK_TP_SPARKSFLASH) || !XENV)
				  MakeSplash(e);

				e.inwater = pc;

// Remove turrets and beartraps if they fall into the lava
//				if (!ENHANCED || ((cc_frame & 3) == 2)) // was failing rune mover
				if (pc == CONTENT_LAVA)
				{
					if (e.classname == "gravity")
					{
						setorigin(e, e.origin + '0 0 16'); // issue: bounces up - need to stop earlier
						e.movetype = MOVETYPE_NONE;
//						e.velocity = v0; // stop on surface
						
					}
					if (e.classname == "beartrap")
					{
						e.think = beartrapDie;
						e.nextthink = time + 0.1;
					}
					else if (e.classname == "turret")
					{
						e.think = turret_deathAnim;
						e.nextthink = time + 0.1;
					}
					else if (e.classname == "tomb") // Cataboligne 8.12.9 purify - pk artifacts
					{
						e.think = tombdie;
						e.movetype = MOVETYPE_NONE;
//						e.velocity = v0; // stop on surface - this fails
						e.nextthink = (time + 2 + random() * 5 );
					}
					else if (e.flags & FL_ITEM) e.revotemsg = time + 5; // clear items from lava as well as the void

/*
 moved below
					else if (e.map  == "rune" && e.classname == "item_sigil")
					{
						if (RUNES)
						if (e.think != fade_relocate) // not already moving
						{
							e.think = ip_checkForMovement; // note - if for any reason rune isnt in checkfor, this code puts it there
							if ( (e.nextthink > time + 6) || (e.nextthink <= 0) )
								e.nextthink = time + random() * 4;
							e.hook = TRUE;
							if (e.solid == SOLID_NOT) e.solid = SOLID_TRIGGER; // 9.27.12 - make sure think fn() fires relocate
						}
					}
*/
				}
				if (pc == CONTENT_SLIME)
				if (e.flags & FL_ITEM) e.revotemsg = time + 20 + random() * 60; // clear items from slime after a wait - idea: hiss sound ?
			}
		}

// fall from grace - stuff in void checks
// logic to perform rescues & such

// dont run these every frame

#ifdef enhanced
// logic for every other frame mode - catch either case
		if (((framecount & 7) == 3) || (framecount & 7) == 2)
#else
// logic if runnning code every frame
		if ((framecount & 7) == 3)
#endifdef
		{
			if (e.movetype != MOVETYPE_NONE)
			if (pcc == CONTENT_SOLID)
			{
				e.cnt = 0;
				if (e.flags & FL_CLIENT)
				{
					if (!e.revotemsg)
					{
						if (e.movetype != MOVETYPE_FLY)
						{
							if (e.velocity_z < 0) e.revotemsg = time + 2;
						}
						else
						if (! e.mask_x & MORPH_ARCHON)
							e.revotemsg = time + 2;
					}
				}
				else
				if (e.flags & FL_MONSTER) e.cnt = 1; // note: swim monsters dont set splash - they will not be detected by this code !!!
				else
				{
// anything not a player | monster and water_notify "yes" and solid and velocity_z (-)
					if (e.velocity_z < 0) e.cnt = time + 6;
// added more checks - there were some non movers
					if (noway_below)
					if (e.origin_z < noway_below) e.cnt = time + 6;
					if (noway_above)
					if (e.origin_z > noway_above) e.cnt = time + 6;
				}

				if (e.cnt)
				if (!e.revotemsg) e.revotemsg = e.cnt;
			}

// rune outside noway bounds checks
			if (RUNE_NOWAY)
			if ( (e.map  == "rune" && e.classname == "item_sigil") && RUNES)
			{
	//				now = FALSE;
				if (!e.revotemsg)
				{
					if (noway_below)
					if (e.origin_z < noway_below) e.revotemsg = 1;
					if (noway_above)
					if (e.origin_z > noway_above) e.revotemsg = 1;



#ifdef warning
							if (e.revotemsg)
							if (WARNING & 128)
							{
								bprint("*** warning: noway splash rune - model = ");
								bprint(e.model);
								bprint("\n");
							}
#endifdef


				}

	/*
				if (now)
				if (e.think != fade_relocate) // not already moving
				{
					e.think = ip_checkForMovement;
					e.nextthink = time + random() * 4;
					e.hook = TRUE;
					if (e.solid == SOLID_NOT) e.solid = SOLID_TRIGGER; // 9.27.12 - make sure think fn() fires relocate
				}
	*/

	// fixed lost nextthink
				if (!e.nextthink) // was ending up 0, consider < 2 test or so, need more qualifier for that
					e.nextthink = time + CFM_TIME;
			}

// monster liquid handle
			if (pc)
			if (e.flags & FL_MONSTER)
			{
				f = self;
				self = e;
				WaterMove(); // Cataboligne - 2.27.8 - water move for monsters
				self = f;
			}
		}

// suspect shot stuff is from bots fallen out & not returned yet
// Cataboligne - 10.18.12 - tweaked velo test, -2011 didnt work for pulse spikes
// 11.11.13 - new method


//		if (pcc == CONTENT_SOLID || (floor(e.velocity_z) < -2000))

		if (e.revotemsg > 0)
		if (e.revotemsg < time)
		{
			if (e.revotemsg > 10) e.revotemsg = 1; // set anything that timed out to 1

			if (e.flags & FL_ITEM)
			{
				if ( (e.map  == "rune" && e.classname == "item_sigil") && RUNES) // rune move is special
				{
					if (e.think != fade_relocate) // not already moving
					{

#ifdef warning
							if (!e.hook)
							if (pcc == CONTENT_SOLID)
							if (WARNING & 128)
							{
								bprint("*** warning: solid splash rune - model = ");
								bprint(e.model);
								bprint("\n");
							}

							if (!e.hook)
							if (pcc == CONTENT_LAVA)
							if (WARNING & 128)
							{
								bprint("*** warning: lava splash rune - model = ");
								bprint(e.model);
								bprint("\n");
							}
#endifdef

						e.think = ip_checkForMovement;
						if ( (e.nextthink > time + 6) || (e.nextthink <= 0) )
							e.nextthink = time + random() * 4;
						e.hook = TRUE;
						if (e.solid == SOLID_NOT) e.solid = SOLID_TRIGGER; // 9.27.12 - make sure think fn() fires relocate
					}
				}
				else if (e.classname == "thrownwep") // remove any thrown weps, any conditions
				{
#ifdef warning
					if (WARNING & 128)
					{
						bprint("*** warning: removed thrown item - ");
						bprint(item_ident(e));
						bprint("\n");
					}
#endifdef
					e.revotemsg = 0;
					remove(e); // remove dynamics
				}
				else if (pcc != CONTENT_SOLID) // in lava or slime, just relocate
				{
					if (e.event == "dynamic_item") e.revotemsg = -2;
					if (e.ip_orgOrigin != e.origin) e.revotemsg = -2; // for a map spawned item on origin point, we can do nada
				}
				else if (e.ip_orgOrigin != v0) // put map spawned items with a storage position back now
				{
					e.revotemsg = e.revotemsg + 1; // count resets, & freeze on 3rd try
					e.msgcount = e.msgcount + 1; // count resets, freeze for bouncy bouncy (where revotemsg is clear by empty space but it keeps bouncing out)

#ifdef warning
					if (WARNING & 128)
					if (e.movetype != MOVETYPE_NONE)
					{
						bprint("*** warning: falling item reset - ");
						bprint(item_ident(e));
						if (e.revotemsg > 6) bprint(" - FROZEN");
						bprint("\n");
					}
#endifdef

					if (e.msgcount > 16) e.revotemsg = 7;

					if (e.revotemsg > 6) 
					{
						e.ip_orgOrigin_z = e.ip_orgOrigin_z - 6;
						setorigin (e, e.ip_orgOrigin);
// final time - #6 - freeze it at orgOrigin
						e.movetype = MOVETYPE_NONE; // drastic but neccesary if a bounding box seems to cut into a wall / solid because item keeps falling after every reset
					}
					else
					{
// 2 times - see if a slight bump up will solve "falls through floors"
						if (e.revotemsg > 4) e.ip_orgOrigin_z = e.ip_orgOrigin_z + 3;
// 3 times - just put it back
						setorigin (e, e.ip_orgOrigin);
						e.velocity = v0;
#ifdef warning
						if (WARNING & 2)
						{
							bprint("*** warning: item in solid - ");
							bprint(item_ident(e));
							bprint (" - z adjust ");
							bprint (vtos (e.origin));
							bprint ("\n");
						}
#endifdef
					}
				}
				else if (e.event == "dynamic_item")
				{
#ifdef warning
					if (WARNING & 128)
					{
						bprint("*** warning: removed falling dynitem - ");
						bprint(item_ident(e));
						bprint("\n");
					}
#endifdef
					e.revotemsg = 0;
					remove(e); // remove dynamics
				}
				else
				{
					e.revotemsg = -2; // cant id this bad boy - relocate code
				}
			}
			else if (e.flags & FL_MONSTER && e.solid != SOLID_NOT)
			{
				if (e.class_select != "class_monster") // polyed to a mosnter - cant kill
				{
					if (e.ip_orgOrigin != v0) setorigin (e, e.ip_orgOrigin + '0 0 40');
					else
					{
						e.revotemsg = -2; // something polyed to monster & no orgOrigin - relocate code
					}
					e.velocity = v0;
				}
				else
				{
					T_Damage (e,world,world,e.health + 10); //e.th_die(); // have to damage for accounting - see random monsters
					e.revotemsg = 0;
					remove(e);
				}
			}
			else if (e.class_select == "class_bot" || e.classname == "player")
			{
				if (!e.portal_busy) // no action if under influence of portal contols
				{
					if (SV_FALLEN == 1)
					if (e.duration < time)
					{
						e.duration = time + 5; // debounce
						e.revotemsg = 0;
						if (e.model == "progs/cthon.mdl") lavacthon_blobme(e); // re-blob cthon
						f = spawn ();
						f.owner = e;
						f.think = phone_teleport;
						f.nextthink = (time + 0.2);
						if (e.class_select != "class_bot")
							centerprint(e, "You went into the void without a void-ship!\n");
//							centerprint(e, "You have fallen from grace - by grace you are restored!\n");
#ifdef warning
							if (WARNING & 128)
							{
								bprint("*** warning: saved falling player - ");
								bprint(item_ident(e));
								bprint("\n");
							}
#endifdef
					}
					if (SV_FALLEN == 2)
					{
#ifdef warning
							if (WARNING & 128)
							{
								bprint("*** warning: killing falling player - ");
								bprint(item_ident(e));
								bprint("\n");
							}
#endifdef
						f = spawn();
						f.classname = "CDM"; // Cataboligne - 2.20.11 - customized death messages
						f.netname = " fell from grace.";
						f.deadflag = 1; // use name
						f.frags = 0;
						e.armorvalue = 0;
						e.revotemsg = 0;
						e.invincible_finished = 0; // turn off invincible
						T_Damage(e, e, f, e.health + 10);
						remove(f);
					}
				}
			}
			else if (e.classname != "player")
			{
#ifdef warning
				if (WARNING & 128)
				{
					bprint("*** warning: removed falling item - ");
					bprint(item_ident(e));
					bprint("\n");
				}
#endifdef
				if (e.classname == "turret") remove(e.turret_base);
				e.revotemsg = 0;
				remove(e); // remove all else
			}

// idic - logic wants us to relocate this ent
			if (e.revotemsg == -2)
			{
				e.revotemsg = 0;
				if (e.think != fade_relocate) set_relocate(e);
//				newmis = dyn_rndloc();
//				if (!newmis) newmis= findradius(world.origin, 256000);
//				setorigin (e, newmis.origin + '0 0 40');
//				droptofloor(0, 0); // likely only works on self
			}

		}

		e = find(e, water_notify, "yes");
	}
};

// Make the entity splash when it enteres / exits the water

void(entity e) AddToSplash =
{
	e.inwater = inWater(e);
	e.water_notify = "yes";
	e.splash_func = do_small_splash1;
};

void(entity e) AddToSplashBig =
{
	e.inwater = inWater(e);
	e.water_notify = "yes";
	e.splash_func = do_large_splash1;
};
