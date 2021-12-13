def parse_line(line: str, separator: str | None = None):
	return list(map(lambda n: int(n), line.split(separator)))