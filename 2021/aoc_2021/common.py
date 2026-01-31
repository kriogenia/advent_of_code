from io import TextIOWrapper
import pathlib
from typing import Generator


def input(filename: str) -> TextIOWrapper:
    path = pathlib.Path(__file__).parent.parent.resolve().joinpath(filename)
    return open(path, "r")


def read_lines(filename: str) -> Generator[str, None, None]:
    with input(filename) as f:
        for line in f:
            yield line.rstrip()
