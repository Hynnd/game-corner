extends Camera3D

var mouse_sensitivity:float = 65

@export var max_angle: float = 89
@export var min_angle: float = -89


func _ready() -> void:
	current = owner.camera_mode == owner.CameraMode.FIRST
	if current:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		await owner.ready
		owner.body_manager.hide()


func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED: return
	
	if event is InputEventMouseMotion:
		var screen_size: Vector2 = get_viewport().get_screen_transform().get_scale()
		var mouse_delta: Vector2 = event.relative * mouse_sensitivity / 1000 * screen_size.x
		rotation.y -= deg_to_rad(mouse_delta.x)
		rotation.x -= deg_to_rad(mouse_delta.y)
		rotation.x = clampf(rotation.x, deg_to_rad(min_angle), deg_to_rad(max_angle))
