/obj/item/soulgem
	name = "bluespace gem"
	desc = "Holds the souls of lesser beings. Not to be confused with bluespace crystals."
	desc_extended = "Used in enchanting items or refilling the magic of staves."
	icon = 'icons/obj/item/soulgem.dmi'
	icon_state = "common"

	var/total_charge = 0
	var/total_capacity = 0

	var/atom/movable/object_to_summon
	var/duration = SECONDS_TO_DECISECONDS(300) //In deciseconds. Only applies to summoning mobs.

	var/do_not_consume = FALSE //Does this get consumed? Or merely emptied on craft. Only used for Azuras Star

	value = 100 //Dummy value. Calculated later.

	weight = 1

	rarity = RARITY_COMMON



/obj/item/soulgem/save_item_data(var/mob/living/advanced/player/P,var/save_inventory = TRUE,var/died=FALSE,var/loadout=FALSE)
	RUN_PARENT_SAFE
	SAVEVAR("total_charge")

/obj/item/soulgem/load_item_data_pre(var/mob/living/advanced/player/P,var/list/object_data,var/loadout=FALSE)
	RUN_PARENT_SAFE
	LOADVAR("total_charge")

/obj/item/soulgem/Finalize()
	. = ..()

	if(!total_capacity)
		if(total_charge)
			total_capacity = total_charge
		else
			total_capacity = SOUL_SIZE_COMMON

	update_sprite()

/obj/item/soulgem/get_base_value()
	. = ..()
	. += (total_charge/16)**1.5
	. += (total_capacity/32)**1.5

/obj/item/soulgem/get_examine_list(var/mob/caller)
	return ..() + span("notice","It has [total_charge] total charge.")

/obj/item/soulgem/update_sprite()
	. = ..()
	name = initial(name)
	icon = initial(icon)
	if(do_not_consume)
		name = "unbreaking [name]"
		icon_state = "azuras"
		rarity = RARITY_LEGENDARY
	else
		switch(total_capacity)
			if(0 to SOUL_SIZE_COMMON)
				name = "common [name]"
				icon_state = "common"
				rarity = RARITY_COMMON
			if(SOUL_SIZE_COMMON to SOUL_SIZE_UNCOMMON)
				name = "uncommon [name]"
				icon_state = "uncommon"
				rarity = RARITY_UNCOMMON
			if(SOUL_SIZE_UNCOMMON to SOUL_SIZE_RARE)
				name = "rare [name]"
				icon_state = "rare"
				rarity = RARITY_RARE
			if(SOUL_SIZE_RARE to SOUL_SIZE_MYSTIC)
				name = "mystic [name]"
				icon_state = "mystic"
				rarity = RARITY_MYTHICAL
			if(SOUL_SIZE_MYSTIC to INFINITY)
				name = "godly [name]"
				icon_state = "godly"
				rarity = RARITY_LEGENDARY
	if(total_charge > 0)
		switch(total_charge)
			if(0 to SOUL_SIZE_COMMON)
				name = "[name] (common)"
			if(SOUL_SIZE_COMMON to SOUL_SIZE_UNCOMMON)
				name = "[name] (uncommon)"
			if(SOUL_SIZE_UNCOMMON to SOUL_SIZE_RARE)
				name = "[name] (rare)"
			if(SOUL_SIZE_RARE to SOUL_SIZE_MYSTIC)
				name = "[name] (mystic)"
			if(SOUL_SIZE_MYSTIC to INFINITY)
				name = "[name] (godly)"
		icon_state = "[icon_state]_1"
	else
		name = "[name] (empty)"


//existing code for filling gems with souls
/obj/item/soulgem/click_on_object(var/mob/caller as mob,var/atom/object,location,control,params)
	if(istype(object,/obj/effect/temp/soul))
		if(total_charge != 0)
			caller.to_chat(span("warning","You need an empty soul gem in order to capture souls!"))
			return TRUE

		var/obj/effect/temp/soul/S = object
		caller.visible_message(span("danger","DEBUG, [S.soul_size]")) //what size is the soul
		if(S.qdeleting || !S.soul_size)
			return TRUE

		total_charge = min(S.soul_size,total_capacity)
		caller.visible_message(span("danger","\The [caller.name] traps \the [S.name] with \the [src.name]!"),span("warning","You trap \the [S.name] with \the [src.name]!"))
		if(is_living(caller))
			var/mob/living/L = caller
			L.add_skill_xp(SKILL_SUMMONING,CEILING(S.soul_size*0.01,1))
		qdel(S)
		update_sprite()

		return TRUE

//for capturing a living creature with a filled soul gem
	if(istype(object,/mob/living/simple)) //THIS CODE IS LIKE THIS BECAUSE I WAS SEEING IF CLICKONOBJECT WAS BROKEN
		var/mob/living/simple/M = object
		caller.visible_message(span("danger","DEBUG, YOU ARE CLICKING A [object] WITH THE [src.name]"))
		if(is_living(M))
			if(total_charge != total_capacity)
				caller.visible_message(span("danger","You need a filled soulgem to capture a creature!"))
				return FALSE
			if(is_living(caller))
				object_to_summon = M.type
				caller.visible_message(span("danger","\The [caller.name] traps \the [M.name] with \the [src.name]!"),span("warning","You contain \the [M.name] within \the [src.name]!"))
				var/mob/living/L = caller
				L.add_skill_xp(SKILL_SUMMONING,CEILING(M.soul_size*0.01,1))
		qdel(M)
		caller.visible_message(span("danger","DEBUG: [object_to_summon]"))
		return TRUE

