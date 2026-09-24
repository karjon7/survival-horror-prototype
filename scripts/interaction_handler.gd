extends Node

var current_interactable: InteractableArea
var interaction_progress: float = 0.0
var interacting: bool = false

@onready var interaction_raycast: RayCast3D = %InteractionRayCast


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_fire"): interacting = true
	if event.is_action_released("primary_fire"): interacting = false


func _process(delta: float) -> void:
	if not interaction_raycast.get_collider() is InteractableArea:
		current_interactable = null
		interacting = false
		%InteractionLabel.text = ""
		%InteractionProgressBar.value = 0.0
		return
	
	current_interactable = interaction_raycast.get_collider()
	%InteractionLabel.text = current_interactable.interactable_name 
	interaction_progress = interaction_progress + delta if interacting else 0.0
	%InteractionProgressBar.value = interaction_progress / current_interactable.interact_seconds
	
	if interaction_progress >= current_interactable.interact_seconds:
		current_interactable.interact(get_parent())
		
		current_interactable = null
		interacting = false
		%InteractionLabel.text = ""
		%InteractionProgressBar.value = 0.0
