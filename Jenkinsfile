// pipeline {
//   agent any

//   environment {
//     // Docker Hub creds from Jenkins
//     DOCKERHUB = credentials('dockerhub-creds')
//     IMAGE      = "${DOCKERHUB_USR}/my-shop-frontend"
//     TAG        = "${env.BUILD_NUMBER}"
//     REACT_APP_API_URL = 'https://fakestoreapi.com'
//   }

//   stages {
//     stage('Checkout') {
//       steps {
//         git credentialsId: 'github-private-creds',
//             url: 'https://github.com/rajan-groove/devops-project.git',
//             branch: 'Sairanjan_P2'
//       }
//     }

//     stage('Build Docker Image') {
//       steps {
//         script {
//           sh """
//             docker build \
//               --build-arg REACT_APP_API_URL=${REACT_APP_API_URL} \
//               -t ${IMAGE}:${TAG} \
//               .
//           """
//         }
//       }
//     }

//     stage('Security Scan') {
//       steps {
//         // Don’t fail build, but mark unstable if vulnerabilities found
//         sh """
//           trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE}:${TAG} || echo 'Scan had findings'
//         """
//       }
//     }

//     stage('Push to Docker Hub') {
//       steps {
//         sh """
//           echo "${DOCKERHUB_PSW}" | docker login -u "${DOCKERHUB_USR}" --password-stdin
//           docker push ${IMAGE}:${TAG}
//         """
//       }
//     }

//     stage('Deploy with Docker Compose') {
//       steps {
//         // Gracefully bring down old, then up new
//         sh """
//           docker-compose down
//           IMAGE_TAG=${TAG} docker-compose up -d --build
//         """
//       }
//     }
//   }

//   post {
//     success {
//       echo "✅ Deployment succeeded: ${IMAGE}:${TAG}"
//     }
//     failure {
//       echo "❌ Deployment failed. Rolling back to previous containers."
//       // On failure, redeploy last successful build if you keep a 'stable' tag:
//       sh """
//         docker-compose down
//         docker pull ${IMAGE}:stable || true
//         IMAGE_TAG=stable docker-compose up -d || true
//       """
//     }
//     cleanup {
//       // Optionally prune old images
//       sh 'docker image prune -f'
//     }
//   }
// }


pipeline {
  agent any

  environment {
    DOCKERHUB = credentials('dockerhub-creds')
    IMAGE     = "${DOCKERHUB_USR}/my-shop-frontend"
    TAG       = "${env.BUILD_NUMBER}"
    API_URL   = 'http://localhost:4000' // Optional override here
  }

  stages {
    stage('Checkout') {
      steps {
        git credentialsId: 'github-private-creds',
            url: 'https://github.com/rajan-groove/devops-project.git',
            branch: 'Sairanjan_P2'
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('E-commerce-website-using-React-Redux') {
          script {
            sh """
              docker build \
                --build-arg REACT_APP_API_URL=${API_URL} \
                -t ${IMAGE}:${TAG} \
                .
            """
          }
        }
      }
    }

    stage('Security Scan') {
      steps {
        dir('E-commerce-website-using-React-Redux') {
          sh """
            trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE}:${TAG} || echo 'Scan had findings'
          """
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        sh """
          echo "${DOCKERHUB_PSW}" | docker login -u "${DOCKERHUB_USR}" --password-stdin
          docker push ${IMAGE}:${TAG}
        """
      }
    }

    stage('Deploy with Docker Compose') {
      steps {
        dir('E-commerce-website-using-React-Redux') {
          sh """
            docker-compose down
            IMAGE_TAG=${TAG} docker-compose up -d --build
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment succeeded: ${IMAGE}:${TAG}"
    }
    failure {
      echo "❌ Deployment failed. Rolling back to previous containers."
      dir('E-commerce-website-using-React-Redux') {
        sh """
          docker-compose down
          docker pull ${IMAGE}:stable || true
          IMAGE_TAG=stable docker-compose up -d || true
        """
      }
    }
    cleanup {
      sh 'docker image prune -f'
    }
  }
}
