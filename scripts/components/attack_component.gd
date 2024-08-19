extends Node2D
class_name AttackComponent

@export var attack: int
@export var attack_multiplier : float = 1:
	set(value):
		multiplier_changed.emit(value)
		attack_multiplier = value
		
@export var attack_cooldown: float = 1

signal multiplier_changed(multiplier: float)

var can_attack: bool = true
@onready var attack_timer = $Timer

func _ready():
	attack_timer.wait_time = attack_cooldown

func damage(target: Node) -> void:
	if can_attack and target.has_method("take_damage"):
		can_attack = false
		target.take_damage(attack * attack_multiplier)
		attack_timer.start()

func _on_Timer_timeout() -> void:
	can_attack = true
