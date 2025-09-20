extends Node

const SAVE_PATH := "user://saves/"
const ENCRYPTION_PASSWORD := "password123"

var current_slot: int = 1

func _init():
	DirAccess.make_dir_recursive_absolute(SAVE_PATH)

# Função principal de save
func save_game(slot: int = 1) -> void:
	current_slot = slot
	var save_data: Dictionary = {}
	
	# --- Dados dos Nodes com grupo "savable" ---
	save_data["nodes"] = {}
	for node in get_tree().get_nodes_in_group("savable"):
		if node.has_method("get_save_data"):
			save_data["nodes"][node.name] = node.get_save_data()

	# --- Dados globais ---
	var game_State = get_node("/root/GameState") 
	save_data["game_State"] = game_State.get_save_data()
	
	# --- Tiles alterados ---
	if game_State.has_method("get_tile_data"):
		save_data["tiles"] = game_State.get_tile_data()
	
	# --- Calendário  ---
	save_data["calendar"] = get_node("/root/Calendar").get_save_data()

	var file_path = get_save_file_path(slot)
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, ENCRYPTION_PASSWORD)
	if file:
		file.store_var(save_data)
		file.close()
		print("Jogo salvo em ", file_path)

# Função principal de load
func load_game(slot: int = 1) -> void:
	current_slot = slot
	var save_data: Dictionary = {}
	
	var file_path = get_save_file_path(slot)
	if not FileAccess.file_exists(file_path):
		push_error("Slot %d não encontrado!" % slot)
		return

	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, ENCRYPTION_PASSWORD)
	if  file :
		save_data = file.get_var()
		file.close()

	if typeof(save_data) != TYPE_DICTIONARY:
		push_error("Save corrompido")
		return	
	
	# --- Restaurar dados globais ---
	var game_State = get_node("/root/GameState")
	game_State.set_save_data(save_data.get("game_State", {}))

	# --- Restaurar nodes ---
	for node in get_tree().get_nodes_in_group("savable"):
		var node_data = save_data["nodes"].get(node.name, null)
		if node_data and node.has_method("set_save_data"):
			node.set_save_data(node_data)

	# --- Restaurar tiles ---
	if save_data.has("tiles") and game_State.has_method("set_tile_data"):
		game_State.set_tile_data(save_data["tiles"])

	var calendar = get_node("/root/Calendar")
	calendar.set_save_data(save_data.get("calendar", {}))

	print("Jogo carregado do slot ", slot)

func get_save_file_path(slot: int) -> String:
	return SAVE_PATH + "slot_%d.dat" % slot
