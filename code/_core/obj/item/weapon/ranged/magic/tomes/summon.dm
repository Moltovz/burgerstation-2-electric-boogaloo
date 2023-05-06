/obj/item/weapon/ranged/magic/tome/holy_warrior //TODO:FIX THIS //Or dont
	name = "tome of the holy warrior"
	desc = "For those too lazy for combat."
	desc_extended = "Costs mana to use."
	cost_mana = 100

	icon = 'icons/obj/item/weapons/ranged/magic/tomes/holy_summon.dmi'

	projectile = /obj/projectile/bullet/holy_summon

	shoot_sounds = list('sound/weapons/magic/summon.ogg')

	projectile_speed = 3

/obj/item/weapon/ranged/magic/tome/holy_warrior/get_static_spread() //Base spread
	return 0

/obj/item/weapon/ranged/magic/tome/holy_warrior/get_skill_spread(var/mob/living/L) //Base spread
	return 0
