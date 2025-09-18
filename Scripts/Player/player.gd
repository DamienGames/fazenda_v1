extends CharacterBody2D
const SPEED = 60.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# state machine
@onready var moviment_state_machine: MovimentStateMachine = $MovimentStateMachine
@onready var action_state_machine: ActionStateMachine = $ActionStateMachine

# componentes
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var input_vector: Vector2 = Vector2.ZERO
var current_state : String
var facing_direction: Vector2 = Vector2.DOWN 
var tilemap: TileMapLayer
var tilemap_componente : TileMapComponent

signal pick_up

func _ready() -> void:	
	 # Registrar estados
	moviment_state_machine.add_state("idle", PlayerIdle.new())
	moviment_state_machine.add_state("walk", PlayerWalk.new())
	
	action_state_machine.add_state("attack", PlayerAttack.new())
	action_state_machine.add_state("dead", PlayerDead.new())
	action_state_machine.add_state("mine", PlayerMine.new())
	
	tilemap = get_tree().get_first_node_in_group("floor")
	if get_parent().has_node("TileMapComponent"):
		tilemap_componente = get_parent().get_node("TileMapComponent")
	pick_up.emit("item_001", 10)
	# Começa em idle
	moviment_state_machine.change_state("idle")

func _physics_process(delta: float) -> void:
	# Movimentação básica
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector
		velocity = facing_direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	velocity = input_vector * SPEED
	move_and_slide()
	
	moviment_state_machine.update(delta)
	
	if Input.is_action_just_pressed("attack"):
		action_state_machine.change_state("attack", { "last_dir": facing_direction })
		
	if Input.is_action_just_pressed("dig"):
		action_state_machine.change_state("mine", { "last_dir": facing_direction })
	
	action_state_machine.update(delta)	

func _load_state(data: Dictionary) -> void:
	if data.has("position"):
		global_position = data["position"]	
		

func _on_health_component_health_changed(current: int, max: int) -> void:
	if progress_bar:
		progress_bar.value = current

func _on_state_machine_state_changed(new_state: String) -> void:
	current_state = new_state
