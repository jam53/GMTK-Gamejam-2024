extends Node2D
class_name AttackComponent

@export var attack: int
@export var attack_cooldown: float = 1

@onready var attack_timer = $Timer

var targets : Array[Node] = []
var _can_attack

func _ready():
	attack_timer.wait_time = attack_cooldown
	
func add_target(target: Node):
	if target.has_method("take_damage"):
		if get_parent() in get_tree().get_nodes_in_group("bears"):
			print("adding ", target.get_parent())
		targets.append(target)
		if targets.size() == 1:
			damage(target)
			attack_timer.start()
	
		
func remove_target(target: Node):
	if target in targets:
		if get_parent() in get_tree().get_nodes_in_group("bears"):
			print("removing ", target.get_parent())
		targets.remove_at(targets.find(target))

func damage(target: Node) -> void:
	if _can_attack:
		target.take_damage(attack)
		_can_attack = false

func _on_Timer_timeout() -> void:
	_can_attack = true
	if targets.size() == 0:
		return
	var target = targets[0]
	while not is_instance_valid(target) and targets.size() > 1:
		targets.remove_at(0)
		target = targets[0]
		
	if targets.size() > 0:
		if is_instance_valid(target):
			damage(target)
		attack_timer.start()
