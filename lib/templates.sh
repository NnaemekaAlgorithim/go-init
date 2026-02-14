#!/bin/bash

render_template() {
  local src=$1 dst=$2 project=$3 module=$4

  mkdir -p "$(dirname "$dst")"

  if [ ! -f "$src" ]; then
    print_error "Template missing: $src"
    return 1
  fi

  sed -e "s|{{PROJECT_NAME}}|$project|g" \
      -e "s|{{MODULE_NAME}}|$module|g" \
      "$src" > "$dst"

  print_success "Generated $(basename "$dst")"
}

render_all_templates() {
  local module=$1
  local project=$2

  require_command "go"   # just in case

  render_template "$SCRIPT_DIR/templates/sqlc.yaml" "sqlc.yaml" "$project" "$module"
  render_template "$SCRIPT_DIR/templates/Dockerfile" "Dockerfile" "$project" "$module"
  render_template "$SCRIPT_DIR/templates/docker-compose.yml" "docker-compose.yml" "$project" "$module"
  render_template "$SCRIPT_DIR/templates/.env.example" ".env.example" "$project" "$module"
  render_template "$SCRIPT_DIR/templates/Makefile" "Makefile" "$project" "$module"

  # Go files
  render_template "$SCRIPT_DIR/templates/cmd/api/main.go" "cmd/api/main.go" "$project" "$module"
  render_template "$SCRIPT_DIR/templates/internal/db/db.go" "internal/db/db.go" "$project" "$module"
  render_template "$SCRIPT_DIR/templates/internal/db/store.go" "internal/db/store.go" "$project" "$module"

  # Sample data
  cp -r "$SCRIPT_DIR/templates/migrations" ./
  cp -r "$SCRIPT_DIR/templates/queries" ./

  print_success "All templates rendered"
}
