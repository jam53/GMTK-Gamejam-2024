extends Node2D

class_name AttackBoostFlower

@export var multiplier := 2
@export var radius : int = 250

@onready var area_drawing = $AreaDrawing
@onready var collision_shape_2d = $BoostArea/CollisionShape2D


func _ready():
	area_drawing.radius = radius
	collision_shape_2d.shape.radius = radius
	



func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		body.get_parent().multiply_attack(2)
	



func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().multiply_attack(1)
