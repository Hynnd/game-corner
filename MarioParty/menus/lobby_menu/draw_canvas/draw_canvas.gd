extends TextureRect

signal stopped_drawing

@export var tex_size:Vector2i = Vector2i(64, 64)


var image:Image

var _is_drawing:bool = false


func _ready() -> void:
	image = Image.create(tex_size.x, tex_size.y, false, Image.FORMAT_LA8)


func _physics_process(delta: float) -> void:
	var pos:Vector2i = Vector2i(get_local_mouse_position())
	Pencil.on_canvas = pos == pos.clamp(Vector2i.ZERO, tex_size)
	if Pencil.is_drawing or Pencil.is_erasing:
		draw_pencil()
		texture = ImageTexture.create_from_image(image)
		_is_drawing = true
	if Input.is_action_just_released("left_click") or Input.is_action_just_released("right_click") and Pencil.on_canvas:
		if _is_drawing:
			_is_drawing = false
			stopped_drawing.emit()
	


func draw_pencil():
	var pos:Vector2i = Vector2i(get_local_mouse_position())
	var color = Color.BLACK
	if Pencil.is_erasing: color = Color.TRANSPARENT
	var half_brush = Pencil.brush_size/2
	
	if pos == pos.clamp(Vector2i.ZERO, tex_size):
		for x in Pencil.brush_size: for y in Pencil.brush_size:
			var poss = pos + Vector2i(x, y) - Vector2i(half_brush,half_brush)
			poss.clamp(Vector2i.ZERO, tex_size)
			if pos.distance_to(poss) <= half_brush:
				image.set_pixel(poss.x, poss.y, color)
