extends Node3D

@onready var ray: RayCast3D = %RayCast3D
@onready var cooldown: Timer = %Cooldown
@onready var orbit: Node3D = %Orbit
@onready var hit_marker: TextureRect = %HitMarker

var t:Tween


func _ready() -> void:
	set_multiplayer_authority(get_parent().id)
	hit_marker.modulate.a = 0


func _process(delta: float) -> void:
	if not is_multiplayer_authority(): 
		global_transform = get_parent().body_manager.head.global_transform
		%UI.hide()
		return
	
	if Input.is_action_pressed("left_click") and cooldown.is_stopped():
		cooldown.start()
		shoot()
	
	update_transforms.call_deferred()


func shoot() -> void:
	if not is_multiplayer_authority(): return
	
	var cam = get_viewport().get_camera_3d()
	var cam_rot = cam.rotation_degrees
	
	var col = ray.get_collider()
	if is_instance_valid(col):
		var bullet_hole
		
		if col.has_method("take_damage"):
			var atk = GameState.ATTACK_EVENT.duplicate()
			atk.damage = 0.2
			atk.owner_id = Multiplayer.id
			col.take_damage.rpc(atk)
			
			hit_marker.modulate.a = 1
			if t: t.kill()
			t = create_tween()
			t.tween_property(hit_marker, "modulate:a", 0, 0.3)
			
			bullet_hole = preload("hit_effects/player_hit.tscn").instantiate()
		else:
			bullet_hole = preload("hit_effects/ground_hit.tscn").instantiate()
		
		bullet_hole.position = ray.get_collision_point()
		get_tree().current_scene.add_child(bullet_hole)
		var normal = ray.get_collision_normal()
		if abs(normal.y) == 1: normal.x += 0.01
		bullet_hole.look_at(bullet_hole.position + normal)
	
	var t = create_tween()
	t.tween_property(orbit, "position:z", 0.23, 0.02)
	t.tween_property(orbit, "position:z", 0, 0.08)
	
	randomize()
	GameState.camera_controller.orbit.rotation.x += 0.016
	randomize()
	GameState.camera_controller.orbit.rotation.y += randf_range(-1, 1) * 0.006


func update_transforms() -> void:
	if not is_instance_valid(get_viewport()): return
	
	var cam = get_viewport().get_camera_3d()
	global_rotation = cam.global_rotation
	global_position = cam.global_position
