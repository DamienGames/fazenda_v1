extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 50.0
@export var tile_size: int = 8
@export var max_steps: int = 3  # anda até 3 tiles
@export var wait_time: float = 3.0
@export var region: Rect2  # define a área de movimento no editor

var _direction: Vector2 = Vector2.ZERO
var _target_position: Vector2
var _is_moving: bool = false
var _timer: float = 0.0

func _ready() -> void:
	randomize()
	_pick_new_target()

func _process(delta: float) -> void:
	if _is_moving:
		var to_target = _target_position - global_position
		if to_target.length() < 2.0:
			# chegou no destino
			_is_moving = false
			velocity = Vector2.ZERO
			_timer = randf_range(wait_time * 0.5, wait_time * 1.5)
			animated_sprite_2d.play("s_idle")
		else:
			# continua andando até o alvo
			_direction = to_target.normalized()
			if abs(_direction.x) > abs(_direction.y):
				animated_sprite_2d.play("s_walk")
				animated_sprite_2d.flip_h = _direction.x < 0
			else:
				if _direction.y > 0:
					animated_sprite_2d.play("d_walk")
				else:
					animated_sprite_2d.play("s_idle")
		
			velocity = _direction * move_speed
			move_and_slide()
	else:
		animated_sprite_2d.play("d_idle")
		_timer -= delta
		if _timer <= 0.0:
			_pick_new_target()

func _pick_new_target() -> void:
	var x = randf_range(region.position.x, region.position.x + region.size.x)
	var y = randf_range(region.position.y, region.position.y + region.size.y)
	_target_position = Vector2(x, y)	
	_is_moving = true
