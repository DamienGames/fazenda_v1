extends Resource
class_name ItemDatabase

var items: Dictionary = {	
	"item_0001": {
		"type": "weapon",
		"name": "Espada de ferro antiga",
		"description" : "Espada antiga encontrada na floresta",
		"max_stack": 1,
		"icon": preload("res://Art/Icons/sword.png"),
		"gold_cost": 100,
		"durability": 100,
		"weight" : 10.0,
		"effects":
			[ 
				{
					"name" : "Ataque Normal",
					"target" : EffectDataBase.Target.HP,
					"type" : EffectDataBase.Type.DAMAGE,
					"target_group" : EffectDataBase.TargetGroup.HOSTILE,
					"damage": "30|50"					
				},
				{
					"name" : "Ataque venenoso",
					"target" : EffectDataBase.Target.HP,
					"type" : EffectDataBase.Type.DEBUFF,
					"target_group" : EffectDataBase.TargetGroup.HOSTILE,
					"damage": "10|10",
					"debuff":{
						"type" : EffectDataBase.DebuffType.POISON,
						"duration" : "5"
					}
				}
		]
	},
	"item_0002": {
		"type": "consumable",
		"name": "Poção de cura pequena",
		"description" : "Restaura 10 de HP",
		"max_stack": 99,
		"icon": preload("res://Art/Icons/potion.png"),
		"gold_cost": 50,
		"effects":
			[ 
				{
					"name" : "Curar",
					"target" : EffectDataBase.Target.HP,
					"type" : EffectDataBase.Type.HEAL,
					"target_group" : EffectDataBase.TargetGroup.SELF,
					"amount": 20,
				}
		]
	}	
}

func get_item(id: String) -> Dictionary:
	if items.has(id):
		return items.get(id)
	return {}
	
