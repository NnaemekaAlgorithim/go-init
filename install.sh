#!/bin/bash
set -euo pipefail

# Detect if run via curl | bash or from cloned repo
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "❌ Do not source this script. Run it directly."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all library functions
for lib in "$SCRIPT_DIR"/lib/*.sh; do
  # shellcheck source=/dev/null
  source "$lib"
done

main() {
  local github_user=""
  local project_name=""
  local auto_init_mod="n"
  local install_tools="n"

  print_header "🚀 Go + Postgres + sqlc + Docker project bootstrap"

  # ──────────────────────────────────────────────────────────────
  # Interactive / non-interactive input collection (unchanged)
  # ──────────────────────────────────────────────────────────────
  if [ $# -eq 0 ]; then
    read -p "Enter project name (e.g. my-new-api): " project_name
    project_name=$(echo "$project_name" | tr -s ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')
    if [ -z "$project_name" ]; then
      print_error "Project name is required."
      exit 1
    fi

    read -p "Enter your GitHub username (for module path): " github_user
    github_user=$(echo "$github_user" | tr -d '[:space:]')
    if [ -z "$github_user" ]; then
      print_error "GitHub username is required for proper module path."
      exit 1
    fi

    read -p "Initialize Go module now? (y/n): " auto_init_mod
    auto_init_mod=${auto_init_mod:-n}

    read -p "Install sqlc & migrate globally + tidy dependencies? (y/n): " install_tools
    install_tools=${install_tools:-n}
  else
    project_name="$1"
    project_name=$(echo "$project_name" | tr -s ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

    github_user=$(git config --get user.name 2>/dev/null || echo "")
    if [ -z "$github_user" ]; then
      github_user=$(whoami)
    fi
    echo "Using detected/fallback GitHub username: $github_user"
  fi

  MODULE_NAME="github.com/${github_user}/${project_name}"

  print_header "Creating project: ${project_name}"
  print_step "Module path will be: ${MODULE_NAME}"

  create_project_structure "$project_name"
  cd "$project_name" || exit 1

  render_all_templates "$MODULE_NAME" "$project_name"

  # ──────────────────────────────────────────────────────────────
  # Optional Go initialization — now calling functions from lib/
  # ──────────────────────────────────────────────────────────────
  if [[ "$auto_init_mod" =~ ^[Yy]$ ]]; then
    # shellcheck source=/dev/null
    source "${SCRIPT_DIR}/lib/go_init.sh"
    go_init_module "${MODULE_NAME}"
  fi

  if [[ "$install_tools" =~ ^[Yy]$ ]]; then
    # shellcheck source=/dev/null
    source "${SCRIPT_DIR}/lib/go_init.sh"
    go_install_tools_and_tidy
  fi

  print_success "✅ Project created successfully!"
  echo ""
  print_step "cd ${project_name}"
  print_step "cp .env.example .env"

  # Only remind about init if we didn't do it
  if [[ ! "$auto_init_mod" =~ ^[Yy]$ ]]; then
    print_step "go mod init ${MODULE_NAME}          # if you want to do it later"
  fi

  print_step "make sqlc"
  print_step "make dev"
  echo ""
  print_success "Ready to write business logic!"
}

main "$@"

main "$@"
