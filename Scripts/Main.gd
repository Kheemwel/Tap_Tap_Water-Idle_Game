extends Control


var money := 0.0
var water_drop := 0.01
var water_amount := 0.0
var capacity := 0.5
var auto_drop_rate := 0.0
var auto_sell_rate := 0.0
var sell_rate := 1.0

var sell_upgrade_base_cost := 100
var sell_upgrade_level := 0
var sell_upgrade_cost : float

var water_drop_upgrade_base_cost := 1.0
var water_drop_upgrade_level := 0
var water_drop_upgrade_cost : float

var capacity_upgrade_base_cost := 1.0
var capacity_upgrade_level := 0
var capacity_upgrade_cost : float

var auto_drop_upgrade_base_cost := 3.0
var auto_drop_upgrade_level := 0
var auto_drop_upgrade_cost : float

var auto_sell_upgrade_base_cost := 3.0
var auto_sell_upgrade_level := 0
var auto_sell_upgrade_cost : float

@onready var text_money := $Money
@onready var water := $Water
@onready var container := $Water/Container
@onready var btn_sell_upgrade = $"Container/VBoxContainer/VBoxContainer3/HBoxContainer/Button Sell Upgrade"
@onready var text_convertion_level = $"Container/VBoxContainer/VBoxContainer3/Convertion Rate Text"
@onready var text_water_drop_level = $"Container/VBoxContainer/HBoxContainer/Water Drop Text"
@onready var btn_water_drop_upgrade = $"Container/VBoxContainer/HBoxContainer/Water Drop Upgrade"
@onready var text_capacity_level = $"Container/VBoxContainer/HBoxContainer2/Capacity Text"
@onready var btn_capacity_upgrade = $"Container/VBoxContainer/HBoxContainer2/Capacity Upgrade"
@onready var text_auto_drop_level = $"Container/VBoxContainer/HBoxContainer4/Auto Drop Rate Text"
@onready var btn_auto_drop_upgrade = $"Container/VBoxContainer/HBoxContainer4/Auto Drop Upgrade"
@onready var text_auto_sell_level = $"Container/VBoxContainer/HBoxContainer5/Auto Sell Rate Text"
@onready var btn_auto_sell_upgrade = $"Container/VBoxContainer/HBoxContainer5/Auto Sell Upgrade"

@onready var gamedata = GameData.gamedata

func _ready():
	_load_game_data()
	_offline_progress()
	_calculate_upgrades_cost()
	text_money.text = "Money: " + ("%.2fG" % money)
	water.max_value = capacity
	water.value = water_amount
	_game_data_level_texts()
	_button_upgrade_texts()
	_button_upgrade_states()

func _process(delta):
	_calculate_upgrades_cost()
	queue_redraw()
	_button_upgrade_states()

func _on_draw():
	text_money.text = "Money: " + ("%.2fG" % money)
	container.text = str(water_amount) + "L"
	water.value = water_amount
	_game_data_level_texts()
	_button_upgrade_texts()

func _on_container_pressed():
	_add_water(water_drop)

func _add_water(amount):
	if (water_amount < capacity) and (amount <= capacity):
		water_amount += min(amount, (capacity - water_amount))

func _on_auto_drop_timeout():
	_add_water(auto_drop_rate)
	pass

func _on_button_sell_pressed():
	_sell(water_amount)

func _sell(amount):
	if water_amount >= amount:
		water_amount -= amount
		money += amount * sell_rate
	
func _on_button_sell_upgrade_pressed():
	if money >= sell_upgrade_cost:
		money -= sell_upgrade_cost
		sell_upgrade_level += 1
		sell_rate = 1 + (0.1 * sell_upgrade_level)

func _calculate_upgrades_cost():
	sell_upgrade_cost = (sell_upgrade_base_cost * (sell_upgrade_level + 1.0)) + (sell_upgrade_base_cost * (sell_upgrade_level * 2))
	water_drop_upgrade_cost = (water_drop_upgrade_base_cost  * (water_drop_upgrade_level  + 1.0)) + (water_drop_upgrade_base_cost * (water_drop_upgrade_level * 1.25))
	capacity_upgrade_cost = (capacity_upgrade_base_cost * (capacity_upgrade_level + 1.0)) + (capacity_upgrade_base_cost * (capacity_upgrade_level * 1.5))
	auto_drop_upgrade_cost = (auto_drop_upgrade_base_cost * (auto_drop_upgrade_level + 1.0)) + (auto_drop_upgrade_base_cost * (auto_drop_upgrade_level * 1.15))
	auto_sell_upgrade_cost = (auto_sell_upgrade_base_cost * (auto_sell_upgrade_level + 1.0)) + (auto_sell_upgrade_base_cost * (auto_sell_upgrade_level * 1.25))

