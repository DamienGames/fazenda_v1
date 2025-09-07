class_name  PlayerIdle
extends State

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	var direction = _actor.facing_direction
	
	if abs(direction.x) > abs(direction.y):
		_actor.animated_sprite_2d.play("s_idle")
		_actor.animated_sprite_2d.flip_h = direction.x < 0
	else:
		if direction.y > 0:
			_actor.animated_sprite_2d.play("d_idle")
		else:
			_actor.animated_sprite_2d.play("u_idle")

func update(_actor: Node, delta: float) -> void:
	if actor.input_vector != Vector2.ZERO:
		actor.state_machine.change_state("walk")

	if Input.is_action_just_pressed("attack"):
		actor.state_machine.change_state("attack")
