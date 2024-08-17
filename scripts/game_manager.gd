extends Node

class_name GameManager

var honey_amount := 0
@onready var honey_amount_label = $honeyamountlabel

func update_honey(delta: int):
	honey_amount += delta
	honey_amount_label.text = "Honey_amount: " + str(honey_amount)
	
