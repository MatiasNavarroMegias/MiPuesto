import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { ProductsService } from './products.service';

@UseGuards(JwtAuthGuard)
@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  create(
    @CurrentUser() user: { organizationId: string },
    @Body() dto: CreateProductDto,
  ) {
    return this.productsService.create(user.organizationId, dto);
  }

  @Get()
  findAll(@CurrentUser() user: { organizationId: string }) {
    return this.productsService.findAll(user.organizationId);
  }

  @Get(':id')
  findOne(@CurrentUser() user: { organizationId: string }, @Param('id') id: string) {
    return this.productsService.findOne(user.organizationId, id);
  }

  @Patch(':id')
  update(
    @CurrentUser() user: { organizationId: string },
    @Param('id') id: string,
    @Body() dto: UpdateProductDto,
  ) {
    return this.productsService.update(user.organizationId, id, dto);
  }

  @Delete(':id')
  remove(@CurrentUser() user: { organizationId: string }, @Param('id') id: string) {
    return this.productsService.remove(user.organizationId, id);
  }
}
