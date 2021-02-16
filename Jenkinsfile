

pipeline {
  agent {
    kubernetes {
      defaultContainer 'dind'
      yaml """\
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            jenkins/kube-default: "true"
            app: jenkins
            component: agent
          namespace: jenkins
        spec:
          containers:
            - name: jnlp
              image: jenkinsci/jnlp-slave
              resources:
                limits:
                  cpu: 512m
                  memory: 512Mi
                requests:
                  cpu: 200m
                  memory: 300Mi
              imagePullPolicy: Always
              env:
              - name: POD_IP
                valueFrom:
                  fieldRef:
                    fieldPath: status.podIP
              - name: DOCKER_HOST
                value: tcp://localhost:2375
            - name: dind
              image: docker:18.05-dind
              securityContext:
                privileged: true
              volumeMounts:
                - name: dind-storage
                  mountPath: /var/lib/docker
          volumes:
            - name: dind-storage
              emptyDir: {}
        """.stripIndent()                    
    }
  }

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/Vahram-M96/Jenkins_Wordpress.git', branch:'master'
      }
    }
    
      stage("Build image") {
            steps {
                script {
                    myapp = docker.build("php_test2")
                }
            }
        }
      stage("Test image") {
            steps {
                sh 'echo "${scmVars.GIT_COMMIT}"'
            }
        }
      stage("Push image") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'HUB_USER', passwordVariable: 'HUB_TOKEN')]) {                      
                    sh '''
                        docker login -u $HUB_USER -p $HUB_TOKEN 
                        docker image tag php_test2 $HUB_USER/php_test2:"${scmVars.GIT_COMMIT}"
                        docker image push ${HUB_USER}/php_test2:"${scmVars.GIT_COMMIT}"
                    '''
                    
                }
            }
        }

    
 

  }

}
