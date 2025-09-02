@icon("res://icons/heart.svg")
class_name HealthComponent
extends  Node

#EXPORT VARS
#LIMITE MAXIMO DE HP
@export var max_health: int = 100:
	set(value):
		max_health = max(value, 1)
		current_health = clamp(current_health, 0, max_health)
		emit_signal("health_changed", current_health, max_health)

#VALOR ATUAL DO HP
@export var current_health: int = 100:
	set(value):
		current_health = clamp(value, 0, max_health)
		emit_signal("health_changed", current_health, max_health)
		if current_health == 0:
			emit_signal("died")


#SIGNALS DE MUDANCA DO HP
signal health_changed(current: int, max: int)
signal died
signal damaged(amount: int)
signal healed(amount: int)

#INICIO DA CLASSE COM VALORES BASE
func _ready() -> void:
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)

#APLICA DANO AO HP ATUAL
func damage(amount: int) -> void:
	amount = max(amount, 0)
	if amount <= 0 or current_health <= 0:
		return
	current_health -= amount
	emit_signal("damaged", amount)
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0:
		emit_signal("died")

#ADICIONA VIDA AO HP ATUAL
func heal(amount: int) -> void:
	amount = max(amount, 0)
	if amount <= 0 or current_health <= 0:
		return
	var before := current_health
	current_health = min(current_health + amount, max_health)
	var real_heal := current_health - before
	if real_heal > 0:
		emit_signal("healed", real_heal)
		emit_signal("health_changed", current_health, max_health)

#AUMENTA O LIMITE MÁXIMO DE VIDA
func inrease_max(amount: int, restore: bool):
	max_health += max(amount, 0)
	if restore:
		restore_full()
		emit_signal("healed", current_health)
	emit_signal("health_changed", current_health, max_health)

#VALIDA SE AINDA ESTA VIVO COM O MENOS 1 HP
func is_alive() -> bool:
	return current_health > 0

#VALIDA SE O HP ESTA CHEIO
func is_full() -> bool:
	return current_health == max_health
	
#RESTAURA O HP AO MÁXIMO
func restore_full() -> void:
	heal(max_health)
