/* ::-::
 *
 * Cataboligne
 *
 * file: compiler.qc
 *
 * date: 11/19/14
 *
 * qc - precompiler specific codes
 *
 */

// tell the compiler about us

#message			-- *** CHA*S mod [ mark II ] - "the Archons" *** 
#message			-- (c) 1996 iD software, (c) 2011 Cataboligne 
#message			-- GPL - see "source code/license.txt" for rights and details 
#message 

#pragma COPYRIGHT (c) 1.06 iD 1996, 1.07 Six 2010

// **************************************
// code weaver section
//
// **************************************


// this section deals with what portions of the code base get compiled in and which get left out


// dont list unused vars warning when compiling
//#pragma warning disable Q302

// note - defines MUST be commented out - you cannot define null or 0 to clear them
// control whether warning code is compiled in

//#define warning

#ifdef warning
float WARNING;								// display warnings - dev work mainly - now uses the following bit flags for specific warning sets
float pkvl; // for indicator
#endifdef
												// & 1 - server ops
												// & 2 - items
												// & 4 - monsters / morphs
												// & 8 - bot warnings
												// & 16 - hipnotic warnings
												// & 32 - weapons
												// & 64 - runes / artifact enh
												// & 128 - environment
												// & 255 - 1 - 128 inclusive + non masked
												// & 256 - non masked elements - excludes 1 - 128 ++
// specials
												// & 1024 - hammer
												// & 2048 - hub ops
												// & 4096 - archon ops
												// & 8192 - looped ops
												// & 16384 - dead threw / viswep
												// & 32768 - vw_load
												// & 65536 - maphack
												// & 131072 - maphack biome spec
												// & 262144 - block some repeating warnings
//
// control over test code

//#define testset

#ifdef testset
#else
#endifdef

// basic code has been enhanced - mostly monsters, but some other things as well

#define enhanced

#ifdef enhanced
#else
#endifdef

// replaces - 
//							float ENHANCED					= 1; // adds features that werent originally there in the sub mods (like runes)

// compiler warnings
// dont list unused vars warning when compiling
//#pragma warning disable Q302

// turn off warnings for map spawn functions - most are normally only called by the engine
#pragma warning off F300

// NOTE: this masks off no return value compiler WARNINGS !
// comment this out to see any related warnings
#pragma warning disable Q206

// **************************************
// Function section
//
// **************************************


// these defines act like function calls


// replaced old built-in frame macro

/*

// matches frames in quake model

$frame fr1 fr2 fr3 fr4

void()   player_frame1 =[ $fr1,   player_frame2 ] { arbitrary_code(); };
void()   player_frame2 =[ $fr2,   player_run ] { };

// expands to

void()   player_frame1 =
{
	self.frame = $fr1;
	self.think = player_frame2;
	self.nextthink = time + 0.1;
	{
		arbitrary_code();
	};
};

*/

// implement a frame seqeunce where anything might happen in the frames
// t_ = think

/// excode --- run any arbitrary code - SUB_Null() for nothing, you can __NOT__ leave this blank!				- you really cant, it wont compile that way

//#define framer(sframe,eframe,t_on,t_to,t_time,excode) void() t_on { if (self.think != t_on || freset == -666) self.frame = sframe - 1; freset = 0; self.think = t_on; self.nextthink = time + t_time; self.frame = self.frame + 1; if (self.frame == eframe) { self.think = t_to; freset = -666; } pr1(); excode; }

#define framer(sframe,eframe,t_on,t_to,t_time,excode) void() t_on {if (self.think != t_on|| self.frame < sframe || self.frame >= eframe){self.frame = sframe - 1; self.think = t_on;} self.frame = self.frame + 1; self.nextthink = time + t_time; if (self.frame == eframe) {self.think = t_to;} excode;}

// self loop - does not think to a t_to on eframe

#define framerloop(sframe,eframe,t_on,t_time,excode) void() t_on {if (self.think != t_on|| self.frame < sframe || self.frame >= eframe){self.frame = sframe - 1; self.think = t_on;} self.frame = self.frame + 1; self.nextthink = time + t_time; excode;}


/*

// code layout

void() t_on 
{
	if (self.think != t_on|| self.frame < sframe || self.frame >= eframe)
	{
		self.frame = sframe - 1;
		self.think = t_on;
	}
	self.frame = self.frame + 1;
	self.nextthink = time + t_time;
	if (self.frame == eframe) { self.think = t_to; }
	excode; // run any arbitrary code - SUB_Null() for nothing, you can NOT leave this blank!
}

*/

// run arbitrary code in a specific frame, range of frames or set of frames

#define frame_arb(thisframe,arbcode) if (self.frame == thisframe) { arbcode; };

#define framerange_arb(thisframe,thatframe,arbcode) if (self.frame >= thisframe && self.frame <= thatframe) { arbcode; };

// use -666 to negate a frame test
// arbcode will run on any frame in the list

#define frameset_arb(thisframe,twoframe,threeframe,fourframe,fiveframe,sixframe,arbcode) if (self.frame == thisframe || self.frame == twoframe || self.frame == threeframe || self.frame == fourframe || self.frame == fiveframe || self.frame == sixframe) { arbcode; };





// a problem with the test map, where a button makes a random item - calls this, crashing without

void() spawn_loop { };


