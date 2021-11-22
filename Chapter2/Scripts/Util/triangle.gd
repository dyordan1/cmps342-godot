extends RefCounted
# A utility class to store three vertices, reprsenting a triangle

# Preloads
var Triangle = get_script()

# Member variables
var a
var b
var c


func _init(a, b, c):
	self.a = a
	self.b = b
	self.c = c


func _make_triangle(a, b, c):
	""" Utility function to allow ColoredTriangle to reuse divide. """
	return Triangle.new(a, b, c)


func divide(count):
	""" Subdivide a triangle up to a limit, returning a list of triangles. """
	if count == 0:
		return [self]

	# Find midpoints of each side.
	var ab = 0.5 * (a + b)
	var ac = 0.5 * (a + c)
	var bc = 0.5 * (b + c)

	# Subdivide all resulting triangles - except the middle (all three
	# midpoints).
	return  _make_triangle(a, ab, ac).divide(count - 1) \
			+ _make_triangle(c, ac, bc).divide(count - 1) \
			+ _make_triangle(b, bc, ab).divide(count - 1)


func vertex_data():
	""" Returns the vertices that make up the triangle. """
	return [a, b, c]
