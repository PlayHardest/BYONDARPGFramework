
Filters
	var
		blur=0

Preferences

datum
	var
		expire_time=0

var
	worldstarttime = 0
	worldstarttimeofday = 0
	ACW_NORTH_ANGLE=270
	ACW_EAST_ANGLE=180
	ACW_SOUTH_ANGLE=90
	ACW_WEST_ANGLE=0//360
	ACW_NORTHEAST_ANGLE=225
	ACW_NORTHWEST_ANGLE=315
	ACW_SOUTHEAST_ANGLE=135
	ACW_SOUTHWEST_ANGLE=45
	NORTH_ANGLE=90
	EAST_ANGLE=180
	SOUTH_ANGLE=270
	WEST_ANGLE=0
	NORTHEAST_ANGLE=135
	NORTHWEST_ANGLE=45
	SOUTHEAST_ANGLE=225
	SOUTHWEST_ANGLE=315

	list
		effect_appearance=list()
		obj_pool=list()
		visual_effects=list()
		animationstates=list()
		animationspeed=list()
		player_list=list()
		all_keys=list("q","w","e","r","t","y","u","i","o","p","\[","]","\\","a","s","d","f","g","h","j","k","l",";","'","z","x","space","back","c","v","b","n","m",",",".","/","1","2","3","4","5","6","7","8","9","0","`","-","=")
		shiftsymbols=list("\["="{","]"="}","\\"="|",";"=":","'"="\"",","="<","."=">","/"="?","1"="!","2"="@","3"="#","4"="$","5"="%","6"="^","7"="&","8"="*","9"="(","0"=")","`"="~","-"="_","="="+")
		letters_only=list("q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m","space","back")
		numbers_only=list("1","2","3","4","5","6","7","8","9","0")


client
	var
		hudobj/chatbox
		hudobj/textbox
		hudobj/active_textbox
		dir_repeat=0
		Controls/controls=new/Controls
		Preferences/options=new/Preferences
		lastpressed
		currentkey
		east=0
		west=0
		north=0
		south=0
		list
			zooms=list()
		zoom

	Del()
		chatbox=null
		textbox=null
		active_textbox=null
		screen=list()


atom
	var
		generation_string//define StringGenerate()
		gx
		gy
		tmp
			collide_layer=1

	movable
		var
			angle_move=0
			x_loc=0
			y_loc=0
			_height=0
			height_gained=0
			height_accel=0
			height_decline=2
			elevation=0
			layer_add=0
			base_layer=0
			mid_air=0
			layer_level=0
			tmp
				list
					reset_vars=list()

				_id=0

				no_dense=0
				set_h_accel=0
				bump_movement_action=""
				end_movement_action=""
				y_plus=0
				on_edge=0
				movement_dir=0
				MAP_X=0
				MAP_Y=0
				maxgx=0
				maxgy=0
				ingame=0
				canMove=1
				phase_through=0
				oppositedir
				travel_distance=0
				max_travel_distance
				walking=0

				Filters/filterinfo=new/Filters

				obj/overshadow
				obj/slope_obj
				obj/shadow

				gravity=1
				jump=0
				can_enter=1
				active_time=0
				move_x
				move_y
				lx
				ly
				//sub_step_x = 0
				//sub_step_y = 0
				atom/movable/grabbed
				atom/movable/grabbedby
				moved=0
				no_move=0
				last_slope_height=0
				slope_start=-1
				slope_dir
				slope_opp_dir

obj
	list
		reset_vars=list("Owner","client","nextobjs")
	var
		tmp
			duration=0
			effect=0
			total_frames=0
			move_trigger=""
			no_layer=0
			power=0
			active=0
			move_dir=""
			base=0
			elev_height=0


			mob/Owner

			client/client
			anchor_x = "WEST"
			anchor_y = "SOUTH"
			screen_x = 0
			screen_y = 0
			width = TILE_WIDTH
			height = TILE_HEIGHT

	Del()
		Owner=null
		client=null
		..()




mob
	base_layer=MOB_LAYER
	destroy=1

	var
		tmp
			list
				hotkeys_keys=list()
				activeprocs=list()
				directional_keys=list()
				movement_keys=list()

			//MISCELLANEOUS VARIABLES
			old_state
			playspeed
			crouch=0
			last_action=""
			cancel_anim=0
			play_anim=0
			cur_anim=""
			last_frame_static=0

			//BUFF VARIABLES
			speed_alter=0
			attack_alter=0
			defence_alter=0

			//MOVEMENT VARIABLES
			check_move_inputs=0
			run=FALSE
			hangtime=0
			ascend=0
			descend=0
			no_state=0
			can_wall_bounce=0
			wall_bounces=1
			max_wall_bounces=1
			wallgrabbed_dir
			climb_limit=48
			max_climb_limit=48


			//MOB VARIABLES

			//OBJECT VARIABLES
			obj/occupying
			obj/under
			obj/wallgrabbed
			visual_fx/blur_fx



		speed_multiplier=1


	Player
		plane=0

	Del()
		under=null
		occupying=null
		shadow=null
		wallgrabbed=null
		blur_fx=null
		..()