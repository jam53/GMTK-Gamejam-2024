extends Control

@export var bee_scene: PackedScene
@export var num_bees: int = 15

func _ready():
	for i in range(num_bees):
		var bee_instance = bee_scene.instantiate()
		add_child(bee_instance)
		bee_instance.position = Vector2(randf_range(0, get_viewport_rect().size.x), randf_range(0, get_viewport_rect().size.y))
