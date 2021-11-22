extends MeshInstance3D

# Preloads
const ColoredTetrahedron = preload("res://Chapter2/Scripts/Util/colored_tetrahedron.gd")

# Constants
var NUM_SUBDIVIDES = 7


func _ready():
	""" Called when the Node is dispatched. """
	
	var red = Color("#ff0000")
	var green = Color("#00ff00")
	var blue = Color("#0000ff")
	var yellow = Color("#ffff00")
	
	# Initialize the top level tetrahedron.
	var tetrahedron = ColoredTetrahedron.new(
		Vector3(0.0000, 0.0000, -1.0000),
		Vector3(0.0000, 0.9428, 0.3333),
		Vector3(-0.8165, -0.4714, 0.3333),
		Vector3(0.8165, -0.4714, 0.3333),
		[red, green, blue, yellow])

	# Subdivide NUM_SUBDIVIDES times.
	var tetras = tetrahedron.divide(NUM_SUBDIVIDES)

	# Add all points to the tool buffer
	var vertex_data = PackedVector3Array()
	var color_data = PackedColorArray()
	for t in tetras:
		vertex_data.append_array(t.vertex_data())
		color_data.append_array(t.color_data())

	# Pack vertex data and color data into a format add_surface_from_arrays
	# expects
	var array_data = []
	array_data.resize(ArrayMesh.ARRAY_MAX)
	array_data[ArrayMesh.ARRAY_VERTEX] = vertex_data
	array_data[ArrayMesh.ArrayType.ARRAY_COLOR] = color_data

	# Ship the vertex buffers to a new ArrayMesh instance
	var mesh = ArrayMesh.new()
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array_data)
	
	# Set the node's mesh property. This only works if the node this script is
	# attached to is a MeshInstance3D or MeshInstance2D.
	self.mesh = mesh
