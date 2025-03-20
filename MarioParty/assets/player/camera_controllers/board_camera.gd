extends Node3D

@onready var camera: Camera3D = $Camera3D

var tween:Tween


func _enter_tree() -> void:
	GameState.camera_controller = self


func _ready() -> void:
	GameState.finished_walking.connect(func():
		animate_camera.rpc()
		)


func _process(delta: float) -> void:
	if tween and tween.is_running(): return
	
	var id = GameState.current_id
	var target = GameState.player_nodes[id].position
	position = position.lerp(target, min(12 * delta, 1))


@rpc("any_peer", "call_local", "reliable")
func animate_camera():
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", GameState.player_nodes[GameState.current_id].position, 1)
