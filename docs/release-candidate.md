# Release candidate v1.0.1

Status: prepared, not published. Publish only after the exact PR head passes CI and the owner approves merge/release. Existing tags must not move.

Distribution: complete source archive. This candidate includes all changes on main since v1.0.0, plus pinned GitHub Actions and review-first dependency updates. This is not an npm/PyPI publication.

Install into a fresh temporary environment from the built archive, not an editable checkout. Run the documented offline core command/fixture before publishing; do not enable profiles, contact paid providers or start services. After release, download the exact public artifact and repeat this check.

Rollback: close the unmerged PR; after merge, submit a revert PR. Do not rewrite the release tag or delete old artifacts. A bad release must be superseded and clearly marked, with owner approval.
