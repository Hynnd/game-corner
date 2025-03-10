extends Node

signal server_created

var peer = ENetMultiplayerPeer.new()


func create_server():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	
	GameState.add_player(peer.get_unique_id())
	multiplayer.peer_connected.connect(func(id: int):
		GameState.add_player.rpc(id)
		
		var state = GameState.get_state()
		GameState.set_state.rpc_id(id, state)
		)
	
	server_created.emit()


func join_server():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
