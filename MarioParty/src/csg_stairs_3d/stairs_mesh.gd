class_name StairsMesh extends ArrayMesh

enum Face { FORWARD, BACK, RIGHT, LEFT, DOWN, UP }

const NORMALS: Array[Vector3] = [
	Vector3.FORWARD, Vector3.BACK, Vector3.RIGHT, Vector3.LEFT, Vector3.DOWN, Vector3.UP,
	]

const CUBE_VERTICES: Array[Vector3] = [
	Vector3(-0.5, -0.5, -0.5), # 0 (Forward face)
	Vector3( 0.5, -0.5, -0.5), # 1
	Vector3( 0.5,  0.5, -0.5), # 2
	Vector3(-0.5,  0.5, -0.5), # 3
	Vector3(-0.5, -0.5,  0.5), # 4 (Back face)
	Vector3( 0.5, -0.5,  0.5), # 5
	Vector3( 0.5,  0.5,  0.5), # 6
	Vector3(-0.5,  0.5,  0.5)  # 7
	]

const CUBE_INDICES: Array[Array] = [
	[3, 0, 1, 1, 2, 3], # Forward face
	[6, 5, 4, 4, 7, 6], # Back face
	[2, 1, 5, 5, 6, 2], # Right face
	[4, 0, 3, 3, 7, 4], # Left face (!BREAKS UV RULE TO FIT THE STAIR SHAPE!)
	[0, 4, 5, 5, 1, 0], # Down face
	[2, 6, 7, 7, 3, 2]  # Up face
	]

const SLOPE_INDICES: Array[Array] = [
	[2, 5, 4, 4, 3, 2], # Up
	[3, 4, 5, 5, 2, 3],  # Down
	]

const RECT_UVS: Array[Vector2] = [
	Vector2(0.0, 1.0), # 0
	Vector2(0.0, 0.0), # 1
	Vector2(1.0, 0.0), # 2
	Vector2(1.0, 1.0), # 3
	]

const QUAD_UVS: Array[Vector2] = [
	RECT_UVS[2],
	RECT_UVS[3],
	RECT_UVS[0],
	RECT_UVS[0],
	RECT_UVS[1],
	RECT_UVS[2],
	]

const X_AXIS_INDICES: Array[int] = [int(Face.RIGHT), int(Face.LEFT)]

var mesh_data: Array = []


func generate_stairs(size: Vector3, fill: bool, steps: int) -> void:
	mesh_data = _create_empty_array()
	mesh_data = _draw_steps(mesh_data, size, not fill, steps)
	if fill:
		mesh_data = _draw_base(mesh_data, size)
	
	# Create mesh
	clear_surfaces()
	if mesh_data[ARRAY_VERTEX].size() > 0:
		add_surface_from_arrays(PRIMITIVE_TRIANGLES, mesh_data)


func generate_slope(size: Vector3, fill: bool) -> void:
	mesh_data = _create_empty_array()
	
	mesh_data = _draw_slope(mesh_data, size, not fill)
	if fill:
		mesh_data = _draw_base(mesh_data, size)
	
	# Create mesh
	clear_surfaces()
	if mesh_data[ARRAY_VERTEX].size() > 0:
		add_surface_from_arrays(PRIMITIVE_TRIANGLES, mesh_data)


