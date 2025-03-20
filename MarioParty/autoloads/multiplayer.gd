extends Node

signal server_created

var id:int = -1

var peer = ENetMultiplayerPeer.new()


func create_server():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	
	GameState.add_player(peer.get_unique_id())
	multiplayer.peer_connected.connect(func(peer_id: int):
		GameState.add_player.rpc(peer_id)
		
		var state = GameState.get_state()
		GameState.set_state.rpc_id(peer_id, state)
		)
	
	id = 1
	
	server_created.emit()


func join_server():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	
	id = multiplayer.get_unique_id()


func sync_game_state_to_peers():
	if id != 1: return
	
	for peer_id in multiplayer.get_peers():
		var state = GameState.get_state()
		GameState.set_state.rpc_id(peer_id, state)
