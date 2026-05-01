import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SubscriptionsService {
  constructor(private readonly prisma: PrismaService) {}

  getPlans() {
    return this.prisma.subscriptionPlan.findMany({
      where: { isActive: true },
      orderBy: { priceMonthly: 'asc' },
    });
  }

  async getCurrent(organizationId: string, userId: string) {
    const subscription = await this.prisma.userSubscription.findFirst({
      where: {
        organizationId,
        userId,
        status: 'ACTIVE',
      },
      orderBy: { createdAt: 'desc' },
      include: { plan: true },
    });

    return subscription ?? null;
  }
}
