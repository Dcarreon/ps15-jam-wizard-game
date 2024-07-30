extends Area2D

@export var signal_bus : SignalBus

enum upgrade_type { #For any future upgrades
	BOOST
}

@export var upgrade : upgrade_type = upgrade_type.BOOST

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		match upgrade:
			0: #BOOST
				signal_bus.boost_upgrade_entered.emit(body)

		queue_free()