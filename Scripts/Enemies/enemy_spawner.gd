extends Node2D
class_name EnemySpawner

@export var enemy_scene: PackedScene          # cena do inimigo
@export var spawn_points: Array[NodePath]     # pontos de spawn (Position2D ou Marker2D)
@export var spawn_interval: float = 2.0       # tempo entre spawns
@export var max_enemies: int = 10             # limite de inimigos ativos

var _timer: Timer
var _active_enemies: Array = []

func _ready():
	# Cria e inicia o timer de spawn
	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.autostart = true
	_timer.one_shot = false
	_timer.timeout.connect(_on_spawn_timeout)
	add_child(_timer)

func _on_spawn_timeout():
	if not enemy_scene:
		push_warning("⚠ EnemySpawner sem cena definida!")
		return
	
	# Checa limite
	if _active_enemies.size() >= max_enemies:
		return

	# Escolhe ponto aleatório
	if spawn_points.is_empty():
		push_warning("⚠ EnemySpawner sem pontos de spawn!")
		return
	
	var spawn_node = get_node(spawn_points.pick_random())
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_node.global_position
	
	# quando o inimigo morrer/remover, limpa da lista
	enemy.tree_exited.connect(func():
		_active_enemies.erase(enemy))
	
	get_parent().add_child(enemy)
	_active_enemies.append(enemy)
