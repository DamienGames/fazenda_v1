class_name  PlayerDig extends State

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
		
	var tile_data: TileData = _player.tilemap.get_cell_tile_data(target_cell)
		
	if tile_data != null:
		var can_dig = tile_data.get_custom_data_by_layer_id(0)
		if can_dig:
			_player.tilemap_componente.colocar_tile(Globals.ActionState.DIG, "floor", target_cell, 1, Vector2i(6,0)) 
		_player.animation_tree.set("parameters/ActionSM/conditions/is_dig", true)

			
func exit(_player: Node) -> void:
	_player.moviment_state_machine.change_state("idle", { "last_dir": _player.facing_direction })
	_player.animation_tree.set("parameters/ActionSM/conditions/is_dig", false)
