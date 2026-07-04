extends CharacterBody2D
@export var damage:float=10
@export var speed:float=10
@export var direction:Vector2=Vector2.ZERO
@export var is_movement_enabled:bool=true
@export var has_charged:bool=false
@onready var animation_tree:AnimationTree=$AnimationTree
@onready var state_machine
func clear():
	queue_free()

func _ready():
	state_machine=animation_tree.get("parameters/playback")
	

func _physics_process(delta):
	velocity=direction*speed
	if not has_charged:
		state_machine.travel("charge")
		pass
	if is_movement_enabled:
		move_and_slide()
		state_machine.travel("damage")
	


func _on_hitbox_particle_is_collided():
	clear()
