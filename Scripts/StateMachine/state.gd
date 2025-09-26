class_name State extends Node

signal finished(next_state_path: String, data: Dictionary)

# Referência ao dono (ex: Player, Enemy, NPC)
var actor: Node

func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_actor: Node, delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
	
func enter(_actor: Node, _data := {}) -> void:
	actor = _actor

func exit(_actor: Node) -> void:
	pass
