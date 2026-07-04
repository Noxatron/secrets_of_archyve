extends Area2D
enum STATUS_EFFECT{NONE,SHOCK}
@export var damage:float=10
@export var shock_duration:float=0.5
@export var damage_effect:STATUS_EFFECT=STATUS_EFFECT.NONE
@onready var collision_shape:CollisionShape2D=$CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape.disabled=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_collision_enabled(enabled:bool):
	collision_shape.disabled=!enabled
