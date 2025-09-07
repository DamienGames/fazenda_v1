extends State
class_name  PlayerWalk
@export var speed: float = 120.0

var input_vector = Vector2.ZERO

func enter(_actor: Node, _data := {}) -> void:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	_actor.velocity = input_vector * speed
	_actor.move_and_slide()
	
	if input_vector == Vector2.ZERO:
		# passa a última direção para o IdleState
		_actor.state_machine.set_state(get_parent().get_node("Idle"), { "last_dir": owner.facing_dir })
		return
	
	# Atualiza direção de olhar
	#_actor.facing_dir = input_vector
	
	# ---------- Animações ----------
	if abs(input_vector.x) > abs(input_vector.y):
		_actor.animated_sprite_2d.play("u_walk")
		_actor.animated_sprite_2d.flip_h = input_vector.x < 0
	else:
		if input_vector.y > 0:
			_actor.animated_sprite_2d.play("u_walk")
		else:
			_actor.animated_sprite_2d.play("u_walk")
	
