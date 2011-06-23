# Trackablaze Gem 

The Trackablaze gem is both the official repository of trackers for
[Trackablaze][1] as well as a stand-alone tool to execute trackers
from the command line. The website and the gem are kept in
version sync, so any recipes released to the gem will be simultaneously
available on the web builder.

## Installation

Installation is simple:

    gem install trackablaze

## Usage

'trackablaze' lets you track web metrics. For
example, the Twitter tracker lets you find metrics
about a specific Twitter account - metrics such as number of
followers, number of friends, etc. Depending on the tracker
used either only public information is available or 
authenticated information is available through oauth.

### Command line usage

The command line take a configuration yaml file and executes 
trackers listed in it.

    trackablaze track sample.yml

Contents of sample.yml

    - twitter:
        params:
          handle: amolk
        metrics:
        - followers_count 
        - friends_count

    - facebook_page:
        params:
          page_id: 125602120804573
      
    - twitter:
        params:
          handle: msuster
  
This will output twitter metrics for the two twitter handles 
(amolk, msuster) and metrics for the facebook page specified. 
If a list of metrics is specified, 
such as for the first twitter tracker, those specific metrics
are listed in the output. Otherwise, the default set of 
metrics are reported.

Output 

    --------------------------------[ Twitter ]--------------------------------
    params: {"handle"=>"amolk"}
    results: {"followers_count"=>25, "friends_count"=>29}
    -----------------------------[ Facebook page ]-----------------------------
    params: {"page_id"=>125602120804573}
    results: {"likes"=>13}
    --------------------------------[ Twitter ]--------------------------------
    params: {"handle"=>"msuster"}
    results: {"followers_count"=>35836}

# Trackablaze Trackers

Trackablaze trackers collection is available
in this GitHub repository. Feel free to fork and improve. You can see all of 
the trackers in the [trackers directory][2].

## Submitting a Tracker

Submitting a tracker is actually a very straightforward process. Trackers
are made of up of a **YAML config file** and a **ruby code file**. 

### Sample YAML config file

    title: 'Twitter'

    params:
      handle:
        name: 'Twitter handle'
        description: 'This is the Twitter username'
        type: string
  
    metrics:
      followers_count:
        name: 'Followers count'
        default: true
      friends_count:
        name: 'Friends count'

### Sample tracker ruby file 

    require 'twitter'

    module Trackablaze
      class Twitter < Tracker
        def get_metrics(tracker_items)
          tracker_items.collect {|tracker_item| get_metrics_single(tracker_item)}
        end
    
        def get_metrics_single(tracker_item)  
          metrics = {}
  
          if (tracker_item.params["handle"].nil? || tracker_item.params["handle"].empty?)
            add_error(metrics, "No handle supplied", "handle") 
            return metrics
          end
      
          user = nil
          begin
            user = ::Twitter.user(tracker_item.params["handle"])
          rescue      
          end

          if (user.nil?)
            add_error(metrics, "Invalid handle supplied", "handle")
            return metrics
          end
  
          tracker_item.metrics.each do |metric|
            metrics[metric] = user[metric]
          end
  
          metrics
        end
      end
    end


A tracker must implement get_metrics() method. This method takes
in an array of tracker items (i.e. configurations). Your tracker may choose to query
for each tracker item one by one or use any available optimized
API calls. For example, the above code queries Twitter API once
for each user handle, but can be optimized by using the 
::Twitter.users API call that takes an array of user handles.

It's really that simple. The gem has RSpec tests that automatically
validate each tracker in the repository, so you should run `rake spec`
as a basic sanity check before submitting a pull request. Note that
these don't verify that your tracker code itself works, just that
Trackablaze could properly load your tracker file and the the config
file is valid.

For more information on all available options for authoring trackers,
please see the wiki.

## License

Trackablaze and its recipes are distributed under the MIT License.

[1]:http://trackablaze.com
[2]:https://github.com/aflatune/trackablaze-gem/tree/master/trackers