import { Request, Response } from 'express';
import { HelpService } from '../../services/help/HelpService.js';
import { ApiResponseHandler } from '../../middleware/responseHandler.js';
import { asyncHandler } from '../../middleware/errorHandler.js';
import { AuthenticatedRequest } from '../../types';
import {
  helpEventAcceptanceSchema,
  helpEventCreateSchema,
  helpEventNearbyQuerySchema,
  helpEventStatusUpdateSchema,
  helpEventRescueeViewSchema,
  helpEventRescuerViewSchema,
  helpEventSummarySchema,
} from '../../middleware/validation.js';
import { z } from 'zod';

export class HelpController {
  private helpService: HelpService;

  constructor() {
    this.helpService = new HelpService();
  }

  private handleValidationError(
    res: Response,
    error: z.ZodError,
    message: string
  ) {
    ApiResponseHandler.validationError(res, message, error.flatten());
  }

  createHelpEvent = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const parsed = helpEventCreateSchema.safeParse(req.body);
      if (!parsed.success) {
        this.handleValidationError(res, parsed.error, 'Invalid help event payload');
        return;
      }

      const event = await this.helpService.createHelpEvent(
        req.user.id,
        parsed.data
      );
      ApiResponseHandler.success(res, event, 201, undefined, helpEventRescueeViewSchema);
    }
  );

  listNearbyHelpEvents = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const parsed = helpEventNearbyQuerySchema.safeParse(req.query);
      if (!parsed.success) {
        this.handleValidationError(
          res,
          parsed.error,
          'Invalid location parameters'
        );
        return;
      }

      const { lat, lng, accuracy } = parsed.data;
      const events = await this.helpService.listNearbyHelpEvents(
        lat,
        lng,
        accuracy ?? 3000
      );
      ApiResponseHandler.success(res, events, 200, undefined, z.array(helpEventSummarySchema));
    }
  );

  getHelpEventView = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      try {
        const event = await this.helpService.getHelpEventView(
          req.params.eventId,
          req.user.id
        );
        // getHelpEventView returns either rescuee or rescuer view based on user role
        // Using union schema - validation will check against both schemas
        ApiResponseHandler.success(res, event, 200, undefined, z.union([helpEventRescueeViewSchema, helpEventRescuerViewSchema]));
      } catch (error) {
        if (error instanceof Error && error.message.includes('not part')) {
          ApiResponseHandler.forbidden(res, error.message);
          return;
        }
        throw error;
      }
    }
  );

  acceptHelpEvent = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const parsed = helpEventAcceptanceSchema.safeParse(req.body);
      if (!parsed.success) {
        this.handleValidationError(res, parsed.error, 'Invalid acceptance payload');
        return;
      }

      try {
        const view = await this.helpService.acceptHelpEvent(
          req.params.eventId,
          req.user.id,
          {
            latitude: parsed.data.location.latitude,
            longitude: parsed.data.location.longitude,
            accuracy: parsed.data.location.accuracy ?? null,
          }
        );
        ApiResponseHandler.success(res, view, 200, undefined, helpEventRescuerViewSchema);
      } catch (error) {
        if (error instanceof Error) {
          ApiResponseHandler.forbidden(res, error.message);
          return;
        }
        throw error;
      }
    }
  );

  withdrawHelpEvent = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      try {
        const view = await this.helpService.withdrawHelpEvent(
          req.params.eventId,
          req.user.id
        );
        ApiResponseHandler.success(res, view, 200, undefined, helpEventRescuerViewSchema);
      } catch (error) {
        if (error instanceof Error) {
          ApiResponseHandler.forbidden(res, error.message);
          return;
        }
        throw error;
      }
    }
  );

  updateHelpEventStatus = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const parsed = helpEventStatusUpdateSchema.safeParse(req.body);
      if (!parsed.success) {
        this.handleValidationError(res, parsed.error, 'Invalid status payload');
        return;
      }

      try {
        const event = await this.helpService.updateHelpEventStatus(
          req.params.eventId,
          req.user.id,
          parsed.data.status
        );
        ApiResponseHandler.success(res, event, 200, undefined, helpEventRescueeViewSchema);
      } catch (error) {
        if (error instanceof Error) {
          ApiResponseHandler.forbidden(res, error.message);
          return;
        }
        throw error;
      }
    }
  );

  streamHelpEvent = asyncHandler(async (req: Request, res: Response) => {
    ApiResponseHandler.error(
      res,
      'NOT_IMPLEMENTED',
      'Real-time streaming is not yet available',
      501
    );
  });
}
