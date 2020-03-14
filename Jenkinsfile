// namespace-credential-injection pipeline

node ('kube_pod_slave') {

    // sample docker registry secrets. Each object in 'docker-registry' array
    // contains four items:
    // - 'name': the name that will be given to the secret
    // - 'docker-server': server location for Docker registry
    // - 'docker-email': email for Docker registry
    // - 'credential-id': the ID of the Jenkins credential file which will be
    //   used to retrieve this secret's docker-username and docker-password
    //
    // def credentials_list = [
    //     'docker-registry': [
    //         [
    //             'name': 'my-docker-secret',
    //             'docker-server': 'my-repo.artifactory.swg-devops.com',
    //             'docker-email': 'myemail@ibm.com',
    //             'credential-id': 'credential-example-1'
    //         ],
    //         [
    //             'name': 'another-docker-secret',
    //             'docker-server': 'my-other-repo.artifactory.swg-devops.com',
    //             'docker-email': 'myemail@ibm.com',
    //             'credential-id': 'credential-example-2'
    //         ]
    //     ]
    // ]
    
    def credentials_list = [
        'docker-registry': [
        ]
    ]
    
    stage ('List current secrets') {
        sh '''
            kubectl get secrets
        '''
    }
    
    stage ('Adding the docker_registry secrets') {
        credentials_list['docker-registry'].each { credential ->
            withCredentials([usernamePassword(credentialsId: credential['credential-id'], usernameVariable: 'CREDENTIAL_USERNAME', passwordVariable: 'CREDENTIAL_PASSWORD')]) {
                env.SECRET_NAME = credential['name']
                env.DOCKER_SERVER = credential['docker-server']
                env.DOCKER_EMAIL = credential['docker-email']
                // See: 
                //     kubectl create secret docker-registry --help
                // for more information
                sh '''
                    # Disable exit on non 0 so that the job does not exit if we try to delete a secret that does not exist
                    set +e
                    kubectl delete secret ${SECRET_NAME}
                    # Re-enable exit on non 0
                    set -e
                    kubectl create secret docker-registry \
                    ${SECRET_NAME} \
                    --docker-server=${DOCKER_SERVER} \
                    --docker-username=${CREDENTIAL_USERNAME} \
                    --docker-password=${CREDENTIAL_PASSWORD} \
                    --docker-email=${DOCKER_EMAIL}
                '''
            }
        }
    }
    
    stage ('List final secrets') {
        sh '''
            kubectl get secrets
        '''
    }
    
}
