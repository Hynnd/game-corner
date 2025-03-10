extends Node

var target_points:Array[Vector2] = []
var move_speed:float

@onready var _marker: MeshInstance3D = $TargetPointMarker


func _physics_process(delta: float) -> void:
	if target_points.size() > 0:
		var point = target_points[0]
		var pos_2d = Swizzler.xz(owner.global_position)
		pos_2d = pos_2d.move_toward(point, move_speed * delta)
		
		var dir = (point - Swizzler.xz(owner.global_position)).normalized()
		owner.velocity.x = (dir * move_speed).x
		owner.velocity.z = (dir * move_speed).y
		owner.movement_normal.move_input = dir 
		
		if pos_2d.distance_to(point) < 0.1: 
			target_points.remove_at(0)
			owner.velocity *= 0
			owner.movement_normal.move_input *= 0
		
		#_marker.position = Vector3(point.x, owner.global_position.y, point.y)
	
	#_marker.visible = target_points.size() > 0
