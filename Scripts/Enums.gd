class_name Enums

# Defines stats that actions can affect, and that modifiers can change on those actions
enum StatType
{
	Damage,
	Healing,
	Defense,
	StatusEffectAmount,
	StatusEffectTurns,
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
	StartBattleAction,
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
	# TODO: check this. It's supposed to be used for triggers right? When player draws
	# a card out of turn
	CardIsDrawn,
}

enum StatusEffectConditionType 
{
	StatusEffectAppliedIs,
	StatusEffectAppliedIsBuff,
	TargetHasStatusEffect,
	ActorHasStatusEffect
}

enum TriggerConditionType
{
	ActorExecutesAction,
	ActorExectuesActionTarget,
	ActorKillsTrigger
}

enum NumberConditionType
{
	ArtifactCounterEquals,
	TargetHPLessThan,
	ActorHPLessThan,
	CharacterHPLessThan,
}

enum GamePhase
{
	BattleStart,
	TurnStart,
	DrawStart,
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
	Disease,
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

enum TriggerTargetType 
{
	Player,
	ActorEnemy,
	RandomEnemy,
	RandomCharacter,
	AllEnemies,
	AllAllies,
	All
}

enum TriggerActor
{
	ArtifactTriggerByPlayer,
	ArtifactTriggerByEnvironment,
	StatusEffect
}

# Modifies how a modifier changes the values it is modifying.
# In implementation (ideally) additive goes first, then mult, then override
enum OperationType
{
	Additive,
	Multiplicative,
	Override
}
