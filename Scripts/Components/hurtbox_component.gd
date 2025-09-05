@icon("res://Art/Icons/hurt.svg")
extends Area2D
class_name HurtboxComponent

signal hurt(damage: int, from: Node)  # quando leva dano
signal blocked(from: Node)            # se bloquear/parar o ataque
signal invincible_started
signal invincible_ended

@export var health_component: NodePath
@export var is_invincible: bool = false

var _health: HealthComponent

func _ready():
	if health_component != NodePath():
		_health = get_node(health_component)

	connect("area_entered", Callable(self, "_on_area_entered"))

# 🔹 Chamado quando uma hitbox entra na hurtbox
func _on_area_entered(area: Area2D) -> void:
	if is_invincible:
		emit_signal("blocked", area)
		return

	if area is HitboxComponent:
		take_hit(area.damage, area)

# 🔹 Receber dano
func take_hit(damage: int, from: Node) -> void:
	if _health and not is_invincible:
		_health.take_damage(damage)
		emit_signal("hurt", damage, from)

# 🔹 Ativar invencibilidade (ex: durante dodge ou após ser atingido)
func set_invincible(active: bool, duration: float = 0.0) -> void:
	is_invincible = active
	if active:
		emit_signal("invincible_started")
		if duration > 0:
			await get_tree().create_timer(duration).timeout
			set_invincible(false)
	else:
		emit_signal("invincible_ended")

# 🔹 Checar se ainda pode levar dano
func can_be_hit() -> bool:
	return not is_invincible and _health and not _health.is_dead()
