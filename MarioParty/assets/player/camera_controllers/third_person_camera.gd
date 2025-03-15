extends Node3D

@onready var _floor_height:float
@onready var cam: Camera3D = %Camera3D

var target:Node3D


func _ready() -> void:
	#await GameState.players_spawned
	await get_tree().process_frame
	set_multiplayer_authority(Multiplayer.id)
	target = GameState.player_nodes[Multiplayer.id]
	_floor_height = target.global_position.y


func _process(delta: float) -> void:
	position.x = lerpf(position.x, target.global_position.x, 25 * delta)
	position.z = lerpf(position.z, target.global_position.z, 25 * delta)
	position.y = lerpf(position.y, _floor_height, 5 * delta)
	
	if target.is_on_floor():
		_floor_height = target.global_position.y
