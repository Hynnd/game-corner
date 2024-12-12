extends Area2D


func get_closest_target() -> Node2D:
	var bodies = get_overlapping_bodies()
	
	var closest_dist:float = INF
	var closest_target:Node2D
	
	for body in bodies:
		var dist = global_position.distance_to(body.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_target = body
	return closest_target
