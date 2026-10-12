def is_allowed_at(
    product_classes: set[str], time_of_day: str, rules: list[dict]
) -> bool:
    for rule in rules:
        if rule["class"] in product_classes:
            if rule["allowed_time"] == "pm_only" and time_of_day == "am":
                return False
            if rule["allowed_time"] == "am_only" and time_of_day == "pm":
                return False
    return True
