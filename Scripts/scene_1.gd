extends Node2D

func _ready() -> void:
	SaveGlobal.on_scene_ready()
	await get_tree().create_timer(2.0).timeout
			
