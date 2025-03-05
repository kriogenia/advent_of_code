import { Day, readFile } from "./common.ts";

if (import.meta.main) {
  if (Deno.args.length < 1) {
    console.error("Please, provide the day number as an argument");
    Deno.exit(1);
  }

  const number = Deno.args[0];
  const part = Deno.args[1] || "ab";

  const dayPromise = import(`./day_${number}.ts`);

  const day: Day<unknown> = (await dayPromise).default;

  if (part === "a" || part === "ab") {
    const generator = readFile(`input/day_${number}.txt`);
    const result = day.parser(generator).then(day.a);
    console.log(`${part === "ab" ? "A: " : ""}${await result}`);
  }

  if (part === "b" || part === "ab" && day.b) {
    const generator = readFile(`input/day_${number}.txt`);
    const result = day.parser(generator).then(day.b) || "nyi";
    console.log(`${part === "ab" ? "B: " : ""}${await result}`);
  }
}
