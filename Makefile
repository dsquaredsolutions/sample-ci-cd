REPO_VERSION ?= $(shell git rev-parse --git-dir > /dev/null 2>&1 && git fetch -q origin --tags && git describe --always --dirty --tags)
REPO_REV ?= $(shell git rev-parse --git-dir > /dev/null 2>&1 && git rev-parse HEAD 2>/dev/null)
BUILD_DATE := $(shell date -u +%FT%T)
TEST_PKGS := $(shell find . -name "*_test.go" -not -wholename "*/vendor/*" -exec dirname {} \; | uniq)
PRIV_KEY := $(shell cat priv.key)
export

build:
	@mkdir -p build/usr/bin
	go build -a -ldflags "\
		-X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.gitVersion=${REPO_VERSION}\"\
		-X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.gitRevision=${REPO_REV}\"\
		-X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.date=${BUILD_DATE}\"\
	" -v -o build/usr/bin/sample-ci-cd $(shell pwd)

docker:
	docker build \
	--build-arg VERSION=${REPO_VERSION} \
	--build-arg REPO_REV=${REPO_REV} \
	--build-arg DATE=${BUILD_DATE} \
	-t dsquaredsolutions/sample-ci-cd:${REPO_VERSION} \
	-t dsquaredsolutions/sample-ci-cd:latest \
	.

test:
	go test -v -p 1 -race ${FLAGS} ${TEST_PKGS}

publish:
	docker login -u dsquaredsolutions -p ${DOCKER_TOKEN}
	docker push dsquaredsolutions/sample-ci-cd:${REPO_VERSION}
	docker push dsquaredsolutions/sample-ci-cd:latest

deploy_dev:
	(cd tf/dev ; make all)

deploy_prod:
	(cd tf/prod ; make all)

clean:
	rm -rf build/

.PHONY: clean test