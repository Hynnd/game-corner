extends Camera3D

@onready var offset:Vector3 = global_position

@onready var _height:float = owner.global_position.y


func _ready() -> void:
	top_level = true
	current = owner.camera_mode == owner.CameraMode.TOP


func _process(delta: float) -> void:
	position.x = lerpf(position.x, offset.x + owner.global_position.x, 25 * delta)
	position.z = lerpf(position.z, offset.z + owner.global_position.z, 25 * delta)
	position.y = lerpf(position.y, _height, 5 * delta)
	
	if owner.is_on_floor():
		_height = offset.y + owner.global_position.y
		
