from aoc_2021.day_16 import Packet


def test_day_16_literal():
    packet = Packet().run("D2FE28")
    assert packet.version == 6
    assert packet.type == 4
    assert packet.value == 2021
    assert len(packet) == 21


def test_day_16_length_type_id_0():
    packet = Packet().run("38006F45291200")
    assert packet.version == 1
    assert packet.type == 6
    assert packet.value == 27

    assert len(packet.subpackets) == 2
    assert packet.subpackets[0].value == 10
    assert packet.subpackets[1].value == 20


def test_day_16_length_type_id_1():
    packet = Packet().run("EE00D40C823060")
    assert packet.version == 7
    assert packet.type == 3
    assert packet.value == 3

    assert len(packet.subpackets) == 3
    assert packet.subpackets[0].value == 1
    assert packet.subpackets[1].value == 2
    assert packet.subpackets[2].value == 3
