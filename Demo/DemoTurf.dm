turf
	Tiles
		//icon='Icons/Map/Turf/Tiles.dmi'
		icon='Tiles.dmi'

		Grass
			icon_state="grass"
			plane=0
			layer=1

obj
	MapObjects
		square32
			icon='Base2.dmi'
			pixel_x=-32
			pixel_y=-32

		BoxTop
			icon='BuildBox.dmi'
			icon_state="top"
			density=0
			no_layer=1

		BoxSide
			icon='BuildBox.dmi'
			icon_state="side"
			density=0
			no_layer=1

		BoxTop2
			icon='BuildBox.dmi'
			icon_state="top2"
			density=0
			no_layer=1

		BoxSide2
			icon='BuildBox.dmi'
			icon_state="side2"
			density=0
			no_layer=1

		Box
			icon='Box.dmi'
			icon_state="box-1"
			_height=32
			elev_height=44
			bound_width=64
			bound_height=20

		Box_2
			icon_state="box-2"
			icon='Box.dmi'
			_height=32
			bound_width=64
			bound_height=32

		N_Slope
			icon='Box.dmi'
			icon_state="slope4"
			slope_dir=NORTH
			slope_opp_dir=SOUTH
			slope_start=0
			_height=32
			bound_width=20
			bound_height=32


		S_Slope
			icon='Box.dmi'
			icon_state="slope3"
			slope_dir=SOUTH
			slope_opp_dir=NORTH
			slope_start=0
			_height=32
			bound_width=20
			bound_height=32


		E_Slope
			icon='Box.dmi'
			icon_state="slope2"
			slope_dir=EAST
			slope_opp_dir=WEST
			slope_start=0
			_height=32
			elev_height=45
			bound_width=64
			bound_height=20

		W_Slope
			elev_height=45
			icon='Box.dmi'
			icon_state="slope1"
			slope_dir=WEST
			slope_opp_dir=EAST
			slope_start=0
			_height=32
			bound_width=64
			bound_height=20

		Box2
			icon='Box2.dmi'
			_height=32
			bound_width=64
			bound_height=64

		Box3
			icon='Box3.dmi'
			_height=64
			bound_width=32
			bound_height=32