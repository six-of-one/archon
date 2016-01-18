/* ::-::
 *
 * Cataboligne
 *
 * file: morph_print.qc
 *
 * date: 9/14/11
 *
 * qc - support chaos mod morph ability
 *
 */

// update: 12.19.12 - cleaned up some descriptions - did not match released code

string(float sel) polymorph_id;


// fn(morph_print) - display connect message for class selection
// fn(morph_classpr) - display general class notes - IDEA - not really needed anymore is it?
// self - connecting client

float SC_MARINE		= 1; // display marine subclass header
float SC_TECH			= 2;
float SC_MEDIEVAL		= 4;
float SC_BEASTY		= 8;
float SC_DOOM			= 16;
float SC_Q2				= 32;

// ck - entity to check
// cl - class to check
// class flags stored in .cnt
// returns TRUE if class message printed

float(entity ck, float cl) morph_classpr =
{
	if (!(ck.cnt & cl))
	{
		ck.cnt = ck.cnt | cl;
		if (cl == SC_BEASTY)
			centerprint(ck,
						 "\bBeasty class:\n\nMany of these worlds were yours before \nthe thin skinned \"humans\" came along   \nand took over...and you want your      \nbreeding grounds and crop lands back!  \nYou are one of the maligned beasts.    \nMisunderstood, weird looking and often \nstinky, you could only find work with  \nShubbers. Now that she is gone, you are\nrestless and bored.  Whats an ogre to  \ndo?, Grrr.                             \n\n\bSelections:                            \n\bFiend:  snarl                          \nEnforcer:  you there, halt!            \nHell Knight:  Shubs elite commanders   \nOgre:  big and stinky with a chainsaw! \nShalrath:  walking tripod nightmare    \nShambler:  big is back                 \nScrag:  flying oddball                 \nZombie:  dead and loving it, moaaannnn \nSon of Cthon:  a smaller lava beasty   \nGremlin:  giggling thief               \nScourge:  hissing, nail spitting horror\n");
		else if (cl == SC_MARINE)
			centerprint(ck,
						 "\bHuman class:\n\nMarine you are the last line of        \ndefense...\"Somebody call for an        \nexterminator!\"  You've been training   \nfor this mission for months.  These    \nother nasties might be able to invade  \nyour training grounds, but they sure as\nhell better not expect you to take it  \nsitting down.                          \n\n\bSelections:                            \n\bMarine:  basic grunt                   \nDemolitions:  your stuff goes BOOM!    \n             the basic weapons         \n");
//						 "\bSpecialist:  focus is being better with\n"
		else if (cl == SC_TECH)
			centerprint(ck,
						 "\bTechnical class:\n\nWhen things started getting messed up, \nthey sent you in to fix it. But, you've\nheard just one pocket protector joke   \ntoo many...  You have a basic military \ntraining neccesary for clearance to the\ntraining grounds.  You can use some    \nbasic weapons, but you need to look for\ngadgets.  (Q snuck in and left you some\ngoodies!)                              \n\n\bTechnical:                             \n\bTechnican:  2 words, booby trap        \nEngineer:  makes cool stuff            \n");
		else if (cl == SC_DOOM)
			centerprint(ck,
						 "\bDoom class:\n\nRemember phobos? Hell? you want it all \nback...now is your chance. Strike a few\nblows for the old icon.  Show these new\nupstarts how it was done back in the   \nday.  Quakers? ha, kids. Stroggos? give\nus a break - mere toddlers!  Go kick   \nass like it was kicked in Hell!        \n\n\bDoomers:                               \n\bImp: hell's avaunt garde foot soldier. \nArachnotron: avenge the Master mind... \nCyberdemon: makes other guys look small\n");
		else if (cl == SC_Q2)
			centerprint(ck,
						 "\bStoggos class:\n\nYou laughed at the pathetic humans who \nlanded on Stroggos.  You were appalled \nwhen a few of the terrorists caused an \nunprecdented amount of property damage!\nYou came here via a faulty slip gate...\nIts time to give 'em hell for the Jorg.\nGo go go soldier!                      \n\n\bStroggos:                              \n\bGunney: frontline bravery at its best. \nTank cmdr: built Stroggos tough!       \nSuper Tank: mechanized Victory...      \n");

		return(TRUE);
	}
	return(FALSE);
};

