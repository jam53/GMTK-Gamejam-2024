extends StaticBody2D

class_name Hive

@export var capacity := 5

var pollinator_template = preload("res://scenes/bees/pollinator.tscn")

func _ready():
	for i in range(capacity):
		var pollinator = pollinator_template.instantiate()
		pollinator.hive = self
		add_child(pollinator)

func bee_arrived():
	GameManager.update_honey(5)


func _on_health_component_died():
	queue_free()
