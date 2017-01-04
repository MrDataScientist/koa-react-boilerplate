.PHONY: install test run

PGUSER ?= postgres
PGHOST ?= 127.0.0.1

install: install-npm install-dockers create-database-for-dev

test:
	@$(MAKE) drop-database-for-test
	@$(MAKE) create-database-for-test
	@$(MAKE) test-api
	@$(MAKE) test-frontend

run: run-api run-frontend

install-dockers:
	@if which docker > /dev/null; then\
		@echo "Installing Docker images";\
		docker run -d -p 5432:5432 postgres;\
	fi

install-npm:
	@echo 'Installing NPM'
	cd api && yarn
	cd frontend && yarn

create-database-for-dev:
	@echo "Create database dev"
	@createdb --user=${PGUSER} --host=${PGHOST} koa-restfull-db_dev || true

drop-database-for-dev:
	@echo "Drop database dev"
	@dropdb --user=${PGUSER} --host=${PGHOST} koa-restfull-db_dev || true

create-database-for-test:
	@echo "Create database test"
	@createdb --user=${PGUSER} --host=${PGHOST} koa-restfull-db_test || true

drop-database-for-test:
	@echo "Drop database test"
	@dropdb --user=${PGUSER} --host=${PGHOST} koa-restfull-db_test || true

generate-model:
	@echo 'Creating the $(MODEL) model'
	@./api/node_modules/.bin/sequelize model:create --name $(MODEL) \
		--attributes foo:string  --models-path ./api/app/models/ \
		--migrations-path ./api/db/migrations/

migrate:
	@echo 'Running Migrations'
	@./api/node_modules/.bin/sequelize db:migrate \
		--models-path ./api/app/models/ \
		--migrations-path ./api/db/migrations/ \
		--config ./api/config/database.json

run-api:
	@echo 'Start API'
	cd api && npm start

run-frontend:
	@echo 'Start Frontend'
	cd frontend && npm start

test-api:
	@echo 'Start API Tests'
	cd api && npm test

test-frontend:
	@echo 'Start Frontend Tests'
	cd frontend && npm test

build-frontend:
	@rm -rf ./frontend/public/assets/* || true
	@cd frontend && ./node_modules/.bin/webpack --progress -p -d

clean:
	@echo 'Delete node_modules directory'
	rm -rf api/node_modules
	rm -rf frontend/node_modules
