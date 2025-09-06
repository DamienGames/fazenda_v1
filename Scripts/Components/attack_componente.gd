extends Node
class_name AttackComponent

signal attack_started(target: Node2D)
signal attack_hit(target: Node2D, damage: int)
signal attack_finished()

enum AttackType { MELEE, RANGED }

@export var type: AttackType = AttackType.MELEE
@export var attack_range: float = 48.0
@export var damage_min: int = 5
@export var damage_max: int = 15
@export var cooldown: float = 1.0
@export var knockback_force: float = 0.0
@export var projectile_scene: PackedScene

var _cooldown_timer: float = 0.0
var _owner: Node2D

func _ready() -> void:
	_owner = get_parent()

func _physics_process(delta: float) -> void:
	if _cooldown_timer > 0:
		_cooldown_timer -= delta

func try_attack(target: Node2D) -> void:
	if not target or _cooldown_timer > 0:
		return
	
	# calcula se o alvo está dentro do alcance
	var distance = _owner.global_position.distance_to(target.global_position)
	if distance > attack_range:
		return
	
	# reseta cooldown
	_cooldown_timer = cooldown
	
	# emite sinal de início
	attack_started.emit(target)
	
	match type:
		AttackType.MELEE:
			_do_melee_attack(target)
		AttackType.RANGED:
			_do_ranged_attack(target)
	
	# emite sinal de fim
	attack_finished.emit()

func _do_melee_attack(target: Node2D) -> void:
	var dmg = randi_range(damage_min, damage_max)
	attack_hit.emit(target, dmg)
	
	# knockback opcional
	if knockback_force > 0 and target.has_method("apply_knockback"):
		var dir = (target.global_position - _owner.global_position).normalized()
		target.apply_knockback(dir * knockback_force)

func _do_ranged_attack(target: Node2D) -> void:
	if projectile_scene == null:
		push_warning("Ranged attack requires a projectile_scene!")
		return
	
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = _owner.global_position
	
	if projectile.has_method("launch"):
		projectile.launch(target.global_position, randi_range(damage_min, damage_max))
