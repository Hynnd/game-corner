extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		GameState.return_to_board.rpc()
	if Input.is_action_just_pressed("right_click"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func exit():
	GameState.return_to_board.rpc()
