extends State
class_name PlayerWalk

@export var speed: float = 120.0
var input_vector := Vector2.ZERO

func enter(_player: Node, _data := {}) -> void:
	# Pode tocar um som de passo ou resetar algo se quiser
	pass

func update(_player: Node, delta: float) -> void:
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector == Vector2.ZERO:
		_player.state_machine.change_state("idle", { "last_dir": _player.facing_direction })
		return
		
	_player.facing_direction = input_vector

	if abs(input_vector.x) > abs(input_vector.y):
		_player.animated_sprite_2d.play("s_walk")
		_player.animated_sprite_2d.flip_h = input_vector.x < 0
	else:
		if input_vector.y > 0:
			_player.animated_sprite_2d.play("d_walk")
		else:
			_player.animated_sprite_2d.play("u_walk")

func exit(_player: Node) -> void:
	_player.velocity = Vector2.ZERO
