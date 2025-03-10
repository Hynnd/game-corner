extends Node3D

@onready var ray: RayCast3D = %RayCast3D
@onready var cooldown: Timer = %Cooldown


func _ready() -> void:
	set_multiplayer_authority(get_parent().player_id)


func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click") and cooldown.is_stopped():
		cooldown.start()
		shoot()
	
	update_transforms.call_deferred()


func shoot() -> void:
	var cam = get_viewport().get_camera_3d()
	var cam_rot = cam.rotation_degrees
	
	#randomize()
	#cam.rotation_degrees.y += randf_range(-1.5, 1.5)
	#cam.rotation_degrees.x += 1.5
	
	
	


func update_transforms() -> void:
	if not is_instance_valid(get_viewport()): return
	
	var cam = get_viewport().get_camera_3d()
	global_rotation = cam.global_rotation
	global_position = cam.global_position
