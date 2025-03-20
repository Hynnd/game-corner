extends TextureRect

signal stopped_drawing

@export var tex_size:Vector2i = Vector2i(64, 64)
@export var pixel_size:float = 1

var image:Image

var _is_drawing:bool = false

@onready var timer:Timer = %Timer


func _ready() -> void:
	image = Image.create(tex_size.x, tex_size.y, false, Image.FORMAT_LA8)
	custom_minimum_size = tex_size * pixel_size
	size = custom_minimum_size


func _process(delta: float) -> void:
	var pos:Vector2i = get_mouse_pos()
	var margin:Vector2i = Vector2i((Vector2.ONE*(Pencil.brush_size/2.)/pixel_size).ceil())
	Pencil.on_canvas = pos == pos.clamp(-margin, tex_size+margin)
	
	if (Pencil.is_drawing or Pencil.is_erasing) and timer.is_stopped():
		timer.start()
		draw_pencil()
		texture = ImageTexture.create_from_image(image)
		_is_drawing = true
	if Input.is_action_just_released("left_click") or Input.is_action_just_released("right_click"):
		if _is_drawing:
			_is_drawing = false
			stopped_drawing.emit()


func draw_pencil() -> void:
	var pos:Vector2i = get_mouse_pos()
	var color:Color = Color.BLACK
	if Pencil.is_erasing: color = Color.TRANSPARENT
	var brush_size:float = float(Pencil.brush_size) / pixel_size
	var half_brush:float = brush_size / 2.
	
	for x:int in ceili(brush_size): for y:int in ceili(brush_size):
		var poss:Vector2i = pos + Vector2i(x, y) - Vector2i(half_brush,half_brush)
		if not is_point_on_canvas(poss): continue
		
		if pos.distance_to(poss) < half_brush and poss == poss.clamp(Vector2i.ZERO, tex_size-Vector2i.ONE):
			image.set_pixel(poss.x, poss.y, color)


func get_mouse_pos() -> Vector2i:
	return Vector2i(get_local_mouse_position() / pixel_size)


func is_point_on_canvas(point:Vector2i,margin:int=0) -> bool:
	var centered:Vector2i = point - tex_size/2
	var bevel:int = floori(tex_size.x * 0.81)
	if absi(centered.x) + absi(centered.y) > bevel: return false
	return true
