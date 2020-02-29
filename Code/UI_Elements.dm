hudobj
	proc
		fade(end_val,t)
			animate(src,alpha=end_val,time=t)

	chatbox
		layer=HUD_LAYER+1
		anchor_x="WEST"
		anchor_y="SOUTH"
		width=352
		height=160
		maptext_width=340
		maptext_height=144
		maptext_x=7
		maptext_y=27
		screen_x=10
		screen_y=10
		maxlifespan=50


		DeActivate()
			fade(0,10)

		Activate(t=10)
			fade(255,t)

	textbox
		layer=HUD_LAYER+1
		icon='Chatbox.dmi'
		icon_state="textbox"
		maptext_height=16
		maptext_width=244
		maptext_x=7
		maptext_y=5
		anchor_x="WEST"
		anchor_y="SOUTH"
		width=256
		height=160
		screen_x=10
		screen_y=15
		mode="all"
		alpha=0
		maptext_default_val="<font size=1 color=#ffffff>"
		maptext_closing_val="</font>"


		Activate()
			client.active_textbox=src
			client.chatbox.Activate()
			message=""
			maptext="[maptext_default_val]_[maptext_closing_val]"
			animate(src,alpha=255,time=10)

		DeActivate()
			maptext=""
			message=""
			client.active_textbox=null
			animate(src,alpha=0,time=10)


	var
		tmp
			mode=""
			maptext_default_val=""
			maptext_closing_val=""
			message=""
			lifespan=0
			maxlifespan=0
			printcount=0


	proc
		Print(msg,txtbox=1)
			animate(src,alpha=255,time=1,flags=ANIMATION_END_NOW)
			//if(txtbox && client?.active_textbox)	client.active_textbox.DeActivate()
			if(!msg)
				Expire(maxlifespan)
				return
			++printcount
			printcount = printcount > 40 ? 0 : printcount
			maptext= printcount == 0 ? "" : maptext
			maptext="[client.chatbox.maptext]\n[msg]"
			if(!client.active_textbox)	Expire(maxlifespan)

		Expire(time=10)
			set waitfor=0
			if(lifespan)
				lifespan=time
				return
			lifespan=time
			while(lifespan>0)
				lifespan--
				if (world.tick_usage > 90)
					lagstopsleep()
				else
					sleep(1)
			DeActivate()

proc
	PrntToClients(mob/m,msg,_txtbox=0,size=1)
		if(istext(m))
			msg=m
			m=null
		if(!msg && m.client)
			if(m.client.chatbox.alpha)
				m.client.chatbox.Expire(m.client.chatbox.maxlifespan)
			return
		msg="<font size=[size]>[msg]</font>"
		if(m)
			if(!m.client)	return
			m.client.chatbox.Print(msg,0)
		else
			for(var/client/c in player_list)
				c.chatbox.Activate(0)
				c.chatbox.Print(msg,_txtbox)

client
	var/tmp/key_repeat=0
	proc
		keyinputrepeat(k)
			set waitfor=0
			for(var/i=0;i<10;i++)
				sleep(1)
				if(k!=currentkey)	break
			if(k!=currentkey)	return
			if(key_repeat)	return
			while(keys[k])
				if(k!=currentkey||!active_textbox)	break
				key_repeat++
				if(key_repeat>=10 && k=="back")
					active_textbox.Activate()
					break
				keyinput(k)
				sleep(1)
			key_repeat=0




		keyinput(k)
			var/append=""
			//if(k=="escape")
			if(!active_textbox)	return
			if(k=="return")
				active_textbox.message=Trim(active_textbox.message," ")
				if(active_textbox.message=="")
					active_textbox.message=""
					chatbox.Print("")
					active_textbox.DeActivate()
					return
				PrntToClients("<b>[src]:</b> [active_textbox.message][active_textbox.maptext_closing_val]")
				active_textbox.DeActivate()
				return

			if(active_textbox.mode=="letters")
				if(k in letters_only)
					append=k
			else if(active_textbox.mode=="numbers")
				if(k in numbers_only)
					append=k
			else
				if(k in all_keys)
					append=k
			if(k=="space")	append=" "
			append= capslock ? uppertext(append) : append
			if(keys["shift"])
				append=uppertext(append)
				if(append in shiftsymbols)
					append=shiftsymbols[append]
			if(k=="back")
				if(length(active_textbox.maptext)>1)
					active_textbox.message="[copytext(active_textbox.message,1,length(active_textbox.message))]"
					active_textbox.maptext="[active_textbox.maptext_default_val][active_textbox.message]_[active_textbox.maptext_closing_val]"
					keyinputrepeat(k)
				return
			active_textbox.message="[active_textbox.message][append]"
			active_textbox.maptext="[active_textbox.maptext_default_val][active_textbox.message]_[active_textbox.maptext_closing_val]"
			keyinputrepeat(k)





