extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hurtbox_component_hurt(damage: int, from: Node) -> void:
	print("hurt")
	pass # Replace with function body.
