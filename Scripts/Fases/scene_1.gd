extends Node2D
@onready var scene_component: SceneComponent
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	SaveGlobal.on_scene_ready()
	await get_tree().create_timer(2.0).timeout
			


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		scene_component.change_scene("res://Scenes/Fases/scene_2.tscn") 
