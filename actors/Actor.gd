extends KinematicBody2D


#movement
var vel = Vector2()
var GRAV = 1000
var GRAV_MAX = 20000
var MAX_SPEED = 20000
var ACCELERATION = 500

var UP_VECTOR = Vector2(0,-1)
var JUMP_HEIGHT = -39000



#water
var is_in_water = false
var SWIM_HEIGHT = -8000
var splash_scn = preload("res://sfx/SplashParticles2D.tscn")


#health
var health = 2
var KNOCKBACK = 8000
var is_in_knockback = false
var is_passed_out = false





onready var sprite = get_node("AnimatedSprite")


func _ready():
	print("I am an Actor! My name is: " + str(name) )
	





func hurt(amount = 1):
	if is_in_knockback: return
	health -= amount
	if get_node("HUDCanvasLayer"): get_node("HUDCanvasLayer").update(health)
	
	if health <= 0: pass_out()
	else: knockback()


func pass_out():
	print('player passed out.')
	is_passed_out = true
	get_node("AnimationPlayer").play("pass_out")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_node("AnimationPlayer").play("game_over")
	yield(get_node("AnimationPlayer"), "animation_finished")
	SceneLoader.load_scene("res://main_menu.tscn", null)
	

func knockback():
	is_in_knockback = true
	if get_node("AnimationPlayer"): get_node("AnimationPlayer").play("flash")
	vel.y = -(KNOCKBACK*1)
	if get_node("AnimatedSprite").flip_h == true: vel.x = KNOCKBACK
	else: vel.x = -KNOCKBACK
	if get_node("AnimationPlayer"): yield(get_node("AnimationPlayer"), "animation_finished")
	is_in_knockback = false



func entered_water():
	is_in_water = true
	var splash = splash_scn.instance()
	splash.one_shot = true
	splash.position = get_node("SplashPosition2D").position
	add_child(splash)
	get_node("SplashAudioStreamPlayer2D").play()


func exited_water():
	is_in_water = false
	var splash = splash_scn.instance()
	splash.one_shot = true
	splash.position = get_node("SplashPosition2D").position
	add_child(splash)
	get_node("SplashAudioStreamPlayer2D").play()





func actor_behavior(delta):
	pass

func _physics_process(delta):
	
	actor_behavior(delta)
	
	move_and_slide(vel * delta, UP_VECTOR)
	