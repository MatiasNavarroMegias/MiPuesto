import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { CreateSaleDto } from './dto/create-sale.dto';
import { SalesService } from './sales.service';

@UseGuards(JwtAuthGuard)
@Controller('sales')
export class SalesController {
  constructor(private readonly salesService: SalesService) {}

  @Post()
  create(
    @CurrentUser() user: { organizationId: string; id: string },
    @Body() dto: CreateSaleDto,
  ) {
    return this.salesService.create(user.organizationId, user.id, dto);
  }

  @Get()
  list(@CurrentUser() user: { organizationId: string }) {
    return this.salesService.list(user.organizationId);
  }

  @Get(':id')
  findOne(@CurrentUser() user: { organizationId: string }, @Param('id') id: string) {
    return this.salesService.findOne(user.organizationId, id);
  }
}
