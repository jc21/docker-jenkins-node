pipeline {
	options {
		buildDiscarder(logRotator(numToKeepStr: '10'))
		disableConcurrentBuilds()
		ansiColor('xterm')
	}
	agent {
		label 'docker'
	}
	environment {
		IMAGE      = 'jenkins-node'
		TAG        = 'latest'
		TEMP_IMAGE = "jenkins-node_${TAG}_${BUILD_NUMBER}"
	}
	stages {
		stage('Build') {
			steps {
				sh 'docker build --pull --no-cache --squash --compress -t "${TEMP_IMAGE}" .'
			}
		}
		stage('Publish') {
			steps {
				sh 'docker tag "${TEMP_IMAGE}" "docker.io/jc21/${IMAGE}:${TAG}"'
				withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'DPASS', usernameVariable: 'DUSER')]) {
					sh 'docker login -u "${DUSER}" -p "${DPASS}"'
					sh 'docker push "docker.io/jc21/${IMAGE}:${TAG}"'
				}
			}
		}
	}
	post {
		success {
			juxtapose event: 'success'
			sh 'figlet "SUCCESS"'
		}
		failure {
			juxtapose event: 'failure'
			sh 'figlet "FAILURE"'
		}
		always {
			sh 'docker rmi "${TEMP_IMAGE}"'
		}
	}
}
