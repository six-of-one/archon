/* Bullet holes QuickC program
   By Jim Dose'  11/20/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Distributed (unsupported) on 3.12.97

	mod: Cataboligne - 9.24.13 - got rid of linked list, holes think to remove anyway - net effect - if max count is hit it stop making stains until some go away
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


void() remove_stain =
{
	if ( self.classname == "stain_decor" )
	{
		remove(self);
		num_stains = num_stains - 1;
		if (num_stains < 0) num_stains = 0; // oops
	}
	else
	{
#ifdef warning
		if (WARNING & 16) bprint("*** remove_stain_decor: Tried to remove non-stain_decor!\n");
#endifdef
		return;
	}
};

entity( vector pos, string stain, void() thk, float ttm ) placestain =
{
   local entity e;

	if (!stain) stain = "progs/s_rlspg.spr"; // default to rail stain
   e = spawn();
   e.classname = "stain_decor";
   setmodel( e, stain );
   setsize (e, '0 0 0', '0 0 0');
//	if (stain == "progs/s_rlspg.spr" || stain == "progs/s_plspg.spr") e.scale = 8; // redid sprites & got rid of scale

   norm = trace_plane_normal;
   norm_x = 0 - norm_x;
   norm_y = 0 - norm_y;
   e.angles = vectoangles( norm );
   makevectors(self.angles);
   setorigin( e, pos - ( v_forward * 0.2 ) );

//	if (thk != SUB_Null && thk != (void()) 0) // frikqcc method
	if (thk != SUB_Null && thk) // fteqcc method
		e.think = thk;		
	else
		e.think = remove_stain;

	if (ttm)
		e.nextthink = time + ttm;
	else
		e.nextthink = time + 30;

   num_stains = num_stains + 1;
   if ( num_stains > 200 ) // NOTE: removes current stain, not first
      {
      remove_stain();
      }

	return(e);
};
