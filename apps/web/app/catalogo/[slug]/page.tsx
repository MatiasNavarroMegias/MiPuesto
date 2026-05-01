import Link from 'next/link';

const products = [
  { name: 'Combo desayuno', price: '$3.50', stock: '24 unidades' },
  { name: 'Bebida energética', price: '$1.80', stock: '12 unidades' },
  { name: 'Snack premium', price: '$2.20', stock: '8 unidades' },
];

export default function CatalogPage({ params }: { params: { slug: string } }) {
  const { slug } = params;

  return (
    <main className="shell page">
      <section className="hero hero-small">
        <div>
          <span className="kicker">Catálogo público</span>
          <h1>{slug}</h1>
          <p className="lead">Vitrine mínima para mostrar productos y mantener el flujo visible online.</p>
          <div className="actions">
            <Link className="btn btn-primary" href="/auth/login">
              Administrar
            </Link>
            <Link className="btn btn-secondary" href="/">
              Volver al inicio
            </Link>
          </div>
        </div>
      </section>

      <section className="section">
        <div className="toolbar">
          <h2>Productos destacados</h2>
          <span className="badge">Ruta: /catalogo/{slug}</span>
        </div>
        <div className="grid-3">
          {products.map((product) => (
            <article className="card" key={product.name}>
              <h3>{product.name}</h3>
              <p className="muted">{product.stock}</p>
              <p>{product.price}</p>
            </article>
          ))}
        </div>
      </section>
    </main>
  );
}
