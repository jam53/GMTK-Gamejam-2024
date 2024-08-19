extends ReferenceRect

@export var player: NodePath

func _ready():
	if player == null:
		print("Error: Player node path is not set.")
		return

func _process(delta):
	var player_node = get_node(player)
	if player_node:
		position = player_node.position
