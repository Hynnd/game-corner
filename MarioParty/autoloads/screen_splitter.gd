extends Node


func _ready():
	if "--window1" in OS.get_cmdline_args():
		get_window().position += Vector2i(-get_window().size.x, -get_window().size.y)/2
	if "--window2" in OS.get_cmdline_args():
		get_window().position += Vector2i(get_window().size.x, -get_window().size.y)/2
	if "--window3" in OS.get_cmdline_args():
		get_window().position += Vector2i(-get_window().size.x, get_window().size.y)/2
	if "--window4" in OS.get_cmdline_args():
		get_window().position += Vector2i(get_window().size.x, get_window().size.y)/2
