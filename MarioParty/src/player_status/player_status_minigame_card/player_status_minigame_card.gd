extends PanelContainer

var id:int

@onready var coins_label: Label = %Coins


func _ready() -> void:
	%You.visible = Multiplayer.id == id
	
	%PlayerIcon.id = id
	%PlayerIcon._refresh()
	
	#self_modulate = GameState.players[id].color


func _process(delta: float) -> void:
	coins_label.text = str(GameState.players[id].minigame_coins)
