# Kalendar API
![Kalendar](../frontend/public/images/kalendar.png)

## Install dependencies

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Serve API
```bash
uvicorn api:api --reload --host 0.0.0.0 --port 5000
```