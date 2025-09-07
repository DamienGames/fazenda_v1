extends Node
class_name DetectionComponent

@export var detection_area: Area2D
@export var raycast: RayCast2D
@export var target_group: String = "player_detection"

var target: Node2D = null
var has_line_of_sight: bool = false

func _ready() -> void:
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered)
		detection_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(target_group):
		target = body

func _on_body_exited(body: Node) -> void:
	if body == target:
		target = null
		has_line_of_sight = false

func _physics_process(delta: float) -> void:
	if target and raycast:
		# Atualiza o raycast para mirar no alvo
		raycast.target_position = target.global_position - raycast.global_position

		if raycast.is_colliding():
			var collider = raycast.get_collider()

			# Só confirma visão se o primeiro collider é o alvo
			if collider == target:
				has_line_of_sight = true
			else:
				has_line_of_sight = false
		else:
			has_line_of_sight = false
