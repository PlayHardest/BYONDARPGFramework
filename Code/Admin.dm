#ifdef ADMIN
atom
	Click()
		usr.VarView(src)

mob
	proc
		VarView(datum/m)
			var/varval=input("Enter the var.")as text|null//client.focus
			switch(varval)
				if("/effects")
					for(var/l in effect_appearance)
						src<<l
					return
				if("/locate")
					var/val=input("Enter the tag of the thing you want to locate")as text|null
					var/s = locate(val)
					if(s)
						varval=input("Enter the var of the found object [s]")as text|null
						m=s
					else
						src<<"Nothing was found"
						return
				if("relheight")
					if(isobj(m))
						src<<"\..."
						#ifdef JUMP
						src<<"RelHeight = [RelHeightLoc(m,src,elevated=1)]"
						#endif
						return
				if("/stepheight")
					var/val=input("Enter the time for the animation")as num|null
					StepHeightIncrease(32,_time=val,end_now=1)
				if("moveto")
					if(ismob(m))
						//Walk(m,EAST)
						Move_To(m,_speed=45,homing=1)//,_readjust=1)
						return
				if("/del")
					del m
					return
				if("/bounds")
					src<<"[m]'s bounds contains : \..."
					for(var/atom/movable/s in bounds(m)-m)
						src<<"[s]|\..."
					src<<""
					return
				if("/layerfind")
					if(ismovable(m))
						var/atom/movable/M=m
						M.LocationUpdate()
						src<<"[M.layer]=[M.base_layer] + [1]-([M.y] + ([M.step_y] + [M.bound_y] + ([M.bound_height]+[M.layer_add]))/[TILE_HEIGHT])/[world.maxy]::[M.base_layer + 1-(M.y + (M.step_y + M.bound_y + (M.bound_height+M.layer_add))/TILE_HEIGHT)/world.maxy]"
			var/x=findtext(varval,".")
			while(x!=0)
				var/_varval=(copytext(varval,1,x))//client
				m=m.vars[_varval]
				varval=copytext(varval,x+1,0)//focus
				x=findtext(varval,".")
			if(varval in m.vars)
				if(islist(m.vars[varval]))
					var/list/varlist=m.vars[varval]
					src<<"<font size=0>[m]:[varval]=\..."//output to admin window
					for(var/v in varlist)
						src<<"[v] , \..."
					src<<"|"
				else
					if(varval in m.vars)
						src<<"[m]:[varval] = [m.vars[varval]]||[initial(m.vars[varval])]"
#endif