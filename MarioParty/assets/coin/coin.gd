extends Node3D

@onready var visuals: Node3D = %Visuals
@onready var area: Area3D = $Area3D


func _ready() -> void:
	#if Multiplayer.id == 1:
	area.body_entered.connect(func(body: Node3D):
		#if body.id == Multiplayer.id:
			#_picked_up.rpc(body.id)
		#else:
		GameState.players[body.id].minigame_coins += 1
		queue_free()
		)


func _process(delta: float) -> void:
	visuals.rotation_degrees.y += delta * 360


#@rpc("any_peer", "call_local", "reliable")
#func _picked_up(id:int):
	#GameState.players[id].minigame_coins += 1
	#queue_free()
