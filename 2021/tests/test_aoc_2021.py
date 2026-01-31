def test_day_01():
    from aoc_2021 import day_01

    assert day_01.part_a("examples/day_01.txt") == 7
    assert day_01.part_b("examples/day_01.txt") == 5


def test_day_02():
    from aoc_2021 import day_02

    assert day_02.part_a("examples/day_02.txt") == 150
    assert day_02.part_b("examples/day_02.txt") == 900


def test_day_03():
    from aoc_2021 import day_03

    assert day_03.part_a("examples/day_03.txt") == 198
    assert day_03.part_b("examples/day_03.txt") == 230


def test_day_04():
    from aoc_2021 import day_04

    assert day_04.part_a("examples/day_04.txt") == 4512
    assert day_04.part_b("examples/day_04.txt") == 1924


def test_day_05():
    from aoc_2021 import day_05

    assert day_05.part_a("examples/day_05.txt") == 5
    assert day_05.part_b("examples/day_05.txt") == 12
