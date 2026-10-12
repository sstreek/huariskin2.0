from src.engine.conflicts import find_conflicts

RULES = [
    {"class_a": "retinoid", "class_b": "aha", "rule_type": "hard"},
    {"class_a": "retinoid", "class_b": "bha", "rule_type": "hard"},
]


def test_retinoid_and_aha_conflict():
    conflicts = find_conflicts({"retinoid", "aha"}, RULES)
    assert len(conflicts) == 1
    assert conflicts[0]["class_b"] == "aha"


def test_no_conflict_when_only_one_class_present():
    conflicts = find_conflicts({"retinoid", "niacinamide"}, RULES)
    assert conflicts == []


def test_retinoid_with_aha_and_bha_finds_both():  # if it finds both rules to be true
    conflicts = find_conflicts({"retinoid", "aha", "bha"}, RULES)
    assert len(conflicts) == 2


def test_no_conflict_when_only_class_b_present():
    conflicts = find_conflicts({"aha"}, RULES)
    assert conflicts == []
