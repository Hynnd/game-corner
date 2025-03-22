extends Control

@export var game_name:String
@export_multiline var description:String

@onready var title_label: Label = %Title
@onready var description_label: Label = %Description


func _ready() -> void:
	%ReadyUpPanel.all_ready.connect(func():
		hide()
		)
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
