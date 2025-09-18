class_name  PlayerIdle extends State

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
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if dir != Vector2.ZERO:
		_player.moviment_state_machine.change_state("walk", { "last_dir": _player.facing_direction })
