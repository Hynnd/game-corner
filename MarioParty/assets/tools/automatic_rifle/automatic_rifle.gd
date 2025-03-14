extends Node3D

@onready var ray: RayCast3D = %RayCast3D
@onready var cooldown: Timer = %Cooldown


func _ready() -> void:
	set_multiplayer_authority(get_parent().id)


func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click") and cooldown.is_stopped():
		cooldown.start()
		shoot()
	
	update_transforms.call_deferred()


func shoot() -> void:
	if not is_multiplayer_authority(): return
	
	var cam = get_viewport().get_camera_3d()
	var cam_rot = cam.rotation_degrees
	
	var col = ray.get_collider()
	if is_instance_valid(col) and col.has_method("take_damage"):
		var atk = GameState.ATTACK_EVENT.duplicate()
		atk.damage = 1
		atk.owner_id = Multiplayer.id
		col.take_damage.rpc(atk)
		print(1)


func update_transforms() -> void:
	if not is_instance_valid(get_viewport()): return
	
	var cam = get_viewport().get_camera_3d()
	global_rotation = cam.global_rotation
	global_position = cam.global_position
