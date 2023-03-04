# Week 2 — Distributed Tracing

## Required Homework

This week was another exciting week with the bootcamp; I learned a lot about working with integrations using SDKs. Understanding how to research and troubleshoot various aspects of not only the flask framework, but using steps to verify connectivity is already yielding fruit in my current role. In addition to the various instrumentation tasks we had this week, I spent a good amount of time configuring the prebuild for my gitpod.yml file. I was having the issue where I would have to manually run the install command for AWSCLI to function properly, but I've now resolve that. Upon startup, Gitpod now does the following:
	- Installs AWSCLI
	- Python pip install per the backend-flask/requirements.txt file
	- NPM install
	- Installs Postgres
Opens desired ports for our app functionality (3000, 4567, and 2000 so far)

### Instrument Honeycomb with OTEL

I was able to follow the livestream up to the point where we instrumented Honeycomb with OTEL. I was able to confirm traces were flowing to honeycomb following a restart of my gitpod workspace. I'm working on getting in the habit of restarting my workspace anytime we make changes to env vars and gitpod env vars. The restart took a while, so I was unable to keep up with the livestream instruction, so I started up again by configuring the SimpleSpan Processor to enable console logs to STDOUT. 

Image of Console Logging Here

I followed along and successfully set up the console logging and see the spans in the backend-flask container logs. The next step was to hardcode a span in preparation for future traces to the databases. I followed along with the stream replay, and added the home.activities attribute along with the custom attributes. This gave me a few ideas around how to add more context around these spans and how to instrument our services. I was still unsure how to create new spans and get the most out of attributes, but I did see there was an interesting feature that allowed one to link spans.

### Instrument AWS X-Ray

X-Ray is the service AWS uses for tracing. It's incorporated into CloudWatch and requires the installation of a daemon that acts as middleware between captured requests and the X-Ray endpoint. To instrument X-Ray into our code, we had to accomplish the following:
	- Update our code to incorporate the X-Ray configurations
	- Create a group to categorize traces along with a sampling rule
	- Install the X-ray daemon by updating our docker-compose.yml to spin up a container for the daemon
		○ We did this in preparation for running our workloads in ECS/EC2, having the X-Ray daemon in the cluster may be required for reporting.
	- Validate the service by checking for service data.

I love how doing these functional activities is not only teaching us the core topic but some of the nuances of working with the flask framework. When I ran docker-compose up, the backend-flask container was not serving to port 4567, and I saw in the logs that the python code for the app failed because there was a reference made to a variable name 'app' prior to it being defined. Once the code was adjusted, I was able to see in the logs that segments were being sent successfully to the x-ray endpoint. 

insert Image of "successful sent batch of 1 segments"

Insert image of Traces

### Configure Custom Logger to send to CloudWatch Logs



### Integrate Rollbar and Capture an Error