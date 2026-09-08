extends Node #levelmanager

#save yolu
const SAVE_PATH="user://savegame.json"

const levels: Dictionary = {0:preload("uid://cq7gkxuf754us"),1:preload("uid://bp2dydiqjucw0"),2:preload("uid://drqljt51120x2"),3:preload("uid://bkglc0w5yawlt"),4:preload("uid://cqupcwg7ql5ew")}
var stars: Dictionary = {0:0}
var current_level: int

func _ready():
	load_game()

func load_game():
	#Oyun açıldığı anda bir bak bakalım öyle bir dosya var mı ?
	if not FileAccess.file_exists(SAVE_PATH):
		#Yoksa dosyayı oluştur
		save_game()
	#Dosyayı okuma modunda aç
	var file=FileAccess.open(SAVE_PATH,FileAccess.READ)
	#Bilgisayarın okuyabileceği metin halinde olan dosyayı
	#Godot'un ouyabileceği hale getir
	var parsed= JSON.parse_string(file.get_as_text())
	stars.clear()
	#parsed.stars = {"0": 2, "1": 0} 
	for key in parsed.stars:
		#String key'i int'e çevirme işlemi
		stars[int(key)]=parsed.stars[key]

func save_game():
	var file=FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	var data={"stars":stars}
	file.store_string(JSON.stringify(data))

func is_level_unlocked(index: int) -> bool:
	if index == 0:
		return true
	else:
		#stars[index-1] sıkıntılı bir kullanım otomatikmen null dönderir eğer ki yoksa
		if stars.get(index-1, 0) >= 1:
			return true
		else:
			return false

func go_to_level(index: int):
	current_level = index
	get_tree().change_scene_to_packed(levels[index])


func record_results(index: int, new_stars:int):
	#gamemanager'dan gelen yıldız ve index bilgisine bakar 
	#star dict'ini güncelleme 
	if not stars.has(index):
		stars[index]=new_stars
		save_game()
	if stars[index] < new_stars:
		stars[index]=new_stars
		save_game()
	else:
		pass
	
