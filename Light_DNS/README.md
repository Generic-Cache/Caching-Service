# Introduction

Caching-Service is a docker based generic cache, which uses NGINX as the underlying server. This can be used to reduce latency in the internal LAN and avoid repeatative usage of the external access link. This can also be used to mimic a mirror server by using an authoritative server.

# Usage

The Cache-Service can handle only HTTP requests. Thus only the HTTP requests must be directed to it, which can done using DNS and SNI Proxy (to handle HTTPS).

## Prerequisites

* Installing Docker
  - Setting up the repository
  
    ```shell
    $ sudo apt-get update;
    $ sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common;
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
    $ sudo add-apt-repository \
     "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable";
    ```
  - Installing Docker CE
    
    ```shell
    $ sudo apt-get update;
    $ sudo apt-get install docker-ce docker-ce-cli containerd.io;
    $ sudo systemctl status docker;
    ```
   - Adding username to Docker group
   
      ```shell
      $ sudo usermod -aG docker ${USER};
      $ su - ${USER};
      ```
      
   * Installing net-tools

      ```shell
      $ sudo apt-get install net-tools
      ```   

   * Installing dnsutils

     ```shell
      $ sudo apt-get install dnsutils
      ```
 
 ## Running Light_DNS
 
  * Running the docker container as a daemon
  
    ```shell
    $ docker run -td \
      --restart unless-stopped \
      --name <container name> \
      -p <Your IP>:53:53/udp \
      -p <Your IP>:53:53/tcp \
      hlpr98/light_dns:latest;
    ```
    
## Usage
 
  This is a authoritative DNS service for your LAN cache. If you have your cache set-up, then you would need to add the domain, thier IP addresses and corresponding hostnames in that domain. To do this, run the `add.sh` script and follow the interactive prompts.
  
  ```shell
  $ ./add.sh
  ```
  
  Now the hostnames added can be querried.

## Monitoring

 * Opening an iteractive bash on the container.
  
    ```shell
    $ docker exec -it <container name> bash
    ```
    
 * Monitor the logs.
 
    * Query log
      
        ```shell
        $ tail --follow /var/log/bind/queries.log
        ```
    * General log
      
        ```shell
        $ tail --follow /var/log/bind/general.log
        ```
    * List all the log files
         
        ```shell
        $ ls -ll /var/log/bind/
        ```
   The logs show the hostnames queried for, clients querying, etc. dynamically.    
   
   * Looking at all the domains added and the hostnames in them
      
     All the domains added are in the folder, `/dns_domains` and all the hostservers in each doamin can be found in the file `<DOMAIN NAME IN CAPS>`.
    

## Testing and Monitoring

* Creating a Docker container named ```test```. bound to ```127.0.0.1```
  
  ```shell
    $ docker run -td \
      --restart unless-stopped \
      --name test \
      -p 127.0.0.1:53:53/udp \
      -p 127.0.0.1:53:53/tcp \
      hlpr98/light_dns:latest;
    ```

 * Opening an iteractive bash on the container.
  
    ```shell
    $ docker exec -it test bash
    ```
    
 * Add a custom test domain 
 
    For example: 
      Addtition of a domain name `test` which is managed by the cache at IP 100.100.100.100, responsible for hosts www.testing.com, test.net and *test.with.wildchar would look like.
  
    ```shell
    $ ./add
    $ Enter the DNS domain you would like to change (must not have spaces) : test 
    $ The requested domain is not defined
    $ Enter the IP address of the CACHE for this DOMAIN : 100.100.100.100
    $ The file named TEST has been created
    $ The ENV TEST=100.100.100.100 has been created
    $ Enter the hostserver names to be added to the domain TEST (Ctrl+D to quit adding)
    $ www.testing.com
    $ *.test.with.wildchar
    $ testing.net
    $ ^D
    $
    $  * Stopping domain name service... bind9 
    $ waiting for pid 55 to die
    $                                           [OK]

  
  * Querying for the cache IP which are responsible for a perticular hostserver, for ex, www.testing.com
  
    Run the following command on the docker host machine
    
    ```shell
    $ dig www.testing.com @127.0.0.1
    ```
    
    If the DNS server is running properly, then the result would look like
    
    ```
    ; <<>> DiG 9.11.3-1ubuntu1.5-Ubuntu <<>> www.testing.com @127.0.0.3
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 33820
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 3

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ; COOKIE: 06802d3bab57ddba9f8c11995c83742256a797a94a5b4a29 (good)
    ;; QUESTION SECTION:
    ;www.testing.com.		IN	A

    ;; ANSWER SECTION:
    www.testing.com.	5	IN	CNAME	test.cache.genericcache.com.
    test.cache.genericcache.com. 86400 IN	A	100.100.100.100

    ;; AUTHORITY SECTION:
    cache.genericcache.com.	86400	IN	NS	localhost.

    ;; ADDITIONAL SECTION:
    localhost.		604800	IN	A	127.0.0.1
    localhost.		604800	IN	AAAA	::1

    ;; Query time: 392 msec
    ;; SERVER: 127.0.0.3#53(127.0.0.3)
    ;; WHEN: Sat Mar 09 13:36:58 IST 2019
    ;; MSG SIZE  rcvd: 193
    ```
         
