class_name Hurtbox
extends Area3D

var damage_text := preload("res://vfx/damage_text.tscn")

# Changing the name of a hurtbox node is fine (UNLESS IT'S A BOSS HURTBOX DISPLAYED IN UI); nothing looks at a hurtbox name (EXCEPT FOR UI ON A DISPLAYED HURTBOX)
# You shouldn't change the name of a hitbox since that's what hurtboxes look at

signal hit_received(damage: int)

var rng := RandomNumberGenerator.new()
@export var hit_particle_color := Color.RED
@export var dp_impulse_limit := 5
@export var dp_count := 5
var health := 100.0
var max_health := 100.0 # This is only set by the Globals script or the CotuHurtbox script.
var current_opponent_hitboxes
@export var opponent_hitboxes := ["default"] # opponent is a misnomer; this is a list any hitboxes that could affect this entity, opponent, ally, or neutral, e.g. PlayerHitbox, EnemyHitbox
@export var hurtbox_owner : Node3D # If this isn't set, parent is used as hurtbox owner
var hb_owner : Node3D

@onready var root := get_tree().root
var level : Node3D

func _ready():
	level = root.find_child("Level", true, false)
	area_entered.connect(on_hit)
	current_opponent_hitboxes = opponent_hitboxes
	assert(opponent_hitboxes != ["default"], "opponent hitboxes not changed from default")
	
	hb_owner = hurtbox_owner if hurtbox_owner != null else get_parent()

func set_invincibility(val: bool):
	if val:
		current_opponent_hitboxes = []
	else:
		current_opponent_hitboxes = opponent_hitboxes

func _physics_process(_delta):
	pass

func on_hit(hitbox):
	if hitbox.name in current_opponent_hitboxes:
		if "is_dodging" in hb_owner:
			if not hb_owner.is_dodging:
				receive_hit(hitbox, hitbox.get_parent())
			else:
				return
		else:
			receive_hit(hitbox, hitbox.get_parent())

func receive_hit(hitbox, _hitter):
	# Damage
	hit_received.emit(hitbox.damage)
	health -= hitbox.damage
	# Spawn damage number
	var number = damage_text.instantiate()
	level.add_child.call_deferred(number)
	await number.tree_entered
	number.global_position = global_position 
	number.setup(hitbox.damage)
	
	# Heal
	health += hitbox.heal_amt
	if health > max_health:
		health = max_health
	
	# Debuff
	if hitbox.debuff != Globals.DEBUFFS.NONE and "active_debuffs" in hb_owner and hb_owner.active_debuffs[hitbox.debuff] <= 0:
		match(hitbox.debuff):
			Globals.DEBUFFS.SLOW:
				hb_owner.receive_debuff_slow()
			Globals.DEBUFFS.INFEST:
				hb_owner.receive_debuff_infest()
			_:
				pass
	
	if health <= 0:
		die()

func die():
	hb_owner.queue_free.call_deferred()
