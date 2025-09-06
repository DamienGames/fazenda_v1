extends Node
class_name GameState

var coins: int = 0
var achievements: Array[String] = []
var gold: int = 0
var xp: int = 0
var quests: Dictionary = {}
var flags: Dictionary = {}


func add_coins(amount: int) -> void:
	coins += amount

func unlock_achievement(id: String) -> void:
	if not achievements.has(id):
		achievements.append(id)








### Para salvar
#func _save_state() -> Dictionary:
	#return {
		#"gold": 10,
		#"coins": coins,
		#"achievements": achievements
	#}
#
### Para carregar
#func _load_state(data: Dictionary) -> void:
	#coins = data.get("coins", coins)
	#achievements = data.get("achievements", []) as Array
