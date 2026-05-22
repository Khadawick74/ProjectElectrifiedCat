# Adaptation of code from DevPoodle: https://youtu.be/6qim01M1Yp0

@tool
extends MeshInstance3D

@export_range(256, 2048, 64) var size := 256.0

# Tell us how defined our worldgen is (Lit. Resolution)
@export_range(4, 256, 4) var resolution := 32:
	set(new_resolution):
		resolution = new_resolution
		update_mesh()

# Create variable of noise to change per-vertex noise
@export var noise: FastNoiseLite:
	set(new_noise):
		noise = new_noise
		update_mesh()
		# If noise exists, we update the mesh if any of the noise parameters are changed
		if noise:
			noise.changed.connect(update_mesh)

# Height range that the mesh will distort to			
@export_range(4.0, 128.0, 4.0) var height := 64:
	set(new_height):
		height = new_height
		# Set the height for the shader
		material_override.set_shader_parameter("height", height * 2.0)
		update_mesh()

# Get the height for verts based on noise
func get_height(x: float, y: float) -> float:
	return noise.get_noise_2d(x, y) * height

# Get the normal for verts based on noise
func get_normal(x: float, y: float) -> Vector3:
	var epsilon := size / resolution
	# Get the normals. Sort of like getting the average for the point.
	var normal := Vector3(
		# Horizontal - epsilon is offset to be one vertex over
		(get_height(x + epsilon, y) - get_height(x - epsilon, y)) / (2.0 * epsilon),
		1.0,
		# Vertical
		(get_height(x, y + epsilon) - get_height(x, y - epsilon)) / (2.0 * epsilon)
	)
	# Return the normal
	return normal.normalized()

# Update the mesh accordingly		
func update_mesh() -> void:
	# Create a new plane and set parameters accordingly
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	
	# Get vertices, normals, etc
	var plane_arrays := plane.get_mesh_arrays()
	var vertex_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_VERTEX]
	var normal_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_NORMAL]
	var tangent_array: PackedFloat32Array = plane_arrays[ArrayMesh.ARRAY_TANGENT]
	
	# Loop over the vertices and adjust them
	for i:int in vertex_array.size():
		var vertex := vertex_array[i]
		# The current normals stored in here are not the ones we want, same with tangent.
		var normal := Vector3.UP
		var tangent := Vector3.RIGHT
		if noise:
			# x and z are horizontal components, y is vertical. 
			vertex.y = get_height(vertex.x, vertex.z)
			normal = get_normal(vertex.x, vertex.z)
			# Give us something perpendicular to normal - i.e., what a tangent is
			tangent = normal.cross(Vector3.UP)
		# Set array values
		vertex_array[i] = vertex
		normal_array[i] = normal
		# Tangent is split into several components
		tangent_array[4 * i] = tangent.x
		tangent_array[4 * i + 1] = tangent.y
		tangent_array[4 * i + 2] = tangent.z
	
	# Create a new array mesh according to the plane above
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	mesh = array_mesh
