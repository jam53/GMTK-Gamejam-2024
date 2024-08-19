extends Node

var honey_amount := 0


var _mouse_follow := true
var _object_placer: ObjectPlacer

func get_mouse_follow() -> bool:
	return _mouse_follow
	
func toggle_mouse_follow():
	_mouse_follow = not _mouse_follow

func _ready():
	_object_placer = get_object_placer()
	
func _process(_delta):
	if Input.is_action_just_pressed("disable_follow"):
		toggle_mouse_follow()
	
func update_honey(delta: int):
	honey_amount += delta
	if _object_placer:
		_object_placer.update_inventory_ui()
	else:
		_object_placer = get_object_placer()
	
func get_object_placer() -> ObjectPlacer:
	# This is ok since ObjectPlacer has been marked as Unique
	return get_tree().root.find_child("ObjectPlacer", true, false)
