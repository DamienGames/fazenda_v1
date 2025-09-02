extends Control
class_name InventoryUI

@onready var inventory: InventoryComponent = $InventoryComponent
@onready var slots: Array[InventorySlot] = $SlotsContainer.get_children()

func _ready():
	# inventário inicial
	inventory.add_item("sword", 1)
	inventory.add_item("potion", 3)
	refresh_inventory()

func refresh_inventory() -> void:
	var items = inventory.get_all_items()
	for i in range(slots.size()):
		if i < items.size():
			slots[i].update_slot(items[i])
		else:
			slots[i].update_slot({})
