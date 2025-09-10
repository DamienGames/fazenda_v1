extends Resource
class_name CalendarDatabase

func get_next_season(season_id:String):
		var current_season = seasons.get(season_id)	
		if current_season:
			var next_season = seasons.get(current_season["next_season"])	 
			return next_season

func get_season_name(season_id: String) -> String:
	if seasons.has(season_id):
		return seasons[season_id].get("name", "")
	return ""
	
func get_week_day_name(week_day_id: String) -> String:
	if week_days.has(week_day_id):
		return week_days[week_day_id].get("name", "")
	return ""	

var seasons : Dictionary = { 
	"season_1" :{
		"name":"Primavera",
		"description":"A primavera é a estação do ano de renovação, caracterizada por temperaturas amenas, dias mais longos e aumento da umidade do ar",
		"next_season" : 'season_2',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "abundant",
			"rain": "common",
			"clouds": "normal",
			"sun": "common",
			"animals": "abundant"
		}
	},
	"season_2" :{
		"name":"Verão",
		"description":"O verão é uma estação caracterizada pelo calor, dias mais longos do que as noites e aumento das chuvas, especialmente chuvas fortes e rápidas de fim de tarde",
		"next_season" : 'season_3',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "normal",
			"rain": "abundant",
			"clouds": "rare",
			"sun": "abundant",
			"animals": "common"
		}
	},
	"season_3" :{
		"name":"Outono",
		"description":"O outono caracteriza-se pela transição do verão para o inverno, com a gradual diminuição da intensidade da luz solar, que leva ao encurtamento dos dias e alongamento das noites.",
		"next_season" : 'season_4',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "rare",
			"rain": "normal",
			"clouds": "abundant",
			"sun": "normal",
			"animals": "normal"
		}
	},
	"season_4" :{
		"name":"Inverno",
		"description":"O inverno é a estação mais fria do ano, caracterizada por temperaturas baixas, dias mais curtos e noites mais longas devido à inclinação do eixo terrestre",
		"next_season" : 'season_1',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "none",
			"rain": "none",
			"clouds": "abundant",
			"sun": "rare",
			"animals": "none"
		}
	}
}

var week_days : Dictionary = {
	"week_day_1" : {
		 "name" : "Domingo"
	},
	"week_day_2" : {
		 "name" : "Segunda-feira"
	},
	"week_day_3" : {
		 "name" : "Terça-feira"
	},
	"week_day_4" : {
		 "name" : "Quarta-feira"
	},
	"week_day_5" : {
		 "name" : "Quinta-feira"
	},
	"week_day_6" : {
		 "name" : "Sexta-feira"
	},
	"week_day_7" : {
		 "name" : "Sábado"
	}
	
	
}
