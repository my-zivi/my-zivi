export type Overrides<T> = T | Record<string, unknown>;

export default interface Factory<T> {
  build(overrides?: Overrides<T>): T;
}
