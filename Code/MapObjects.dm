
obj
	MapObjects
		//layer_add=5
		density=1

		New()
			..()
			if(!no_layer)
				base_layer=MOB_LAYER
				LocationUpdate()
			ShadowCreate()