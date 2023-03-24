######################################## DEV #########################################
key='<+secrets.getValue("account.ansibleocpsadev")>'
echo $key > ansiblekey.json
echo <+secrets.getValue("account.ansiblevaultpasswd")> > vault_pass

gcloud auth activate-service-account --key-file=ansiblekey.json

mkdir -p /root/.ssh
cd /root/.ssh

ssh-keygen -f dev-ssh-ansible-sa-new
chmod 400 dev-ssh-ansible-sa-new
cat dev-ssh-ansible-sa-new

gcloud compute os-login ssh-keys add --key-file=dev-ssh-ansible-sa-new.pub

eval `ssh-agent -s`
ssh-add dev-ssh-ansible-sa-new
######################################## SIT #########################################
key='<+secrets.getValue("account.ansibleocpsasit")>'
echo $key > ansiblekey.json
echo <+secrets.getValue("account.ansiblevaultpasswd")> > vault_pass

gcloud auth activate-service-account --key-file=ansiblekey.json

mkdir -p /root/.ssh
cd /root/.ssh

ssh-keygen -f sit-ssh-ansible-sa-new
chmod 400 sit-ssh-ansible-sa-new
cat sit-ssh-ansible-sa-new

gcloud compute os-login ssh-keys add --key-file=sit-ssh-ansible-sa-new.pub

eval `ssh-agent -s`
ssh-add sit-ssh-ansible-sa-new
######################################## PP MONTREAL #########################################
key='<+secrets.getValue("account.ansibleocpsappmontreal")>'
echo $key > ansiblekey.json
echo <+secrets.getValue("account.ansiblevaultpasswd")> > vault_pass

gcloud auth activate-service-account --key-file=ansiblekey.json

mkdir -p /root/.ssh
cd /root/.ssh

ssh-keygen -f pp-montreal-ssh-ansible-sa-new
chmod 400 pp-montreal-ssh-ansible-sa-new
cat pp-montreal-ssh-ansible-sa-new

gcloud compute os-login ssh-keys add --key-file=pp-montreal-ssh-ansible-sa-new.pub

eval `ssh-agent -s`
ssh-add pp-montreal-ssh-ansible-sa-new
######################################## PP OREGON #########################################
key='<+secrets.getValue("account.ansibleocpsapporegon")>'
echo $key > ansiblekey.json
echo <+secrets.getValue("account.ansiblevaultpasswd")> > vault_pass

gcloud auth activate-service-account --key-file=ansiblekey.json

mkdir -p /root/.ssh
cd /root/.ssh

ssh-keygen -f pp-oregon-ssh-ansible-sa-new
chmod 400 pp-oregon-ssh-ansible-sa-new
cat pp-oregon-ssh-ansible-sa-new

gcloud compute os-login ssh-keys add --key-file=pp-oregon-ssh-ansible-sa-new.pub

eval `ssh-agent -s`
ssh-add pp-oregon-ssh-ansible-sa-new
######################################## PROD MONTREAL #########################################
key='<+secrets.getValue("account.ansibleocpsaprodmontreal")>'
echo $key > ansiblekey.json
echo <+secrets.getValue("account.ansiblevaultpasswd")> > vault_pass

gcloud auth activate-service-account --key-file=ansiblekey.json

mkdir -p /root/.ssh
cd /root/.ssh

ssh-keygen -f prod-montreal-ssh-ansible-sa-new
chmod 400 prod-montreal-ssh-ansible-sa-new
cat prod-montreal-ssh-ansible-sa-new

gcloud compute os-login ssh-keys add --key-file=prod-montreal-ssh-ansible-sa-new.pub

eval `ssh-agent -s`
ssh-add prod-montreal-ssh-ansible-sa-new
######################################## PROD OREGON #########################################
key='<+secrets.getValue("account.ansibleocpsaprodoregon")>'
echo $key > ansiblekey.json
echo <+secrets.getValue("account.ansiblevaultpasswd")> > vault_pass

gcloud auth activate-service-account --key-file=ansiblekey.json

mkdir -p /root/.ssh
cd /root/.ssh

ssh-keygen -f prod-oregon-ssh-ansible-sa-new
chmod 400 prod-oregon-ssh-ansible-sa-new
cat prod-oregon-ssh-ansible-sa-new

gcloud compute os-login ssh-keys add --key-file=prod-oregon-ssh-ansible-sa-new.pub

eval `ssh-agent -s`
ssh-add prod-oregon-ssh-ansible-sa-new