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
string(entity p1, float sel, string fp) polymorph_id;


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
						 "\bBeasty class:\n\n"
						 "\bMany of these worlds were yours before \n"
						 "\bthe thin skinned \"humans\" came along   \n"
						 "\band took over...and you want your      \n"
						 "\bbreeding grounds and crop lands back!  \n"
						 "\bYou are one of the maligned beasts.    \n"
						 "\bMisunderstood, weird looking and often \n"
						 "\bstinky, you could only find work with  \n"
						 "\bShubbers. Now that she is gone, you are\n"
						 "\brestless and bored.  Whats an ogre to  \n"
						 "\bdo?, Grrr.                             \n\n"
						 "\bSubclasses:                            \n"
						 "\bFiend:  snarl                          \n"
						 "\bEnforcer:  you there, halt!            \n"
						 "\bHell Knight:  Shubs elite commanders   \n"
						 "\bOgre:  big and stinky with a chainsaw! \n"
						 "\bShalrath:  walking tripod nightmare    \n"
						 "\bShambler:  big is back                 \n"
						 "\bScrag:  flying oddball                 \n"
						 "\bZombie:  dead and loving it, moaaannnn \n"
						 "\bSon of Cthon:  a smaller lava beasty   \n"
						 "\bGremlin:  giggling thief               \n"
						 "\bScourge:  hissing, nail spitting horror\n");
		else if (cl == SC_MARINE)
			centerprint(ck,
						 "\bHuman class:\n\n"
						 "\bMarine you are the last line of        \n"
						 "\bdefense...\"Somebody call for an        \n"
						 "\bexterminator!\"  You've been training   \n"
						 "\bfor this mission for months.  These    \n"
						 "\bother nasties might be able to invade  \n"
						 "\byour training grounds, but they sure as\n"
						 "\bhell better not expect you to take it  \n"
						 "\bsitting down.                          \n\n"
						 "\bSubclasses:                            \n"
						 "\bMarine:  basic grunt                   \n"
						 "\bDemolitions:  your stuff goes BOOM!    \n"
//						 "\bSpecialist:  focus is being better with\n"
						 "\b             the basic weapons         \n");
		else if (cl == SC_TECH)
			centerprint(ck,
						 "\bTechnical class:\n\n"
						 "\bWhen things started getting messed up, \n"
						 "\bthey sent you in to fix it. But, you've\n"
						 "\bheard just one pocket protector joke   \n"
						 "\btoo many...  You have a basic military \n"
						 "\btraining neccesary for clearance to the\n"
						 "\btraining grounds.  You can use some    \n"
						 "\bbasic weapons, but you need to look for\n"
						 "\bgadgets.  (Q snuck in and left you some\n"
						 "\bgoodies!)                              \n\n"
						 "\bTechnical:                             \n"
						 "\bTechnican:  2 words, booby trap        \n"
						 "\bEngineer:  makes cool stuff            \n");
		else if (cl == SC_DOOM)
			centerprint(ck,
						 "\bDoom class:\n\n"
						 "\bRemember phobos? Hell? you want it all \n"
						 "\bback...now is your chance. Strike a few\n"
						 "\bblows for the old icon.  Show these new\n"
						 "\bupstarts how it was done back in the   \n"
						 "\bday.  Quakers? ha, kids. Stroggos? give\n"
						 "\bus a break - mere toddlers!  Go kick   \n"
						 "\bass like it was kicked in Hell!        \n\n"
						 "\bDoomers:                               \n"
						 "\bImp: hell's avaunt garde foot soldier. \n"
						 "\bArachnotron: avenge the Master mind... \n"
						 "\bCyberdemon: makes other guys look small\n");
		else if (cl == SC_Q2)
			centerprint(ck,
						 "\bStoggos class:\n\n"
						 "\bYou laughed at the pathetic humans who \n"
						 "\blanded on Stroggos.  You were appalled \n"
						 "\bwhen a few of the terrorists caused an \n"
						 "\bunprecdented amount of property damage!\n"
						 "\bYou came here via a faulty slip gate...\n"
						 "\bIts time to give 'em hell for the Jorg.\n"
						 "\bGo go go soldier!                      \n\n"
						 "\bStroggos:                              \n"
						 "\bGunney: frontline bravery at its best. \n"
						 "\bTank cmdr: built Stroggos tough!       \n"
						 "\bSuper Tank: mechanized Victory...      \n");

		return(TRUE);
	}
	return(FALSE);
};

// pl - players entity
// .cnt - cleared for classpr

