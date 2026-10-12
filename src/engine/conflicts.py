def find_conflicts(routine_classes: set[str], rules: list[dict]) -> list[dict]:
    conflicts = []
    for rule in rules:
        if rule["class_a"] in routine_classes and rule["class_b"] in routine_classes:
            conflicts.append(rule)
    return conflicts
