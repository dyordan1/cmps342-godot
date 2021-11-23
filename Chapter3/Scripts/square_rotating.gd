extends MeshInstance2D

# Preloads
const Triangle = preload("res://Chapter2/Scripts/Util/triangle.gd")

# Global variables
var window
var square_size
var square
var theta = 0;


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
	square_size = min(window.size[0], window.size[1]) * 0.6 # small "padding"

	square = [
		Vector3(-1, 1, 0),
		Vector3(1, 1, 0),
		Vector3(1, -1, 0),
		Vector3(-1, -1, 0),
	]


# Utility function to rotate a vertex.
func _rotated(vert):
	var s = sin(theta);
	var c = cos(theta);
	return Vector3(-s * vert.y + c * vert.x, s * vert.x + c * vert.y, 0);


func _process(delta):
	# delta is the time since last frame - so this will rotate at
	# PI radians / second, i.e. 1 rotation every 2 seconds.
	theta += PI * delta;
	
	var triangles = [
		Triangle.new(_rotated(square[0]), _rotated(square[1]), _rotated(square[2])),
		Triangle.new(_rotated(square[2]), _rotated(square[3]), _rotated(square[0])),
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
