extends MeshInstance2D

# Preloads
const Triangle = preload("res://Chapter2/Scripts/Util/triangle.gd")

# Global variables
var window
var square_size


func toScreenCoordinate(vec3):
	""" Convert a vec3 with values [-1;1] to screen space. """

	return Vector3(
		vec3[0] * (square_size / 2) + window.size[0] / 2,
		vec3[1] * (square_size / 2) + window.size[1] / 2,
		0) # Z is ignored in 2D


func _ready():
	""" Called when the Node is dispatched. """

	# Collect window data once - used in toScreenCoordinates.
	window = get_viewport()
	square_size = min(window.size[0], window.size[1]) * 0.9 # small "padding"

	var square = [
		Vector3(-1, 1, 0),
		Vector3(1, 1, 0),
		Vector3(1, -1, 0),
		Vector3(-1, -1, 0),
	]
	
	var triangles = [
		Triangle.new(square[0], square[1], square[2]),
		Triangle.new(square[2], square[3], square[0]),
	]

	# Initialize a Surface Tool in POINTS mode
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
