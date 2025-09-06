extends State
class_name StateAttack

func enter(_owner: Node, _data := {}) -> void:
	super.enter(_owner, _data)
	var hitbox_component = actor.get_node("HitboxComponent")
	actor.animated_sprite_2d.play("d_attack")
	hitbox_component._enable_collision(false);
	await actor.animated_sprite_2d.animation_finished
	hitbox_component._enable_collision(true);
	actor.state_machine.change_state("idle")
