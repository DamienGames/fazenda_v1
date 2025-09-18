class_name PlayerWalk extends State

@export var speed: float = 120.0
var input_vector := Vector2.ZERO

func enter(_player: Node, _data := {}) -> void:
	# Pode tocar um som de passo ou resetar algo se quiser
	pass

func update(_player: Node, delta: float) -> void:
	if _player.input_vector == Vector2.ZERO:
		_player.moviment_state_machine.change_state("idle", { "last_dir": _player.facing_direction })
		return
		
	if abs(_player.input_vector.x) > abs(_player.input_vector.y):
		_player.animated_sprite_2d.play("s_walk")
		_player.animated_sprite_2d.flip_h = _player.input_vector.x < 0
	else:
		if _player.input_vector.y > 0:
			_player.animated_sprite_2d.play("d_walk")
		else:
			_player.animated_sprite_2d.play("u_walk")

func exit(_player: Node) -> void:
	_player.velocity = Vector2.ZERO
