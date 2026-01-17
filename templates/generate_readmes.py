import os

templates_name = ".README.template.md"
excluded_dirs = ["templates", ".git"]

day_template = "[Day {day}](https://adventofcode.com/{year}/day/{day})"
img_template = '<img width="100px" height="100px" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/{icon}/{icon}-original.svg" />'
badge_template = "[![{year}](https://img.shields.io/badge/⭐%20{stars}-gray?logo=adventofcode&labelColor=black)](https://adventofcode.com/{year})"


def read_config(file):
    config = {}
    while line := file.readline():
        if not line.startswith("/"):
            break
        line = line.split("=")
        config[line[0][3:]] = line[1][:-1]
    return config


def read_completion(file):
    days: list[int] = [0] * 25
    while not (line := file.readline()).startswith("// completion=end"):
        if len(splits := line.split(":")) == 2:
            days[int(splits[0])] = int(splits[1][0])
    return days


def write_completion_table(file, days, year, max):
    file.write("\n## Completion\n\n")
    file.write("| Day   | Part A | Part B |\n")
    file.write("| :---: | :----: | :----: |\n")
    for day, count in enumerate(days):
        day_link = day_template.format(day=day, year=year)
        if count == 1:
            file.write(f"| {day_link} | ⭐ |    |\n")
        if count == 2:
            file.write(f"| {day_link} | ⭐ | ⭐ |\n")
    file.write(f"\n**Total**: {sum(days)}/{max} ⭐\n\n")


def write_years_table(file, years):
    sorted_years = sorted(years)

    def year(year, _):
        return f"[{year}](./{year})"

    def separator(*_):
        return ":----:"

    def image_link(_, config):
        return img_template.format(icon=config["icon"])

    def name(_, config):
        return f"**{config['title']}**"

    def stars(year, config):
        return badge_template.format(year=year, stars=sum(config["days"]))

    for mapping in [year, separator, image_link, name, stars]:
        transformed = [mapping(year, years[year]) for year in sorted_years]
        file.write(f"| {' | '.join(transformed)} |\n")


def write_stats(file, years):
    achieved = 0
    total = 0
    percents = []

    max = (None, 0)
    min = (None, 1)

    for year, data in years.items():
        star_sum = sum(data["days"])
        achieved += star_sum

        max_stars = int(data.get("max", 50))
        total += max_stars

        percent = star_sum / max_stars
        percents.append(percent)

        if percent > max[1]:
            max = (year, percent)
        if percent < min[1]:
            min = (year, percent)

    percents = sorted(percents)
    n = len(percents)
    median = (
        (percents[n // 2] + percents[n // 2 - 1]) // 2
        if not n % 2
        else percents[n // 2]
    )

    file.write(f"* **Years**: {n}\n")
    file.write(f"* **Total**: {achieved}/{total} ⭐\n")
    file.write(f"* **Max**: {years[max[0]]['title']} {max[0]} ({max[1]:.2f}%)\n")
    file.write(f"* **Min**: {years[min[0]]['title']} {min[0]} ({min[1]:.2f}%)\n")
    file.write(f"* **Average**: {sum(percents) / n:.2f}%\n")
    file.write(f"* **Median**: {median:.2f}%\n")


def generate_year_readme(year, template, max):
    days = {}
    with open(f"{year}/README.md", "w") as new_readme:
        new_readme.write(f"# Advent of Code {year}\n\n")
        while line := template.readline():
            if line.startswith("// completion=start"):
                days = read_completion(template)
                write_completion_table(new_readme, days, year, max)
                continue
            new_readme.write(line)
    return days


def generate_root_readme(years):
    with open(f"templates/{templates_name}") as root_template:
        with open("README.md", "w") as root_readme:
            for line in root_template.readlines():
                if line.startswith("// years"):
                    write_years_table(root_readme, years)
                elif line.startswith("// stats"):
                    write_stats(root_readme, years)
                else:
                    root_readme.write(line)


years = {}
for year in [f for f in os.listdir(".") if os.path.isdir(f) and f not in excluded_dirs]:
    with open(f"{year}/{templates_name}") as template:
        config = read_config(template)
        years[year] = config
        years[year]["days"] = generate_year_readme(
            year, template, config.get("max", 50)
        )

generate_root_readme(years)
