extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var state_machine: StateMachine = $StateMachine
@onready var state_label: Label = $ProgressBar/StateLabel
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var health: int = 100
 
func _ready() -> void:
	 # Registrar estados
	state_machine.add_state("idle", StateIdle.new())
	state_machine.add_state("walk", StateWalk.new())
	state_machine.add_state("attack", StateAttack.new())

	# Começa em idle
	state_machine.change_state("idle")

func _process(delta: float) -> void:
	state_machine.update(delta)

func _physics_process(delta: float) -> void:	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		GameSave.save_game()

	if event.is_action_pressed("load_game"):
		GameSave.load_game()

func _on_hurtbox_component_hurt(damage: int, from: Node) -> void:
	animated_sprite_2d.play("hurt")

func _on_state_machine_state_changed(new_state: String) -> void:
	state_label.text = new_state
	
func set_data(data: Dictionary) -> void:
	print("Dados recebidos: ", data)
