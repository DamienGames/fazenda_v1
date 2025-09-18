class_name PlayerAttack extends State

@export var attack_duration: float = 0.3
var timer: Timer

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)
	if not timer:
		timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(_on_attack_finished.bind(_player))
		_player.add_child(timer) 
	
	var offset := Vector2.ZERO
	var distance := 8
	
	if abs(_player.facing_direction.x) > abs(_player.facing_direction.y):
		offset.x = distance * sign(_player.facing_direction.x)
		offset.y = 0
		_player.animated_sprite_2d.play("s_attack")
		_player.animated_sprite_2d.flip_h = _player.facing_direction.x < 0		
	else:
		offset.y = distance * sign(_player.facing_direction.y)
		offset.x = 0
		if _player.facing_direction.y > 0:
			_player.animated_sprite_2d.play("d_attack")
		else:
			_player.animated_sprite_2d.play("u_attack")
			
	_player.hitbox_component.position = offset
	
	await _player.animated_sprite_2d.animation_finished
	timer.start(attack_duration)
	_player.hitbox_component._enable_collision(false)
	exit(_player)

func _on_attack_finished(_player: Node) -> void:
	_player.hitbox_component._enable_collision(true)
	_player.moviment_state_machine.change_state("idle", { "last_dir": _player.facing_direction })


	
func exit(_player: Node) -> void:
	_player.hitbox_component._enable_collision(false);
