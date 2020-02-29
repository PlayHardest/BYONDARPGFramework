#ifdef JUMP

Elevation
	parent_type=/obj
	//layer_add=5
	base_layer=MOB_LAYER
	density=1

	Platform_Base

		//icon='BuildBox.dmi'
		//plane=1
		base=1
		alpha=150

		New(_x,_y,_z,BW,BH,H)
			..()
			icon_state=num2text(rand(1,5))
			loc=locate(_x,_y,_z)
			bound_width=BW
			bound_height=BH
			_height=H
			var/matrix/M=matrix()
			M.Scale(BW/32,BH/32)
			M.Translate((BW/2)-16,(BH/2)-16)
			transform=M
			LocationUpdate(_height<bound_height?0:1)
			SetLayer()



obj
	proc
		SetLayer(layer_only=0)
			set waitfor=0
			sleep(0)
			sleep(-1)
			sleep(2)
			LocationUpdate(_height<bound_height?0:1)
			var/list/top_platforms=list()
			var/min
			var/Elevation/Platform_Base/lowest
			if(base)
				for(var/obj/o in obounds(src,0,0,0,_height+elevation))
					if(o._height)	continue
					o.layer=layer
				for(var/obj/o in obounds(src,0,0,0,max(0,_height-bound_height)))
					o.elev_height=((o.y-(y))*32)*2
					o.ShadowCreate()
					//
			if(layer_only)	return
			for(var/obj/o in obounds(src,0,0,0,!base?0:_height+elevation))//for all objects inside of src's obounds
				if(o._height>0 && !o.elevation)//if they have a height value
					top_platforms+=o//add them to the top platforms list
			for(var/obj/o in top_platforms)//for everything in the top_platforms list
				if(o.y<y)//if its y value is less than src's y value(src is higher on the map, and therefore src is on top of it)
					top_platforms=list()//empty the top_platforms list
					break//exit the loop
			while(top_platforms.len>0)//if top_platforms has at least one item
				min=999
				lowest=null
				for(var/obj/o in top_platforms)//loop through the top_platforms list and
					if(o.y<min)//find the item with the lowest y value
						min=o.y
						lowest=o
				for(var/obj/o in obounds(lowest,0,0,0,!lowest.base?0:_height+elevation)-src)//check the items within the bounds of the item with the lowest y value
					//if the base var is equal to 1, that means it was a manually built elevation, and therefore to account for everything it may contain the searched area
					//must be increased by _height
					if(o._height>0 && o.y>lowest.y)//if an item is found that has a height value and it's y value is greater than lowest obj's y val(an item is found that
					//is higher up than the current lowest while within its bounds. i.e - on top of it)
						o.elevation+=lowest._height//add the current lowest item's height to its elevation
						if(!(o in top_platforms))	top_platforms.Add(o)//add them to be processed if they have not been already

				top_platforms-=lowest//remove the item from the top_platforms list that you're operating on
				lowest.elevation+=_height//set the lowest's elevation to the _height of the platform it stands on
				lowest.y-=ceil(lowest.elevation/TILE_HEIGHT)//lower the physical position of the item by the amount its elevated by
				if(!lowest.base)//if the item is not a base type
					lowest.pixel_z+=lowest.elevation//increase its pizel_z by its elevation to hide the repositioning in the y plane
					lowest.LocationUpdate()//update the location to update the shadow
				else
					lowest.SetLayer(1)//update the layers of the item and its objs






area
	var
		x_val=0
		y_val=0

	Elevation
		New()
			tag="[z] - [icon_state]"
			icon_state=null
			icon=null

		Top_BL
			icon='Top_BL.dmi'

		Base_TR
			icon='Base_TR.dmi'

		Base_BL
			icon='Base_BL.dmi'
			New()
				..()
				spawn()
					CreateBase()

	proc
		CreateBase()
			set waitfor=0
			var/area/top_piece=locate("[tag]-c")
			if(!top_piece)
				CRASH("No top piece area was found for [src]::[tag]||[tag]-c")
				return


			var/heightval=(top_piece.y-y)*TILE_HEIGHT
			var/area/partner=locate("[tag]-b")
			if(!partner)
				CRASH("No partner area was found for [src]::[tag]||[tag]-b")
				return
			x_val=(partner.x-(x-1))*TILE_WIDTH
			y_val=(partner.y-(y-1))*TILE_HEIGHT
			new/Elevation/Platform_Base(x,y,z,x_val,y_val,heightval)


#endif