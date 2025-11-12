# API Changes

## GET /api/v1/users
OK
## GET /api/v1/users/me
OK
## PUT /api/v1/users/:id
OK
## DELETE /api/v1/users/:id
OK
## GET `/api/v1/snow-types`
OK

## POST `/api/v1/segments/:id/reviews`
OK

## GET `/api/v1/segments/:id/updates`
REMOVED, replaced by GET `/api/v1/segments/:id/observations`

## GET `/api/v1/updates`
REMOVED, replaced by GET `/api/v1/observations`

## GET `/api/v1/reviews/all`
REMOVED, replaced by limit on GET `/api/v1/reviews`

## GET `/api/v1/segments`

### Old Response Item
???

### New Response Item
    [
      {
        id: string;
        name: string;
        terrain: string;
        avalancheDanger: boolean;
        isLowerSegment: number | null;
        points: [
          {
            lat: double;
            lng: double;
          }
        ],
        guideUpdate: null | {
          "description": string | null;
          "primarySnowTypeIds": string[/* max 2 */];
          "secondarySnowTypeIds": string[/* max 2 */];
        },
        userReviews: [ // Limit to 3
          {
            submittedAt: Date;
            snowTypeId: string;
            hazards: string[];
          }
        ],
      }
    ]

---

## GET `/api/v1/reviews` -> GET `/api/v1/observations` 

### Changes
- Remove ambiguous segment and snowType, replace with clear named params.
- Remove comment. Comnments serve as feedback to the customer and normal users shouldn't receive those in responses.
- Do not give userId's in response even if undefined
- Combine reviews and guide updates into single 'observations' route.

### Query Params
- days: number, default 3
- limit (reviews): number, default 3. 

### Old Response Item
    [
      {
        time: Date;
        details: number | null;
        snowType: number | null;
        comment: string | null;
        snow: string | null;
        segment: string | null;
        userId: undefined;
      }
    ]

### New Response Item
    [
      {
        segmentId: string;
        guideUpdate: null | {
          "description": string | null;
          "primarySnowTypeIds": string[/* max 2 */];
          "secondarySnowTypeIds": string[/* max 2 */];
        },
        userReviews: [
          {
            submittedAt: Date;
            snowTypeId: string;
            hazards: string[];
          }
        ]
      }
    ]

---

## New endpoints:
## GET `/api/v1/segments/:id/observations`

### Description
Observations for a specific segment.

### Query Params
- limit: number, default 3
- days: number, default 3

### Response Item
    Same as GET `/api/v1/observations`
    
## POST `/api/v1/segments/:id/guideUpdate`

### Request Body
    {
      "description": string | null;
      "primarySnowTypeIds": string[/* max 2 */];
      "secondarySnowTypeIds": string[/* max 2 */];
    }