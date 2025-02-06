pipeline {
    agent any
    stages {      
        stage("Copy files to Docker server") {
            steps {
                // แก้ตรง team33-neogym ให้เป็นชื่อเดียวกับ pipeline job/item ที่สร้างใน Jenkins
                sh "scp -r /var/lib/jenkins/workspace/66022646/* root@43.208.241.236:~/66022646"
            }
        }
        
        stage("Build Docker Image") {
            steps {
                // path การทำงานกับ Ansible playbook
                ansiblePlaybook playbook: '/var/lib/jenkins/workspace/66022646/playbooks/build.yaml'
            }    
        } 
        
        stage("Create Docker Container") {
            steps {
                // path การทำงานกับ Ansible playbook
                ansiblePlaybook playbook: '/var/lib/jenkins/workspace/66022646/playbooks/deploy.yaml'
            }    
        } 
    }
}
