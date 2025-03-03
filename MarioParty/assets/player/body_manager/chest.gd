extends Node3D

const STEP_AMP:float = 0.1
const STEP_FREQ:float = 1.4

var progress:float = 0

@onready var _height:float = position.y
var _jump_offset:float = 0


func _process(delta: float) -> void:
	progress += delta * STEP_FREQ * Swizzler.xz(owner.player.velocity).length()
	
	position.y = _height + _jump_offset + sin(progress) * STEP_AMP
