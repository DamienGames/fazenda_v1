extends Node

@onready var save_load = SaveLoadComponent
@onready var scene_component: SceneComponent = $SceneComponent
@onready var scene_container: Control = $SceneContainer
@onready var day_nigh_cicle: CanvasModulate = $DayNighCicle

@onready var week_day_label: Label = %WeekDayLabel
@onready var day_label: Label = %DayLabel
@onready var time_label: Label = %TimeLabel
@onready var season_label: Label = %SeasonLabel

@export var current_scene: Node = null	
@export_file("*.tscn") var initial_scene_path: String

func _ready() -> void:
	save_load = SaveLoadComponent.new()
	change_scene(initial_scene_path)
	CalendarGlobal.connect("day_change", Callable(self, "_on_calendar_global_day_change"))
	CalendarGlobal.connect("week_day_change", Callable(self, "_on_calendar_global_week_day_change"))
	CalendarGlobal.connect("minute_tick", Callable(self, "_on_calendar_global_minute_tick"))
	CalendarGlobal.connect("season_change", Callable(self, "_on_calendar_global_season_change"))

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

func _on_calendar_global_minute_tick(time: String, total_minutes : int) -> void:
	time_label.text = str(time)

func _on_calendar_global_day_change(day: int):
	day_label.text = str(day)

func _on_calendar_global_week_day_change(week_day:Dictionary):
	week_day_label.text = str(week_day["short_name"])
	
func _on_calendar_global_season_change(season:Dictionary):
	season_label.text = str(season["name"])

func _on_pause_timer_pressed() -> void:
	CalendarGlobal.set_timer_pause(true)


func _on_unpause_pressed() -> void:
	CalendarGlobal.set_timer_pause(false)
