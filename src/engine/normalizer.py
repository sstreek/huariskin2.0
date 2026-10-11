#dictionary look up with a fall back


def build_alias_table(aliases: list[dict]) -> dict[str, str]:
    table = {}
    for row in aliases:
        table[row["alias"]] = row["canonical_name"]
    return table



def normalize(raw_name: str, alias_table: dict[str, str]) -> str:
    cleaned = raw_name.strip().lower()
    return alias_table.get(cleaned, cleaned)




def normalize_all(raw_names: list[str], alias_table: dict[str, str]) -> tuple[list[str], list[str]]:
    names = []
    unmatched = []
    for raw in raw_names:
        canonical = normalize(raw, alias_table)
        names.append(canonical)

        cleaned = raw.strip().lower()

        if cleaned not in alias_table:
            unmatched.append(raw)
    return names, unmatched