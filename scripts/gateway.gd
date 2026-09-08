extends Area2D #gateaway

@onready var game_manager: Node = %GameManager
#Buradaki neredeyse tüm fonksiyonlar silinecek ve gateaway'in tek amacı sinyal yayınlamak olacak
#Eğer ki area2d'ye karakter girerse ve o karakter player grubundaysa karakteri dondor ve sinyal yayınla
#Sinyali game_manager yakalayacak ve ekrana kaç yıldız aldığını gösteren fonksiyonu oynatacak
#O fonksiyon bittikten sonra ekranı karatıcak ve yeni sahneye geçirecek
#Buradaki kapının tek amacı sadece karakter kapıya girdi mi ? Girmedi mi ?

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.set_physics_process(false)
		game_manager.results()
