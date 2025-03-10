extends PanelContainer

var id:int

@onready var color_rect: ColorRect = %ColorRect
@onready var label: Label = %Label


func _process(delta: float) -> void:
	color_rect.color = GameState.players[id].color
	label.text = str(GameState.players[id].minigame_coins)
