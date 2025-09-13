
var total_minutes: int = 0

func _process(delta):
	# avança tempo (opcional)
	total_minutes = (total_minutes + 1) % (24 * 60)
	update_day_night(total_minutes)

func get_day_progress(total_minutes: int) -> float:
	return float(total_minutes) / (24.0 * 60.0)

func get_light_intensity(total_minutes: int) -> float:
	var progress = get_day_progress(total_minutes)
	return clamp(sin(progress * TAU - PI/2), 0.0, 1.0)

func update_day_night(total_minutes: int):
	var intensity = get_light_intensity(total_minutes)
	var day_color = Color(1, 1, 1)
	var night_color = Color(0.05, 0.05, 0.2)
	canvas_modulate.color = day_color.lerp(night_color, 1.0 - intensity)
