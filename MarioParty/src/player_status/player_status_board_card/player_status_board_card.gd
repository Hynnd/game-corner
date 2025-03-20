extends Control

var id:int

@onready var balloons: Label = %Balloons
@onready var balloons_unsecured: Label = %BalloonsUnsecured
@onready var coins: Label = %Coins
@onready var unsecured_container: HBoxContainer = %UnsecuredContainer
@onready var panel_container: PanelContainer = %PanelContainer
@onready var outline: Panel = %Outline


func _ready() -> void:
	%You.visible = Multiplayer.id == id
	
	%PlayerIcon.id = id
	%PlayerIcon._refresh()
	
	outline.modulate = GameState.players[id].color
	#if id == Multiplayer.id:
	panel_container.self_modulate = GameState.players[id].color


func _process(delta: float) -> void:
	coins.text = str(GameState.players[id].coins)
	balloons.text = str(GameState.players[id].balloons)
	balloons_unsecured.text = str(GameState.players[id].unsecured_balloons)
	unsecured_container.visible = GameState.players[id].unsecured_balloons > 0
	unsecured_container.visible = GameState.players[id].unsecured_balloons > 0
	
	outline.visible = GameState.current_id == id
	
	if GameState.current_id == id:
		add_theme_constant_override("margin_left", 12)
		add_theme_constant_override("margin_right", 12)
	else:
		add_theme_constant_override("margin_left", 0)
		add_theme_constant_override("margin_right", 0)
