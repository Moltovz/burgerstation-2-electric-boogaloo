/obj/structure/interactive/horde_beacon
    name = "horde beacon"
    desc = "mmmmh.... bacon...."
    desc_extended = "A beacon that summons hordes of enemies. Draw them out by placing their currency inside."
    icon = 'icons/obj/structure/horde_beacon.dmi'
    icon_state = "beacon"

/obj/structure/interactive/horde_beacon/New(var/desired_loc)
	. = ..()
	update_sprite()
	set_text("20 Targets")

/obj/structure/interactive/horde_beacon/proc/set_text(var/desired_text)
    maptext = "<center valign='middle'>[desired_text]</center>"
    maptext_y = 15
    return TRUE
