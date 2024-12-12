extends Label


func _process(delta: float) -> void:
	text = str("Money: ", GameState.money)
