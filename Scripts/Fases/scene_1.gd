extends Node2D
@onready var area_2d: Area2D = $AreaPorta
@onready var tile_map_component: TileMapComponent

func _ready() -> void:
	SaveGlobal.on_scene_ready()
	await get_tree().create_timer(2.0).timeout
	TileMapComponent.new()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var scene_component = get_tree().root.get_node_or_null("Main/SceneComponent")
	if scene_component:
		scene_component.change_scene("res://Scenes/Fases/Casa/casa_interior.tscn")
