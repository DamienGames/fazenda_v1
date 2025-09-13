extends CanvasModulate

const COLOR_MORNING   =  Color("#ec9870dd") # alaranjado suave
const COLOR_AFTERNOON = Color("#feebe2fd") # claro
const COLOR_NIGHT     = Color("#d277efc0") # azul escuro
const COLOR_DAWN      = Color("#a89afcc0") # quase preto/azul
const COLOR_END      = Color("#a7b7fce7") # quase preto/azul

func _ready() -> void:
		CalendarGlobal.minute_tick.connect(Callable(self,"_on_calendar_component_minute_tick" ))

func _on_calendar_component_minute_tick(time: String, total_minutes : int):
	if total_minutes >= 6*100 and total_minutes < 12*100:
		var t = float(total_minutes - 6*100) / float(6*100) # 0.0 → 06h, 1.0 → 12h
		color = COLOR_MORNING.lerp(COLOR_AFTERNOON, t)
	
	elif total_minutes >= 12*100 and total_minutes < 18*100:
		var t = float(total_minutes - 12*100) / float(6*100)
		color = COLOR_AFTERNOON.lerp(COLOR_NIGHT, t)		

	elif total_minutes >= 12*100 and total_minutes < 18*100:
		var t = float(total_minutes - 12*100) / float(6*100)
		color = COLOR_AFTERNOON.lerp(COLOR_NIGHT, t)

	elif total_minutes >= 18*100 and total_minutes < 24*100:
		var t = float(total_minutes - 18*60) / float(6*100)
		color = COLOR_NIGHT.lerp(COLOR_DAWN, t)

	else: # 00:00 até 02:00
		var t = float(total_minutes) / float(2*100)
		color = COLOR_NIGHT.lerp(COLOR_END, t)
