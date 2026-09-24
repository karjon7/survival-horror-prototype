extends Area3D
class_name InteractableArea

signal interacted_with(interactor: Node3D)

const INTERACTABLE_LAYER = 0b1000

@export var interactable_name: String = "Interactable"
@export_range(0.0, 5.0, 0.1, "or_greater", "prefer_slider") var interact_seconds: float = 1.0

func _ready() -> void:
	collision_layer = INTERACTABLE_LAYER


func interact(interactor: Node3D) -> void:
	interacted_with.emit(interactor)