// initial note is on a think so centertime can be changed
// this is necessary - from the time touching the morph cube to entering the first morph_print, centertime is not changed

void() morph_print_notify =
{
	if (self.enemy)
	if (!self.enemy.deadflag)
	if (self.enemy.solid)
	if (self.enemy.classname == "player")
	{
		if (self.mask_x == MORPH_ARCHON)
		{
			centerprint3(self.enemy, "\b                 ARCHON!                \n\b----------------------------------------\n\bYou have been chosen - So might it be...\nselect a demense with these controls:   \n\b----------------------------------------\n\bUse cycle weapon+ to go forward -       \nUse cycle weapon- to go backward.       \nPress alt-fire to finish your selection \nand become one!                         \nselect any weapon with 1 - 9 to exit.   \n----------------------------------------\n\byou have: ", ftos(floor(self.enemy.archon)), " points.");
		}
		else
		{
			centerprint3(self.enemy, "\b           Welcome to Archon.           \n\b----------------------------------------\n\bYou can now evolve - please select an   \nevolution with these controls:          \n\b----------------------------------------\n\bUse cycle weapon+ to go forward -       \nUse cycle weapon- to go backward.       \nPress alt-fire to finish your selection \nand Evolve!                             \nselect any weapon with 1 - 9 to exit.   \n----------------------------------------\n\byou have: ", ftos(floor(self.enemy.archon)), " points.");
		}
	}
	remove(self);
};

// pl - players entity
// .cnt - cleared for classpr

void(entity p1) morph_print =
{
stuffcmd(p1,"scr_centertime 240\n"); // incase admin_centertime is not
stuffcmd(self, "\ncon_notify 4\n"); // for this output
p1.eweapon.archon = 0;
if (p1.cnt < 0)
	{
		newmis = spawn();
		newmis.think = morph_print_notify;
		newmis.nextthink = time + 0.5;
		newmis.enemy = p1;
		newmis.mask_x = p1.eweapon.mask_x; // would not compile when this was mask = mask

		p1.cnt = 0; // clear for classpr
		return;
	}
else if (p1.state == IMP_MCHAOS)
	{
	p1.eweapon.archon = 5000;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Archon of Chaos:\n----------------------------------------\n\bA sentient formless mass of energy and \nplasma floating in a dark void with    \nother energy and plasma.  You came to  \nthese worlds on a whim.  You are chaos \nincarnate.  Defeat & defy order.       \nYou can learn to take on _any_ form.   \nYou can use any weapons or spells that \nform can.  Sounds great right?  Just   \ndont count on any \"consistency\" when   \nyou take on this class...              \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MORDER)
	{
	p1.eweapon.archon = 5000;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Archon of Order:\n----------------------------------------\n\bOrder incarnate - you are the reason   \nfor the seaons, why things fall down   \nand every action has a reaction. Your  \nancient enemy Chaos is back, disturbing\nyour realm.                            \nThis WILL NOT be tolerated at all. Use \nall your might, cleanse your realm of  \nthe pervasive Chaotic influence now.   \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MGREMLIN_F)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 200;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1, 
						 "Gremlin:\n----------------------------------------\n\bA nasty gremlin spawn - You are taunted\nby the other beasties because of your  \nsize and miserable failure in the movie\nAnd you stink.  Get revenge. You can   \nsteal human weapons. Oh, and try not to\nget wet :-) Gremlins are not hurt by   \nslime and may even drink some if health\nis low.  Good luck shorty. \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
//						 "\bAnd you stink.  Get revenge. You can   \n"
//						 "\bsteal human weapons. You can also learn\n"
//						 "\bto set booby traps.  Oh, and try not to\n"
	}
else if (p1.state == IMP_MENF)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 100;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Enforcer:\n----------------------------------------\n\bAn elite former marine hard wired for  \ncombat.  Your laser rifle has a self   \ncharging battery, and you still know   \nhow to use human weapons and armor.    \nWreak havok, soldier.                  \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MSCOURGE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 300;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Scourge:\n----------------------------------------\n\bYou have a mechanical scorpian body with\na poison stinger and built in nailguns  \nwith replicating ammo.  Life has never  \nbeen better.  It was boring working for \nArmagon because you didnt do anything   \nbut sit and wait in one place.  Duh. If \nyou find certain human weapons you can  \nimprove your built in weapons (you are a\nbeasty tech!) to use their ammo.  And   \nyour built in armor is healable, but    \nyour health must be near max.           \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MSHAMBLR)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 450;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Shambler:\n----------------------------------------\n\bYou are the loved and feared shambler.  \nShoot lightning bolts and rip flesh like\nthere is no tommorow.  Smash every      \nliving thing you find...why?  You just  \nwant to hibernate and dream about giant \nhoney bee hives...                      \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MHKNIGHT)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 300;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Hell Knight:\n----------------------------------------\n\bBeing a former general among Shubs     \nminions has taught you some new tricks.\nYou know how to fire a concentrated    \nburst of magic spikes from your sword. \nAnd you can use armor.  Urrr, kill the \nhumans.                                \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MSHALR)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 300;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Shalrath:\n----------------------------------------\n\bYou are an elite spell caster from      \nanother dimension.  And you have no idea\nwhy they call you a \"Vore\".  You're     \npissed about it too... Try new spells!  \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
//						 "\bpissed about it too... Learn some spells\n"
//						 "\bquick as your main \"missle\" spell hurts \n"
//						 "\byou more at close range than they do.   \n"
	}
