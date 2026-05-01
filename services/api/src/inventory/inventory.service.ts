import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateMovementDto } from './dto/create-movement.dto';

@Injectable()
export class InventoryService {
  constructor(private readonly prisma: PrismaService) {}

  async createMovement(organizationId: string, userId: string, dto: CreateMovementDto) {
    const product = await this.prisma.product.findFirst({
      where: { id: dto.productId, organizationId },
    });

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    let newStock = product.stock;
    if (dto.type === 'IN') {
      newStock = product.stock + Number(dto.quantity);
    } else if (dto.type === 'OUT') {
      newStock = product.stock - Number(dto.quantity);
    } else if (dto.type === 'ADJUST') {
      // ADJUST sets the stock to the provided quantity.
      newStock = Number(dto.quantity);
    }

    if (newStock < 0) {
      throw new BadRequestException('Insufficient stock');
    }

    return this.prisma.$transaction(async (tx) => {
      const updatedProduct = await tx.product.update({
        where: { id: product.id },
        data: { stock: newStock },
      });

      const movement = await tx.inventoryMovement.create({
        data: {
          organizationId,
          productId: product.id,
          type: dto.type,
          quantity: Number(dto.quantity),
          reason: dto.reason,
          referenceId: dto.referenceId,
          createdById: userId,
        },
      });

      return { product: updatedProduct, movement };
    });
  }

  list(organizationId: string) {
    return this.prisma.inventoryMovement.findMany({
      where: { organizationId },
      orderBy: { createdAt: 'desc' },
      include: {
        product: true,
      },
    });
  }
}
