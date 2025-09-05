extends Node2D
@onready var scene_component: SceneComponent = $SceneComponent
func _ready() -> void:
	GameSave.on_scene_ready()
	await get_tree().create_timer(2.0).timeout
	#scene_component.change_scene("res://Scenes/player.tscn", { "1": "2"})
