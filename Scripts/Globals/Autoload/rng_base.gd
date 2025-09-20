extends Node

var rng = RandomNumberGenerator.new()
var lista :Array = [1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.seed = hash("seed1")
	for i in rng.randi_range(1,10):
		var dado = lista.pick_random()
		print(dado)
		if dado == 20:
			print("CRITICAL")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
