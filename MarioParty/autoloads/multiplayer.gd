extends Node

var peer = ENetMultiplayerPeer.new()


func create_server():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect()


func join_server():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
