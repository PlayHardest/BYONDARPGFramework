#ifdef JUMP
atom
	movable
		proc
			SlopeTravel()
				if(!canMove && !travel_distance)	return
				if(slope_obj)
					var/rel_height=RelHeightLoc(slope_obj,src,elevated=1)
					if(rel_height!=last_slope_height)//only follow through if the user has made a move up or down the slope"
						if(movement_dir & slope_obj.slope_dir)
							if(rel_height-last_slope_height>=0)
								if(!mid_air)	StepHeightIncrease(rel_height-last_slope_height,0,0,_time=(1/step_size)*2,end_now=1)
								last_slope_height = rel_height
								elevation = rel_height
						else if(movement_dir & slope_obj.slope_opp_dir)
							if(rel_height-last_slope_height<0)
								if(!mid_air)	StepHeightIncrease(rel_height-last_slope_height,0,0,_time=(1/step_size)*2,end_now=1)
								last_slope_height = rel_height
								elevation = rel_height
						height_gained=0
						if(src:shadow)	src:shadow.SwitchMode()

proc
	RelHeightLoc(obj/slope,atom/movable/m,elevated=0,instance="",step=0)//calculates the height of an object relative to the players current location on it
		if(!m || !slope)	return//if no movable or obj is supplied return
		if(slope.slope_start<0)//if the slope starts at a negative value(i.e - not a slope)
			if(elevated)//check if its elevated
				return slope._height+slope.elevation//if it is, return the slope's height + elevation
			else//otherwise
				return slope._height//return the slope's height
		m.LocationUpdate()
		var/x_diff=slope.gx-m.gx,y_diff=slope.gy-m.gy,retval=0//declare x_diff,y_diff and retval
		//x_diff is the difference between the global_x locations of the slope and movable;
		//y_diff is the difference between the global_y locations of the slope and movable;
		if(m.dir & NORTH)	y_diff = step ? slope.gy-(m.gy+m.bound_height+m.step_size) : slope.gy-(m.gy+m.bound_height)
		if(m.dir & EAST)	x_diff = step ? slope.gx-(m.gx+m.bound_width+m.step_size) : slope.gx-(m.gx+m.bound_width)
		if(m.dir & SOUTH)	y_diff = step ? slope.gy-(m.gy-m.step_size) : slope.gy-m.gy
		if(m.dir & WEST)	x_diff = step ? slope.gx-(m.gx-m.step_size) : slope.gx-m.gx
		switch(slope.slope_dir)//check the direction that the slope is inclining in
			if(NORTH)//if north
				if(y_diff<0)//if the y_diff is less than zero
					y_diff= abs(y_diff) > slope.bound_height ? slope.bound_height : y_diff//if the absolute value of y_diff is greater than the distance to be travelled
					//until the top of the slope is reached set y_diff to the bound_height, otherwise, it remains unchanged
				else
					y_diff= y_diff < slope.bound_height ? slope.bound_height : y_diff//
					y_diff=abs(slope.bound_height-abs(y_diff))
				retval=floor((abs(y_diff)/slope.bound_height)*(slope._height-slope.slope_start))//cur/max_dist*height-starting height||50/100*(32-16)
			if(SOUTH)
				if(y_diff>0) //if the user is coming from the opposite side
					y_diff=slope.bound_height//make it as tall as possible
				else
					y_diff= y_diff < -slope.bound_height ? -slope.bound_height : y_diff//if they are approaching from the front, make it as low as possible if necessary
					y_diff=abs(slope.bound_height-abs(y_diff))
				retval=floor((abs(y_diff)/slope.bound_height)*(slope._height-slope.slope_start))//cur/max_dist*height-starting height||50/100*(32-16)
			if(EAST)
				if(x_diff<0)//is ontop of it
					x_diff=abs(x_diff)>slope.bound_width ? slope.bound_width : x_diff
				else
					x_diff= x_diff < slope.bound_width ? slope.bound_width : x_diff
					x_diff=abs(slope.bound_width-abs(x_diff))
				retval=floor((abs(x_diff)/slope.bound_width)*(slope._height-slope.slope_start))
			if(WEST)
				/*x_diff = x_diff>0 ? 0 : abs(x_diff)
				x_diff = x_diff>slope.bound_width ? slope.bound_width : x_diff
				retval=floor((abs(x_diff)/slope.bound_width)*(slope._height-slope.slope_start))*/

				if(x_diff>0) //if the user is coming from the opposite side (user is on the slope
					x_diff=slope.bound_width//make it as tall as possible
				else
					x_diff= x_diff < -slope.bound_width ? -slope.bound_width : x_diff//if they are approaching from the front, make it as low as possible if necessary
					x_diff=abs(slope.bound_width-abs(x_diff))
				retval=floor((abs(x_diff)/slope.bound_width)*(slope._height-slope.slope_start))//cur/max_dist*height-starting height||50/100*(32-16)
		retval+=slope.slope_start//add back on the minimum height
		retval = elevated ? retval + slope.elevation : retval
		return retval

#endif
