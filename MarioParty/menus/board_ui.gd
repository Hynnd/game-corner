extends Node

@onready var split_path_prompt: Control = %SplitPathPrompt
@onready var do_next_menu: VBoxContainer = %DoNextMenu
@onready var roll_menu: Control = %RollMenu


func _ready() -> void:
	%DoNextMenu.hide()


func _process(delta: float) -> void:
	if GameState.current_id == -1: return
	
	var your_turn = GameState.current_id == Multiplayer.id
	%Label.visible = true
	
	var color:Color = GameState.players[GameState.current_id].color
	var html = color.to_html(false)
	%Label.text = "Your turn" if your_turn else str(Game.COLOR_NAMES[html], "'s turn")
	%Label.modulate = color
