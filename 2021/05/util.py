def parse_line(line: str):
    start, end = line.split(" -> ")
    start = tuple(map(lambda n: int(n), start.split(",")))
    end = tuple(map(lambda n: int(n), end.split(",")))
    return start, end


def get_range(start: int, end: int):
    if start > end:
        return end, start + 1
    else:
        return start, end + 1


def get_direction(start: int, end: int):
    return -1 if start > end else 1


def add_to_map(spots: dict, *coords: int):
    key = str(coords)
    value = spots.get(key)
    if value == None:
        spots[key] = 0
    spots[key] += 1
