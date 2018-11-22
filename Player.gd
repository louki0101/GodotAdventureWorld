extends KinematicBody2D

var GRAV = 1000
var MAX_SPEED = 20000
var ACCELERATION = 500

var UP_VECTOR = Vector2(0,-1)
var JUMP_HEIGHT = -39000


var vel = Vector2()

func _ready():
	pass



func _process(delta):	
	#gravity
	vel.y += GRAV
	
	if is_on_wall():
		vel.x = 0
	
	
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
			
			
		
	else:
		#in the air...
#		if vel.y > 0:
#			get_node("AnimatedSprite").play("fall")
		
		if is_on_ceiling():
			vel.y = 0
	

func _physics_process(delta):
	move_and_slide(vel * delta, UP_VECTOR)