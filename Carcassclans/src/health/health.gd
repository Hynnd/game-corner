@icon("health.svg")
class_name Health extends Node

signal damaged
signal healed
signal hp_changed
signal died
signal revived

@export_range(0, 0, 1, "or_greater") var max_hp:float = 1
var hp:float = -1
var is_alive:bool:
	get: return hp > 0
var is_hurt:bool:
	get: return hp < max_hp


func _ready() -> void:
	if hp == -1:
		hp = max_hp


func damage(amount:float) -> void:
	if hp > 0:
		hp = move_toward(hp, 0, amount)
		damaged.emit()
		hp_changed.emit()
		if hp <= 0:
			died.emit()


func heal(amount:float) -> void:
	if hp < max_hp:
		hp = move_toward(hp, max_hp, amount)
		healed.emit()
		hp_changed.emit()


func heal_ratio(ratio:float) -> void:
	heal(max_hp * ratio)


func kill() -> void:
	damage(hp)


func revive() -> void:
	hp = max_hp
	healed.emit()
	hp_changed.emit()
	revived.emit()
