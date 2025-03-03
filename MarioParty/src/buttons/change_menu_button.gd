class_name ChangeMenuButton extends Button

@export var hide_menu:Node
@export var show_menu:Node
@export var esc_as_input:bool = false


func _ready() -> void:
	pressed.connect(func():
		change_menu()
		)


func _input(event: InputEvent) -> void:
	if esc_as_input and is_visible_in_tree():
		if Input.is_action_just_pressed("esc"):
			change_menu()


func change_menu() -> void:
	if hide_menu:
		hide_menu.hide()
	if show_menu:
		show_menu.show()
