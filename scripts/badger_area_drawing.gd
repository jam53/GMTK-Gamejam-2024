extends Line2D

@export var radius = 500:  # The radius of the circle
	set(value):
		radius = value
		_draw_circle()
		
@export var color: Color = Color(1, 0, 0)  # The color of the circle (default is red)

func _ready():
	_draw_circle()
	
func _draw_circle():
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
	self.default_color = color  # Use the exported color
