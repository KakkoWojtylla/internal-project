extends Node3D

@export var spawn_points: Array[NodePath] = []

func get_spawn_point(index: int = -1) -> Transform3D:
    var nodes: Array[Node3D] = []
    for path in spawn_points:
        var node := get_node_or_null(path)
        if node is Node3D:
            nodes.append(node)
    if nodes.is_empty():
        return Transform3D()
    if index >= 0 and index < nodes.size():
        return nodes[index].global_transform
    return nodes[randi() % nodes.size()].global_transform
