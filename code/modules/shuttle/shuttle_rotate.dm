/*
All shuttleRotate procs go here

If ever any of these procs are useful for non-shuttles, rename it to proc/rotate and move it to be a generic atom proc
*/

/************************************Base proc************************************/

/atom/proc/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	if(params & ROTATE_DIR)
		//rotate our direction
		setDir(angle2dir(rotation+dir2angle(dir)))

		QUEUE_SMOOTH(src) //resmooth if need be.

	//rotate the pixel offsets too.
	if((pixel_x || pixel_y) && (params & ROTATE_OFFSET))
		if(rotation < 0)
			rotation += 360
		for(var/turntimes=rotation/90;turntimes>0;turntimes--)
			var/oldPX = pixel_x
			var/oldPY = pixel_y
			pixel_x = oldPY
			pixel_y = (oldPX*(-1))

/************************************Turf rotate procs************************************/

/turf/closed/mineral/shuttleRotate(rotation, params)
	params &= ~ROTATE_OFFSET
	return ..()

/************************************Mob rotate procs************************************/

//override to avoid rotating pixel_xy on mobs
/mob/shuttleRotate(rotation, params)
	params = NONE
	. = ..()
	if(!buckled)
		setDir(angle2dir(rotation+dir2angle(dir)))

/mob/dead/observer/shuttleRotate(rotation, params)
	. = ..()
	update_icons()

/************************************Structure rotate procs************************************/

//Fixes dpdir on shuttle rotation
/obj/structure/disposalpipe/shuttleRotate(rotation, params)
	. = ..()
	var/new_dpdir = 0
	for(var/D in GLOB.cardinals)
		if(dpdir & D)
			new_dpdir = new_dpdir | angle2dir(rotation+dir2angle(D))
	dpdir = new_dpdir

/obj/structure/window/framed/shuttleRotate(rotation, params)
	. = ..()
	update_icon()

/obj/structure/alien/weeds/shuttleRotate(rotation, params)
	params &= ~ROTATE_OFFSET
	return ..()

/************************************Machine rotate procs************************************/

//override to avoid rotating multitile vehicles
/obj/vehicle/shuttleRotate(rotation, params)
	if(hitbox)
		params = NONE
	return ..()

/obj/vehicle/sealed/mecha/combat/greyscale/shuttleRotate(rotation, params)
	params &= ~ROTATE_OFFSET
	return ..()

/obj/machinery/atmospherics/shuttleRotate(rotation, params)
	var/list/real_node_connect = getNodeConnects()
	for(var/i in 1 to device_type)
		real_node_connect[i] = angle2dir(rotation+dir2angle(real_node_connect[i]))

	. = ..()
	SetInitDirections()
	var/list/supposed_node_connect = getNodeConnects()
	var/list/nodes_copy = nodes.Copy()

	for(var/i in 1 to device_type)
		var/new_pos = supposed_node_connect.Find(real_node_connect[i])
		nodes[new_pos] = nodes_copy[i]

