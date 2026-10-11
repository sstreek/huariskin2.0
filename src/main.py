from fastapi import FastAPI
from fastapi.templating import Jinja2Templates

app = FastAPI()
templates = Jinja2Templates(directory="src/templates")

# Routes will be registered here as we build each feature, e.g.:
# from src.routes import shelf, profile, routine
# app.include_router(shelf.router)


# Cloudflare Workers calls this function for every incoming HTTP request.
# The `env` object gives you access to bindings like env.DB (your D1 database).
async def on_fetch(request, env):
    import asgi
    return await asgi.fetch(app, request, env)
