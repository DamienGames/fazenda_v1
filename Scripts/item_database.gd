extends Node
class_name ItemDatabase

var items: Dictionary = {
	"sword": {
		"name": "Espada de Ferro",
		"max_stack": 1,
		"icon": preload("res://Icons/sword.png"),
		"type": "weapon"
	},
	"potion": {
		"name": "Poção de Cura",
		"max_stack": 10,
		"icon": preload("res://Icons/potion.png"),
		"type": "consumable"
	}
}

static func get_item(id: String) -> Dictionary:
	return items.get(id)