func _draw_steps(m_data: Array, size: Vector3, draw_inside: bool, steps: int) -> Array:
	var vertices: PackedVector3Array = PackedVector3Array()
	var normals: PackedVector3Array = PackedVector3Array()
	var uvs: PackedVector2Array = PackedVector2Array()
	
	var faces: Array[int] = [Face.BACK, Face.UP, Face.LEFT, Face.RIGHT]
	if draw_inside:
		faces.append(Face.FORWARD)
		faces.append(Face.DOWN)
	
	var step_size: Vector3 = Vector3(size.x, size.y / float(steps), size.z / float(steps))
	for step: int in steps:
		var ratio: float = float(step) / float(steps)
		for face_index: int in faces:
			var indices_indices = range(0, 6) if draw_inside or not face_index in X_AXIS_INDICES else range(3, 6)
			for indices_index: int in indices_indices:
				# Vertex
				var vertex_index: int = CUBE_INDICES[face_index][indices_index]
				var vertex: Vector3 = CUBE_VERTICES[vertex_index]
				vertex *= step_size
				vertex += Vector3(0, -ratio * size.y, ratio * size.z)
				vertex += Vector3(0, size.y * 0.5, -size.z * 0.5)
				vertex += Vector3(0, -step_size.y * 0.5, step_size.z * 0.5)
				vertices.append(vertex)
				
				# Normal
				normals.append(NORMALS[face_index])
				
				# UV
				var uv: Vector2 = QUAD_UVS[indices_index]
				if not draw_inside:
					var size_space_uv: Vector2 = Vector2(vertex.z / size.z + 0.5, vertex.y / size.y + 0.5)
					if face_index == Face.RIGHT:
						uv = Vector2(1.0, 1.0) - size_space_uv
					elif face_index == Face.LEFT:
						uv = Vector2(size_space_uv.x, 1.0 - size_space_uv.y)
				else:
					if face_index == Face.LEFT:
						uv = Vector2(uv.y, uv.x)
				uvs.append(uv)
	
	m_data[ARRAY_TEX_UV].append_array(uvs)
	m_data[ARRAY_NORMAL].append_array(normals)
	m_data[ARRAY_VERTEX].append_array(vertices)
	return m_data


func _draw_slope(arr: Array, size: Vector3, draw_under: bool) -> Array:
	var vertices: PackedVector3Array = PackedVector3Array()
	var normals: PackedVector3Array = PackedVector3Array()
	var uvs: PackedVector2Array = PackedVector2Array()
	
	var num_faces: int = 1
	if draw_under:
		num_faces += 1
	
	for face_index: int in num_faces:
		var normal: Vector3 = Vector3(0, size.z, size.y).normalized()
		for indices_index: int in SLOPE_INDICES[face_index].size():
			# Vertex
			var vertex_index: int = SLOPE_INDICES[face_index][indices_index]
			var vertex: Vector3 = CUBE_VERTICES[vertex_index]
			vertex *= size
			vertices.append(vertex)
			# Normal
			normals.append(normal)
			# UV
			var uv: Vector2 = QUAD_UVS[indices_index]
			uvs.append(uv)
	
	arr[ARRAY_TEX_UV].append_array(uvs)
	arr[ARRAY_NORMAL].append_array(normals)
	arr[ARRAY_VERTEX].append_array(vertices)
	return arr


func _draw_base(arr: Array, size: Vector3) -> Array:
	var vertices: PackedVector3Array = PackedVector3Array()
	var normals: PackedVector3Array = PackedVector3Array()
	var uvs: PackedVector2Array = PackedVector2Array()
	
	for face_index: int in [Face.FORWARD, Face.DOWN, Face.LEFT, Face.RIGHT]:
		for indices_index: int in CUBE_INDICES[face_index].size():
			if face_index in X_AXIS_INDICES and indices_index > 2:
				break
			# Vertex
			var vertex_index: int = CUBE_INDICES[face_index][indices_index]
			var vertex: Vector3 = CUBE_VERTICES[vertex_index]
			vertex *= Vector3(size.x, size.y, size.z)
			vertices.append(vertex)
			# Normal
			normals.append(NORMALS[face_index])
			# UV
			var uv: Vector2 = QUAD_UVS[indices_index]
			if face_index == Face.LEFT:
				uv = Vector2(1.0 - uv.y, uv.x)
			uvs.append(uv)
	
	arr[ARRAY_TEX_UV].append_array(uvs)
	arr[ARRAY_NORMAL].append_array(normals)
	arr[ARRAY_VERTEX].append_array(vertices)
	return arr


func _create_empty_array() -> Array:
	var arr: Array = []
	arr.resize(ARRAY_MAX)
	arr[ARRAY_TEX_UV] = PackedVector2Array()
	arr[ARRAY_NORMAL] = PackedVector3Array()
	arr[ARRAY_VERTEX] = PackedVector3Array()
	return arr
