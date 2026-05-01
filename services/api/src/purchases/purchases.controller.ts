import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { CreatePurchaseDto } from './dto/create-purchase.dto';
import { PurchasesService } from './purchases.service';

@UseGuards(JwtAuthGuard)
@Controller('purchases')
export class PurchasesController {
  constructor(private readonly purchasesService: PurchasesService) {}

  @Post()
  create(
    @CurrentUser() user: { organizationId: string; id: string },
    @Body() dto: CreatePurchaseDto,
  ) {
    return this.purchasesService.create(user.organizationId, user.id, dto);
  }

  @Get()
  list(@CurrentUser() user: { organizationId: string }) {
    return this.purchasesService.list(user.organizationId);
  }

  @Get(':id')
  findOne(@CurrentUser() user: { organizationId: string }, @Param('id') id: string) {
    return this.purchasesService.findOne(user.organizationId, id);
  }
}
