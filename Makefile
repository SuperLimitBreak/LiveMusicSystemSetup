ROOT_FOLDER=..

REPOS=\
	libs \
	webMidiTools \
	multisocketServer \
	mediaInfoService \
	mediaTimelineRenderer \
	stageOrchestration \
	displayTrigger \
	stageViewer \


DOCKER_BASE_IMAGES=\
	alpine \
	nginx:alpine \
	node:alpine \
	python:alpine \

# Annoyingly these imagenames must be in sync with the subrepos - consider a single point of truth
DOCKER_BUILD_VERSION=latest
DOCKER_PACKAGE=superlimitbreak
DOCKER_IMAGE_DISPLAYTRIGGER=${DOCKER_PACKAGE}/displaytrigger:${DOCKER_BUILD_VERSION}
DOCKER_IMAGE_DISPLAYTRIGGER_PRODUCTION=${DOCKER_PACKAGE}/displaytrigger:production
DOCKER_IMAGE_MEDIAINFOSERVICE=${DOCKER_PACKAGE}/mediainfoservice:${DOCKER_BUILD_VERSION}
DOCKER_IMAGE_MEDIATIMELINERENDERER=${DOCKER_PACKAGE}/mediatimelinerenderer:${DOCKER_BUILD_VERSION}
DOCKER_IMAGE_SUBSCRIPTIONSERVER=${DOCKER_PACKAGE}/subscriptionserver2:${DOCKER_BUILD_VERSION}
DOCKER_IMAGE_STAGEORCHESTRATION=${DOCKER_PACKAGE}/stageorchestration:${DOCKER_BUILD_VERSION}
DOCKER_IMAGES=\
	${DOCKER_IMAGE_SUBSCRIPTIONSERVER} \
	${DOCKER_IMAGE_MEDIAINFOSERVICE} \
	${DOCKER_IMAGE_MEDIATIMELINERENDERER} \
	${DOCKER_IMAGE_STAGEORCHESTRATION} \
	${DOCKER_IMAGE_DISPLAYTRIGGER} \
	${DOCKER_IMAGE_DISPLAYTRIGGER_PRODUCTION} \


.PHONY: help
help:
	# superLimitBreak system setup
	#  - build            - clone-repos/build docker images
	#  - push             - Push docker images to dockerhub
	#  - run              - Use docker-compose to run from docker images
	#  - run_local        - Use docker-compose to run from local data
	#  - clean            - Delete all repos and docker images
	# helpers
	#  - clone            - checkout all repos
	#  - pull             - `git pull` all repos
	#
	# REPOS="${REPOS}"
	# IMAGES=""${DOCKER_IMAGES}""

# Clone ------------------------------------------------------------------------

.PHONY: clone
clone: \
	${ROOT_FOLDER}/libs \
	${ROOT_FOLDER}/multisocketServer \
	${ROOT_FOLDER}/mediaInfoService \
	${ROOT_FOLDER}/mediaTimelineRenderer \
	${ROOT_FOLDER}/stageOrchestration \
	${ROOT_FOLDER}/stageViewer \
	${ROOT_FOLDER}/webMidiTools \
	${ROOT_FOLDER}/displayTrigger \

${ROOT_FOLDER}/.dockerignore:
	cp .dockerignore ${ROOT_FOLDER}/

# Repos ------------------------------------------------------------------------
libs: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/libs:
	cd ${ROOT_FOLDER} ; git clone https://github.com/calaldees/libs.git

mediaInfoService: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/mediaInfoService:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/mediaInfoService.git

mediaTimelineRenderer: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/mediaTimelineRenderer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/mediaTimelineRenderer.git

multisocketServer: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/multisocketServer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/multisocketServer.git

stageOrchestration: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/stageOrchestration:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/stageOrchestration.git

displayTrigger: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/displayTrigger:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/displayTrigger.git

stageViewer: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/stageViewer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/stageViewer.git

