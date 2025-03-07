extends Node3D

@onready var camera: Camera3D = $Camera3D


func _ready() -> void:
	await get_tree().current_scene.ready
	get_viewport().get_camera_3d().current = false
	
	camera.current = true


func _process(delta: float) -> void:
	var id = GameState.current_id
	var target = GameState.players[id].node.position
	position = position.lerp(target, 3 * delta)
