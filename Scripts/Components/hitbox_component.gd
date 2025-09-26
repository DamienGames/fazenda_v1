@icon("res://Art/Icons/hit.svg")
extends Area2D
class_name HitboxComponent

@export var damage: int = 50
@export var knockback_force: float = 200.0
@onready var collision_shape: CollisionShape2D = find_child("CollisionShape2D", true, false)

signal hit(target)

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var hurtbox: HurtboxComponent = area
		var my_owner = get_parent() # dono deste hitbox
		var target_owner = hurtbox.get_parent()

		# EVITA FRIENDLY FIRE: SÓ ATACA SE NÃO ESTIVER NO MESMO GRUPO
		if my_owner and target_owner:
			var my_groups = my_owner.get_groups()
			var target_groups = target_owner.get_groups()

			if not _share_group(my_groups, target_groups):
				hurtbox.take_hit(damage, my_owner)
				emit_signal("hit", hurtbox)

func _share_group(groups_a: Array, groups_b: Array) -> bool:
	for g in groups_a:
		if g in groups_b:
			return true
	return false

#func _enable_collision(collide: bool):
	#collision_shape.disabled = collide;
