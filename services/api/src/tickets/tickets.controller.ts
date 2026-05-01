import { Body, Controller, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { UpdateTicketDto } from './dto/update-ticket.dto';
import { TicketsService } from './tickets.service';

@UseGuards(JwtAuthGuard)
@Controller('tickets')
export class TicketsController {
  constructor(private readonly ticketsService: TicketsService) {}

  @Post()
  create(
    @CurrentUser() user: { organizationId: string; id: string },
    @Body() dto: CreateTicketDto,
  ) {
    return this.ticketsService.create(user.organizationId, user.id, dto);
  }

  @Get()
  list(@CurrentUser() user: { organizationId: string }) {
    return this.ticketsService.list(user.organizationId);
  }

  @Patch(':id')
  update(
    @CurrentUser() user: { organizationId: string },
    @Param('id') id: string,
    @Body() dto: UpdateTicketDto,
  ) {
    return this.ticketsService.update(user.organizationId, id, dto);
  }
}
