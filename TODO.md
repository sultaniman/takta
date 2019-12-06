# TODO

## Auth

* ✅ Split magic tokens into separate module,
* ✅ Use sessions module only to manage session related logic,

## Web

* ✅ Once token is valid then lookup valid active session and set it,
* ✅ If not found create new session entry,
* ✅ Implement auth/session plug,
* ✅ Implement session plug to attach current user to request,
* ✅ Implement social auth sign in with token exchange,
* ✅ Extract session helpers from magic controller,
* ✅ Configure storage for development (local folder), testing (local folder) and production (aws s3),
* ❌ Implement whiteboard resource,
  * ✅ Create separate folder for each user (by user id),
  * ✅ Upload/create whiteboard,
  * ❌ Delete whiteboard,
  * ❌ View details of whiteboard,
* ❌ Implement comments & annotations resource,
  * ❌ Create comment,
  * ❌ Update comment,
  * ❌ Delete comment,
* ❌ Implement memberships,
  * ❌ Create membership,
  * ❌ Update membership,
  * ❌ Delete membership,
* ❌ Implement invites,
  * ❌ Create invite,
  * ❌ Update invite,
  * ❌ Delete invite,
* ❌ Test if proper session set after social signin,
* ✅ Implement aws s3 uploader,
* ✅ Create initial test suites for authentication logic,
* ❌ Implement username & password sign in with token exchange,
* ❌ Implement linking social account and other login methods,
