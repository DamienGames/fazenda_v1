extends Node
class_name State

# Referência ao dono (ex: Player, Enemy, NPC)
var actor: Node

func enter(_actor: Node, _data := {}) -> void:
	actor = _actor
	# Executa ao entrar no estado

func update(_actor: Node, delta: float) -> void:
	# Chamado a cada frame
	pass

func exit(_actor: Node) -> void:
	# Executa ao sair do estado
	pass
