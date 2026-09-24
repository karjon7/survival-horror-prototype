extends CanvasLayer


enum SCREENS {
	NONE,
	INVENTORY
}

var current_screen: SCREENS: set = _set_current_screen

@onready var inventory: Control = %Inventory


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_screen = SCREENS.NONE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"): 
		toggle_inventory()


func toggle_inventory() -> void:
	if current_screen == SCREENS.INVENTORY:
		current_screen = SCREENS.NONE
	else:
		current_screen = SCREENS.INVENTORY


func _set_current_screen(new_screen: SCREENS) -> void:
	current_screen = new_screen
	
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	inventory.hide()
	
	match current_screen:
		SCREENS.NONE:
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		SCREENS.INVENTORY:
			inventory.show()
