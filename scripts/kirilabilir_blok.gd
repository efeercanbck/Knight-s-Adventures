extends Area2D
@onready var kirik_goruntu: Sprite2D = $"../kirik_goruntu"
@onready var surpriz_goruntu: Sprite2D = $"../surpriz_goruntu"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $"."
@onready var cpu_particles: CPUParticles2D = $"../CPUParticles2D"

var is_active = true

func _ready():
	if is_active:
		kirik_goruntu.visible=false

func blogu_kir():
	is_active=false
	surpriz_goruntu.call_deferred("queue_free")
	kirik_goruntu.visible=true
	cpu_particles.emitting=true
	area_2d.call_deferred("queue_free")
	

func _on_body_entered(body: Node2D) -> void:
	collision_shape.set_deferred("disabled",true)
	blogu_kir()
