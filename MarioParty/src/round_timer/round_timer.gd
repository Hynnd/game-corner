extends Node

## Seconds
@export var round_time:float = 60 * 3

var _counter:float

@onready var label: Label = %Label


func _ready() -> void:
	_counter = round_time


func _process(delta: float) -> void:
	if _counter > 0:
		_counter -= delta
		if _counter <= 0:
			if multiplayer.is_server():
				get_tree().current_scene.exit()
	
	label.text = Time.get_time_string_from_unix_time(_counter).erase(0, 3)
