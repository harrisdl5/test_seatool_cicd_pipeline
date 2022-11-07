// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-role
  restartPolicy: Never
  containers:
  - name: aws-pythonsdk
    image: dylanhdev/aws-pythonsdk:0.1
    command: ['cat']
    tty: true
  - name: awscli
    image: amazon/aws-cli
    command: ['cat']
    tty: true
'''
            //defaultContainer 'awscli'
        }
    }
  stages {
        stage('aws config'){
            steps {
              container ('awscli'){
                sh '''
                aws sts assume-role \
                --role-arn $arn \
                --role-session-name cbc-rdssnap \
                --output text \
                --query Credentials \
                > /tmp/role-creds.txt
                cat > .aws-creds <<EOF
[default]
aws_access_key_id = $(cut -f1 /tmp/role-creds.txt)
aws_secret_access_key = $(cut -f3 /tmp/role-creds.txt)
aws_session_token = $(cut -f4 /tmp/role-creds.txt)
EOF
                '''
              }
            }
        }
        stage('create snapshot'){
          steps {
            container ('aws-pythonsdk'){
              sh '''
              # Run AWS command to test the assume role.
              mkdir -p $HOME/.aws
              cp -v .aws-creds $HOME/.aws/credentials
              unset AWS_WEB_IDENTITY_TOKEN_FILE
              aws sts get-caller-identity
              cd rcm/seatool/_terraform/compute/scripts/
              chmod +x seatool_binaries.ps1
              # echo $DB_IDENTIFIER
              seatool_binaries.ps1
              '''
            }
          }
        }
  }
}

