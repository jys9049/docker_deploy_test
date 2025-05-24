### docker_deploy_test

##### 해당 프로젝트는 EC2 + Docker + nginx 를 사용하여 배포를 테스트 하기 위한 프로젝트이며 아래 스터디한 내용을 정리

1.  Dockerfile, docker-compose.yml, nginx.conf 파일 생성 및 코드 작성
2.  AWS EC2 인스턴스 생성 후 받은 키페어로 우분투 콘솔로 진입
3.  필요한 리소스 다운로드

    - 필수 패키지 설치

      ```
      sudo apt-get update

      sudo apt-get install -y ca-certificates curl gnupg lsb-release
      ```

    - Docker 공식 GPG 키 추가

      ```
      sudo mkdir -p /etc/apt/keyrings

      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      ```

    - Docker 저장소 설정

      ```
      echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      ```

    - Docker Engine 설치

      ```
      sudo apt-get update

      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
      ```

    - Docker 서비스 시작 및 활성화

      ```
      sudo systemctl start docker

      sudo systemctl enable docker
      ```

    - Docker 명령어 테스트

      ```
      sudo docker ps

      (CONTAINER ID, IMAGE, COMMAND가 보인다면 설치 성공)
      ```

    - Docker Compose 설치

      ```
      sudo apt-get install -y docker-compose-plugin

      docker compose --version (docker compose 설치 확인)

      ```

    - git clone (생략)

    - Certbot 설치 (SSL 인증서 발급/갱신)

      ```
      sudo apt install certbot python3-certbot-nginx -y

      ```

    - SSL 인증서 (https)

      ```
      sudo certbot certonly --standalone -d <도메인>
      ```

    - Docker 이미지 빌드

      ```
      sudo docker compose build --no-cache web (docker compose에 설정한 값)
      ```

    - Docker Compose로 서비스 실행

      ```
      sudo docker-compose up -d
      ```

    - Docker 컨테이너 확인

      ```
      sudo docker-compose ps
      ```
