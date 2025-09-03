extends Area2D
class_name HurtBoxComponent

@export var max_health: int = 100
var current_health: int

signal damaged(amount, new_health)
signal died

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int, knockback_force: float = 0.0, source_pos: Vector2 = Vector2.ZERO) -> void:
	current_health -= amount
	emit_signal("damaged", amount, current_health)

	if current_health <= 0:
		emit_signal("died")

	# KNOCKBACK OPCIONAL
	var body = get_parent()
	if knockback_force > 0 and body is CharacterBody2D:
		var dir = (body.global_position - source_pos).normalized()
		body.velocity += dir * knockback_force
