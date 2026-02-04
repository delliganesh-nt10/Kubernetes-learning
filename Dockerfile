# ---- Base image ----
FROM python:3.12-slim

# ---- System settings ----
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# ---- Workdir ----
WORKDIR /app

# ---- OS deps (mysql client libs) ----
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- Python deps ----
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- App code ----
COPY . .

# ---- Expose port ----
EXPOSE 5000

# ---- Run with Gunicorn ----
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "main:app"]
