extends CharacterBody2D

#@export var max_speed := 300.0
#@export var mouse_follow_force := 0.5
#@export var move := false
#
#var _velocity: Vector2
#
#
#func _ready():
	#randomize()
	#_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

#func _physics_process(delta):
	#var mouse_target = get_global_mouse_position()
	#var mouse_vector = Vector2.ZERO
	#if mouse_target != Vector2.INF:
		#mouse_vector = global_position.direction_to(mouse_target) * max_speed * mouse_follow_force
		#
	#var acceleration = mouse_vector
	#
	#_velocity = (_velocity + acceleration).limit_length(max_speed)
	#
	#
	#velocity = _velocity
	#move_and_slide()
	#_velocity = velocity
		
		

func _on_area_2d_body_entered(body):
	if body != self:
		print("Body entered: TestDIngetje")
