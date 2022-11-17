/obj/item/clothing/overwear/coat/drip
	name = "drip"
	icon = 'icons/obj/item/clothing/suit/drip.dmi'

	desc = "By any means necessary."
	desc_extended = "Probably the most expensive clothing you can find. Does it do anything? Probably not."

	is_container = TRUE
	dynamic_inventory_count = 2
	container_max_size = SIZE_2

	size = SIZE_3

	armor = /armor/cloth/hoodie

	rarity = RARITY_LEGENDARY

/obj/item/clothing/overwear/coat/drip/get_base_value()
	. = ..()
	. += 20000