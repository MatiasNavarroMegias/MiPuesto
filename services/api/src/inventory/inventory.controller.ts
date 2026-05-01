import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { CreateMovementDto } from './dto/create-movement.dto';
import { InventoryService } from './inventory.service';

@UseGuards(JwtAuthGuard)
@Controller('inventory')
export class InventoryController {
  constructor(private readonly inventoryService: InventoryService) {}

  @Post('movements')
  createMovement(
    @CurrentUser() user: { organizationId: string; id: string },
    @Body() dto: CreateMovementDto,
  ) {
    return this.inventoryService.createMovement(user.organizationId, user.id, dto);
  }

  @Get('movements')
  list(@CurrentUser() user: { organizationId: string }) {
    return this.inventoryService.list(user.organizationId);
  }
}
