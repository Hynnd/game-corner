class_name Util


static func rand_vector2(circular = false):
	var vec: Vector2 = Vector2.UP * 10
	if not circular:
		randomize(); vec.x = randf_range(-1, 1)
		randomize(); vec.y = randf_range(-1, 1)
	else:
		while vec.length() > 1:
			randomize(); vec.x = randf_range(-1, 1)
			randomize(); vec.y = randf_range(-1, 1)
	return vec


static func rand_vector3(spherical = false):
	var vec: Vector3 = Vector3.UP * 10
	if not spherical:
		randomize(); vec.x = randf_range(-1, 1)
		randomize(); vec.y = randf_range(-1, 1)
		randomize(); vec.z = randf_range(-1, 1)
	else:
		while vec.length() > 1:
			randomize(); vec.x = randf_range(-1, 1)
			randomize(); vec.y = randf_range(-1, 1)
			randomize(); vec.z = randf_range(-1, 1)
	return vec


static func move_toward_angles(from_rad: float, to_rad: float, weight: float):
	from_rad = fposmod(from_rad, PI*2)
	to_rad = fposmod(to_rad, PI*2)
	
	var distance: float = abs(to_rad - from_rad)
	
	if distance < PI: 
		return move_toward(from_rad, to_rad, weight)
	elif from_rad > to_rad: 
		return move_toward(from_rad - PI*2, to_rad, weight)
	else:
		return move_toward(from_rad + PI*2, to_rad, weight)


# 1 = 100%, 0 = 0%
static func rand_chance(chance: float) -> bool: 
	randomize()
	return randf() <= chance


static func is_mouse_captured() -> bool:
	return (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)


static func is_mouse_visible() -> bool:
	return (Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE)


static func create_timer(wait_time: float) -> Timer:
	var new_timer = Timer.new()
	new_timer.wait_time = wait_time
	new_timer.autostart = true
	return new_timer


static func get_all_children(node: Node) -> Array[Node]:
	var nodes: Array[Node] = []
	for n: Node in node.get_children():
		if n.get_child_count() > 0:
			nodes.append(n)
			nodes.append_array(get_all_children(n))
		else:
			nodes.append(n)
	return nodes


static func distance_to(from: float, to: float) -> float:
	return abs(from - to)


## Converts a number into a string with a set length.
## (e.g. x: 0.00001, length: 3 -> 0.0)
static func str_fixed_length(x: Variant, length: int) -> String:
	if x is float:
		# Offset negative numbers
		var neg: bool = x < 0.0
		var minus: int = 0 if neg else 0
		
		var text = str(x)
		while text.length() < length + minus:
			if not text.contains("."):
				text += "."
			else:
				text += "0"
		if text.length() > length:
			text = text.substr(0, length)
		return text
	elif x is Vector3:
		return str("(", str_fixed_length(x.x, length), ", ", str_fixed_length(x.y, length), ", ", str_fixed_length(x.z, length), ")")
	return ""


## @deprecated
static func zero_vector_in_direction(vector: Vector3, direction: Vector3) -> Vector3:
	## Calculate the dot product of the vector and the direction
	#var dot_product: float = vector.x * direction.x + vector.y * direction.y + vector.z * direction.z
	## Calculate the projection of the vector onto the direction
	#var projection := Vector3(dot_product * direction.x, dot_product * direction.y, dot_product * direction.z)
	## Subtract the projection from the original vector to get the zeroed vector
	#return Vector3(vector.x - projection.x, vector.y - projection.y, vector.z - projection.z)
	
	return scale_vector_in_direction(vector, direction, 0)


static func scale_vector_in_direction(vector: Vector3, direction: Vector3, scale: float) -> Vector3:
	# Calculate the dot product of the vector and the direction
	var dot_product: float = vector.x * direction.x + vector.y * direction.y + vector.z * direction.z
	# Calculate the projection of the vector onto the direction
	var projection: Vector3 = direction * dot_product
	# Subtract the projection from the original vector to get the zeroed vector
	return vector - projection + projection * scale


static func random_point_on_sphere(radius: float = 1.0) -> Vector3:
	#var theta = 2 * PI * randf()  # azimuth
	#var phi = acos(2 * randf() - 1)  # inclination
	#var x = radius * sin(phi) * cos(theta)
	#var y = radius * sin(phi) * sin(theta)
	#var z = radius * cos(phi)
	#return Vector3(x, y, z)
	
	return rand_vector3(true).normalized() * radius


static func get_points_aabb(points: PackedVector3Array) -> AABB:
	if points.size() == 0:
		return AABB()
	
	var aabb = AABB(points[0], Vector3.ZERO)
	for point: Vector3 in points:
		aabb = aabb.expand(point)
	return aabb


## Returns a readable string of an action's keys
static func get_action_keys_as_string(action:StringName) -> String:
	var events = InputMap.action_get_events(action)
	
	var text := ""
	for e in events:
		var k = e.as_text()
		if " (Physical)" in k:
			k = k.replace(" (Physical)", "")
		text += k
		if not e == events.back():
			text += ", "
	return "[" + text + "]"


static func get_child_by_class(parent:Node, c_name:String) -> Node:
	for child in parent.get_children():
		if child.is_class(c_name):
			return child
	return null


static func get_explosion_knockback(from_pos:Vector3, to_pos:Vector3, radius:float) -> Vector3:
	var force_dir = from_pos.direction_to(to_pos)
	var distance = to_pos.distance_to(from_pos)
	var exposure = clampf(remap(distance, 0, radius, 1, 0), 0, 1)
	return force_dir * exposure


static func get_flat_axis(aabb:AABB) -> Vector3:
	if aabb.size.x < aabb.size.y and aabb.size.x < aabb.size.z:
		return Vector3(1, 0, 0)
	if aabb.size.z < aabb.size.y and aabb.size.z < aabb.size.x:
		return Vector3(0, 0, 1)
	return Vector3(0, 1, 0)
