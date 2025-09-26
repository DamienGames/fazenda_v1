class_name  PlayerIdle extends State

func enter(_player: Node, _data := {}) -> void:
	super.enter(_player, _data)

func update(_player: Node, delta: float) -> void:
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if dir != Vector2.ZERO:
		_player.moviment_state_machine.change_state("walk", { "last_dir": _player.facing_direction })
	else:
		_player.animation_tree.set("parameters/MovimentSM/conditions/is_idle", true)

func exit(_player: Node) -> void:
	_player.animation_tree.set("parameters/MovimentSM/conditions/is_idle", false)
	
