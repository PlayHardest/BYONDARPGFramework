//1366x768(62)
/*
#define WALLCLIMB 1
#define WALLBOUNCE 1
#define ADMIN 1
#define JUMP 1
#define JUMP_ACCEL 20
#define CEILING 200
*/

#ifdef JUMP
	#ifndef CEILING
		#warn A maximum height is undefined, defaulting to 81
		#define CEILING 81
	#endif
#endif

#define HUD_LAYER 10
#define NO_CLICK 1
#define NO_KEY_REPEAT 1
#define FPS 25
#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define pi 3.141592654
#define MAP_PLANE 0
#define HIT_PLANE 1
#define walk_speed 5
#define run_speed 8
#define MAX_INVENTORY 24
#define MAX_ACTIVE_TIME 30
#define EDGE_CLAYER 99
#define K_RIGHT "east"
#define K_LEFT "west"
#define K_UP "north"
#define K_DOWN "south"
#define K_JUMP "space"
#define MAX_VIEW_TILES 800
#define degrees_to_rad(s) s * 2 * pi/360
#define even(x) x % 2 = 1 ? (round(x,1)-1) : x
#define odd(x) x % 2 = 0 ? (round(x,1)-1) : x

#ifndef TER13_STDLIB
	#define TER13_STDLIB "version 2.2"

	#if !defined(TILE_WIDTH)||!defined(TILE_HEIGHT)
		#define WARN_TILE_METRICS
	#endif

	#ifndef TILE_WIDTH
		#define TILE_WIDTH 32
	#endif

	#ifndef TILE_HEIGHT
		#define TILE_HEIGHT 32
	#endif

	#ifndef FPS
		#define WARN_FPS
		#define FPS 25
	#endif

	#ifndef VFPS
		#define VFPS FPS
	#endif

	#define TICK_LAG (10/FPS)
	#define FRAME_LAG (10/VFPS)

var
	__stdlib_rnd
	__stdlib_p2dy
	__stdlib_p2dx
	__stdlib_tan
	list
		__stdlib_dir_ang = list(90,270,null,0,45,315,0,180,135,225,180,null,90,180,null)
		__stdlib_dir_names = list("north"=NORTH,"south"=SOUTH,null,"east"=EAST,"northeast"=NORTHEAST,"southeast"=SOUTHEAST,null,"west"=WEST,"northwest"=NORTHWEST,"southwest"=SOUTHWEST)
		__stdlib_dir_clock = list(EAST,NORTHEAST,NORTH,NORTHWEST,WEST,SOUTHWEST,SOUTH,SOUTHEAST)

	#define floor(x) round(x)
	#define ceil(x) (-round(-(x)))
	#define round_in(x) ((__stdlib_rnd=(x))>=0 ? floor(__stdlib_rnd) : ceil(__stdlib_rnd))
	#define round_out(x) ((__stdlib_rnd=(x))<0 ? ceil(__stdlib_rnd) : floor(__stdlib_rnd))

	//#define clamp(v,l,h) min(max(v,l),h)

