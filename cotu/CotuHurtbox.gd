class_name CotuHurtbox
extends Hurtbox

var original_max_health := 100.0

@export var base_recovery_rate := .25
@export var fast_recovery_rate := .5
var recovery_rate := .5
@export var recovery_delay := 1.0 # Time after getting hit before recovery begins
var recovery_delay_remaining := 1.0
@export var recovery_disabled := false # Exported so that it can be set via anim keyframes
var recovery_active := false # This really means "Cotu is trying to recover". If recovery_disabled, recovery_active does not recover stability

var damage_indicator_value := 100.0

@export var destab_invin_time := 1.0

var frostbite_buildup := 0.0 # Once this number hits the current frostbite stage threshold, frostbite stage increments
var current_frostbite_threshold := 15.0 # frostbite buildup needed to progress frostbite stage
var current_frostbite_stage := 0 # 0 = no frostbite, 1-3 = frostbite. This is the index into the frostbite_stage_thresholds list
@export var frostbite_stage_thresholds := [ # Each attack will deal around 10 frostbite buildup on average on a clean direct hit
	15.0,
	30.0,
	30.0,
]

# When Cotu gets grabbed, his position is set to the hitbox's parent
@export var opponent_grab_hitboxes := []

func _ready():
	super()
	original_max_health = Globals.cotu_max_health
	if hb_owner.has_method("has_sigil") and hb_owner.has_sigil(Globals.SIGILS.MAX_STABILITY_BOOST):
		# Assuming you have a max_stability variable in Globals or locally
		original_max_health *= 1.2
	max_health = original_max_health
	base_recovery_rate = Globals.cotu_base_regen_rate
	fast_recovery_rate = Globals.cotu_fast_regen_rate
	recovery_delay = Globals.cotu_regen_delay
	destab_invin_time = Globals.cotu_destabilize_invincibility_time
	
	damage_indicator_value = max_health
	Globals.stabilize.connect(on_stabilize)
	
	current_frostbite_threshold = frostbite_stage_thresholds[current_frostbite_stage]

func on_stabilize():
	max_health = original_max_health
	health = original_max_health
	damage_indicator_value = max_health

func reset_recovery_delay():
	recovery_delay_remaining = recovery_delay
	recovery_active = false

func on_hit(hitbox):
	if hitbox.name in opponent_grab_hitboxes:
		hb_owner.grab_pos_node = hitbox.grab_pos_node
		hb_owner.start_grab_anim(hitbox.name)
	else:
		super(hitbox)

func receive_hit(hitbox, hitter):
	if recovery_active:
		damage_indicator_value = health
	reset_recovery_delay()
	
	frostbite_buildup += hitbox.frostbite_buildup
	if frostbite_buildup > current_frostbite_threshold:
		if current_frostbite_stage < frostbite_stage_thresholds.size():
			current_frostbite_stage += 1
			current_frostbite_threshold = frostbite_stage_thresholds[current_frostbite_stage]
		frostbite_buildup = 0
	
	super(hitbox, hitter)

func self_hit(damage: float):
	if recovery_active:
		damage_indicator_value = health
	reset_recovery_delay()
	health -= damage
	if health <= 0:
		die()

func self_heal(heal: float):
	health += heal
	if health >= max_health:
		health = max_health

func set_fast_recovery_rate(is_fast: bool):
	if is_fast:
		recovery_rate = fast_recovery_rate
	else:
		recovery_rate = base_recovery_rate

func _physics_process(delta):
	recovery_delay_remaining -= delta
	if recovery_delay_remaining < 0:
		recovery_active = true
	if not recovery_disabled and recovery_active and health < max_health:
		if hb_owner.active_debuffs[Globals.DEBUFFS.INFEST] > 0:
			if hb_owner.has_method("has_sigil") and hb_owner.has_sigil(Globals.SIGILS.REGENERATOR):
				health += recovery_rate * hb_owner.infest_stability_regen_reduction * hb_owner.sigil_regenerator_stability_regen_multiplier
			else:
				health += recovery_rate * hb_owner.infest_stability_regen_reduction
		else:
			health += recovery_rate
		damage_indicator_value -= recovery_rate

func die():
	# AKA destabilize
	if hb_owner.destabilized:
		Engine.time_scale = .1
		hb_owner.get_node("DeathParticles/GPUParticles3D").emitting = true
		await get_tree().create_timer(.5).timeout
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://levels/hub/hub_viewcontrol.tscn")
		return
	Globals.destabilize.emit()
	set_invincibility(true)
	health = 1
	max_health = 1
	await get_tree().create_timer(destab_invin_time).timeout
	set_invincibility(false)
