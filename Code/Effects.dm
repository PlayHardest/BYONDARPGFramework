visual_fx
	destroy=1
	density=0
	parent_type=/obj
	var
		flickstate=""
		varname=""

	appearance_flags = PIXEL_SCALE

	AfterImage
		active=1

	AirShockwave
		icon='96x96effects.dmi'
		flickstate="doublejump"
		//icon_state="doublejump"
		pixel_x=-42
		pixel_y=-34
		alpha=200

	Blur
		active=1
		//vis_flags=VIS_INHERIT_ICON|VIS_INHERIT_ICON_STATE|VIS_INHERIT_DIR//|VIS_UNDERLAY
		varname="blur_fx"

	proc
		Timeout(_time)
			set waitfor=0
			if(!Owner)	return
			sleep(_time)
			while(active==2)
				sleep(0)
				sleep(1)
				sleep(-1)
			Owner.vars[varname]=null
			Recycle(e=src)
proc
	Effect_Prep()
		set waitfor=0
		for(var/i=0;i<50;i++)
			var/s=new/visual_fx
			Recycle(e=s,timed=0)
		var/list/l=typesof(/visual_fx/)
		for(var/s in l)
			var/visual_fx/k = new s
			if(!k.icon && !k.active)
				k.destroy=1
				del k
			else
				effect_appearance[k.type]=k


	Recycle(typepath,visual_fx/e=null,timed=1,lease=0)
		if(e)
			if(visual_effects.len>=80)
				e.destroy=1
				del e
			else
				e.appearance=initial(e.appearance)
				e.flickstate=""
				visual_effects+=e
				e.pixel_z=0
				e.Owner=null
				e.loc=null
				e.expire_time=world.realtime+9000
				if(timed)	e.DelayedDestroy()

		else
			var/visual_fx/retval
			if(visual_effects && visual_effects.len)
				retval=visual_effects[max(1,visual_effects.len-1)]
				visual_effects-=retval
			if(!retval)
				retval=new/visual_fx
			if(retval)
				if(typepath)
					var/visual_fx/s=effect_appearance[typepath]
					retval.appearance=s
					retval.flickstate=s.flickstate
				else
					retval.appearance=null
				if(lease)	retval.Timeout(lease)
			return retval

	DoubleJumpfx(mob/m)
		set waitfor=0
		if(!m)	return
		var/visual_fx/I=Recycle(/visual_fx/AirShockwave)
		I.setPosition(m)
		I.layer=m.layer
		flick(I.flickstate,I)
		sleep(7)
		Recycle(e=I)

	AfterImage(mob/m)
		set waitfor=0
		if(!m)	return
		var/visual_fx/I=Recycle(/visual_fx/AfterImage)
		I.appearance=m.appearance
		I.alpha=200
		I.name="Afterimage"
		I.dir=m.dir
		I.setPosition(m)
		animate(I,alpha=0,time=5)
		sleep(5)
		Recycle(e=I)


	Blur(mob/m,_x,_y,_t=10)
		if(!m||(!_x && !_y))	return
		if(!m.blur_fx)
			m.blur_fx=Recycle(/visual_fx/Blur)
			m.blur_fx.render_source=m.render_target
			m.vis_contents+=m.blur_fx
		if(!m.blur_fx.filters.len)
			m.blur_fx.filters+=filter(type="motion_blur",x=0,y=0)
		_x/=2
		_y/=2
		_x=max(min(_x,5),-5)
		_y=max(min(_y,5),-5)
		//world<<"blur at [_x],[_y]"
		m.blur_fx.pixel_x=_x
		m.blur_fx.pixel_y=_y
		animate(m.blur_fx.filters[m.blur_fx.filters.len],x=floor(_x),y=floor(_y),time=_t)


		/*if(!m.filterinfo.blur)
			m.filters+=filter(type="motion_blur",x=0,y=0)
			m.filterinfo.blur=m.filters.len
		animate(m.filters[m.filterinfo.blur],x=floor(_x),y=floor(_y),time=_t)*/


	RemoveBlur(mob/m)
		if(m.blur_fx)
			m.vis_contents-=m.blur_fx
			m.blur_fx.pixel_x=0
			m.blur_fx.pixel_y=0
			m.blur_fx.filters=list()
			Recycle(e=m.blur_fx)
			m.blur_fx=null