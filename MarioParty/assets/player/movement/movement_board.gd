extends Node

var target_point:Vector2 = Vector2.INF
var move_speed:float = 12

@onready var _marker: MeshInstance3D = $TargetPointMarker
@onready var moves_num: Label3D = %MovesNum

var current_moves:int = 0
var moving:bool = false


func _physics_process(delta: float) -> void:
	if target_point.is_finite():
		var pos_2d = Swizzler.xz(owner.global_position)
		pos_2d = pos_2d.move_toward(target_point, move_speed * delta)
		
		var dir = (target_point - Swizzler.xz(owner.global_position)).normalized()
		owner.velocity.x = (dir * move_speed).x
		owner.velocity.z = (dir * move_speed).y
		owner.movement_normal.move_input = dir 
		
		if pos_2d.distance_to(target_point) < 0.1: 
			target_point = Vector2.INF
			owner.velocity *= 0
			owner.movement_normal.move_input *= 0
		
		owner.movement_normal.move_dir = owner.movement_normal.move_input
		
		_marker.position = Vector3(target_point.x, owner.global_position.y, target_point.y)
	
	_tile_moving()
	
	moves_num.text = str(current_moves+1)
	#moves_num.visible = moving
	moves_num.visible = current_moves > 0 or moving



func _tile_moving():
	# Pass tile
	if moving and current_moves > 0 and not target_point.is_finite():
		var tile = GameState.find_tile(owner.current_tile_name)
		if tile.has_method("on_player_passed"):
			tile.on_player_passed(owner.id)
	
	# Finish moving
	if moving and current_moves == 0 and not target_point.is_finite():
		moving = false
		owner.face_camera()
		
		var tile = GameState.find_tile(owner.current_tile_name)
		if tile.has_method("on_player_stopped"):
			tile.on_player_stopped(owner.id)
		
		GameState.finished_walking.emit()
