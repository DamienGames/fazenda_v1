class_name  PlayerIdle
extends State

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)
	var direction = _player.facing_direction
	
	if abs(direction.x) > abs(direction.y):
		_player.animated_sprite_2d.play("s_idle")
		_player.animated_sprite_2d.flip_h = direction.x < 0
	else:
		if direction.y > 0:
			_player.animated_sprite_2d.play("d_idle")
		else:
			_player.animated_sprite_2d.play("u_idle")

func update(_player: Node, delta: float) -> void:
	if _player.input_vector != Vector2.ZERO:
		_player.state_machine.change_state("walk", { "last_dir": _player.facing_direction })

	if Input.is_action_just_pressed("attack"):
		_player.state_machine.change_state("attack", { "last_dir": _player.facing_direction })
		
	if Input.is_action_just_pressed("dig"):
		_player.state_machine.change_state("mine", { "last_dir": _player.facing_direction })
