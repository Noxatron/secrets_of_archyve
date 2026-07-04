extends Entity

@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D
@onready var player:Node2D=get_tree().get_first_node_in_group("Player")
@onready var raycast:RayCast2D=$Sprite2D/RayCast2D
@onready var raycast_particle:RayCast2D=$Sprite2D/ParticleRayCast
@onready var particle_spawner=$ParticleSpawner
@onready var particle_spawn_place:Node2D=$Sprite2D/ParticleSpawn

var current_dir:Vector2

func _ready():
	movement_enabled=true
	animation_tree=get_node("AnimationTree") as AnimationTree
	if animation_tree==null:
		print_debug("animation tree is null")
	state_machine=animation_tree.get("parameters/playback")
	hp_bar=self.get_node("HPBar") as TextureProgressBar
	init_hp()

func _physics_process(delta):
	animation_tree.advance(delta*animation_speed_scale)
	if not movement_enabled or player==null:
		return
	var dir=to_local(navigation_agent.get_next_path_position()).normalized()
	current_dir=dir
	velocity=dir*movement_speed
	sprite.look_at(player.global_position)
	move_and_slide()
	
	if raycast.is_colliding():
		var coll=raycast.get_collider()
		if coll.name=="MainChar" and coll.has_method("damage"):
			state_machine.travel("attack1")
			return
			
	if raycast_particle.is_colliding():
		var coll=raycast_particle.get_collider()
		if coll.name=="MainChar" and coll.has_method("damage"):
			state_machine.travel("attack2")
 
func create_path():
	if player==null:
		return
	navigation_agent.target_position=player.global_position

func _on_timer_timeout():
	create_path()

func spawn_particle():
	particle_spawner.spawn_particle(current_dir,particle_spawn_place.global_position)
