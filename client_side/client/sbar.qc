/*

client/sbar.qc

This is a slight redesign of the quake item bar.

*/

var float ibar_alpha = 1;

float SB_BOTTOM = 0;
float SB_MIDDLE = 1;
float SB_TOP    = 2;
float SB_BOTTOM_RIGHT = 3;
float sb_align;

float cl_items;

//-----------------------------------------------------------------------------
// Custom hud config init / shutdown
//-----------------------------------------------------------------------------


void() Sbar_Init =
{
	if((cvar("viewsize") >= 113) && (cvar("viewsize") <= 115))
		{
			compass = 1;
			ibar_flag = cvar("viewsize") - 113;
			if (ibar_flag == 0 ) ibar = 0;
			else ibar = 1;
			cvar_set("viewsize", "110");
		}
	else if((cvar("viewsize") >= 110) && (cvar("viewsize") <= 112))
		{
			compass = 0;
			ibar_flag = cvar("viewsize") - 110;
			if (ibar_flag == 0 ) ibar = 0;
			else ibar = 1;
			cvar_set("viewsize", "110");
		}
	if(cvar("viewsize") == 101) compass = 1;

	weapons_offset = autocvar_hud_weapons_offset;
	var float autocvar_waterfog = 0;
	waterfog = autocvar_waterfog;

	if (((getkeybind(67)=="")&&(getkeybind(99) =="")))	localcmd("bind c compass\n");
	if (((getkeybind(88)=="")&&(getkeybind(120)=="")))	localcmd("bind x itembar\n");
	if (((getkeybind(70)=="")&&(getkeybind(102)=="")))	localcmd("bind f itembar\n");
	if (((getkeybind(82)=="")&&(getkeybind(114)=="")))	localcmd("bind r compass\n");
	if (((getkeybind(91)=="")&&(getkeybind(123)=="")))	localcmd("bind [ consizedown\n");
	if (((getkeybind(93)=="")&&(getkeybind(125)=="")))	localcmd("bind ] consizeup\n");


	cvar_set("vid_conheight", ftos(cvar("vid_conwidth")*cvar("vid_height")/cvar("vid_width")));
};

void() Sbar_Shutdown =
{
	if((cvar("viewsize") >= 110) && (cvar("viewsize") < 120))
	{
		if(compass == 1) cvar_set("viewsize", ftos(110 + ibar_flag + 3));
		else cvar_set("viewsize", ftos(110 + ibar_flag));
	}
	if((cvar("viewsize") >= 100) && (cvar("viewsize") < 110) && compass )
		cvar_set("viewsize", "101");
};


//-----------------------------------------------------------------------------
// Sbar_Draw functions
//-----------------------------------------------------------------------------

vector(vector v) sbar_align =
{
	if (sb_align == SB_MIDDLE)
	{
		v_x = v_x + (vid_conwidth / 2);
		v_y = v_y + (vid_conheight / 2);
		return v;
	}

	if (sb_align == SB_TOP)
	{
		v_x = v_x + (vid_conwidth / 2);
		// no change to v_y
		return v;
	}
	if (sb_align == SB_BOTTOM_RIGHT)
	{
		v_x = vid_conwidth - ( 320 - v_x );
		v_y = vid_conheight - v_y;
		return v;
	}

	// SB_BOTTOM - the default
	v_x = v_x + (vid_conwidth / 2);
	v_y = vid_conheight - v_y;
	return v;
};
 
/*
void(vector pos, string pic, float alph, float escala, float tre) Sbar_DrawPic2 =
{
	local vector siz;
	siz = drawgetimagesize(pic);
	siz_x = siz_x * escala;
	siz_y = siz_y * tre;
	
	//siz_x = drawgetimagesize(pic) * escala;
	//siz_y = drawgetimagesize(pic) * tre;

	pos = sbar_align(pos);
	drawpic(pos, pic, siz, VEC_1, alph, DRAWFLAG_NORMAL);
};
*/

