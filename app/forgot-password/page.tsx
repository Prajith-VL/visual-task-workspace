"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { createClient } from "@/lib/supabase/client";

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");
    const { error: resetError } = await createClient().auth.resetPasswordForEmail(email, { redirectTo: `${window.location.origin}/login` });
    if (resetError) setError(resetError.message);
    else setMessage("If an account exists for that email, a reset link is on its way.");
  }

  return <main className="auth-shell"><form className="auth-card" onSubmit={submit}><span className="eyebrow">NORTHSTAR / RESET PASSWORD</span><h1>Reset your password</h1><p>We will send a secure reset link to your email.</p><label>Email<input type="email" value={email} onChange={(event) => setEmail(event.target.value)} required /></label>{error && <div className="auth-error" role="alert">{error}</div>}{message && <div className="auth-message" role="status">{message}</div>}<button className="auth-submit">Send reset link</button><Link href="/login">Back to sign in</Link></form></main>;
}
