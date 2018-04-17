PACKAGENAME = auto-updater
RELEASE    ?= 0
VERSION    ?= 0.0

all: build rpm

build: clean
	@echo "Building $(PACKAGENAME)-$(VERSION)-$(RELEASE)"
	mkdir -p ./dist
	python setup.py sdist -d ./dist --formats=gztar
	python setup.py bdist_wheel -d ./dist --universal

clean:
	rm -rf dist/
	rm -rf rpm-build/

rpm:
	mkdir -p rpm-build
	cp dist/*.gz rpm-build
	cp dist/*.whl rpm-build
	ls -al rpm-build/

	rpmbuild \
	--define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_version ${VERSION}" \
	--define "_release ${RELEASE}" \
	--define '_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm' \
	--define "_specdir %{_topdir}" \
	--define "_sourcedir  %{_topdir}" \
	-bb auto-updater.spec
