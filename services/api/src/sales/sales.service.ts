import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSaleDto } from './dto/create-sale.dto';

@Injectable()
export class SalesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(organizationId: string, userId: string, dto: CreateSaleDto) {
    const productIds = dto.items.map((item) => item.productId);
    const products = await this.prisma.product.findMany({
      where: { organizationId, id: { in: productIds } },
    });

    if (products.length !== productIds.length) {
      throw new NotFoundException('One or more products not found');
    }

    const itemData = dto.items.map((item) => {
      const product = products.find((p) => p.id === item.productId);
      if (!product) {
        throw new NotFoundException('Product not found');
      }

      const price = Number(item.price ?? product.price);
      const total = price * Number(item.quantity);
      return { product, price, quantity: item.quantity, total };
    });

    const subtotal = itemData.reduce((sum, item) => sum + item.total, 0);
    const tax = dto.tax ?? 0;
    const discount = dto.discount ?? 0;
    const total = subtotal + tax - discount;

    return this.prisma.$transaction(async (tx) => {
      for (const item of itemData) {
        const newStock = item.product.stock - item.quantity;
        if (newStock < 0) {
          throw new BadRequestException('Insufficient stock');
        }
      }

      const sale = await tx.sale.create({
        data: {
          organizationId,
          userId,
          subtotal,
          tax,
          discount,
          total,
          status: 'PAID',
          items: {
            create: itemData.map((item) => ({
              productId: item.product.id,
              quantity: Number(item.quantity),
              price: Number(item.price),
              total: Number(item.total),
            })),
          },
        },
        include: { items: true },
      });

      for (const item of itemData) {
        await tx.product.update({
          where: { id: item.product.id },
          data: { stock: item.product.stock - item.quantity },
        });

        await tx.inventoryMovement.create({
          data: {
            organizationId,
            productId: item.product.id,
            type: 'OUT',
            quantity: Number(item.quantity),
            reason: 'SALE',
            referenceId: sale.id,
            createdById: userId,
          },
        });
      }

      return sale;
    });
  }

  list(organizationId: string) {
    return this.prisma.sale.findMany({
      where: { organizationId },
      orderBy: { createdAt: 'desc' },
      include: { items: true },
    });
  }

  async findOne(organizationId: string, id: string) {
    const sale = await this.prisma.sale.findFirst({
      where: { id, organizationId },
      include: { items: true },
    });

    if (!sale) {
      throw new NotFoundException('Sale not found');
    }

    return sale;
  }
}
