/obj/item/weapon/ranged/magic/gem/
	name = "magic gem"
	desc = "yeah ok"
	desc_extended = "a magical gem"

	icon = 'icons/obj/item/weapons/ranged/magic/tomes/gem.dmi'

	has_quick_function = TRUE

	weight = 4

/obj/item/weapon/ranged/magic/gem/get_shoot_delay(var/mob/caller,var/atom/target,location,params)

	. = ..()

	if(caller.health)
		. *= clamp(0.5 + (100/max(10,caller.health.mana_current))*0.5,0.5,4)

	. = max(.,2)


/obj/item/weapon/ranged/magic/gem/get_static_spread()
	return 0

/obj/item/weapon/ranged/magic/gem/get_skill_spread(var/mob/living/L)
	return 0

/obj/item/weapon/ranged/magic/gem/quick(var/mob/caller,var/atom/object,location,params)
	return shoot(caller,object,location,params)

/obj/item/weapon/ranged/magic/gem/proc/get_mana_cost(var/mob/living/caster)
	return cost_mana

/obj/item/weapon/ranged/magic/gem/get_owner()

	if(is_inventory(src.loc))
		var/obj/hud/inventory/I = src.loc
		return I.owner

	return null

/obj/item/weapon/ranged/magic/gem/can_gun_shoot(var/mob/caller)

	if(get_ammo_count() < 1)
		return FALSE

	return ..()

/obj/item/weapon/ranged/magic/gem/get_ammo_count()

	var/mob/living/owner = get_owner()

	if(!owner)
		return 0

	if(!owner.health)
		return 1

	var/actual_mana_cost = get_mana_cost(owner)

	if(!actual_mana_cost)
		return 1

	return owner && actual_mana_cost ? FLOOR(owner.health.mana_current / actual_mana_cost, 1) : 0


/obj/item/weapon/ranged/magic/gem/handle_ammo(var/mob/caller,var/bullet_position=1)

	if(!is_advanced(caller))
		return ..()

	var/mob/living/advanced/A = caller
	if(!A.health)
		return ..()

	var/mana_cost = get_mana_cost(A)

	A.health.adjust_mana(-mana_cost)

	A.mana_regen_delay = max(A.mana_regen_delay,30)

	return null
