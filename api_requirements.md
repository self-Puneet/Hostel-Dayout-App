## 1. update the request document structure accordingly - only these fields has to be updated

  **before** 

  ```json
  "parent_action" : ["accepted", "rejected"]
  "assitent_warden_action" {
      "action_by" : "",
      "action": ["cancelled", "accepted"], 
  },
  "senior_warden_action" {
      "action_by": "",
      "action": ["rejected" , "accepted"],
  },
  "security_guard_action" {
      "action_by" : "",
      "action" :["in" , "out"],
  }
  "student_action" {
      "action": ["cancelled" ]
  }
  ```
**after** 
```json
"parent_action" : {
  "action_by" : "", 
  "action" : ["accepted", "rejected"],
  "action_at" : "", //timestamp
}
"assitent_warden_action" :{
  "action_by" : "", 
  "action" : ["accepted", "rejected"],
  "action_at" : "", //timestamp
},
"senior_warden_action" :{
  "action_by" : "", 
  "action" : ["accepted", "rejected"],
  "action_at" : "", //timestamp
},
"security_guard_action": {
  "action_by" : "", 
  "action" : ["accepted", "rejected"],
  "action_at" : "", //timestamp
}
"student_action": {
  "action" : ["cancecanl"],
  "action_at" : "", //timestamp
}
```
actions enums terminologies can be changed as you wish

## 2. inform about enums possible values for maintaining frontend and backend consistency

following fields of different collection which you have to share 
- request collection
  - parent_action's action
  - security_guard_action's action
  - assistent_warden_action's action
  - senior_warden_action's action
  - student_action's action
  - request_type
  - request_status (de diya)
  - security_status
- warden collection
  - warden_role

## 3. warden login - dynamically understanding if the warden i ssenior or assitent

## 4. 