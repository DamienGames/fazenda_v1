extends Control
class_name InventoryUI

@onready var slots: Array = $SlotsContainer.get_children()
@onready var inventory: InventoryComponent = $InventoryComponent

func _ready():
	refresh_inventory()
	var player = get_tree().get_nodes_in_group("player")

func refresh_inventory() -> void:
	var items = inventory.get_all_items()
	for i in range(slots.size()):
		if i < items.size():
			slots[i].update_slot(items[i])
		else:
			slots[i].update_slot({})

func _on_player_pick(id: String, amount: int) -> void:
		inventory.add_item(id, amount)
		refresh_inventory() 

func _on_player_drop(id: String, amount: int) -> void:
		inventory.remove_item(id, amount)
		refresh_inventory() 
