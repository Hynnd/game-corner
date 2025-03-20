@icon("minigame.svg")
extends Node


func _ready() -> void:
	if Multiplayer.id == 1:
		for id in GameState.player_nodes.keys():
			var player = GameState.player_nodes[id]
			player.health.died.connect(func():
				var pos = player.global_position
				respawn_player.rpc(id, GameState.player_spawner.get_random_point())
				await get_tree().create_timer(0.2).timeout
				spawn_item.rpc("res://assets/coin/coin.tscn", pos)
				
				
				#var coin = preload("res://assets/coin/coin.tscn").instantiate()
				#coin.global_position = player.global_position
				#coin.linear_velocity.y = 5
				#player.global_position = GameState.player_spawner.get_random_point()
				#player.health.revive()
				
				#await get_tree().create_timer(0.2).timeout
				#add_child(coin)
				)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		exit()


func exit():
	GameState.to_winner_screen.rpc()


@rpc("any_peer", "call_local", "reliable")
func spawn_item(item_path:String, pos:Vector3):
	var item = load(item_path).instantiate()
	item.global_position = pos
	#item.linear_velocity.y = 5
	add_child(item)


@rpc("any_peer", "call_local", "reliable")
func respawn_player(id:int, to_pos:Vector3):
	var player = GameState.player_nodes[id]
	player.global_position = to_pos
	player.health.revive()
