import os

templates_name = ".README.template.md"
excluded_dirs = ["templates", ".git"]
config_lines = 2
day_template = "[Day {day}](https://adventofcode.com/{year}/day/{day})"


def read_config(file):
    config = {}
    for line in [file.readline().split("=") for _ in range(0, config_lines)]:
        config[line[0][3:]] = line[1][:-1]
    template.readline()  # skip separation line
    return config


def read_completion(file):
    days: list[int] = [0] * 25
    while not (line := file.readline()).startswith("// completion=end"):
        if len(splits := line.split(":")) == 2:
            days[int(splits[0])] = int(splits[1][0])
    return days


def write_completion_table(file, days, year):
    file.write("\n## Completion\n\n")
    file.write("| Day   | Part A | Part B |\n")
    file.write("| :---: | :----: | :----: |\n")
    for day, count in enumerate(days):
        day_link = day_template.format(day=day, year=year)
        if count == 1:
            file.write(f"| {day_link} | ⭐ |    |\n")
        if count == 2:
            file.write(f"| {day_link} | ⭐ | ⭐ |\n")
    file.write(f"\n**Total**: {sum(days)}/50 ⭐\n\n")


def generate_year_readme(year, template):
    days = {}
    with open(f"{year}/README.md", "w") as new_readme:
        new_readme.write(f"# Advent of Code {year}\n\n")
        while line := template.readline():
            if line.startswith("// completion=start"):
                days = read_completion(template)
                write_completion_table(new_readme, days, year)
                continue
            new_readme.write(line)
    return days


years = {}
for year in [f for f in os.listdir(".") if os.path.isdir(f) and f not in excluded_dirs]:
    with open(f"{year}/{templates_name}") as template:
        years[year] = read_config(template)
        years[year]["days"] = generate_year_readme(year, template)
