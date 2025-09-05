# res://scripts/SaveComponent.gd
extends Node
class_name SaveComponent

## Config
@export var save_dir := "user://saves"
@export var file_prefix := "slot_"
@export var file_ext := ".json"
@export var current_slot := 1
@export var save_group := "saveable" # nós que participam do save
@export var version := 1              # versão do formato do seu jogo

# Opcional: senha para criptografar o arquivo .dat (deixe vazio para não criptografar)
@export var encryption_password := ""

signal saved(path: String)
signal loaded(path: String)
signal save_failed(reason: String)
signal load_failed(reason: String)

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(save_dir)

func get_slot_path(slot: int = -1) -> String:
	if slot <= 0:
		slot = current_slot
	return "%s/%s%d%s" % [save_dir, file_prefix, slot, file_ext]

func get_backup_path(slot: int = -1) -> String:
	var p := get_slot_path(slot)
	return p.replace(file_ext, ".bak")

## ---- API pública ----

func save_game(slot: int = -1) -> void:
	var path := get_slot_path(slot)
	var backup := get_backup_path(slot)

	var state := _collect_state()

	# envelope com metadados
	var payload := {
		"version": version,
		"timestamp": Time.get_unix_time_from_system(),
		"state": state
	}

	# 1) cria backup do arquivo anterior (se existir)
	if FileAccess.file_exists(path):
		var from := FileAccess.open(path, FileAccess.READ)
		if from:
			var bytes := from.get_buffer(from.get_length())
			from.close()
			var to := FileAccess.open(backup, FileAccess.WRITE)
			if to:
				to.store_buffer(bytes)
				to.close()

	# 2) serializa e opcionalmente criptografa
	var fa := _open_for_write(path)
	if fa == null:
		emit_signal("save_failed", "Não foi possível abrir arquivo para escrita.")
		return

	# Dica: store_var é prático, binário e suporta Dictionary/Array.
	# Use o flag 'full_objects' = false (padrão) para evitar refs de objeto.
	fa.store_var(payload)
	fa.close()

	emit_signal("saved", path)

func load_game(slot: int = -1) -> void:
	var path := get_slot_path(slot)
	if not FileAccess.file_exists(path):
		emit_signal("load_failed", "Arquivo inexistente: %s" % path)
		return

	var fa := _open_for_read(path)
	if fa == null:
		emit_signal("load_failed", "Falha ao abrir arquivo pra leitura.")
		return

	var payload = fa.get_var() # lê o que foi escrito com store_var
	fa.close()

	if typeof(payload) != TYPE_DICTIONARY or not payload.has("state"):
		emit_signal("load_failed", "Formato inválido.")
		return

	# valida versão (se quiser migrar, faça aqui)
	var file_ver := int(payload.get("version", 0))
	if file_ver != version:
		# aqui você poderia chamar uma rotina de migração
		# payload.state = _migrate_state(payload.state, file_ver, version)
		pass

	_apply_state(payload.state)
	emit_signal("loaded", path)

func has_save(slot: int = -1) -> bool:
	return FileAccess.file_exists(get_slot_path(slot))

## ---- Internos ----

func _open_for_write(path: String) -> FileAccess:
	if encryption_password.is_empty():
		return FileAccess.open(path, FileAccess.WRITE)
	else:
		return FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, encryption_password)

func _open_for_read(path: String) -> FileAccess:
	if encryption_password.is_empty():
		return FileAccess.open(path, FileAccess.READ)
	else:
		return FileAccess.open_encrypted_with_pass(path, FileAccess.READ, encryption_password)

func _collect_state() -> Dictionary:
	# Coleta o estado de todos os nós no grupo 'saveable'.
	# Cada nó deve implementar o método opcional `_save_state() -> Dictionary`
	# Se não implementar, tentamos pegar propriedades básicas.
	var state: Dictionary = {}
	var nodes := get_tree().get_nodes_in_group(save_group)
	for n in nodes:
		var id := _stable_node_id(n)
		var snap := {}
		if n.has_method("_save_state"):
			snap = n._save_state()
		else:
			snap = _default_snapshot(n)
		state[id] = {
			"scene_path": n.scene_file_path,
			"node_path": n.get_path(),
			"data": snap
		}
	return state

func _apply_state(state: Dictionary) -> void:
	var nodes := get_tree().get_nodes_in_group(save_group)
	var map_by_id: Dictionary = {}
	for n in nodes:
		map_by_id[_stable_node_id(n)] = n

	for id in state.keys():
		var entry = state[id]
		var data = entry.get("data", {})
		if map_by_id.has(id):
			var node = map_by_id[id]
			if node and node.has_method("_load_state"):
				node._load_state(data)
			else:
				_default_apply(node, data)
		# Caso o nó não exista, você pode optar por instanciá-lo usando `scene_path`
		# se fizer sentido para o seu jogo.

func _default_snapshot(n: Node) -> Dictionary:
	var d := {}
	# exemplo básico para 2D
	if n is Node2D:
		d["position"] = (n as Node2D).global_position
		d["rotation"] = (n as Node2D).rotation
		d["scale"] = (n as Node2D).scale
	# propriedades comuns (ajuste ao seu jogo)
	#if n.has_variable("hp"): d["hp"] = n.get("hp")
	#if n.has_variable("mp"): d["mp"] = n.get("mp")
	#if n.has_variable("level"): d["level"] = n.get("level")
	return d

func _default_apply(n: Node, data: Dictionary) -> void:
	if n is Node2D:
		var nd := n as Node2D
		if data.has("position"): nd.global_position = data["position"]
		if data.has("rotation"): nd.rotation = data["rotation"]
		if data.has("scale"):    nd.scale = data["scale"]
	for k in ["hp","mp","level"]:
		if data.has(k) and n.has_variable(k):
			n.set(k, data[k])

func _stable_node_id(n: Node) -> String:
	# Gera um ID estável por cena/caminho (evite depender de NodePaths voláteis entre cenas)
	# Se seus nós têm um UUID próprio, use-o aqui.
	return str(n.get_path())
