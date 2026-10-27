# Dependency maintenance

Dependabot opens weekly review-first pull requests for the applicable manifests and GitHub Actions. There is no auto-merge. Keep existing SHA pins and review upstream changes before accepting updates.

No installable runtime dependency graph is declared in this repository. Metadata-only package.json files and commands suggested by bundled documentation are not a lockfile. Do not add a meaningless npm/pip audit; review external tools separately before installing them. GitHub Actions updates still apply.
