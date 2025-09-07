# StateMachine.gd
extends Node
class_name StateMachine

signal state_changed(new_state: String)

var states: Dictionary = {}
var current_state: State

func add_state(state_name: String, state: State) -> void:
	states[state_name] = state

func change_state(state_name: String, data := {}) -> void:
	if not states.has(state_name):
		push_error("Estado '%s' não existe!" % state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter(get_parent(), data)  # dono = nó pai (ex: Player)
	
	emit_signal("state_changed", state_name)

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func get_current_state():
	return current_state
