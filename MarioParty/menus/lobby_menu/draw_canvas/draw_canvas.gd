extends TextureRect

signal stopped_drawing

@export var tex_size:Vector2i = Vector2i(64, 64)
@export var pixel_size:float = 1

var image:Image

var _is_drawing:bool = false


func _ready() -> void:
	image = Image.create(tex_size.x, tex_size.y, false, Image.FORMAT_LA8)
	custom_minimum_size = tex_size * pixel_size
	size = custom_minimum_size


func _physics_process(delta: float) -> void:
	var pos:Vector2i = get_mouse_pos()
	var margin:Vector2i = Vector2i((Vector2.ONE*(Pencil.brush_size/2.)/pixel_size).ceil())
	Pencil.on_canvas = pos == pos.clamp(-margin, tex_size+margin)
	
	if Pencil.is_drawing or Pencil.is_erasing:
		draw_pencil()
		texture = ImageTexture.create_from_image(image)
		_is_drawing = true
	if Input.is_action_just_released("left_click") or Input.is_action_just_released("right_click") and Pencil.on_canvas:
		if _is_drawing:
			_is_drawing = false
			stopped_drawing.emit()


func draw_pencil():
	var pos:Vector2i = get_mouse_pos()
	var color = Color.BLACK
	if Pencil.is_erasing: color = Color.TRANSPARENT
	var brush_size = float(Pencil.brush_size) / pixel_size
	var half_brush = brush_size / 2.
	
	for x in ceili(brush_size): for y in ceili(brush_size):
		var poss = pos + Vector2i(x, y) - Vector2i(half_brush,half_brush)
		if pos.distance_to(poss) < half_brush and poss == poss.clamp(Vector2i.ZERO, tex_size-Vector2i.ONE):
			image.set_pixel(poss.x, poss.y, color)


func get_mouse_pos() -> Vector2i:
	return Vector2i(get_local_mouse_position()) / pixel_size
