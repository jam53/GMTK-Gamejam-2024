extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Bears to spawn")
@export var basic_bear: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_bears(basic_bear, initial_amount)

# Generates a random position with the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	return Vector2(randf_range(top_left.x, bottom_right.x), randf_range(bottom_right.y, top_left.y))

# Instantiates a flower at a given position.
func spawn_bear(bear: PackedScene, pos: Vector2) -> Node:
	var bearInstance := bear.instantiate()
	bearInstance.position = pos
	add_child(bearInstance)
	return bearInstance 

# Generates a specified number of flowers of the given PackedScene type
func generate_bears(bear: PackedScene, amount := 1):
	for i in range(0, amount):
		var pos = generate_random_position()
		spawn_bear(bear, pos)
