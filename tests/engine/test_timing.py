from src.engine.timing import is_allowed_at

TIMING_RULES = [
    {"class": "retinoid", "allowed_time": "pm_only"},
    {"class": "spf", "allowed_time": "am_only"},
]


def test_retinoid_not_allowed_in_am():
    assert is_allowed_at({"retinoid"}, "am", TIMING_RULES) == False


def test_retinoid_allowed_in_pm():
    assert is_allowed_at({"retinoid"}, "pm", TIMING_RULES) == True


def test_spf_not_allowed_in_pm():
    assert is_allowed_at({"spf"}, "pm", TIMING_RULES) == False


def test_no_timing_rule_allowed_at_any_time():
    assert is_allowed_at({"niacinamide"}, "am", TIMING_RULES) == True
    assert is_allowed_at({"niacinamide"}, "pm", TIMING_RULES) == True
