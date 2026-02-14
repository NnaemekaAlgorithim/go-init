#!/bin/bash

create_project_structure() {
  local name=$1
  mkdir -p "$name"/{cmd/api,internal/{config,db/sqlc,handler,middleware,model,repository,service},migrations,queries}
  print_success "Created folder structure for $name"
}
