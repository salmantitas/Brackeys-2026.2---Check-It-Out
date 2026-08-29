extends Dialogue

func visitable(npc : NPC) -> bool:
	return not npc.assisted
