def jobName = 'YOUR_JOB_NAME'
def buildNumber = hudson.model.Hudson.instance.getItemByFullName(jobName).lastBuild.number
def run = hudson.model.Hudson.instance.getItemByFullName(jobName).getBuildByNumber(buildNumber)

if (run instanceof hudson.model.Run) {
    def steps = run.getExecution().getCurrentExecutable().getBuild().getActions(hudson.model.ParametersAction)
    steps.each { step ->
        if (step instanceof org.jenkinsci.plugins.workflow.cps.nodes.StepAtomNode) {
            def stageName = step.getDescriptor().getFunctionName()
            def startTime = step.getStartTimeInMillis()
            def endTime = step.getDuration() + startTime
            def status = step.getResult().toString()
            println("Stage: $stageName, Status: $status, Duration: ${(endTime - startTime) / 1000} seconds")
        }
    }
}
