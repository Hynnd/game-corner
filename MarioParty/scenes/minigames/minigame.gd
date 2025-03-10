extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		GameState.return_to_board.rpc()
	
	if Input.is_action_just_pressed("right_click"):
		if not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func exit():
	GameState.return_to_board.rpc()
