# Tentura

Social network based on MeritRank

## How to build

Tentura uses GraphQL codegen. So, before building the project as usual,
        run the codegenerator:

```bash
dart run build_runner build -d

```

To make database scheme diff run:

```
dart run drift_dev schema dump lib/data/database/database.dart drift_schemas/
```
