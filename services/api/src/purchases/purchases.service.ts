import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePurchaseDto } from './dto/create-purchase.dto';

@Injectable()
export class PurchasesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(organizationId: string, userId: string, dto: CreatePurchaseDto) {
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

      const cost = Number(item.cost ?? product.cost);
      const total = cost * Number(item.quantity);
      return { product, cost, quantity: item.quantity, total };
    });

    const subtotal = itemData.reduce((sum, item) => sum + item.total, 0);
    const tax = dto.tax ?? 0;
    const discount = dto.discount ?? 0;
    const total = subtotal + tax - discount;

    return this.prisma.$transaction(async (tx) => {
      const purchase = await tx.purchase.create({
        data: {
          organizationId,
          user: { connect: { id: userId } },
          supplierName: dto.supplierName,
          subtotal,
          tax,
          discount,
          total,
          status: 'RECEIVED',
          items: {
            create: itemData.map((item) => ({
              productId: item.product.id,
              quantity: Number(item.quantity),
              cost: Number(item.cost),
              total: Number(item.total),
            })),
          },
        } as any,
        include: { items: true },
      });

      for (const item of itemData) {
        await tx.product.update({
          where: { id: item.product.id },
          data: { stock: item.product.stock + item.quantity },
        });

        await (tx as any).inventoryMovement.create({
          data: {
            organizationId,
            productId: item.product.id,
            type: 'IN',
            quantity: Number(item.quantity),
            reason: 'PURCHASE',
            referenceId: purchase.id,
            createdById: userId,
          },
        });
      }

      return purchase;
    });
  }

  list(organizationId: string) {
    return this.prisma.purchase.findMany({
      where: { organizationId },
      orderBy: { createdAt: 'desc' },
      include: { items: true },
    });
  }

  async findOne(organizationId: string, id: string) {
    const purchase = await this.prisma.purchase.findFirst({
      where: { id, organizationId },
      include: { items: true },
    });

    if (!purchase) {
      throw new NotFoundException('Purchase not found');
    }

    return purchase;
  }
}
