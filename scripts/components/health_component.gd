extends Node2D
class_name HealthComponent

@export var max_hp : int

var current_hp : int

var health_bar : ProgressBar = null

func take_damage(damage: int) -> void:
	current_hp -= damage
	if current_hp <= 0:
		queue_free()
	if current_hp < max_hp:
		health_bar = ProgressBar.new()
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
		add_child(health_bar)

