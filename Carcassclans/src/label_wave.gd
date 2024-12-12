extends Label


func _process(delta: float) -> void:
	text = str("Wave: ", GameState.wave_index, " / ", GameState.wave_max)
