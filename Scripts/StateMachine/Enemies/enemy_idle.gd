extends State
class_name  EnemyIdle

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	actor.animated_sprite_2d.play("idle")

func update(delta: float) -> void:
	if actor.input_vector != Vector2.ZERO:
		actor.state_machine.change_state("walk")

	if Input.is_action_just_pressed("attack"):
		actor.state_machine.change_state("attack")
