/* ::-::
 *
 * Cataboligne
 *
 * file: mcode.qc
 *
 * date: 10/16/12
 *
 * qc - center messages for making demo videos
 *
 */

// demo messages
float dmsg_cnt, dmsg_togl, dmove;

float DEMO = 1; // set to one for recording demos with text below

void() demo_msg =
{
	if (dmsg_togl) // turn off msg - does not use up a count
	{
		dmsg_togl = 0;
		stuffcmd(self, "noadmin_centertime\n");
		centerprint(self, null_string);
		return;
	}

	stuffcmd(self, "admin_centertime\n");
	if (dmsg_cnt == 0)
	{
		centerprint(self, "Oh crap... Not good, this is not good.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 1)
		centerprint(self, "Music soothes the raging beast eh, hope its true!");
	if (dmsg_cnt == 2)
		centerprint(self, "Better find something good and fast.");
	if (dmsg_cnt == 3)
		centerprint(self, "No.  No.  WHAT?! Madonna?  Hell no, feed this to the shambler later.");
	if (dmsg_cnt == 4)
	{
		centerprint(self, "DJ Chaos Mix.  This oughta do it.");
//		centerprint(self, "Angelspit.  Heh heh..");
		dmsg_togl = 1;
	}

	if (dmsg_cnt == 5)
	{
		centerprint(self, "Woot, old Shubs taught these guys how to party.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 6)
	{
		centerprint(self, "OOPSIE.  Better make this grizzled marine disappear.");
		dmsg_togl = 1;
	}

/* portal run demo 9.10.11

	if (world.model == "maps/end.bsp" && dmsg_cnt < 25) dmsg_cnt = 25;
	
	stuffcmd(self, "admin_centertime\n");
	if (dmsg_cnt == 0)
		centerprint(self, "What the? Quake...ONE!  Again?! Arg.");
	if (dmsg_cnt == 1)
		centerprint(self, "Hrm, whats this?  Crates.  Lets see, trusty axe, check!");
	if (dmsg_cnt == 2)
		centerprint(self, "Now, what do we have here?");
	if (dmsg_cnt == 3)
		centerprint(self, "Chain Thunderbolt - cool, love the Painkeep");
	if (dmsg_cnt == 4)
		centerprint(self, "Red armor - my favorite");
	if (dmsg_cnt == 5)
		centerprint(self, "Aw yeah.");
	if (dmsg_cnt == 6)
		centerprint(self, "Portal apparatus.  That is...different.");
	if (dmsg_cnt == 7)
	{
		centerprint(self, "Gotta open 'er up then.");
		dmsg_togl = 1;
	}

	if (dmsg_cnt == 8)
		centerprint(self, "INSTRUCTIONS:");
	if (dmsg_cnt == 9)
		centerprint(self, "Select mode, target wall area, engage fire to activate.");
	if (dmsg_cnt == 10)
		centerprint(self, "Be aware of environmental hazards\nCAUTION: quantum tunnels have associated risk.");
	if (dmsg_cnt == 11)
		centerprint(self, "Huh?");
	if (dmsg_cnt == 12)
		centerprint(self, "Mode: 1 - quantum tunneling...sounds iffy to me");
	if (dmsg_cnt == 13)
		centerprint(self, "Mode: 2 - entry / exit portal.  Eww.  Dont even want to know.");
	if (dmsg_cnt == 14)
		centerprint(self, "Mode: 3 - select random teleport.  WHAT?\nRandom freaking teleports got us in this mess!");
	if (dmsg_cnt == 15)
		centerprint(self, "Mode: 4 - portal telefrag.  Now we're talkin.");
	if (dmsg_cnt == 16)
		centerprint(self, "Mode: 5 - multi portal telefrag.\nGonna have to try that after they work the bugs out.");
	if (dmsg_cnt == 17)
	{
		centerprint(self, "Enough of this, lets go try this baby out on Shubbers.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 18)
		centerprint(self, "First, a little test, heh heh.");
	if (dmsg_cnt == 19)
		centerprint(self, "Cripes!");
	if (dmsg_cnt == 20)
		centerprint(self, "Figures.  Live human subject then, <SIGH>.");
	if (dmsg_cnt == 21)
		centerprint(self, "Ha, cool!");
	if (dmsg_cnt == 22)
	{
		centerprint(self, "Right, off we go.  We'll see about this quantum tunnel.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 23)
	{
		centerprint(self, "Hrm, doesnt seem to work on rune gates.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 24)
		centerprint(self, "Ah ha, ye old tunnel to shubs lair.\nRunes Shmunes, who needs em?");
	if (dmsg_cnt == 25)
	{
		centerprint(self, "A verticle drop into stinky water - \nbet a quid there's rot fish down here.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 26)
	{
		centerprint(self, "Told ya so.");
		stuffcmd(self, "noadmin_centertime\n");
	}
	if (dmsg_cnt == 27)
	{
		centerprint(self, "Ladies & gents, introducing, the one the only\nShub NIggurath herself.  Right, telefrag time.");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 28)
		centerprint(self, "Target Acquired - got you locked in my sights shubs.");
	if (dmsg_cnt == 29)
	{
		centerprint(self, "Doink - portal open...and...");
		dmsg_togl = 1;
	}
	if (dmsg_cnt == 30)
	{
		centerprint(self, "...BAM.");
		stuffcmd(self, "noadmin_centertime\n");
	}
*/

	dmsg_cnt = dmsg_cnt + 1;
};


/* test code goes here - splash,qc

void(entity e) MakeSplash =
{
	...
		if (pc == CONTENT_LAVA || e.inwater == CONTENT_LAVA)
		{
			...
		}
		else
		{
		...


// TEST: demo - insert this code
if (DEMO)
if (e.classname == "player" && !dmove)
{
	dmove = 1;
	e.movetype = 0;
}



*/


/* test code goes here - pk_weapons.qc

void() PK_ImpulseCommands =
{
	local entity sv;



// TEST: demo making - insert this code
if (DEMO)
if (self.impulse == IMP_MSIGHT)
{
	if (self._summon != SUB_Null) self._summon();
	self.impulse = 0;
	return;
}



*/

/* test code goes here - pk_client.qc

void() PutClientInServer =
{

...

polymorph_check(self.morphy, self.morphy); // become incarnation



// TEST: demo - insert this code
if (DEMO)
{
	self._summon = demo_msg;
	stuffcmd(self, "cd stop\n");
	stuffcmd(self, "notest\n");
}



*/


