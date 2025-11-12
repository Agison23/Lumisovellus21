# Backend API feedback

## Segments

### `GET /api/v1/segments`

#### Params

##### Bounding Box

Currently, the API supports filtering segments by a bounding box using the `bbox` query parameter. The `bbox` parameter should be provided as a comma-separated list of four values: `minLat,minLng,maxLat,maxLng`.

Resulting URL example:

```txt
http://localhost:3001/api/v1/segments?bbox=64.0,25.0,66.0,30.0
```

I feel like this format trades clarity for brevity, which arguably is not ideal for an API. Comma-separated values can be harder to read and understand at a glance, and makes it easy to pass the values in the wrong order.

I propose the following alternative to improve clarity:

- Instead of an array or comma-separated list, use four separate query parameters:
  - `minLat`
  - `minLng`
  - `maxLat`
  - `maxLng`
- Example: `http://localhost:3001/api/v1/segments?minLat=64.0&minLng=25.0&maxLat=66.0&maxLng=30.0`

Alternatively keep as is, but should use standardized OGC format for bounding boxes, by switching the order of the values to:

- `bbox=minLng,minLat,maxLng,maxLat`

### Response

The response format from the API is generally clear and well-structured.

Inside the the `data` array, each segments has an array of coordinates under the `Points` property. This should be 1. changed to `points` (lowercase 'p') to maintain consistency with camelCase or 2. renamed to `coordinates` to better reflect the content. Currently the `isLowerSegment` property uses the old id convention instead of UUID strings. This should be updated to use UUIDs for consistency.

### `PUT /api/v1/segments/:id`

The `PUT /api/v1/segments/:id` endpoint is used to update an existing segment. The request body should contain the updated segment data in JSON format.

This route should be protected to ensure that only users with `admin` role can update segments.

#### Params

Takes segment `id: string` as a URL parameter.

#### Request Body

The request body should contain the following properties:

- `name: string` - The name of the segment.
- `terrain: string` - The terrain of the segment.
- `points: Array<{ lat: number; lng: number }>` - An array of coordinate points defining the segment. Alternatively, this could be named `coordinates` for better clarity is chosen to for the `GET /api/v1/segments` response.
- `isLowerSegment: string | null` - The ID of the lower segment, or `null` if there is no lower segment.
- `avalancheDanger: bool` - Indicates if there is an avalanche danger in the segment.

#### Response

On successful update, the API responds with a status code of `200 OK` and the updated segment data in JSON format:

```json
{
  "data": {
    "id": "string",
    "name": "string",
    "terrain": "string",
    "points": [
      {
        "lat": 0,
        "lng": 0
      }
    ],
    "isLowerSegment": "string | null",
    "avalancheDanger": true
  },
  "meta": {
    ...
  }
}
```

If the segment with the specified ID does not exist, the API should respond with a `404 Not Found` status code and an appropriate error message.

If the user does not have the required `admin` role, the API should respond with a `403 Forbidden` status code.

If the request body is missing required fields or contains invalid data, the API should respond with a `400 Bad Request` status code and an appropriate error message.

### `POST /api/v1/segments`

The `POST /api/v1/segments` endpoint is used to create a new segment. The request body should contain the segment data in JSON format. This route should be protected to ensure that only users with `admin` role can create new segments.

#### Request Body

```json
{
	"name": "string",
	"terrain": "string",
	"points": [
		{
			"lat": 0,
			"lng": 0
		}
	],
	"isLowerSegment": "string | null",
	"avalancheDanger": true
}
```

#### Response

On successful creation, the API responds with a status code of `201 Created` and the newly created segment data in JSON format:

```json
{
  "data": {
    "id": "string",
    "name": "string",
    "terrain": "string",
    "points": [
      {
        "lat": 0,
        "lng": 0
      }
    ],
    "isLowerSegment": "string | null",
    "avalancheDanger": true
  },
  "meta": {
    ...
  }
}
```

If the user does not have the required `admin` role, the API should respond with a `403 Forbidden` status code.
If the request body is missing required fields or contains invalid data, the API should respond with a `400 Bad Request` status code and an appropriate error message.

### `DELETE /api/v1/segments/:id`

The `DELETE /api/v1/segments/:id` endpoint is used to delete an existing segment. This route should be protected to ensure that only users with `admin` role can delete segments.

#### Params

Takes segment `id: string` as a URL parameter.

#### Response

On successful deletion, the API responds with a status code of `204 No Content`.

If the segment with the specified ID does not exist, the API should respond with a `404 Not Found` status code and an appropriate error message.

If the user does not have the required `admin` role, the API should respond with a `403 Forbidden` status code.