void(vector pos, string pic, float alph, float escala) Sbar_DrawPic =
{
	local vector siz;
	siz = drawgetimagesize(pic) * escala;
	pos = sbar_align(pos);
	drawpic(pos, pic, siz, VEC_1, alph, DRAWFLAG_NORMAL);
};

void(vector pos, float char, float alph) Sbar_DrawCharacter =
{
	pos = sbar_align(pos);
	drawcharacter(pos, char, '8 8 0', VEC_1, alph, DRAWFLAG_NORMAL);
};

void(vector pos, string str, float alph,vector medida,vector coloracion) Sbar_DrawString =
{
	pos = sbar_align(pos);
	drawstring(pos, str, medida, coloracion, alph, DRAWFLAG_NORMAL);
};


void(vector pos, float num, float digits, float color, float alpha) Sbar_DrawNum =
{
	string pic, s, digit;
	float i, len, cnt;
	vector v;

	s = ftos(num);
	len = strlen(s);
	
	// draw the last 'digits' chars of s
	cnt = digits;
	if (len < digits) cnt = len;

	for (i=1; i<=cnt; i=i+1)
	{
		digit = substring(s, len - i, 1);
		if (digit == "-")
			digit = "minus";
		if (color)
			pic = strcat("gfx/anum_", digit);
		else
			pic = strcat("gfx/num_", digit);

		v = pos + ('24 0 0' * (digits - i));
		Sbar_DrawPic(v, pic, alpha,1);
	}
};


//-----------------------------------------------------------------------------
// Sbar_DrawCompass
//-----------------------------------------------------------------------------

vector(float x, float y) vec2 =
{
	vector v;
	v_x = x;
	v_y = y;
	return v;
};

void() Sbar_DrawCompass =
{

	sb_align = SB_TOP;

	local string compass_string, s, point;
	local float ang, yaw, ofs, i, strofs;
	
	compass_string = "N...ne...E...se...S...sw...W...nw...";
	compass_string = strconv(CONV_SAME, CONV_RED, CONV_RED, compass_string);
	point = strconv(CONV_SAME, CONV_RED, CONV_RED, ".");
	
	// Note: STAT_COMPASS_NORTH is a stat I was using in a server side
	// mod so that the level could change the north position of the compass (and basically
	// pretend that the entire level is aligned at any compass angle. I've left the code
	// here so that it's easy to add back.
	ang = 365 - (input_angles_y /* - GetStat_FLOAT_TRUNCATED(STAT_COMPASS_NORTH) */ );
	while (ang < 0)
	{ ang = ang + 360; }
	while (ang >= 360)
	{ ang = ang - 360; }
	
	ang = ang * 0.1;//(365 - angle) * 0.1;
	yaw = ceil(ang);
	ofs = (ceil(ang) - ang) * 8;
	yaw = yaw - 5;
	
	for (i=0; i<9; i=i+1)
	{
		strofs = yaw + i;
		if (strofs > 35)
			strofs = strofs - 36;
		if (strofs < 0)
			strofs = strofs + 36;
		// a hack to centre '.' characters a bit more
		// theres no centred red dot in conchars
		s = substring(compass_string, strofs, 1);
		if (s == point)
			Sbar_DrawString(vec2(-40 + ofs + i*8 + 2, 8 - 1), s, 1,'8 8 0','1 1 1' );
		else
			Sbar_DrawString(vec2(-40 + ofs + i*8, 8), s, 1,'8 8 0', '1 1 1');
	}
	
	s = strcat(chr2str(16), "        ", chr2str(17));
	Sbar_DrawString('-40 8 0', s, 1,'8 8 0','1 1 1');
};

//-----------------------------------------------------------------------------
// Sbar_DrawInventory
//-----------------------------------------------------------------------------

float items, items2, currentweap, mcode;
float rune_flag;
float pk_inv, pk_wep;

