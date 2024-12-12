extends Area2D

## Damage per second
@export var damage:float = 1


func _physics_process(delta: float) -> void:
	attack(delta * damage)


func attack(damage:float) -> void:
	var bodies = get_overlapping_bodies()
	var areas = get_overlapping_areas()
	
	for node in bodies + areas:
		if node.has_method("take_damage"):
			var atk = AttackEvent.new()
			atk.damage = damage
			node.take_damage(atk)
