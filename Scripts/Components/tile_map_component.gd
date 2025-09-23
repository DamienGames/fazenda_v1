extends Node
class_name TileMapComponent

var layers: Dictionary = {}
var tile_states := {} 

func _ready():
	for child in get_children():
		if child is TileMapLayer:
			layers[child.name.to_lower()] = child

func colocar_tile(action, name: String, cell: Vector2i, source_id: int, atlas_coords: Vector2i):	
	match action:
		Globals.ActionState.DIG:
			layers[name].set_cell(cell, source_id, atlas_coords)
			set_tile_state(cell, "can_dig", false)
		Globals.ActionState.PLANT:
			print("PLANT")
		Globals.ActionState.WATER:
			print("WATER")
						
	if name not in layers:
		push_warning("Camada '%s' não encontrada!" % name)

func limpar_tile(name: String, cell: Vector2i):
	name = name.to_lower()
	if name in layers:
		layers[name].erase_cell(cell)
		
func set_tile_state(cell: Vector2i, key: String, value):
	if not tile_states.has(cell):
		tile_states[cell] = {}
	tile_states[cell][key] = value

func get_tile_state(cell: Vector2i, key: String, default=false):
	if tile_states.has(cell) and key in tile_states[cell]:
		return tile_states[cell][key]
	return default
