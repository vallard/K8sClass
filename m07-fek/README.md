# The FEK Stack

Logging information from your applications to search, verify, and index on is a great idea and gives added visibility.  In a production environment developers are constantly looking at logs to analyze user behavior, what went wrong, and find ways to improve the system. 


## Components

* Fluentd - This is the workhorse that gathers the logs from the system and then forwards them on to a centralized place.  But it can do more than that, it can forward logs to multiple places, transform them in place, and do other fancy tricks. 
* ElasticSearch (OpenSearch) - ElasticSearch is open source and the company behind them (Elastic) seemed to have issues with Amazon.  So Amazon forked it, and now offers OpenSearch.  Good or bad, this is what we'll use. 
* Kibana - This is our dashboard for viewing the logs and keeping them sorted. 

## OpenSearch

The first step is to install an OpenSearch Cluster.  We'll keep it small to start out with but notice how big these things can get, so watch it.  The other thing to watch for is that the logs constantly fill up!  We have implemented a culler in the past that culls these logs and clears out everything 