extends Resource
class_name EffectDataBase

enum Type {
	HEAL,
	DAMAGE,
	BUFF,
	DEBUFF
}

enum Target {
	HP,
	MP,
	ATTACK,
	DEFENSE,
	MOVEMENT
}

enum TargetGroup {
	SELF,
	HOSTILE,
	NEUTRAL,
	ALL
}

enum BuffType {
	ATTACK_UP,
	DEFENSE_UP,
	SPEED_UP	
}

enum DebuffType {
	POISON,
	BURN,
	FREEZE,
	SLEEP,
	BLIND,
	SILENCE,
	PARALYZED,
	CONFUSE
}
