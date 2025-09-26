class_name PlayerWalk extends State

@export var speed: float = 120.0
var input_vector := Vector2.ZERO

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)	
	var state_machine  = _player.animation_tree.get("parameters/MovimentSM/playback")
	_player.animation_tree.set("parameters/MovimentSM/conditions/is_walk", true)
	state_machine.travel("Walk")
	
func update(_player: Node, delta: float) -> void:
	if _player.input_vector == Vector2.ZERO:
		_player.moviment_state_machine.change_state("idle", { "last_dir": _player.facing_direction })

func exit(_player: Node) -> void:
	_player.velocity = Vector2.ZERO
	_player.animation_tree.set("parameters/MovimentSM/conditions/is_walk", false)
