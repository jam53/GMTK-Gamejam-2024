extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var badger_nearby = false
	for badger in get_tree().get_nodes_in_group("badgers"):
		if global_position.distance_to(badger.global_position) < 500:
			badger_nearby = true
			break
	
	if badger_nearby:
		if not is_in_group("occupied_flowers"):
			add_to_group("occupied_flowers")
		modulate.a = 0.5  # Set visibility to 50%
	else:
		if is_in_group("occupied_flowers"):
			remove_from_group("occupied_flowers")
		modulate.a = 1.0  # Set visibility to 100%
