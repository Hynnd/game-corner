extends Control

var id:int

@onready var coins_label: Label = %Coins
@onready var coins_total_label: Label = %CoinsTotal
@onready var minigame_coins_container: HBoxContainer = %MinigameCoinsContainer

var minigame_coins:float
var board_coins:float


func _ready() -> void:
	%You.visible = Multiplayer.id == id
	
	%PlayerIcon.id = id
	%PlayerIcon._refresh()
	
	minigame_coins = GameState.players[id].minigame_coins
	board_coins = GameState.players[id].coins
	
	create_tween().tween_property(self, "minigame_coins", 0, 1.2).set_delay(4.5)
	create_tween().tween_property(self, "board_coins", board_coins + minigame_coins, 1.2).set_delay(4.5)


func _process(delta: float) -> void:
	minigame_coins_container.visible = floori(minigame_coins) > 0
	coins_label.text = str("+", floori(minigame_coins))
	coins_total_label.text = str(ceili(board_coins))
