

mob
	Login()
		LocationUpdate()
		ingame=1
		step_size=GetSpeed()
		StateMachine()
		layer=MOB_LAYER
		client.focus=src
		setPosition(704,1152,1)
		//
		icon='Base.dmi'
		icon_state="idle"
		pixel_x=-10
		pixel_y=-2
		bound_height=8
		bound_width=13
		ShadowCreate()
		client.chatbox = new/hudobj/chatbox(null,client,show=1)
		client.chatbox.filters +=filter(type="drop_shadow", x=0, y=-1,size=0, offset=0, color=rgb(3,3,3,170)) //filter(type="outline",size=1)
		client.textbox = new/hudobj/textbox(null,client,show=1)
		client.textbox.filters +=filter(type="drop_shadow", x=0, y=-1,size=0, offset=0, color=rgb(3,3,3,170))
		player_list+=client

mob
	NPC
		icon='BaseNpc.dmi'
		icon_state="idle"
		icon_state="idle"
		pixel_x=-10
		pixel_y=-2
		bound_height=8
		bound_width=13

		New()
			..()
			LocationUpdate()
			ShadowCreate()
//In Login() set ingame to 1