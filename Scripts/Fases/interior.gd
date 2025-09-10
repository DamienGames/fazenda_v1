extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_saida_casa_body_entered(body: Node2D) -> void:
	var scene_component = get_tree().root.get_node_or_null("Main/SceneComponent")
	if scene_component:
		scene_component.change_scene("res://Scenes/Fases/scene_1.tscn")
