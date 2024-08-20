extends Node2D
class_name AttackComponent

@export var attack: int
@export var attack_cooldown: float = 1

@onready var attack_timer = $Timer

var main_target : Node = null
var targets : Array[Node] = []
var _can_attack := true
var attack_multiplier = 1

func _ready():
	attack_timer.wait_time = attack_cooldown
	
func add_target(target: Node):
	if target.has_method("take_damage"):
		targets.append(target)
		if targets.size() == 1:
			if get_parent().is_in_group("attackers") or _is_valid_target(target):
				damage(target)
				attack_timer.start()
	
		
func remove_target(target: Node):
	if target in targets:
		targets.remove_at(targets.find(target))

func damage(target: Node) -> void:
	if _can_attack:
		target.take_damage(attack * attack_multiplier)
		_can_attack = false
		
func remove_freed_nodes_from_list(node_list: Array) -> void:
	for i in range(node_list.size() - 1, -1, -1):  # Iterate in reverse to avoid skipping elements
		if not is_instance_valid(node_list[i]):
			node_list.remove_at(i)

func _is_valid_target(target):
	var attacker = target.get_parent().is_in_group("attackers")
	if main_target == null:
		return attacker
	else:
		return attacker or main_target == target.get_parent()
		

func _on_Timer_timeout() -> void:
	_can_attack = true
	remove_freed_nodes_from_list(targets)
	if targets.size() == 0:
		return
		
	var target = targets[0]
		
	if targets.size() > 0:
		if is_instance_valid(target):
			# Filter based on main_target
			var i = 1
			if get_parent().is_in_group("attackers"):
				damage(target)
			else:
				while not _is_valid_target(target):
					if i < targets.size():
						target = targets[i]
						i += 1
					else: 
						target = null
						break
							
				if target != null:
					damage(target)
		attack_timer.start()
