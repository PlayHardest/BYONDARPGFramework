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
	/*
	0.15,0.15,0.15,0
	0.15,0.15,0.15,0
	0.15,0.15,0.15,0
	0   ,0   ,   0,1

	1,1,1,0		1,1,1,0
	1,1,1,0		1,1,1,0
	1,1,1,0		1,1,1,0
	0,0,0,1		0,0,0,1

	NB - IN THE MATRIX OPERATIONS CODE DEFINED BELOW, MULTI DIMENSIONAL LISTS ARE REPRESENTED AS :

	LIST[Y][X]
	*/
	C_MatrixMultiplication(list/A,A_col=4,A_row=4,list/B,B_col=4,B_row=4,opaque=1)
		if(!A||!B||!A_col||!B_col||!A_row||!B_row)	CRASH("What the hell are you doing?")
		if(A_row!=B_row || A_col!=B_col)	CRASH("Both matrices must be of the same size")
		var/list/C[A_col][A_row]
		var/newval,_x,_y,list/retval
		//first, convert them into multi-dimensional lists for ease of use
		var/list/_A[A_col][A_row]
		_A=List_to_multi(A,A_col,A_row)
		var/list/_B[B_col][B_row]
		_B=List_to_multi(B,B_col,B_row)
		//start at the location you would like to place the result, the top left corner
		for(var/y=A_col; y>0; y--)//start at the top row
			for(var/x=1; x<A_row+1; x++)//start at the left most value
				newval=0
				_y=A_col
				_x=1
				while(_y>0 && _x<=A_row)//find the dot product
					//world<<"adding [_A[y][_x]]*[_B[_y][x]] to [newval]"
					newval+=_A[y][_x]*_B[_y][x]
					_x++
					_y--
				world<<"[newval], \..."
				C[y][x]=newval//assign the new value to the location
			world<<""
		//C[1][4]=C[1][4]?C[1][4]:1
		retval=Multi_to_list(C,A_row,B_row)
		return retval



	List_to_multi(list/L,rows=1,cols=1)
		var/list/M[rows][cols]
		for(var/i=rows;i>0;i--)
			for(var/a=1;a<=cols;a++)
				M[i][a]=L[(abs(i-rows)*cols)+a]
				//world<<"L to M))M([i])([a])=[M[i][a]] || L([(abs(i-rows)*cols)+a])=[L[(abs(i-rows)*cols)+a]]"
				//y, x
		return M

	Multi_to_list(list/M,rows=1,cols=1)
		var/list/L[rows*cols]
		for(var/i=rows;i>0;i--)
			for(var/a=1;a<=cols;a++)
				L[(abs(i-rows)*cols)+a]=M[i][a]
				//world<<"M to L))M([i])([a])=[M[i][a]] || L([(abs(i-rows)*cols)+a])=[L[(abs(i-rows)*cols)+a]]"
		return L

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


	Blur(mob/m,_x,_y,_t=10,p_x=0,p_y=0,pix_offset=1,pix_anim=0)
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
		if(pix_offset)
			p_x = p_x ? p_x : _x
			p_y = p_y ? p_y : _y
		//world<<"blur at [_x],[_y]"
		if(pix_anim)
			animate(m.blur_fx,pixel_x=p_x,pixel_y=p_y,time=_t)
			animate(m.blur_fx.filters[m.blur_fx.filters.len],x=floor(_x),y=floor(_y),time=_t,flags=ANIMATION_PARALLEL)
		else
			world<<"[p_x],[p_y]"
			m.blur_fx.pixel_x=p_x
			m.blur_fx.pixel_y=p_y
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