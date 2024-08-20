extends Control
class_name ObjectPlacer

@export var node_to_place_objects_in: Node
@export var item_template: PackedScene # Reference to the item template used to create new item instances
@export var honey_amount_label : NumberLabel

@onready var inventory := $VBoxContainer/Inventory
@onready var selected_item_label: Label = $VBoxContainer/SelectedItemTitle # Reference to the label that shows the currently selected item title

var user_items: Array[InventoryItem] = [] # Array to keep track of user items in the inventory
var selected_item: InventoryItem = null # The item that the user selected by clicking on it from the inventory
var cursor_sprite: Sprite2D = Sprite2D.new() # Sprite that will be used to display as the cursor when the user selected an item to place
var cursor_max_size: float = 128

func _ready():
	add_items_to_inventory([
		InventoryItem.new(
			preload("res://assets/sprites/temp/beehive.png"), 
			2, 
			"beehive", 
			preload("res://scenes/hive.tscn"),
			0.5
		),
		InventoryItem.new(
			preload("res://assets/sprites/temp/beehive-attackers.png"),
			5,
			"beehive attackers",
			preload("res://scenes/attackers_hive.tscn"),
			0.5
		),
		InventoryItem.new(
			preload("res://assets/sprites/temp/attack_boost_flower.png"),
			10,
			"attack boost flower",
			preload("res://scenes/flowers/attack_boost_flower.tscn"),
			0.05
		),
		InventoryItem.new(
			preload("res://assets/sprites/temp/health_boost_flower.png"),
			10,
			"health boost flower",
			preload("res://scenes/flowers/health_boost_flower.tscn"),
			0.05
		)
	])
		
	add_child(cursor_sprite)
	update_inventory_ui()

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
func add_items_to_inventory(inventoryItems: Array[InventoryItem]):
	for item in inventoryItems:
		if !is_item_in_inventory(item):
			user_items.append(item)
			update_inventory_ui()
		
func update_inventory_ui():
	honey_amount_label.set_count(GameManager.honey_amount)
	# Remove all old items in the UI
	for item in inventory.get_children():
		inventory.remove_child(item)

	for item in user_items:
		if GameManager.honey_amount >= item.price:
			var itemInstance := item_template.instantiate()
			itemInstance.name = item.title
			itemInstance.texture_normal = item.texture
			itemInstance.texture_hover = item.texture
			itemInstance.button_down.connect(_on_item_pressed.bind(item))

			inventory.add_child(itemInstance)
			var price_label = itemInstance.find_child("Price", true, false)
			if price_label is NumberLabel:
				price_label.set_count(item.price)

	if inventory.get_child_count() == 0:
		selected_item_label.text = "Not enough honey to buy any items"
	else:
		selected_item_label.text = ""

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
	cursor_sprite.texture = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Places the currently selected item on the play area
func place_selected_item(position_to_place: Vector2):
	GameManager.update_honey(-selected_item.price)
	spawn_item(selected_item.scene_to_spawn, position_to_place)

	selected_item.price += ceil(selected_item.price * selected_item.increase_price_by_percent)

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
	var increase_price_by_percent: float # The amount in percent as a float (0.0 -> 1.0) by which the price of an item should be increased when it has been purchased

	func _init(texture: Texture2D, price: int, title: String, scene_to_spawn: PackedScene, increase_price_by_percent: float):
		self.texture = texture
		self.price = price
		self.title = title
		self.scene_to_spawn = scene_to_spawn
		self.increase_price_by_percent = increase_price_by_percent
