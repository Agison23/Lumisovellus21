import { Request } from 'express';

// Base API Response Types
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    pagination?: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
    timestamp: string;
  };
}

// Request Types
export interface AuthenticatedRequest extends Request {
  user?: {
    id: string;
    email: string | null;
    firstName: string;
    lastName: string | null;
    role: string;
  };
}

// Health Types
export interface HealthResponse {
  status: string;
  version: string;
}

// Segment Types
export interface Segment {
  id: string;
  name: string;
  terrain: string;
  avalancheDanger: boolean;
  isLowerSegment: number | null;
  Points: Array<{
    lat: number;
    lng: number;
  }>;
}

export interface SegmentUpdate {
  id: string;
  segment: string;
  time: Date;
  description?: string;
  snowTypeId1?: string;
  snowTypeId2?: string;
  secondaryId1?: string;
  secondaryId2?: string;
  reviewId1?: string;
  reviewId2?: string;
  reviewId3?: string;
}

// Review Types
export interface ReviewRequest {
  segment: string;
  snowType: string;
  details: number;
  comment: string;
}

export interface Review {
  id: string;
  time: Date;
  segment: string;
  snowType?: string | null;
  details?: number | null;
  comment?: string | null;
  userId?: string | null;
}

// Snow Type Types
export interface SnowType {
  id: string;
  name: string;
  colour: string;
  skiability?: number | null;
  categoryId?: number | null;
  explanation?: string | null;
}

// User Types
export interface LocationUpdateRequest {
  timestamp: number;
  firstName: string;
  lastName: string;
  gpsCoord: string;
  phoneNumber?: string;
}

export interface BatteryUpdateRequest {
  batteryStatus: 'low' | 'normal';
}

export interface RoleUpdateRequest {
  role: string;
}

export interface UserRole {
  role: string;
  permissions: string;
}

// Help Request Types
export interface HelpRequestCreate {
  timestamp: number;
  deviceId: string;
  gpsCoord: string;
  helpType: 'seriousEmerg' | 'help';
  chatRoomId: string;
}

export interface HelpRequest {
  id: string;
  userId: string;
  timestamp: number;
  gpsCoord: string;
  helpType: string;
  roomId: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface HelpResponseUpdate {
  helpGiver: string;
  helpRequester: string;
  state: number;
}

// Error Types
export interface ApiError {
  code: string;
  message: string;
  details?: any;
}

// Pagination Types
export interface PaginationParams {
  page?: number;
  limit?: number;
}

export interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}