else if (p1.state == IMP_MDEMON)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 500;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Fiend:\n----------------------------------------\n\bYou are a flesh ripping and jumping     \nmachine. That is about it. And you stink\nbad.  You are one thick skinned beasty. \nKeep your health up and most attacks    \nwont gib you!                           \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MOGRE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 300;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Ogre:\n----------------------------------------\n\bGrrr, get Grank and Grud.  All you know\nis chainsaws and grenades.  Can an ogre\nlearn more?  And does he need to?      \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
//						 "\b \n"
	}
else if (p1.state == IMP_MZOMBIE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 100;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Zomby:\n----------------------------------------\n\bYou are dead.  And slow. And you stink!\nAs the living dead, however you do have\none advantage: regeneration. Reanimated\nflesh just cant be killed unless its   \nblasted apart into stinking little     \ngibblets.  Go pelt all the living with \nyour dead and diseased flesh.          \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MWIZARD)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 200;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Scrag:\n----------------------------------------\n\bYou fly and you stink.  And you have   \nspikes for arms.  Lets face it you dont\nhave many redeeming qualities even for \na beasty.  You have one joy in life,   \nhowever. You know how humiliating it is\nwhen someone is \"Scragged\".            \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
//						 "\bwhen someone is \"Scragged\".  Find a way\n"
//						 "\bof improving your attack quickly, it is\n"
//						 "\bvery weak.                             \n"
	}
else if (p1.state == IMP_MCTHON)
	{
	if (!MORPH_FREE) p1.eweapon.archon = 300;
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Lava Bomb:\n----------------------------------------\n\bYou are the sentient offspring          \nof Cthon. You are very hot under the    \ncollar at your fathers betrayers. You   \nonly exist as a lava bomb blobbng around\nuntil you find a pool of lava. Then you \ncan grow into a small Cthon. Just dont  \nleave the lava without returning to blob\nform.  You are a very hard kill as Cthon\n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}

