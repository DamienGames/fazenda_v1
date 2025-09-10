@icon("res://Art/Icons/calendar.svg")
extends Node
class_name CalendarComponent
@export var calendar_database:  CalendarDatabase
@export var total_days : int = 1
@export var max_days_in_season: int= 28
@export var max_hours_in_day : int= 2600
@export var time_multiplier : int= 10
@export var starting_hour_in_day : int= 600
@export var starting_season : String = "season_1"

var current_season: Dictionary
var current_day: int = 1
var current_week_day: String = "SEG"
var current_time: int = 600

func start_day():
	pass
	
func get_season_events(season_id:String):
	var events = calendar_database.get_season_spawn_rates(season_id)
	return events
	
func get_full_date():
	var full_date = "Hoje é : %s %s %s %s" % [current_day, current_time, current_week_day, current_season] 
	return full_date
	

func change_next_season(season_id:String):
		var next_season = calendar_database.get_next_season(season_id)
		if next_season:
			current_season = next_season

func change_time_multiplier(new_time_multiplier:int):
	if time_multiplier:
		time_multiplier = new_time_multiplier
