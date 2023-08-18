# Audit Logging and Behavioral Analysis
Open-source tool called Falco 
- monitors Linux system calls at runtime and alerts on any suspicious 

Examples:
- Privilege Escalation
- File Access 
- Binaries

falco -r <rules-file.yaml> -M <seconds> 

# falco variables to be referenced in the rules.yaml
falco --list 
