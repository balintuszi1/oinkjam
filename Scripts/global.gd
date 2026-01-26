extends Node

### SIGNALS ###
#Desk
signal is_player_working(work)
signal add_money(amount)
#Printer
signal give_documents(amount)
#Elevator
signal is_player_in_elevator(value)
signal move_floors(amount)

### VARIABLES ###
var player = null
var active_elevator = null

const MAX_FLOORS = 12

var acorns = 0
var current_floor = 1
var ground_height = 230
var window_height = 270
#var is_desk_active = true
#var is_printer_active = true
var printer_requires_paper = true
var printer_requires_blue = false
var printer_requires_magenta = false
var printer_requires_yellow	 = false
var printer_requires_black = false

func get_floor_y():
	return ground_height-((current_floor-1)*window_height)
