extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal pick(id:String, amount:int)
signal drop(id:String, amount:int)
		 
func _ready() -> void:
	pick.emit("item_0002",13)
	await get_tree().create_timer(2.0).timeout
	pick.emit("item_0002",12)
	await get_tree().create_timer(2.0).timeout
	drop.emit("item_0002",10)
	pick.emit("item_0001",5)
	pass

func _physics_process(delta: float) -> void:	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
