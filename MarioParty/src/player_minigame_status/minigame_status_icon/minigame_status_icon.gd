extends PanelContainer

var id

@onready var color_rect: ColorRect = %ColorRect
@onready var label: Label = %Label


func _process(delta: float) -> void:
	color_rect.color = GameState.players[id].color
	label.color = GameState.players[id].mini_coins
