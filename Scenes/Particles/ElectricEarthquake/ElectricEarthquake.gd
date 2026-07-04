extends CharacterBody2D


@export var movement_speed = 100
@export var direction=Vector2(0,0)
@export var can_move=false
@onready var lifespan_timer:Timer=$Lifespan
@export var self_destruct_on_timer_elapsed:bool=true

@onready var animation_tree:AnimationTree
@export var animation_speed_scale=1

func _ready():
	animation_tree=get_node("AnimationTree") as AnimationTree

func _physics_process(delta):
	animation_tree.advance(delta*animation_speed_scale)
	if can_move:
		velocity=direction*movement_speed
		move_and_slide()

func launch_projectile(dir:Vector2):
	direction=dir
	lifespan_timer.start()


func _on_weapon_destroy_self():
	queue_free()


func _on_lifespan_timeout():
	if self_destruct_on_timer_elapsed:
		queue_free()
