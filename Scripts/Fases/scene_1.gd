extends Node2D
@onready var area_2d: Area2D = $AreaPorta
@onready var tile_map_component: TileMapComponent

func _ready() -> void:
	TileMapComponent.new()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if 	body.is_in_group("player"):
		var daynight = get_tree().root.get_node_or_null("Main/DayNightCicle")
		daynight.visible = false
		var scene_component = get_tree().root.get_node_or_null("Main/SceneComponent")
		if scene_component:
			scene_component.change_scene("res://Scenes/Fases/Casa/casa_interior.tscn")
