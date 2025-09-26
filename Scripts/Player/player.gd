class_name Player extends CharacterBody2D

const SPEED = 60.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $Animations/AnimationPlayer
@onready var animation_tree: AnimationTree = $Animations/AnimationTree

# state machine
@onready var moviment_state_machine: MovimentStateMachine = $MovimentStateMachine
@onready var action_state_machine: ActionStateMachine = $ActionStateMachine

# componentes
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var inventory_component: InventoryComponent = $InventoryComponent

var input_vector: Vector2 = Vector2.ZERO
var current_state : String
var facing_direction: Vector2 = Vector2.DOWN 
var tilemap: TileMapLayer
var tilemap_componente : TileMapComponent

signal player_pick_up(item:String, amount:int)

func _ready() -> void:	
	animation_tree.active = true	
	 # Registrar estados
	moviment_state_machine.add_state("idle", PlayerIdle.new())
	moviment_state_machine.add_state("walk", PlayerWalk.new())
	
	action_state_machine.add_state("attack", PlayerAttack.new())
	action_state_machine.add_state("dead", PlayerDead.new())
	action_state_machine.add_state("mine", PlayerMine.new())
	action_state_machine.add_state("dig", PlayerDig.new())

	tilemap = get_tree().get_first_node_in_group("floor")
	if get_parent().has_node("TileMapComponent"):
		tilemap_componente = get_parent().get_node("TileMapComponent")
		
	moviment_state_machine.change_state("idle")
	var state_machine  = animation_tree.get("parameters/MovimentSM/playback")
	state_machine.travel("Idle")
	animation_tree.active = true;
	animation_tree.set("parameters/MovimentSM/conditions/is_idle", true)
	
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
	
	animation_tree.set("parameters/MovimentSM/Idle/blend_position", facing_direction)
	animation_tree.set("parameters/MovimentSM/Walk/blend_position", input_vector)

	moviment_state_machine.update(delta)

	if Input.is_action_just_pressed("attack"):
		action_state_machine.change_state("attack", { "last_dir": facing_direction })
		
	if Input.is_action_just_pressed("mine"):
		action_state_machine.change_state("mine", { "last_dir": facing_direction })
	
	if Input.is_action_just_pressed("dig"):
		action_state_machine.change_state("dig", { "last_dir": facing_direction })
	
	action_state_machine.update(delta)	

func _load_state(data: Dictionary) -> void:
	if data.has("position"):
		global_position = data["position"]	
		
func _on_health_component_health_changed(current: int, max: int) -> void:
	if progress_bar:
		progress_bar.value = current

func _on_state_machine_state_changed(new_state: String) -> void:
	current_state = new_state


func get_save_data() -> Dictionary:
	return {
		"global_position": global_position,
		"facing_direction": facing_direction,
		"inventory_itens": inventory_component.get_all_items()
	}

func set_save_data(data: Dictionary) -> void:
	global_position = data.get("global_position", global_position)
	facing_direction = data.get("facing_direction", facing_direction)
	var items = data.get("inventory_itens", {})
	for i in items:
		inventory_component.add_item(i)
		
