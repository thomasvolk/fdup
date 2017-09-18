
all: unit-tests integration-test

unit-tests:
	mix test

integration-test: compile
	@echo "--- Duplicate: "
	./fdup test_data
	@echo "  - groups:"
	./fdup test_data --mode duplicate --group 1
	@echo "--- Unique:"
	./fdup test_data --mode unique
	@echo "  - groups:"
	./fdup test_data --mode unique --group 1

compile:
	mix escript.build

clean:
	mix clean
	rm -rf _build
