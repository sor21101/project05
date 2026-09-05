## docker web service 구동 확인

1. 컨테이너 실행 상태 확인
docker ps

CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS              PORTS                                 NAMES
d4ce0d047456   nginx:alpine   "/docker-entrypoint.…"   5 minutes ago   Up About a minute   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx

2. 웹 서비스 응답 확인
curl localhost
nginx 기본 페이지 응답 확인

3. 정상 상태 리소스 사용량 확인
docker stats

CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
d4ce0d047456   nginx     0.00%     4.254MiB / 909.5MiB   0.47%     1.87kB / 1.68kB   7.21MB / 4.1kB   3

현재 아무 작업이 이루어지지않아서 자원 사용량이 적음
이 값이 baseline

4. 현재 구성
Internet -> EC2 public IP -> Port 80 -> Docker -> Nginx Container

5. 진행할 테스트
- 컨테이너 중지 시 서비스 장애 확인
- 트래픽 증가 시 CPU / Memory 변화 확인
- 현재 구조의 장애 탐지 및 자동 복구 가능 여부 확인
---
6. 컨테이너 장애 테스트
docker stop nginx

결과
- 당연하겠지만 nginx 컨테이너 중지
- curl localhost 접속 실패

복구 - docker start nginx

결과
- 당연하겠지만 nginx 컨테이너 재실행
- curl localhost 응답 확인

문제점
- 컨테이너 장애 시 서비스 즉시 중단
- 현재로써는 터미널을 보고있기 때문에 꺼진줄 알았지만, 별도의 알림이 없음
- 운영자가 직접 확인하고 수동 복구해야함

7. 트래픽 부하 테스트
apachebench를 이용하여 외부에서 EC2로 HTTP 요청

테스트 조건
ab -n 1000 -c 10 http://3.38.209.48/
총 요청 1000, 동시 요청 10, EC2 Public IP -> Docker -> Nginx

Nginx 정적 페이지는 요청에 대해 준비된 HTML파일만 반환하는 가벼운 작업만 수행하기 때문에, 높은 트래픽을 넣어도 CPU사용률이나 응답 시간에 유의미한 변화가 나지 않음

총 요청 : 1000
동시 요청 : 10
Failed Requests: 0
Requests per second: 363.04 req/s
Time per request: 27.545 ms
Container CPU: 최대 약 6.26%

보다시피 요청수를 크게 늘려도 서비스가 안정적으로 동작
따라서 HTTP 연결 처리가 아닌
application 처리량 증가에 따른 ec2의 성능 한계 확인으로 변경

### 테스트 조건 변경
flask 사용

실제 web application에서는 요청을 받을 때 단순 파일 변환 외에 다음 작업도 같이 발생

Client Request -> Application -> Business Logic / cpu 연산 -> Response

이러한 처리 비용을 간단한게 재현하기 위해 flask 기반 test app 배포

각 HTTP 요청마다 반복적인 cpu 연산을 수행하도록 구성하여 요청 증가에 따라 서버의 cpu 사용량과 응답시간이 변화하도록 함
-> application workload를 의도적으로 재현하기 위한 테스트 환경

다시 apachebench를 이용하여 다음과 같이 부하 

ab -t 30 -c 50 http://3.38.251.168/
약 30초 동안 동시 요청 50, 대상은 flask test-app
외부 -> ec2로 요청
측정항목 : apachebench 응답 성능, container cpu / memory, ec2 전체 cpu 

### 아래는 테스트 결과

container 리소스 변화

부하 전
cpu : 평균 0.01% // 거의 0에 수렴
memory : 평균 21.10 MiB

부하 발생 후
cpu 사용률 급격히 증가

64.96% 
102.27% 
105.15% 
120.36% ← 최대 
104.84% 
106.42% 
106.77% 
105.57%
...

cpu 약 103~106% 수준 // 최대 120.36%
memory : 약 21.1 MiB -> 최대 약 25.1 MiB // 그렇게 막 증가하지 않음


EC2 리소스 변화

vmstat을 통해 EC2 CPU 사용량도 확인

부하 전 
us 0~1%    // user cpu flask app cpu 비율
id 98~100% // idle cpu 놀고 있는 cpu비율

부하 발생 후
us 50~52% 
id 46~49% 

EC2는 2vcpu 환경이고 cpu-bound application 하나의 cpu core를 지속적으로 사용하는 형태 (2개 중 하나 사용)
container에서 cpu사용률이 100퍼 이상 지속된 것과 일치하는 결과


apachebench 결과

Concurrency Level:      50
Time taken for tests:   30.914 seconds
Complete requests:      74
Failed requests:        0

Requests per second:    2.39 req/s
Time per request:       20887.854 ms

연결 시간 기준:

                 mean       max
Processing     14,142 ms   26,702 ms
Waiting        13,631 ms   26,113 ms
Total          14,157 ms   26,716 ms

응답시간 분포:

50%   15,208 ms
80%   21,804 ms
90%   22,920 ms
95%   24,660 ms
100%  26,716 ms

30초 동안 처리된 요청은 총 74건으로 처리량은 약 2.39 req/s 까지 감소
분명 실패된 처리는 없었음
전체 요청의 절반이 처리되는 시간이 약 15초가 걸렸고, 제일 느린 요청이 약 26.7 
결과적으로 서버가 다운되지 않았지만, user 입장에서는 요청했지만 처리된 답이 15초가 넘어감으로 매우매우 답답할 것 // 정상적인 서비스 제공이 어려움


---
초기 nginx 테스트에서도 많은 HTTP 요청에도 서버가 안정적으로 돌아가서 단일 EC2의 한계점을 확인하기 어려웠음

실제 app 처럼 요청마다 연산이 발생하는 flask 환경으로 변경한 결과 다음과 같이 흐름을 확인할 수 잇었음

트래픽이 증가하면서  
- Application CPU 사용률 증가  
- CPU 처리 능력 한계 도달 
- 처리되지 못한 요청 대기 
- 응답시간 증가 
- 서비스 품질 저하

현재는 단일 EC2 환경이라 처리력이 한계에 도달해도 요청을 다른 서버에 분산하거나 새로운 서버를 자동으로 추가할 수 없음

따라서 이후 단계에서는 이러한 상황 개선을 위한 Load Balencer와 필요한 서버 수를 자동 조절하는 Auto Scaling 구조를 검토
---


### 결론
nginx container가 의외로 견고해서 테스트 방식을 교체했다.
다만 이번 테스트를 통해 서버가 반드시 다운되어야만 장애 상태라고 볼 수 있는게 아니며, 서버는 살아있어도 처리력을 초과하여 응답시간이 극도로 증가하면 그건 이제 정상적인 서비스라고 볼 수 없다.

추가로 인프라 용량을 판단할 때 단순 요청 수 뿐만 아니라 실제 app이 요청 하나를 처리하는 데 필요한 cpu, memory 등의 workload 특성을 함께 고려해야할듯

