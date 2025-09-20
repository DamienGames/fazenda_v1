extends CanvasModulate

const COLOR_DAWN      = Color("#fbb18de3")
const COLOR_MORNING   =  Color("#feebe2fd") 
const COLOR_AFTERNOON = Color("#fdcbb3fd")
const COLOR_NIGHT_FALL     = Color("#d277efc0")
const COLOR_NIGHT     = Color("#4a65a3cb")

func _ready() -> void:
	Calendar.minute_tick.connect(Callable(self,"_on_calendar_component_minute_tick" ))

func _on_calendar_component_minute_tick(time: String, total_minutes : int):
	if total_minutes >= 6*100 and total_minutes < 8*100:
		var t = float(total_minutes - 6*100) / float(8*100)
		color = COLOR_DAWN.lerp(COLOR_MORNING, t)		
	elif total_minutes >= 8*100 and total_minutes < 12*100:
		var t = float(total_minutes - 8*100) / float(12*100)
		color = COLOR_MORNING.lerp(COLOR_AFTERNOON, t)	
	elif total_minutes >= 12*100 and total_minutes < 18*100:
		var t = float(total_minutes - 12*100) / float(18*100)
		color = COLOR_AFTERNOON.lerp(COLOR_NIGHT_FALL, t)
	elif total_minutes >= 18*100 and total_minutes < 24*100:
		var t = float(total_minutes - 18*100) / float(24*100)
		color = COLOR_NIGHT_FALL.lerp(COLOR_NIGHT, t)		
	else: 
		color = COLOR_NIGHT
