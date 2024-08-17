extends Control

@onready var inventory := $VBoxContainer/Inventory
@export var item_template: PackedScene # Reference to the item template used to create new item instances
@onready var selected_item_label: Label = $VBoxContainer/SelectedItemTitle # Reference to the label that shows the currently selected item title

var user_items: Array[UserItem] = [] # Array to keep track of user items in the inventory

func _ready():
	selected_item_label.text = ""
		
# Adds an item to the user's inventory
func add_item_to_inventory(item: UserItem):
	if is_item_in_inventory(item):
		get_item_in_inventory(item.title).amount += item.amount
		inventory.find_child(item.title, true, false).find_child("Amount", true, false).text = str(get_item_in_inventory(item.title).amount) # Find the UI node corresponding to the item by its title, then find its "Amount" label, and update its text with the current amount in the inventory
	else:
		user_items.append(item)

		# Add the item in the UI
		var itemInstance := item_template.instantiate()
		itemInstance.name = item.title
		itemInstance.texture_normal = item.texture
		itemInstance.texture_hover = item.texture
		itemInstance.find_child("Amount", true, false).text = str(item.amount)

		inventory.add_child(itemInstance)

# Checks if an item with the same title already exists in the inventory
func is_item_in_inventory(userItem: UserItem) -> bool:
	for item in user_items:
		if item.title == userItem.title:
			return true

	return false

# Retrieves an item from the inventory by its title
func get_item_in_inventory(itemTitle: String) -> UserItem:
	for item in user_items:
		if item.title == itemTitle:
			return item

	return null

# Class to represent an item in the user's inventory
class UserItem:
	var texture: Texture2D
	var amount: int
	var title: String # This is assumed to be unique per item

	func _init(texture: Texture2D, amount: int, title: String):
		self.texture = texture
		self.amount = amount
		self.title = title
