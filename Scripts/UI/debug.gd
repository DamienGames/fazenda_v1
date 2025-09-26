extends CanvasLayer
class_name DebugPanel

@onready var panel = $Panel
@onready var label = $Panel/RichTextLabel

var enabled: bool = true

func _ready():
	# 🔹 Configura tamanho/posição do painel
	panel.size = Vector2(350, 200)
	panel.position = Vector2(10, 10)
	update_debug_info()

func _process(_delta: float) -> void:
	if enabled:
		update_debug_info()

	if Input.is_action_just_pressed("debug_toggle"):
		enabled = !enabled
		visible = enabled

func update_debug_info():
	var player = get_tree().get_first_node_in_group("player")
	var player_health := "?"
	var player_pos := "?"
	var current_state := "?"
	var animation := "?"
	
	if player:
		var health_component = player.get_node_or_null("HealthComponent")
		current_state = player.current_state		
		if health_component:
			player_health = str(health_component.current_health, "/", health_component.max_health)
		player_pos = str(player.global_position)

	var text := """
	[b]DEBUG PANEL
	FPS: %d
	Scene: %s
	Player Pos: %s
	Player Health: %s
	CurrentState: %s
	Animation: %s
	Gold: %d
	XP: %d
	Quests: %s
	Flags: %s
	Achievements: %s
	""" % [
		Engine.get_frames_per_second(),
		get_tree().current_scene.scene_file_path,
		player_pos,
		player_health,
		current_state,
		animation,
		GameState.current_gold,
		GameState.current_xp,
		str(GameState.quests),
		str(GameState.flags),
		str(GameState.achievements)
	]

	label.text = text
