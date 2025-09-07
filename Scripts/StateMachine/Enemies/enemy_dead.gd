extends State
class_name EnemyDead

var state_machine

func enter(_actor: Node, _data := {}) -> void:
	# Zera a velocidade e impede movimento
	_actor.velocity = Vector2.ZERO
	
	# Para animação de andar/ataque e toca animação de morte
	if _actor.animated_sprite_2d:
		_actor.animated_sprite_2d.play("dead")
	
	if _actor.has_node("DetectionComponent"):
		_actor.remove_child(_actor.get_node("DetectionComponent"))
	
	# Opcional: desabilita o próprio CharacterBody2D para não colidir
	_actor.set_collision_layer(0)
	_actor.set_collision_mask(0)

func update(delta: float):
	# Aqui normalmente não faz nada
	pass

func exit():
	# Em teoria, DeadState não costuma sair, mas caso queira "reviver"
	# pode reativar tudo aqui
	pass
