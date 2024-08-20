extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect
@export var dont_spawn_area : ReferenceRect

@export_category("Items to spawn")
@export var scene: PackedScene
@export var group: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if scene:
		generate_items(scene, initial_amount)

# Generates a random position within the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	var new_pos = Vector2(randf_range(top_left.x, bottom_right.x), randf_range(top_left.y, bottom_right.y))
	
	while get_closest_in_group(new_pos) < 100 or is_in_dont_spawn_area(new_pos):
		new_pos = Vector2(randf_range(top_left.x, bottom_right.x), randf_range(top_left.y, bottom_right.y))
	return new_pos

# Checks if a position is within the dont_spawn_area
func is_in_dont_spawn_area(pos: Vector2) -> bool:
	if dont_spawn_area:
		var dont_spawn_rect = dont_spawn_area.get_rect()
		return dont_spawn_rect.has_point(pos)
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
		spawn_item(flower, pos)
		
func get_closest_in_group(pos: Vector2) -> float:
	var closest_distance : float = INF
	for item in get_tree().get_nodes_in_group(group):
		var distance = pos.distance_to(item.position)
		if distance < closest_distance:
			closest_distance = distance
	return closest_distance
