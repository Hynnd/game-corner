extends PanelContainer

var id:int

@onready var color_rect: ColorRect = %ColorRect
@onready var label: Label = %Label


func _ready() -> void:
	#if Multiplayer.id == id:
		#custom_minimum_size.x += 30
		#custom_minimum_size.y += 30
	%You.visible = Multiplayer.id == id


func _process(delta: float) -> void:
	color_rect.color = GameState.players[id].color
	label.text = str(GameState.players[id].coins)
