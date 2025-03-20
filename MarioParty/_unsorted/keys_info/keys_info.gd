extends Control

@export var keys:Array[String] = []

@onready var container: HBoxContainer = %Container


func _ready() -> void:
	for st in keys:
		var label = %Label.duplicate()
		label.text = st
		container.add_child(label)
	
	%Label.hide()
