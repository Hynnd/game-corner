extends Node3D

@export var disabled:bool = false
@export var meshes:Array[Node3D]

var _arms_sway:float = 0

var _arms_raise:float = 0
var _arms_fall:float = 0

@onready var legs: Node3D = %Legs
@onready var arms: Node3D = %Arms
@onready var head: Node3D = %Head
@onready var stomach: Node3D = %Stomach
@onready var hand_1: Node3D = %Hand1
@onready var hand_2: Node3D = %Hand2
@onready var foot_1: Node3D = %Foot1
@onready var foot_2: Node3D = %Foot2
@onready var chest: Node3D = %Chest
@onready var decal: Decal = %Decal

var player: Node3D

var _old_grounded:bool = true

@onready var _head_height:float = head.position.y
@onready var _arms_height:float = arms.position.y

var jump_tween:Tween

@onready var _mat:Material = preload("res://assets/player/body_manager/mats/balloon_mat.tres").duplicate()


func _ready() -> void:
	for node in meshes:
		node.material_override = _mat
	
	if disabled: return
	
	_mat.set_shader_parameter("color", GameState.players[owner.id].color)
	
	player = owner
	
	if GameState.players[player.id].face != null:
		var image = Image.new()
		#image.data = GameState.players[player.id].face
		image.load_png_from_buffer(GameState.players[player.id].face)
		decal.texture_albedo = ImageTexture.create_from_image(image)


func _process(delta: float) -> void:
	if disabled: return
	
	var vel = owner.velocity
	var move_dir = owner.movement_normal.move_dir
	
	if Swizzler.xz(vel).length() > owner.MOVE_SPEED * 0.465:
		var ang = -Swizzler.xz(vel).angle()-PI/2
		legs.rotation.y = lerp_angle(legs.rotation.y, ang, min(delta * 7, 1))
		arms.rotation.y = lerp_angle(arms.rotation.y, ang, min(delta * 11, 1))
	
	if move_dir.length() > 0.5:
		var ang = -move_dir.angle()-PI/2
		head.rotation.y = lerp_angle(head.rotation.y, ang, min(delta * 11, 1))
	
	
	if owner.is_on_floor():
		if owner.velocity.length() > owner.MOVE_SPEED * 0.465:
			_arms_sway += delta * 18 * _arms_raise
	else:
		_arms_raise = lerpf(_arms_raise, 0, min(delta*8, 1))
	
	# Forward/Back
	hand_1.position.z = cos(_arms_sway) * 0.55 * _arms_raise
	hand_2.position.z = cos(_arms_sway+PI) * 0.55 * _arms_raise
	# Up/Down
	hand_1.position.y = (_arms_raise-1) * 0.3 + _arms_fall * 1.2
	hand_2.position.y = (_arms_raise-1) * 0.3 + _arms_fall * 1.2
	# Out/In
	hand_1.position.x = -0.38 - _arms_raise * 0.19 - _arms_fall * 0.3
	hand_2.position.x = 0.38 + _arms_raise * 0.19 + _arms_fall * 0.3
	
	legs.position = legs.position.lerp(Swizzler.xoz(vel).limit_length(1) * 0.4, min(delta * 7, 1))
	arms.position = arms.position.lerp(Swizzler.xoz(vel).limit_length(1) * 0.15 + Vector3(0,_arms_height,0), min(delta * 7, 1))
	if Swizzler.xoz(vel).length() > 1:
		stomach.position = stomach.position.lerp(Swizzler.xoz(vel).limit_length(1) * 0.11 + Vector3(0,0.45,0), min(delta * 7, 1))
	
	head.position = head.position.lerp(Swizzler.xoz(vel).normalized() * 0.25 + Vector3(0,_head_height,0), min(delta * 7, 1))
	
	if owner.is_on_floor():
		if move_dir.length() > 0.1:
			_arms_raise = lerpf(_arms_raise, 1, min(delta*8, 1))
		else:
			_arms_raise = lerpf(_arms_raise, 0, min(delta*8, 1))
	
	if not owner.is_on_floor():
		_arms_fall = lerpf(_arms_fall, 1, min(delta*2, 1))
	else:
		_arms_fall = lerpf(_arms_fall, 0, min(delta*8, 1))


func _physics_process(delta: float) -> void:
	if disabled: return
	
	# On landed
	if _old_grounded and not player.is_on_floor():
		if jump_tween: jump_tween.kill()
		jump_tween = create_tween().set_trans(Tween.TRANS_SINE)
		jump_tween.tween_property(chest, "_jump_offset", -0.4, 0.15)
		jump_tween.tween_property(chest, "_jump_offset", 0.15, 0.4)
		jump_tween.tween_property(chest, "_jump_offset", 0.0, 0.25)
	
	# On landed
	if not _old_grounded and player.is_on_floor():
		if jump_tween: jump_tween.kill()
		jump_tween = create_tween().set_trans(Tween.TRANS_SINE)
		jump_tween.tween_property(chest, "_jump_offset", -0.75, 0.09)
		jump_tween.tween_property(chest, "_jump_offset", 0.2, 0.34)
		jump_tween.tween_property(chest, "_jump_offset", -0.11, 0.3)
		jump_tween.tween_property(chest, "_jump_offset", 0.04, 0.3)
		jump_tween.tween_property(chest, "_jump_offset", 0.0, 0.3)
		
		for foot in [foot_1, foot_2]:
			foot.take_step(get_physics_process_delta_time())
	
	_old_grounded = player.is_on_floor()
