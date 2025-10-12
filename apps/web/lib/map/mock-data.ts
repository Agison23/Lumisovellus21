export const mapAreas = [
  {
    type: "Feature" as const,
    properties: { name: "Ski Area 1", id: "area-1" },
    geometry: {
      type: "Polygon" as const,
      coordinates: [
        [
          [24.05, 68.045], // bottom left
          [24.06, 68.048], // bottom right
          [24.045, 68.055], // top right
          [24.04, 68.055], // top left
          [24.05, 68.045], // closing the polygon
        ],
      ],
    },
  },
  {
    type: "Feature" as const,
    properties: { name: "Hiking Trail", id: "area-2" },
    geometry: {
      type: "Polygon" as const,
      coordinates: [
        [
          [24.04, 68.03],
          [24.07, 68.03],
          [24.07, 68.045],
          [24.04, 68.045],
          [24.04, 68.03],
        ],
      ],
    },
  },
];
