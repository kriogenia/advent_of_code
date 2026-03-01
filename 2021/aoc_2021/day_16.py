from typing_extensions import Self
from .common import read_lines

INPUT = "input/day_16.txt"


class Packet:
    def __init__(self) -> None:
        self.next = self.read_version
        self.version: int = -1
        self.type: int = -1
        self.value: int = 0
        self.subpackets: list[Packet] = []
        self._buffer: str = ""
        self._initial_size: int = -1

    def run(self, sequence: str) -> Self:
        self._buffer = "".join(bin(int(c, 16))[2:].zfill(4) for c in sequence)
        while not self.next():
            pass  # these type of loops always feel wrong somehow
        return self

    def read_version(self):
        self._initial_size = len(self._buffer)
        self.version = int(self._buffer[:3], 2)
        self._buffer = self._buffer[3:]
        self.next = self.read_type

    def read_type(self):
        self.type = int(self._buffer[:3], 2)

        if self.type == 4:
            self._buffer = self._buffer[3:]
            self.next = self.read_literal
        elif self._buffer[3] == "0":
            self._buffer = self._buffer[4:]
            self.next = self.read_total_length
        else:
            self._buffer = self._buffer[4:]
            self.next = self.read_subpacket_number

    def read_literal(self) -> bool:
        self.value = self.value * 16 + int(self._buffer[1:5], 2)
        is_last, self._buffer = self._buffer[0] == "0", self._buffer[5:]
        return is_last

    def read_total_length(self):
        self.value, self._buffer = int(self._buffer[:15], 2), self._buffer[15:]
        self.next = self.push_to_subpacket_by_length
        self._add_subpacket()

    def read_subpacket_number(self):
        self.value, self._buffer = int(self._buffer[:11], 2), self._buffer[11:]
        self.next = self.push_to_subpacket_by_number
        self._add_subpacket()

    def push_to_subpacket_by_length(self) -> bool:
        if self.subpackets[-1].next():
            self._buffer = self.subpackets[-1]._buffer
            if sum(len(s) for s in self.subpackets) >= self.value:
                return True
            self._add_subpacket()
        return False

    def push_to_subpacket_by_number(self) -> bool:
        if self.subpackets[-1].next():
            self._buffer = self.subpackets[-1]._buffer
            if len(self.subpackets) >= self.value:
                return True
            self._add_subpacket()
        return False

    def _add_subpacket(self):
        new_packet = Packet()
        new_packet._buffer = self._buffer
        self.subpackets.append(new_packet)

    def total_version(self) -> int:
        return self.version + sum(sp.total_version() for sp in self.subpackets)

    def __len__(self) -> int:
        return self._initial_size - len(self._buffer)

    def __repr__(self) -> str:
        buf = f"{self.version} / {self.type} / {self.value}"
        if self.subpackets:
            buf += f" [ {', '.join(str(sp) for sp in self.subpackets)} ]"
        return buf


def part_a(filename: str = INPUT):
    sequence = next(read_lines(filename))
    return Packet().run(sequence).total_version()


def part_b(filename: str = INPUT):
    raise NotImplementedError("TODO")


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    # print(f"Part B: {part_b()}")
