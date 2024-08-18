extends Node2D
class_name AttackComponent

@export var attack: int

var can_attack: bool = true
var attack_timer: Timer

func _init() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0
	attack_timer.one_shot = true
	attack_timer.connect("timeout", self._on_Timer_timeout)
	add_child(attack_timer)

func damage(target: Node) -> void:
	if can_attack and target.has_method("take_damage"):
		target.take_damage(attack)
		can_attack = false
		attack_timer.start()

func _on_Timer_timeout() -> void:
	can_attack = true
