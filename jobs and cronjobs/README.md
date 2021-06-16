Jobs are used to run a specific task and complete it successfully by
creating the POD at that point of time and status changes to "Completed"

CronJobs are designed to run a task at specific point of time scheduled.

Entries for CronJobs to run on specific time:
Minute (0-59)
Hour (0-23)
Day of the Month (1-31)
Month (1-12) (Jan, Feb)
Day of the week (0-6) starting from Sunday

2:15 am on every week at sunday

15 2 * * 0

How to suspend the job?
kubectl patch cronjobs <job-name> -p '{"spec" : {"suspend" : true}}'

Jobs:
Create a job with the specified name.

Examples:
  # Create a job
  kubectl create job my-job --image=busybox

  # Create a job with command
  kubectl create job my-job --image=busybox -- date

  # Create a job from a CronJob named "a-cronjob"
  kubectl create job test-job --from=cronjob/a-cronjob

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
the template. Only applies to golang and jsonpath output formats.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --from='': The name of the resource to create a Job from (only cronjob is supported).
      --image='': Image name to run.
  -o, --output='': Output format. One of:
json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-file.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --validate=true: If true, use a schema to validate the input before sending it

Usage:
  kubectl create job NAME --image=image [--from=cronjob/name] -- [COMMAND] [args...] [flags] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).


Cronjobs:

Create a cronjob with the specified name.

Aliases:
cronjob, cj

Examples:
  # Create a cronjob
  kubectl create cronjob my-job --image=busybox

  # Create a cronjob with command
  kubectl create cronjob my-job --image=busybox -- date

  # Create a cronjob with schedule
  kubectl create cronjob test-job --image=busybox --schedule="*/1 * * * *"

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
the template. Only applies to golang and jsonpath output formats.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --image='': Image name to run.
  -o, --output='': Output format. One of:
json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-file.
      --restart='': job's restart policy. supported values: OnFailure, Never
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --schedule='': A schedule in the Cron format the job should be run with.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --validate=true: If true, use a schema to validate the input before sending it

Usage:
  kubectl create cronjob NAME --image=image --schedule='0/5 * * * ?' -- [COMMAND] [args...] [flags] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