void(entity p1) morph_print =
{
if (!p1.state)
	{
	stuffcmd(p1,"scr_centertime 240\n");
	//						 1234567890123456789012345678901234567890
	centerprint(p1, "\b           Welcome to Archon.           \n"
						 "\b----------------------------------------\n"
						 "\bYou can now evolve - please select an   \n"
						 "\bevolution with these controls:          \n"
						 "\b----------------------------------------\n"
						 "\bUse cycle weapon+ to go forward -       \n"
						 "\bUse cycle weapon- to go backward.       \n"
						 "\bPress fire to finish your selection     \n"
						 "\band Evolve!                             \n"
						 "\bselect any weapon with 1 - 9 to exit.   \n"
						 "\b----------------------------------------\n");
		p1.cnt = 0; // clear for classpr
	}
else if (p1.state == IMP_MCHAOS)
	centerprint(p1, "\bA sentient formless mass of energy and \n"
						 "\bplasma floating in a dark void with    \n"
						 "\bother energy and plasma.  You came to  \n"
						 "\bthese worlds on a whim.  You are chaos \n"
						 "\bincarnate.  Defeat & defy order.       \n"
						 "\bYou can learn to take on _any_ form.   \n"
						 "\bYou can use any weapons or spells that \n"
						 "\bform can.  Sounds great right?  Just   \n"
						 "\bdont count on any \"consistency\" when   \n"
						 "\byou take on this class...              \n");
else if (p1.state == IMP_MORDER)
	centerprint(p1, "\bOrder incarnate - you are the reason   \n"
						 "\bfor the seaons, why things fall down   \n"
						 "\band every action has a reaction. Your  \n"
						 "\bancient enemy Chaos is back, disturbing\n"
						 "\byour realm.                            \n"
						 "\bThis WILL NOT be tolerated at all. Use \n"
						 "\ball your might, cleanse your realm of  \n"
						 "\bthe pervasive Chaotic influence now.   \n");
else if (p1.state == IMP_MGREMLIN_F)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	centerprint(p1, 
						 "\bA nasty gremlin spawn - You are taunted\n"
						 "\bby the other beasties because of your  \n"
						 "\bsize and miserable failure in the movie\n"
						 "\bAnd you stink.  Get revenge. You can   \n"
						 "\bsteal human weapons. You can also learn\n"
						 "\bto set booby traps.  Oh, and try not to\n"
						 "\bget wet :-) Gremlins are not hurt by   \n"
						 "\bslime and may even drink some if health\n"
						 "\bis low.  Good luck shorty. \n");
	}
else if (p1.state == IMP_MENF)
	centerprint(p1, "\bAn elite former marine hard wired for  \n"
						 "\bcombat.  Your laser rifle has a self   \n"
						 "\bcharging battery, and you still know   \n"
						 "\bhow to use human weapons and armor.    \n"
						 "\bWreak havok, soldier.                  \n");
else if (p1.state == IMP_MSCOURGE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	centerprint(p1, "\bYou have a mechanical scorpian body with\n"
						 "\ba poison stinger and built in nailguns  \n"
						 "\bwith replicating ammo.  Life has never  \n"
						 "\bbeen better.  It was boring working for \n"
						 "\bArmagon because you didnt do anything   \n"
						 "\bbut sit and wait in one place.  Duh. If \n"
						 "\byou find certain human weapons you can  \n"
						 "\bimprove your built in weapons (you are a\n"
						 "\bbeasty tech!) to use their ammo.  And   \n"
						 "\byour built in armor is healable, but    \n"
						 "\byour health must be near max.           \n");
	}
else if (p1.state == IMP_MSHAMBLR)
	centerprint(p1, "\bYou are the loved and feared shambler.  \n"
						 "\bShoot lightning bolts and rip flesh like\n"
						 "\bthere is no tommorow.  Smash every      \n"
						 "\bliving thing you find...why?  You just  \n"
						 "\bwant to hibernate and dream about giant \n"
						 "\bhoney bee hives...                      \n");
else if (p1.state == IMP_MHKNIGHT)
	centerprint(p1, "\bBeing a former general among Shubs     \n"
						 "\bminions has taught you some new tricks.\n"
						 "\bYou know how to fire a concentrated    \n"
						 "\bburst of magic spikes from your sword. \n"
						 "\bAnd you can use armor.  Urrr, kill the \n"
						 "\bhumans.                                \n");
else if (p1.state == IMP_MSHALR)
	centerprint(p1, "\bYou are an elite spell caster from      \n"
						 "\banother dimension.  And you have no idea\n"
						 "\bwhy they call you a \"Vore\".  You're     \n"
						 "\bpissed about it too... Learn some spells\n"
						 "\bquick as your main \"missle\" spell hurts \n"
						 "\byou more at close range than they do.   \n");
else if (p1.state == IMP_MDEMON)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	centerprint(p1, "\bYou are a flesh ripping and jumping     \n"
						 "\bmachine. That is about it. And you stink\n"
						 "\bbad.  You are one thick skinned beasty. \n"
						 "\bKeep your health up and no attack can   \n"
						 "\bgib you!                                \n");
	}
else if (p1.state == IMP_MOGRE)
	centerprint(p1, "\bGrrr, get Grank and Grud.  All you know\n"
						 "\bis chainsaws and grenades.  Can an ogre\n"
						 "\blearn more?  And does he need to?      \n"
						 "\b \n"
						 "\b \n"
						 "\b \n"
						 "\b \n");
