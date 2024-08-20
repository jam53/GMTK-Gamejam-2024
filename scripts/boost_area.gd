extends Area2D

@onready var boost_collision = $CollisionShape2D
@onready var area_drawing = $AreaDrawing

@export var radius : int = 250
@export var color : Color = Color(1, 0, 0)


func _ready():
	area_drawing.radius = radius
	area_drawing.color = color
	boost_collision.shape.radius = radius
