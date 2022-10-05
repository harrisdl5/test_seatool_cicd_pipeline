pipeline {
  agent any
  stages {
    stage('AWS') {
      steps {
        s3DoesObjectExist(bucket: 'secrets-rotation-hhy7', path: 'seatoolcicd')
        s3Upload 's3://secrets-rotation-hhy7/seatoolcicd/'
      }
    }

  }
}