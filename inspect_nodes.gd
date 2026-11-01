extends Node

func _ready():
    var town = preload("res://tucheng_town.glb").instantiate()
    print("Town children count:", town.get_child_count())
    for i in range(min(15, town.get_child_count())):
        var c = town.get_child(i)
        print("Child ", i, ": ", c.name, " (", c.get_class(), ")")
    # Search for nodes around 1090-1105
    for i in range(max(0, town.get_child_count() - 30), town.get_child_count()):
        var c = town.get_child(i)
        print("Child ", i, ": ", c.name, " (", c.get_class(), ") pos=", c.position if c is Node3D else "")
    get_tree().quit()
