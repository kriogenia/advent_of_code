import time
import importlib


def format_duration(seconds: float) -> str:
    if seconds >= 1:
        return f"{seconds:7.3f}s"
    elif seconds >= 1e-3:
        return f"{seconds * 1e3:7.3f}ms"
    else:
        return f"{seconds * 1e6:7.3f}µs"


def time_fn(fn):
    start = time.perf_counter()
    fn()
    return time.perf_counter() - start


def time_module(day: int) -> tuple[float, float]:
    module_name = f"aoc_2021.day_{day:02d}"

    try:
        module = importlib.import_module(module_name)
    except ModuleNotFoundError:
        print(f"| {day:>5} |           |           |")
        return 0.0, 0.0

    t_a = time_fn(module.part_a)
    part_a = format_duration(t_a)

    t_b = time_fn(module.part_b)
    part_b = format_duration(t_b)

    print(f"| {day:>5} | {part_a} | {part_b} |")
    return t_a, t_b


if __name__ == "__main__":
    print("|  Day  |  Part A   |  Part B   |")
    print("|-------|-----------|-----------|")

    total_a, total_b = 0.0, 0.0
    for i in range(1, 26):
        t_a, t_b = time_module(i)
        total_a += t_a
        total_b += t_b
    print(f"| Total | {format_duration(total_a)} | {format_duration(total_b)} |")
