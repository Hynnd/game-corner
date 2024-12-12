extends Camera2D

@export var move_speed:float = 10


func _process(delta: float) -> void:
	var move_input = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	position += move_input * move_speed * delta
