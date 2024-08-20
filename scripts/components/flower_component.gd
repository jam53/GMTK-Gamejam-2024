extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent()
	var badger_nearby = false
	for badger in get_tree().get_nodes_in_group("badgers"):
		if global_position.distance_to(badger.global_position) < 500:
			badger_nearby = true
			break
	
	if badger_nearby:
		if not parent.is_in_group("occupied_flowers"):
			parent.add_to_group("occupied_flowers")
		parent.modulate.a = 0.5  # Set visibility to 50%
	else:
		if parent.is_in_group("occupied_flowers"):
			parent.remove_from_group("occupied_flowers")
		parent.modulate.a = 1.0  # Set visibility to 100%

