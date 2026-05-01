'use client';

import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { apiFetch } from '../../lib/api';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError('');
    setLoading(true);

    try {
      const result = await apiFetch<{ accessToken: string }>('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email, password }),
      });

      localStorage.setItem('mipuesto_access_token', result.accessToken);
      router.push('/dashboard');
    } catch {
      setError('No pudimos iniciar sesión. Revisa tus credenciales.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="shell page">
      <section className="hero hero-small">
        <div>
          <span className="kicker">Acceso seguro</span>
          <h1>Inicia sesión</h1>
          <p className="lead">Usa la cuenta de tu organización para entrar al panel.</p>
          <form className="form section" onSubmit={handleSubmit}>
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
              {loading ? 'Ingresando...' : 'Entrar'}
            </button>
          </form>
          <p className="muted section">
            ¿No tenés cuenta? <Link href="/auth/registro">Creala aquí</Link>
          </p>
        </div>
      </section>
    </main>
  );
}
