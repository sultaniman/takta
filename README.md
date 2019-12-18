# Takta whiteboards

# TODO

## Core
* [x] Create mailer app and confgure Bamboo,
* [ ] Invite by email,
* [ ] Activate newly created user if was invited by email,
* [ ] Create default collection when user created,
* [ ] Adjust invite resource to follow the latest changes in context,

Creating invite accepts
  * Accept permissions,
  * Whiteboard or collection,
  * Accept email
    * If does not exist, then create
  * Send email at the end.

If invite was accepted and user inactive
Then activate user,
And generate magic token for session exchange login.

## Docs
* [ ] Write configuration & operational documentation,
* [ ] Document business logic in sources,

## Misc
* [ ] Test if proper session set after social signin,
* [ ] Implement linking social account and other login methods,
* [ ] Add missing tests
