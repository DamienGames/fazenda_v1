extends Resource
class_name CalendarDatabase

func get_next_season(season_name:String):
		if seasons.has(season_name):
			print(season_name)
		var current_season = seasons.get(season_name)	
		if current_season:
			var next_season = seasons.get(current_season["next_season"])	 
			return next_season

var seasons : Dictionary = { 
	"season_0" :{
		"name": "Primavera",
		"short_name":"PRI",
		"description":"A primavera é a estação do ano de renovação, caracterizada por temperaturas amenas, dias mais longos e aumento da umidade do ar",
		"next_season" : 'season_1',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "abundant",
			"rain": "common",
			"clouds": "normal",
			"sun": "common",
			"animals": "abundant"
		}
	},
	"season_1" :{
		"name": "Verão",
		"short_name":"VER",
		"description":"O verão é uma estação caracterizada pelo calor, dias mais longos do que as noites e aumento das chuvas, especialmente chuvas fortes e rápidas de fim de tarde",
		"next_season" : 'season_2',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "normal",
			"rain": "abundant",
			"clouds": "rare",
			"sun": "abundant",
			"animals": "common"
		}
	},
	"season_2" :{
		"name": "Outono",
		"short_name":"OUT",
		"description":"O outono caracteriza-se pela transição do verão para o inverno, com a gradual diminuição da intensidade da luz solar, que leva ao encurtamento dos dias e alongamento das noites.",
		"next_season" : 'season_3',
		"icon": preload("res://Art/Icons/sword.png"),
		"spawn_rate": {
			"flowers": "rare",
			"rain": "normal",
			"clouds": "abundant",
			"sun": "normal",
			"animals": "normal"
		}
	},
	"season_3" :{
		"name": "Inverno",
		"short_name":"INV",
		"description":"O inverno é a estação mais fria do ano, caracterizada por temperaturas baixas, dias mais curtos e noites mais longas devido à inclinação do eixo terrestre",
		"next_season" : 'season_0',
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
	"week_day_0" : {
		 "name" : "Segunda-feira",
		 "short_name" : "SEG"
	},
	"week_day_1" : {
		 "name" : "Terça-feira",
		 "short_name" : "TER"
	},
	"week_day_2" : {
		 "name" : "Quarta-feira",
		 "short_name" : "QUA"
	},
	"week_day_3" : {
		 "name" : "Quinta-feira",
		 "short_name" : "QUI"
	},
	"week_day_4" : {
		 "name" : "Sexta-feira",
		 "short_name" : "SEX"
	},
	"week_day_5" : {
		 "name" : "Sábado",
		 "short_name" : "SÁB"
	},		
	"week_day_6" : {
		"name" : "Domingo",
		"short_name" : "DOM",
	},
}
