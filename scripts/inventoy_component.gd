extends Node
class_name InventoryComponent

var slot_datas: Array[SlotData] = []
var inventory_size: int = 4


func add_item(item_data: ItemData, quantity: int = 1) -> int:
	var remaining: int = quantity
	
	#Find slots with same item data first
	for slot in slot_datas:
		if slot.item_data != item_data: continue
		var spaces_left: int = item_data.max_stack_size - slot.quantity
		var amt_to_add: int = mini(spaces_left, remaining)
		
		slot.quantity += amt_to_add
		remaining -= amt_to_add
		
		if remaining == 0: return remaining
	
	#Find empty slot datas second
	for slot in slot_datas:
		if not slot.is_empty(): continue
		var amt_to_add: int = mini(item_data.max_stack_size, remaining)
		
		slot.item_data = item_data
		slot.quantity = amt_to_add
		
		if remaining == 0: return remaining
	
	return remaining
	


func _set_inventory_size(new_value: int) -> void:
	inventory_size = new_value
	slot_datas.resize(inventory_size)
