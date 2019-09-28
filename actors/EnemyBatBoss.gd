extends KinematicBody2D

var MOVE_SPEED = 3
var path_dir_forward = true
var is_hanging = true
var is_passed_out = false
var is_in_knockback = false

var health = 3


func _ready():
	pass


func hurt(amount = 1):
	if is_passed_out == true: return
	health -= amount
	if get_node("HUDCanvasLayer"): get_node("HUDCanvasLayer").update(health)
	
	if health <= 0: pass_out()
	else: knockback()


func knockback():
	is_in_knockback = true
	if get_node("AnimationPlayer"): get_node("AnimationPlayer").play("flash")
	if get_node("AnimationPlayer"): yield(get_node("AnimationPlayer"), "animation_finished")
	is_in_knockback = false


func pass_out():
	print('general passed out.')
	is_passed_out = true
	
	queue_free()





func _on_DamageArea2D_body_entered(body):
	if body.has_method("hurt") and body.is_in_group("player"):
		body.hurt()




func _physics_process(delta):

	
	if is_hanging == false:
		$AnimatedSprite.play("fly")
		
		if path_dir_forward == true:
			get_parent().offset += MOVE_SPEED
			if get_parent().unit_offset >= 1.0:
				is_hanging = true
				path_dir_forward = false
				$HangTimer.start()
		else:
			get_parent().offset -= MOVE_SPEED
			if get_parent().unit_offset <= 0.0:
				is_hanging = true
				path_dir_forward = true
				$HangTimer.start()
	else:
		$AnimatedSprite.play("hang")
		
	
	

func _on_HangTimer_timeout():
	print('hang done')
	is_hanging = false
