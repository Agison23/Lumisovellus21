import { Request, Response } from "express";
import { HelpService } from "../../services/help/HelpService";
import { ApiResponseHandler } from "../../middleware/responseHandler";
import { asyncHandler } from "../../middleware/errorHandler";
import { AuthenticatedRequest } from "../../types";

export class HelpController {
  private helpService: HelpService;

  constructor() {
    this.helpService = new HelpService();
  }

  createHelpRequest = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, "Authentication required");
        return;
      }

      const helpData = {
        ...req.body,
        userId: req.user.id, // Use authenticated user's ID
      };
      const result = await this.helpService.createHelpRequest(helpData);
      ApiResponseHandler.success(res, { status: "ok", ...result });
    },
  );

  getAllHelpRequests = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const helpRequests = await this.helpService.getAllHelpRequests();
      ApiResponseHandler.success(res, helpRequests);
    },
  );

  updateHelpResponse = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const responseData = req.body;
      await this.helpService.updateHelpResponse(responseData);
      ApiResponseHandler.success(res, { status: "ok" });
    },
  );
}
