class_name  PlayerMine extends State

@export var tile_solo_normal: int = 1
@export var mine_duration: float = 0.1

var timer: Timer

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)
	
	if _player.tilemap == null:
		return

	var pos = _player.global_position
	var current_cell = _player.tilemap.local_to_map(_player.tilemap.to_local(pos))
	var target_cell = current_cell + Vector2i(_player.facing_direction)		
	var current_tile = _player.tilemap.get_cell_source_id(target_cell)
	_player.tilemap_componente.colocar_tile("floor", target_cell, 1, Vector2i(6,0)) 
	_player.animation_tree.set("parameters/ActionSM/conditions/is_mine", true)

func exit(_player: Node) -> void:
	_player.moviment_state_machine.change_state("idle", { "last_dir": _player.facing_direction })
	_player.animation_tree.set("parameters/ActionSM/conditions/is_mine", false)
