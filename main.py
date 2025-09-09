# main.py (patched excerpt)
import os
from datetime import datetime, timezone
from fastapi import FastAPI, HTTPException, Query
from dotenv import load_dotenv
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, ServerSelectionTimeoutError
from bson import ObjectId
from typing import Any, Dict

load_dotenv()
MONGODB_URI = os.getenv("STRING")
if not MONGODB_URI:
    raise RuntimeError("MONGODB_URI is not set in the environment")

client = MongoClient(MONGODB_URI, serverSelectionTimeoutMS=5000)
db = client["Hostel-Leave"]
parents_col = db["parents"]
requests_col = db["requests"]

app = FastAPI()

def to_iso_z(value: Any) -> Any:
    if isinstance(value, datetime):
        if value.tzinfo is None:
            value = value.replace(tzinfo=timezone.utc)
        return value.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")
    if isinstance(value, dict) and "$date" in value:
        try:
            dt = datetime.fromisoformat(str(value["$date"]).replace("Z", "+00:00"))
            return dt.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")
        except Exception:
            return str(value["$date"])
    return value

def deep_sanitize(obj: Any) -> Any:
    if isinstance(obj, ObjectId):
        return str(obj)
    if isinstance(obj, datetime):
        return to_iso_z(obj)
    if isinstance(obj, dict):
        return {k: deep_sanitize(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple, set)):
        return [deep_sanitize(v) for v in obj]
    return obj

@app.on_event("startup")
def startup_event():
    try:
        client.admin.command("ping")
    except (ConnectionFailure, ServerSelectionTimeoutError) as e:
        raise RuntimeError(f"MongoDB not available: {e}") from e

@app.get("/get-parent-requests")
def get_parent_requests(parent_id: str = Query(..., description="Parent identifier, e.g., PAR_xxxxxxxx")):
    try:
        # 1) Find parent(s) and collect enrollment numbers
        parents = list(parents_col.find({"parent_id": parent_id}))
        enrollment_set = set()
        for p in parents:
            for num in p.get("student_enrollment_no") or []:
                if isinstance(num, str) and num.strip():
                    enrollment_set.add(num.strip())

        if not enrollment_set:
            return {"messages": "", "requests": []}

        # 2) Fetch requests for those enrollments
        cursor = requests_col.find(
            {"student_enrollment_number": {"$in": list(enrollment_set)}}
        ).limit(200)

        # 3) Deep-sanitize documents for JSON and Dart mapping
        requests_out = [deep_sanitize(doc) for doc in cursor]

        return {"messages": "", "requests": requests_out}

    except (ConnectionFailure, ServerSelectionTimeoutError) as e:
        raise HTTPException(status_code=503, detail=f"Database error: {e}")
