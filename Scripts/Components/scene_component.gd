@icon("res://Art/Icons/scene.svg")
class_name SceneComponent
extends Node2D	

@onready var _fade_layer := _create_fade_layer()

@export var transition_time: float = 0.5   # tempo de fade
@export var scene_container: NodePath  # Aponta para o container dentro do Main

var _scene_container: Node = null
var _current_scene: Node

signal scene_changed(new_scene: Node)

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

	# Anima fade out
	_fade(true)

	await get_tree().create_timer(transition_time).timeout

	# Troca cena
	for child in _scene_container.get_children():
		child.queue_free()

	var new_scene = load(path).instantiate()
	_scene_container.add_child(new_scene)
	new_scene.owner = _scene_container 

	# Passa dados se houver
	if data.size() > 0 and _current_scene.has_method("set_data"):
		_current_scene.set_data(data)

	emit_signal("scene_changed", _current_scene)

	# Anima fade in
	_fade(false)


# Cria camada de fade (preto sobre tudo)
func _create_fade_layer() -> ColorRect:
	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.size = get_viewport().size
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.visible = false
	add_child(rect)
	rect.z_index = 999
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
