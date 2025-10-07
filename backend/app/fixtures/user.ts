import type { Pool } from "mysql2/promise";
import { faker } from "@faker-js/faker";

type UserInput = { name?: string; email?: string; password?: string };
type InsertedUser = { id: number; name: string; email: string };

export async function createUser(
  pool: Pool,
  {
    name = faker.person.fullName(),
    email = faker.internet.email().toLowerCase(),
    password = faker.internet.password(),
  }: UserInput = {},
): Promise<InsertedUser> {
  const [result] = await pool.query(
    "INSERT INTO users (name, email, password) VALUES (?, ?, ?)",
    [name, email, password],
  );
  const insertId = (result as any).insertId as number;
  return { id: insertId, name, email };
}
