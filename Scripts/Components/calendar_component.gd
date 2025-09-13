@icon("res://Art/Icons/calendar.svg")
extends Node
class_name CalendarComponent

signal minute_tick(time:String)
signal day_change(day:int)
signal week_day_change(week_day:Dictionary)
signal week_change(week_number:int)
signal season_change(season:Dictionary)
signal year_change(year:int)

@export var calendar_database:= CalendarDatabase.new()
@export var starting_season_index : int = 0
@export var starting_week_day_index : int = 0
@export var starting_day : int = 1
@export var time_scale: float = 1.6

# Configurações do relógio
const START_TIME: int = 600    # começa às 6h00
const END_TIME: int = 3000     # termina às 2h00
const SLEEP_TIME: int = 400     # termina às 2h00

const GAME_MINUTES_PER_HOUR: int = 60
const REAL_SECONDS_PER_GAME_HOUR: float = 45 #45.0
const MINUTES_PER_DAY: int = END_TIME - START_TIME  # 2000 minutos
const REAL_SECONDS_PER_GAME_MINUTE: float = REAL_SECONDS_PER_GAME_HOUR / GAME_MINUTES_PER_HOUR

const MAX_TIME_IN_WEEK : int = 18200
const MAX_TIME_IN_SEASON: int = 72800
const MAX_TIME_IN_YEAR: int = 291200

var total_game_minutes: int = 0  # nunca zera, soma todos os minutos passados
var daily_game_minutes: int = START_TIME  # reinicia a cada dia
var start_real_time: float

var current_day: int 
var current_week_day: Dictionary = {}
var current_season: Dictionary = {}
var current_week_day_index: int
var current_season_index: int
var current_week_number: int = 1
var current_year_number: int = 1
var current_season_number: int = 1

func _ready() -> void:
	start_real_time = Time.get_ticks_msec() / 1000.0
	
func _process(delta: float) -> void:
	var elapsed_real: float = (Time.get_ticks_msec() / 1000.0) - start_real_time
	var adjusted_time: float = elapsed_real * time_scale
	total_game_minutes = int(adjusted_time / REAL_SECONDS_PER_GAME_MINUTE)
	# minutos do "relógio do dia" (ciclo 600 → 2600)
	var minutes_today: int = total_game_minutes % MINUTES_PER_DAY	
	daily_game_minutes = START_TIME + minutes_today
	
	print(get_formatted_time(daily_game_minutes))
	if daily_game_minutes + SLEEP_TIME >= END_TIME :
		change_next_week_day()


func change_next_week_day():	
	total_game_minutes += SLEEP_TIME
	current_week_day_index += 1
	if	current_week_day_index > 6:
		current_week_day_index = starting_week_day_index
		change_next_week()
	current_week_day = calendar_database.week_days.get("week_day_%s" % current_week_day_index)
	week_day_change.emit(current_week_day)
	print(current_week_day);

func change_next_week():
	current_week_number += 1	
	if current_week_number == 4: # total_game_minutes / (MAX_TIME_IN_SEASON * current_season_number) >= 1:
		change_next_season()
	current_week_day_index = starting_week_day_index
	current_week_day = calendar_database.week_days.get("week_day_%s" % current_week_day_index)
	week_change.emit(current_week_day_index)
	print(current_week_number);
	
func change_next_season():
	current_day = starting_day
	current_week_day_index = starting_week_day_index
	current_season_number += 1
	current_season_index += 1
	if 	current_season_index > 3:
		current_season_index = starting_season_index
		change_next_year()
	current_season = calendar_database.seasons.get("season_%s" % current_season_index)
	season_change.emit(current_season)
	print(current_season);

	
func change_next_year():
	current_year_number += 1
	current_season_index = starting_season_index
	current_week_day_index = starting_week_day_index
	current_day = starting_day
	year_change.emit()	
	print(current_year_number);
	
func get_current_day() -> int:
	current_day = total_game_minutes / MINUTES_PER_DAY + starting_day  # dia 1, 2, 3...
	print(current_day)
	return current_day
	
func get_current_week() -> int:
	var current_week = get_current_day() / 7 + 1  # semana 1, 2, 3...
	print(current_week)
	return current_week

func get_current_month() -> int:
	var current_month = get_current_day() / 30 + 1  # mês 1, 2, 3...
	print(current_month)
	return current_month

# --- Formatação do relógio ---
func get_formatted_time(minutes: int) -> String:
	var hour: int = minutes / 100
	var minute: int = (minutes % 100) * 60 / 100
	return "%02d:%02d" % [hour, minute]
