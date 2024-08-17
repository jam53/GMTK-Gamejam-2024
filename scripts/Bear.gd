# BearScript.gd
extends Node2D

@export var speed: float = 30.0

var target_flower: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial call to find the closest flower
	find_closest_flower()

# Finds the closest flower and sets it as the target
func find_closest_flower():
	var closest_distance = INF
	target_flower = null  # Reset target_flower before finding the closest one
	for flower in Global.flowers:
		var distance = position.distance_to(flower.position)
		if distance < closest_distance:
			closest_distance = distance
			target_flower = flower
	if target_flower:
		print("Closest flower found at position: ", target_flower.position)
	else:
		print("No flowers found.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Continuously find the closest flower
	find_closest_flower()
	if target_flower:
		var direction = (target_flower.position - position).normalized()
		position += direction * speed * delta
		print("Bear position: ", position)
		print("Target flower position: ", target_flower.position)
		print("Distance to target: ", position.distance_to(target_flower.position))
	else:
		print("No target flower to move towards.")
