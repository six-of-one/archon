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
	if (ck.class_select != "class_bot")
	if (!(ck.cnt & cl))
	{
		ck.cnt = ck.cnt | cl;
		if (cl == SC_BEASTY) ck.mcode = 1101;
		else if (cl == SC_MARINE) ck.mcode = 1102;
		else if (cl == SC_DOOM) ck.mcode = 1103;
		else if (cl == SC_Q2) ck.mcode = 1104;

		ck.state = -1; // HUD

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
			centerprint3(self.enemy, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\b                 ARCHON!                \n\b----------------------------------------\n\bYou have been chosen - So might it be...\nselect a demense with these controls:   \n\b----------------------------------------\n\bUse cycle weapon+ to go forward -       \nUse cycle weapon- to go backward.       \nPress alt-fire to finish your selection \nand become one!                         \nselect any weapon with 1 - 9 to exit.   \n----------------------------------------\n\byou have: ", ftos(floor(self.enemy.archon)), " points.");
		}
		else
		{
			centerprint3(self.enemy, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\b           Welcome to Archon.           \n\b----------------------------------------\n\bYou can now evolve - please select an   \nevolution with these controls:          \n\b----------------------------------------\n\bUse cycle weapon+ to go forward -       \nUse cycle weapon- to go backward.       \nPress alt-fire to finish your selection \nand Evolve!                             \nselect any weapon with 1 - 9 to exit.   \n----------------------------------------\n\byou have: ", ftos(floor(self.enemy.archon)), " points.");
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
p1.mcode = p1.eweapon.mcode;

if (p1.class_select != "class_bot")
if (p1.cnt < 0)
	{
		newmis = spawn();
		newmis.think = morph_print_notify;
		newmis.nextthink = time + 0.5;
		newmis.enemy = p1;
		newmis.mask_x = p1.eweapon.mask_x; // would not compile when this was .mask = .mask

		p1.cnt = 0; // clear for classpr
		p1.state = -1; // HUD
		return;
	}

if (p1.state == IMP_MCHAOS)
	{
	p1.eweapon.archon = 5000;
	}
else if (p1.state == IMP_MORDER)
	{
	p1.eweapon.archon = 5000;
	}
else if (p1.state == IMP_MGREMLIN_F)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 35;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 80;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 20;
	else p1.eweapon.archon = 200;
	}
else if (p1.state == IMP_MENF)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 20;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 45;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 10;
	else p1.eweapon.archon = 100;
	}
else if (p1.state == IMP_MSCOURGE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 60;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 125;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 40;
	else p1.eweapon.archon = 300;
	}
else if (p1.state == IMP_MSHAMBLR)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 100;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 180;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 80;
	else p1.eweapon.archon = 450;
	}
else if (p1.state == IMP_MHKNIGHT)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 60;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 120;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 40;
	else p1.eweapon.archon = 300;
	}
else if (p1.state == IMP_MSHALR)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 65;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 145;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 45;
	else p1.eweapon.archon = 300;
	}
else if (p1.state == IMP_MDEMON)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 115;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 200;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 75;
	else p1.eweapon.archon = 500;
	}
else if (p1.state == IMP_MOGRE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 55;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 120;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 35;
	else p1.eweapon.archon = 300;
	}
else if (p1.state == IMP_MZOMBIE)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 20;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 45;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 10;
	else p1.eweapon.archon = 100;
	}
else if (p1.state == IMP_MWIZARD)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 45;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 100;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 25;
	else p1.eweapon.archon = 200;
	}
else if (p1.state == IMP_MCTHON)
	{
	if (morph_classpr(p1, SC_BEASTY)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 60;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 125;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 40;
	else p1.eweapon.archon = 300;
	}

else if (p1.state == IMP_MHUMAN) // basic grunt desc.
	{
	if (morph_classpr(p1, SC_MARINE)) return;
	if (p1.mask_x == CB_CHAOS) p1.eweapon.archon = 25;
	else if (p1.mask_x == CB_ORDER) p1.eweapon.archon = 50;
	else if (p1.mask_x == CB_SHAPESHIFT) p1.eweapon.archon = 17;
	else p1.eweapon.archon = 150;
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
	p1.eweapon.archon = 200;
//						 "Imp:\n----------------------------------------\n\bDoom Imp - you are a spiny fire tossing\nfreak nobody wants to run into in some \ndark corridor.  That pretty much says  \nit all...go slay something hideously!  \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MARACHN)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
	p1.eweapon.archon = 400;
//						 "Arachnotron:\n----------------------------------------\n\bScary monster brain on top of a spider \nmechanical body - EEK.  Oh wait, thats \nyou.  You are one bizzare beastie from \nthe Doom realm - with a built in plasma\ncannon.  Go melt everything!           \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MCYBER)
	{
	if (morph_classpr(p1, SC_DOOM)) return;
	p1.eweapon.archon = 800;
//						 "Cyberdemon:\n----------------------------------------\n\bThe original bad ass beastie from the  \nDoom realm. Before the Shambler was big\nyou were there.  Tall as a 2 story with\na rocket launcher for a right hand. Go \nkick ass? You gotta be kiddin - go     \nblast them to kibbles and bits!        \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MGUNNEY)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	p1.eweapon.archon = 300;
//						 "Gunney:\n----------------------------------------\n\bGunney, you are the pride of all front \nline soldiers. No enemy has known fear \nuntil your weapons are aimed at them...\nGo clear the field - you own it!       \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MTANK)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	p1.eweapon.archon = 750;
//						 "Tank:\n----------------------------------------\n\bThe Man...the Machine...the Menace!    \nyou are a TANK - go bust some ass now! \nYour precision engineering has one goal\n- years of trouble free mayhem and     \ndestruction. Your builtin self reload  \nweapons are ready to clear the field...\n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}
else if (p1.state == IMP_MSUPTANK)
	{
	if (morph_classpr(p1, SC_Q2)) return;
	p1.eweapon.archon = 2000;
//						 "Super Tank:\n----------------------------------------\n\bThe Super Man...the Super Machine...the\nSuper Menace! you are one mean machine.\nYour precision engineering has one goal\nthe destruction of every opponent on   \nthe field of honor - go Soldier, go!   \n\b----------------------------------------\nuses: ", ftos(p1.eweapon.archon), " points.");
	}

//else if (p1.state == IMP_M)
//	centerprint3(p1,
//						 "\n"
//						 "\n"
//						 "\n"
//						 "\n"

	if (MORPH_FREE && (p1.eweapon.mcode != -666))
		p1.eweapon.archon = 0;
	else
	if (p1.archon > p1.eweapon.archon)
	{
		if (p1.eweapon.mcode == -666)
		if (p1.ammo_nails == 5)
			p1.eweapon.archon = p1.eweapon.archon * 1.4; // 40% more for poly other
	}

/*
	if (MORPH_FREE && (p1.eweapon.mcode != -666))
	{
		p1.eweapon.archon = 0;
		sprint(p1,"Your current selection = ");
		sprint(p1,polymorph_id(p1.state));
		sprint(p1,".\n");
	}
	else
	if (p1.archon > p1.eweapon.archon)
	{
		if (p1.eweapon.mcode == -666)
		if (p1.ammo_nails == 5)
			p1.eweapon.archon = p1.eweapon.archon * 1.4; // 40% more for poly other
		sprint(p1,"Your current selection = ");
		sprint(p1,polymorph_id(p1.state));
		sprint(p1,", ");
		sprint(p1,ftos(p1.eweapon.archon));
		sprint(p1," points.\n");
	}
*/
};
