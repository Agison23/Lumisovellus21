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
export interface GuideUpdate {
  description: string | null;
  primarySnowTypeIds: string[];
  secondarySnowTypeIds: string[];
  hazards: HazardType[];
}

export interface UserReviewItem {
  submittedAt: Date;
  snowTypeId: string;
  secondarySnowTypeId?: string | null;
  hazards: string[];
}

export interface Observation {
  segmentId: string;
  guideUpdate: GuideUpdate | null;
  userReviews: Array<{
    submittedAt: Date;
    snowTypeId: string;
    hazards: string[];
  }>;
}

export interface Segment {
  id: string;
  name: string;
  terrain: string;
  avalancheDanger: boolean;
  isLowerSegment: number | null;
  points: Array<{
    lat: number;
    lng: number;
  }>;
  guideUpdate: GuideUpdate | null;
  userReviews: UserReviewItem[];
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
/**
 * Hazard types that can be reported on a trail segment
 */
export type HazardType = 'stones' | 'branches';

export interface ReviewRequest {
  snowType: string | null;
  secondarySnowType?: string | null;
  /** Array of hazards encountered on the trail (e.g., ["stones", "branches"]) */
  hazards: HazardType[];
  comment: string | null;
}

export interface Review {
  id: string;
  time: Date;
  segment: string;
  snowType?: string | null;
  hazards?: HazardType[];
  comment?: string | null;
  userId?: string | null;
}

// Snow Type Types
export interface SnowType {
  id: string;
  name: string;
  colour: string;
  skiability?: number | null;
  primarySnowTypeId?: string | null;
  explanation?: string | null;
  secondaryTypes?: SnowType[];
}

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

// Help Event Types
export type HelpNeedType = 'health' | 'equipment' | 'lost';

export type HelpEventStatus = 'active' | 'completed' | 'cancelled';

export interface HelpEventLocation {
  latitude: number;
  longitude: number;
  accuracy: number | null;
}

export interface HelpEventCreate {
  timestamp: number;
  location: {
    latitude: number;
    longitude: number;
    accuracy?: number | null;
  };
  needType: HelpNeedType;
  chatRoomId: string;
}

export interface HelpRequest {
  id: string;
  userId: string;
  timestamp: number;
  gpsCoord: string;
  helpType: string;
  roomId: string;
  status: HelpEventStatus;
  locationAccuracy?: number | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface HelpResponseUpdate {
  helpGiver: string;
  helpRequester: string;
  state: number;
}

export interface NearbyUser {
  userId: string;
  distance: number;
}

export interface HelpRequestHelper {
  userId: string;
  firstName: string;
  lastName: string | null;
  phoneNumber: string | null;
  distance: number; // -1 if no location data
  state: number; // 0: Pending, 1: Accepted, 2: Declined, 3: Completed
  lowBattery: number; // 0: Normal, 1: Low
  lastSeen: Date;
}

export interface Rescuee {
  userId: string;
  needType: HelpNeedType;
  userStatus: {
    location: HelpEventLocation;
    batteryLevel: number | null;
  };
}

export interface HelpEventParticipation {
  acceptanceId: string;
  eventId: string;
  responderId: string;
  location: HelpEventLocation | null;
  acceptedAt: string;
}

export interface HelpEventSummary {
  eventId: string;
  status: HelpEventStatus;
  rescuee: Rescuee;
  location: HelpEventLocation;
  rescuerCount: number;
  createdAt: string;
}

export interface HelpEventRescueeView extends HelpEventSummary {
  acceptedRescuers: HelpEventParticipation[];
  updatedAt: string | null;
}

export type HelpEventRescuerView = HelpEventSummary;

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
