extends CharacterBody2D

var player_ref:Node2D=null
var last_seen_position:Vector2
var state=null
var current_target:Vector2=Vector2.ZERO

@onready var exclamation_mark: Sprite2D = $exclamation_mark
@onready var question_mark: Sprite2D = $question_mark
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_right: RayCast2D = $RayCast2D
@onready var ray_cast_left: RayCast2D = $RayCast2D2
@onready var timer: Timer = $Timer
#Inspector panelinde Canvas>Visibility>Top Level değeri açık
#Bu değer parent'ın child'ı olan bu ikisinin parent ile yürümemesini sağlıyor
#Yani böylelikle bu noktalar bir child oluyor ve kendilerine ait Z indeksleri ve pozisyonları oluyor
#Diğer türlü olsaydı markerların pozisyonu canavar ileri gidince ileri,geri gidince geri giderdi
#Canavar asla marker'a ulaşamazdı
#Alien sahnesini iki marker olmadan açamıyorsun yoksa değerleri null olduğu içn hata veriyor
@onready var marker_a: Marker2D = $Marker_A
@onready var marker_b: Marker2D = $Marker_B
@onready var killzone: Area2D = $Killzone



var SPEED = 105
const JUMP_VELOCITY = -250

func set_active(active:bool) -> void:
	set_physics_process(active)
	killzone.monitoring=active

func _ready() -> void:
	set_active(visible)
	enter_patrol()

func _on_aggro_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_ref=body
		state="CHASE"
		timer.stop()
		exclamation_mark.visible=true
		question_mark.visible=false


func _on_aggro_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		last_seen_position=player_ref.global_position
		player_ref=null
		state="RETURN"
		exclamation_mark.visible=false
		question_mark.visible=true

func _on_timer_timeout() -> void:
	if player_ref==null:
		enter_patrol()


func _physics_process(delta: float) -> void:
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#player'ın koordinatları
	if state=="CHASE":
		var player_ref_coordinates=player_ref.global_position
		var direction = sign(player_ref.global_position.x-global_position.x)
		velocity.x = direction * SPEED
	elif state=="RETURN":
		var direction = sign(last_seen_position.x-global_position.x)
		velocity.x=direction * SPEED
		# Çıkan değerin pozitif halini alıyor
		if abs(global_position.x-last_seen_position.x) < 5:
			velocity.x=move_toward(velocity.x,0,SPEED)
			if timer.is_stopped():
				timer.start()
		else:
			pass
	elif state=="PATROL":
		#sign eklememizin nedeni de bize -1,0,1 değerlerini döndermesi
		var direction=sign(current_target.x-global_position.x)
		velocity.x=direction*SPEED
		if abs(global_position.x-current_target.x) < 5:
			if current_target == marker_a.global_position:
				current_target=marker_b.global_position
			else:
				current_target=marker_a.global_position
			
	# Handle jump
	if (ray_cast_right.is_colliding() or ray_cast_left.is_colliding()) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if velocity.x!=0:
		#Buradaki karşılaştırma ile birlikte true ya da false değeri dönüyor
		animated_sprite_2d.flip_h=velocity.x<0
	
	move_and_slide()

func enter_patrol():
	state="PATROL"
	question_mark.visible=false
	#Patrol'a geçtiğinde en yakın mesafeye bakıp A ya yada B ye gitmeli 
	if global_position.distance_to(marker_a.global_position) < global_position.distance_to(marker_b.global_position):
		current_target=marker_a.global_position
	else:
		current_target=marker_b.global_position
	
