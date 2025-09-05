extends State
class_name StateAttack

func enter(_owner: Node, _data := {}) -> void:
	super.enter(_owner, _data)
	actor.animated_sprite_2d.play("d_attack")
	await actor.animated_sprite_2d.animation_finished
	actor.state_machine.change_state("idle")
