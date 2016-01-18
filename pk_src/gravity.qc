/*
	gravity well
	Written by Matt Houser
	an Evolve project
*/

$frame cubelf01 cubelf02 cubelf03 cubelf04 cubelf05 cubelf06 cubelf07 cubelf08
$frame cubelf09 cubelf10 cubelf11 cubelf12 cubelf13 cubelf14 cubelf15 cubelf16
$frame cubelf17 cubelf18 cubelf19 cubelf20

$frame cube201 cube202 cube203 cube204 cube205 cube206 cube207 cube208
$frame cube209 cube210 cube211 cube212 cube213 cube214 cube215 cube216
$frame cube217 cube218 cube219 cube220


// check to see if ents are visible to gravity wave

float (entity targ) grav_visible =
{
	local vector	spot1, spot2, v2;
	local float f;

	v2 = v0;
	if (targ.flags & FL_CLIENT) f = TRUE;
	else
	if (targ.class_select == "class_bot") f = TRUE;
	if (targ.flags & FL_MONSTER) f = TRUE;
	if (f) v2 = targ.view_ofs;

	spot1 = self.origin;
	spot2 = targ.origin + v2;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters

// TDO: pull some liquid with it - full chaos mod env expansion
//	if (trace_inopen && trace_inwater)
//		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;

// WATCH: keep an eye on this hack of a fix, until the "better" solution is available
	if (!f)
	if (pointcontents (targ.origin) == CONTENT_SOLID) // IDEA: qualify as x weps as well?
	if (trace_fraction > 0.65)
		return TRUE;

	if (f) return FALSE;
/*
	spot1 = self.origin + ' 0 0 24';
	traceline (spot1, spot2, TRUE, self);	
	if (trace_fraction == 1) return TRUE;

	spot1 = self.origin + ' 0 0 -16';
	traceline (spot1, spot2, TRUE, self);
	if (trace_fraction == 1) return TRUE;
*/
	return FALSE;
};

void() gravity_touch =
{
	// try to gib whatever touched the gravity centre
	if (other.takedamage && other.health > 0)
	{
		// sound

		T_Damage(other, self, self.owner, 5000);
	}

	if (other.classname == "turret")
	if (other.delay == TRUE)
	{
		turret_KillStraker(other, 1 + random() * 5);
	}

};

void() gravity_pull =
{
	local entity e, g;
	local float d, sgl, i;
	local vector org, v1;
	local float gPercent;
	local float gDist, gExt, gFal;
	local float gPower;

	gDist = 960;		// range of the weapon
	gPower = 512;	// ideal speed of pull
	gExt = 0; // extra dist - only super gravwell

// either banished & went grav or grav + sphere
	if (self.classname == "sphere_annihilation") // these are a bit more powerfull
	{
		gDist = 1290 + random() * 200;
		gPower = 640 + random() * 100;		
	}

	if (self.frame > $cubelf20) // super grav well = sgw
	{
		gDist = 1280;
		gPower = 640;
		gExt = 320; // laser beam range out to 1600
		sgl = TFL_HEAL | TFL_TKDMG | TFL_TRACE | TFL_INVIS;		// all hittable things for lazer
	}

// idea: sgw -  phantom zone effect with 6 sides flying off, catching vars ents, & sweeping from level - players watch this - time out & allow respawn / return
	if (time > self.attack_finished)
	{
		// turn off bright light
		if (self.effects & EF_BRIGHTLIGHT)
			self.effects = self.effects - EF_BRIGHTLIGHT;

		// do an explosion
		T_RadiusDamage(self, self.owner, 80, world);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		BecomeExplosion();
		return;
	}

	org = (self.absmin + self.absmax) * 0.5;
	e = findradius(self.origin, gDist + gExt);


	while (e)
	{



// TESTING
if (WARNING)
{

if (!grav_visible(e))
	{
		bprint("--- failed grav pull: ");
		bprint(item_ident(e));
		bprint(", by visible\n");
	}

if (!pk_art_movshot_ck(e, "grav"))
	{
		bprint("--- failed grav pull: ");
		bprint(item_ident(e));
		bprint(", by pk_art_movshot\n");
	}

}

		gFal = TRUE; // fail check for ext dist items
		if (gExt) // sgw - laser range test
		{
			if (vlen(e.origin - self.origin) > gDist)
			{
// idea: sgw - chance to teleport out of range in range
//if (e != self.owner) //TEST:
				if (random() < 0.366)
				if (can_has_target(e, self, self.origin, 0, sgl)) // check LOS to grav
				{
					T_Damage (e,self,self.owner,10); // fired black laser

					v1 = e.origin - self.origin;
					g = chaos_spawn(MOVETYPE_NONE, SOLID_NOT, 0, 0, self.origin, v0, v0, vectoangles(v1), v0, "", "progs/lzrbm_seg.mdl", SUB_Remove, 0.2, SUB_Remove, SUB_Null, self, world);
					i = vlen(v1);
					i = floor(i / 32);
					if (i > 63) i = 63;
					g.frame = i;
					g.skin = 2;
				}
				gFal = FALSE; // laser beam range item only
			}
			else // in range - other tests
			{
// idea: sgw - grim flakes
//if (1) // TEST:
				if (random() < 0.45)
				{
					v1 = v0;
					v1_x = crandom() * 25;
					v1_y = crandom() * 25;
					v1_z = crandom() * 25;
					chaos_particle(e.origin + v1, 0, 0.8, 0);
				}
				if (e.hook & HOOK_ON)
				if (random() < 0.28) // heh heh - strong enough to release hooks
					DropHook_ent(e);
			}
		}

// idea: sgw - check for players / bots moving & lift if not - e.g. stuck behind brush, or just pull through solid

		if (gFal)
		if (grav_visible(e))
		if (e.classname != "gravity") // don't yank on any other gravity wells
		if (e.classname != "beartrap")
		if (e.model != "progs/boss.mdl" && e.model != "progs/oldone.mdl" && e.model != "progs/cthon.mdl") // dont pull bosses or cthon morph
		if (pk_art_movshot_ck(e, "grav")) // Cataboligne 8.12.9 purify - pk artifacts
		if (e.classname != "chase_cam")
		//if (e != self.owner)
		if ((e.classname == OBSERVER && random() < 0.001666) || e.classname != OBSERVER)
		if (e.movetype != MOVETYPE_NONE) // anything that can move
		if (e.movetype != MOVETYPE_PUSH)
		if (e.movetype != MOVETYPE_NOCLIP)
		{
			d = vlen(e.origin - org);
			if (e.flags & FL_ONGROUND)
			{
				// raise the object a bit
				setorigin(e, e.origin + '0 0 1');
				e.flags = e.flags - FL_ONGROUND;
			}
			//dprint(e.classname);
			gPercent = 1 - (d / gDist);

			// modify the velocity
			e.velocity = e.velocity + normalize(self.origin - e.origin) * gPower * gPercent;

			if (e.map  == "rune" && e.classname == "item_sigil") // relocate runes sucked by wells
				e.hook = TRUE;
		}
		e = e.chain;
	}
};

