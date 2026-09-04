"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setLoading(true);
    setError("");
    const { error: signInError } = await createClient().auth.signInWithPassword({ email, password });
    if (signInError) setError(signInError.message);
    else router.replace("/");
    setLoading(false);
  }

  return <main className="auth-shell"><form className="auth-card" onSubmit={submit}><span className="eyebrow">NORTHSTAR / SIGN IN</span><h1>Welcome back</h1><p>Return to your visual workspace.</p><label>Email<input type="email" value={email} onChange={(event) => setEmail(event.target.value)} required /></label><label>Password<input type="password" value={password} onChange={(event) => setPassword(event.target.value)} required /></label>{error && <div className="auth-error" role="alert">{error}</div>}<button className="auth-submit" disabled={loading}>{loading ? "Signing in..." : "Sign in"}</button><Link href="/forgot-password">Forgot password?</Link><span className="auth-switch">New here? <Link href="/signup">Create an account</Link></span></form></main>;
}
