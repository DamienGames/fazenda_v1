extends Node2D
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	SaveGlobal.on_scene_ready()
	await get_tree().create_timer(2.0).timeout
			
