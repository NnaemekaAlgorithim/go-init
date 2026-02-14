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
  if [ $# -eq 0 ]; then
    print_error "Usage: $0 <project-name>"
    print_error "Example: $0 my-awesome-api"
    exit 1
  fi

  PROJECT_NAME="$1"
  MODULE_NAME="github.com/$(whoami)/${PROJECT_NAME}"

  print_header "🚀 Creating Go API: ${PROJECT_NAME}"

  create_project_structure "$PROJECT_NAME"
  cd "$PROJECT_NAME"

  render_all_templates "$MODULE_NAME" "$PROJECT_NAME"

  print_success "✅ Project created!"
  print_step "cd ${PROJECT_NAME}"
  print_step "cp .env.example .env"
  print_step "make sqlc"
  print_step "make dev"
  echo ""
  print_success "You're ready to write business logic!"
}

main "$@"
