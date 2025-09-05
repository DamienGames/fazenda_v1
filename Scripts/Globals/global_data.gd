extends Node

# Variáveis globais do jogo
var gold: int = 0
var quests: Dictionary = {}   # {"quest_id": "completed"/"in_progress"/"not_started"}

# Flags do jogo (coisas que já aconteceram)
var flags: Dictionary = {}    # {"opened_gate": true, "boss_defeated": false}
