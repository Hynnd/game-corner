extends Control

signal path_chosen(path:int)

@onready var left_button: Button = %LeftButton
@onready var right_button: Button = %RightButton


func _ready() -> void:
	left_button.pressed.connect(func():
		path_chosen.emit(0)
		)
	right_button.pressed.connect(func():
		path_chosen.emit(1)
		)
	hide()
