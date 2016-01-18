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
	enginebar = 1;
	if((cvar("viewsize") >= 115) && (cvar("viewsize") <= 119))
		{
			compass = 1;
			ibar_flag = cvar("viewsize") - 114;
			if (ibar_flag == 0 ) ibar = 0;
			else ibar = 1;
			if (ibar_flag == 3 ) enginebar = 0;
			cvar_set("viewsize", "110");
		}
	else if((cvar("viewsize") >= 110) && (cvar("viewsize") <= 114))
		{
			compass = 0;
			ibar_flag = cvar("viewsize") - 110;
			if (ibar_flag == 0 ) ibar = 0;
			else ibar = 1;
			if (ibar_flag == 3 ) enginebar = 0;
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
		if(compass == 1) cvar_set("viewsize", ftos(110 + ibar_flag + 5));
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
// monster names
//-----------------------------------------------------------------------------

string(float mb) monster_id =
{
	local string s2;

	s2 = "";

	if (mb == CB_M_ARMY) 			s2 = "Army Grunt";
	if (mb == CB_M_FISH) 			s2 = "Fish";
	if (mb == CB_M_KNIGHT) 			s2 = "Knight";
	if (mb == CB_M_DOG) 				s2 = "Rabid Dog";
	if (mb == CB_M_DEMON) 			s2 = "Fiend";
	if (mb == CB_M_ENF) 				s2 = "Enforcer";
	if (mb == CB_M_HKNIGHT) 		s2 = "Hell Knight";
	if (mb == CB_M_OGRE) 			s2 = "Ogre";
	if (mb == CB_M_SHALR) 			s2 = "Shalrath";
	if (mb == CB_M_SHAMBL) 			s2 = "Shambler";
	if (mb == CB_M_SCRAG) 			s2 = "Scragg";
	if (mb == CB_M_ZOMBY) 			s2 = "Zomby";
	if (mb == CB_M_CTHON) 			s2 = "Cthon";
	if (mb == CB_M_TARBABY) 		s2 = "Spawn";
	if (mb == CB_M_SCOURGE) 		s2 = "Scourge";
	if (mb == CB_M_SHUBS) 			s2 = "Shub Niggurath";
	if (mb == CB_M_SVORE) 			s2 = "Vorerel";
	if (mb == CB_M_GREMLIN) 		s2 = "Gremlin";
	if (mb == CB_M_VOMIT) 			s2 = "Vomitus";
	if (mb == CB_M_SPIKEMINE) 		s2 = "Spike Mine";

	return(s2);
};

//-----------------------------------------------------------------------------
// Sbar_DrawInventory
//-----------------------------------------------------------------------------

float items, items2, currentweap, mcode, archon;
float rune_flag, dmg_flare;
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
	vector v, y;
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

// these are silly, but pk code does not clear inventory on switching to a non pk wep
		if ((pk_wep == PK_IT_AIRGUN) && (mcode != MC_AIRGUN)) draw = FALSE;
		if ((pk_wep == PK_IT_CLIGHT) && (mcode != MC_CHTHUNDR)) draw = FALSE;
		if ((pk_wep == PK_IT_GRAPGUN) && (mcode != MC_GRAP) && (mcode != MC_HOOK)) draw = FALSE;
	}

	if (has)
	{
      v = valor;
		v_y = v_y + weapons_offset;    
		if (draw)
		{
			pic = pic2;
			inv_alm = 1;
// dang hacks
			if (pic1 == "gfx/inv_lightng") y = '24 0 0';
// code damage weps - color change &| dmg_flare
			if (dmg_flare > 1)
				Sbar_DrawPic(v + y, "gfx/dmg_flare2", ibar_alpha, 0.125); // NOTE: scale deal
			if (dmg_flare)
				Sbar_DrawPic(v + y, "gfx/dmg_flare", ibar_alpha, 0.125);
			else
				Sbar_DrawPic(v + y + '3 -16 0', "gfx/spell_bar", ibar_alpha, 0.5);

// code hasted weps - dbl shadow image on active wep
			if ((rune_flag & RUNE_FLG_HS) || (rune_flag & TECH_TEIM))
				Sbar_DrawPic(v + '2 5 0', pic, ibar_alpha * 0.45, scale);
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

// scale power bar for console display

// pow - power level for bar indicator or sub level
// return:
// scl - the scaled value so bar will fit on screen

// scale chart																											1 unit =
// 0 - 100						- full scale, up to 100 screen units						1
// 101 - 5000				- 4900 scaled into 101 - 360 screen uinits			0.053
// 5001 - 60000+	- 55000 scaled into 361 - 480									0.00218
// max bar position capped at 480

float(float pow) bar_scale =
{
	local float scl;

	scl = pow;

	if (pow > 5000)
		scl = 360 + ((pow - 5000) / 55000) * 120;
	else if (pow > 100)
		scl = 100 + ((pow - 100) / 4900) * 260;

	if (scl > 480) scl = 480;
	
	return(scl);
}
// has_* - once a mapcode item is detected, this allows holstered view
float has_laser, has_prox, has_pnail, has_hook, has_flamer1, has_deepsleep, has_ppoint, cnt_left, explflg;

void() Sbar_DrawInventory =
{

	ibar_alpha = cvar("sbar_alpha_fg");

	float ALPHA_FULL, ALPHA_MEDIUM, ALPHA_LOW, ALPHA_90, p_alph;

	ALPHA_FULL = ibar_alpha;
	ALPHA_MEDIUM = ibar_alpha * 0.7;
	ALPHA_90 = ibar_alpha * 0.9;
	ALPHA_LOW = ibar_alpha * 0.4;

	float k, shells, rockets, nails, cells, health, armorval, explodeshot, explodsht_alp, inv_alm, slugs, bullets, gas, volspec, plevel, archon_magic, morph;
	float pk_gwell, pk_tur, pk_bt, pk_copb, pk_tomb, pk_ego, pk_mask, pk_phone;
	vector pwr_step, wep_step, wep_axlv, arc_level, chaos_level, p_level, woff;

	string wep_sg, wep_ssg, wep_nail, wep_snail, wep_gren, wep_rock, wep_light, wep_mj, wep_prox, wep_laser, wep_harp, wep_airgun, wep_clg, wep_axe, wep_pnail;
	string target1, target2, instr;

// active (drawn in hand) weapon icons
	wep_axe = "gfx/inv2_axe";
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
	wep_clg = "gfx/inv2_clg";
	wep_pnail = "gfx/inv2_pnail";

// get data from server

	shells  = GetStat_FLOAT_TRUNCATED(STAT_SHELLS);
	nails   = GetStat_FLOAT_TRUNCATED(STAT_NAILS);
	rockets = GetStat_FLOAT_TRUNCATED(STAT_ROCKETS);
	cells   = GetStat_FLOAT_TRUNCATED(STAT_CELLS);

	health = GetStat_FLOAT_TRUNCATED(STAT_HEALTH);
	armorval = GetStat_FLOAT_TRUNCATED(STAT_ARMOR);

// Archon data
	archon = GetStat_FLOAT_TRUNCATED(STAT_ARCHON);
	morph = GetStat_FLOAT_TRUNCATED(STAT_MORPH);
	mcode = GetStat_FLOAT_TRUNCATED(STAT_MCODE);
	rune_flag = GetStat_FLOAT_TRUNCATED(STAT_RUNEFLAG);

	volspec = GetStat_FLOAT_TRUNCATED(STAT_VOL);
	target1 = GetStat_STRING(STAT_STK1);
	target2 = GetStat_STRING(STAT_STK2);

// pk data
	pk_inv = GetStat_FLOAT_TRUNCATED(STAT_PKINV);
	pk_wep = GetStat_FLOAT_TRUNCATED(STAT_PKWEP);
	explodeshot = GetStat_FLOAT_TRUNCATED(STAT_EXPSHELL);
	explodsht_alp = ALPHA_LOW;
	if ((mcode == MC_SHOTGUN) || (mcode == MC_SUPER_SHOTGUN)) explodsht_alp = ALPHA_FULL;

	pk_gwell = GetStat_FLOAT_TRUNCATED(STAT_PKGWELL);
	pk_tur = GetStat_FLOAT_TRUNCATED(STAT_PKTURR);
	pk_bt = GetStat_FLOAT_TRUNCATED(STAT_PKBT);
	pk_copb = GetStat_FLOAT_TRUNCATED(STAT_PKCOPB);
	pk_tomb = GetStat_FLOAT_TRUNCATED(STAT_PKTOMB);
	pk_ego = GetStat_FLOAT_TRUNCATED(STAT_PKEGO);
	pk_mask = GetStat_FLOAT_TRUNCATED(STAT_PKMASK);
	pk_phone = GetStat_FLOAT_TRUNCATED(STAT_PKPH);

// enhanced data
	bullets = GetStat_FLOAT_TRUNCATED(STAT_AMBUL);
	slugs = GetStat_FLOAT_TRUNCATED(STAT_AMSLUG);
	gas = GetStat_FLOAT_TRUNCATED(STAT_AMGAS);

	cl_items = GetStat_FLOAT_TRUNCATED(STAT_ITEMS);

	items = GetStat_BITS(STAT_ITEMS, 0, 23);
	items2 = GetStat_BITS(STAT_ITEMS, 23, 9);
	currentweap = GetStat_FLOAT_TRUNCATED(STAT_ACTIVEWEAPON);
// end data

// damage addative in effect for drawn weapon
// code hot weps - images sbar didnt use in this set and dmg_flare gfx

	dmg_flare = 0;
	if (rune_flag & RUNE_FLG_DM) dmg_flare = 1;
	if (rune_flag & TECH_AMP) dmg_flare = dmg_flare + 1;
	if (cl_items & IT_QUAD) dmg_flare = dmg_flare + 1;
	if (dmg_flare)
	{
		wep_sg = "gfx/inva2_shotgun";
		wep_ssg = "gfx/inva2_sshotgun";
		wep_nail = "gfx/inva2_nailgun";
		wep_snail = "gfx/inva2_snailgun";
		wep_gren = "gfx/inva2_rlaunch";
		wep_rock = "gfx/inva2_srlaunch";
		wep_light = "gfx/inva2_lightng";
		wep_laser = "gfx/inva2_laser";
	}

// things detected by mapcode and stored in global - need global turned off when wep goes away, like with death

	if (! cl_items & IT_NAILGUN) has_pnail = FALSE;
	if (mcode == MC_PULSE_NAILGUN) has_pnail = TRUE;

	if (! cl_items & IT_SUPER_NAILGUN) has_laser = FALSE;
	if (mcode == MC_HIP_LASERCAN) has_laser = TRUE;

	if (! cl_items & IT_GRENADE_LAUNCHER)
	{
		has_prox = FALSE;
		has_flamer1 = FALSE;
	}
	if (mcode == MC_HIP_PROXGUN) has_prox = TRUE;
	if (mcode == MC_C_FLAMER) has_flamer1 = TRUE;

	has_deepsleep = FALSE;
	if (mcode == MC_DEEPSLEEP) has_deepsleep = TRUE;

	if (! pk_inv & PK_IT_GRAPGUN) has_hook = FALSE;
	if (mcode == MC_HOOK) has_hook = TRUE;


if (ibar_flag)
{
	weapons_offset = autocvar_hud_weapons_offset;

	if (!enginebar) weapons_offset = weapons_offset - 12;
	woff = '0 0 0';
	woff_y = weapons_offset;

sb_align = SB_BOTTOM; ///NOTE: should this be alignt left ?

/// Archon power bars

//note vid_conheight and vid_conwidth are very important for this - they need consulted or set

//	if (mcode == -665) archon_magic = 2; // using magic from archon pts - for now we use (-) volume
	if (mcode == -666) archon_magic = 1; // chaos archon
	if (mcode == -667) archon_magic = 1; // order archon - for diff color bars

	if (archon_magic)
	if (explodeshot > 0)
		plevel = archon - explodeshot; // archon magic cost
	if (volspec < 0) plevel = archon - fabs(volspec); // morph cube cost or power shots
	if (plevel < 0) plevel = 0; // IMP: warn on - result - red # or such

// IMP: diff colors for archons themselves, 
//shows spell usage at top of bar (reduction amount)

// scale chaos level bar
	chaos_level = '-412 0 0';
	chaos_level_y = bar_scale(volspec);
	
// scale archon level bar
	arc_level = '-412 0 0';
	arc_level_y = bar_scale(archon);

// scale plevel result mark
	p_level = '-412 0 0';
	p_level_y = bar_scale(plevel);

	if (archon > 0)
	if (chaos_level_y < arc_level_y + 4)
		chaos_level_x = -409; // move over for second bar

	p_alph = ALPHA_FULL;
	if (plevel > 0) p_alph = ibar_alpha * 0.35; // shade spell cost portion

	if (archon_magic == 1)
	if (volspec > 0)
		Sbar_DrawPic(chaos_level, "gfx/inv_chaos_bar", p_alph * 0.8, 1); // chaos / order power

	if (archon > 0)
	{
		Sbar_DrawPic(arc_level, "gfx/inv_archon_bar", p_alph, 1);
		if  (arc_level_y < 4) arc_level_y = 3;
		DrawAmmo(arc_level + '20 5 0' - woff, archon, ALPHA_FULL);

		k = arc_level_y;
		if (archon_magic || (volspec < 0))
		if (plevel > 0)
		{
// make sure we have a visible usage amt at high archon levels where scale is minimal for small amts
			if (arc_level_y > 100)
			if ((arc_level_y - p_level_y) < 4) p_level_y = arc_level_y - 3;
			Sbar_DrawPic(p_level, "gfx/inv_archon_bar", ALPHA_FULL, 1);
// tic line for usage
			if (p_level_y < 1) p_level_y = 1;
			Sbar_DrawPic(p_level + '6 0 0', "gfx/spell_bar", ALPHA_FULL, 0.5);

//			if  (plevel < 10) p_level_y = p_level_y + 10 - plevel;
			if ((p_level_y < 7) && (arc_level_y > 10)) p_level_y = 7; // hold text amt here if poss.
			if (p_level_y > 6) DrawAmmo(p_level + '20 0 0' - woff, plevel, ALPHA_FULL);
			k = p_level_y;
		}
	}

	if (chaos_level_y > 0) // c/o power numeric
	{
		if (archon > 0)
		{
			if (chaos_level_y < k + 4) chaos_level_x = -409;
			if ((chaos_level_y >= (k - 14)) && (chaos_level_y <= (arc_level_y+ 8))) // dont over write archon pts - hold till passed
				chaos_level_y = k - 14;
			if (chaos_level_y < 7) chaos_level_y = arc_level_y + 9; // put above if arc level would lower off HUD
		}

		if  (volspec > 0)
			Sbar_DrawString(chaos_level + '20 5 0', ftos(volspec), ALPHA_FULL, '7 7 0','1 0.5 1');
	}

/// morph cube status here


/// runes area left
	pwr_step = '-400 50 0';

/*
// test to find lowest val in left draw coords

	DrawAmmo('-300 100 0', chaos_level_y, ALPHA_FULL);
	DrawAmmo('-300 80 0', p_level_y, ALPHA_FULL);
	DrawAmmo('-300 60 0', arc_level_y, ALPHA_FULL);
	DrawAmmo('-300 40 0', cnt_left, ALPHA_FULL);
*/

// move runes over for low range digit display
	cnt_left = cnt_left + woff_y;

	if ((archon > 0) && (arc_level_y < cnt_left + 2))
		pwr_step = '-370 50 0';
	if ((plevel > 0) && (p_level_y < cnt_left + 6))
		pwr_step = '-370 50 0';
	if ((volspec > 0) && (chaos_level_y < cnt_left + 2))
		pwr_step = '-370 50 0';

	cnt_left = 0; // recount every time

// armor, health in bar 2, 3
// keys, artifacts in bar 3


	wep_step = '55 -10 0'; // morph ID's
	if (health > 999) wep_step = '65 -10 0';
	if (ibar_flag == 1) wep_step = '35 -10 0';
	if (ibar_flag > 2)
	{
		wep_step = '30 -27 0';
		DrawInventory(pwr_step + '10 -15 0' + woff, "gfx/sb_key1", IT_KEY1, 0, ALPHA_FULL, 1.4);
		DrawInventory(pwr_step + '0 -15 0' + woff, "gfx/sb_key2",IT_KEY2 , 0, ALPHA_FULL, 1.4);
		if (cl_items & (IT_KEY1 | IT_KEY2)) pwr_step_y = pwr_step_y + 4;
	}

/// morph ident and weapon / spell description and special status items

	if (ibar_flag)
	{
		if (morph == CHAR_Q)
			Sbar_DrawString(pwr_step + wep_step + woff, "Marine", ALPHA_FULL, '7 7 0','0.5 0.7 1');
		else if (morph == CHAR_D)
			Sbar_DrawString(pwr_step + wep_step + woff, "UAC Marine", ALPHA_FULL, '7 7 0','0.16 0.2 0.29');
		else if (morph == CHAR_Q2)
			Sbar_DrawString(pwr_step + wep_step + woff, "Space Marine", ALPHA_FULL, '7 7 0','0.5 0.7 1');
		else if (morph == CHAR_Q3)
			Sbar_DrawString(pwr_step + wep_step + woff, "Sarge", ALPHA_FULL, '7 7 0','0.5 0.7 1');
		else if (morph == CHAR_PK)
			Sbar_DrawString(pwr_step + wep_step + woff, "Pain Killer", ALPHA_FULL, '7 7 0','0.2 0.2 1');
		else if (morph == CHAR_W)
			Sbar_DrawString(pwr_step + wep_step + woff, "Blaskowitz", ALPHA_FULL, '7 7 0','0.7 0.7 0.7');
		else if (morph == IMP_MENF)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Enforcer", ALPHA_FULL, '7 7 0','0.5 0.7 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '60 0 0', "| Laser bolt", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MOGRE)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Ogre", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Chainsaw", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_GRENADE_LAUNCHER)
				Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Grenades", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_ROCKET_LAUNCHER)
				Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Cluster Grenades", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MHKNIGHT)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Hell Knight", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '80 0 0', "| Sword", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '80 0 0', "| Magic spikes", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SUPER_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '80 0 0', "| Focused spikes", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_ROCKET_LAUNCHER)
				Sbar_DrawString(pwr_step + wep_step + woff + '80 0 0', "| Explosive spikes *", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MSHALR)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Vore", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
			{
				if (mcode == -505)
					Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Spike Bomb -->", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				else if (volspec == -1000)
				{
					Sbar_DrawString(pwr_step + wep_step + woff + '34 9 0', "| FIRE - summon *", ALPHA_FULL, '7 7 0','1 0.5 0.5');
					Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Sphere of Annihilation", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				}
				else
				{
					if (mcode == -500)
					{
						Sbar_DrawString(pwr_step + wep_step + woff + '34 9 0', "| ALT_FIRE - take control", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Sphere of Annihilation - not following", ALPHA_FULL, '7 7 0','1 0.5 0.5');
					}
					else if (mcode == -504)
						Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Sphere of Annihilation - out of range", ALPHA_FULL, '7 7 0','1 0.5 0.5');
					else
					{
						if (mcode == -501)
							Sbar_DrawString(pwr_step + wep_step + woff + '34 9 0', "| Mouse wheel - height adjust", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						else if (mcode == -502)
							Sbar_DrawString(pwr_step + wep_step + woff + '34 9 0', "| Mouse wheel - bearing adjust", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						Sbar_DrawString(pwr_step + wep_step + woff + '34 27 0', "| FIRE - banish *", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						Sbar_DrawString(pwr_step + wep_step + woff + '34 18 0', "| ALT_FIRE / M3 - change control mode", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Sphere of Annihilation - following", ALPHA_FULL, '7 7 0','1 0.5 0.5');
					}
				}
			}
			if (currentweap == IT_LIGHTNING)
				Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Lightning", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SUPER_NAILGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Magic spikes", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_ROCKET_LAUNCHER)
				Sbar_DrawString(pwr_step + wep_step + woff + '34 0 0', "| Spike Bomb", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MSHAMBLR)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Shambler", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '60 0 0', "| Claws", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_LIGHTNING)
				Sbar_DrawString(pwr_step + wep_step + woff + '60 0 0', "| Lightning", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MDEMON)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Fiend", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Hack & Slash", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Head spike", ALPHA_FULL, '7 7 0','1 0.5 0.5');
// demon rage explosion
			if (explodeshot == -501)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  Pentagram power surges beyond rage", ALPHA_FULL, '7 7 0','1 0.2 0.2');
			else if (explodeshot == -505)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  Not enough Archon power for RAGE", ALPHA_FULL, '7 7 0','1 0.2 0.2');
			else if (explodeshot == -506)
			{
				Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  Runes failed your RAGE", ALPHA_FULL, '7 7 0','1 0.2 0.2');
				explflg = 0;
			}
			else if (explodeshot == -504)
			{
				Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  B--O--O--M", ALPHA_FULL, '7 7 0','1 0.1 0.1');
				explflg = 0;
			}
			if (currentweap == IT_GRENADE_LAUNCHER)
			{
				if (explodeshot > 0 || explflg)
				{
					explflg = 1;
					Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| RAGE - Gonna pop in      or less", ALPHA_FULL, '7 7 0','1 0.1 0.1');
					if (explodeshot > 0)
						Sbar_DrawString(pwr_step + wep_step + woff + '200 0 0', ftos(explodeshot), ALPHA_FULL, '7 7 0','1 0.1 0.1');
					else
						Sbar_DrawString(pwr_step + wep_step + woff + '200 0 0', "**", ALPHA_FULL, '7 7 0','0 0 0');

					if (explodeshot < 5)
					{
						if (cl_items & IT_INVULNERABILITY)
							Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  Everyone will be blown straight to HELL!", ALPHA_FULL, '7 7 0','1 0.2 0.2');
						else if (rune_flag & (RUNE_FLG_HS |TECH_TEIM))
							Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  Hurry", ALPHA_FULL, '7 7 0','1 0.2 0.2');
					}
				}
				else
				{
					if (explodeshot == -502)
						Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  * - you will lose runes of power", ALPHA_FULL, '7 7 0','1 0.2 0.2');
					if (explodeshot == -503)
						Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  RAGE has overcome you...\n", ALPHA_FULL, '7 7 0','1 0.1 0.1');
					if (cl_items & IT_INVULNERABILITY)
						Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Fiendish onslaught of DOOM!", ALPHA_FULL, '7 7 0','1 0.1 0.1');
					else
						Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| RAGE", ALPHA_FULL, '7 7 0','1 0.1 0.1');
				}
			}
		}
		else if (morph == IMP_MWIZARD)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Scrag", ALPHA_FULL, '7 7 0','0 0.8 0');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Pain field", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Acid Spikes", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SUPER_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Focused spikes", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_ROCKET_LAUNCHER)
				Sbar_DrawString(pwr_step + wep_step + woff + '40 0 0', "| Explosive spikes *", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MZOMBIE)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Zomby", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '41 0 0', "| Stench cloud", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '41 0 0', "| Rotten flesh", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SUPER_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '41 0 0', "| Plague flesh", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_NAILGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '41 0 0', "| Gib fountain", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MCTHON)
		{
			if (mcode == -503 || mcode == -502 || mcode == -501)
			{
				Sbar_DrawString(pwr_step + wep_step + woff, "Cthon", ALPHA_FULL, '7 7 0','1 0.2 0');
				Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  ALT_FIRE - return to Lava Bomb", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				if (mcode == -502)
				{
					if (random() < 0.03) explflg = 1;
					if (explflg)
						Sbar_DrawString(pwr_step + wep_step + woff + '40 18 0',   "HURRY!  Hit ALT_FIRE now or find more Lava fast!", ALPHA_FULL, '7 7 0','1 0.5 0.5');
					else
						Sbar_DrawString(pwr_step + wep_step + woff + '40 18 0',   "HURRY!  Find more Lava fast!", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				}
				if (mcode == -501)
					Sbar_DrawString(pwr_step + wep_step + woff + '40 9 0', "  Cthon cannot exist away from Lava", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			}
			else
			{
				explflg = 0;
				Sbar_DrawString(pwr_step + wep_step + woff, "Lava Bomb", ALPHA_FULL, '7 7 0','1 0.2 0');
				if (mcode == -504) // in lava code
					Sbar_DrawString(pwr_step + wep_step + woff + '66 9 0', "| ALT_FIRE - become Cthon !", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				if (currentweap == IT_AXE)
				if (pk_wep == PK_IT_AXE)
					Sbar_DrawString(pwr_step + wep_step + woff + '66 0 0', "| Lava balls", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				if (currentweap == IT_NAILGUN)
					Sbar_DrawString(pwr_step + wep_step + woff + '66 0 0', "| Lava nails", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				if (currentweap == IT_ROCKET_LAUNCHER)
					Sbar_DrawString(pwr_step + wep_step + woff + '66 0 0', "| Lava bombs *", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			}
		}
		else if (morph == IMP_MSCOURGE)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Scourge", ALPHA_FULL, '7 7 0','1 0.5 1');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '58 0 0', "| Stinger", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '58 0 0', "| 4 x perforator", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_LIGHTNING)
				Sbar_DrawString(pwr_step + wep_step + woff + '58 0 0', "| Lasrs", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_GRENADE_LAUNCHER)
				Sbar_DrawString(pwr_step + wep_step + woff + '58 0 0', "| Proximity bombs", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
		else if (morph == IMP_MGREMLIN_F || morph == IMP_MGREMLIN_L)
		{
			Sbar_DrawString(pwr_step + wep_step + woff, "Gremlin", ALPHA_FULL, '7 7 0','0 0.7 0');
			if (morph == IMP_MGREMLIN_F)
				Sbar_DrawString(pwr_step + wep_step + woff + '50 9 0', "| Flyer", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_AXE)
			if (pk_wep == PK_IT_AXE)
				Sbar_DrawString(pwr_step + wep_step + woff + '50 0 0', "| Bite", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			if (currentweap == IT_SHOTGUN)
				Sbar_DrawString(pwr_step + wep_step + woff + '50 0 0', "| Claws", ALPHA_FULL, '7 7 0','1 0.5 0.5');
		}
	}

	if (ibar_flag > 1)
	{
		
		if (!archon_magic)
		{
			if (cl_items & IT_SUPERHEALTH)
				DrawInventory(pwr_step + '2 0 0' + woff,"gfx/sb_mega",   IT_SUPERHEALTH, 0, ALPHA_FULL, 0.19);
			else
				DrawInventoryAmmo(pwr_step + '4 0 0', "gfx/sb_health", ALPHA_FULL, 0.17);
			DrawAmmo(pwr_step + '27 -10 0', health, ALPHA_FULL);

			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 27;
		}

// IMP: archons have shield here - dont use armor icons
		if (cl_items & IT_ARMOR3)
			DrawInventoryAmmo(pwr_step + '2 0 0', "gfx/sb__armor3", ALPHA_FULL, 0.28);
		else if (cl_items & IT_ARMOR2)
			DrawInventoryAmmo(pwr_step + '2 0 0', "gfx/sb__armor2", ALPHA_FULL, 0.28);
		else if (cl_items & IT_ARMOR1)
			DrawInventoryAmmo(pwr_step + '2 0 0', "gfx/sb__armor1", ALPHA_FULL, 0.28);

		if (cl_items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3))
		{
			DrawAmmo(pwr_step + '27 -10 0', armorval, ALPHA_FULL);
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 27;
		}
	}

	if (ibar_flag > 2)
	{
		if (cl_items & IT_INVISIBILITY)
		{
			DrawInventoryAmmo(pwr_step + '2 0 0',"gfx/sb_invis",    ALPHA_LOW, 1.5);
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 27;
		}

		if (cl_items & IT_SUIT)
		{
			DrawInventoryAmmo(pwr_step + '2 0 0',"gfx/sb_suit",    ALPHA_MEDIUM, 1.5);
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 27;
		}

		if (cl_items & IT_QUAD)
		{
			DrawInventoryAmmo(pwr_step + '2 0 0',"gfx/sb_quad",    ALPHA_FULL, 1.5);
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 27;
		}

		if (cl_items & IT_INVULNERABILITY)
		{
			DrawInventoryAmmo(pwr_step + '2 0 0',"gfx/sb_invuln",    ALPHA_FULL, 1.5);
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 27;
		}
//		DrawInventory('60 48 0', "gfx/sb_invuln", IT_INVULNERABILITY, 0, ALPHA_MEDIUM, 1.5);
	}

// ammo pack deal
	if (rune_flag & RUNE_AMMO)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_pack", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}

	if (rune_flag & TECH_AMP)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_amp", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & TECH_TEIM)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_tiem", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & TECH_ADOC)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_adoc", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & TECH_DSH)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_dsh", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}

	if (rune_flag & RUNE_FLG_DM)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_dmg", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_FLG_HS)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_hst", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_FLG_RG)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_rgn", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_FLG_RS)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_res", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}
	if (rune_flag & RUNE_VAMPIRE)
	{
		DrawInventoryAmmo(pwr_step, "gfx/rune_vmp", ALPHA_FULL, 0.25);
		cnt_left = pwr_step_y;
		pwr_step_y = pwr_step_y + 30;
	}

	if (enginebar) // always above bar while it is there
	{
		DrawInventory('40 48 0', "gfx/sb_invis",  IT_INVISIBILITY, 0, ALPHA_LOW, 1.5);
		DrawInventory('60 48 0', "gfx/sb_invuln", IT_INVULNERABILITY, 0, ALPHA_MEDIUM, 1.5);
		DrawInventory('80 48 0', "gfx/sb_suit",   IT_SUIT, 0, ALPHA_MEDIUM, 1.5);
		DrawInventory('100 48 0',"gfx/sb_quad",   IT_QUAD, 0, ALPHA_FULL, 1.5);

		DrawInventory('120 48 0',"gfx/sb_mega",   IT_SUPERHEALTH, 0, ALPHA_FULL, 0.19);

// IMP: needs detection
//		DrawInventory('120 48 0', "gfx/sb_eshld", 0, HIP_IT_EMPATY_SHIELD, ALPHA_FULL, 1.5);
//		DrawInventory('140 48 0', "gfx/sb_wsuit", 0, HIP_IT_WETSUIT, ALPHA_FULL, 1.5);

		DrawInventory('170 48 0', "gfx/sb_sigil1", 0, 32, ALPHA_MEDIUM, 1.5);
		DrawInventory('190 48 0', "gfx/sb_sigil2", 0, 64, ALPHA_MEDIUM, 1.5);
		DrawInventory('210 48 0', "gfx/sb_sigil3", 0, 128, ALPHA_MEDIUM, 1.5);
		DrawInventory('230 48 0', "gfx/sb_sigil4", 0, 256, ALPHA_MEDIUM, 1.5);
	}

/// spells
	if (archon_magic)
	{
		if (explodeshot == -6)
		{
			Sbar_DrawString(pwr_step + '20 -5 0' + woff, "Spell cancelled...", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 20;
		}

		if (currentweap != IT_AXE) // casting spells
		{
			if (plevel > 0)
			{
				if (currentweap == IT_SHOTGUN) // spell list 1 - teleports
				{
					if (shells == 3)
					{
						Sbar_DrawString('314 40 0' + woff, "Teleport", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						instr = "*FIRE - teleport target to reticle";
					}
					else if (shells == 5)
					{
						Sbar_DrawString('280 40 0' + woff, "Teleport swap", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						if (target2) instr = "*FIRE - swap targets";
					}
					else if (shells == 7)
					{
						Sbar_DrawString('280 40 0' + woff, "Teleport self", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						if (target2) instr = "*FIRE - teleport to reticle";
					}
					else if (shells == 11)
					{
						if (explodeshot == 20)
						{
							Sbar_DrawString('280 40 0' + woff, "Set beacon", ALPHA_FULL, '7 7 0','1 0.5 0.5');
							instr = "*FIRE - launch beacon";
						}
						else
						{
							Sbar_DrawString('248 40 0' + woff, "Teleport to beacon", ALPHA_FULL, '7 7 0','1 0.5 0.5');
							instr = "*FIRE - cast teleport spell";
						}
					}
//					else Sbar_DrawString('280 40 0', "Unknown Magic", ALPHA_FULL, '7 7 0','1 0.5 0.5');
				}
				if (currentweap == IT_SUPER_SHOTGUN) // spell list 1 - poly
				{
					if (nails == 3)
					{
						Sbar_DrawString('260 40 0' + woff, "Polymorph self", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						if (explodeshot == 24) // no creature cost can be this val
							instr = "*FIRE - start polymorph selection";
						else
							instr = "*FIRE - cast polymorph spell";
					}
					else if (nails == 5)
					{
						Sbar_DrawString('260 40 0' + woff, "Polymorph other", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						if (explodeshot == 24) // no creature cost can be this val
							instr = "*FIRE - start polymorph selection";
						else
						{
							if (pk_bt > 0)
							{
								Sbar_DrawString(pwr_step + '22 -5 0' + woff, "target becomes: ", ALPHA_FULL, '7 7 0','1 0.5 0.5');
								Sbar_DrawString(pwr_step + '130 -5 0' + woff, monster_id(pk_bt), ALPHA_FULL, '7 7 0','1 0.5 0.5');
								cnt_left = pwr_step_y;
								pwr_step_y = pwr_step_y + 18;
							}
							instr = "*ALT_FIRE - cast polymorph spell";
						}
					}
					else if (nails == 7)
					{
						Sbar_DrawString('260 40 0' + woff, "Polymorph other", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						if (pk_bt > 0)
						{
							Sbar_DrawString(pwr_step + '22 -5 0' + woff, "target becomes: ", ALPHA_FULL, '7 7 0','1 0.5 0.5');
							Sbar_DrawString(pwr_step + '130 -5 0' + woff, monster_id(pk_bt), ALPHA_FULL, '7 7 0','1 0.5 0.5');
							cnt_left = pwr_step_y;
							pwr_step_y = pwr_step_y + 18;
						}
						instr = "*FIRE - cast polymorph spell (repeat)";
					}
				}
				DrawInventoryAmmo('372 50 0', "gfx/reticle.spr_0", ALPHA_FULL, 0.05);
			}

			if (pk_mask & 2) // spell requires targets
			{
				if (ibar_flag > 1) // ibar_f = 1, no instructions
				{
					if (!target1)
					{
						Sbar_DrawString(pwr_step + '22 -5 0' + woff, "Select target with reticle", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						cnt_left = pwr_step_y;
						pwr_step_y = pwr_step_y + 18;
					}
					else
					{
						Sbar_DrawString(pwr_step + '22 -5 0' + woff, "Select alternate target with reticle", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						if (nails == 5)
						{
							cnt_left = pwr_step_y;
							pwr_step_y = pwr_step_y + 14;
							Sbar_DrawString(pwr_step + '22 -5 0' + woff, "CUBE_RELEASE (imp: 50) - use alternate target", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						}
						else
						{
							cnt_left = pwr_step_y;
							pwr_step_y = pwr_step_y + 14;
							Sbar_DrawString(pwr_step + '22 -5 0' + woff, "ALT_FIRE - use alternate target", ALPHA_FULL, '7 7 0','1 0.5 0.5');
						}
						if (instr)
						{
							cnt_left = pwr_step_y;
							pwr_step_y = pwr_step_y + 14;
							Sbar_DrawString(pwr_step + '22 -5 0' + woff, instr, ALPHA_FULL, '7 7 0','1 0.5 0.5');							
						}
						cnt_left = pwr_step_y;
						pwr_step_y = pwr_step_y + 18;
					}
				}

				if (target2)
				{
					DrawInventoryAmmo(pwr_step, "gfx/reticle.spr_0", ALPHA_MEDIUM, 0.04);
					Sbar_DrawString(pwr_step + '22 -7 0' + woff, target2, ALPHA_MEDIUM, '7 7 0','1 0.5 0.5');
					cnt_left = pwr_step_y;
					pwr_step_y = pwr_step_y + 23;
				}
				if (target1)
				{
					DrawInventoryAmmo(pwr_step, "gfx/reticle.spr_0", ALPHA_FULL, 0.04);
					Sbar_DrawString(pwr_step + '22 -7 0' + woff, target1, ALPHA_FULL, '7 7 0','1 0.5 0.5');
					cnt_left = pwr_step_y;
					pwr_step_y = pwr_step_y + 23;
				}
			}
			else
			if (pk_mask & 1) // spell selects location
			{
				if (ibar_flag > 1)
				{
					Sbar_DrawString(pwr_step + '22 -5 0' + woff, "Select destination with reticle", ALPHA_FULL, '7 7 0','1 0.5 0.5');
					if (instr)
					{
						cnt_left = pwr_step_y;
						pwr_step_y = pwr_step_y + 14;
						Sbar_DrawString(pwr_step + '22 -5 0' + woff, instr, ALPHA_FULL, '7 7 0','1 0.5 0.5');							
					}
					cnt_left = pwr_step_y;
					pwr_step_y = pwr_step_y + 20;
				}
			}
			else if (!pk_mask) // spell just fires off
			{
				if (instr)
				{
					cnt_left = pwr_step_y;
					pwr_step_y = pwr_step_y + 14;
					Sbar_DrawString(pwr_step + '22 -5 0' + woff, instr, ALPHA_FULL, '7 7 0','1 0.5 0.5');							
				}
			}
		}
		else
		{
			Sbar_DrawString(pwr_step + '22 -5 0' + woff, "FIRE - chaos bolt attack", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			cnt_left = pwr_step_y;
			pwr_step_y = pwr_step_y + 14;
			if (volspec > 2000) Sbar_DrawString(pwr_step + '22 -5 0' + woff, "ALT_FIRE - chaos beam", ALPHA_FULL, '7 7 0','1 0.5 0.5');
			DrawInventoryAmmo('362 50 0', "gfx/inv_chaos_shot", ALPHA_FULL, 0.1);
		}

		return; // because archon should not have any stuff
	}

sb_align = SB_BOTTOM_RIGHT;

//position and size of ibar items

// std inventory will maintain a 20 unit step, blocked, new inventory will increment where needed
// some items are on position swap out - laser for sng, etc.

/// weapon area right
	wep_step = '290 140 0';

	if (bullets > 0)
	{
		DrawInventoryAmmo(wep_step + '12 -10 0',"gfx/sb_bullet", ALPHA_FULL, 0.08);
//		if (mcode == MC_C_FLAMER)
//			DrawAmmo(wep_step + '-10 -15 0', bullets, ALPHA_FULL);
//		else
			DrawAmmo(wep_step + '-10 -15 0', bullets, ALPHA_MEDIUM);
		wep_step = wep_step + '0 20 0';
	}

	if (gas > 0)
	{
		DrawInventoryAmmo(wep_step + '12 -10 0',"gfx/sb_gas1", ALPHA_FULL, 0.1);
		if (mcode == MC_C_FLAMER)
			DrawAmmo(wep_step + '-10 -15 0', gas, ALPHA_FULL);
		else
			DrawAmmo(wep_step + '-10 -15 0', gas, ALPHA_MEDIUM);
		wep_step = wep_step + '0 20 0';
	}

	if (slugs > 0)
	{
		DrawInventoryAmmo(wep_step + '12 -10 0',"gfx/sb_slug", ALPHA_FULL, 0.08);
		if (mcode == MC_Q2_RAILGUN)
			DrawAmmo(wep_step + '-10 -15 0', slugs, ALPHA_FULL);
		else
			DrawAmmo(wep_step + '-10 -15 0', slugs, ALPHA_MEDIUM);
		wep_step = wep_step + '0 20 0';
	}

//	if (mcode == MC_HIP_MJOLNIR) // exclude non mjolnir items that use IT_MJOLNIR bit == 128
	DrawInventoryWeapon(wep_step, "gfx/inv_mjolnir",  wep_mj,  IT_MJOLNIR, 0.125, 0);
	if (cl_items & IT_MJOLNIR) wep_step = wep_step + '0 20 0';

	if (has_hook)
		DrawInventoryWeapon(wep_step, "gfx/inv_hook", "gfx/inv2_hook",  PK_IT_GRAPGUN, 0.125, STAT_PKWEP);
	else
		DrawInventoryWeapon(wep_step, "gfx/inv_harp", wep_harp,  PK_IT_GRAPGUN, 0.125, STAT_PKWEP);
	if (pk_inv & PK_IT_GRAPGUN) wep_step = wep_step + '0 20 0';

	DrawInventoryWeapon(wep_step, "gfx/inv_shotgun",  wep_sg,  IT_SHOTGUN, 1, 0);
	wep_axlv = wep_step + '-30 0 0';

	DrawInventoryWeapon(wep_step + '0 20 0', "gfx/inv_aircan", wep_airgun,  PK_IT_AIRGUN, 0.125, STAT_PKWEP);
	if (pk_inv & PK_IT_AIRGUN) wep_step = wep_step + '0 20 0';

	DrawInventoryWeapon(wep_step + '0 20 0', "gfx/inv_sshotgun", wep_ssg, IT_SUPER_SHOTGUN, 1, 0);

	if (has_pnail)
		DrawInventoryWeapon(wep_step + '0 40 0', "gfx/inv_pnail",  wep_pnail,  IT_NAILGUN, 0.125, 0);
	else
		DrawInventoryWeapon(wep_step + '0 40 0', "gfx/inv_nailgun",  wep_nail,  IT_NAILGUN, 1, 0);

// Cataboligne - 9.9.13 - had to change, these had issues because Archon code is different on extra weps

	if (has_laser)
		DrawInventoryWeapon(wep_step + '0 60 0', "gfx/inv_laser", wep_laser, IT_SUPER_NAILGUN, 0.125, 0);
	else
		DrawInventoryWeapon(wep_step + '0 60 0', "gfx/inv_snailgun", wep_snail, IT_SUPER_NAILGUN, 1, 0);

	if (has_flamer1)
		DrawInventoryWeapon(wep_step + '0 80 0', "gfx/inv_flamer1",  "gfx/inv2_flamer1",  IT_GRENADE_LAUNCHER, 0.125, 0);
	else if (has_prox)
		DrawInventoryWeapon(wep_step + '0 80 0', "gfx/inv_prox_gren",  wep_prox,  IT_GRENADE_LAUNCHER, 0.125, 0);
	else
		DrawInventoryWeapon(wep_step + '0 80 0', "gfx/inv_rlaunch",  wep_gren,  IT_GRENADE_LAUNCHER, 1, 0);

	DrawInventoryWeapon(wep_step + '0 100 0', "gfx/inv_srlaunch", wep_rock, IT_ROCKET_LAUNCHER, 1, 0);

	DrawInventoryWeapon(wep_step + '-24 120 0', "gfx/inv_lightng",  wep_light,  IT_LIGHTNING, 1, 0);
	if (cl_items & IT_LIGHTNING) wep_step = wep_step + '0 20 0';

	DrawInventoryWeapon(wep_step + '0 120 0', "gfx/inv_clg",  wep_clg,  PK_IT_CLIGHT, 0.125, STAT_PKWEP);
	if (pk_inv & PK_IT_CLIGHT) wep_step = wep_step + '0 20 0';


	wep_step = '262 30 0';
	inv_alm = 1;
	if (items & IT_INVISIBILITY) inv_alm = 0.2;

	if (pk_phone > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PKPLUS_IT_PHONE))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_phn", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_phone, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_phn", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_phone, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_mask > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PKPLUS_IT_ACTOR))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_mask", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_mask, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_mask", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_mask, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_tomb > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PKPLUS_IT_TOMB))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_tomb", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_tomb, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_tomb", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_tomb, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_ego > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PKPLUS_IT_EGO))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_ego", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_ego, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_ego", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_ego, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_copb > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PK_IT_CANPAB))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_copb", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_copb, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_copb", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_copb, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_bt > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PK_IT_BEARTRAP))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_btrap", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_bt, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_btrap", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_bt, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_tur > 0)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PK_IT_TURRET))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			DrawInventoryAmmo(wep_step, "gfx/inv_turr", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_tur, ALPHA_FULL);
		}
		else
		{
			DrawInventoryAmmo(wep_step, "gfx/inv_turr", ALPHA_FULL * inv_alm, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', pk_tur, ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (pk_gwell)
	{
		if ((currentweap == IT_AXE) && (pk_wep == PK_IT_GRAVITYWELL))
		{
			if (dmg_flare) Sbar_DrawPic(wep_step + '-2 2 0' + woff, "gfx/dmg_flare3", ALPHA_90, 0.15);
			else Sbar_DrawPic(wep_step + '-2 -16 0' + woff, "gfx/spell_bar", ALPHA_90, 0.5);
			if (pk_gwell > 0)
				DrawInventoryAmmo(wep_step, "gfx/inv_gwell", ALPHA_FULL, 0.125);
			else
				DrawInventoryAmmo(wep_step, "gfx/inv_sgwell", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', fabs(pk_gwell), ALPHA_FULL);
		}
		else
		{
			if (pk_gwell > 0)
				DrawInventoryAmmo(wep_step, "gfx/inv_gwell", ALPHA_FULL * inv_alm, 0.125);
			else
				DrawInventoryAmmo(wep_step, "gfx/inv_sgwell", ALPHA_FULL, 0.125);
			DrawAmmo(wep_step + '-22 -5 0', fabs(pk_gwell), ALPHA_MEDIUM);			
		}
		wep_step = wep_step + '0 20 0';
	}

	if (wep_axlv_y < wep_step_y) wep_axlv_y = wep_step_y;

	if ((pk_wep == PK_IT_AXE) && (currentweap == IT_AXE))
	if (has_deepsleep)
		DrawInventoryWeapon(wep_axlv, "gfx/inv_deep_sleep",  "gfx/inv2_deep_sleep",  IT_AXE, 0.125, 0);		
	else
		DrawInventoryWeapon(wep_axlv, "gfx/inv_axe",  wep_axe,  IT_AXE, 0.125, 0);

	if (explodeshot > 0)
	{
		DrawInventoryAmmo('302 30 0', "gfx/sb_xpshells", explodsht_alp, 0.125);  
		DrawAmmo('280 25 0', explodeshot, explodsht_alp);
	}

// for 4 small ammo icon positions

	if (morph > 60) // dont display for non humans unless they got some
	{
		if (shells > 0)
		{
			DrawInventoryAmmo('302 50 0', "gfx/sb_shells", ALPHA_FULL, 0.5);  
			DrawAmmo('280 45 0', shells, ALPHA_MEDIUM);
		}
		if (nails > 0)
		{
			DrawInventoryAmmo('302 70 0', "gfx/sb_nails", ALPHA_FULL, 0.5);
			DrawAmmo('280 65 0', nails, ALPHA_MEDIUM);
		}
		if (rockets > 0)
		{
			DrawInventoryAmmo('302 90 0', "gfx/sb_rocket", ALPHA_FULL, 0.5);
			DrawAmmo('280 85 0', rockets, ALPHA_MEDIUM);
		}
		if (cells > 0)
		{
			DrawInventoryAmmo('302 110 0',"gfx/sb_cells", ALPHA_FULL, 0.5);
			DrawAmmo('280 105 0', cells, ALPHA_MEDIUM);		
		}
		return;
	}
	DrawInventoryAmmo('302 50 0', "gfx/sb_shells", ALPHA_FULL, 0.5);  
	DrawInventoryAmmo('302 70 0', "gfx/sb_nails", ALPHA_FULL, 0.5);
	DrawInventoryAmmo('302 90 0', "gfx/sb_rocket", ALPHA_FULL, 0.5);
	DrawInventoryAmmo('302 110 0',"gfx/sb_cells", ALPHA_FULL, 0.5);

//highlight of current weapon ammo counter + position of ammo counters
	if (cl_items & IT_SHELLS)
	{
		if (explodsht_alp == ALPHA_FULL)
			DrawAmmo('280 45 0', shells, ALPHA_MEDIUM);
		else
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
