@icon("res://Art/Icons/calendar.svg")
extends Node
class_name CalendarComponent

@export var calendar_database: CalendarDatabase
@export var max_time_in_season: int = 72.800
@export var max_time_in_year: int = 291.200
@export var max_time_in_week : int = 18.200
@export var max_time_in_day : int = 2600

@export var time_multiplier : int = 40
@export var starting_time : int = 600
@export var starting_season : String = "season_0"
@export var starting_week_day : String = "Segunda"
@export var starting_day : int = 1

var current_year: int = 0
var current_season: Dictionary = {}
var current_day: int = 0
var current_week_day: String = ""
var current_time: int = 0
var total_time: int = 0
var total_days_in_season: int = 0

signal minute_tick(time:String)
signal day_change(day:int)
signal week_change(week_day:Dictionary)
signal season_change(season:Dictionary)
signal year_change(year:int)

func _ready():
	calendar_database = CalendarDatabase.new()	
	if not current_season:
		current_season = calendar_database.seasons.get(starting_season)
	if not current_day:
		current_day = starting_day
	if not current_week_day:
		current_week_day = starting_week_day
	if not current_time:
		current_time = starting_time

func _process(delta: float) -> void:
		current_time = current_time + int(time_multiplier * delta)
		total_time += current_time
		
		if current_time % 10 == 0:
			minute_tick.emit(get_time_string())
			
		if 	current_time >= max_time_in_day:
			current_day += 1
			day_change.emit(current_day)
			current_time = starting_time
			
		if total_time > max_time_in_week:
			change_next_week_day(current_season["next_season"])
			week_change.emit(current_week_day)
			
		#if total_days > max_days_in_season:
			#change_next_season(current_season["next_season"])
			#season_change.emit(current_season)
			#
		#if total_days > max_days_in_season:
			#change_next_season(current_season["next_season"])
			#day_change.emit(current_season["short_name"])
			#
		#if 	total_days > max_days_in_season:
			#current_year += 1
			#year_change.emit(current_year)	

func change_next_week_day(week_day_name:String):
	var next_week_day = calendar_database.week_days.get(week_day_name)
	if next_week_day :
		current_week_day = next_week_day
		
func change_next_season(season_name:String):
	var next_Season = calendar_database.seasons.get(season_name)
	if next_Season :
		current_season = next_Season

func change_time_multiplier(new_time_multiplier:int):
	if time_multiplier:
		time_multiplier = new_time_multiplier

func get_time_string() -> String:
	var hours = current_time / 100
	var minutes = current_time % 60
	return "%02d:%02d" % [hours, minutes]
