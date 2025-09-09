# test_main.py
from fastapi.testclient import TestClient
from main import app

def test_get_parent_requests_real():
    parent_id = "PAR_b847ca58"  # adjust to an ID existing in your DB
    with TestClient(app) as client:  # ensures startup/shutdown run
        resp = client.get("/get-parent-requests", params={"parent_id": parent_id})
        print("Status:", resp.status_code)
        data = resp.json()
        print("Response JSON:", data)

        assert resp.status_code == 200
        assert isinstance(data, dict), f"Top-level is not dict: {type(data)}"
        assert "requests" in data, "Missing 'requests' key"
        assert isinstance(data["requests"], list), f"'requests' is not a list: {type(data['requests'])}"

        bad_items = []
        for idx, item in enumerate(data["requests"]):
            if not isinstance(item, dict):
                bad_items.append((idx, type(item).__name__, item))
        if bad_items:
            print("Non-dict entries found in 'requests':", bad_items)
        assert not bad_items, "Found non-dict item(s) in 'requests'"

        # Now validate representative fields on the first item (if any)
        if data["requests"]:
            item0 = data["requests"]
            assert isinstance(item0.get("_id", ""), str)
            # These fields should be strings if present
            for k in ["applied_from", "applied_to", "applied_at", "last_updated_at", "updated_at"]:
                if k in item0 and item0[k] is not None:
                    assert isinstance(item0[k], str)

if __name__ == "__main__":
    test_get_parent_requests_real()
