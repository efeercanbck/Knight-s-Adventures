extends CharacterBody2D
 
enum States {IDLE,RUNNING,JUMPING,FALLING,ROLLING,DYING}
var state = States.IDLE

@onready var Coyote_Timer: Timer = $CoyoteTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var golge_mesafesi: RayCast2D = $golge_mesafesi
@onready var golge: Sprite2D = $golge



var SPEED = 175
const JUMP_VELOCITY = -300.0
const ROLL_SPEED = 200


func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	if animated_sprite.animation == "die":
		Engine.time_scale=1
		get_tree().reload_current_scene()
	if animated_sprite.animation == "roll":
		if is_on_floor():
			state=States.IDLE
		else:
			state=States.FALLING

func _on_timer_timeout() -> void:
	pass
	 
func die():
	if state == States.DYING:
		return
	state = States.DYING
	Engine.time_scale=0.5
	if is_on_floor():
		animated_sprite.play("die")
	else:
		animated_sprite.play("hit")
		$CollisionShape2D.set_deferred("disabled",true)
		await get_tree().create_timer(1).timeout
		Engine.time_scale=1
		get_tree().reload_current_scene()
	
	#eğer ki gamemanager gibi bir şey ölüm sinyalimizi alması gerekiyorsa sinyal yayabiliriz
	
func jump():
	velocity.y = JUMP_VELOCITY
	state = States.JUMPING
	Coyote_Timer.stop()
	
func roll():
	state = States.ROLLING
	var dir = -1.0 if animated_sprite.flip_h else 1.0
	velocity.x = dir * ROLL_SPEED
	animated_sprite.play("roll")
	
	
func _physics_process(delta: float) -> void:

	if (state == States.JUMPING or state==States.FALLING) and is_on_floor():
		state = States.IDLE
		Coyote_Timer.stop()
	
	# Yerçekimi
	if not is_on_floor():
		velocity += get_gravity() * delta
		if state!=States.JUMPING and state!=States.FALLING and state !=States.ROLLING and state!=States.DYING:
			state=States.FALLING
			Coyote_Timer.start()
		
	if state == States.DYING:
		velocity.x = 0
		move_and_slide() 
		return
	
		
	# Zıplama: yerdeyken YA DA coyote süresi içindeyken izin ver
	var can_jump = is_on_floor() or (state== States.FALLING and (Coyote_Timer.is_stopped()==false))
	if Input.is_action_just_pressed("jump") and (state!=States.JUMPING or state==States.ROLLING) and can_jump :
		jump()
	
	#Rolling
	if Input.is_action_just_pressed("roll") and state != States.ROLLING and is_on_floor():
		roll()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Left = -1 , Nothing = 0 , Right = 1
	var direction := Input.get_axis("move_left", "move_right")
	if state != States.ROLLING:
		if direction:
			animated_sprite.flip_h=direction<0
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if state != States.ROLLING:
		if is_on_floor():
			if direction==0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	
	move_and_slide()
	
	if golge_mesafesi.is_colliding():
		golge.visible=true
		golge.global_position.x=global_position.x
		golge.global_position.y=golge_mesafesi.get_collision_point().y
	else:
		golge.visible=false
