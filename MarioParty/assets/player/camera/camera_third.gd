extends Node3D

#@onready var offset:Vector3 = global_position

@onready var _height:float = owner.global_position.y
@onready var camera: Camera3D = $Camera


func _ready() -> void:
	top_level = true
	camera.current = owner.camera_mode == owner.CameraMode.TOP and owner.is_owner()


func _process(delta: float) -> void:
	position.x = lerpf(position.x, owner.global_position.x, 25 * delta)
	position.z = lerpf(position.z, owner.global_position.z, 25 * delta)
	position.y = lerpf(position.y, _height, 5 * delta)
	
	if owner.is_on_floor():
		_height = owner.global_position.y
