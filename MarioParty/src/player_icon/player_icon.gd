extends ColorRect

var id:int = -1

@export var auto_update:bool = false

@onready var face: TextureRect = %Face
@onready var timer: Timer = %Timer
@onready var polygon_2d: Polygon2D = %Polygon2D


func _ready() -> void:
	timer.timeout.connect(func():
		if auto_update:
			_refresh()
		)


func _refresh() -> void:
	modulate = GameState.players[id].color
	
	if GameState.players[id].face != null:
		var image = Image.new()
		image.load_png_from_buffer(GameState.players[id].face)
		face.texture = ImageTexture.create_from_image(image)
