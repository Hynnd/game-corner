extends HBoxContainer

var icons := {}


func _process(delta: float) -> void:
	for id in GameState.players.keys():
		if not icons.has(id):
			#var rect = ColorRect.new()
			#rect.custom_minimum_size = Vector2i(32,32)
			#rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			#$HBoxContainer.add_child(rect)
			#icons[id] = icon
			
			var icon = preload("res://src/player_icon/player_icon.tscn").instantiate()
			icon.id = id
			icon.auto_update = true
			$HBoxContainer.add_child(icon)
			
			icons[id] = icon
	
	for id in icons.keys():
		var icon = icons[id]
		if GameState.players[id].has("color"):
			icon.color = GameState.players[id].color
	
	$Label2.text = str(owner.num_ready_players, "/", multiplayer.get_peers().size()+1)
