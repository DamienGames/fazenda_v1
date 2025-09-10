extends Node

@onready var save_load = SaveLoadComponent.new()
@export var current_scene: Node = null	
@export_file("*.tscn") var initial_scene_path: String
@onready var scene_component: SceneComponent = $SceneComponent
@onready var scene_container: Control = $SceneContainer

func _ready() -> void:	
	change_scene(initial_scene_path)


func change_scene(path: String) -> void:
	if current_scene:
		current_scene.queue_free()
	var scene = load(path).instantiate()
	scene_component.spawn_player(scene)
	scene_container.add_child(scene)
	current_scene = scene

# 🔹 Salvar jogo
func save_game(slot: int = 1):
	var player = current_scene.get_node("Player") # ajuste conforme sua cena
	save_load.save_game(player, current_scene.scene_file_path, slot)

# 🔹 Carregar jogo
func load_game(slot: int = 1):
	var data = save_load.load_game(slot)
	if data.is_empty(): return

	# Troca cena
	change_scene(data["scene_path"])

	await get_tree().process_frame  # espera 1 frame pra cena instanciar

	# Restaura Player
	var player = current_scene.get_node("Player")
	player._load_state(data["player"])

	# Restaura globais
	GlobalData.gold = data["globals"]["gold"]
	GlobalData.xp = data["globals"]["xp"]
	GlobalData.quests = data["globals"]["quests"]
	GlobalData.flags = data["globals"]["flags"]
	GlobalData.achievements = data["globals"]["achievements"]

func _on_save_pressed() -> void:
	save_game(1)
	
func _on_load_pressed() -> void:
	load_game(1)


func _on_scene_2_pressed() -> void:
	scene_component.change_scene("res://Scenes/Fases/scene_2.tscn") 
