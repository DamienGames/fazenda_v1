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
		if abs(_player.facing_direction.x) > abs(_player.facing_direction.y):
			_player.animated_sprite_2d.play("s_mine")
			_player.animated_sprite_2d.flip_h = _player.facing_direction.x < 0		
		else:
			if _player.facing_direction.y > 0:
				_player.animated_sprite_2d.play("d_mine")
			else:
				_player.animated_sprite_2d.play("u_mine")
				
		await _player.animated_sprite_2d.animation_finished
		timer.start(mine_duration)
		
		var pos = _player.global_position
		var current_cell = _player.tilemap.local_to_map(_player.tilemap.to_local(pos))		
		var target_cell = current_cell + Vector2i(_player.facing_direction)
		var current_tile = _player.tilemap.get_cell_source_id(target_cell)
	#_player.tilemap_componente.limpar_tile("floor", target_cell)
		_player.tilemap_componente.colocar_tile("floor", target_cell, 1, Vector2i(1,0)) 
			
func _on_mine_finished(_player: Node):
	_player.moviment_state_machine.change_state("idle", { "last_dir": _player.facing_direction })
