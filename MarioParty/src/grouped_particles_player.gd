extends Node

@export var lifetime:float = -1


func _ready() -> void:
	if lifetime >= 0:
		get_tree().create_timer(lifetime).timeout.connect(queue_free)
	
	for child in get_children():
		child.restart()
