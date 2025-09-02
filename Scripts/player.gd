extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	health_component.damage(99)
	await get_tree().create_timer(2.0).timeout
	health_component.heal(22)
	await get_tree().create_timer(2.0).timeout
	health_component.restore_full()

func _physics_process(delta: float) -> void:	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
