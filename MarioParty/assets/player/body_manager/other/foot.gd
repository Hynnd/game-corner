extends Node3D

const STEP_DIST:float = 0.6
const STEP_MARGIN:float = 0.05

const STEP_HEIGHT:float = 0.42
const STEP_TIME:float = 0.07

const COOLDOWN:float = 0.14

@export var other_leg:Node

var _cooldown_counter:float = 0


func _ready() -> void:
	if owner.disabled: return
	
	top_level = true


func _process(delta:float) -> void:
	if owner.disabled: return
	
	var parent = get_parent()
	
	if owner.player.is_on_floor():
		if _cooldown_counter <= 0 and Swizzler.xz(global_position - parent.global_position).length() > STEP_DIST - STEP_MARGIN:
			take_step(delta)
	else:
		airborn(delta)
	
	
	if _cooldown_counter > 0:
		_cooldown_counter = move_toward(_cooldown_counter, 0, delta)


func airborn(delta:float):
	var parent = get_parent()
	
	var target_pos = parent.global_position
	target_pos += Vector3(0,0.35,0) # Foot height
	position = position.lerp(target_pos, 33 * delta)


func take_step(delta:float):
	var parent = get_parent()
	
	_cooldown_counter = COOLDOWN
	if is_instance_valid(other_leg): other_leg._cooldown_counter = COOLDOWN / 2
	
	var dir = Swizzler.xz(owner.player.velocity*0.1).limit_length(1)
	create_tween().tween_property(self, "global_position:x", parent.global_position.x + STEP_DIST * dir.x, STEP_TIME)
	create_tween().tween_property(self, "global_position:z", parent.global_position.z + STEP_DIST * dir.y, STEP_TIME)
	var t = create_tween()
	t.tween_property(self, "global_position:y", parent.global_position.y + STEP_HEIGHT, STEP_TIME*0.5)
	t.tween_property(self, "global_position:y", parent.global_position.y, STEP_TIME*0.5)
