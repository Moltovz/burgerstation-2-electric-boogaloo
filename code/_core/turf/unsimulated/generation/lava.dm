var/global/list/possible_mushrooms = list(
	/obj/structure/interactive/plant/cactus_fruit = 6,
	/obj/structure/interactive/plant/polypore_mushroom = 1,
	/obj/structure/interactive/plant/porcini_mushroom = 1,
	/obj/structure/interactive/plant/inocybe_mushroom = 1,
	/obj/structure/interactive/plant/embershroom_mushroom = 1
)

var/global/list/possible_lavaland_fauna = list(
	/obj/marker/generation/mob/ash_walker = 5,
	/obj/marker/generation/mob/goliath = 10,
	/obj/marker/generation/mob/goliath_ancient = 1,
	/obj/marker/generation/mob/watcher = 5,
	/obj/marker/generation/mob/legion = 5
)
var/global/list/possible_lavaland_decor = list(
	/obj/structure/interactive/basalt = 5,
)

#define PLACE_MUSHROOM var/datum/D__LINE__ = pickweight(possible_mushrooms); new D__LINE__(src)
#define PLACE_LAVALAND_FAUNA var/datum/D__LINE__ = pickweight(possible_lavaland_fauna); new D__LINE__(src)
#define PLACE_LAVALAND_DECOR var/datum/D__LINE__ =pickweight(possible_lavaland_decor); new D__LINE__(src) //not used, I know!

/turf/unsimulated/generation/lava
	name = "lava generation"
	icon_state = "lava"

/turf/unsimulated/generation/lava/generate(var/size = WORLD_SIZE)

	if(no_wall)
		new /turf/simulated/floor/basalt(src)
		return ..()

	if(x <= VIEW_RANGE || x >= world.maxx - VIEW_RANGE || y <= VIEW_RANGE || y >= world.maxy - VIEW_RANGE) //Handle corners.
		new /turf/simulated/hazard/lava(src)
		if(prob(2))
			new /obj/marker/generation/lava(src)
		return ..()

	if(y <= VIEW_RANGE*4 && prob(y - VIEW_RANGE*4)) //Handle lower section.
		new /turf/simulated/floor/basalt(src)
		if(prob(1))
			new /obj/marker/generation/basalt(src)
		return ..()

	var/seed_resolution = max(world.maxx,world.maxy)
	var/x_seed = x / seed_resolution
	var/y_seed = y / seed_resolution

	var/max_instances = 3
	var/noise = 0
	for(var/i=1,i<=max_instances,i++)
		noise += text2num(rustg_noise_get_at_coordinates("[SSturf.seeds[z+i]]","[x_seed]","[y_seed]"))
	noise *= 1/max_instances

	switch(noise) //Lower values means deeper.
		if(-INFINITY to 0.1)
			new /turf/simulated/floor/basalt(src)
			if(prob(5))
				new /obj/marker/generation/lava(src)
		if(0.1 to 0.4)
			if(prob(1))
				new /obj/marker/generation/lava(src)
			else if(prob(1))
				new /obj/marker/generation/ash_floor(src)
				if(prob(1))
					new /obj/marker/generation/mob/ash_walker(src)
			else if(prob(1))
				PLACE_MUSHROOM
			else if(prob(1))
				PLACE_LAVALAND_FAUNA
			new /turf/simulated/floor/basalt(src)

		if(0.4 to 0.5)
			if(prob(1))
				new /obj/marker/generation/lava(src)
			else if(prob(1))
				new /obj/marker/generation/ash_floor(src)
				if(prob(1))
					new /obj/marker/generation/mob/ash_walker(src)
			else if(prob(1))
				PLACE_MUSHROOM
			else if(prob(1))
				PLACE_LAVALAND_FAUNA
			new /turf/simulated/floor/basalt(src)

		if(0.5 to 0.7)
			if(prob(3))
				PLACE_MUSHROOM
			else if(prob(1))
				PLACE_LAVALAND_FAUNA
			else if(prob(1))
				new /obj/marker/generation/basalt_wall(src)
			else if(prob(1))
				new /obj/marker/generation/ash_wall(src)
			new /turf/simulated/floor/basalt(src)

		if(0.7 to 0.8)
			if(prob(3))
				PLACE_MUSHROOM
			else if(prob(1))
				PLACE_LAVALAND_FAUNA
			else if(prob(1))
				new /obj/marker/generation/lava(src)
			else if(prob(1))
				new /obj/marker/generation/basalt_wall(src)
			else if(prob(1))
				new /obj/marker/generation/ash_wall(src)
			new /turf/simulated/floor/basalt(src)

		if(0.8 to INFINITY)
			if(prob(1))
				new /obj/marker/generation/mob/goliath(src)
			else if(prob(1))
				PLACE_MUSHROOM
			else if(prob(1))
				new /obj/marker/generation/ash_wall(src)
			else if(prob(0.1))
				new /obj/marker/generation/basalt(src)
			new /turf/simulated/wall/rock/basalt(src)



	return ..()

/*
/turf/unsimulated/generation/lava_deep
	name = "deep lava generation"
	icon_state = "lava"

/turf/unsimulated/generation/lava_deep/generate(var/size = WORLD_SIZE)

	if(no_wall)
		new /turf/simulated/floor/basalt(src)
		return ..()

	var/seed_resolution = max(world.maxx,world.maxy)
	var/x_seed = x / seed_resolution
	var/y_seed = y / seed_resolution

	var/max_instances = 3
	var/noise = 0
	for(var/i=1,i<=max_instances,i++)
		noise += text2num(rustg_noise_get_at_coordinates("[SSturf.seeds[z+i]]","[x_seed]","[y_seed]"))
	noise *= 1/max_instances

	switch(noise) //Lower values means deeper.
		if(-INFINITY to 0.1)
			new /turf/simulated/hazard/lava(src)
		if(0.1 to 0.2)
			new /turf/simulated/floor/basalt(src)
			if(prob(1))
				new /obj/marker/generation/lava(src)
		if(0.2 to 0.4)
			new /turf/simulated/hazard/lava(src)
			if(prob(1))
				new /obj/marker/generation/basalt(src)
		if(0.4 to 0.6)
			new /turf/simulated/floor/basalt(src)
			if(prob(1))
				new /obj/marker/generation/basalt_wall(src)
		if(0.6 to 0.8)
			new /turf/simulated/hazard/lava(src)
			if(prob(1))
				new /obj/marker/generation/basalt_wall(src)
		if(0.8 to INFINITY)
			new /turf/simulated/wall/rock/basalt(src)

	return ..()
*/
