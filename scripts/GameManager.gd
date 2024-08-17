extends Node

@export var object_placer: ObjectPlacer


# Called when the node enters the scene tree for the first time.
func _ready():
	object_placer.add_item_to_inventory(
        ObjectPlacer.UserItem.new(
            preload("res://assets/sprites/hive.webp"), 
            2, 
            "hive", 
            preload("res://scenes/hive.tscn")
        )
    )


