extends Control

@export var speed = 50
var direction = Vector2.ZERO

func _ready():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _process(delta):
	position += direction * speed * delta
	if position.x < 0 or position.x > get_viewport_rect().size.x:
		direction.x = -direction.x
	if position.y < 0 or position.y > get_viewport_rect().size.y:
		direction.y = -direction.y
