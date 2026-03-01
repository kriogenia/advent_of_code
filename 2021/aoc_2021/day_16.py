from enum import IntEnum
from math import prod
from typing_extensions import Self
from .common import read_lines

INPUT = "input/day_16.txt"


class Type(IntEnum):
    SUM = 0
    PRODUCT = 1
    MIN = 2
    MAX = 3
    LITERAL = 4
    GT = 5
    LT = 6
    EQ = 7
    NOOP = 8


OPS = {
    Type.SUM: sum,
    Type.PRODUCT: prod,
    Type.MIN: min,
    Type.MAX: max,
}


class Packet:
    def __init__(self) -> None:
        self.__next = self.__read_version
        self.version: int = -1
        self.type: Type = Type.NOOP
        self.value: int = 0
        self.subpackets: list[Packet] = []
        self._buffer: str = ""
        self._initial_size: int = -1

    def run(self, sequence: str) -> Self:
        self._buffer = "".join(bin(int(c, 16))[2:].zfill(4) for c in sequence)
        while not self.__next():
            pass  # these type of loops always feel wrong somehow
        return self

    def total_version(self) -> int:
        return self.version + sum(sp.total_version() for sp in self.subpackets)

    def calc(self) -> int:
        if self.type == Type.LITERAL:
            return self.value
        if op := OPS.get(self.type):
            return op(sp.calc() for sp in self.subpackets)

        diff = self.subpackets[0].calc() - self.subpackets[1].calc()
        if self.type == Type.GT and diff > 0:
            return 1
        if self.type == Type.LT and diff < 0:
            return 1
        if self.type == Type.EQ and diff == 0:
            return 1
        return 0

    def __read_version(self):
        self._initial_size = len(self._buffer)
        self.version = int(self._buffer[:3], 2)
        self._buffer = self._buffer[3:]
        self.__next = self.__read_type

    def __read_type(self):
        self.type = Type(int(self._buffer[:3], 2))

        if self.type == Type.LITERAL:
            self._buffer = self._buffer[3:]
            self.__next = self.__read_literal
        elif self._buffer[3] == "0":
            self._buffer = self._buffer[4:]
            self.__next = self.__read_total_length
        else:
            self._buffer = self._buffer[4:]
            self.__next = self.__read_subpacket_number

    def __read_literal(self) -> bool:
        self.value = self.value * 16 + int(self._buffer[1:5], 2)
        is_last, self._buffer = self._buffer[0] == "0", self._buffer[5:]
        return is_last

    def __read_total_length(self):
        self.value, self._buffer = int(self._buffer[:15], 2), self._buffer[15:]
        self.__next = self.__push_to_subpacket_by_length
        self._add_subpacket()

    def __read_subpacket_number(self):
        self.value, self._buffer = int(self._buffer[:11], 2), self._buffer[11:]
        self.__next = self.__push_to_subpacket_by_number
        self._add_subpacket()

    def __push_to_subpacket_by_length(self) -> bool:
        if self.subpackets[-1].__next():
            self._buffer = self.subpackets[-1]._buffer
            if sum(len(s) for s in self.subpackets) >= self.value:
                return True
            self._add_subpacket()
        return False

    def __push_to_subpacket_by_number(self) -> bool:
        if self.subpackets[-1].__next():
            self._buffer = self.subpackets[-1]._buffer
            if len(self.subpackets) >= self.value:
                return True
            self._add_subpacket()
        return False

    def _add_subpacket(self):
        new_packet = Packet()
        new_packet._buffer = self._buffer
        self.subpackets.append(new_packet)

    def __len__(self) -> int:
        return self._initial_size - len(self._buffer)

    def __repr__(self) -> str:
        buf = f"{self.version} / {self.type} / {self.value}"
        if self.subpackets:
            buf += f" [ {', '.join(str(sp) for sp in self.subpackets)} ]"
        return buf


def run_a(sequence: str) -> int:
    return Packet().run(sequence).total_version()


def run_b(sequence: str) -> int:
    return Packet().run(sequence).calc()


def part_a(filename: str = INPUT):
    sequence = next(read_lines(filename))
    return run_a(sequence)


def part_b(filename: str = INPUT):
    sequence = next(read_lines(filename))
    return run_b(sequence)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
