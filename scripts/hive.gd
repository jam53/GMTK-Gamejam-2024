extends StaticBody2D

class_name Hive

@export var capacity := 5
@onready var game_manager = %GameManager


var pollinator_template = preload("res://scenes/pollinator.tscn")


func _ready():
	print(game_manager)
	for i in range(capacity):
		var pollinator = pollinator_template.instantiate()
		pollinator.hive = self
		# pollinator.game_manager = game_manager
		add_child(pollinator)

