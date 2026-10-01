extends Button
class_name SlotButton

var slot_data: SlotData : set = _set_slot_data

@onready var quantity_label: Label = %QuantityLabel
@onready var mesh_viewer: MeshViewer = %MeshViewer
@onready var highlight_overlay: Panel = %HighlightOverlay
@onready var lighten_overlay: Panel = %LightenOverlay
@onready var darken_overlay: Panel = %DarkenOverlay


func highlight() -> void:
	highlight_overlay.show()


func unhighlight() -> void:
	highlight_overlay.hide()


func darken() -> void:
	darken_overlay.show()


func undarken() -> void:
	darken_overlay.hide()


func _set_slot_data(new_slot_data: SlotData) -> void:
	slot_data = new_slot_data
	
	mesh_viewer.mesh = null
	quantity_label.visible = false
	
	if not slot_data.is_empty():
		mesh_viewer.mesh = slot_data.item_data.mesh_preview
		quantity_label.text = "x%s" % slot_data.quantity 
		quantity_label.visible = slot_data.quantity > 1 \
			if not slot_data.item_data.display_stack_value else true


func _on_mouse_entered() -> void:
	lighten_overlay.show()


func _on_mouse_exited() -> void:
	lighten_overlay.hide()
