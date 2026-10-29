# Aether Harbor

The v.40 browser edition, preserving the v.39 game rules and world.
Python/FastAPI server with streaming narration and separate player campaigns.

## Hosting

Run a **single instance, single Uvicorn worker** using the supplied Dockerfile
or `pip install -r requirements.txt` followed by `python run_web_server.py`.
`PORT` is supplied by the host. `GET /healthz` is the health check.
Disable local inference in hosting with `AETHER_LOCAL_FALLBACK=0`.

Configure model credentials as server environment variables, never in public
source. Players use the server's providers and do not supply API keys.

For durable saves, run `deploy/cloud_saves.sql` in a dedicated free Supabase
project and set `AETHER_SAVE_URL` to its HTTPS project URL and `AETHER_SAVE_KEY`
to its server-only service-role key. Set `AETHER_REQUIRE_CLOUD_SAVES=1` on Render
so missing configuration fails startup instead of silently using temporary saves.
The table and RPCs are inaccessible to anonymous and ordinary signed-in clients.

Each committed SQLite write, including background memory, creates a compressed,
versioned private checkpoint. Restarts restore the entire database, including
history, evidence and pending rolls. Optimistic revisions reject stale writes
from overlapping deployments. Failed uploads are visibly pending and block the
next action until saved. No local saves or logs are included in this repository.

Returning players must use the same browser with its session cookie intact.
There are no player accounts or cross-device recovery yet. Cookies renew for
one year. Clearing cookies or choosing Restart Campaign starts a new voyage.
Cloud persistence protects completed saves; a crash during inference may still
interrupt the current turn. It is not transactional replay of model calls.

Render Free sleeps when idle and can take about a minute to wake up. Supabase
Free can pause after a week of low activity; its owner must resume it if paused.
Free-plan limits apply. These are not guaranteed always-on services.

## Limits

Maximum checkpoint: 32 MiB uncompressed / 8 MiB compressed per browser session.
No automatic deletion of old player campaigns. Monitor the free storage quota;
when writes fail, the UI reports pending saves instead of claiming success.

## Source package

`source.zip` contains the complete runtime source, extracted by Docker during build.
`SOURCE_MANIFEST.json` records SHA-256 hashes for every source file.
No private credentials, player saves, or local debug logs are included.
