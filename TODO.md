# TODO

## Auth

* ✅ Split magic tokens into separate module,
* ✅ Use sessions module only to manage session related logic,

## Web

* ✅ Once token is valid then lookup valid active session and set it,
* ✅ If not found create new session entry
* ❌ Implement auth/session plug,
* ❌ Implement session plug to attach current user to request,
* ❌ Implement social auth sign in with magic token exchange,
* ❌ Extract session helpers from magic controller,