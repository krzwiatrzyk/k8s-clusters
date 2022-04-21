default: cluster

cluster:
	dialogs/cluster-management.sh

add-local-cluster-as-submodule:
	git submodule add https://github.com/krzwiatrzyk/local-cluster

pull-submodules:
	git submodule update --init --recursive
	#
	#git pull --recurse-submodules

update-submodules:
	#git submodule update --recursive
	git submodule update --recursive --remote