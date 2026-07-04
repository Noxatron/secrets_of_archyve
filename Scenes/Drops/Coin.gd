extends Area2D
@export var coin_value=5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	var parent=area.get_parent()
	if parent.name!="MainChar":
		return
	if parent.has_method("collect_coin"):
		parent.collect_coin(coin_value)
		queue_free()
