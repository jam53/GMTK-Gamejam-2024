extends Line2D

@export var radius = 500  # The radius of the circle


func _ready():
	var num_sides = 64  # The number of sides of the polygon (more sides = smoother circle)
	var points = PackedVector2Array()
	
	for i in range(num_sides):
		var angle = (PI * 2 / num_sides) * i
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
	
	points.append(points[0])  # Close the circle by adding the first point at the end
	self.points = points
	self.width = 2  # Set the width of the line
	self.default_color = Color(1, 0, 0)  # Set the color to red
