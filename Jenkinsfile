#!/usr/bin/env groovy

import net.smartcosmos.BuildUtil

@Library('smartcosmos@v1.0.0') _

node {
  def helper = new net.smartcosmos.helper()
  def utils = new BuildUtil(env, steps)

  stage("Checkout") {
    checkout scm
  }

  def commitId = utils.getCommitId()
  def image

  stage("Build") {
    image = docker.build "smartcosmos/react-native-build"
  }

  if (env.BRANCH_NAME == "master") {
    stage("Publish") {
      docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
        image.push(commitId)
        image.push("master")
      }
    }
  }

  // remove the docker image locally
  sh "docker rmi ${image.id}"
}