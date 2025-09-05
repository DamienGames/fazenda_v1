# IdleState.gd
extends State
class_name StateIdle

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	actor.animated_sprite_2d.play("d_idle")

func update(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		actor.state_machine.change_state("walk")
	if Input.is_action_just_pressed("attack"):
		actor.state_machine.change_state("attack")
