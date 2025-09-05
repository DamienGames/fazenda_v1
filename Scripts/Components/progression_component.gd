@icon("res://Art/Icons/progression.svg")
extends  Node
class_name ProgressionComponent

signal xp_changed(current_xp: int, required_xp: int)
signal level_up(new_level: int)

@export var starting_level: int = 1
@export var starting_xp: int = 0
@export var base_required_xp: int = 100   # XP necessária para o lvl 1 -> 2
@export var growth_factor: float = 1.5    # multiplicador de xp necessária por nível

var level: int
var current_xp: int
var required_xp: int

func _ready() -> void:
	level = starting_level
	current_xp = starting_xp
	required_xp = _calculate_required_xp(level)
	emit_signal("xp_changed", current_xp, required_xp)


# Adiciona XP (chame isso ao matar inimigo, completar quest, etc.)
func add_xp(amount: int) -> void:
	current_xp += amount
	while current_xp >= required_xp:
		current_xp -= required_xp
		_level_up()
	emit_signal("xp_changed", current_xp, required_xp)


# Função interna de subir de nível
func _level_up() -> void:
	level += 1
	required_xp = _calculate_required_xp(level)
	emit_signal("level_up", level)

# Para resetar o progresso (exemplo: new game)
func reset() -> void:
	level = starting_level
	current_xp = starting_xp
	required_xp = _calculate_required_xp(level)
	emit_signal("xp_changed", current_xp, required_xp)
	
	# Fórmula para XP necessária (pode customizar aqui)
func _calculate_required_xp(level: int) -> int:
	return int(base_required_xp * pow(growth_factor, level - 1))
