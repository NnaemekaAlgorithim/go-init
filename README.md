# go-init

## Project Structure
```
go-init/
├── install.sh              # ← Main entry point (what users run)
├── lib/
│   ├── colors.sh           # Nice output
│   ├── utils.sh            # Shared helpers
│   ├── structure.sh        # Folder creation
│   ├── templates.sh        # Rendering templates
│   ├── go.sh               # Go-specific files (main, store, etc.)
│   └── docker.sh           # Docker + compose
├── templates/
│   ├── sqlc.yaml
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── .env.example
│   ├── Makefile
│   ├── cmd/api/main.go
│   ├── internal/db/db.go
│   ├── internal/db/store.go
│   ├── migrations/000001_create_users.up.sql
│   ├── migrations/000001_create_users.down.sql
│   └── queries/user.sql
├── README.md
├── LICENSE
└── .gitignore
```