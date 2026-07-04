class_name ParticleSpawner
extends Node2D

@export var particle_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_particle(direction:Vector2,global_position:Vector2):
	var new_particle_instance=particle_scene.instantiate()
	add_child(new_particle_instance)
	new_particle_instance.global_position=global_position
	new_particle_instance.launch_projectile(direction)

func spawn_particle2(global_rotation:float,global_position:Vector2):
	var new_particle_instance=particle_scene.instantiate()
	add_child(new_particle_instance)
	new_particle_instance.global_position=global_position
	new_particle_instance.global_rotation=global_rotation
