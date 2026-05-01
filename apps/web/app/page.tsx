import Link from 'next/link';

const stats = [
  { label: 'Ventas', value: '24 hoy' },
  { label: 'Stock bajo', value: '8 productos' },
  { label: 'Tickets', value: '3 abiertos' },
];

const modules = [
  {
    title: 'POS y Ventas',
    description: 'Crea ventas, controla caja y revisa histórico en tiempo real.',
  },
  {
    title: 'Inventario',
    description: 'Mueve stock, detecta faltantes y protege tu operación.',
  },
  {
    title: 'Soporte y Suscripciones',
    description: 'Gestiona tickets, usuarios y planes desde un solo panel.',
  },
];

export default function HomePage() {
  return (
    <main className="shell page">
      <section className="hero">
        <div>
          <span className="kicker">MiPuesto · gestión comercial online</span>
          <h1>
            Tu negocio,
            <br />
            ordenado y listo para vender.
          </h1>
          <p className="lead">
            MiPuesto centraliza ventas, inventario, compras, tickets y suscripciones en una
            experiencia rápida, simple y lista para producción.
          </p>
          <div className="actions">
            <Link className="btn btn-primary" href="/auth/registro">
              Crear cuenta
            </Link>
            <Link className="btn btn-secondary" href="/auth/login">
              Iniciar sesión
            </Link>
          </div>
          <div className="grid-3">
            {stats.map((item) => (
              <div className="card" key={item.label}>
                <h3>{item.value}</h3>
                <p className="muted">{item.label}</p>
              </div>
            ))}
          </div>
        </div>
        <aside className="panel metrics">
          <div className="metric">
            <strong>Estado operativo</strong>
            <span className="muted">Todo conectado: frontend, API y base de datos.</span>
          </div>
          <div className="metric">
            <strong>API</strong>
            <span className="muted">/api/health, /api/auth, /api/products y más.</span>
          </div>
          <div className="metric">
            <strong>Deployment</strong>
            <span className="muted">Vercel + Render + Supabase.</span>
          </div>
        </aside>
      </section>

      <section className="section">
        <div className="toolbar">
          <h2>Qué incluye</h2>
          <span className="badge">Listo para crecer</span>
        </div>
        <div className="grid-3">
          {modules.map((module) => (
            <article className="card" key={module.title}>
              <h3>{module.title}</h3>
              <p className="muted">{module.description}</p>
            </article>
          ))}
        </div>
      </section>
    </main>
  );
}
