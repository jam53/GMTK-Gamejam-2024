extends StaticBody2D

class_name AttackHive

@export var capacity := 5


var attacker_template = preload("res://scenes/attacker.tscn")


func _ready():
	for i in range(capacity):
		var attacker = attacker_template.instantiate()
		add_child(attacker)
	
