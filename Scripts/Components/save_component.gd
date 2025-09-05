extends Node
class_name GameSaveManager

var save_data: Dictionary = {
	"player": {},
	"scenes": {},
	"globals": {}
}

var current_scene_path: String = ""

# 🔹 Registrar atores (NPCs, inimigos, objetos interativos)
func register_actor(id: String, node: Node) -> void:
	if not node.has_meta("save_id"):
		node.set_meta("save_id", id)


# 🔹 Salvar estado da cena atual
func save_current_scene() -> void:
	current_scene_path = get_tree().current_scene.scene_file_path
	
	var scene_data: Dictionary = {
		"npcs": {},
		"enemies": {},
		"objects": {}
	}
	
	# NPCs
	for npc in get_tree().get_nodes_in_group("npc"):
		var id = npc.get_meta("save_id") if npc.has_meta("save_id") else str(npc.get_instance_id())
		scene_data["npcs"][id] = {
			"position": npc.position,
			"state": npc.state_machine.get_current_state_name()
		}
	
	# Inimigos
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var id = enemy.get_meta("save_id") if enemy.has_meta("save_id") else str(enemy.get_instance_id())
		scene_data["enemies"][id] = {
			"position": enemy.position,
			"alive": enemy.is_alive
		}
	
	# Objetos interativos (ex: portas, baús)
	for obj in get_tree().get_nodes_in_group("interactive"):
		var id = obj.get_meta("save_id") if obj.has_meta("save_id") else str(obj.get_instance_id())
		scene_data["objects"][id] = {
			"state": obj.state if obj.has_variable("state") else null
		}
	
	save_data["scenes"][current_scene_path] = scene_data
	print("💾 Cena salva:", current_scene_path, scene_data)


# 🔹 Restaurar estado da cena atual
func apply_current_scene() -> void:
	if current_scene_path == "":
		return
	if not save_data["scenes"].has(current_scene_path):
		return
	
	var scene_data = save_data["scenes"][current_scene_path]
	
	# NPCs
	for npc in get_tree().get_nodes_in_group("npc"):
		var id = npc.get_meta("save_id") if npc.has_meta("save_id") else str(npc.get_instance_id())
		if id in scene_data["npcs"]:
			var d = scene_data["npcs"][id]
			npc.position = d.get("position", npc.position)
			npc.state_machine.change_state(d.get("state", "idle"))
	
	# Inimigos
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var id = enemy.get_meta("save_id") if enemy.has_meta("save_id") else str(enemy.get_instance_id())
		if id in scene_data["enemies"]:
			var d = scene_data["enemies"][id]
			enemy.position = d.get("position", enemy.position)
			enemy.is_alive = d.get("alive", true)
			if not enemy.is_alive:
				enemy.queue_free()
	
	# Objetos
	for obj in get_tree().get_nodes_in_group("interactive"):
		var id = obj.get_meta("save_id") if obj.has_meta("save_id") else str(obj.get_instance_id())
		if id in scene_data["objects"]:
			var d = scene_data["objects"][id]
			if "state" in d and obj.has_variable("state"):
				obj.state = d["state"]
	
	print("✅ Cena restaurada:", current_scene_path, scene_data)


# 🔹 Salvar Player
func save_player(player: Node) -> void:
	save_data["player"] = {
		#"health": player.health,
		"position": player.position,
		#"xp": player.xp_component.current_xp,
		#"level": player.xp_component.level
	}


# 🔹 Restaurar Player
func apply_player(player: Node) -> void:
	if not save_data.has("player"):
		return
	var p = save_data["player"]
	#player.health = p.get("health", player.health)
	print(p.get("position", player.position))
	player.position = p.get("position", player.position)
	#player.xp_component.current_xp = p.get("xp", 0)
	#player.xp_component.level = p.get("level", 1)


# 🔹 Salvar Globals
func save_globals() -> void:
	save_data["globals"] = {
		"gold": GlobalData.gold,
		#"quests": GlobalData.quests,
		#"flags": GlobalData.flags
	}


# 🔹 Restaurar Globals
func apply_globals() -> void:
	if "globals" in save_data:
		GlobalData.gold = save_data["globals"].get("gold", 0)
		#GlobalData.quests = save_data["globals"].get("quests", {})
		#GlobalData.flags = save_data["globals"].get("flags", {})


# 🔹 Trocar de cena mantendo estado
func change_scene(path: String) -> void:
	# 1. salvar cena atual
	save_current_scene()
	
	# 2. trocar cena
	current_scene_path = path
	get_tree().change_scene_to_file(path)


# 🔹 Chamado no _ready de cada cena carregada
func on_scene_ready() -> void:
	# Restaurar dados da cena
	apply_current_scene()
	
	# Restaurar player (se já existir)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		apply_player(player)


# 🔹 Salvar tudo no disco
func save_game() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		save_player(player)
	save_current_scene()
	save_globals()
	
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	if file:
		file.store_var(save_data)  # salva o Dictionary como binário
		file.close()
		print("💾 Jogo salvo:", save_data)


func load_game() -> void:
	if not FileAccess.file_exists("user://savegame.dat"):
		push_warning("Nenhum save encontrado.")
		return
	
	var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
	if file:
		var data = file.get_var()  # ❌ ler como binário, não usar get_as_text()
		file.close()
		
		if typeof(data) == TYPE_DICTIONARY:
			save_data = data
			apply_globals()
			# Trocar cena para a última salva
			if save_data["scenes"].keys().size() > 0:
				var last_scene = save_data["scenes"].keys()[0]
				change_scene(last_scene)
			
			print("✅ Jogo carregado:", save_data)
		else:
			push_error("Erro ao carregar save")
