# WalkState.gd
extends State
class_name StateWalk

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	actor.animated_sprite_2d.play("run")

func update(delta: float) -> void:
	if not Input.is_action_pressed("ui_right"):
		actor.state_machine.change_state("idle")
