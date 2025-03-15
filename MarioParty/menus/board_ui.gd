extends Node


func _ready() -> void:
	%DoNextMenu.hide()


func _process(delta: float) -> void:
	var your_turn = GameState.current_id == Multiplayer.id
	%Label.visible = true
	
	var color:Color = GameState.players[GameState.current_id].color
	var html = color.to_html(false)
	%Label.text = "Your turn" if your_turn else str(Game.COLOR_NAMES[html], "'s turn")
	%Label.modulate = color
