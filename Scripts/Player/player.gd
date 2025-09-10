extends CharacterBody2D
const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var input_vector: Vector2 = Vector2.ZERO
var current_state : String
var facing_direction: Vector2 = Vector2.DOWN 

signal pick_up

func _ready() -> void:	
	 # Registrar estados
	state_machine.add_state("idle", PlayerIdle.new())
	state_machine.add_state("walk", PlayerWalk.new())
	state_machine.add_state("attack", PlayerAttack.new())
	state_machine.add_state("dead", PlayerDead.new())
	pick_up.emit("item_001", 10)
	# Começa em idle
	state_machine.change_state("idle")

func _process(delta: float) -> void:
	state_machine.update(delta)

func _physics_process(delta: float) -> void:	
	# Movimentação básica
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()
		
	velocity = input_vector * SPEED
	move_and_slide()

func _load_state(data: Dictionary) -> void:
	if data.has("position"):
		global_position = data["position"]	
		
func _on_health_component_health_changed(current: int, max: int) -> void:
	if progress_bar:
		progress_bar.value = current

func _on_state_machine_state_changed(new_state: String) -> void:
	current_state = new_state
