client
	var//declare the vars to determine the size
		view_width//the width of the viewable portion of the map
		view_height//the height of the viewable portion of the map
		buffer_x//the width of the buffer zone of the map that is not displayed in the viewport
		buffer_y//the height of the buffer zone of the map that is not displayed in the viewport
		map_zoom//the zoom value of the map

		//browser_loaded = 0//

	verb
		/*onLoad()//ran when the client is loaded
			set hidden = 1//hidden from normal access through the displayed verbs
			browser_loaded = 1//flag to show that the browser has been loaded
			src << output(null,"browser1:CenterWindow")//calls the CenterWindow() proc within mapbrowser.html and passes null into it as an argument
			winset(src,null,"window1.is-maximized=true")
			//src<< output(null,"browser1:ToggleFullscreen")//calls the ToggleFullscreen() proc within mapbrowser.html and passes null into it as an argument
			eye=mob*/

		onResize(map as text|null,size as text|null)
			set hidden=1
			set instant = 1
			var/list/sz = splittext("[size]","x")
			var/map_width = text2num(sz[1]),map_height = text2num(sz[2])
			map_zoom = 1
			view_width = ceil(map_width/TILE_WIDTH)
			if(!(view_width%2)) ++view_width
			view_height = ceil(map_height/TILE_HEIGHT)
			if(!(view_height%2)) ++view_height
			while(view_width*view_height>MAX_VIEW_TILES)
				view_width = ceil(map_width/TILE_WIDTH/++map_zoom)
				if(!(view_width%2)) ++view_width
				view_height = ceil(map_height/TILE_HEIGHT/map_zoom)
				if(!(view_height%2)) ++view_height
			buffer_x = floor((view_width*TILE_WIDTH - map_width/map_zoom)/2)
			buffer_y = floor((view_height*TILE_HEIGHT - map_height/map_zoom)/2)
			src.view = "[view_width]x[view_height]"
			winset(src,map,"zoom=[map_zoom];")

	New()
		.=..()
		InitView()

	proc
		InitView()
			set waitfor = 0
			sleep(1)
			winset(src,null,"window1.is-maximized=true")
			//var/list/l = params2list(winget(src,":map","id;size;"))
			//onResize(l["id"],l["size"])

		/*onResize(VW as num,VH as num,BX as num,BY as num,Z as num)//called when the window is resized
			set hidden = 1
			if(VW*VH>MAX_VIEW_TILES) return//if the total amount of tiles in view is greater than the allowed maximum amount then return from the verb call
			view_width = VW//otherwise set view_width to VW
			view_height = VH//and set view_height to VH
			buffer_x = BX//set buffer_x to BX
			buffer_y = BY//set buffer_y to BY
			map_zoom = Z//and set the map_zoom to Z
			view = "[VW]x[VH]"//set the client.view to VWxVH
			for(var/hudobj/h in screen)
				h.updatePos()

	New()//when a client is created
		spawn()//call spawn(), causing the inline function to execute right after the current frame's scheduled procs sitting in the queue
			while(!browser_loaded)//while the browser_loaded flag is not enabled
				src << browse('mapbrowser.html',"window=browser1")//this sends the mapbrowser.html file to the client and then displays it in the browser1 control
				sleep(50)//sleep for 5 seconds
		..()
		eye=null*/
