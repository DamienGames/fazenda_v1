extends Node

var achievements: Array = []
var current_gold: int = 500
var current_xp: int = 0
var quests: Dictionary = {}
var flags: Dictionary = {}
var current_scene_path: String

func add_gold(amount: int) -> void:
	current_gold += amount

func remove_gold(amount: int) -> void:
	current_gold -= amount

func add_xp(amount: int) -> void:
	current_xp += amount

func unlock_achievement(id: String) -> void:
	if not achievements.has(id):
		achievements.append(id)

func get_save_data() -> Dictionary:
	return {
		"gold": current_gold,
		"xp": current_xp,
		"quests": quests,
		"achievements": achievements,
		"scene_path": current_scene_path
	}

func set_save_data(data: Dictionary) -> void:
	current_gold = data.get("gold", current_gold)
	current_xp = data.get("xp", current_xp)
	quests = data.get("quests", {}) as Dictionary
	achievements = data.get("achievements", []) as Array
	current_scene_path = data.get("scene_path", current_scene_path)
