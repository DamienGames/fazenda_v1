extends Node

@onready var scene_component: SceneComponent = $SceneComponent
@onready var scene_container: Control = $SceneContainer
@onready var week_day_label: Label = %WeekDayLabel
@onready var day_label: Label = %DayLabel
@onready var time_label: Label = %TimeLabel
@onready var season_label: Label = %SeasonLabel
@export var current_scene: Node = null	
@export_file("*.tscn") var initial_scene_path: String
@onready var inventory_ui: InventoryUI = $CanvasLayer/InventoryUI

const PLAYER = preload("res://Scenes/player.tscn")

func _ready() -> void:
	change_scene(initial_scene_path)
	Calendar.connect("day_change", Callable(self, "_on_calendar_global_day_change"))
	Calendar.connect("week_day_change", Callable(self, "_on_calendar_global_week_day_change"))
	Calendar.connect("minute_tick", Callable(self, "_on_calendar_global_minute_tick"))
	Calendar.connect("season_change", Callable(self, "_on_calendar_global_season_change"))

func change_scene(path: String) -> void:
	if current_scene:
		current_scene.queue_free()
	var scene = load(path).instantiate()
	spawn_player(scene)
	scene_container.add_child(scene)
	current_scene = scene
	
# 🔹 Salvar jogo
func save_game(slot: int = 1):
	SaveLoad.save_game(slot)

# 🔹 Carregar jogo
func load_game(slot: int = 1):
	SaveLoad.load_game(slot)
	print(GameState)
	scene_component.change_scene(GameState.current_scene_path)

func _on_save_pressed() -> void:
	save_game(1)
	
func _on_load_pressed() -> void:
	load_game(1)

func _on_calendar_global_minute_tick(time: String, total_minutes : int) -> void:
	time_label.text = str(time)

func _on_calendar_global_day_change(day: int):
	day_label.text = str(day)

func _on_calendar_global_week_day_change(week_day:Dictionary):
	week_day_label.text = str(week_day["short_name"])
	
func _on_calendar_global_season_change(season:Dictionary):
	season_label.text = str(season["name"])

func _on_pause_timer_pressed() -> void:
	Calendar.set_timer_pause(true)

func _on_unpause_pressed() -> void:
	Calendar.set_timer_pause(false)

func spawn_player(level: Node):
	var spawn = level.get_node_or_null("PlayerSpawn")
	if spawn:
		var player = PLAYER.instantiate()
		player.global_position = spawn.global_position
		level.add_child(player)
		 # conectar sinais do player ao inventário/ao HUD
		player.player_pick_up.connect(inventory_ui._on_player_pick)
