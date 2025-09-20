extends Node2D

func _process(delta: float) -> void:
	pass

func _on_saida_casa_body_entered(body: Node2D) -> void:
	var scene_component = get_tree().root.get_node_or_null("Main/SceneComponent")	
	if scene_component:
		scene_component.change_scene("res://Scenes/Fases/farm.tscn")
		var daynight = get_tree().root.get_node_or_null("Main/DayNightCicle")
		daynight.visible = true
