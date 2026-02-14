package db

import (
	"context"
	"fmt"

	"{{MODULE_NAME}}/internal/db/sqlc"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Store struct {
	*sqlc.Queries
	db *pgxpool.Pool
}

func NewStore(db *pgxpool.Pool) *Store {
	return &Store{
		db:      db,
		Queries: sqlc.New(db),
	}
}

func (store *Store) ExecTx(ctx context.Context, fn func(*sqlc.Queries) error) error {
	tx, err := store.db.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return err
	}

	queries := sqlc.New(tx)
	err = fn(queries)

	if err != nil {
		if rbErr := tx.Rollback(ctx); rbErr != nil {
			return fmt.Errorf("tx error: %v, rollback error: %v", err, rbErr)
		}
		return err
	}

	return tx.Commit(ctx)
}
