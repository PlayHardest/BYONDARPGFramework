#ifndef STDLIB_NOWARN
	#ifdef WARN_TILE_METRICS
		#ifndef STDLIB_WARNINGS
			#define STDLIB_WARNINGS
		#endif

		#warn TILE_WIDTH and TILE_HEIGHT were not specified. This warning can be disabled by #defining TILE_WIDTH and TILE_HEIGHT.
	#endif

	#ifdef WARN_FPS
		#ifndef STDLIB_WARNINGS
			#define STDLIB_WARNINGS
		#endif

		#warn FPS is undefined. Defaulting to 25. This warning can be disabled by #defining FPS.
	#endif

	#ifdef STDLIB_WARNINGS
		#warn Warnings from STDLIB can be silenced by defining STDLIB_NOWARN
	#endif
#endif