//for summoning with a captured mob
	if(istype(object,/turf/simulated/))
		caller.visible_message(span("danger","DEBUG: [object_to_summon] stored"))
		var/turf/simulated/T = object
		if(total_charge != total_capacity)
			caller.visible_message(span("danger","FLOOR CLICKED WITH A NON FILLED GEM"))
			return FALSE

		if(object_to_summon)
			var/mob/living/simple/S = object_to_summon
//
			caller.visible_message(span("danger","FLOOR CLICKED WITH FILLED GEM"))
			caller.visible_message(span("danger","STORED PATH [S]"))
//
			caller.visible_message(span("danger","You summon the [src.object_to_summon.name] with the [src.name]!"))
			caller.visible_message(span("danger","FLOOR LOCATION [T]"))
//actually summoning the cunt
			caller.visible_message(span("danger","DEBUG [S] BEFORE")) //everything after this doesnt work
			S = new S(T)
			caller.visible_message(span("danger","DEBUG [S] AFTER S = new S(T)"))
			INITIALIZE(S)
			caller.visible_message(span("danger","DEBUG [S] AFTER INITIALIZE"))
			GENERATE(S)
			caller.visible_message(span("danger","DEBUG [S] AFTER GENERATE"))
			FINALIZE(S)
			caller.visible_message(span("danger","DEBUG [S] AFTER FINALIZE"))
			caller.visible_message(span("danger","DEBUG S.LOC: [S.loc]"))

			return TRUE
		return TRUE

//for refilling a staff
	if(istype(object,/obj/item/weapon/ranged/magic/staff/))

		INTERACT_CHECK
		INTERACT_CHECK_OBJECT
		INTERACT_DELAY(1)

		var/obj/item/weapon/ranged/magic/staff/W = object
		if(total_charge)
			caller.visible_message(span("notice","\The [caller.name] recharges \the [W.name] with \the [src.name]."),span("notice","You charge \the [W] with \the [src]."))
			W.total_charge += total_charge
			total_charge -= total_charge
			if(is_living(caller))
				var/mob/living/L = caller
				L.add_skill_xp(SKILL_SUMMONING,CEILING(total_charge*0.0025,1))
			if(!do_not_consume && total_charge <= 0)
				caller.to_chat(span("warning","\The [src] shatters!"))
				qdel(src)
		else
			caller.to_chat(span("warning","\The [src] is empty!"))
		update_sprite()

		return TRUE



/*
	if(istype(object,/mob/living/simple))

		var/mob/living/simple/S = object
/*
		if(total_charge != 0)
			var/response = input(caller,"You are about to use \The [src.name] to capture a summon, this will delete the filled gem! Do you want to continue?") as null|anything in list("Continue","Cancel")
			if(response != "Continue")
				caller.to_chat(span("thought","You decide not to capture the [S.name]"))
				return TRUE
			return FALSE
*/
		caller.visible_message(span("danger","\The [caller.name] traps \the [S.name] with \the [src.name]!"),span("warning","You contain \the [S.name] within \the [src.name]!"))

		if(is_living(caller))
			var/mob/living/L = caller
			L.add_skill_xp(SKILL_SUMMONING,CEILING(S.soul_size*0.01,1))
		qdel(S)
		qdel(src)

		var/obj/item/weapon/ranged/magic/gem/summon/g
		summonmob.object_to_summon = S
		INITIALIZE(summonmob)
		GENERATE(summonmob)
		FINALIZE(summonmob)
		new g(caller.loc)
		return TRUE
*/

//WND OF CAPTURING MOBS FOR SUMMONING

	return ..()

/obj/item/soulgem/proc/spawn_mob(var/atom/A, var/turf/T)
	var/obj/item/soulgem/L = new src.object_to_summon(get_turf(src))
	INITIALIZE(L)
	GENERATE(L)
	FINALIZE(L)

/obj/item/soulgem/common
	total_capacity = SOUL_SIZE_COMMON

/obj/item/soulgem/common/filled/Generate()
	. = ..()
	total_charge = total_capacity

/obj/item/soulgem/uncommon
	total_capacity = SOUL_SIZE_UNCOMMON

/obj/item/soulgem/uncommon/filled/Generate()
	. = ..()
	total_charge = total_capacity

/obj/item/soulgem/rare
	total_capacity = SOUL_SIZE_RARE

/obj/item/soulgem/rare/filled/Generate()
	. = ..()
	total_charge = total_capacity

/obj/item/soulgem/mystic
	total_capacity = SOUL_SIZE_MYSTIC

/obj/item/soulgem/mystic/filled/Generate()
	. = ..()
	total_charge = total_capacity

/obj/item/soulgem/godly
	total_capacity = SOUL_SIZE_GODLY
	value_burgerbux = 1

/obj/item/soulgem/godly/filled/Generate()
	. = ..()
	total_charge = total_capacity

/obj/item/soulgem/azuras_star
	total_capacity = SOUL_SIZE_MYSTIC
	do_not_consume = TRUE