//  for the 4 small sized ammo counts on the right side
void(vector valor, float ammo, float transparencia) DrawAmmo =
{
	vector v;
	string s;
	v = valor;
	v_y = v_y + weapons_offset;

if (ammo >= 100)
{
	s = strconv(CONV_SAME, CONV_RED, CONV_WHITESPECIAL, ftos(ammo));
	Sbar_DrawString(v, s, transparencia, '7 7 0','0.5 0.7 1');
}
if ((ammo >= 10) && (ammo <= 99)) 
{
	v_x = v_x + 7;    
	s = strconv(CONV_SAME, CONV_RED, CONV_WHITESPECIAL, ftos(ammo));
	Sbar_DrawString(v, s, transparencia, '7 7 0','1 1 1');
}
if ((ammo >= 0) && (ammo <= 9)) 
{
	v_x = v_x + 14;   
	s = strconv(CONV_SAME, CONV_RED, CONV_WHITESPECIAL, ftos(ammo));
	Sbar_DrawString(v, s, transparencia, '7 7 0','1 0.5 0.5');
}
};

void(vector valor, string pic, float itemnum, float item2num, float transparencia, float scale) DrawInventory =
{
	vector v;
	v = valor;
	if (items & itemnum || items2 & item2num)
	{
		Sbar_DrawPic(v, pic, transparencia, scale);
	}
};
 
// scale - usual scale, cause some weps scale wrong
// spcl - pk wep, etc

void(vector valor, string pic1, string pic2, float itemnum, float scale, float spcl) DrawInventoryWeapon =
{
	vector v;
	string pic;
	float inv_alm, draw, has;

// if invisible, ghost all holstered weps
	inv_alm = 1;
	if (items & IT_INVISIBILITY) inv_alm = 0.2;

	has = items & itemnum;
	draw = (currentweap == itemnum);

// testing pk weps
	if (spcl == STAT_PKWEP)
	{
		has = pk_inv & itemnum;
		draw = (pk_wep == itemnum);
		if ((pk_wep == PK_IT_AIRGUN) && (mcode != MC_AIRGUN)) draw = FALSE;
	}

	if (has)
	{
      v = valor;
		v_y = v_y + weapons_offset;    
		if (draw)
		{
			pic = pic2;
			inv_alm = 1;
// code hasted weps - dbl image on active wep
			if ((rune_flag & RUNE_FLG_HS) || (rune_flag & TECH_TEIM))
				Sbar_DrawPic(v + '2 5 0', pic, ibar_alpha * 0.65, scale);
		}
		else
			pic = pic1;

		Sbar_DrawPic(v, pic, ibar_alpha * inv_alm, scale);
	}
};

void(vector valor, string pic1, float scale) DrawInventoryWeaponHip =
{
	string pic; pic = pic1;
	vector v; v = valor;
	v_y = v_y + weapons_offset;    
// code hasted weps - dbl image on active wep
	if ((rune_flag & RUNE_FLG_HS) || (rune_flag & TECH_TEIM))
		Sbar_DrawPic(v + '2 5 0', pic, ibar_alpha * 0.65, scale);

	Sbar_DrawPic(v, pic, ibar_alpha, scale);
};

void(vector valor, string pic, float transparencia, float scale) DrawInventoryAmmo =
{
	vector v;
	v = valor;
	v_y = v_y + weapons_offset;
	Sbar_DrawPic(v, pic, transparencia, scale);
}; 

// has_* - once a mapcode item is detected, this allows holstered view
float has_laser, has_prox;

