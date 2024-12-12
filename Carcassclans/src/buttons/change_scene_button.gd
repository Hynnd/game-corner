class_name ChangeSceneButton extends Button

@export_file("*.tscn") var scene:String
@export var esc_as_input:bool = false


func _ready() -> void:
	pressed.connect(func():
		change_scene()
		)


func _input(_event: InputEvent) -> void:
	if esc_as_input and is_visible_in_tree():
		if Input.is_action_just_pressed("esc"):
			change_scene()


func change_scene() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(scene)
