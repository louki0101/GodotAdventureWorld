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




func _ready():
	get_node("HUDCanvasLayer").update(health)	
	
	if SceneLoader.spawn_group_name:
		var spawn_target = get_tree().get_nodes_in_group(SceneLoader.spawn_group_name).front()
		position = spawn_target.position



func hurt(amount = 1):
	if is_in_knockback: return
	health -= amount
	get_node("HUDCanvasLayer").update(health)
	
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
	get_node("AnimationPlayer").play("flash")
	vel.y = -(KNOCKBACK*1)
	if get_node("AnimatedSprite").flip_h == true: vel.x = KNOCKBACK
	else: vel.x = -KNOCKBACK
	yield(get_node("AnimationPlayer"), "animation_finished")
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





func _process(delta):	
	#gravity
	if is_in_water:
		vel.y = min(vel.y + (GRAV/5), GRAV_MAX/5)
	else:
		vel.y = min(vel.y + GRAV, GRAV_MAX)
	
	
	if is_passed_out: 
		vel.x = 0
		return
		
	
	
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