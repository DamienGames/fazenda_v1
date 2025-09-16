extends Node
class_name TileMapComponent

var layers: Dictionary = {}

func _ready():
	for child in get_children():
		if child is TileMapLayer:
			layers[child.name.to_lower()] = child

func colocar_tile(nome_camada: String, cell: Vector2i, source_id: int, atlas_coords: Vector2i):
	nome_camada = nome_camada.to_lower()
	if nome_camada in layers:
		layers[nome_camada].set_cell(cell, source_id, atlas_coords)
	else:
		push_warning("Camada '%s' não encontrada!" % nome_camada)

func limpar_tile(nome_camada: String, cell: Vector2i):
	nome_camada = nome_camada.to_lower()
	if nome_camada in layers:
		layers[nome_camada].erase_cell(cell)
