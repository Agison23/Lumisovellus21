import { Request, Response } from 'express';
import { HelpService } from '../../services/help/HelpService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';

export class HelpController {
  private helpService: HelpService;

  constructor() {
    this.helpService = new HelpService();
  }

  createHelpRequest = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const helpData = req.body;
    const result = await this.helpService.createHelpRequest(helpData);
    ApiResponseHandler.success(res, { status: 'ok', ...result });
  });

  getAllHelpRequests = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const helpRequests = await this.helpService.getAllHelpRequests();
    ApiResponseHandler.success(res, helpRequests);
  });

  updateHelpResponse = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const responseData = req.body;
    await this.helpService.updateHelpResponse(responseData);
    ApiResponseHandler.success(res, { status: 'ok' });
  });
}
