class_name Entity
extends CharacterBody2D

## This is to prevent oneshots if enemies land multiple attacks at once
@export var invulnerability_window=0.5
var invulnerability_window_active=false
@export var enable_invulnerability_window=false
## Movement speed of the entity.[br]
## For slower entities it is recommended to keep movement speed at 100.[br]
## The player character has its movement speed set at 200.
@export var movement_speed:float=100
@export var hp:float=100
@export var max_hp:float=100

## HP regeneration per second
@export var hp_regeneration:float=1

@export var mana:float=100
@export var max_mana:float=100

## Mana regeneration per second
@export var mana_regeneration:float=1

@export var dash_speed:float=800
@export var dash_duration:float=0.1

@export var movement_enabled:bool = true
		
@export var can_be_damaged:bool=true

@export var single_coin_value:int=5
@export var coin_drop_amount:int=1

@onready var COIN_SCENE=preload("res://Scenes/Drops/Coin.tscn")

@onready var animation_tree:AnimationTree
@export var animation_speed_scale=1
@onready var state_machine

## determines if the entity is dashing at current time.
var is_dashing:bool=false

## determines if the entity can dash.
var can_dash:bool=true

@onready var sprite:Sprite2D=$Sprite2D
var hp_bar:TextureProgressBar
var mana_bar:TextureProgressBar

func _process(delta):
	use_mana(-(mana_regeneration*delta))
	damage(-(hp_regeneration*delta))

func shock(shock_duration:float)->void:
	if !can_be_damaged:
		return
	#movement_enabled=false
	await get_tree().create_timer(shock_duration,true,false,true).timeout
	movement_enabled=true

func damage(damage_value:float)->void:
	if (!can_be_damaged or (invulnerability_window_active and enable_invulnerability_window)) and damage_value>0:
		return
	hp-=damage_value
	if hp<=0:
		die()
	if hp_bar!=null:
		hp_bar.value=hp
	if damage_value>0:
		invulnerability_window_active=true
		await get_tree().create_timer(invulnerability_window,true,false,true).timeout
		invulnerability_window_active=false
	

func use_mana(mana_value:float)->bool:
	if mana_bar==null:
		return false
	if mana-mana_value<=0:
		return false
	mana-=mana_value
	if mana_value>0:
		print_debug(mana_value)
	if mana_bar!=null:
		mana_bar.value=mana
	return true

func drop_coins():
	var coins=[]
	var root=get_tree().root
	for i in range(coin_drop_amount):
		var coin=COIN_SCENE.instantiate()
		coin.get_node("CoinArea").coin_value=single_coin_value
		coins.append(coin)
		coins[i].global_position = global_position
		root.add_child(coins[i])

	

# removes the entity from the scene
func die()->void:
	drop_coins()
	queue_free()

func init_hp()->void:
	if hp_bar==null:
		print("HP bar was not found on "+self.name)
		return
	hp_bar.max_value=max_hp
	hp_bar.value=hp

func init_mana()->void:
	if mana_bar==null:
		print("Mana bar was not found on "+self.name)
		return
	mana_bar.max_value=max_mana
	mana_bar.value=mana