webMidiTools: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/webMidiTools:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/webMidiTools.git


# docker-compose.yml builder ---------------------------------------------------
# Build hybrid docker-compose.yml
# UNFINISHED!
# config_merger.py:
# 	curl https://raw.githubusercontent.com/calaldees/config-merger/master/config_merger.py -o $@
# DOCKER_COMPOSE_PATHS=displayTrigger/server stageOrchistration stageViewer
# docker-compose.yml: config_merger.py
# 	for PATH_DOCKER_COMPOSE in ${DOCKER_COMPOSE_PATHS}; do\
# 		${ROOT_FOLDER}/$$PATH_DOCKER_COMPOSE ;\
# 	done


# Build ------------------------------------------------------------------------

.PHONY: build
build: clone ${ROOT_FOLDER}/.dockerignore
	${MAKE} build --directory ${ROOT_FOLDER}/mediaInfoService
	${MAKE} build --directory ${ROOT_FOLDER}/mediaTimelineRenderer
	${MAKE} build --directory ${ROOT_FOLDER}/multisocketServer
	${MAKE} build --directory ${ROOT_FOLDER}/stageOrchestration
	docker build \
		-t ${DOCKER_IMAGE_DISPLAYTRIGGER} \
		--file Dockerfile \
		${ROOT_FOLDER}
	docker build \
		-t ${DOCKER_IMAGE_DISPLAYTRIGGER_PRODUCTION} \
		--file Dockerfile.production \
		--build-arg DISPLAYTRIGGER_IMAGENAME=${DOCKER_IMAGE_DISPLAYTRIGGER} \
		./

.PHONY: push
push:
	# TODO: call sub Makefiles?
	for DOCKER_IMAGE in ${DOCKER_IMAGES}; do\
		docker push $$DOCKER_IMAGE ;\
	done

# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	for DOCKER_BASE_IMAGE in ${DOCKER_BASE_IMAGES}; do\
		docker pull $$DOCKER_BASE_IMAGE ;\
	done
	for REPO in ${REPOS}; do\
		echo "Pulling $$REPO" ;\
		cd ${ROOT_FOLDER}/$$REPO ; git pull ;\
	done

# Run --------------------------------------------------------------------------

.PHONY: run
run:
	docker-compose up

.PHONY: run_local
run_local:
	docker-compose \
		--file docker-compose.yml \
		--file docker-compose.local.yml \
		up \
		--abort-on-container-exit \

# Run bare displaytrigger/multisocketserver without other containers
#  often used when developing stageOrcheatration locally
.PHONY: run_displaytrigger_local
run_displaytrigger_local:
	docker-compose \
		--file docker-compose.yml \
		--file docker-compose.local.yml \
		up \
		--exit-code-from displaytrigger \
		displaytrigger

.PHONY: run_production
run_production:
	docker-compose \
		--file docker-compose.production.yml \
		up

.PHONY: run_production_local
run_production_local:
	# TEMP!! Remove hard offset!
	STAGEORCHESTRATION_timeoffset_media_seconds='0.06465517241379311' \
	docker-compose \
		--file docker-compose.production.yml \
		--file docker-compose.local.yml \
		up \
		--abort-on-container-exit


# Cloc -------------------------------------------------------------------------

.PHONY: cloc
cloc:
	for REPO in ${REPOS}; do\
		echo "$$REPO" ;\
		${MAKE} cloc --directory ${ROOT_FOLDER}/$$REPO ;\
	done


# Clean ------------------------------------------------------------------------

.PHONY: clean_repos
clean_repos:
	for REPO in ${REPOS}; do\
		rm -rf ${ROOT_FOLDER}/$$REPO ;\
	done

.PHONY: clean
clean:
	for REPO in ${REPOS}; do\
		${MAKE} clean --directory $$REPO ;\
	done
	for DOCKER_IMAGE in ${DOCKER_IMAGES}; do\
		docker rmi $$DOCKER_IMAGE ;\
	done
