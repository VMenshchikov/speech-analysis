.DEFAULT_GOAL := help

help: ## список доступных целей
	@echo "Доступные команды:"
	@awk 'BEGIN {FS = ":.*##"} \
		/^[a-zA-Z0-9_-]+:.*##/ { \
			printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 \
		} \
		/^[a-zA-Z0-9_-]+:/ && !/##/ { \
			split($$0, a, ":"); \
			printf "  \033[36m%-20s\033[0m (нет описания)\n", a[1] \
		}' $(MAKEFILE_LIST)


PROTO_BASE := proto/cloudapi/
THIRD_PARTY := $(PROTO_BASE)/third_party/googleapis
PROTO_FILES := \
	$(wildcard $(PROTO_BASE)/yandex/cloud/speechsense/v1/*.proto) \
	$(wildcard $(PROTO_BASE)/yandex/cloud/speechsense/v1/analysis/*.proto)
OUT_DIR := ./gen

generate: ## генерация bp
	mkdir -p gen
	protoc \
		--proto_path=$(PROTO_BASE) \
		--proto_path=$(THIRD_PARTY) \
		--go_out=$(OUT_DIR) \
		--go-grpc_out=$(OUT_DIR) \
		$(PROTO_FILES)

clean: ## очистка всех сгенерированных файлов
	rm -rd gen/*

