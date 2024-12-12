extends Button

@export var esc_as_input:bool = false


func _ready() -> void:
	pressed.connect(func():
		get_tree().quit()
		)


func _input(_event: InputEvent) -> void:
	if esc_as_input and is_visible_in_tree():
		if Input.is_action_just_pressed("esc"):
			get_tree().quit()