else if (p1.state == IMP_MZOMBIE)
	centerprint(p1, "\bYou are dead.  And slow. And you stink!\n"
						 "\bAs the living dead, however you do have\n"
						 "\bone advantage: regeneration. Reanimated\n"
						 "\bflesh just cant be killed unless its   \n"
						 "\bblasted apart into stinking little     \n"
						 "\bgibblets.  Go pelt all the living with \n"
						 "\byour dead and diseased flesh.          \n");
else if (p1.state == IMP_MWIZARD)
	centerprint(p1, "\bYou fly and you stink.  And you have   \n"
						 "\bspikes for arms.  Lets face it you dont\n"
						 "\bhave many redeeming qualities even for \n"
						 "\ba beasty.  You have one joy in life,   \n"
						 "\bhowever. You know how humiliating it is\n"
						 "\bwhen someone is \"Scragged\".  Find a way\n"
						 "\bof improving your attack quickly, it is\n"
						 "\bvery weak.                             \n");
else if (p1.state == IMP_MCTHON)
	centerprint(p1, "\bYou are the sentient offspring\n"
						 "\bof Cthon. You are very hot under the   \n"
						 "\bcollar at your fathers betrayers. You  \n"
						 "\bonly exist as a lava bomb blobbng around\n"
						 "\buntil you find a pool of lava. Then you\n"
						 "\bcan grow into a small Cthon. Just dont \n"
						 "\bleave the lava without returning to blob\n"
						 "\bform.  You are a very hard kill as Cthon\n");
else if (p1.state == IMP_MHUMAN) // basic grunt desc.
	{
	if (morph_classpr(p1, SC_MARINE)) return;
		centerprint(p1,
						 "\bYou are _the_ weapons guy.  If it has a\n"
						 "\btrigger and a business end you can use \n"
						 "\bit.  You learn new weapons fast...and  \n"
						 "\byou walk around looking like           \n"
						 "\bSchwarzenegger.  All the focus on      \n"
						 "\bweapons has left your defenses a little\n"
						 "\bweaker, however.                       \n");
	}
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
else if (p1.state == IMP_MSPECIAL)
	centerprint(p1, "\bYour training is simply the best.  Your\n"
						 "\bnails hurt more, your rockets explode  \n"
						 "\bharder.  Your shotguns boom louder.    \n"
						 "\bYou can even improve a few of them. You\n"
						 "\blook like  Wesley Snipes in Blade. Dont\n"
						 "\bstop your training, its critical...you \n"
						 "\bmust collect items to maintain training\n"
						 "\bdiscipline.  You have been warned.     \n");
/*
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
		centerprint(p1, 
						 "\bDoom Imp - you are a spiny fire tossing\n"
						 "\bfreak nobody wants to run into in some \n"
						 "\bdark corridor.  That pretty much says  \n"
						 "\bit all...go slay something hideously!  \n");
	}
else if (p1.state == IMP_MARACHN)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
		centerprint(p1, 
						 "\bScary monster brain on top of a spider \n"
						 "\bmechanical body - EEK.  Oh wait, thats \n"
						 "\byou.  You are one bizzare beastie from \n"
						 "\bthe Doom realm - with a built in plasma\n"
						 "\bcannon.  Go melt everything!           \n");
	}
else if (p1.state == IMP_MCYBER)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
	centerprint(p1, 
						 "\bThe original bad ass beastie from the  \n"
						 "\bDoom realm. Before the Shambler was big\n"
						 "\byou were there.  Tall as a 2 story with\n"
						 "\ba rocket launcher for a right hand. Go \n"
						 "\bkick ass? You gotta be kiddin - go     \n"
						 "\bblast them to kibbles and bits!        \n");
	}
else if (p1.state == IMP_MGUNNEY)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	centerprint(p1, 
						 "\bGunney, you are the pride of all front \n"
						 "\bline soldiers. No enemy has known fear \n"
						 "\buntil your weapons are aimed at them...\n"
						 "\bGo clear the field - you own it!       \n");
	}
else if (p1.state == IMP_MTANK)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	centerprint(p1, 
						 "\bThe Man...the Machine...the Menace!    \n"
						 "\byou are a TANK - go bust some ass now! \n"
						 "\bYour precision engineering has one goal\n"
						 "\b- years of trouble free mayhem and     \n"
						 "\bdestruction. Your builtin self reload  \n"
						 "\bweapons are ready to clear the field...\n");
	}
else if (p1.state == IMP_MSUPTANK)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	centerprint(p1, 
						 "\bThe Super Man...the Super Machine...the\n"
						 "\bSuper Menace! you are one mean machine.\n"
						 "\bYour precision engineering has one goal\n"
						 "\bthe destruction of every opponent on   \n"
						 "\bthe field of honor - go Soldier, go!   \n");
	}

//else if (p1.state == IMP_M)
//	centerprint(p1, "\n"
//						 "\n"
//						 "\n"
//						 "\n");

polymorph_id(p1,p1.state,"Your current selection = ");
sprint(p1,".\n");
};
