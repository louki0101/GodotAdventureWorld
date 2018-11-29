extends KinematicBody2D

var GRAV = 1000
var GRAV_MAX = 20000
var MAX_SPEED = 20000
var ACCELERATION = 500

var UP_VECTOR = Vector2(0,-1)
var JUMP_HEIGHT = -39000

var is_in_water = false
var SWIM_HEIGHT = -8000


var splash_scn = preload("res://sfx/SplashParticles2D.tscn")


var vel = Vector2()

func _ready():
	pass


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





func _process(delta):	
	#gravity
	if is_in_water:
		vel.y = min(vel.y + (GRAV/5), GRAV_MAX/5)
	else:
		vel.y = min(vel.y + GRAV, GRAV_MAX)
	
	
	if is_on_wall():
		vel.x = 0
	
	if is_in_water:
		get_node("AnimatedSprite").play("swim")
		if Input.is_key_pressed(KEY_RIGHT):
			vel.x = min(vel.x + ACCELERATION/2, MAX_SPEED/2)
			get_node("AnimatedSprite").flip_h = false
			
		elif Input.is_key_pressed(KEY_LEFT):
			vel.x = max(vel.x - ACCELERATION/2, -MAX_SPEED/2)
			get_node("AnimatedSprite").flip_h = true
		else:
			vel.x = lerp(vel.x, 0, 0.2)
		
		if Input.is_action_just_pressed("ui_accept"):
				vel.y = SWIM_HEIGHT
	else:
		if Input.is_key_pressed(KEY_RIGHT):
			vel.x = min(vel.x + ACCELERATION, MAX_SPEED)
			get_node("AnimatedSprite").flip_h = false
			if is_on_floor(): get_node("AnimatedSprite").play("walk")
		elif Input.is_key_pressed(KEY_LEFT):
			vel.x = max(vel.x - ACCELERATION, -MAX_SPEED)
			get_node("AnimatedSprite").flip_h = true
			if is_on_floor(): get_node("AnimatedSprite").play("walk")
		else:
			vel.x = lerp(vel.x, 0, 0.1)
			if is_on_floor(): get_node("AnimatedSprite").play("idle")
			
		if Input.is_key_pressed(KEY_DOWN):
			vel.x = 0
			get_node("AnimatedSprite").play("duck")
		
		if is_on_floor():
			vel.y = 10
			
			if Input.is_action_just_pressed("ui_accept"):
				vel.y = JUMP_HEIGHT
				get_node("AnimatedSprite").play("jump")
		else: #in the air...
	#		if vel.y > 0:
	#			get_node("AnimatedSprite").play("fall")
			
			if is_on_ceiling():
				vel.y = 0
	
	

func _physics_process(delta):
	move_and_slide(vel * delta, UP_VECTOR)