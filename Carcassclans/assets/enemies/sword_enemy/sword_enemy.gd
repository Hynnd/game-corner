extends RigidBody2D


func take_damage(atk:AttackEvent) -> void:
	queue_free()
