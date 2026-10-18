extends Node

enum rank {COMMONER, UNCOMMONER, ESTEEMED, NOBILITY, ROYALTY}

@export var inventory : Array[String] = ["res://autobattler/guys/you.tscn"]
@export var highlighted_ally : Ally = null