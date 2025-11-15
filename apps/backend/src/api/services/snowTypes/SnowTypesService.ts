import { BaseService } from '../BaseService';
import { SnowType } from '../../types';

export interface CreateSnowTypeRequest {
  name: string;
  colour: string;
  skiability?: number | null;
  primarySnowTypeId?: string | null;
  explanation?: string | null;
}

export interface AddSecondarySnowTypesRequest {
  secondarySnowTypeIds: string[];
}

export class SnowTypesService extends BaseService {
  async createSnowType(data: CreateSnowTypeRequest): Promise<SnowType> {
    try {
      // Check if snow type with same name already exists
      const existing = await this.prisma.snowType.findUnique({
        where: { name: data.name },
      });

      if (existing) {
        const error: any = new Error('Snow type with this name already exists');
        error.statusCode = 409;
        throw error;
      }

      // Normalize colour format (ensure it starts with #)
      const normalizedColour = data.colour.startsWith('#') ? data.colour : `#${data.colour}`;

      // If primarySnowTypeId is provided, verify it exists and is a primary type (has null primarySnowTypeId)
      if (data.primarySnowTypeId) {
        const primaryType = await this.prisma.snowType.findUnique({
          where: { id: data.primarySnowTypeId },
        });

        if (!primaryType) {
          const error: any = new Error('Primary snow type not found');
          error.statusCode = 404;
          throw error;
        }

        if (primaryType.primarySnowTypeId !== null) {
          const error: any = new Error('Cannot use a secondary snow type as primary snow type');
          error.statusCode = 400;
          throw error;
        }
      }

      const snowType = await this.prisma.snowType.create({
        data: {
          id: crypto.randomUUID(),
          name: data.name,
          colour: normalizedColour,
          skiability: data.skiability ?? null,
          primarySnowTypeId: data.primarySnowTypeId ?? null,
          explanation: data.explanation ?? null,
        },
      });

      return {
        id: snowType.id,
        name: snowType.name,
        colour: snowType.colour,
        skiability: snowType.skiability,
        primarySnowTypeId: snowType.primarySnowTypeId,
        explanation: snowType.explanation,
      };
    } catch (error: any) {
      if (error.statusCode === 409) {
        throw error;
      }
      throw await this.handleDatabaseError(error);
    }
  }

  async addSecondarySnowTypes(
    snowTypeId: string,
    secondarySnowTypeIds: string[]
  ): Promise<SnowType> {
    try {
      // Verify the snow type exists (this is the one that will have secondary types)
      const snowType = await this.prisma.snowType.findUnique({
        where: { id: snowTypeId },
      });

      if (!snowType) {
        const error: any = new Error('Snow type not found');
        error.statusCode = 404;
        throw error;
      }

      // Verify all secondary snow types exist (these are other SnowTypes that will be secondary)
      const secondarySnowTypes = await this.prisma.snowType.findMany({
        where: {
          id: {
            in: secondarySnowTypeIds,
          },
        },
      });

      if (secondarySnowTypes.length !== secondarySnowTypeIds.length) {
        const error: any = new Error('One or more snow types not found');
        error.statusCode = 404;
        throw error;
      }

      // Prevent self-referential relationships
      if (secondarySnowTypeIds.includes(snowTypeId)) {
        const error: any = new Error('Cannot add a snow type as its own secondary type');
        error.statusCode = 400;
        throw error;
      }

      // Create secondary snow type relationships
      // First, get existing relationships to avoid duplicates
      const existingRelations = await this.prisma.snowTypeSecondary.findMany({
        where: {
          primarySnowTypeId: snowTypeId,
          secondarySnowTypeId: {
            in: secondarySnowTypeIds,
          },
        },
      });

      const existingSecondaryIds = existingRelations.map(
        (rel) => rel.secondarySnowTypeId
      );
      const newSecondaryIds = secondarySnowTypeIds.filter(
        (id) => !existingSecondaryIds.includes(id)
      );

      if (newSecondaryIds.length > 0) {
        await this.prisma.snowTypeSecondary.createMany({
          data: newSecondaryIds.map((secondaryId) => ({
            id: crypto.randomUUID(),
            primarySnowTypeId: snowTypeId,
            secondarySnowTypeId: secondaryId,
          })),
          skipDuplicates: true,
        });
      }

      // Return updated snow type with secondary types
      const updatedSnowType = await this.prisma.snowType.findUnique({
        where: { id: snowTypeId },
        include: {
          primarySnowTypes: {
            include: {
              secondarySnowType: {
                select: {
                  id: true,
                  name: true,
                  colour: true,
                  skiability: true,
                  primarySnowTypeId: true,
                  explanation: true,
                },
              },
            },
          },
        },
      });

      if (!updatedSnowType) {
        const error: any = new Error('Failed to retrieve updated snow type');
        error.statusCode = 500;
        throw error;
      }

      return {
        id: updatedSnowType.id,
        name: updatedSnowType.name,
        colour: updatedSnowType.colour,
        skiability: updatedSnowType.skiability,
        primarySnowTypeId: updatedSnowType.primarySnowTypeId,
        explanation: updatedSnowType.explanation,
        secondaryTypes: updatedSnowType.primarySnowTypes.map(
          (rel) => ({
            id: rel.secondarySnowType.id,
            name: rel.secondarySnowType.name,
            colour: rel.secondarySnowType.colour,
            skiability: rel.secondarySnowType.skiability,
            primarySnowTypeId: rel.secondarySnowType.primarySnowTypeId,
            explanation: rel.secondarySnowType.explanation,
          })
        ),
      };
    } catch (error: any) {
      if (error.statusCode) {
        throw error;
      }
      throw await this.handleDatabaseError(error);
    }
  }

