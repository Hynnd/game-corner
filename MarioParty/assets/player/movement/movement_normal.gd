extends Node

const ACCEL:float = 15
const DECEL:float = 15
const ACCEL_AIR:float = 0.2
const GRAVITY_DOWN:float = 1.00

var move_speed:float
var jump_force:float
var gravity:float
var can_sprint:bool


var move_input:Vector2
@export var move_dir:Vector2

@export var synced_velocity:Vector3

var t1:Tween

var _sprinting = false


func _physics_process(delta: float) -> void:
	if owner.can_move and owner.is_owner():
		move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		move_dir = move_input.rotated(-get_viewport().get_camera_3d().global_rotation.y)
	var tar_dir = move_dir
	
	if Input.is_action_pressed("sprint") and move_input.y < 0 and can_sprint:
		tar_dir += (Swizzler.xz(-get_viewport().get_camera_3d().global_basis.z)).normalized() * 0.60
		
		if not _sprinting: 
			_sprinting = true
	elif _sprinting: 
		_sprinting = false
	
	if is_instance_valid(GameState.camera_controller) and "fov" in GameState.camera_controller:
		var target_fov = GameState.camera_controller.fov*1.1 if _sprinting else GameState.camera_controller.fov
		GameState.camera_controller.cam.fov = lerpf(GameState.camera_controller.cam.fov, target_fov, 5 * delta)
	
	
	# Puppet
	if not synced_velocity.is_zero_approx():
		owner.velocity = synced_velocity
		owner.move_and_slide()
		return
	
	var accel = ACCEL if Swizzler.xz(owner.velocity).length() < move_speed * move_input.length() else DECEL
	if owner.is_on_floor():
		owner.velocity.x = lerpf(owner.velocity.x, tar_dir.x * move_speed, delta * accel)
		owner.velocity.z = lerpf(owner.velocity.z, tar_dir.y * move_speed, delta * accel)
	else:
		if move_input.length() > 0:
			owner.velocity.x = lerpf(owner.velocity.x, tar_dir.x * move_speed, delta * accel * ACCEL_AIR)
			owner.velocity.z = lerpf(owner.velocity.z, tar_dir.y * move_speed, delta * accel * ACCEL_AIR)
	
	if owner.is_on_floor() and owner.velocity.y <= 0:
		if Input.is_action_just_pressed("jump") and owner.is_owner():
			if owner.can_jump:
				owner.velocity.y = jump_force
	else:
		owner.velocity.y -= get_gravity() * delta
	
	var old_grounded = owner.is_on_floor()
	
	owner.move_and_slide()


func get_gravity() -> float:
	return gravity * GRAVITY_DOWN if owner.velocity.y < 0 else gravity
