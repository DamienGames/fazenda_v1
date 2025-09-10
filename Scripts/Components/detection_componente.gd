extends Node
class_name DetectionComponent

@export var detection_area: Area2D
@export var raycast: RayCast2D
@export var target_group: String = "player_detection"

var target: Node2D = null
var has_line_of_sight: bool = false

func _physics_process(delta: float) -> void:
	if target and raycast:
		# Atualiza o raycast para mirar no alvo
		raycast.target_position = target.global_position - raycast.global_position

		if raycast.is_colliding():
			var collider = raycast.get_collider()
			print(target)
			print(collider)
			# Só confirma visão se o primeiro collider é o alvo
			if collider == target:
				has_line_of_sight = true
			else:
				has_line_of_sight = false
		else:
			has_line_of_sight = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group(target_group):
		target = area

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group(target_group):
		target = null
		has_line_of_sight = false
