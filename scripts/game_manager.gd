extends Node #game_manager

@export var next_scene:PackedScene

var coins = 0
@onready var coin_label: Label = %CoinsLabel
var total_coins = 0
var my_current_level = 0
const pop_up_scene = preload("uid://d2kv7hg2h8g7v")
const level_closing = preload("uid://bn8qdjww70oyy")

#Bir fonksiyon yapacağız ve o fonksiyon return index ve 1,2,3 döndürecek
#1 coin toplamak 1 yıldız
#tüm coinlerin %60 ı 2 yıldız Total_coins'in %60 ını bulucaz = 60/(100*coin sayısı) ve toplanan coin ona eşitse 2 döndürecez 
#tüm coinler 3 yıldız 

func _ready():
	total_coins = get_tree().get_nodes_in_group("coins").size()
	my_current_level= LevelManager.current_level

func add_point():
	coins += 1
	coin_label.text = "Coins: " + str(coins) + " / " + str(total_coins)
	
#Bufonksiyonun muhabbeti şu
#Sinyali game_manager yakalayacak ve ekrana kaç yıldız aldığını gösteren fonksiyonu oynatacak
#O fonksiyon bittikten sonra ekranı karatıcak ve yeni sahneye geçirecek
func results():
	var star=0
	if coins == 0:
		print("Başaramadın")
		
	elif coins >= 1 and coins*100 < (60*total_coins):
		star=1
		print("Şu kadar yıldız kazandın: "+str(star))
		#Pop-up yıldız ekranı
		LevelManager.record_results(my_current_level,star)
		#ekranı karart -> Animasyon bitince hub'a gönder
	elif coins*100 >= (60*total_coins) and coins < total_coins:
		star=2
		print("Şu kadar yıldız kazandın: "+str(star))
		LevelManager.record_results(my_current_level,star)
	elif coins==total_coins:
		star=3
		print("Şu kadar yıldız kazandın: "+str(star))
		LevelManager.record_results(my_current_level,star)
		
	var pop_up_instantiate = pop_up_scene.instantiate()
	add_child(pop_up_instantiate)
	pop_up_instantiate.show_results(star)
	
	pop_up_instantiate.closed.connect(_on_popup_closed)
	
func _on_popup_closed():
	var level_closing_instantiate = level_closing.instantiate()
	add_child(level_closing_instantiate)
	var level_closing_animationplayer=level_closing_instantiate.get_node("AnimationPlayer")
	level_closing_animationplayer.animation_finished.connect(_on_animation_finished)
	level_closing_animationplayer.play("level_closing")

func _on_animation_finished(anim_name: StringName):
	if anim_name == "level_closing":
		get_tree().change_scene_to_packed(next_scene)
