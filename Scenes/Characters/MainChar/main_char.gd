extends Entity

enum State { MOVE, ATTACK, DASH }
var current_state: State = State.MOVE

@export var ultimate_attack_mana_cost:float=50
@export var coins:int=0
@onready var particle_spawner:ParticleSpawner=$ParticleSpawner


func _ready():
	animation_tree=get_node("AnimationTree") as AnimationTree
	state_machine=animation_tree.get("parameters/playback")
	get_tree().call_group("skeletons","set_player",self)
	hp_bar=self.get_node("HPBar") as TextureProgressBar
	mana_bar=self.get_node("ManaBar") as TextureProgressBar
	print_debug("test")
	init_hp()
	init_mana()
func dash():
	if can_dash and Input.is_action_just_pressed("dash"):
		can_dash=false
		is_dashing=true
		can_be_damaged=false
		await get_tree().create_timer(dash_duration).timeout
		is_dashing=false
		can_dash=true
		can_be_damaged=true

func collect_coin(coin_value):
	coins+=coin_value
	print(coins)

func _physics_process(delta):
	animation_tree.advance(delta*animation_speed_scale)
	if not movement_enabled:
		return
	dash()
	var input_direction=Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("top")
	)
	if Input.is_action_just_pressed("attack1"):
		state_machine.travel("attack1")
	if Input.is_action_just_pressed("attack2"):
		state_machine.travel("attack2")
	if Input.is_action_just_pressed("parry"):
		state_machine.travel("parry")
	if Input.is_action_just_pressed("attack_ultimate"):
		if use_mana(ultimate_attack_mana_cost):
			state_machine.travel("attack_ultimate")
		
	var speed=dash_speed if is_dashing else movement_speed
	velocity=input_direction*speed
	var look_vector=get_global_mouse_position()-global_position
	sprite.global_rotation=atan2(look_vector.y,look_vector.x)
	
	move_and_slide()

func spawn_particle():
	particle_spawner.spawn_particle2(sprite.global_rotation,sprite.global_position)
