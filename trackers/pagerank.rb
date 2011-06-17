require 'socket' 

module Trackablaze
  class Pagerank < Tracker
    def get_metrics(tracker_items)
      tracker_items.collect {|tracker_item| get_metrics_single(tracker_item)}
    end
    
    def get_metrics_single(tracker_item)  
      metrics = {}
  
      if (tracker_item.params["domain"].nil? || tracker_item.params["domain"].empty?)
        add_error(metrics, "No domain supplied", "domain") 
        return metrics
      end
      
      pagerank = nil
      begin
        pagerank = getpr(tracker_item.params["domain"])
      rescue      
      end

      if (pagerank.nil?)
        add_error(metrics, "Could not find pagerank. Is domain specified properly (e.g. google.com)?", "domain")
        return metrics
      end
  
      metrics['pagerank'] = pagerank
  
      metrics
    end
    
    #------------------------------
    # Ruby conversion by Amol Kelkar of
    # PageRank Lookup v1.1 by HM2K at http://www.hm2k.com/projects/pagerank
    # based on an alogoritham found here: http://pagerank.gamesaga.net/
    #------------------------------
    
    #convert a string to a 32-bit integer
    def str_to_num(str, check, magic)
        int32Unit = 4294967296;  # 2^32

        length = str.length;
        (0..length-1).each do |i|
            check *= magic; 	

            #If the float is beyond the boundaries of integer (usually +/- 2.15e+9 = 2^31), 
            #  the result of converting to integer is undefined
            #  refer to http://www.php.net/manual/en/language.types.integer.php
            if (check >= int32Unit) 
                check = (check - int32Unit * (check / int32Unit).to_i);
                #if the check less than -2^31
                check = (check < -2147483648) ? (check + int32Unit) : check;
            end
            check += str[i].ord 
        end
        return check
    end

    # genearate a hash for a url
    def hash_url(str)
        check1 = str_to_num(str, 0x1505, 0x21);
        check2 = str_to_num(str, 0, 0x1003F);

        check1 >>= 2; 	
        check1 = ((check1 >> 4) & 0x3FFFFC0 ) | (check1 & 0x3F);
        check1 = ((check1 >> 4) & 0x3FFC00 ) | (check1 & 0x3FF);
        check1 = ((check1 >> 4) & 0x3C000 ) | (check1 & 0x3FFF);	

        t1 = ((((check1 & 0x3C0) << 4) | (check1 & 0x3C)) <<2 ) | (check2 & 0xF0F );
        t2 = ((((check1 & 0xFFFFC000) << 4) | (check1 & 0x3C00)) << 0xA) | (check2 & 0xF0F0000 );

        return t1 | t2;
    end

    # genearate a checksum for the hash string
    def check_hash(hashnum)
        checkByte = 0
        flag = 0

        hashStr = sprintf('%u', hashnum)
        length = hashStr.length;

        (length - 1).downto(0) do |i|
            re = hashStr[i].to_i;
            if (1 === (flag % 2))             
                re += re
                re = (re / 10).to_i + (re % 10).to_i
            end
            checkByte += re;
            flag += 1	
        end

        checkByte %= 10;
        if (0 != checkByte)
            checkByte = 10 - checkByte;
            if (1 === (flag % 2) )
                if (1 === (checkByte % 2))
                    checkByte += 9
                end
                checkByte >>= 1
            end
        end

        return "7#{checkByte}#{hashStr}"
    end

    # return the pagerank checksum hash
    def getch(url) 
      return check_hash(hash_url(url));
    end

    # return the pagerank figure
    def getpr(url)
      googlehost='toolbarqueries.google.com';
      googleua='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.6) Gecko/20060728 Firefox/1.5';

    	ch = getch(url)
    	fp = TCPSocket.open(googlehost, 80)
    	if (fp)
        out = "GET /search?client=navclient-auto&ch=#{ch}&features=Rank&q=info:#{url} HTTP/1.1\r\n"

        out = out + "User-Agent: #{googleua}\r\n"
        out = out + "Host: #{googlehost}\r\n"
        out = out + "Connection: Close\r\n\r\n"

        fp.puts out

        while line = fp.gets do
          pos = line.index("Rank_");
          unless(pos.nil?) 
          	pr = line.slice(pos + 9, 2);
          	return pr.to_i;
          end
    	  end
    	  fp.close
    	end
    end
    
  end
end



