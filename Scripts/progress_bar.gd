extends ProgressBar


func _on_health_component_health_changed(current: int, max: int) -> void:
	max_value = max
	value = current


func _on_health_component_healed(amount: int) -> void:
	value += amount
