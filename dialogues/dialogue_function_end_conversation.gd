extends DialogueFunction

func execute() -> void:
	SignalBus.conversation_ended.emit()
