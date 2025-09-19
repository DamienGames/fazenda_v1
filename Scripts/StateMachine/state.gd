class_name State extends Node

signal finished(next_state_path: String, data: Dictionary)

# Referência ao dono (ex: Player, Enemy, NPC)
var actor: Node

func update(_actor: Node, delta: float) -> void:
	# Chamado a cada frame
	pass
	
func physics_update(_delta: float) -> void:
	pass
	
func enter(_actor: Node, _data := {}) -> void:
	actor = _actor
	# Executa ao entrar no estado

func exit(_actor: Node) -> void:
	# Executa ao sair do estado
	pass

func handle_input(_event: InputEvent) -> void:
	pass
