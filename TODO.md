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
  * ✅ Comment on whiteboard,
  * ✅ Create member for whiteboard,
* ✅ Implement comments & annotations resource,
  * ✅ Create comment,
    * ✅ Accept annotation coordinates,
    * ✅ Test it,
    * ✅ Respect membership flags (to annotate, comment),
  * ✅ Update comment,
  * ✅ Delete comment,
* ✅ Implement memberships,
  * ✅ Create memberships,
  * ✅ Get membership details,
  * ✅ Update memberships,
  * ✅ Delete memberships,
* ❌ Implement invites,
  * ✅ Create invite,
  * ✅ Get all invites for current user,
  * ✅ Get invite details,
  * ❌ Send invite when membership created,
  * ❌ Invite by email,
  * ❌ Activate newly created user if was invited by email,
  * ✅ Delete invite,
* ❌ Implement collections
  * ✅ Create collections context,
  * ❌ Create default collection when user created,
  * ✅ Get collection details,
  * ✅ Get whiteboards for collection,
  * ✅ Update collections,
  * ✅ Delete collections,
  * ✅ Add whiteboards to collection,
  * ✅ Write collection resource tests,
* ✅ Permission manager,
  * ✅ Only owners of entities can update/delete,
  * ✅ Admins can update/delete any entity,
* ✅ Implement aws s3 uploader,
* ✅ Create initial test suites for authentication logic,
* ✅ Create unified error response format,

# Mailer

* ✅ Generate mailer app,
* ✅ Create gmail mailer app,
* ❌ Create minimal templates to send invite,

# Cleanup & tech debt

* ✅ Implement verical slicing,
* ✅ Apply vertical slicing,

# Misc

* ✅ May be move mappers into context domain,
* ❌ Test if proper session set after social signin,
* ❌ Implement linking social account and other login methods,
* ❌ Add missing tests
