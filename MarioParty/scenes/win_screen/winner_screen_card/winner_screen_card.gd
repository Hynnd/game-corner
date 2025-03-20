extends Control

var id:int

@onready var coins_label: Label = %Coins
@onready var coins_total_label: Label = %CoinsTotal

var coins:float
var coins_total:float


func _ready() -> void:
	%You.visible = Multiplayer.id == id
	
	%PlayerIcon.id = id
	%PlayerIcon._refresh()
	
	create_tween().tween_property(self, "coins", 0, 1.2).set_delay(4.5)
	create_tween().tween_property(self, "coins_total", coins_total + coins, 1.2).set_delay(4.5)


func _process(delta: float) -> void:
	coins_label.text = str("+", floori(coins))
	coins_total_label.text = str(floori(coins_total))
