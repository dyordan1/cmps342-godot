extends MeshInstance2D

# Constants
var NUM_POINTS = 10000

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

	# Collect window data once - used in toScreenCoordinates.
	window = get_viewport()
	gasket_size = min(window.size[0], window.size[1]) * 0.9 # small "padding"

	# Initialize the tips of the gasket.
	var verts = [
		Vector3(-1, -1, 0),
		Vector3(0,  1, 0),
		Vector3(1, -1, 0)]

	# Seed the gasket with the first point - midpoint of the line connecting
	# the midpoints of two sides.
	var u = 0.5 * (verts[0] + verts[1])
	var v = 0.5 * (verts[0] + verts[2])
	var p = 0.5 * (u + v)
	var points = [ p ]

	# Generate NUM_POINTS random points
	var rng = RandomNumberGenerator.new()
	for i in range(0, NUM_POINTS):
		var j = rng.randi_range(0, 2)
		p = 0.5 * (points[i] + verts[j])
		points.append(p)

	# Initialize a Surface Tool in POINTS mode
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_POINTS)

	# Add all points to the tool buffer
	for vert in points:
		st.add_vertex(toScreenCoordinate(vert))

	# Ship the vertex buffer to a new ArrayMesh instance
	var mesh = ArrayMesh.new()
	st.commit(mesh)

	# Set the node's mesh property. This only works if the node this script is
	# attached to is a MeshInstance3D or MeshInstance2D.
	self.mesh = mesh
