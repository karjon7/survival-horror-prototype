extends Button
class_name SlotButton

var slot_data: SlotData : set = _set_slot_data

@onready var quantity_label: Label = %QuantityLabel
@onready var mesh_viewer: MeshViewer = %MeshViewer
@onready var highlight_overlay: Panel = %HighlightOverlay
@onready var lighten_overlay: Panel = %LightenOverlay
@onready var darken_overlay: Panel = %DarkenOverlay


func update_slot() -> void:
	if not slot_data or slot_data.is_empty():
		quantity_label.visible = false
		mesh_viewer.mesh = null
		return
	
	mesh_viewer.mesh = slot_data.item_data.mesh
	quantity_label.text = "x%s" % slot_data.quantity 
	quantity_label.visible = slot_data.quantity != 1


func highlight() -> void:
	highlight_overlay.show()


func unhighlight() -> void:
	highlight_overlay.hide()


func darken() -> void:
	darken_overlay.show()


func undarken() -> void:
	darken_overlay.hide()


func _set_slot_data(new_slot_data: SlotData) -> void:
	if slot_data: slot_data.updated.disconnect(update_slot)
	
	slot_data = new_slot_data
	
	if slot_data: slot_data.updated.connect(update_slot)
	update_slot()


func _on_mouse_entered() -> void:
	lighten_overlay.show()


func _on_mouse_exited() -> void:
	lighten_overlay.hide()
