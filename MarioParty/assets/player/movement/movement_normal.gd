extends Node

const ACCEL:float = 12
const DECEL:float = 9
const ACCEL_AIR:float = 0.2

const GRAVITY_DOWN:float = 1.09

@export var move_input:Vector2
var move_dir:Vector2

@export var synced_velocity:Vector3
	#set(value):
		#owner.velocity = value
		#synced_velocity = value

var t1:Tween


func _physics_process(delta: float) -> void:
	if owner.can_move and owner.is_owner():
		move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	move_dir = move_input.rotated(-get_viewport().get_camera_3d().global_rotation.y)
	
	# Puppet
	if not synced_velocity.is_zero_approx():
		owner.velocity = synced_velocity
		owner.move_and_slide()
		return
	
	var accel = ACCEL if Swizzler.xz(owner.velocity).length() < owner.MOVE_SPEED * move_input.length() else DECEL
	if owner.is_on_floor():
		owner.velocity.x = lerpf(owner.velocity.x, move_dir.x * owner.MOVE_SPEED, delta * accel)
		owner.velocity.z = lerpf(owner.velocity.z, move_dir.y * owner.MOVE_SPEED, delta * accel)
	else:
		if move_input.length() > 0:
			owner.velocity.x = lerpf(owner.velocity.x, move_dir.x * owner.MOVE_SPEED, delta * accel * ACCEL_AIR)
			owner.velocity.z = lerpf(owner.velocity.z, move_dir.y * owner.MOVE_SPEED, delta * accel * ACCEL_AIR)
	
	if owner.is_on_floor() and owner.velocity.y <= 0:
		if Input.is_action_just_pressed("jump") and owner.is_owner():
			if owner.can_jump:
				owner.velocity.y = owner.JUMP_FORCE
	else:
		owner.velocity.y -= get_gravity() * delta
	
	var old_grounded = owner.is_on_floor()
	
	owner.move_and_slide()


func get_gravity() -> float:
	return owner.GRAVITY * GRAVITY_DOWN if owner.velocity.y < 0 else owner.GRAVITY
