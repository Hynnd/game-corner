extends Node2D

@export var is_erasing:bool = false

var size_min:int = 8
var size_max:int = 48
var size_step:int = 4

var brush_size:int = 16

var velocity:Vector2

var _old_pos:Vector2

@onready var pencil_sway: Node3D = %PencilSway
@onready var pencil_erase: Node3D = %PencilErase
@onready var brush_texture: TextureRect = %BrushTexture

var _draw_sway_progress:float
var _erase_rot:float = 0
var _erase_rot_tar:float = 0

var er_tween:Tween


func _ready() -> void:
	_refresh_brush()


func _process(delta: float) -> void:
	position = get_global_mouse_position()
	
	velocity = (position - _old_pos) / delta
	
	_animate(delta)
	_change_brush_size()
	
	if Input.is_action_just_pressed("right_click"):
		is_erasing = !is_erasing
		if er_tween: er_tween.kill()
		er_tween = create_tween().set_trans(Tween.TRANS_SINE)
		
		_erase_rot_tar += PI
		if is_erasing:
			er_tween.tween_property(self, "_erase_rot", _erase_rot_tar +PI *0.1, 0.25)
			er_tween.tween_property(self, "_erase_rot", _erase_rot_tar -PI *0.1, 0.15)
			er_tween.tween_property(self, "_erase_rot", _erase_rot_tar, 0.15)
		else:
			er_tween.tween_property(self, "_erase_rot", _erase_rot_tar +PI*0.1, 0.2)
			er_tween.tween_property(self, "_erase_rot", _erase_rot_tar -PI*0.1, 0.15)
			er_tween.tween_property(self, "_erase_rot", _erase_rot_tar, 0.15).finished.connect(func():
				_erase_rot = 0
				_erase_rot_tar = 0
				)
	
	
	_old_pos = position

func _animate(delta:float):
	var is_drawing = Input.is_action_pressed("left_click")
	
	var tar_z = 0
	tar_z = velocity.y * 0.0012
	tar_z += clampf(velocity.x, -0.7, 0.7)
	if is_drawing:
		_draw_sway_progress += delta * 34
		tar_z += cos(_draw_sway_progress) * 0.4
	else: _draw_sway_progress = 0
	
	pencil_sway.rotation.z = lerp_angle(pencil_sway.rotation.z, tar_z, min(20*delta,1))
	
	var tar_y = 0
	if is_drawing:
		tar_y = lerp_angle(tar_y, -3, 20 * delta)
	
	pencil_sway.rotation.y = lerp_angle(pencil_sway.rotation.y, tar_y, min(20*delta,1))
	
	pencil_erase.rotation.z = _erase_rot


func _refresh_brush():
	brush_texture.texture.width = brush_size
	brush_texture.texture.height = brush_size


func _change_brush_size():
	if Input.is_action_just_pressed("scroll_down"):
		brush_size = clampi(brush_size+size_step, size_min, size_max)
		_refresh_brush()
	if Input.is_action_just_pressed("scroll_up"):
		brush_size = clampi(brush_size-size_step, size_min, size_max)
		_refresh_brush()