else if (p1.state == IMP_MHUMAN) // basic grunt desc.
	{
	if (morph_classpr(p1, SC_MARINE)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 150;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1,
						 "Marine:\n----------------------------------------\n\bYou are _the_ weapons guy.  If it has a\ntrigger and a business end you can use \nit.  You learn new weapons fast...and  \nyou walk around looking like           \nSchwarzenegger. Gear up and blast em!  \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
//						 "\bSchwarzenegger.  All the focus on      \n"
//						 "\bweapons has left your defenses a little\n"
//						 "\bweaker, however.                       \n"
	}
/*
else if (p1.state == IMP_MSPECIAL)
	centerprint(p1, "\bYour training is simply the best.  Your\n"
						 "\bnails hurt more, your rockets explode  \n"
						 "\bharder.  Your shotguns boom louder.    \n"
						 "\bYou can even improve a few of them. You\n"
						 "\blook like  Wesley Snipes in Blade. Dont\n"
						 "\bstop your training, its critical...you \n"
						 "\bmust collect items to maintain training\n"
						 "\bdiscipline.  You have been warned.     \n");
else if (p1.state == IMP_MDEMO)
	{
	if (morph_classpr(p1, SC_MARINE)) return;
	centerprint(p1, "\bLots of new explodable packages and a  \n"
						 "\bfew basic weapons.  Mine the tunnels   \n"
						 "\bmarine!  You look like Dennis Hopper   \n"
						 "\bfrom Speed with the explosive vest...  \n"
						 "\bNot much in the way of a ranged attack \n"
						 "\bfor awhile.  No fantasy weapons at all.\n");
	}
else if (p1.state == IMP_MTECH) // tech desc.
	{
	if (morph_classpr(p1, SC_TECH)) return;
		centerprint(p1,
						 "\bYou are the gadget guy.  You look more \n"
						 "\blike Rick Morannis from \"Honey I       \n"
						 "\bShrunk...\"  You cant handle any        \n"
						 "\bexplosives, however.  But you can work \n"
						 "\bon stuff!  Like doors, lifts, gates,   \n"
						 "\blights, etc.  Eventually you can learn \n"
						 "\bhow to set \"booby\" traps.  And you're  \n"
						 "\blearning not to be nervous around      \n"
						 "\bgunfire.                               \n");
	}
else if (p1.state == IMP_MENG)
	{
	if (morph_classpr(p1, SC_TECH)) return;
		centerprint(p1, "\bYou wear a labcoat and have a notepad. \n"
						 "\bYou look like Riff from Sluggy         \n"
						 "\bFreelance.  You no longer get so many  \n"
						 "\bspiffy gadgets from Q. But you can make\n"
						 "\byour own!  Your ability to work on     \n"
						 "\bthings you didnt make is also limited. \n"
						 "\bGunfire?  Oh that popcorn sound in the \n"
						 "\bbackground, check.  Go make dangerous  \n"
						 "\bstuff.                                 \n");
	}
*/
// doomers
else if (p1.state == IMP_MIMP)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 200;
	if (p1.archon > p1.eweapon.archon)
		centerprint3(p1, 
						 "Imp:\n----------------------------------------\n\bDoom Imp - you are a spiny fire tossing\nfreak nobody wants to run into in some \ndark corridor.  That pretty much says  \nit all...go slay something hideously!  \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MARACHN)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 400;
	if (p1.archon > p1.eweapon.archon)
		centerprint3(p1, 
						 "Arachnotron:\n----------------------------------------\n\bScary monster brain on top of a spider \nmechanical body - EEK.  Oh wait, thats \nyou.  You are one bizzare beastie from \nthe Doom realm - with a built in plasma\ncannon.  Go melt everything!           \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MCYBER)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 800;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1, 
						 "Cyberdemon:\n----------------------------------------\n\bThe original bad ass beastie from the  \nDoom realm. Before the Shambler was big\nyou were there.  Tall as a 2 story with\na rocket launcher for a right hand. Go \nkick ass? You gotta be kiddin - go     \nblast them to kibbles and bits!        \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MGUNNEY)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 300;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1, 
						 "Gunney:\n----------------------------------------\n\bGunney, you are the pride of all front \nline soldiers. No enemy has known fear \nuntil your weapons are aimed at them...\nGo clear the field - you own it!       \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MTANK)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 750;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1, 
						 "Tank:\n----------------------------------------\n\bThe Man...the Machine...the Menace!    \nyou are a TANK - go bust some ass now! \nYour precision engineering has one goal\n- years of trouble free mayhem and     \ndestruction. Your builtin self reload  \nweapons are ready to clear the field...\n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MSUPTANK)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	if (!MORPH_FREE) p1.eweapon.archon = 2000;
	if (p1.archon > p1.eweapon.archon)
	centerprint3(p1, 
						 "Super Tank:\n----------------------------------------\n\bThe Super Man...the Super Machine...the\nSuper Menace! you are one mean machine.\nYour precision engineering has one goal\nthe destruction of every opponent on   \nthe field of honor - go Soldier, go!   \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}

//else if (p1.state == IMP_M)
//	centerprint3(p1,
//						 "\n"
//						 "\n"
//						 "\n"
//						 "\n"

if (MORPH_FREE)
	{
	sprint(p1,"Your current selection = ");
	sprint(p1,polymorph_id(p1.state));
	sprint(p1,".\n");
	}
else
	if (p1.archon > p1.eweapon.archon)
	{
	sprint(p1,"Your current selection = ");
	sprint(p1,polymorph_id(p1.state));
	sprint(p1,", ");
	sprint(p1,ftos(p1.eweapon.archon));
	sprint(p1," points.\n");
	}
};
