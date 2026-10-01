extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 99
const TEST_ITEM: ItemData = preload("uid://dpmf8r2tqgqav")

var item_data: ItemData : set = _set_item_data
var quantity: int = 0 : set = _set_quantity


func _init(item: ItemData = null) -> void:
	item_data = item


func is_empty() -> bool:
	return item_data == null or quantity == 0


func _set_item_data(new_item_data: ItemData) -> void:
	item_data = new_item_data
	quantity = 0
	


func _set_quantity(new_value: int) -> void:
	quantity = new_value
	
	if not quantity > 0 and item_data: 
		item_data = null
		quantity = 0
