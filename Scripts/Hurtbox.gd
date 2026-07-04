class_name Hurtbox
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.area_entered.connect(_on_area_entered)
	print("connected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_entered(hitbox):
	if hitbox.name=="Hurtbox" or !owner.has_method("damage"):
		return
	print(owner.name)
	print(hitbox.damage_effect)
	owner.damage(hitbox.damage)
	if hitbox.damage_effect==1:
		owner.shock(hitbox.shock_duration)
	if hitbox.has_method("clear_on_collision"):
		print_debug("clearing on collision")
		hitbox.clear_on_collision()
