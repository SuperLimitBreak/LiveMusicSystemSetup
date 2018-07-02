ROOT_FOLDER=..
PATH_BUILD=_build

REPOS=libs stageOrchestration stageViewer webMidiTools displayTrigger
#pentatonicHero voteBattle

.PHONY: help
help:
	# superLimitBreak system setup
	#  - install          - Install and setup all repos
	#  - run              - Use docker-compose to run all containers
	#  - pull             - Update all repos
	#  - clean            - Delete all repos

# Install ----------------------------------------------------------------------

.PHONY: install
install: clone

.PHONY: clone
clone: ${ROOT_FOLDER}/libs ${ROOT_FOLDER}/stageOrchestration ${ROOT_FOLDER}/stageViewer ${ROOT_FOLDER}/webMidiTools ${ROOT_FOLDER}/displayTrigger

config_merger.py:
	curl https://raw.githubusercontent.com/calaldees/config-merger/master/config_merger.py -o $@


# Repos ------------------------------------------------------------------------

${ROOT_FOLDER}/libs:
	cd ${ROOT_FOLDER} ; git clone https://github.com/calaldees/$@.git

${ROOT_FOLDER}/stageOrchestration:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git
	make install --directory ${ROOT_FOLDER}/$@

${ROOT_FOLDER}/stageViewer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git
	make install --directory ${ROOT_FOLDER}/$@

${ROOT_FOLDER}/webMidiTools:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git

${ROOT_FOLDER}/displayTrigger:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git
	make install --directory ${ROOT_FOLDER}/$@

#pentatonicHero:
#	git clone https://github.com/SuperLimitBreak/pentatonicHero.git

#voteBattle:
#	git clone https://github.com/SuperLimitBreak/voteBattle.git
#	cd voteBattle/server; make install

DOCKER_COMPOSE_PATHS=displayTrigger/server stageOrchistration stageViewer
docker-compose.yml: config_merger.py
	for PATH_DOCKER_COMPOSE in ${DOCKER_COMPOSE_PATHS}; do\
		${ROOT_FOLDER}/$$PATH_DOCKER_COMPOSE ;\
	done



run: install docker-compose.yml
	docker-compose --file ${ROOT_FOLDER}/displayTrigger/server/docker-compose.yml --file ${ROOT_FOLDER}/stageOrchistration/docker-compose.yml --file ${ROOT_FOLDER}/stageViewer/docker-compose.yml up

build: clone
	docker build --file nginx.production.dockerfile ${ROOT_FOLDER}


# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	for REPO in ${REPOS}; do\
		cd ${ROOT_FOLDER}/$$REPO ; git pull;\
	done


# Clean ------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf ${PATH_BUILD}
	for REPO in ${REPOS}; do\
		rm -rf ${ROOT_FOLDER}/$$REPO ;\
	done
