atom
	movable
		proc
			ShadowCreate()
				if(ismob(src))
					var/mob/M=src
					Object_Pool(/obj/Shadow,creation_params=M)
					Object_Pool(/obj/Overshadow,creation_params=M)
				if(isobj(src))
					var/obj/O=src
					if(!O.power)
						Object_Pool(/visual_fx/MapShadow,creation_params=O)
						Object_Pool(/visual_fx/MapOverShadow,creation_params=O)
					else
						Object_Pool(/obj/Obj_Shadow,creation_params=O)






visual_fx
	MapOverShadow
		base_layer=MOB_LAYER

		Create(obj/O)
			loc=O.loc
			dir=O.dir
			icon=O.icon
			if(O.icon_state in O.cast_replace)
				O.cast_state="[O.icon_state]-cast"
			icon_state=O.cast_state ? O.cast_state : O.icon_state
			//filters+=filter(type="alpha",icon='MapShadow.dmi')
			color=list(0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0)
			alpha=80
			y_loc=((O.elev_height?O.elev_height : O._height))
			//world<<"[((TILE_WIDTH*(O.x-1))+O.step_x)],[((TILE_HEIGHT*(O.y-1))+O.step_y)+y_loc],[O.z]"
			//setPosition(((TILE_WIDTH*(O.x-1))+O.step_x),((TILE_HEIGHT*(O.y-1))+O.step_y),O.z)
			layer=MOB_LAYER + 1-(y + (-O.base_height)/TILE_HEIGHT)/world.maxy
			//layer=MOB_LAYER + 1-(((O.y-1)+O.step_y)+y_loc + (y_loc)/TILE_HEIGHT)/world.maxy


	MapShadow
		base_layer=MOB_LAYER

		Create(obj/O)
			loc=O
			if(O.shadow)
				O.shadow.destroy=1
				del O.shadow
			dir=O.dir
			icon = O.icon
			icon_state=O.icon_state
			if(O.icon_state in O.edge_replace)
				//O.edge_state="[O.icon_state]-edge"
				icon_state = O.edge_state ? O.edge_state : O.icon_state
			//filters+=filter(type="alpha",icon='MapShadow.dmi')
			color=list(0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0)
			alpha=80
			var/matrix/m=matrix()
			m.Scale(1,-1)
			y_loc=-((O.elev_height?O.elev_height : O._height))
			pixel_y+=4
			transform=m
			O.shadow=src
			setPosition(((TILE_WIDTH*(O.x-1))+O.step_x),((TILE_HEIGHT*(O.y-1))+O.step_y)+y_loc,O.z)
			layer=MOB_LAYER + 1-(O.platform_base.y + (-(O.base_height-4))/TILE_HEIGHT)/world.maxy
			//layer=base_layer + 1-(y + y_plus + (step_y + bound_y + bound_height)/TILE_HEIGHT)/world.maxy




obj
	Obj_Shadow
		icon='Shadow.dmi'
		vis_flags=VIS_UNDERLAY|VIS_INHERIT_LAYER
		destroy=1

		Create(obj/O)
			loc=O
			origin=O
			origin.shadow=src
			Initialize(O)


		Initialize(obj/O)
			O.vis_contents+=src
			SwitchMode(0)


		SwitchMode(t=1)
			set waitfor=0
			if(t>=1)
				while(hang_shadow)
					if(!origin)	break
					sleep(1)
					sleep(-1)
			if(!origin)	return
			//layer=Owner.layer
			if(origin.mid_air)
				hang_shadow=1
				animate(src,pixel_y=-origin.height_gained,time=t,flags=ANIMATION_END_NOW)
				if(t>=1)	sleep(t)
				hang_shadow=0



	Overshadow
		name="Overshadow"
		mouse_opacity=0

		Create(mob/M)
			Owner=M
			M.overshadow=src
			Initialize(M)

		Initialize(mob/M)
			var/mutable_appearance/m_a=new(M)
			m_a.icon_state=""
			m_a.pixel_x=0
			m_a.pixel_y=0
			m_a.plane=1
			appearance=m_a
			color=list(0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,1,0)
			alpha=20
			vis_flags = VIS_INHERIT_ICON|VIS_INHERIT_ICON_STATE|VIS_INHERIT_DIR|VIS_INHERIT_LAYER|VIS_UNDERLAY|VIS_INHERIT_ID
			M.vis_contents+=src
			//M.overlays = M.overlays.Copy() + src

	var/hang_shadow=0

	Shadow
		icon='Shadow.dmi'
		vis_flags=VIS_UNDERLAY|VIS_INHERIT_LAYER

		Create(mob/m)
			loc=m
			Owner=m
			Owner.shadow=src
			Initialize(m)


		Initialize(mob/m)
			m.vis_contents+=src
			SwitchMode()


	proc
		SwitchMode(t=1)
			set waitfor=0
			if(t>=1)
				while(hang_shadow)
					if(!Owner)	break
					sleep(1)
					sleep(-1)
			if(!Owner)	return
			//layer=Owner.layer
			if(Owner.mid_air)
				hang_shadow=1
				animate(src,pixel_y=-Owner.height_gained,time=t,flags=ANIMATION_END_NOW)
				if(t>=1)	sleep(t)
				hang_shadow=0



