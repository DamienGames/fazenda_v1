@icon("res://Art/Icons/scene.svg")
class_name SceneComponent extends Node2D

@onready var _fade_layer := _create_fade_layer()

@export var transition_time: float = 0.4  
@export var scene_container: NodePath

const PLAYER = preload("res://Scenes/player.tscn")

signal scene_changed(new_scene: Node)

var _scene_container: Node = null
var _current_scene: Node

func _ready() -> void:
	if scene_container != NodePath():
		_scene_container = get_node(scene_container)
	else:
		push_error("⚠ SceneComponent: Nenhum 'scene_container' definido!")

# Troca a cena por caminho
func change_scene(path: String, data: Dictionary = {}) -> void:
	if not _scene_container:
		push_error("SceneComponent: Container não encontrado!")
		return
	_do_transition(path, data)

# Recarrega a cena atual
func reload_scene() -> void:
	if _current_scene:
		change_scene(_current_scene.scene_file_path)

# Lógica de transição
func _do_transition(path: String, data: Dictionary) -> void:
	var new_scene_res = load(path)
	if not new_scene_res:
		push_error("Failed to load scene: %s" % path)
		return
	_fade(true)
	await get_tree().create_timer(transition_time).timeout
	for child in _scene_container.get_children():
		child.queue_free()
	var new_scene = load(path).instantiate()
	_scene_container.add_child(new_scene)
	new_scene.owner = _scene_container
	if data.size() > 0 and _current_scene.has_method("set_data"):
		_current_scene.set_data(data)
	emit_signal("scene_changed", _current_scene)
	_fade(false)	
	spawn_player(new_scene)

func spawn_player(level: Node):
	var spawn = level.get_node_or_null("PlayerSpawn")
	if spawn:
		var player = PLAYER.instantiate()
		player.global_position = spawn.global_position
		level.add_child(player)

# Cria camada de fade (preto sobre tudo)
func _create_fade_layer() -> ColorRect:
	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.visible = false
	rect.z_index = 999	
	# Anchors de 0 a 1 para ocupar toda a tela
	rect.anchor_left = 0.0
	rect.anchor_top = 0.0
	rect.anchor_right = 1.0
	rect.anchor_bottom = 1.0	
	
	rect.offset_left = 0
	rect.offset_top = 0
	rect.offset_right = 0
	rect.offset_bottom = 0	
	# ⚠️ IMPORTANTE: adicionar num CanvasLayer ou Control
	var layer := CanvasLayer.new()
	add_child(layer)  # aqui "self" pode ser Node2D
	layer.add_child(rect)
	return rect

func _fade(fade_out: bool) -> void:
	_fade_layer.visible = true
	var tween = create_tween()
	if fade_out:
		_fade_layer.modulate.a = 0.0
		tween.tween_property(_fade_layer, "modulate:a", 1.0, transition_time)
	else:
		_fade_layer.modulate.a = 1.0
		tween.tween_property(_fade_layer, "modulate:a", 0.0, transition_time)
		tween.finished.connect(func():
			_fade_layer.visible = false)
