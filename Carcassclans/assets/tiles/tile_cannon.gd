extends Area2D

@onready var range_area: Area2D = %RangeArea
@onready var attack_cooldown: Timer = %AttackCooldown


func _process(delta: float) -> void:
	if attack_cooldown.is_stopped() and range_area.has_overlapping_bodies():
		attack_cooldown.start()
		
		var target = range_area.get_closest_target()
		var atk = AttackEvent.new()
		atk.damage = 1
		target.take_damage(atk)
