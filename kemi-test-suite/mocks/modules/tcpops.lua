local tcpops = {
    tcp_conid_alive = function(id) 
        return id == 1 and true or false
    end,
    tcp_conid_state = function(id) 
        return id == 1 and 1 or -1
    end
}
return tcpops