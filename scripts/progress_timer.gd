extends Control

@export var wait_time := 10

@onready var timer = $Timer
@onready var progress_bar = $ProgressBar

signal timer_finsihed()

func _ready():
	timer.wait_time = wait_time
	progress_bar.max_value = wait_time
	start_timer()

func start_timer():
	timer.start()
	



func _process(delta):
	progress_bar.value = timer.time_left
	


func _on_timer_timeout():
	timer_finsihed.emit()
