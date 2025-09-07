extends State
class_name PlayerAttack

@export var attack_duration: float = 0.3 # tempo da animação do ataque
var timer: Timer

func enter(_actor: Node, _data := {}) -> void:
	super.enter(_actor, _data)
	print("enter")
	if not timer:
		timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(_on_attack_finished.bind(_actor))
		_actor.add_child(timer)  # <<--- agora ele entra no SceneTree
	
	var offset := Vector2.ZERO
	var distance := 8
	
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
	
	await _actor.animated_sprite_2d.animation_finished
	timer.start(attack_duration)
	_actor.hitbox_component._enable_collision(false);
	_actor.state_machine.change_state("idle")

func _on_attack_finished(_actor: Node) -> void:
	# desativa hitbox
	_actor.hitbox_component._enable_collision(true);
	
	# volta para Idle mantendo direção
	_actor.state_machine.change_state("idle", { "last_dir": _actor.facing_direction })