proc
	decimal(x)
		. = x - round_in(x)

	to_places(x,places)
		if(places)
			var/whole = round_in(x)
			var/shift = 10**(places-1)
			. = whole + round_in((x - whole) * shift) / shift
		else
			. = round_in(x)

	sign(x)
		return (x==0 ? 0 : (x<0 ? -1 : 1))

	#define isatom(o) istype(o,/atom)
	#define ismovable(o) istype(o,/atom/movable)
	#define islist(o) istype(o,/list)
	#define isclient(o) istype(o,/client)

	ang2dir(x)
		//ensure that the angle is between 0 and 360
		if(x<0)
			x = x+360*ceil(x/-360)
		. = __stdlib_dir_clock[floor(ceil(x/22.5)%16 / 2)+1]

	atan2(x,y)
		. = (x||y)&&(y>=0 ? arccos(x/sqrt(x*x+y*y)) : 360-arccos(x/sqrt(x*x+y*y)))

	atan2dir(x,y)
		. = (x||y)&&(y>=0 ? arccos(x/sqrt(x*x+y*y)) : 360-arccos(x/sqrt(x*x+y*y)))
		switch(.)
			if(22.5 to 67.5)
				return NORTHEAST
			if(67.5 to 112.5)
				return NORTH
			if(112.5 to 157.5)
				return NORTHWEST
			if(157.5 to 202.5)
				return WEST
			if(202.5 to 247.5)
				return SOUTHWEST
			if(247.5 to 292.5)
				return SOUTH
			if(292.5 to 337.5)
				return SOUTHEAST
			else
				return EAST

	#define point2dir(x,y) (((__stdlib_p2dx=(x))>0 ? EAST : (__stdlib_p2dx<0 ? WEST : 0)) + ((__stdlib_p2dy=(y))>0 ? NORTH : (__stdlib_p2dy<0 ? SOUTH : 0)))
	#define point2dist(x,y) sqrt((x)**2 + (y)**2)

	#define dir2ang(x) __stdlib_dir_ang[x]
	#define dir2text(x) __stdlib_dir_names[x]
	#define text2dir(name) __stdlib_dir_names[name]

	#define tan(a) (sin(a) / cos(a))
	#define arctan(a) (arccos(1 / sqrt(1 + (a)**2))
	#define arccot(a) (arcsin(1 / sqrt(1 + (a)**2))

	#define cot(a) (1/tan(a))
	#define sec(a) (1/cos(a))
	#define csc(a) (1/sin(a))
	#define arcsec(a) arccos(1 / (a))
	#define arccsc(a) arcsin(1 / (a))

	screen2coord(client/client,param)
		//split the location string into two parts
		var/list/l = splittext(param,",")
		//then split those two parts into two parts.
		var/list/lx = splittext(l[1],":")
		var/list/ly = splittext(l[2],":")

		//store the coordinates in the first list we created and return it
		l[1] = (text2num(lx[1])) * TILE_WIDTH + text2num(lx[2])-1
		l[2] = (text2num(ly[1])) * TILE_HEIGHT + text2num(ly[2])-1
		return l

	screen2world(client/client,param)
		var/list/l = splittext(param,",")
		var/list/lx = splittext(l[1],":")
		var/list/ly = splittext(l[2],":")

		//store the coordinates in the first list we created and return it
		l[1] = (text2num(lx[1])) * TILE_WIDTH + text2num(lx[2])-1 + client.bound_x
		l[2] = (text2num(ly[1])) * TILE_HEIGHT + text2num(ly[2])-1 + client.bound_y
		return l

	singleton_init(root)
		var/datum/d, id, list/l = list()
		for(var/v in typesof(root))
			d = v
			if((id = initial(d:id)))
				l[id] = new v()
		return l

	index_typesof(root)
		var/datum/d, id, list/l = list()
		for(var/v in typesof(root))
			d = v
			if((id = initial(d:id)))
				l[id] = v
		return l

	savefile_database(file)
		var/list/l
		if(fexists(file))
			var/savefile/f = new/savefile(file)
			f >> l
			f = null
		return l

	json_database(file)
		var/list/l
		if(fexists(file))
			l = json_decode(file2text(file))
			return json2datum(l)

	json2datum(datum/root)
		if(islist(root))
			var/key, list/value, datum/current = root
			if((value = root["type"]))
				root = new value()
				current -= "type"
			for(key in current)
				if(!isnum(key))
					value = current[key]
					current.vars[key] = islist(value) ? .(value) : value
		return root

datum
	var
		destroy=0

	proc
		Destroy()

	Del()
		if(Destroy())//if a positive signal is recieved, that is, it fails to recycle an object due to it either being designated to be destroyed or the object pool is full
					  //then carry out the normal deletion process of the object
			..()
		//otherwise, leave the object alone, as the object_pool procedure should have been successfully carried out on it


atom/movable
	Destroy()
		for(var/atom/movable/o in src)
			o.loc = null
		loc = null
		if(!destroy)//if the object isnt designated to be destroyed
			if(!ismob(src))//and it is not a mob
				if(Object_Pool(s=src))//and 1 is returned from Object_Pool(), that is, it is already within the recycle list or it is successfully recycled
					return 0//then return a negative signal
		return 1//otherwise return a positive signal

client
	proc
		Destroy()

	Del()
		Destroy()
		..()

#define PRESERVE_NONE 0
#define PRESERVE_WORLDTIME 1
#define PRESERVE_REALTIME 2

mob
	var
		save_worldtime
		save_realtime

	Write(savefile/F)
		save_worldtime = world.time //store the current world time right before saving
		save_realtime = world.realtime //store the current real time right before saving
		..() //default action causes the mob to be written to the savefile.

#define HOOK_EVENT(evname) /init_event/##evname/New()
#define INIT_EVENT(evname) /init_event/New(){..();new/init_event/##evname()};HOOK_EVENT(##evname)

//INIT_EVENT is used to define a new initialization event without requiring more global variable space.

//HOOK_EVENT is used to override an existing initialization event. Do not INIT the same event more than once.
//do not hook an event before it has been initialized or it will not function.
//events are processed by compiler order, so be mindful of that.

var
	init_event/__init_event = new()
	initialized = 0
	list/__post_init

//do not derive manually. Use the INIT_EVENT function
init_event
	var
		id
	New()
		if(!initialized)
			__post_init = list(src)
			..()
		else
			del src
	PostInit()
		__init_event = null

//set an atom's post_init to 1 to ensure that PostInit() is called after New().
datum
	var
		post_init = 0

	New()
		if(initialized)
			post_init&&PostInit()
		else if(post_init) __post_init[src] = 1
		..()

	proc
		PostInit()

//PostInit is a convenience function that lets you make sure world/New() has been called prior to the datum's initialization.
//any objects you want to have PostInit() called on should add themselves to __post_init. This is done by default on any /atom with post_init variable set to 1

world
	New()
		..()
		PostInit()
	proc
		PostInit()
			if(!initialized)
				initialized = 1
				for(var/d in __post_init)
					d:PostInit()
				__post_init = null


overlay
	parent_type = /obj
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE

underlay
	parent_type = /obj
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE

#endif