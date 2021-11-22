extends "res://Chapter2/Scripts/Util/tetrahedron.gd"
# A utility class to store four vertices and three colors, reprsenting a colored tetrahedron

# Preloads
const ColoredTriangle = preload("res://Chapter2/Scripts/Util/colored_triangle.gd")
var ColoredTetrahedron = get_script()

# Member variables
var colors


func _init(a, b, c, d, colors):
	self.colors = colors
	super(a, b, c, d)


func _make_triangles():
	return [ColoredTriangle.new(a, b, c, colors[0]),
			ColoredTriangle.new(a, c, d, colors[1]),
			ColoredTriangle.new(a, d, b, colors[2]),
			ColoredTriangle.new(b, d, c, colors[3])]


func _make_tetrahedron(a, b, c, d):
	return ColoredTetrahedron.new(a, b, c, d, colors)


func color_data():
	""" Returns the color for each vertex. """
	var col = []
	
	for tri in triangles:
		col.append_array(tri.color_data())
		
	return col
