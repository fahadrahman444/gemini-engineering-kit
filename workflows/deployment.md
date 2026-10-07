# Deployment Workflow

## Steps

1. **Stack & Environment Detection:**
   - Detect application pattern (Compiled binary, JVM/.NET, Dynamic runtime, Docker, Static SPA) using `gemini-kit stack`.

2. **Pre-Deployment Verification:**
   - Run `gemini-kit verify` to ensure clean build and passing tests.
   - Verify environment configuration (`chmod 600 .env` owned by service user).

3. **Service Management & Reverse Proxy:**
   - Configure systemd unit or Docker Compose container.
   - Configure Nginx or Caddy reverse proxy with SSL certificate.

4. **Health Check Verification:**
   - Verify service is alive using `curl -sf http://127.0.0.1:<PORT>/healthz`.
