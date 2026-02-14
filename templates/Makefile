dev:
	docker compose up --build

migrate-up:
	migrate -path migrations -database "$(shell grep DATABASE_URL .env | cut -d= -f2)" up

sqlc:
	sqlc generate

tidy:
	go mod tidy

test:
	go test ./... -race -v
