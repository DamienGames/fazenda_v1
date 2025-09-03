extends Resource
class_name ItemDatabase

var items: Dictionary = {
	"item_0001": {
		"type": "weapon",
		"name": "Espada de Ferro",
		"max_stack": 1,
		"icon": preload("res://Icons/sword.png"),
	},
	"item_0002": {
		"type": "consumable",
		"name": "Poção de Cura",
		"max_stack": 99,
		"icon": preload("res://Icons/potion.png"),
	}
}

func get_item(id: String) -> Dictionary:
	if items.has(id):
		return items.get(id)
	return {}
	
