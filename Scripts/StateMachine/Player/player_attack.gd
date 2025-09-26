class_name PlayerAttack extends State

@export var attack_duration: float = 0.3

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)
	_player.animation_tree.set("parameters/ActionSM/conditions/is_attack", true)

func exit(_player: Node) -> void:
	_player.animation_tree.set("parameters/ActionSM/conditions/is_attack", false)
