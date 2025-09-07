extends State
class_name PlayerAttack
var facing_dir: Vector2 = Vector2.DOWN 

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	_actor.animated_sprite_2d.play("d_attack")
	_actor.hitbox_component._enable_collision(false);
	await _actor.animated_sprite_2d.animation_finished
	_actor.hitbox_component._enable_collision(true);
	_actor.state_machine.change_state("idle")
