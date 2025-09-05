extends Node
class_name State

signal transiotioned(state: State, new_state_name: String)

# Referência ao dono (ex: Player, Enemy, NPC)
var actor: Node

func enter(_actor: Node, _data := {}) -> void:
	actor = _actor
	# Executa ao entrar no estado

func update(_delta: float) -> void:
	# Chamado a cada frame
	pass

func exit() -> void:
	# Executa ao sair do estado
	pass
