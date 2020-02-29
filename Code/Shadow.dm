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
					Object_Pool(/obj/MapShadow,creation_params=O)








obj
	MapShadow
		vis_flags = VIS_INHERIT_ICON|VIS_INHERIT_ICON_STATE|VIS_INHERIT_DIR|VIS_INHERIT_LAYER|VIS_UNDERLAY
		blend_mode=BLEND_MULTIPLY

		Create(obj/O)
			loc=O
			if(O.shadow)
				O.shadow.destroy=1
				del O.shadow
			O.vis_contents=list()
			color=list(0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0)
			alpha=120
			layer=O.layer
			var/matrix/m=matrix()
			m.Scale(1,-1)
			//m.Translate(0,-((O.elev_height?O.elev_height : O._height)-1))
			pixel_y=-((O.elev_height?O.elev_height : O._height)-1)
			//CALCULATE THE SHADOW'S LAYER PER TILE USING LOCATIONUPDATE'S METHOD FOR LAYER CALCULATION
			//layer=base_layer + 1-(y + y_plus + (step_y + bound_y + bound_height)/TILE_HEIGHT)/world.maxy
			transform=m
			O.shadow=src
			O.vis_contents+=src


	Overshadow
		name="Overshadow"
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
			vis_flags = VIS_INHERIT_ICON|VIS_INHERIT_ICON_STATE|VIS_INHERIT_DIR|VIS_INHERIT_LAYER
			M.vis_contents+=src
			//M.overlays = M.overlays.Copy() + src

	var/hang_shadow=0

	Shadow
		icon='Shadow.dmi'
		vis_flags=VIS_UNDERLAY

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
				animate(src,pixel_y=-Owner.height_gained,time=t)//,flags=ANIMATION_END_NOW)
				if(t>=1)	sleep(t)
				hang_shadow=0