  async getSnowTypeWithSecondaries(id: string): Promise<SnowType & { secondaryTypes?: SnowType[] }> {
    try {
      const snowType = await this.prisma.snowType.findUnique({
        where: { id },
        include: {
          primarySnowTypes: {
            include: {
              secondarySnowType: {
                select: {
                  id: true,
                  name: true,
                  colour: true,
                  skiability: true,
                  primarySnowTypeId: true,
                  explanation: true,
                },
              },
            },
          },
        },
      });

      if (!snowType) {
        const error: any = new Error('Snow type not found');
        error.statusCode = 404;
        throw error;
      }

      return {
        id: snowType.id,
        name: snowType.name,
        colour: snowType.colour,
        skiability: snowType.skiability,
        primarySnowTypeId: snowType.primarySnowTypeId,
        explanation: snowType.explanation,
        secondaryTypes: snowType.primarySnowTypes.map(
          (rel) => ({
            id: rel.secondarySnowType.id,
            name: rel.secondarySnowType.name,
            colour: rel.secondarySnowType.colour,
            skiability: rel.secondarySnowType.skiability,
            primarySnowTypeId: rel.secondarySnowType.primarySnowTypeId,
            explanation: rel.secondarySnowType.explanation,
          })
        ),
      };
    } catch (error: any) {
      if (error.statusCode) {
        throw error;
      }
      throw await this.handleDatabaseError(error);
    }
  }

  async getAllSnowTypesFlat(): Promise<SnowType[]> {
    try {
      // Get primary types first (primarySnowTypeId is null), then secondary types
      const primaryTypes = await this.prisma.snowType.findMany({
        where: { primarySnowTypeId: null },
        orderBy: { name: 'asc' },
      });

      const secondaryTypes = await this.prisma.snowType.findMany({
        where: { primarySnowTypeId: { not: null } },
        orderBy: { name: 'asc' },
      });

      const allSnowTypes = [...primaryTypes, ...secondaryTypes];

      return allSnowTypes.map((snowType) => ({
        id: snowType.id,
        name: snowType.name,
        colour: snowType.colour,
        skiability: snowType.skiability,
        primarySnowTypeId: snowType.primarySnowTypeId,
        explanation: snowType.explanation,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getPrimarySnowTypes(): Promise<SnowType[]> {
    try {
      const snowTypes = await this.prisma.snowType.findMany({
        where: {
          primarySnowTypeId: null,
        },
        include: {
          primarySnowTypes: {
            include: {
              secondarySnowType: true,
            },
          },
        },
      });

      return snowTypes.map((snowType) => ({
        id: snowType.id.toString(),
        name: snowType.name,
        colour: snowType.colour,
        skiability: snowType.skiability,
        primarySnowTypeId: snowType.primarySnowTypeId,
        explanation: snowType.explanation,
        secondaryTypes: snowType.primarySnowTypes.map((rel) => ({
          id: rel.secondarySnowType.id.toString(),
          name: rel.secondarySnowType.name,
          colour: rel.secondarySnowType.colour,
          skiability: rel.secondarySnowType.skiability,
          primarySnowTypeId: rel.secondarySnowType.primarySnowTypeId,
          explanation: rel.secondarySnowType.explanation,
        })),
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}

