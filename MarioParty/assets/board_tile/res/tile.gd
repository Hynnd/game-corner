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


func get_pos() -> Vector2:
	var offsets = [Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)]
	var players_on_tile = 0
	for id in GameState.players.keys():
		var tile_name = GameState.players[id].tile
		if tile_name == name and global_position.distance_to(GameState.player_nodes[id].global_position) < 2:
			players_on_tile += 1
	
	return Swizzler.xz(global_position) + offsets[players_on_tile]
