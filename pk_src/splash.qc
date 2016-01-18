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
		pcc = pc = pointcontents(e.origin + ' 0 0 4'); // extra check because some items have origin at 0 z in model - sitting on floor can be in solid

	if (!(pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA))
		pc = NOT_IN_WATER;

	return pc;
};

// Makes splashes of an entity has meved in / out of water. Called in PlayerPreThink
void() CheckWaterLevels =
{
	local entity e, f;
	local float mv, now;

	cc_frame = framecount; // call only once per frame

// run every other frame if enhanced
	if (ENHANCED)
	if (cc_frame & 1) return;

	mv = 0 - cvar("sv_maxvelocity");

	e = find(world, water_notify, "yes");

	while (e != world)
	{
// bit of fn above - delooped
		pcc = pc = pointcontents(e.origin + ' 0 0 2'); // special for item test - see InWater fn code

		if (!(pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA))
			pc = NOT_IN_WATER;

// need an extra rune test - they dont always vacate lava
		if (pc == CONTENT_LAVA)
		if (e.map  == "rune" && e.classname == "item_sigil")
		if (!e.hook)
			e.inwater = 0;

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



#ifdef warning
							if (WARNING & 128)
							{
								bprint("*** warning: lava splash rune - model = ");
								bprint(e.model);
								bprint("\n");
							}
#endifdef


						}
					}
					else if (e.classname == "tomb") // Cataboligne 8.12.9 purify - pk artifacts
					{
						e.think = tombdie;
						if (ENHANCED) 
						{
							e.velocity = v0; // stop on surface
							e.nextthink = (time + 2 + random() * 5 );
						}
						else
							e.nextthink = (time + 0.1 + random() );
					}
				}
			}
		}

// fall from grace - stuff out of level checks

// suspect shot stuff is from bots fallen out & not returned yet
// Cataboligne - 10.18.12 - tweaked velo test, -2011 didnt work for pulse spikes

		if ((cc_frame & 15) == 10) // dont run these every frame, or even every 14th frame
		{
			if (pcc == CONTENT_SOLID || (floor(e.velocity_z) < -2000 || floor(e.velocity_z) == mv))
			{
				if (floor(e.velocity_z) < -2000 || floor(e.velocity_z) == mv)
				{
					if (e.flags & FL_ITEM)
					{
						if (e.msgcount > -888)
						{
							e.msgcount = -888;
		//					bprint("*** warning: falling item hit -2011 vel*_z (terminal) - ");
		//					bprint(item_ident(e));
		//					bprint("\n");
						}
						if ( (e.map  == "rune" && e.classname == "item_sigil") && RUNES)
						{
							if (e.think != fade_relocate) // not already moving
							{
								e.think = ip_checkForMovement;
								if ( (e.nextthink > time + 6) || (e.nextthink <= 0) )
									e.nextthink = time + random() * 4;
								e.hook = TRUE;
								if (e.solid == SOLID_NOT) e.solid = SOLID_TRIGGER; // 9.27.12 - make sure think fn() fires relocate



#ifdef warning
									if (WARNING & 128)
									{
										bprint("*** warning: solid splash rune - model = ");
										bprint(e.model);
										bprint("\n");
									}
#endifdef


							}
						}
						else if (e.ip_orgOrigin != v0) // put items back now
						{
							e.msgcount = e.msgcount - 1;
							if (e.msgcount < -891) e.movetype = MOVETYPE_NONE; // drastic but neccesary if a bounding box seems to cut into a wall / solid because item keeps falling after every reset
							e.ip_orgOrigin_z = e.ip_orgOrigin_z + 3;
							setorigin (e, e.ip_orgOrigin);
							e.velocity = v0;
	//						e.think = ip_checkForMovement;
	//						e.nextthink = time + CFM_TIME;
#ifdef warning
							if (WARNING & 128)
							{
								bprint("*** warning: falling item reset - ");
								bprint(item_ident(e));
								if (e.movetype == MOVETYPE_NONE) bprint(" - FROZEN");
								bprint("\n");
							}
#endifdef
						}
					}
					else if (e.flags & FL_MONSTER && e.solid != SOLID_NOT)
					{
						if (e.class_select != "class_mosnter") // polyed mosnter - cant kill
						{
							if (e.ip_orgOrigin != v0) setorigin (e, e.ip_orgOrigin + '0 0 40');
							else
							{
								newmis = dyn_rndloc();
								if (!newmis) newmis= findradius(world.origin, 256000);
								setorigin (e, newmis.origin + '0 0 40');
							}
							e.velocity = v0;
						}
						else
						{
							T_Damage (e,world,world,e.health + 10); //e.th_die(); // note: swim monsters dont set splash - have to damage for accounting - see random monsters
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
								e.duration = time + 2; // debounce
								if (e.model == "progs/cthon.mdl") lavacthon_blobme(e); // re-blob cthon
								f = spawn ();
								f.owner = e;
								f.think = phone_teleport;
								f.nextthink = (time + 0.2);
								if (e.class_select != "class_bot") centerprint(e, "You have fallen from grace - by grace you are restored!\n");
							}
							else if (SV_FALLEN == 2)
							{
								f = spawn();
								f.classname = "CDM"; // Cataboligne - 2.20.11 - customized death messages
								f.netname = " fell from grace.";
								f.deadflag = 1; // use name
								f.frags = 0;
								e.armorvalue = 0;
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
						remove(e); // remove all else
					}
				}
			}

			if (RUNE_NOWAY) // outside noway bounds checks
			if ( (e.map  == "rune" && e.classname == "item_sigil") && RUNES)
			{
				now = FALSE;
				if (noway_below)
				if (e.origin_z < noway_below) now = TRUE;
				if (noway_above)
				if (e.origin_z > noway_above) now = TRUE;

				if (now)
				if (e.think != fade_relocate) // not already moving
				{
					e.think = ip_checkForMovement;
					e.nextthink = time + random() * 4;
					e.hook = TRUE;
					if (e.solid == SOLID_NOT) e.solid = SOLID_TRIGGER; // 9.27.12 - make sure think fn() fires relocate



#ifdef warning
							if (WARNING & 128)
							{
								bprint("*** warning: noway splash rune - model = ");
								bprint(e.model);
								bprint("\n");
							}
#endifdef


				}

// fixed lost nextthink
				if (!e.nextthink) // was ending up 0, consider < 2 test or so, need more qualifier for that
					e.nextthink = time + CFM_TIME;
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
