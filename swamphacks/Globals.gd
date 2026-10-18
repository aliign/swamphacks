extends Node

enum rank {COMMONER, UNCOMMONER, ESTEEMED, NOBILITY, ROYALTY}

@export var inventory : Array[String] = []
@export var highlighted_ally : Ally = null