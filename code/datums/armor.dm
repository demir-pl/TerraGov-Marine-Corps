#define ARMORID "armor-[melee]-[bullet]-[laser]-[energy]-[bomb]-[bio]-[fire]-[acid]"

/proc/getArmor(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, fire = 0, acid = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(melee, bullet, laser, energy, bomb, bio, fire, acid)

/datum/armor
	var/melee = 0
	var/bullet = 0
	var/laser = 0
	var/energy = 0
	var/bomb = 0
	var/bio = 0
	var/fire = 0
	var/acid = 0

/datum/armor/New(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, fire = 0, acid = 0)
	src.melee = melee
	src.bullet = bullet
	src.laser = laser
	src.energy = energy
	src.bomb = bomb
	src.bio = bio
	src.fire = fire
	src.acid = acid
	GenerateTag()

/datum/armor/GenerateTag()
	. = ..()
	tag = ARMORID

/datum/armor/proc/modifyRating(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, fire = 0, acid = 0)
	return getArmor(src.melee+melee, src.bullet+bullet, src.laser+laser, src.energy+energy, src.bomb+bomb, src.bio+bio, src.fire+fire, src.acid+acid)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(melee+modifier, bullet+modifier, laser+modifier, energy+modifier, bomb+modifier, bio+modifier, fire+modifier, acid+modifier)

/datum/armor/proc/scaleAllRatings(modifier = 1, round_to = 0)
	if(round_to >= 1)
		return getArmor(round(melee*modifier,round_to), round(bullet*modifier,round_to), round(laser*modifier,round_to), round(energy*modifier,round_to), round(bomb*modifier,round_to), round(bio*modifier,round_to), round(fire*modifier,round_to), round(acid*modifier,round_to))
	return getArmor(melee*modifier, bullet*modifier, laser*modifier, energy*modifier, bomb*modifier, bio*modifier, fire*modifier, acid*modifier)

/datum/armor/proc/setRating(melee, bullet, laser, energy, bomb, bio, fire, acid)
	return getArmor((isnull(melee) ? src.melee : melee),\
					(isnull(bullet) ? src.bullet : bullet),\
					(isnull(laser) ? src.laser : laser),\
					(isnull(energy) ? src.energy : energy),\
					(isnull(bomb) ? src.bomb : bomb),\
					(isnull(bio) ? src.bio : bio),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),
					)

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list(MELEE = melee, BULLET = bullet, LASER = laser, ENERGY = energy, BOMB = bomb, BIO = bio, FIRE = fire, ACID = acid)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(melee+AA.melee, bullet+AA.bullet, laser+AA.laser, energy+AA.energy, bomb+AA.bomb, bio+AA.bio, fire+AA.fire, acid+AA.acid)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(melee-AA.melee, bullet-AA.bullet, laser-AA.laser, energy-AA.energy, bomb-AA.bomb, bio-AA.bio, fire-AA.fire, acid-AA.acid)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	GenerateTag() // update tag in case armor values were edited

#undef ARMORID
