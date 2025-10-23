import { beforeAll, afterAll } from "vitest";
import { PrismaClient } from "@prisma/client";

// Global test database client
export const testPrisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL || "mysql://root:testpassword@localhost:3307/testdb"
    }
  }
});

beforeAll(async () => {
  // Connect to test database
  await testPrisma.$connect();
});

afterAll(async () => {
  // Disconnect from test database
  await testPrisma.$disconnect();
});
