pipeline {
    agent {
        label "arm64&&docker"
    }

    environment {
        ZK_VERSION= sh returnStdout: true, script: "awk '/^appVersion:/ { print \$2 }' helm/zookeeper/Chart.yaml | tr -d '\\n'"
        KAFKA_VERSION= sh returnStdout: true, script: "awk '/^appVersion:/ { print \$2 }' helm/kafka/Chart.yaml | tr -d '\\n'"
    }

    options {
        ansiColor('xterm')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5')
        timestamps()
    }


    stages {
        stage("Build & Push Docker Image") {
            when {
                branch "master"
            }

            steps {
                echo "Zookeeper version: ${env.ZK_VERSION}"
                sh "docker build --build-arg 'ZK_VERSION=${env.ZK_VERSION}' -t rafaelostertag/zookeeper:${env.ZK_VERSION} docker/zookeeper"

                echo "Kafka version: ${env.KAFKA_VERSION}"
                sh "docker build --build-arg 'KAFKA_VERSION=${env.KAFKA_VERSION}' -t rafaelostertag/kafka:${env.KAFKA_VERSION} docker/kafka"

                withCredentials([usernamePassword(credentialsId: '750504ce-6f4f-4252-9b2b-5814bd561430', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh 'docker login --username "$USERNAME" --password "$PASSWORD"'
                    sh "docker push rafaelostertag/zookeeper:${env.ZK_VERSION}"
                    sh "docker push rafaelostertag/kafka:${env.KAFKA_VERSION}"
                }
            }
        }

        stage("Deploy to k8s") {
            agent {
                label "helm"
            }

            when {
               branch "master"
            }

            steps {
                withKubeConfig(credentialsId: 'a9fe556b-01b0-4354-9a65-616baccf9cac') {
                    sh """
if ! helm status -n funnel zookeeper
then
  helm install -n funnel zookeeper helm/zookeeper
else
  helm upgrade -n funnel zookeeper helm/zookeeper
fi
"""
                    sh """
if ! helm status -n funnel kafka
then
  helm install -n funnel kafka helm/kafka
else
  helm upgrade -n funnel kafka helm/kafka
fi
"""
                }
            }
        }
    }

    post {
        unsuccessful {
            mail to: "rafi@guengel.ch",
                    subject: "${JOB_NAME} (${BRANCH_NAME};${env.BUILD_DISPLAY_NAME}) -- ${currentBuild.currentResult}",
                    body: "Refer to ${currentBuild.absoluteUrl}"
        }
    }
}
