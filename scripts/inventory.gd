extends Control

const SLOT_BUTTON = preload("uid://brt7wjfxmx1s3")

@onready var player_inventory: InventoryComponent = %InventoryComponent
@onready var slots_container: GridContainer = %SlotsContainer

@onready var mesh_viewer: MeshViewer = %MeshViewer
@onready var item_name_label: Label = %ItemNameLabel
@onready var item_desc_label: Label = %ItemDescriptionLabel


func _ready() -> void:
	refresh_player_slots()
	clear_slot_selected()


func _process(delta: float) -> void:
	pass


func slot_selected(index: int) -> void:
	var slot: SlotButton = slots_container.get_child(index)
	
	if slot.slot_data.is_empty():
		clear_slot_selected()
		return
	
	mesh_viewer.mesh = slot.slot_data.item_data.mesh
	item_name_label.text = slot.slot_data.item_data.item_name 
	item_desc_label.text = slot.slot_data.item_data.description


func clear_slot_selected() -> void:
	mesh_viewer.mesh = null
	item_name_label.text = "" 
	item_desc_label.text = ""


func refresh_player_slots() -> void:
	if not is_node_ready(): 
		await ready
	
	slots_container.columns = ceili(sqrt(player_inventory.size))
	slots_container.columns = mini(slots_container.columns, 4)
	
	while slots_container.get_child_count() < player_inventory.size:
		var slot_instance: SlotButton = SLOT_BUTTON.instantiate()
		
		slots_container.add_child(slot_instance)
	
	for slot: SlotButton in slots_container.get_children():
		if slot.get_index() + 1 > player_inventory.size: 
			slot.queue_free()
			continue
		
		var current_slot_data: SlotData = player_inventory.slot_datas[slot.get_index()]
		
		slot.slot_data = current_slot_data
		if slot.pressed.get_connections().is_empty():
			slot.pressed.connect(slot_selected.bind(slot.get_index()))


func _on_visibility_changed() -> void:
	if not is_node_ready(): 
		await ready
	
	clear_slot_selected()
