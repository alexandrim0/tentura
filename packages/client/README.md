# Tentura

Social network based on MeritRank

## How to build

Tentura uses GraphQL codegen. So, before building the project as usual,
        run the codegenerator:

```bash
flutter gen-l10n

dart run build_runner build -d

flutter build web --wasm --pwa-strategy=none --source-maps --dart-define-from-file=.env --dart-define NEED_INVITE_CODE=true --dart-define SERVER_NAME=https://app.tentura.io --dart-define IMAGE_SERVER=https://static.tentura.io
```

To make database migration:
 - increment `schemaVersion` at Database
 - then run:
```
dart run drift_dev make-migrations
```
