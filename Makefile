ROOT_FOLDER=..
#PATH_BUILD=_build

REPOS=libs multisocketServer stageOrchestration stageViewer webMidiTools displayTrigger
#pentatonicHero voteBattle

DOCKER_BASE_IMAGES=alpine nginx:alpine node:alpine python:alpine
DOCKER_BUILD_VERSION=latest
DOCKER_PACKAGE=superlimitbreak
DOCKER_IMAGE_DISPLAYTRIGGER=${DOCKER_PACKAGE}/displaytrigger:${DOCKER_BUILD_VERSION}
DOCKER_IMAGE_SUBSCRIPTIONSERVER=${DOCKER_PACKAGE}/subscriptionserver:${DOCKER_BUILD_VERSION}
DOCKER_IMAGE_STAGEORCHESTRATION=${DOCKER_PACKAGE}/stageorchestration:${DOCKER_BUILD_VERSION}
DOCKER_IMAGES=${DOCKER_IMAGE_DISPLAYTRIGGER} ${DOCKER_IMAGE_SUBSCRIPTIONSERVER} ${DOCKER_IMAGE_STAGEORCHESTRATION}


.PHONY: help
help:
	# superLimitBreak system setup
	#  - build            - Build docker images
	#  - push             - Push docker images to dockerhub
	#  - run              - Use docker-compose to run from docker images
	#  - run_local        - Use docker-compose to run from local source
	#  - clean            - Delete all repos and docker images
	# helpers
	#  - clone            - checkout all repos
	#  - install          - clone and install/setup all repos
	#  - pull             - `git pull` all repos
	#
	# REPOS="${REPOS}"
	# IMAGES=""${DOCKER_IMAGES}""

# Clone/Install ----------------------------------------------------------------

.PHONY: install
install: clone
	make install --directory ${ROOT_FOLDER}/displayTrigger/trigger/

.PHONY: clone
clone: ${ROOT_FOLDER}/libs ${ROOT_FOLDER}/multisocketServer ${ROOT_FOLDER}/stageOrchestration ${ROOT_FOLDER}/stageViewer ${ROOT_FOLDER}/webMidiTools ${ROOT_FOLDER}/displayTrigger
#clone: libs displayTrigger stageOrchestration stageViewer webMidiTools

# Repos ------------------------------------------------------------------------
libs: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/libs:
	cd ${ROOT_FOLDER} ; git clone https://github.com/calaldees/libs.git

multisocketServer: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/multisocketServer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/multisocketServer.git

displayTrigger: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/displayTrigger:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/displayTrigger.git
	#make install --directory ${ROOT_FOLDER}/$@

stageOrchestration: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/stageOrchestration:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/stageOrchestration.git
	#make install --directory ${ROOT_FOLDER}/$@

stageViewer: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/stageViewer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/stageViewer.git
	#make install --directory ${ROOT_FOLDER}/$@

webMidiTools: ${ROOT_FOLDER}/$@
	ln -s ${ROOT_FOLDER}/$@
${ROOT_FOLDER}/webMidiTools:
	cd ${ROOT_FOLDER} ; git clone https://github.com/superLimitBreak/webMidiTools.git

#pentatonicHero:
#	git clone https://github.com/SuperLimitBreak/pentatonicHero.git

#voteBattle:
#	git clone https://github.com/SuperLimitBreak/voteBattle.git
#	cd voteBattle/server; make install


# docker-compose.yml builder ---------------------------------------------------

config_merger.py:
	curl https://raw.githubusercontent.com/calaldees/config-merger/master/config_merger.py -o $@

# Build hybrid docker-compose.yml
# UNFINISHED!
DOCKER_COMPOSE_PATHS=displayTrigger/server stageOrchistration stageViewer
docker-compose.yml: config_merger.py
	for PATH_DOCKER_COMPOSE in ${DOCKER_COMPOSE_PATHS}; do\
		${ROOT_FOLDER}/$$PATH_DOCKER_COMPOSE ;\
	done


# Build ------------------------------------------------------------------------

.PHONY: build
build: install
	docker build -t ${DOCKER_IMAGE_DISPLAYTRIGGER} --file displaytrigger.dockerfile ${ROOT_FOLDER}
	${MAKE} build --directory ${ROOT_FOLDER}/multisocketServer
	${MAKE} build --directory ${ROOT_FOLDER}/stageOrchestration
	#docker build -t ${DOCKER_IMAGE_SUBSCRIPTIONSERVER} --file ${ROOT_FOLDER}/multisocketServer/server/ ${ROOT_FOLDER}/multisocketServer/server/
	#docker build -t ${DOCKER_IMAGE_STAGEORCHESTRATION} --file ${ROOT_FOLDER}/stageOrchestration/Dockerfile ${ROOT_FOLDER}/stageOrchestration

.PHONY: push
push:
	# TODO: call sub Makefiles?
	for DOCKER_IMAGE in ${DOCKER_IMAGES}; do\
		docker push $$DOCKER_IMAGE ;\
	done

# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	for REPO in ${REPOS}; do\
		echo "Pulling $$REPO" ;\
		cd ${ROOT_FOLDER}/$$REPO ; git pull ;\
	done
	for DOCKER_BASE_IMAGE in ${DOCKER_BASE_IMAGES}; do\
		docker pull $$DOCKER_BASE_IMAGE ;\
	done

# Run --------------------------------------------------------------------------

.PHONY: run
run:
	docker-compose up

.PHONY: run_local
run_local: install
	# TODO - unfinished concept
	docker-compose \
		--file ${ROOT_FOLDER}/displayTrigger/server/docker-compose.yml \
		--file ${ROOT_FOLDER}/stageOrchistration/docker-compose.yml \
		--file ${ROOT_FOLDER}/stageViewer/docker-compose.yml \
		up

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
