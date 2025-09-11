@icon("res://Art/Icons/calendar.svg")
extends Node
class_name CalendarComponent

@export var calendar_database: CalendarDatabase
@export var max_time_in_day : int = 2600
@export var max_time_in_week : int = 18200
@export var max_time_in_season: int = 72800
@export var max_time_in_year: int = 291200

@export var time_multiplier : int = 40
@export var starting_time : int = 600
@export var starting_day : int = 1
@export var starting_season_index : int = 0
@export var starting_week_day_index : int = 0

var current_time: int = 0
var current_day: int = 0
var current_week_day: Dictionary = {}
var current_season: Dictionary = {}
var current_week_day_index: int = 0
var current_season_index: int = 0
var current_week_number: int = 1
var current_year_number: int = 1
var current_season_number: int = 1

var total_time: int = 0

signal minute_tick(time:String)
signal day_change(day:int)
signal week_day_change(week_day:Dictionary)
signal week_change(week_number:int)
signal season_change(season:Dictionary)
signal year_change(year:int)

func _ready():
	calendar_database = CalendarDatabase.new()
	if not current_time:
		current_time = starting_time
	if not current_day:
		current_day = starting_day
	if not current_week_day_index:
		current_week_day_index = starting_week_day_index
		current_week_day = calendar_database.week_days.get("week_day_%s" % current_week_day_index)
	if not current_season:
		current_season = calendar_database.seasons.get("season_%s" % starting_season_index)
	print("dia =%s" %current_day)
	print("weekday %s" %current_week_day["name"])
		
func _process(delta: float) -> void:
	current_time = current_time + int(time_multiplier * delta)
		
	if current_time % 10 == 0:
		minute_tick.emit(get_time_string())
			
	if 	current_time >= max_time_in_day:
		total_time += current_time
		current_time = starting_time
		current_day += 1	
		change_next_week_day()
		day_change.emit(current_day)
		print("dia =%s" %current_day)

func change_next_week_day():	
	current_week_day_index += 1
	if	current_week_day_index > 6:
		current_week_day_index = starting_week_day_index
		change_next_week()
	current_week_day = calendar_database.week_days.get("week_day_%s" % current_week_day_index)
	week_day_change.emit(current_week_day)
	print("weekday %s" %current_week_day["name"])
		
func change_next_week():
	current_week_number += 1
	var teste  = total_time / (max_time_in_season * current_season_number)
	if total_time / (max_time_in_season * current_season_number) >= 1:
		change_next_season()
	current_week_day_index = starting_week_day_index
	current_week_day = calendar_database.week_days.get("week_day_%s" % current_week_day_index)
	week_change.emit(current_week_day_index)
	print("week number %s" %current_week_number)
	
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
	print("season number %s" %current_season["name"])

	
func change_next_year():
	current_year_number += 1
	current_season_index = starting_season_index
	current_week_day_index = starting_week_day_index
	current_day = starting_day
	current_time = starting_time
	year_change.emit()	
	print("year number %s" %current_year_number)

func change_time_multiplier(new_time_multiplier:int):
	if time_multiplier:
		time_multiplier = new_time_multiplier

func get_time_string() -> String:
	var hours = current_time / 100
	var minutes = current_time % 60
	return "%02d:%02d" % [hours, minutes]
