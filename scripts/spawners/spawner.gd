extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Items to spawn")
@export var scene: PackedScene
@export var group: String

var spawned_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if scene:
		generate_items(scene, initial_amount)

# Generates a random position within the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	return Vector2(randf_range(top_left.x, bottom_right.x), randf_range(bottom_right.y, top_left.y))

# Checks if the position is too close to any existing positions
func is_too_close(pos: Vector2, min_distance: float) -> bool:
	for existing_pos in spawned_positions:
		if pos.distance_to(existing_pos) < min_distance:
			return true
	return false

# Instantiates a flower at a given position.
func spawn_item(flower: PackedScene, pos: Vector2) -> Node:
	if flower:
		var instance = flower.instantiate()
		instance.position = pos
		add_child(instance)
		return instance
	else:
		return null

# Generates a specified number of flowers of the given PackedScene type
func generate_items(flower: PackedScene, amount := 1):
	for i in range(0, amount):
		var pos = generate_random_position()
		while is_too_close(pos, 300):
			pos = generate_random_position()
		spawn_item(flower, pos)
		spawned_positions.append(pos)
