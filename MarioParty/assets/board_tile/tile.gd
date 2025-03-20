class_name BoardTile extends Node3D

const BOARD_TILE_LINE = preload("_line.tscn")


func create_line(point:Vector3):	
	var line = BOARD_TILE_LINE.instantiate()
	var arrow = line.get_node("Arrow")
	add_child(line)
	line.position = global_position.lerp(point, 0.5)
	line.scale.z = global_position.distance_to(point)
	line.rotation.y = -Swizzler.xz(point - global_position).angle()-PI/2
	
	arrow.position = global_position.lerp(point, 0.5)
	arrow.rotation.y = -Swizzler.xz(point - global_position).angle()-PI/2


func on_player_passed(id:int):
	pass


func on_player_stopped(id:int):
	pass
