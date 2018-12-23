extends "res://actors/Actor.gd"




func _ready():
	get_node("HUDCanvasLayer").update(health)	
	
	if SceneLoader.spawn_group_name:
		var spawn_target = get_tree().get_nodes_in_group(SceneLoader.spawn_group_name).front()
		position = spawn_target.position






func actor_behavior(delta):
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
	
	