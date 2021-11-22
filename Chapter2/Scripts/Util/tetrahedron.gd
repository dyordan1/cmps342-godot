extends RefCounted
# A utility class to store four vertices, reprsenting a tetrahedron

# Preloads
const Triangle = preload("res://Chapter2/Scripts/Util/triangle.gd")
var Tetrahedron = get_script()

# Member variables
var a
var b
var c
var d
var triangles


func _init(a, b, c, d):
	self.a = a
	self.b = b
	self.c = c
	self.d = d
	self.triangles = _make_triangles()


func _make_triangles():
	""" Utility function to allow ColoredTetrahedron to reuse constructor. """
	return [Triangle.new(a, b, c),
			Triangle.new(a, c, d),
			Triangle.new(a, d, b),
			Triangle.new(b, d, c)]


func _make_tetrahedron(a, b, c, d):
	""" Utility function to allow ColoredTetrahedron to reuse divide. """
	return Tetrahedron.new(a, b, c, d)


func divide(count):
	""" Subdivide a tetrahedron up to a limit, returning a list of tetrahedrons. """
	if count == 0:
		return [self]

	# Find midpoints of each side.
	var ab = 0.5 * (a + b)
	var ac = 0.5 * (a + c)
	var ad = 0.5 * (a + d)
	var bc = 0.5 * (b + c)
	var bd = 0.5 * (b + d)
	var cd = 0.5 * (c + d)

	# Subdivide all resulting tetrahedrons - except the middle (all four
	# midpoints).
	return  _make_tetrahedron(a, ab, ac, ad).divide(count - 1) \
			+ _make_tetrahedron(ab, b, bc, bd).divide(count - 1) \
			+ _make_tetrahedron(ac, bc, c, cd).divide(count - 1) \
			+ _make_tetrahedron(ad, bd, cd, d).divide(count - 1)


func vertex_data():
	""" Returns the vertices that make up the tetrahedron. """
	var verts = []

	for t in triangles:
		verts.append_array(t.vertex_data())

	return verts
