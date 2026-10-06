extends Node
class_name InventoryComponent

signal inventory_updated

@export var size: int = 3 : set = _set_size 
@export var slot_datas: Array[SlotData] = []


func _ready() -> void:
	_set_size(size)
	inventory_updated.emit()


func has_item(item_data: ItemData) -> bool:
	for slot in slot_datas:
		if slot.item_data == item_data: return true
	
	return false


func add_item(item_data: ItemData, quantity: int = 1) -> int:
	var remaining: int = quantity
	
	#Find slots with same item data first
	for slot in slot_datas:
		if slot.is_empty(): continue 
		if slot.item_data != item_data: continue
		
		var spaces_left: int = item_data.max_stack_size - slot.quantity
		var amt_to_add: int = mini(spaces_left, remaining)
		
		if amt_to_add == 0: continue
		
		slot.quantity += amt_to_add
		remaining -= amt_to_add
		inventory_updated.emit()
		
		if not remaining > 0: break
	
	#Find empty slot datas second
	for slot in slot_datas:
		if not slot.is_empty(): continue
		var amt_to_add: int = mini(item_data.max_stack_size, remaining)
		
		slot.item_data = item_data
		slot.quantity = amt_to_add
		remaining -= amt_to_add
		inventory_updated.emit()
		
		if not remaining > 0: break
	
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
		inventory_updated.emit()
		
		if not remaining > 0: break
	
	return remaining


func _set_size(new_value: int) -> void:
	size = new_value
	slot_datas.resize(size)
	
	for index in slot_datas.size():
		if not slot_datas.get(index): slot_datas.set(index, SlotData.new())
	
	inventory_updated.emit()
