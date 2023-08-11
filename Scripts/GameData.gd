extends Node

const SAVE_FILE = "user://gamedata.save"
var gamedata = {}

func _ready() -> void:
	load_data()

func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(gamedata)
	file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		gamedata = {
			"money": 0.0,
			"water_amount": 0.0,
			"sell_upgrade_level": 0,
			"water_drop_upgrade_level": 0,
			"capacity_upgrade_level": 0,
			"auto_drop_upgrade_level": 0,
			"auto_sell_upgrade_level": 0,
			"lastplaydatetime": null
		}
		save_data()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	gamedata = file.get_var()
	file.close()
	
