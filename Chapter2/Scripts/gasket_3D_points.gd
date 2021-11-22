extends MeshInstance3D

# Constants
var NUM_POINTS = 10000


func _ready():
	""" Called when the Node is dispatched. """

	# Initialize the vertices of our 3D gasket - four vertices on unit circle
	# Intial tetrahedron with equal length sides.
	var verts = [
		Vector3(0.0000, 0.0000, -1.0000),
		Vector3(0.0000, 0.9428, 0.3333),
		Vector3(-0.8165, -0.4714, 0.3333),
		Vector3(0.8165, -0.4714, 0.3333)
	];

	# Seed the gasket with the first point - midpoint of the line connecting
	# the midpoints of two sides.
	var points = [ Vector3(0, 0, 0) ]

	# Generate NUM_POINTS random points
	var rng = RandomNumberGenerator.new()
	for i in range(0, NUM_POINTS):
		var j = rng.randi_range(0, 3)
		var p = 0.5 * (points[i] + verts[j])
		points.append(p)

	# Initialize a Surface Tool in POINTS mode
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_POINTS)

	# Add all points to the tool buffer
	for vert in points:
		st.add_vertex(vert)

	# Ship the vertex buffer to a new ArrayMesh instance
	var mesh = ArrayMesh.new()
	st.commit(mesh)
	
	# Set the node's mesh property. This only works if the node this script is
	# attached to is a MeshInstance3D or MeshInstance2D.
	self.mesh = mesh
