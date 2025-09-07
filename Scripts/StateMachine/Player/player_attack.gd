extends State
class_name PlayerAttack
var facing_dir: Vector2 = Vector2.DOWN 

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	
	var offset := Vector2.ZERO
	var distance := 4 
	0	
	if abs(_actor.facing_direction.x) > abs(_actor.facing_direction.y):
		offset.x = distance * sign(_actor.facing_direction.x)
		offset.y = 0
		_actor.animated_sprite_2d.play("s_attack")
		_actor.animated_sprite_2d.flip_h = _actor.facing_direction.x < 0		
	else:
		offset.y = distance * sign(_actor.facing_direction.y)
		offset.x = 0
		if _actor.facing_direction.y > 0:
			_actor.animated_sprite_2d.play("d_attack")
		else:
			_actor.animated_sprite_2d.play("u_attack")
			
	_actor.hitbox_component.position = offset
	_actor.hitbox_component._enable_collision(false);
	await _actor.animated_sprite_2d.animation_finished
	_actor.hitbox_component._enable_collision(true);
	_actor.state_machine.change_state("idle")
