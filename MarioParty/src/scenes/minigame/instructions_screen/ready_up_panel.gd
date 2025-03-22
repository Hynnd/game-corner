extends Control

signal all_ready

@onready var icons_container: HBoxContainer = %Icons
@onready var num_players: Label = %NumPlayers
@onready var ready_button: Button = %Ready
@onready var force_start_button: Button = %ForceStart

var num_ready_players:int = 0

var icons := {}


func _ready() -> void:
	ready_button.toggled.connect(func(toggled_on:bool):
		if toggled_on: ready_up.rpc()
		else: unready.rpc()
		)
	force_start_button.pressed.connect(func():
		ready_up.rpc(true)
		)
	if not OS.is_debug_build(): force_start_button.hide()


func _process(delta: float) -> void:
	# Add player icons for joining players
	for id in GameState.players.keys():
		if not icons.has(id):
			var icon = preload("res://src/player_icon/player_icon.tscn").instantiate()
			icon.id = id
			icon.auto_update = true
			icons_container.add_child(icon)
			
			icons[id] = icon
	# Update colors
	for id in icons.keys():
		var icon = icons[id]
		if GameState.players[id].has("color"):
			icon.color = GameState.players[id].color
	
	num_players.text = str(num_ready_players, "/", multiplayer.get_peers().size()+1)


@rpc("any_peer", "call_local", "reliable")
func ready_up(force_start:bool = false):
	num_ready_players += 1
	if force_start: num_ready_players = multiplayer.get_peers().size() + 1
	
	if num_ready_players == multiplayer.get_peers().size() + 1:
		all_ready.emit()


@rpc("any_peer", "call_local", "reliable")
func unready():
	num_ready_players -= 1