void() gravity_pulse1 = [ $cubelf01, gravity_pulse2 ] { gravity_pull(); };
void() gravity_pulse2 = [ $cubelf02, gravity_pulse3 ] { gravity_pull(); };
void() gravity_pulse3 = [ $cubelf03, gravity_pulse4 ] { gravity_pull(); };
void() gravity_pulse4 = [ $cubelf04, gravity_pulse5 ] { gravity_pull(); };
void() gravity_pulse5 = [ $cubelf05, gravity_pulse6 ] { gravity_pull(); };
void() gravity_pulse6 = [ $cubelf06, gravity_pulse7 ] { gravity_pull(); };
void() gravity_pulse7 = [ $cubelf07, gravity_pulse8 ] { gravity_pull(); };
void() gravity_pulse8 = [ $cubelf08, gravity_pulse9 ] { gravity_pull(); };
void() gravity_pulse9 = [ $cubelf09, gravity_pulse10 ] { gravity_pull(); };
void() gravity_pulse10 = [ $cubelf10, gravity_pulse11 ] { gravity_pull(); };
void() gravity_pulse11 = [ $cubelf11, gravity_pulse12 ] { gravity_pull(); };
void() gravity_pulse12 = [ $cubelf12, gravity_pulse13 ] { gravity_pull(); };
void() gravity_pulse13 = [ $cubelf13, gravity_pulse14 ] { gravity_pull(); };
void() gravity_pulse14 = [ $cubelf14, gravity_pulse15 ] { gravity_pull(); };
void() gravity_pulse15 = [ $cubelf15, gravity_pulse16 ] { gravity_pull(); };
void() gravity_pulse16 = [ $cubelf16, gravity_pulse17 ] { gravity_pull(); };
void() gravity_pulse17 = [ $cubelf16, gravity_pulse18 ] { gravity_pull(); };
void() gravity_pulse18 = [ $cubelf16, gravity_pulse19 ] { gravity_pull(); };
void() gravity_pulse19 = [ $cubelf16, gravity_pulse20 ] { gravity_pull(); };
void() gravity_pulse20 = [ $cubelf16, gravity_pulse1 ] { gravity_pull(); };

