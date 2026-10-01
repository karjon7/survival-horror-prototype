extends Node
class_name InventoryComponent

@export var inventory_size: int = 4 : set = _set_inventory_size 

var slot_datas: Array[SlotData] = [SlotData.new()]


func _init() -> void:
	_set_inventory_size(inventory_size)


func has_item(item_data: ItemData) -> bool:
	for slot in slot_datas:
		if slot.item_data == item_data: return true
	
	return false


func add_item(item_data: ItemData, quantity: int = 1) -> int:
	var remaining: int = quantity
	
	#Find slots with same item data first
	for slot in slot_datas:
		if not slot.is_empty() and slot.item_data != item_data: continue
		var spaces_left: int = item_data.max_stack_size - slot.quantity
		var amt_to_add: int = mini(spaces_left, remaining)
		
		slot.quantity += amt_to_add
		remaining -= amt_to_add
		
		if remaining < 1: return remaining
	
	#Find empty slot datas second
	for slot in slot_datas:
		if not slot.is_empty(): continue
		var amt_to_add: int = mini(item_data.max_stack_size, remaining)
		
		slot.item_data = item_data
		slot.quantity = amt_to_add
		remaining -= amt_to_add
		
		if remaining < 1: return remaining
	
	return remaining


func remove_item(item_data: ItemData, quantity: int = 1) -> int:
	var remaining: int = quantity
	var reversed_slot_datas: Array[SlotData] = slot_datas.duplicate(true)
	reversed_slot_datas.reverse()
	
	for slot in reversed_slot_datas:
		if slot.item_data != item_data: continue
		var amt_to_remove: int = mini(slot.quantity, quantity)
		
		slot.quantity -= amt_to_remove
		remaining -= amt_to_remove
		
		if remaining < 1: return remaining
	
	return remaining


func _set_inventory_size(new_value: int) -> void:
	inventory_size = new_value
	slot_datas.resize(inventory_size)
