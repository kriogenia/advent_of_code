def flat_map(list: "list(str)"):
    map = []
    for x in list:
        map.extend(x)
    return map
