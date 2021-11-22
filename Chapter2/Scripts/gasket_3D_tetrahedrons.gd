extends MeshInstance3D

# Preloads
const Tetrahedron = preload("res://Chapter2/Scripts/Util/tetrahedron.gd")

# Constants
var NUM_SUBDIVIDES = 7


func _ready():
	""" Called when the Node is dispatched. """
	
	# Initialize the top level tetrahedron.
	var tetrahedron = Tetrahedron.new(
		Vector3(0.0000, 0.0000, -1.0000),
		Vector3(0.0000, 0.9428, 0.3333),
		Vector3(-0.8165, -0.4714, 0.3333),
		Vector3(0.8165, -0.4714, 0.3333))

	# Subdivide NUM_SUBDIVIDES times.
	var tetras = tetrahedron.divide(NUM_SUBDIVIDES)

	# Initialize a Surface Tool in POINTS mode
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Add all points to the tool buffer
	for t in tetras:
		for v in t.vertex_data():
			st.add_vertex(v)

	# Ship the vertex buffer to a new ArrayMesh instance
	var mesh = ArrayMesh.new()
	st.commit(mesh)
	
	# Set the node's mesh property. This only works if the node this script is
	# attached to is a MeshInstance3D or MeshInstance2D.
	self.mesh = mesh
