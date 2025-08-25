# Adaptation of code from DevPoodle: https://youtu.be/6qim01M1Yp0

@tool
extends MeshInstance3D

const size := 256.0

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
		update_mesh()

# Update the mesh accordingly		
func update_mesh() -> void:
	# Create a new plane and set parameters accordingly
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	
	# Get vertices, normals, etc
	var plane_arrays := plane.get_mesh_arrays()
	# Create a new array mesh according to the plane above
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	mesh = array_mesh
