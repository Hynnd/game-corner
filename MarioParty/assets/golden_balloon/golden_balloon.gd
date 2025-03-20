extends Marker3D

var line_length:float = 3

@onready var balloon: RigidBody3D = %Balloon
@onready var line: Node3D = %Line
@onready var pin: StaticBody3D = %Pin


func _ready() -> void:
	#randomize()
	#pin.position.y += randf_range(0.0, 0.15)
	randomize()
	pin.position.x += randf_range(0.25, 0.25)
	randomize()
	pin.position.z += randf_range(0.25, 0.25)
	balloon.top_level = true
	line.top_level = true


func _process(delta: float) -> void:
	line.position = global_position
	line.look_at_from_position(global_position, balloon.global_position)
	line.scale.z = global_position.distance_to(balloon.global_position)