void() Sbar_DrawInventory =
{

	ibar_alpha = cvar("sbar_alpha_fg");

	float ALPHA_FULL, ALPHA_MEDIUM, ALPHA_LOW;
		
	ALPHA_FULL = ibar_alpha;
	ALPHA_MEDIUM = ibar_alpha * 0.7;
	ALPHA_LOW = ibar_alpha * 0.4;

	float shells, rockets, nails, cells, explodeshot, explodsht_alp;
	vector pwr_step, wep_step;

	string wep_sg, wep_ssg, wep_nail, wep_snail, wep_gren, wep_rock, wep_light, wep_mj, wep_prox, wep_laser, wep_harp, wep_airgun;

	wep_sg = "gfx/inv2_shotgun";
	wep_ssg = "gfx/inv2_sshotgun";
	wep_nail = "gfx/inv2_nailgun";
	wep_snail = "gfx/inv2_snailgun";
	wep_gren = "gfx/inv2_rlaunch";
	wep_rock = "gfx/inv2_srlaunch";
	wep_light = "gfx/inv2_lightng";
	wep_mj = "gfx/inv2_mjolnir";
	wep_prox = "gfx/inv2_prox_gren";
	wep_laser = "gfx/inv2_laser";
	wep_harp = "gfx/inv2_harp";
	wep_airgun = "gfx/inv2_aircan";

	shells  = GetStat_FLOAT_TRUNCATED(STAT_SHELLS);
	nails   = GetStat_FLOAT_TRUNCATED(STAT_NAILS);
	rockets = GetStat_FLOAT_TRUNCATED(STAT_ROCKETS);
	cells   = GetStat_FLOAT_TRUNCATED(STAT_CELLS);

// Archon server
	mcode = GetStat_FLOAT_TRUNCATED(STAT_MCODE);
	rune_flag = GetStat_FLOAT_TRUNCATED(STAT_RUNEFLAG);

// pk
	pk_inv = GetStat_FLOAT_TRUNCATED(STAT_PKINV);
	pk_wep = GetStat_FLOAT_TRUNCATED(STAT_PKWEP);
	explodeshot = GetStat_FLOAT_TRUNCATED(STAT_EXPSHELL);
	explodsht_alp = ALPHA_LOW;
	if ((mcode == MC_SHOTGUN) || (mcode == MC_SUPER_SHOTGUN)) explodsht_alp = ALPHA_FULL;

	cl_items = GetStat_FLOAT_TRUNCATED(STAT_ITEMS);

	items = GetStat_BITS(STAT_ITEMS, 0, 23);
	items2 = GetStat_BITS(STAT_ITEMS, 23, 9);
	currentweap = GetStat_FLOAT_TRUNCATED(STAT_ACTIVEWEAPON);

// damage rune in effect
// code hot weps - images sbar didnt use in this set

	if ((rune_flag & RUNE_FLG_DM) || (rune_flag & TECH_AMP))
	{
		wep_sg = "gfx/inva2_shotgun";
		wep_ssg = "gfx/inva2_sshotgun";
		wep_nail = "gfx/inva2_nailgun";
		wep_snail = "gfx/inva2_snailgun";
		wep_gren = "gfx/inva2_rlaunch";
		wep_rock = "gfx/inva2_srlaunch";
		wep_light = "gfx/inva2_lightng";
		wep_mj = "gfx/inva2_mjolnir";
		wep_prox = "gfx/inva2_prox_gren";
		wep_laser = "gfx/inva2_laser";
		wep_harp = "gfx/inva2_harp";
		wep_airgun = "gfx/inva2_aircan";
	}

	if (! cl_items & IT_SUPER_NAILGUN) has_laser = FALSE;
	if (mcode == MC_HIP_LASERCAN) has_laser = TRUE;

	if (! cl_items & IT_GRENADE_LAUNCHER) has_prox = FALSE;
	if (mcode == MC_HIP_PROXGUN) has_prox = TRUE;

if (( ibar_flag == 1) || ( ibar_flag == 2)) // both
{
	weapons_offset = autocvar_hud_weapons_offset;

	sb_align = SB_BOTTOM;

// runes
	pwr_step = '-400 50 0';

	if (rune_flag & TECH_AMP)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_amp", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & TECH_TEIM)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_tiem", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & TECH_ADOC)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_adoc", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & TECH_DSH)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_dsh", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}

	if (rune_flag & RUNE_FLG_DM)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_dmg", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_FLG_HS)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_hst", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_FLG_RG)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_rgn", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_FLG_RS)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_res", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_VAMPIRE)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_vmp", ALPHA_FULL, 0.25);
		pwr_step_y = pwr_step_y + 30;
	}

}

