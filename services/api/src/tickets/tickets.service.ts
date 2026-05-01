import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { UpdateTicketDto } from './dto/update-ticket.dto';

@Injectable()
export class TicketsService {
  constructor(private readonly prisma: PrismaService) {}

  create(organizationId: string, userId: string, dto: CreateTicketDto) {
    return this.prisma.ticket.create({
      data: {
        organizationId,
        userId,
        subject: dto.subject,
        message: dto.message,
        priority: dto.priority ?? 'MEDIUM',
      },
    });
  }

  list(organizationId: string) {
    return this.prisma.ticket.findMany({
      where: { organizationId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async update(organizationId: string, id: string, dto: UpdateTicketDto) {
    const ticket = await this.prisma.ticket.findFirst({
      where: { id, organizationId },
    });

    if (!ticket) {
      throw new NotFoundException('Ticket not found');
    }

    return this.prisma.ticket.update({
      where: { id },
      data: dto,
    });
  }
}
