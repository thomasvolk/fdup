all: unit-tests integration-test release

REL=fdup.tar.gz

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

release: compile
	tar cfz $(REL) fdup

compile:
	mix escript.build

clean:
	mix clean
	rm -rf _build
	rm $(REL)