if (0) // NOT using for now
if( ibar_flag == 1) // Smith's inventory layout 
{

// added 10 by default - always seem to need that in multi due to info_bar line being used for so much

	weapons_offset = autocvar_hud_weapons_offset - 2;
	if ( weapons_offset == -2 )
	{
		if (cvar("showfps"))	weapons_offset = weapons_offset + 12;
		if (cvar("showtime"))	weapons_offset = weapons_offset + 12;
		if (cvar("showdate"))	weapons_offset = weapons_offset + 12;
	}

sb_align = SB_BOTTOM;

	//DrawInventory('32 40', "gfx/sb_key1",   IT_KEY1, 0, ALPHA_FULL, 1);
	//DrawInventory('48 40', "gfx/sb_key2",   IT_KEY2, 0, ALPHA_FULL, 1);
	DrawInventory('64 40 0', "gfx/sb_invis",  IT_INVISIBILITY, 0, ALPHA_FULL, 1);
	DrawInventory('80 40 0', "gfx/sb_invuln", IT_INVULNERABILITY, 0, ALPHA_FULL, 1);
	DrawInventory('96 40 0', "gfx/sb_suit",   IT_SUIT, 0, ALPHA_FULL, 1);
	DrawInventory('112 40 0',"gfx/sb_quad",   IT_QUAD, 0, ALPHA_FULL, 1);

// IMP: needs detection
//	DrawInventory('128 40 0', "gfx/sb_eshld", 0, HIP_IT_EMPATY_SHIELD, ALPHA_FULL, 1);
//	DrawInventory('144 40 0',"gfx/sb_wsuit", 0, HIP_IT_WETSUIT, ALPHA_FULL, 1);

	DrawInventory('128 40 0', "gfx/sb_sigil1", 0, 32, ALPHA_MEDIUM, 1);
	DrawInventory('136 40 0', "gfx/sb_sigil2", 0, 64, ALPHA_MEDIUM, 1);
	DrawInventory('144 40 0', "gfx/sb_sigil3", 0, 128, ALPHA_MEDIUM, 1);
	DrawInventory('152 40 0', "gfx/sb_sigil4", 0, 256, ALPHA_MEDIUM, 1);

sb_align = SB_BOTTOM_RIGHT;

//position and size of ibar items
	DrawInventoryWeapon('272 40 0', "gfx/inv_shotgun",  wep_sg,  IT_SHOTGUN, 1, 0);
	DrawInventoryWeapon('296 40 0', "gfx/inv_sshotgun", wep_ssg, IT_SUPER_SHOTGUN, 1, 0);
	DrawInventoryWeapon('272 68 0', "gfx/inv_nailgun",  wep_nail,  IT_NAILGUN, 1, 0);

// Cataboligne - 9.9.13 - had to change, these had issues because Archon code is different on extra weps
// IMP: inventory detection of all weps, active and stored

	if (has_laser)
		DrawInventoryWeapon('272 130 0', "gfx/inv_laser", wep_laser, IT_SUPER_NAILGUN, 0.125, 0);
	else
		DrawInventoryWeapon('296 68 0', "gfx/inv_snailgun", wep_snail, IT_SUPER_NAILGUN, 1, 0);

	if (has_prox)
		DrawInventoryWeapon('272 96 0', "gfx/inv_prox_gren",  wep_prox,  IT_GRENADE_LAUNCHER, 0.125, 0);
	else
		DrawInventoryWeapon('272 96 0', "gfx/inv_rlaunch",  wep_gren,  IT_GRENADE_LAUNCHER, 1, 0);

/*
	if (cl_items & IT_LASER_CANNON)
	{ 
	if (currentweap == IT_LASER_CANNON) 
		DrawInventoryWeaponHip('272 140 0', wep_laser);

	else if (currentweap != IT_LASER_CANNON) 
		DrawInventoryWeaponHip('272 140 0', "gfx/inv_laser");
	}

	if((currentweap == IT_PROXIMITY_GUN) || (currentweap == IT_GRENADE_LAUNCHER))
	{
		if (currentweap == IT_PROXIMITY_GUN) 
		DrawInventoryWeaponHip('272 96 0', wep_prox);

		else if (currentweap == IT_GRENADE_LAUNCHER) 
		DrawInventoryWeaponHip('272 96 0', wep_gren);
	}
	else if((cl_items & IT_PROXIMITY_GUN) || (cl_items & IT_GRENADE_LAUNCHER))
	{
		if (cl_items & IT_PROXIMITY_GUN) 
		DrawInventoryWeaponHip('272 96 0', "gfx/inv_prox");

		else if(cl_items & IT_GRENADE_LAUNCHER) 
		DrawInventoryWeaponHip('272 96 0', "gfx/inv_rlaunch");
	}
*/

	DrawInventoryWeapon('296 96 0', "gfx/inv_srlaunch", wep_rock, IT_ROCKET_LAUNCHER, 1, 0);

	if (has_chainth)
		DrawInventoryWeapon('272 124 0',"gfx/inv_lightng",  wep_light,  IT_LIGHTNING, 1, 0);
	else
		DrawInventoryWeapon('272 124 0',"gfx/inv_lightng",  wep_light,  IT_LIGHTNING, 1, 0);

//	if (mcode == MC_HIP_MJOLNIR) // exclude non mjolnir items that use IT_MJOLNIR bit == 128
	DrawInventoryWeapon('272 140 0', "gfx/inv_mjolnir",  wep_mj,  IT_MJOLNIR, 0.125, 0);

	//for 4 small ammo icon positions
	DrawInventoryAmmo('308 24 0', "gfx/sb_shells", ALPHA_FULL, 0.5);  
	DrawInventoryAmmo('308 52 0', "gfx/sb_nails", ALPHA_FULL, 0.5);
	DrawInventoryAmmo('308 80 0', "gfx/sb_rocket", ALPHA_FULL, 0.5);
	DrawInventoryAmmo('308 108 0',"gfx/sb_cells", ALPHA_FULL, 0.5);

	if (explodeshot > 0)
	{
		DrawInventoryAmmo('268 24 0', "gfx/sb_xpshells", explodsht_alp, 0.125);  
		DrawAmmo('244 20 0', explodeshot, explodsht_alp);
	}

//highlight of current weapon ammo counter + position of ammo counters
	if (cl_items & IT_SHELLS)
	{
		DrawAmmo('284 20 0', shells, ALPHA_FULL);
		DrawAmmo('284 48 0', nails, ALPHA_MEDIUM);
		DrawAmmo('284 76 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('284 104 0', cells, ALPHA_MEDIUM);
	}	
	else if (cl_items & IT_NAILS)
	{
		DrawAmmo('284 20 0', shells, ALPHA_MEDIUM);
		DrawAmmo('284 48 0', nails, ALPHA_FULL);
		DrawAmmo('284 76 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('284 104 0', cells, ALPHA_MEDIUM);
	}
		else if (cl_items & IT_ROCKETS)
	{
		DrawAmmo('284 20 0', shells, ALPHA_MEDIUM);
		DrawAmmo('284 48 0', nails, ALPHA_MEDIUM);
		DrawAmmo('284 76 0', rockets, ALPHA_FULL);
		DrawAmmo('284 104 0', cells, ALPHA_MEDIUM);
	}
		else if (cl_items & IT_CELLS)
	{
		DrawAmmo('284 20 0', shells, ALPHA_MEDIUM);
		DrawAmmo('284 48 0', nails, ALPHA_MEDIUM);
		DrawAmmo('284 76 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('284 104 0', cells, ALPHA_FULL);
	}		
	if (cl_items & IT_AXE)// a strange dummy, but work´s fine!
	{
		if (cl_items & IT_SHELLS)	return;
		if (cl_items & IT_NAILS) 	return;
		if (cl_items & IT_ROCKETS) 	return;
		if (cl_items & IT_CELLS) 	return;
		DrawAmmo('284 20 0', shells, ALPHA_MEDIUM);
		DrawAmmo('284 48 0', nails, ALPHA_MEDIUM);
		DrawAmmo('284 76 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('284 104 0', cells, ALPHA_MEDIUM);
	}
}

if (ibar_flag)
//if ( ibar_flag == 2 ) // Nahuel's inventory layout
{
	weapons_offset = autocvar_hud_weapons_offset;

sb_align = SB_BOTTOM;

	DrawInventory('40 48 0', "gfx/sb_invis",  IT_INVISIBILITY, 0, ALPHA_LOW, 1.5);
	DrawInventory('60 48 0', "gfx/sb_invuln", IT_INVULNERABILITY, 0, ALPHA_MEDIUM, 1.5);
	DrawInventory('80 48 0', "gfx/sb_suit",   IT_SUIT, 0, ALPHA_MEDIUM, 1.5);
	DrawInventory('100 48 0',"gfx/sb_quad",   IT_QUAD, 0, ALPHA_FULL, 1.5);

// IMP: needs detection
//	DrawInventory('120 48 0', "gfx/sb_eshld", 0, HIP_IT_EMPATY_SHIELD, ALPHA_FULL, 1.5);
//	DrawInventory('140 48 0', "gfx/sb_wsuit", 0, HIP_IT_WETSUIT, ALPHA_FULL, 1.5);

	DrawInventory('170 48 0', "gfx/sb_sigil1", 0, 32, ALPHA_MEDIUM, 1.5);
	DrawInventory('190 48 0', "gfx/sb_sigil2", 0, 64, ALPHA_MEDIUM, 1.5);
	DrawInventory('210 48 0', "gfx/sb_sigil3", 0, 128, ALPHA_MEDIUM, 1.5);
	DrawInventory('230 48 0', "gfx/sb_sigil4", 0, 256, ALPHA_MEDIUM, 1.5);

sb_align = SB_BOTTOM_RIGHT;

//position and size of ibar items

// std inventory will maintain a 20 unit step, blocked, new inventory will increment where needed
// some items are on position swap out - laser for sng, etc.
	wep_step = '290 140 0';

//	if (mcode == MC_HIP_MJOLNIR) // exclude non mjolnir items that use IT_MJOLNIR bit == 128
	DrawInventoryWeapon(wep_step, "gfx/inv_mjolnir",  wep_mj,  IT_MJOLNIR, 0.125, 0);
	if (cl_items & IT_MJOLNIR) wep_step = wep_step + '0 20 0';

	DrawInventoryWeapon(wep_step, "gfx/inv_harp", wep_harp,  PK_IT_GRAPGUN, 0.125, STAT_PKWEP);
	if (pk_inv & PK_IT_GRAPGUN) wep_step = wep_step + '0 20 0';

	DrawInventoryWeapon(wep_step, "gfx/inv_shotgun",  wep_sg,  IT_SHOTGUN, 1, 0);

	DrawInventoryWeapon(wep_step + '0 20 0', "gfx/inv_aircan", wep_airgun,  PK_IT_AIRGUN, 0.125, STAT_PKWEP);
	if (pk_inv & PK_IT_AIRGUN) wep_step = wep_step + '0 20 0';

	DrawInventoryWeapon(wep_step + '0 20 0', "gfx/inv_sshotgun", wep_ssg, IT_SUPER_SHOTGUN, 1, 0);
	DrawInventoryWeapon(wep_step + '0 40 0', "gfx/inv_nailgun",  wep_nail,  IT_NAILGUN, 1, 0);

// Cataboligne - 9.9.13 - had to change, these had issues because Archon code is different on extra weps

	if (has_laser)
		DrawInventoryWeapon(wep_step + '0 140 0', "gfx/inv_laser", wep_laser, IT_SUPER_NAILGUN, 0.125, 0);
	else
		DrawInventoryWeapon(wep_step + '0 60 0', "gfx/inv_snailgun", wep_snail, IT_SUPER_NAILGUN, 1, 0);

	if (has_prox)
		DrawInventoryWeapon(wep_step + '0 80 0', "gfx/inv_prox_gren",  wep_prox,  IT_GRENADE_LAUNCHER, 0.125, 0);
	else
		DrawInventoryWeapon(wep_step + '0 80 0', "gfx/inv_rlaunch",  wep_gren,  IT_GRENADE_LAUNCHER, 1, 0);

	DrawInventoryWeapon(wep_step + '0 100 0', "gfx/inv_srlaunch", wep_rock, IT_ROCKET_LAUNCHER, 1, 0);

	if (has_chainth)
		DrawInventoryWeapon(wep_step + '-24 120 0', "gfx/inv_lightng",  wep_light,  PK_IT_CLIGHT, 1, STAT_PKWEP);
	else
		DrawInventoryWeapon(wep_step + '-24 120 0', "gfx/inv_lightng",  wep_light,  IT_LIGHTNING, 1, 0);
	
	// for 4 small ammo icon positions
	DrawInventoryAmmo('302 50 0', "gfx/sb_shells", ALPHA_FULL, 0.5);  
	DrawInventoryAmmo('302 70 0', "gfx/sb_nails", ALPHA_FULL, 0.5);
	DrawInventoryAmmo('302 90 0', "gfx/sb_rocket", ALPHA_FULL, 0.5);
	DrawInventoryAmmo('302 110 0',"gfx/sb_cells", ALPHA_FULL, 0.5);

	if (explodeshot > 0)
	{
		DrawInventoryAmmo('302 30 0', "gfx/sb_xpshells", explodsht_alp, 0.125);  
		DrawAmmo('280 25 0', explodeshot, explodsht_alp);
	}

//highlight of current weapon ammo counter + position of ammo counters
	if (cl_items & IT_SHELLS)
	{
		DrawAmmo('280 45 0', shells, ALPHA_FULL);
		DrawAmmo('280 65 0', nails, ALPHA_MEDIUM);
		DrawAmmo('280 85 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('280 105 0', cells, ALPHA_MEDIUM);
	}	
	else if (cl_items & IT_NAILS)
	{
		DrawAmmo('280 45 0', shells, ALPHA_MEDIUM);
		DrawAmmo('280 65 0', nails, ALPHA_FULL);
		DrawAmmo('280 85 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('280 105 0', cells, ALPHA_MEDIUM);
	}
		else if (cl_items & IT_ROCKETS)
	{
		DrawAmmo('280 45 0', shells, ALPHA_MEDIUM);
		DrawAmmo('280 65 0', nails, ALPHA_MEDIUM);
		DrawAmmo('280 85 0', rockets, ALPHA_FULL);
		DrawAmmo('280 105 0', cells, ALPHA_MEDIUM);
	}
		else if (cl_items & IT_CELLS)
	{
		DrawAmmo('280 45 0', shells, ALPHA_MEDIUM);
		DrawAmmo('280 65 0', nails, ALPHA_MEDIUM);
		DrawAmmo('280 85 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('280 105 0', cells, ALPHA_FULL);
	}		
	if (cl_items & IT_AXE)// a strange dummy, but work´s fine!
	{
		if (cl_items & IT_SHELLS)	return;
		if (cl_items & IT_NAILS) 	return;
		if (cl_items & IT_ROCKETS) 	return;
		if (cl_items & IT_CELLS) 	return;
		DrawAmmo('280 45 0', shells, ALPHA_MEDIUM);
		DrawAmmo('280 65 0', nails, ALPHA_MEDIUM);
		DrawAmmo('280 85 0', rockets, ALPHA_MEDIUM);
		DrawAmmo('280 105 0', cells, ALPHA_MEDIUM);
	}
}
};
