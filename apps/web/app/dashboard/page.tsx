'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { apiFetch } from '../lib/api';

export default function DashboardPage() {
  const [plans, setPlans] = useState<Array<{ code: string; name: string; priceMonthly: number }>>([]);
  const [error, setError] = useState('');

  useEffect(() => {
    apiFetch<Array<{ code: string; name: string; priceMonthly: number }>>('/subscriptions/plans')
      .then(setPlans)
      .catch(() => setError('No pudimos cargar los planes.'));
  }, []);

  return (
    <main className="shell page">
      <section className="hero hero-small">
        <div>
          <span className="kicker">Panel operativo</span>
          <h1>Dashboard</h1>
          <p className="lead">Desde aquí controlás planes, usuarios, inventario y ventas.</p>
          <div className="actions">
            <Link className="btn btn-primary" href="/catalogo/matias">
              Ver catálogo
            </Link>
            <Link className="btn btn-secondary" href="/auth/login">
              Cambiar sesión
            </Link>
          </div>
        </div>
      </section>

      <section className="section">
        <div className="toolbar">
          <h2>Planes</h2>
          <span className="badge">/api/subscriptions/plans</span>
        </div>
        {error ? <p className="badge">{error}</p> : null}
        <table className="table">
          <thead>
            <tr>
              <th>Código</th>
              <th>Nombre</th>
              <th>Precio mensual</th>
            </tr>
          </thead>
          <tbody>
            {plans.map((plan) => (
              <tr key={plan.code}>
                <td>{plan.code}</td>
                <td>{plan.name}</td>
                <td>${plan.priceMonthly.toFixed(2)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </main>
  );
}
