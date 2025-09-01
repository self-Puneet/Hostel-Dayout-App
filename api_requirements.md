# :satellite: API Requirements

## :arrows_counterclockwise: 1. Update Request Status Enum

Add a new status in RequestStatus  `student_canceled`

## :pushpin: 2. Give me all the valid status strings. which I will pass into the status fields in upcomming apis payload and will be accepted by you api for all request status.

## :pushpin: 2. Get Latest Requests

**Endpoint:**

```
GET /api/requests/latest
```

**Requirement:**

* Return the **most recent** request of each type:

  * accepted
  * rejected
  * student\_canceled


## :pushpin: 3. Get All Active Requests

**Endpoint:**

```
GET /api/requests/active
```

**Requirement:**

* Return all **active requests** of a student.

---

## :pushpin: 4. Get Requests by Status List

**Endpoint:**

```
POST /api/requests/by-status
```

**Requirement:**

* Accept a list of statuses.
* Return all requests whose status is in that list.
* If list is `null` or empty → return **all requests**.
* I will pass valid status string as given by you.

## parent login

## reset password functionality - uss gande se password se mai thak gaya