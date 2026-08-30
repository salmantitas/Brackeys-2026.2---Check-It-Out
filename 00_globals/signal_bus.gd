extends Node

@warning_ignore("unused_signal")
signal conversation_started(npc : NPC)

@warning_ignore("unused_signal")
signal conversation_ended(npc : NPC)

@warning_ignore("unused_signal")
signal npc_left(npc : NPC)

@warning_ignore("unused_signal")
signal position_cleared(pos_x : float)

@warning_ignore("unused_signal")
signal inspection_started()

@warning_ignore("unused_signal")
signal inspection_ended()

@warning_ignore("unused_signal")
signal product_taken(product_id : StoreManager.ProductType, npc: NPC)

@warning_ignore("unused_signal")
signal product_returned(product_id : StoreManager.ProductType, npc: NPC)
