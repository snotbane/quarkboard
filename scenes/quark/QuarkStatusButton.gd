
extends IconToggleButton

@export var socket : ResourceSocket

@export var status : Quark.Status

var quark : Quark :
	get: return socket.resource


func _ready() -> void:
	super._ready()

	assert(status != Quark.Status.NONE, "QuarkStatusButton cannot track NONE status.")

	socket.resource_changed.connect(_on_resource_changed)
	socket.resource_value_changed.connect(_on_resource_changed.unbind(1))


func _on_resource_changed() -> void:
	set_pressed_no_signal(quark.status == status)
	super._toggled(button_pressed)


func _toggled(toggled_on: bool) -> void:
	super._toggled(toggled_on)

	quark.status = status if toggled_on else Quark.Status.NONE
	quark.save()
