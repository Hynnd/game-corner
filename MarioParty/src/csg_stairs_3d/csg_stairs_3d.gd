@tool
class_name CSGStairs3D extends CSGBox3D

const InvisibleMaterial := preload("invisible_material.tres")

@export var steps: int = 5:
	set(value):
		steps = maxi(value, 0)
		redraw()

@export var fill: bool = true:
	set(value):
		fill = value
		redraw()

# Mesh
var stairs_mesh: StairsMesh = StairsMesh.new()
# Nodes
var mesh_instance: MeshInstance3D = MeshInstance3D.new()
var static_body: StaticBody3D = StaticBody3D.new()
var collider: CollisionShape3D = CollisionShape3D.new()
var collision_shape: ConcavePolygonShape3D = ConcavePolygonShape3D.new()

@onready var _size: Vector3 = size


func _init() -> void:
	add_child(mesh_instance)
	mesh_instance.mesh = stairs_mesh
	mesh_instance.material_override = material
	
	add_child(static_body)
	static_body.add_child(collider)
	collider.shape = collision_shape
	
	material_override = InvisibleMaterial
	redraw()


func _process(_delta: float) -> void:
	if _size != size:
		_size = size
		redraw()


func redraw() -> void:
	# Mesh
	if steps > 0:
		stairs_mesh.generate_stairs(size, fill, steps)
	else:
		stairs_mesh.generate_slope(size, fill)
	stairs_mesh.regen_normal_maps()
	# Colliders
	collision_shape.set_faces(stairs_mesh.get_faces())
