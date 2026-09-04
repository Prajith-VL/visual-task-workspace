"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function SignupPage() {
  const router = useRouter();
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmation, setConfirmation] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!/^[a-zA-Z0-9_]{3,32}$/.test(username)) return setError("Username must be 3-32 letters, numbers, or underscores.");
    if (password !== confirmation) return setError("Passwords do not match.");
    setLoading(true);
    setError("");
    const supabase = createClient();
    const { data, error: signUpError } = await supabase.auth.signUp({ email, password, options: { data: { username } } });
    if (signUpError) setError(signUpError.message);
    else if (data.user && data.session) router.replace("/");
    else setError("Check your email to confirm your account, then sign in.");
    setLoading(false);
  }

  return <main className="auth-shell"><form className="auth-card" onSubmit={submit}><span className="eyebrow">NORTHSTAR / CREATE ACCOUNT</span><h1>Make space for the work.</h1><p>Your projects, notes, and next steps in one visual place.</p><label>Username<input value={username} onChange={(event) => setUsername(event.target.value)} required autoComplete="username" /></label><label>Email<input type="email" value={email} onChange={(event) => setEmail(event.target.value)} required autoComplete="email" /></label><label>Password<input type="password" minLength={6} value={password} onChange={(event) => setPassword(event.target.value)} required autoComplete="new-password" /></label><label>Confirm password<input type="password" minLength={6} value={confirmation} onChange={(event) => setConfirmation(event.target.value)} required autoComplete="new-password" /></label>{error && <div className="auth-error" role="alert">{error}</div>}<button className="auth-submit" disabled={loading}>{loading ? "Creating account..." : "Create account"}</button><span className="auth-switch">Already have an account? <Link href="/login">Sign in</Link></span></form></main>;
}
