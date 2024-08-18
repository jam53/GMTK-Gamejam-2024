extends Control
class_name ObjectPlacer

@export var node_to_place_objects_in: Node
@export var item_template: PackedScene # Reference to the item template used to create new item instances
@export var honey_amount_label : Label

@onready var inventory := $VBoxContainer/Inventory
@onready var selected_item_label: Label = $VBoxContainer/SelectedItemTitle # Reference to the label that shows the currently selected item title

var user_items: Array[InventoryItem] = [] # Array to keep track of user items in the inventory
var selected_item: InventoryItem = null # The item that the user selected by clicking on it from the inventory
var cursor_sprite: Sprite2D = Sprite2D.new() # Sprite that will be used to display as the cursor when the user selected an item to place
var cursor_max_size: float = 128

func _ready():
	add_item_to_inventory(
		InventoryItem.new(
			preload("res://assets/sprites/hive.webp"), 
			2, 
			"hive", 
			preload("res://scenes/hive.tscn")
		)
	)
		

	selected_item_label.text = ""
	add_child(cursor_sprite)

func _process(delta):
	if selected_item != null:
		var mouse_position = get_viewport().get_mouse_position()
		cursor_sprite.position = mouse_position

func _input(event):
	if event.is_action_pressed("abort"):
		unselect_selected_item()
	elif event.is_action_pressed("click") and selected_item != null:
		var world_position = get_viewport().get_camera_2d().get_global_mouse_position()
		place_selected_item(world_position)

# Adds an item to the user's inventory
func add_item_to_inventory(inventoryItem: InventoryItem):
	if !is_item_in_inventory(inventoryItem):
		user_items.append(inventoryItem)
		update_inventory_ui()
		
func update_inventory_ui():
	honey_amount_label.text = "Honey_amount: " + str(GameManager.honey_amount)
	# Remove all old items in the UI
	for item in inventory.get_children():
		inventory.remove_child(item)

	for item in user_items:
		if GameManager.honey_amount >= item.price:
			var itemInstance := item_template.instantiate()
			itemInstance.name = item.title
			itemInstance.texture_normal = item.texture
			itemInstance.texture_hover = item.texture
			itemInstance.find_child("Price", true, false).text = str(item.price)
			itemInstance.button_down.connect(_on_item_pressed.bind(item))

			inventory.add_child(itemInstance)

# Fires when the user selects an item from the inventory by clicking on the item
func _on_item_pressed(inventoryItem: InventoryItem):
	selected_item = inventoryItem
	selected_item_label.text = "Selected item: " + selected_item.title + ". Click to place, ESC to abort"

	# Calculate the scale to ensure the maximum size doesn't exceed `cursor_max_size`
	var texture_size = inventoryItem.texture.get_size()
	if texture_size.x > cursor_max_size or texture_size.y > cursor_max_size:
		var scale_factor = min(cursor_max_size / texture_size.x, cursor_max_size / texture_size.y)
		cursor_sprite.scale = Vector2(scale_factor, scale_factor)
	
	cursor_sprite.texture = inventoryItem.texture
	# Hide the default cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Deselects the currently selected item
func unselect_selected_item():
	selected_item = null
	selected_item_label.text = ""
	cursor_sprite.texture = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Places the currently selected item on the play area
func place_selected_item(position_to_place: Vector2):
	GameManager.update_honey(-selected_item.price)
	spawn_item(selected_item.scene_to_spawn, position_to_place)

	update_inventory_ui()
	unselect_selected_item()

# Instantiates an item at a given position.
func spawn_item(item: PackedScene, pos: Vector2):
	var itemInstance := item.instantiate()
	itemInstance.position = pos
	node_to_place_objects_in.add_child(itemInstance)

# Checks if an item with the same title already exists in the inventory
func is_item_in_inventory(inventoryItem: InventoryItem) -> bool:
	for item in user_items:
		if item.title == inventoryItem.title:
			return true

	return false

# Retrieves an item from the inventory by its title
func get_item_in_inventory(itemTitle: String) -> InventoryItem:
	for item in user_items:
		if item.title == itemTitle:
			return item

	return null

# Class to represent an item in the user's inventory
class InventoryItem:
	var texture: Texture2D
	var price: int
	var title: String # This is assumed to be unique per item
	var scene_to_spawn: PackedScene # This will be used to instantiate the item on the play area

	func _init(texture: Texture2D, price: int, title: String, scene_to_spawn: PackedScene):
		self.texture = texture
		self.price = price
		self.title = title
		self.scene_to_spawn = scene_to_spawn