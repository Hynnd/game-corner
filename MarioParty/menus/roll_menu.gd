extends Control


func _ready() -> void:
	$Button.pressed.connect(func():
		GameState.find_player(GameState.current_player).current_moves = 3
		hide()
		)
	hide()
