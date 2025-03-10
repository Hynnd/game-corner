extends Node3D

@onready var _height:float = owner.global_position.y
@onready var cam: Camera3D = %Camera3D

var target:Node3D


func _ready() -> void:
	await GameState.players_spawned
	set_multiplayer_authority(Multiplayer.id)
	target = GameState.player_nodes[Multiplayer.id]


func _process(delta: float) -> void:
	position.x = lerpf(position.x, owner.global_position.x, 25 * delta)
	position.z = lerpf(position.z, owner.global_position.z, 25 * delta)
	position.y = lerpf(position.y, _height, 5 * delta)
	
	if owner.is_on_floor():
		_height = owner.global_position.y
