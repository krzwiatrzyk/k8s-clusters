#!/usr/bin/env bash

CLUSTERS_PATH=$(pwd)/clusters

function cluster_title() {
    while true; do
    case "${1-none}" in
    --clusterName ) local clusterName="$2"; shift 2;;
    -- ) shift; break;;
    * ) break;; 
    esac
    done

    local k3dClusterList=$(k3d cluster list)

    if is_running; then
        echo "${clusterName} <running>"
        return
    elif is_installed; then
        echo "${clusterName} <stopped>"
        return
    else
        echo "${clusterName}"
        return
    fi

    echo "error"
}

function is_running() {
  while true; do
    case "${1-none}" in
    --clusterName ) local clusterName="$2"; shift 2;;
    -- ) shift; break;;
    * ) break;; 
    esac
  done

  if ! is_installed --clusterName ${clusterName}; then
    return 1
  fi

  if ! servers_running || ! agents_running; then 
    return 1
  fi

  return
}

function is_installed() {
  while true; do
    case "${1-none}" in
    --clusterName ) local clusterName="$2"; shift 2;;
    -- ) shift; break;;
    * ) break;; 
    esac
  done

  local k3dClusterList=$(k3d cluster list)
  echo ${k3dClusterList} | grep ${clusterName} > /dev/null
  return $?
}

function cluster_discovery() {
    ls -1 ${CLUSTERS_PATH}
}

function servers_running() {
  if [[ $(k3d cluster list | grep minimal | cut -d ' ' -f 4 | cut -d "/" -f 1) == $(k3d cluster list | grep minimal | cut -d ' ' -f 4 | cut -d "/" -f 2) ]]; then
    return 0
  fi
  return 1
}

function agents_running() {
  if [[ $(k3d cluster list | grep minimal | cut -d ' ' -f 11 | cut -d "/" -f 1) == $(k3d cluster list | grep minimal | cut -d ' ' -f 11 | cut -d "/" -f 2) ]]; then
    return 0
  fi
  return 1
}

function start() {
    CHOICE=$(whiptail --title "ClusterManagement" --menu "Make your choice" 16 100 9 \
    "1" "$(cluster_title --clusterName minimal)"   \
    "2" "$(cluster_title --clusterName dashy)"  \
    "3" "$(cluster_title --clusterName istio)" \
    "4" "$(cluster_title --clusterName gocd)" \
    "5" "$(cluster_title --clusterName teleport)" \
    "6" "$(cluster_title --clusterName traefik-monitoring)" \
    "7" "$(cluster_title --clusterName firefly)" \
    3>&1 1>&2 2>&3);

    case ${CHOICE} in
    1)
        manageCluster --clusterName minimal
        ;;
    2)
        manageCluster --clusterName dashy
        ;;
    3)
        manageCluster --clusterName istio
        ;;
    4)
        manageCluster --clusterName gocd
        ;;
    5)  
        manageCluster --clusterName teleport
        ;;
    6)
        manageCluster --clusterName traefik-monitoring
        ;;     
    8)
        listClusters
        ;;
    *)
        echo "Not used."
        ;;
    esac
}

function listClusters() {
    whiptail --title "K3d Clusters List" --msgbox "$(k3d cluster list)" 8 78
    start
}

function manageCluster() {
    while true; do
    case "${1-none}" in
    --clusterName ) local clusterName="$2"; shift 2;;
    -- ) shift; break;;
    * ) break;; 
    esac
    done

    CHOICE=$(whiptail --title "ClusterManagement" --menu "Make your choice" 16 100 9 \
    "1" "Create"   \
    "2" "Start"   \
    "3" "Stop"   \
    "4" "Delete"  \
    "5" "Reinstall" \
    "9" "Back"  3>&1 1>&2 2>&3);

    cd clusters/${clusterName}

    case ${CHOICE} in
    1)
        task create
        ;;
    2)
        task start
        ;;
    3)  
        task stop
        ;;
    4)
        task delete
        ;;
    5)
        task delete
        task create
        ;;
    9)
        start
        ;;
    *)
        echo "Not used."
        ;;
    esac

    cd ../..
}

set -o nounset

start
