'use client';

import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { apiFetch } from '../../lib/api';

export default function RegisterPage() {
  const router = useRouter();
  const [organizationName, setOrganizationName] = useState('');
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError('');
    setLoading(true);

    try {
      const result = await apiFetch<{ accessToken: string }>('/auth/register', {
        method: 'POST',
        body: JSON.stringify({ organizationName, fullName, email, password }),
      });

      localStorage.setItem('mipuesto_access_token', result.accessToken);
      router.push('/dashboard');
    } catch {
      setError('No pudimos crear la cuenta. Revisa los datos e inténtalo otra vez.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="shell page">
      <section className="hero hero-small">
        <div>
          <span className="kicker">Crear organización</span>
          <h1>Registro</h1>
          <p className="lead">Crea tu empresa y entra al sistema en segundos.</p>
          <form className="form section" onSubmit={handleSubmit}>
            <label className="field">
              <span>Organización</span>
              <input value={organizationName} onChange={(event) => setOrganizationName(event.target.value)} />
            </label>
            <label className="field">
              <span>Nombre completo</span>
              <input value={fullName} onChange={(event) => setFullName(event.target.value)} />
            </label>
            <label className="field">
              <span>Email</span>
              <input value={email} onChange={(event) => setEmail(event.target.value)} type="email" />
            </label>
            <label className="field">
              <span>Contraseña</span>
              <input
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                type="password"
              />
            </label>
            {error ? <p className="badge">{error}</p> : null}
            <button className="btn btn-primary" type="submit" disabled={loading}>
              {loading ? 'Creando...' : 'Crear cuenta'}
            </button>
          </form>
          <p className="muted section">
            ¿Ya tenés cuenta? <Link href="/auth/login">Entrar</Link>
          </p>
        </div>
      </section>
    </main>
  );
}
