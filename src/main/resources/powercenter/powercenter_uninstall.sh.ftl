<#--

    THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
    FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.

-->
export INFA_HOME=${previousDeployed.container.home}
export LD_LIBRARY_PATH=${previousDeployed.container.home}/server/bin

<#assign pmrep=previousDeployed.container.home + "/server/bin/pmrep">
<#assign exitCodeCheck>
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
</#assign>
${pmrep} connect -r ${previousDeployed.container.repository} -d ${previousDeployed.container.domain} -n ${previousDeployed.container.userName} -x ${previousDeployed.container.password}
${exitCodeCheck}

<#list previousDeployed.folderNames?keys as key>
<#list previousDeployed.objectNames as objectName>
<#list previousDeployed.objectTypes as objectType>
${pmrep} deleteobject -o ${objectType} -f ${previousDeployed.folderNames[key]} -n ${objectName}
</#list>
</#list>
</#list>


${exitCodeCheck}

echo ------------------------------------------------------------------------

#echo Powercenter objects can not be deleted from a versioned repository using command line interface.
#echo NB: Use Repository Manager to delete object manually!
