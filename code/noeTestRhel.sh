if [ "x$1" = "x" ]; then
  LOG=log.txt
else
  LOG=$1
fi


cd noe-tests
#what templates use
export RUN_ENV=run.env.template
export RUN_ENV_SPEC=run.env.specific.ipv6.template

#what log level use
export LOGGING_LEVEL=6
#what test to execute
export EXECUTE_TEST=.*${TestToRun}.*
#what version to test
export EWS_VERSION=3.0.3-CR1
#where noe can install it
export EAP_VERSION=7.0.0.ER7
#What ip adress use
export HOST=127.0.0.1
#under what user should apache httpd run
export HTTPD_RUN_AS=apache
#where to install
export WORKSPACE_BASEDIR=/opt
#where noe can find zips
export HUDSON_STATIC_ENV=/root/static
#test profile
export TEST_PROFILE=ews-java
#what tomcat use
export TOMCAT_MAJOR_VERSION=7
#can noe use sudo?
export RUN_WITH_SUDO=true


#mod_cluster starting
if [ "$2" == "mod_cluster" ]; then 
  export TEST_PROFILE=mod_cluster-eap6
  export HTTPD_SERVER_NAME=rhel7GAx86-64
  export DEFAULT_EAP6_PREFIX=""
  export MODCLUSTER_EXPECTED_NATIVE_LIB_VERSION=\"mod_cluster/1.3.1.Final\"
  export MODCLUSTER_EXPECTED_JAVA_LIB_VERSION=\"mod_cluster version 1.3.1.Final\"
  export MODCLUSTER_EXPECTED_HTTPD_VERSION=\"Apache/2.4.6\"
fi

#Set java and maven home
export M2_HOME=/root/apache-maven-3.3.9
export JAVA_HOME=/etc/alternatives/java_sdk_1.7.0_oracle
export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH
#MAVEN HOME

cp scripts/ews/templates/$RUN_ENV run.env
cp scripts/ews/templates/$RUN_ENV_SPEC run.env.specific

sed -i -r 's/mvn --version.*/mvn --version | grep "3\\.3"/g' run.sh

echo "export LOGGING_LEVEL=$LOGGING_LEVEL" >> run.env
echo "export EXECUTE_TEST=$EXECUTE_TEST" >> run.env
echo "export EWS_VERSION=$EWS_VERSION" >> run.env
echo "export WORKSPACE_BASEDIR=$WORKSPACE_BASEDIR" >> run.env
echo "export TEST_PROFILE=$TEST_PROFILE" >> run.env
echo "export JAVA_HOME=$JAVA_HOME" >> run.env
echo "export HUDSON_STATIC_ENV=$HUDSON_STATIC_ENV" >> run.env
echo "export CONTEXT=$CONTEXT" >> run.env

./run.sh 2>&1 | tee ../$LOG