func _game_data_level_texts():
	text_convertion_level.text = "Convertion Rate: 1L = " + str(sell_rate) + "G\nLevel: " + str(sell_upgrade_level)
	text_water_drop_level.text = "Water Drop: " + str(water_drop) + "L/Click\nLevel: " + str(water_drop_upgrade_level)
	text_capacity_level.text = "Capacity: " + str(capacity) + "L\nLevel: " + str(capacity_upgrade_level)
	text_auto_drop_level.text = "Auto Drop Rate: " + str(auto_drop_rate) + "L/s\nLevel: " + str(auto_drop_upgrade_level)
	text_auto_sell_level.text = "Auto Sell Rate: " + str(auto_sell_rate) + "L/s\nLevel: " + str(auto_sell_upgrade_level)
	
func _button_upgrade_states():
	btn_sell_upgrade.disabled = money < sell_upgrade_cost
	btn_water_drop_upgrade.disabled = money < water_drop_upgrade_cost or (0.01 + (0.02 * (water_drop_upgrade_level + 1))) > capacity
	btn_capacity_upgrade.disabled = money < capacity_upgrade_cost
	btn_auto_drop_upgrade.disabled = money < auto_drop_upgrade_cost or (0.02 * (auto_drop_upgrade_level + 1)) > capacity
	btn_auto_sell_upgrade.disabled = money < auto_sell_upgrade_cost

func _button_upgrade_texts():
	btn_sell_upgrade.text = "Upgrade\n+0.1L/Level\nCost: " + str(sell_upgrade_cost) + "G"
	btn_water_drop_upgrade.text = "Upgrade\n+0.02L/Level\nCost: " + str(water_drop_upgrade_cost) + "G"
	btn_capacity_upgrade.text = "Upgrade\n+0.5L/Level\nCost: " + str(capacity_upgrade_cost) + "G"
	btn_auto_drop_upgrade.text = "Upgrade\n+0.02L/Level\nCost: " + str(auto_drop_upgrade_cost) + "G"
	btn_auto_sell_upgrade.text = "Upgrade\n+0.02L/Level\nCost: " + str(auto_sell_upgrade_cost) + "G"

func _on_water_drop_upgrade_pressed():
	if money >= water_drop_upgrade_cost:
		money -= water_drop_upgrade_cost
		water_drop_upgrade_level += 1
		water_drop = 0.01 + (0.02 * water_drop_upgrade_level)

func _on_capacity_upgrade_pressed():
	if money >= capacity_upgrade_cost:
		money -= capacity_upgrade_cost
		capacity_upgrade_level += 1
		capacity = 0.5 + ( 0.5 * capacity_upgrade_level)

func _on_auto_drop_upgrade_pressed():
	if money >= auto_drop_upgrade_cost:
		money -= auto_drop_upgrade_cost
		auto_drop_upgrade_level += 1
		auto_drop_rate = 0.02 * auto_drop_upgrade_level

func _on_auto_sell_upgrade_pressed():
	if money >= auto_sell_upgrade_cost:
		money -= auto_sell_upgrade_cost
		auto_sell_upgrade_level += 1
		auto_sell_rate = 0.02 * auto_sell_upgrade_level

func _on_auto_sell_timeout():
	_sell(auto_sell_rate)


func _load_game_data():
	money = gamedata.money
	water_amount = gamedata.water_amount
	sell_upgrade_level = gamedata.sell_upgrade_level
	water_drop_upgrade_level = gamedata.water_drop_upgrade_level
	capacity_upgrade_level = gamedata.capacity_upgrade_level
	auto_drop_upgrade_level = gamedata.auto_drop_upgrade_level
	auto_sell_upgrade_level = gamedata.auto_sell_upgrade_level
	sell_rate = 1 + (0.1 * sell_upgrade_level)
	water_drop = 0.01 + (0.02 * water_drop_upgrade_level)
	capacity = 0.5 + ( 0.5 * capacity_upgrade_level)
	auto_drop_rate = 0.02 * auto_drop_upgrade_level
	auto_sell_rate = 0.02 * auto_sell_upgrade_level

func _offline_progress():
	var lastdatetime = gamedata.lastplaydatetime
	if not lastdatetime == null:
		var currentdatetime = Time.get_datetime_string_from_system()
		var secondsbetween = Time.get_unix_time_from_datetime_string(currentdatetime) - Time.get_unix_time_from_datetime_string(lastdatetime)
		print("seconds away: " + str(secondsbetween))
		if auto_drop_rate < capacity:
			var multiplier = min(auto_drop_rate, auto_sell_rate)
			money += secondsbetween * multiplier		

func _on_tree_exiting():
	gamedata.money = money
	gamedata.water_amount = water_amount
	gamedata.sell_upgrade_level = sell_upgrade_level
	gamedata.water_drop_upgrade_level = water_drop_upgrade_level
	gamedata.capacity_upgrade_level = capacity_upgrade_level
	gamedata.auto_drop_upgrade_level = auto_drop_upgrade_level
	gamedata.auto_sell_upgrade_level = auto_sell_upgrade_level
	gamedata.lastplaydatetime = Time.get_datetime_string_from_system()
	GameData.save_data()
