extends Node


func _input(_event: InputEvent):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


#func _process(delta: float) -> void:
	## Print clicked control node path
	#if Input.is_action_just_pressed("left_click") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		#print(get_viewport().gui_get_hovered_control().get_path())
