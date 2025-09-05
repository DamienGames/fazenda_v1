extends Node2D
@onready var scene_component: SceneComponent = $SceneComponent
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	SaveGlobal.on_scene_ready()
	await get_tree().create_timer(2.0).timeout
	#scene_component.change_scene("res://Scenes/Fases/scene_2.tscn", { "1": "2"})
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		scene_component.change_scene("res://Scenes/Fases/scene_2.tscn", { "1": "2"})
		
func _input(event: InputEvent) -> void:
	if 	event.is_action_pressed("save_game"):
		SaveComponent2.save_game(1)
	if 	event.is_action_pressed("load_game"):
		SaveComponent2.load_game(1)
