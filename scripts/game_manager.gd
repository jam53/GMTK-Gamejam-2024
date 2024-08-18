extends Node

var honey_amount := 0

var _object_placer

func _ready():
	_object_placer = get_tree().root.find_child("ObjectPlacer", true, false)
	
func update_honey(delta: int):
	honey_amount += delta
	_object_placer.update_inventory_ui()
	
