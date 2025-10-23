import { describe, it, expect, beforeEach } from 'vitest';
import { testPrisma } from '../vitest.setup';

describe('Segment Integration Tests', () => {
  beforeEach(async () => {
    // Clean up segments and coordinates before each test
    await testPrisma.coordinate.deleteMany();
    await testPrisma.segment.deleteMany();
  });

  it('should create a segment with coordinates', async () => {
    const segmentData = {
      id: 'test-segment-1',
      name: 'Test Slope',
      terrain: 'Beginner',
      avalancheDanger: false,
    };

    const segment = await testPrisma.segment.create({
      data: segmentData,
    });

    expect(segment).toMatchObject({
      id: segmentData.id,
      name: segmentData.name,
      terrain: segmentData.terrain,
      avalancheDanger: segmentData.avalancheDanger,
    });

    // Add coordinates to the segment
    const coordinates = [
      {
        id: 'coord-1',
        segment: segment.id,
        order: 1,
        latitude: 65.0121,
        longitude: 25.4651,
      },
      {
        id: 'coord-2',
        segment: segment.id,
        order: 2,
        latitude: 65.0122,
        longitude: 25.4652,
      },
    ];

    for (const coord of coordinates) {
      await testPrisma.coordinate.create({
        data: coord,
      });
    }

    const segmentWithCoords = await testPrisma.segment.findUnique({
      where: { id: segment.id },
      include: { coordinates: true },
    });

    expect(segmentWithCoords?.coordinates).toHaveLength(2);
  });

  it('should handle avalanche danger segments', async () => {
    const dangerousSegment = {
      id: 'danger-segment-1',
      name: 'Advanced Slope',
      terrain: 'Expert',
      avalancheDanger: true,
    };

    const segment = await testPrisma.segment.create({
      data: dangerousSegment,
    });

    expect(segment.avalancheDanger).toBe(true);
  });
});
