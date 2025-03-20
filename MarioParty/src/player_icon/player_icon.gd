extends ColorRect

var id:int = -1

@export var auto_update:bool = false

@onready var texture_rect: TextureRect = %TextureRect
@onready var timer: Timer = %Timer
@onready var polygon_2d: Polygon2D = %Polygon2D


func _ready() -> void:
	timer.timeout.connect(func():
		if auto_update:
			_refresh()
		)


func _refresh() -> void:
	#color = GameState.players[id].color
	#polygon_2d.modulate = GameState.players[id].color
	modulate = GameState.players[id].color
	
	if GameState.players[id].face != null:
		var image = Image.new()
		image.load_png_from_buffer(GameState.players[id].face)
		texture_rect.texture = ImageTexture.create_from_image(image)
