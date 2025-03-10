extends Control

@onready var host_button: Button = $HBoxContainer/HostButton
@onready var join_button: Button = $HBoxContainer/JoinButton


func _ready() -> void:
	host_button.pressed.connect(func():
		Multiplayer.create_server()
		)
	join_button.pressed.connect(func():
		Multiplayer.join_server()
		)
