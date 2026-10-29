FROM python:3.10-slim
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user PATH=/home/user/.local/bin:$PATH PYTHONUNBUFFERED=1 PORT=7860 AETHER_LOCAL_FALLBACK=0 AETHER_MAX_ENGINES=24 AETHER_MAX_JOBS=4
WORKDIR /home/user/app
COPY --chown=user source.zip .
RUN python -m zipfile -e source.zip . && python -c "from pathlib import Path; Path('source.zip').unlink()"
RUN pip install --no-cache-dir --user -r requirements.txt
RUN mkdir -p data/runtime/sessions
EXPOSE 7860
CMD ["python", "run_web_server.py", "--host", "0.0.0.0"]
