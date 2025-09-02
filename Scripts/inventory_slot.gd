extends Control
class_name InventorySlot

@onready var icon: TextureRect = $Icon
@onready var quantity_label: Label = $Quantity

var slot_data: Dictionary = {} # { "id": String, "quantity": int }

func update_slot(data: Dictionary) -> void:
	slot_data = data
	if not slot_data.has("id"):
		icon.texture = null
		quantity_label.text = ""
		return

	var item_info = ItemDatabase.get_item(slot_data.id)
	if item_info:
		icon.texture = item_info.icon
		quantity_label.text = str(slot_data.quantity)
