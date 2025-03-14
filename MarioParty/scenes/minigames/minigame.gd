extends Node


func _ready() -> void:
	for id in GameState.player_nodes.keys():
		var player = GameState.player_nodes[id]
		player.health.died.connect(func():
			var coin = preload("res://assets/coin/coin.tscn").instantiate()
			coin.global_position = player.global_position
			
			player.global_position = GameState.player_spawner.get_random_point()
			
			await get_tree().create_timer(0.5).timeout
			
			add_child(coin)
			)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		exit()
	
	if Input.is_action_just_pressed("right_click"):
		if not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func exit():
	GameState.to_winner_screen.rpc()
