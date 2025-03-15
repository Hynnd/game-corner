extends Node

var COLOR_NAMES:Dictionary[String,String] = {
	"3c7dff": "Blue",
	"ff4e47": "Red",
	"3bff41": "Green",
	"ffe83d": "Yellow",
	"b53dff": "Magenta",
	"3dffe5": "Mint",
}


func _input(_event: InputEvent):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _process(delta: float) -> void:
	# Print clicked control node path
	if Input.is_action_just_pressed("left_click") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		if is_instance_valid(get_viewport().gui_get_hovered_control()):
			print(get_viewport().gui_get_hovered_control().get_path())
