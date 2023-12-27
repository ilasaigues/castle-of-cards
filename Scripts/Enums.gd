class_name Enums

# Defines stats that actions can affect, and that modifiers can change on those actions
enum StatType
{
	Damage,
	Healing,
	Defense,
	StatusEffectAmount,
	DrawCount,
	EnergyGain,
	MaxHP,
}

# defines the types of actions that are going to be enqueued.
# both players, enemies or the flow of the game can create them
enum ActionType  
{
	DamageAction,
	HealAction,
	DefenseAction,
	ApplyStatusAction,
	ModifyStatusAction,
	RemoveStatusAction,
	DrawCardAction,
	DiscardAction,
	CreateCardAction,
	DeathAction,
	GainEnergyAction,
	ChangeArtifactCounterAction,
	StartTurnAction,
	EndTurnAction,
}

# For specific conditions that define if an action can be executed or not, if a modifier applies, 
# or if a trigger fires
enum BoolConditionType
{
	TargetIsDead,
	ActorIsAffected,
	TargetIsAffected,
	ActorIsPlayer,
	ActorIsAlly,
}

enum NumberConditionType
{
	ArtifactCounterEquals,
	TargetHPLessThan,
	ActorHPLessThan
}

enum GamePhase
{
	TurnStart,
	ActiveTurn,
	TurnEnd,
	GameOver,
}

enum StatusEffectType
{
	Strength,
	Resilience,
	Weakness,
	Fragility,
	Stun,
	Poison,
}

enum ActionTargetType
{
	Self,
	AllEnemies,
	TargetAny,
	TargetEnemy,
	RandomEnemy,
	All
}

# Modifies how a modifier changes the values it is modifying.
# In implementation (ideally) additive goes first, then mult, then override
enum OperationType
{
	Additive,
	Multiplicative,
	Override
}
