import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  const plans = [
    {
      code: 'BASE',
      name: 'BASE',
      description: 'Plan base para micro negocios',
      priceMonthly: 0,
      maxUsers: 3,
      maxProducts: 500,
      maxStores: 1,
    },
    {
      code: 'INTERMEDIO',
      name: 'INTERMEDIO',
      description: 'Plan intermedio para pymes',
      priceMonthly: 9.99,
      maxUsers: 10,
      maxProducts: 5000,
      maxStores: 3,
    },
    {
      code: 'AVANZADO',
      name: 'AVANZADO',
      description: 'Plan avanzado para empresas',
      priceMonthly: 29.99,
      maxUsers: 50,
      maxProducts: 50000,
      maxStores: 10,
    },
  ];

  for (const plan of plans) {
    await prisma.subscriptionPlan.upsert({
      where: { code: plan.code },
      update: plan,
      create: plan,
    });
  }

  const adminEmail = process.env.SEED_ADMIN_EMAIL;
  const adminPassword = process.env.SEED_ADMIN_PASSWORD;

  if (!adminEmail || !adminPassword) {
    return;
  }

  const existing = await prisma.user.findUnique({
    where: { email: adminEmail },
  });

  if (existing) {
    return;
  }

  const organization = await prisma.organization.create({
    data: {
      name: 'MiPuesto',
      slug: 'mipuesto',
    },
  });

  const passwordHash = await bcrypt.hash(adminPassword, 10);

  const user = await prisma.user.create({
    data: {
      organizationId: organization.id,
      fullName: 'Super Admin',
      email: adminEmail,
      passwordHash,
      role: 'OWNER',
    },
  });

  const basePlan = await prisma.subscriptionPlan.findUnique({
    where: { code: 'BASE' },
  });

  if (basePlan) {
    await prisma.userSubscription.create({
      data: {
        organizationId: organization.id,
        userId: user.id,
        planId: basePlan.id,
        status: 'ACTIVE',
      },
    });
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
