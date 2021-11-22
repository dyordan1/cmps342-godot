extends "res://Chapter2/Scripts/Util/triangle.gd"
# A utility class to store three vertices and a color, reprsenting a colored triangle

# Preloads
var ColoredTriangle = get_script()

# Member Variables
var color


func _init(a, b, c, color):
	super(a, b, c)
	self.color = color


func _make_triangle(a, b, c):
	""" Utility function to allow ColoredTriangle to reuse divide. """
	return ColoredTriangle.new(a, b, c, color)


func color_data():
	""" Returns the color for each vertex. """
	return [color, color, color]
