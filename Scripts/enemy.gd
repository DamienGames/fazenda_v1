extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var detection: DetectionComponent = $DetectionComponent

#@export var target: CharacterBody2D
@export var speed := 100

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:	
	#navigation_agent_2d.target_position = target.global_position

func _physics_process(delta: float) -> void:
	#navigation_agent_2d.target_position = target.global_position
	#var next_path_pos = navigation_agent_2d.get_next_path_position()
	#var direction = (next_path_pos - global_position).normalized()
	#velocity = direction * speed
	#move_and_slide()
	
	if detection.target and detection.has_line_of_sight:
		var direction = (detection.target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

#func go_to_target():
	#navigation_agent_2d.target_position = target.global_position

func _on_hurtbox_component_hurt(damage: int, from: Node) -> void:
	print("hurt")
	pass # Replace with function body.
