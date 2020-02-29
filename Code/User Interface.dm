#define HUD_LAYER 10

hudobj
	parent_type = /obj
	layer = HUD_LAYER



	proc
		setSize(W,H)//set the size of a hud element
			width = W//set the width
			height = H//set the height
			if(anchor_x!="WEST"||anchor_y!="SOUTH")//if the anchors are not equal to the south or the west of the screen, update the hud position
				updatePos()//updates the elements position

		setPos(X,Y,AnchorX="WEST",AnchorY="SOUTH")//set the position and anchors of the hud element
			screen_x = X//assigns the values
			anchor_x = AnchorX
			screen_y = Y
			anchor_y = AnchorY
			updatePos()//updates the elements position

		updatePos()//updates the elements position
			var/ax//variable to store the anchor in the x plane
			var/ay//variable to store the anchor in the y plane
			var/ox//variable to store the pixel_x offset of the element
			var/oy//variable to store the pixel_y offset of the element
			switch(anchor_x)//check what is the value of the anchor_x variable
				if("WEST")//if its set to WEST
					ax = "WEST+0"//set the anchor to WEST+0
					ox = screen_x + client.buffer_x//set the offset in the x plane to the specified screen_x value + the buffer zone for the x plane
				if("EAST")//if its set to EAST
					if(width>TILE_WIDTH)//if the element is wider than the TILE_WIDTH value
						var/tx = ceil(width/TILE_WIDTH)//calculate tx, to determine how far out of bounds it is
						ax = "EAST-[tx-1]"//set the anchor to EAST - (tx-1) to make sure the entirety of the element is anchored to the easter border of the screen correctly
						ox = tx*TILE_WIDTH - width - client.buffer_x + screen_x//set the offset in the x_plane to tx*TILE_WIDTH(width) - width - client.buffer_x + screen_x
						//to get the correct location for the x_plane
					else
						ax = "EAST+0"//otherwise
						ox = TILE_WIDTH - width - client.buffer_x + screen_x//set the offset in the x plane to the specified screen_x value + the buffer zone - the width
						//for the x plane
				if("CENTER")
					ax = "CENTER+0"
					ox = floor((TILE_WIDTH - width)/2) + screen_x
			switch(anchor_y)
				if("SOUTH")
					ay = "SOUTH+0"
					oy = screen_y + client.buffer_y
				if("NORTH")
					if(height>TILE_HEIGHT)
						var/ty = ceil(height/TILE_HEIGHT)
						ay = "NORTH-[ty-1]"
						oy = ty*TILE_HEIGHT - height - client.buffer_y + screen_y
					else
						ay = "NORTH+0"
						oy = TILE_HEIGHT - height - client.buffer_y + screen_y
				if("CENTER")
					ay = "CENTER+0"
					oy = floor((TILE_HEIGHT - height)/2) + screen_y
			screen_loc = "[ax]:[ox],[ay]:[oy]"//set the screen_loc to the calculated values

		show()//add src to the client's screen
			updatePos()
			client.screen += src

		hide()//remove src from the client's screen
			client.screen -= src

	New(loc=null,client/Client,list/Params,show=1)
		client = Client
		for(var/v in Params)
			vars[v] = Params[v]
		if(show) show()
