class_name  PlayerMine
extends State

@export var tile_solo_normal: int = 1
@export var mine_duration: float = 0.1

var timer: Timer

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)
	if not timer:
		timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(_on_mine_finished.bind(_player))
		_player.add_child(timer) 	
	
	if Input.is_action_just_pressed("dig"): 
		if _player.tilemap == null:
			return
		var pos = _player.global_position
		var current_cell = _player.tilemap.local_to_map(_player.tilemap.to_local(pos))		
		var target_cell = current_cell + Vector2i(_player.facing_direction)
		
		if abs(_player.facing_direction.x) > abs(_player.facing_direction.y):
			_player.animated_sprite_2d.play("s_mine")
			_player.animated_sprite_2d.flip_h = _player.facing_direction.x < 0		
		else:
			if _player.facing_direction.y > 0:
				_player.animated_sprite_2d.play("d_ine")
			else:
				_player.animated_sprite_2d.play("u_mine")
				
		await _player.animated_sprite_2d.animation_finished
		timer.start(mine_duration)
		var current_tile = _player.tilemap.get_cell_source_id(target_cell)
		if current_tile == 1:
			_player.tilemap.set_cell(target_cell, 0, Vector2i(1,0)) 
			
func update(_player: Node, delta: float) -> void:
	if _player.input_vector != Vector2.ZERO:
		_player.state_machine.change_state("walk", { "last_dir": _player.facing_direction })

	if Input.is_action_just_pressed("attack"):
		_player.state_machine.change_state("attack", { "last_dir": _player.facing_direction })
		
func _on_mine_finished(_player: Node):
	_player.state_machine.change_state("idle", { "last_dir": _player.facing_direction })
