#!/usr/bin/env bash
# lib/go_init.sh
# Contains guarded / optional Go module + tool setup logic

go_init_module() {
  local module_path="$1"

  print_step "Running go mod init ${module_path} ..."
  if ! command -v go >/dev/null 2>&1; then
    print_error "Go binary not found → skipping go mod init"
    return 1
  fi

  if go mod init "${module_path}" 2>/dev/null; then
    print_success "go mod init completed"
  else
    print_error "go mod init failed (network? already exists? Go version?) → continuing anyway"
  fi
}

go_install_tools_and_tidy() {
  print_step "Installing global tools (sqlc + migrate) ..."

  if ! command -v go >/dev/null 2>&1; then
    print_error "Go not found → skipping tool installation"
    return 1
  fi

  local failed=0

  go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest || {
    print_error "Failed to install sqlc"
    failed=1
  }

  go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest || {
    print_error "Failed to install golang-migrate"
    failed=1
  }

  if [ $failed -eq 0 ]; then
    print_step "Running go mod tidy ..."
    if go mod tidy; then
      print_success "go mod tidy completed"
    else
      print_error "go mod tidy failed → check network or go.mod issues"
    fi
  else
    print_error "Some tools failed to install → skipping tidy"
  fi
}
