import * as streams from "@std/streams";

export interface Day<T> {
  parser: Parser<T>;
  a: Solver<T>;
  b?: Solver<T>;
}

export interface Parser<T> {
  (generator: FileReader): Promise<T>;
}

export interface Solver<T> {
  (input: T): number;
}

export type FileReader = AsyncGenerator<string, void, void>;

export async function* readFile(
  file: string,
): FileReader {
  using f = await Deno.open(file);
  const readable: ReadableStream<string> = f.readable
    .pipeThrough(new TextDecoderStream())
    .pipeThrough(new streams.TextLineStream());

  for await (const line of readable) {
    yield line;
  }
}

export const SUM = (a: number, b: number): number => a + b;