// sgw animate
void() gravity_pulsex1 = [ $cube201, gravity_pulsex2 ] { gravity_pull(); };
void() gravity_pulsex2 = [ $cube202, gravity_pulsex3 ] { gravity_pull(); };
void() gravity_pulsex3 = [ $cube203, gravity_pulsex4 ] { gravity_pull(); };
void() gravity_pulsex4 = [ $cube204, gravity_pulsex5 ] { gravity_pull(); };
void() gravity_pulsex5 = [ $cube205, gravity_pulsex6 ] { gravity_pull(); };
void() gravity_pulsex6 = [ $cube206, gravity_pulsex7 ] { gravity_pull(); };
void() gravity_pulsex7 = [ $cube207, gravity_pulsex8 ] { gravity_pull(); };
void() gravity_pulsex8 = [ $cube208, gravity_pulsex9 ] { gravity_pull(); };
void() gravity_pulsex9 = [ $cube209, gravity_pulsex10 ] { gravity_pull(); };
void() gravity_pulsex10 = [ $cube210, gravity_pulsex11 ] { gravity_pull(); };
void() gravity_pulsex11 = [ $cube211, gravity_pulsex12 ] { gravity_pull(); };
void() gravity_pulsex12 = [ $cube212, gravity_pulsex13 ] { gravity_pull(); };
void() gravity_pulsex13 = [ $cube213, gravity_pulsex14 ] { gravity_pull(); };
void() gravity_pulsex14 = [ $cube214, gravity_pulsex15 ] { gravity_pull(); };
void() gravity_pulsex15 = [ $cube215, gravity_pulsex16 ] { gravity_pull(); };
void() gravity_pulsex16 = [ $cube216, gravity_pulsex17 ] { gravity_pull(); };
void() gravity_pulsex17 = [ $cube216, gravity_pulsex18 ] { gravity_pull(); };
void() gravity_pulsex18 = [ $cube216, gravity_pulsex19 ] { gravity_pull(); };
void() gravity_pulsex19 = [ $cube216, gravity_pulsex20 ] { gravity_pull(); };
void() gravity_pulsex20 = [ $cube216, gravity_pulsex1 ] { gravity_pull(); };


void() gravity_explode =
{
	//if (time > self.attack_finished)
	//{
		// TODO something funky in the water?

		setmodel(self, "progs/cubel.mdl");
		self.nextthink = time + 0.1;

		if (self.alpha < 1)
		{
			setsize(self, '-8 -8 -8', ' 8 8 8');
			if (self.frame < $cube201)
			{
				self.frame = $cube201;
				self.skin = 1;
			}
			self.alpha = self.alpha + 0.05;
			self.frame = self.frame + 0.5;
			return;
		}

		if (self.frame > $cubelf20)
		{
			sound (self, CHAN_BODY, "misc/grav/grav_new.wav", 1, ATTN_NORM);
			self.attack_finished = time + PK_GRV_TIME + random() + random() + random();	// duration of sgw
			self.think = gravity_pulsex1;
		}
		else
		{
			self.attack_finished = time + PK_GRV_TIME;	// duration of gravity well
			self.think = gravity_pulse1;
		}

		self.touch = gravity_touch;
		self.effects = self.effects | EF_BRIGHTLIGHT;
	  self.pk_currentitem = PK_IT_GRAVITYWELL;
	//	return;
	//}

	//sound (self, CHAN_BODY, "misc/gravsp_3.wav", 1, ATTN_NORM);
	//self.nextthink = time + 1.0;
};

// idea: sgw - move sphere up 200 units, or 1/2 dist bot to top if  < 400 units

void() drop_gravity =
{
	local entity gravity;

	if (!PK_GRV_SET)
	{
		PK_GRV_SET = TRUE;

		PK_GRV_TIME = 3.2; // def

		if (!PK_100)
		if (DARKPLACES || chaos)
		{
			PK_GRV_TIME = cvar("pk_grv_time");
		}
	}

	// create a gravity object
	newmis = gravity = spawn();
	gravity.classname = "gravity";
	gravity.owner = self;
	gravity.solid = SOLID_TRIGGER;
	gravity.movetype = MOVETYPE_TOSS;

	// set it's placement and velocity
	setorigin(gravity, self.origin + self.view_ofs);
	gravity.velocity = self.velocity * 0.5;
	setmodel(gravity, "progs/cube.mdl");
	// TODO get acurate sizing
	setsize(gravity, '-32 -32 -32', '32 32 32');

	/*
	gravity.think = gravity_explode;
	gravity.nextthink = time + 1.0;
	gravity.attack_finished = time + 2.1;
	*/
	gravity.think = gravity_explode;
	gravity.nextthink = time + 2.0;
	sound (self, CHAN_BODY, "misc/grav/grav_new.wav", 1, ATTN_NORM);

	// Throw away from you
	makevectors (self.angles);
	gravity.velocity = (v_forward * (200 + random() * 100)) + (v_up * (200 + random() * 100));

	// For the correct death messages
	gravity.pk_currentitem = PK_IT_GRAVITYWELL;
	gravity.weapon = IT_AXE;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(gravity);
};

void() drop_gravity_sups =
{
	drop_gravity();
	sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
	newmis.frame = 1;
	newmis.alpha = 0.1;
};

