extends Node
class_name SaveLoadComponent

@export var encryption_password := "password123"

const SAVE_PATH = "user://saves/"
var current_slot: int = 1

func _ensure_save_dir():
	DirAccess.make_dir_recursive_absolute(SAVE_PATH)

func get_save_file_path(slot: int) -> String:
	return SAVE_PATH + "slot_%d.dat" % slot

# 🔹 Salvar jogo
func save_game(player: Node, scene_path: String, slot: int = 1) -> void:
	_ensure_save_dir()
	var file_path = get_save_file_path(slot)
	var health_component = player.get_node("HealthComponent")

	var save_data: Dictionary = {
		"scene_path": scene_path,
		"player": {
			"position": player.global_position,
			"health": health_component.current_health
		},
		"globals": {
			"gold": GlobalData.gold,
			"xp": GlobalData.xp,
			"quests": GlobalData.quests,
			"flags": GlobalData.flags,
			"achievements": GlobalData.achievements
		}
	}
	print("save", save_data)


	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, encryption_password)
	if file:
		file.store_var(save_data)
		file.close()
		print("Jogo salvo em ", file_path)

# 🔹 Carregar jogo
func load_game(slot: int = 1) -> Dictionary:
	var file_path = get_save_file_path(slot)
	if not FileAccess.file_exists(file_path):
		push_error("Save slot %d não encontrado." % slot)
		return {}

	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, encryption_password)
	if  file :
		var save_data: Dictionary = file.get_var()
		file.close()
		return save_data
	return {}
