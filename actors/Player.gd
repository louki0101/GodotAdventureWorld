extends "res://actors/Actor.gd"


var inventory = []
var has_jetpack = false

const JETPACK_MAX_FUEL = 10
const JETPACK_BURN_RATE = 5
const JETPACK_THRUST = 50
const JETPACK_REFILL_RATE = 2
const JETPACK_SPRITE_OFFSET = 16

var jetpack_fuel = JETPACK_MAX_FUEL
var jetpack_on = false
var jump_released_in_air = false


var has_boomstick = false






func _ready():
	get_node("HUDCanvasLayer").update(health)
	get_node("HUDCanvasLayer").update_inventory(inventory)
	
	if SceneLoader.spawn_group_name:
		var spawn_target = get_tree().get_nodes_in_group(SceneLoader.spawn_group_name).front()
		position = spawn_target.position
	
	toggle_light(false)
	$Pickaxe.hide()
	
	$JetpackSprite.hide()
	$HUDCanvasLayer/JetpackFuelProgress.max_value = JETPACK_MAX_FUEL
	$HUDCanvasLayer/JetpackFuelProgress.min_value = 0
	$HUDCanvasLayer/JetpackFuelProgress.hide()
	$JetpackSprite/JetpackParticles2D.emitting = false
	$JetpackSprite/JetpackParticles2D2.emitting = false
	
	
	$Boomstick.hide()
	
	
	#test inventory items
	#add_item('coin')
	#add_item('torch')
	




func teleport_to(target_pos):
	get_node("AnimationPlayer").play("FadeOut")
	yield(get_node("AnimationPlayer"), "animation_finished")
	position = target_pos
	get_node("AnimationPlayer").play("FadeIn")


func add_item(item_to_add):
	inventory.append(item_to_add)
	$HUDCanvasLayer.update_inventory(inventory)
	if item_to_add == 'jetpack':
		has_jetpack = true
		$JetpackSprite.show()
	if item_to_add == 'boomstick':
		has_boomstick = true
		$Boomstick.show()

func remove_item(item_to_remove):
	inventory.erase(item_to_remove)
	$HUDCanvasLayer.update_inventory(inventory)




onready var feet_rays = get_node("FeetRays")

func check_jump_attack():
	for ray in feet_rays.get_children():
		if ray is RayCast2D and ray.is_colliding():
			print('jump attack!')
			player_jump()
			var target = ray.get_collider()
			if target and target.has_method("hurt"): target.hurt()
			return


func player_jump():
	vel.y = JUMP_HEIGHT
	get_node("AnimatedSprite").play("jump")


func toggle_light(turn_on):	
	if turn_on and inventory.has('torch'): $Torch.show()
	else: $Torch.hide()


func swing_pickaxe():
	if inventory.has('pickaxe'):
		$Pickaxe.show()
		
		#figure out if we hit a block, and break it
		var world_pos = $Pickaxe/Position2D.global_position
		var map = get_node("/root/Level_1/ForegroundTileMap")
		var map_pos = map.world_to_map(world_pos)
		#print(map_pos)
		var tile_index = map.get_cellv(map_pos)
		if tile_index == 7:
			#print(tile_index)
			map.set_cellv(map_pos, -1)#clear tile
		
		yield(get_tree().create_timer(.5), "timeout")
		$Pickaxe.hide()





func actor_behavior(delta):
	jetpack_on = false
	if has_jetpack:
		$HUDCanvasLayer/JetpackFuelProgress.value = jetpack_fuel
		$HUDCanvasLayer/JetpackFuelProgress.show()
	
	
	
	#gravity
	if is_in_water:
		vel.y = min(vel.y + (GRAV/5), GRAV_MAX/5)
	else:
		vel.y = min(vel.y + GRAV, GRAV_MAX)
	
	
	if is_passed_out: 
		vel.x = 0
		return
	
	
	if Input.is_action_just_pressed('use_pickaxe'):
		swing_pickaxe()
	if get_node("AnimatedSprite").flip_h == true:
		$Pickaxe.scale.x = -1
	else:
		$Pickaxe.scale.x = 1
	
	
	if has_boomstick:
		if get_node("AnimatedSprite").flip_h == true:
			$Boomstick.scale.x = -1
		else:
			$Boomstick.scale.x = 1
	
	

	
	
	if is_on_wall():
		vel.x = 0
	
	if is_in_water:
		if has_jetpack:
			$HUDCanvasLayer/JetpackFuelProgress.hide()
				
		
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
		
		#if has_jetpack:
			
		
		
		if Input.is_key_pressed(KEY_RIGHT):
			vel.x = min(vel.x + ACCELERATION, MAX_SPEED)
			get_node("AnimatedSprite").flip_h = false
			if is_on_floor(): get_node("AnimatedSprite").play("walk")
			$JetpackSprite.position.x = -JETPACK_SPRITE_OFFSET
		elif Input.is_key_pressed(KEY_LEFT):
			vel.x = max(vel.x - ACCELERATION, -MAX_SPEED)
			get_node("AnimatedSprite").flip_h = true
			if is_on_floor(): get_node("AnimatedSprite").play("walk")
			$JetpackSprite.position.x = JETPACK_SPRITE_OFFSET
		else:
			vel.x = lerp(vel.x, 0, 0.1)
			if is_on_floor(): get_node("AnimatedSprite").play("idle")
			
		if Input.is_key_pressed(KEY_DOWN):
			vel.x = 0
			get_node("AnimatedSprite").play("duck")
		
		if is_on_floor():
			vel.y = 10
			jump_released_in_air = false
			
			if has_jetpack and jetpack_fuel < JETPACK_MAX_FUEL:
				jetpack_fuel = jetpack_fuel + (delta*JETPACK_REFILL_RATE)
			
			if Input.is_action_just_pressed("ui_accept"):
				player_jump()
		else: #in the air...
			check_jump_attack()
	#		if vel.y > 0:
	#			get_node("AnimatedSprite").play("fall
			if Input.is_action_just_released("ui_accept"): jump_released_in_air = true
				
			if has_jetpack and jump_released_in_air and Input.is_action_pressed("ui_accept") and jetpack_fuel > 0:
				vel.y = vel.y -JETPACK_THRUST
				jetpack_fuel = jetpack_fuel - (delta*JETPACK_BURN_RATE)
				get_node("AnimatedSprite").play("jump")
				if $JetpackAudio.playing == false: $JetpackAudio.play()
				$JetpackSprite/JetpackParticles2D.emitting = true
				$JetpackSprite/JetpackParticles2D2.emitting = true
				jetpack_on = true
			
			
			if is_on_ceiling():
				vel.y = 0
	
	#turn jetpack audio off when its not running
	if jetpack_on == false and $JetpackAudio.playing == true:
		$JetpackAudio.stop()
		$JetpackSprite/JetpackParticles2D.emitting = false
		$JetpackSprite/JetpackParticles2D2.emitting = false



func pass_out():
	print('player passed out.')
	is_passed_out = true
	get_node("AnimationPlayer").play("pass_out")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_node("AnimationPlayer").play("game_over")
	yield(get_node("AnimationPlayer"), "animation_finished")
	SceneLoader.load_scene("res://main_menu.tscn", null)