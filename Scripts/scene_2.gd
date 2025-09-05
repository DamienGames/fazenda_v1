extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGlobal.on_scene_ready()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if 	event.is_action_pressed("save_game"):
		SaveComponent2.save_game(1)
	if 	event.is_action_pressed("load_game"):
		SaveComponent2.load_game(1)
