extends RefCounted
class_name ItemData

@export var item_name: String
@export_multiline() var description: String
@export_range(1, SlotData.MAX_STACK_SIZE) var max_stack_size: int = 1
