# Host OS Security
Use them only when absolutely necessary
- hostIPC
- hostPID
- hostNetwork

# AppArmor
/etc/apparmor.d/<profile-name>

sudo vi /etc/apparmor.d/deny-write 

#include <tunables/global>
profile deny-write flags=(attach_disconnected) {
    #include <abstractions/base>
    file,
    # Deny all file writes
    deny /** w,
}

apparmor_parser /etc/apparmor.d/deny-write

# Deploy sample pod
kubectl create -f apparmor-disk-write-pod.yaml --save-config
