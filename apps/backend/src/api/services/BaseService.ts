import { PrismaClient } from "@prisma/client";

export abstract class BaseService {
  protected prisma: PrismaClient;

  constructor() {
    this.prisma = new PrismaClient();
  }

  protected async handleDatabaseError(error: any): Promise<never> {
    console.error("Database error:", error);
    throw error;
  }

  async disconnect(): Promise<void> {
    await this.prisma.$disconnect();
  }
}
