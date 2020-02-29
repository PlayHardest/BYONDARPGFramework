/*
For adding colored hair, we would alter an independent mutable_appearance's color var and keep track of it and apply it to the overlays instead of the base item's
normal appearance

Sleep(x)
	There is also a special case use for sleep(), which is important to note. The current frame may have other pending tasks queued up. If you want to delay something until
	the currently queued tasks are done processing, you can use sleep(0), or just sleep() to delay the current proc until after tasks scheduled in the current frame.

	Another interesting use of sleep(), is calling sleep() with a negative value as the argument. This will cause BYOND to check if there are other functions in the queue
	that should already have already been finished. If the scheduler is in overrun according to this check, it will suspend processing of the current function for the
	shortest time possible (which is the tick_lag value) to allow other events to finish their work. You can use this quirk to make heavy-duty loops not freeze BYOND
	completely while they do their work.

Code Interfaces : http://www.byond.com/forum/post/1810596
	This approach isn't something I'd recommend using ALL the time, but if you find yourself seriously needing multiple-inheritance-like structures in DM, this is one way
	to go about it. There are definite cons to this approach compared to the other two approaches I showed, though. This approach isn't "the best", it's just one option. I
	think it's a good option in specific cases, but not the be-all-end-all for how to approach multiple-inheritance-like logic.

Spawn(x)
	All of the code that gets tabbed under a spawn() block will be treated like an unnamed inline function and be executed at a later, specified time. As such,
	the scheduler will put it in line based on the value you feed to spawn as the argument.
	There is also some interesting special case behavior here much like sleep(). If you feed spawn() 0, the inline function will execute right after the current frame's
	scheduled procs sitting in the queue.
	If you feed spawn() a negative value, on the other hand, the inline function is executed immediately before continuing in the current proc. This will treat the inline
	function like a blocking proc, which is honestly not something that there is much actual use for. Often, it's better to not use this quirk, and I can't think of any
	reasons to actually use it.


Appearance Churn :
	When you want to add a value to the overlays/underlays do :

		overlays = overlays.Copy()+'herp.dmi'-'derp.dmi'-'herpy.dmi'+'derpy.dmi'


	When you want to define an object with overlays, instead of adding them in New() do :

		turf
	    	overlays = list('someoverlay.dmi')


	Take advantages of mutable_appearances when changing several appearance values at once to save on appearance churn :

		var/mutable_appearance/m = src.appearance
		m.overlays += 'herp.dmi'
		m.underlays += 'derp.dmi'
		m.maptext = "<span class='combat'>[maptext]"
		m.icon_state += "1"
		src.appearance = m

		**********************************************************
		N.B. - Do no set color and alpha in the mutable_appearance
		**********************************************************


Look up :
-Regular Expressions
-Argument Expanding
-Database datum
in the documentation and apply them

ToDo :
-Code Inverse collision behaviour with platforms (Done)
-Solve the layering issue with platforms

==================================================
list.Find(null) locates an empty index in the list
==================================================
*/