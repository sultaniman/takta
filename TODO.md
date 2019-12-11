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
* ✅ Implement whiteboard resource,
  * ✅ Create separate folder for each user (by user id),
  * ✅ Upload/create whiteboard,
  * ✅ Delete whiteboard (only owner),
  * ✅ Get list of whiteboards,
  * ✅ View details of whiteboard,
* ✅ Implement comments & annotations resource,
  * ✅ Create comment,
    * ✅ Accept annotation coordinates,
    * ✅ Test it,
  * ✅ Update comment,
  * ✅ Delete comment,
* ❌ Implement memberships,
  * ❌ Create annotation,
  * ❌ Update annotation,
  * ❌ Delete annotation,
* ❌ Implement invites,
  * ❌ Create invite,
  * ❌ Update invite,
  * ❌ Delete invite,
* ✅ Permission manager,
  * ✅ Only owners of entities can update/delete,
  * ✅ Admins can update/delete any entity,
* ❌ Test if proper session set after social signin,
* ✅ Implement aws s3 uploader,
* ✅ Create initial test suites for authentication logic,
* ❌ Implement username & password sign in with token exchange,
* ❌ Implement linking social account and other login methods,
* ❌ Create unified error response format,

# Mailer

* ❌ Generate mailer app,
* ❌ Create gmail mailer app,
* ❌ Create minimal template to send invite,

# Cleanup & tech debt

* ❌ Implement verical slicing,

# Misc

* ✅ May be move mappers into context domain,
* ❌ Add missing tests
