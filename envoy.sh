# envoy support functions

proxy_wait_sec=180 ## wait for 180 seconds for istio-proxy

wait_for_proxy()
{
   local proxy_past_sec=0
   while ! curl -s -f http://localhost:15000/server_info | grep -q '"state": "LIVE"'; do
     echo "Waiting for istio-proxy.."
     sleep 1
     proxy_past_sec=$((proxy_past_sec+1))
     if [ $proxy_past_sec -ge $proxy_wait_sec ]; then
       echo "Timeout reached. istio-proxy is not ready.."
       echo "Exiting.."
       exit 1
     fi
   done
   sleep 2
   echo "istio-proxy ready."
}


terminate_proxy()
{
   echo "signalling istio-proxy to terminate.."
   curl -X POST http://127.0.0.1:15000/drain_listeners?graceful
   curl -X POST http://127.0.0.1:15000/healthcheck/fail
   curl -X POST http://127.0.0.1:15000/quitquitquit
   echo "signaled istio-proxy to terminate.."
}
