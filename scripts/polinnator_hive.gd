extends StaticBody2D

class_name Hive

@export var capacity := 5
@onready var game_manager = %GameManager


var pollinator_template = preload("res://scenes/pollinator.tscn")


func _ready():
	for i in range(capacity):
		var pollinator = pollinator_template.instantiate()
		pollinator.hive = self
		add_child(pollinator)

func bee_arrived():
	game_manager.update_honey(5)
