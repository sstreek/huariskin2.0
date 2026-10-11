from src.engine.normalizer import normalize, build_alias_table, normalize_all

ALIAS_TABLE = build_alias_table([
    {"alias": "tocopherol",    "canonical_name": "vitamin_e"},
    {"alias": "retinol",       "canonical_name": "retinol"},
    {"alias": "l-ascorbic acid", "canonical_name": "vitamin_c"},
  ])

def test_known_alias_returns_canonical():
    assert normalize("tocopherol", ALIAS_TABLE) == "vitamin_e"
def test_unknown_ingredient_returns_normalized_raw():
    assert normalize("wax", ALIAS_TABLE) == "wax"
def test_case_insensitive():
    assert normalize("Tocopherol", ALIAS_TABLE) == "vitamin_e"


def test_normalize_all_reports_unmatched():
    names, unmatched = normalize_all(["Tocopherol", "wax"], ALIAS_TABLE)
    assert names == ["vitamin_e", "wax"]       
    assert unmatched == ["wax"]      