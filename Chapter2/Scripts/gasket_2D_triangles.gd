extends MeshInstance2D

# Preloads
const Triangle = preload("res://Chapter2/Scripts/Util/triangle.gd")

# Constants
var NUM_SUBDIVIDES = 7

# Global variables
var window
var gasket_size


func toScreenCoordinate(vec3):
	""" Convert a vec3 with values [-1;1] to screen space. """

	return Vector3(
		vec3[0] * (gasket_size / 2) + window.size[0] / 2,
		vec3[1] * (gasket_size / 2) + window.size[1] / 2,
		0) # Z is ignored in 2D


func _ready():
	""" Called when the Node is dispatched. """

	# Collect window data once - used in toScreenCoordinate.
	window = get_viewport()
	gasket_size = min(window.size[0], window.size[1]) * 0.9 # small "padding"

	# Initialize the top level triangle.
	var triangle = Triangle.new(
		Vector3(-1, -1, 0),
		Vector3(0,  1, 0),
		Vector3(1, -1, 0))

	# Subdivide NUM_SUBDIVIDES times.
	var triangles = triangle.divide(NUM_SUBDIVIDES)

	# Initialize a Surface Tool in TRIANGLES mode
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Add all points to the tool buffer
	for tri in triangles:
		for v in tri.vertex_data():
			st.add_vertex(toScreenCoordinate(v))

	# Ship the vertex buffer to a new ArrayMesh instance
	var mesh = ArrayMesh.new()
	st.commit(mesh)

	# Set the node's mesh property. This only works if the node this script is
	# attached to is a MeshInstance3D or MeshInstance2D.
	self.mesh = mesh
