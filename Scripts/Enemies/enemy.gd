extends CharacterBody2D

@onready var detection: DetectionComponent = $DetectionComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var state_machine: StateMachine = $StateMachine

@export var speed := 50
signal pick_up()

func _ready() -> void:
	# Registrar estados
	#state_machine.add_state("idle", EnemyIdle.new())
	#state_machine.add_state("walk",  EnemyPatrol.new())
	#state_machine.add_state("attack", EnemyAttack.new())
	#state_machine.add_state("dead", EnemyDead.new())
	pick_up.emit()

	# Começa em idle
	#state_machine.change_state("idle")

func _physics_process(delta: float) -> void:
	if detection.target and detection.has_line_of_sight:
		var distance = global_position.distance_to(detection.target.global_position)

		if distance > 10: # só persegue se estiver mais longe que 30px
			var direction = (detection.target.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_hurtbox_component_hurt(damage: int, from: Node) -> void:
	pass # Replace with function body.

func _on_health_component_died() -> void:
	#state_machine.change_state("dead")
	await get_tree().create_timer(2).timeout
	queue_free()
