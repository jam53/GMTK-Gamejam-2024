extends Node2D
class_name HealthComponent

@export var max_hp : int

var current_hp : int
var is_freed : bool = false

signal died()

var health_bar : ProgressBar = ProgressBar.new()

func _ready():
	health_bar.modulate.a = 0.0
	current_hp = max_hp
	self.add_child(health_bar)

func take_damage(damage: int) -> void:
	current_hp -= damage
	if is_freed:
		return
	
	if current_hp <= 0:
		is_freed = true
		if health_bar != null:
			health_bar.queue_free()
		died.emit()
		
	if current_hp < max_hp:
		health_bar.modulate.a = 1.0
		health_bar.min_value = 0
		health_bar.max_value = max_hp
		health_bar.value = current_hp
		health_bar.anchor_left = 0.5
		health_bar.anchor_right = 0.5
		health_bar.anchor_top = 0
		health_bar.anchor_bottom = 0
		health_bar.offset_left = -12.5  # 4x smaller width
		health_bar.offset_right = 12.5  # 4x smaller width
		health_bar.offset_top = -40     # Moving it a bit more to the top
		health_bar.offset_bottom = -35  # 4x smaller height

