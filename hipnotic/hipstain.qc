/* Bullet holes QuickC program
   By Jim Dose'  11/20/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Distributed (unsupported) on 3.12.97
*/

/*QUAKED wallsprite (0 1 0) (-8 -8 -8) (8 8 8)
Places a sprite on a wall.  Angles should be opposite of face.

"model" sprite to place on wall.  Default is "progs/s_blood1.spr".
*/
void() wallsprite =
   {
   if ( !self.model )
      {
      self.model = "progs/s_blood1.spr";
      }

   precache_model( self.model );
   setmodel (self, self.model );

   // QuakeEd doesn't save up and down angles properly.
   if (self.angles == '0 -1 0')
      self.angles = '-90 0 0';
	else if (self.angles == '0 -2 0')
      self.angles = '90 0 0';

   // Pull the sprite away from the wall slightly to
   // get rid of z sort errors.
   makevectors(self.angles);
   setorigin( self, self.origin - ( v_forward * 0.2 ) );
	makestatic (self);
   };

void() Initstain_set =
   {
   precache_model ("progs/s_bullet.spr");

   stain_set = nullstain;
   last_stain = nullstain;
   num_stains = 0;
   };

void() remove_stain =
{
   local entity ent;

   // There is a possibility that this is not the first bullet
   // in the list, but it doesn't really matter.  All that
   // matters is there is one less bullet.  Just make sure
   // we don't remove the world!
   if ( stain_set == nullstain )
      {
      if (Q_100) objerror("remove_stain_decor: stain_set == nullstain! " );
		else if (WARNING)
			{
				bprint("*** remove_stain_decor: stain_set == nullstain! ");
				stain_set = last_stain = world;
				num_stains = 0;
				return;
			}
      }

   ent = stain_set;
   if ( ent.classname != "stain_decor" )
      {
      if (Q_100) objerror("remove_stain_decor: Tried to remove non-stain_decor!\n");
		else if (WARNING)
			{
				bprint("*** remove_stain_decor: Tried to remove non-stain_decor!\n");
				stain_set = last_stain = world;
				num_stains = 0;
				return;
			}
      }

   stain_set = stain_set.lastvictim;
   remove( ent );
   if ( last_stain == ent )
      {
      last_stain = nullstain;
      }
   num_stains = num_stains - 1;

	if (num_stains < 0) num_stains = 0;
};

entity( vector pos, string stain, void() thk, float ttm ) placestain =
{
   local entity new;
   local entity ent;
   local vector norm;
	local string stainv;

	stainv = stain;
	if (!stainv) stainv = "progs/s_rlspg.spr";
   new = spawn();
   new.owner = new;
   new.movetype = MOVETYPE_NONE;
   new.solid = SOLID_NOT;
   new.classname = "stain_decor";
//   setmodel( new, "progs/s_bullet.spr" );
   setmodel( new, stainv );
   setsize (new, '0 0 0', '0 0 0');
	if (stainv == "progs/s_rlspg.spr" || stainv == "progs/s_plspg.spr") new.scale = 8; // TDO: redo sprites & get rid of scale
	new.alpha = 1;

   norm = trace_plane_normal;
   norm_x = 0 - norm_x;
   norm_y = 0 - norm_y;
   new.angles = vectoangles( norm );
   makevectors(self.angles);
   setorigin( new, pos - ( v_forward * 0.2 ) );

	if (thk != SUB_Null && thk != (void()) 0)
		new.think = thk;		
	else
		new.think = remove_stain;

	if (ttm)
		new.nextthink = time + ttm;
	else
		new.nextthink = time + 300;

   num_stains = num_stains + 1;
   if ( num_stains > 150 )
      {
      remove_stain();
      }

   if ( last_stain != nullstain )
      {
      last_stain.lastvictim = new;
      }
   else
      {
      stain_set = new;
      }
   new.lastvictim = nullstain;
   last_stain = new;

	return(new);
};
