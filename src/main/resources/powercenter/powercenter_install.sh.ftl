<#--

    THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
    FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.

-->
export INFA_HOME=${deployed.container.home}
export LD_LIBRARY_PATH=${deployed.container.home}/server/bin

<#assign pmrep=deployed.container.home + "/server/bin/pmrep">
<#assign exitCodeCheck>
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
</#assign>
${pmrep} connect -r ${deployed.container.repository} -d ${deployed.container.domain} -n ${deployed.container.userName} -x ${deployed.container.password}
${exitCodeCheck}

echo ------------------------------------------------------------------------

<#if deployed.folderNameMap?has_content>
	<#list deployed.folderNameMap?keys as key>
		${pmrep} createFolder -n ${deployed.folderNameMap[key]} -p 777
		res=$?
		if [ $res != 0 ] ; then
			echo "Target folder ${deployed.folderNameMap[key]} already exists. Proceeding with object import."
		fi
	</#list>
<#else>
	<#list deployed.folderNames as folderName>
		${pmrep} createFolder -n ${folderName} -p 777
		res=$?
		if [ $res != 0 ] ; then
			echo "Target folder ${folderName} already exists. Proceeding with object import."
		fi
	</#list>
</#if>

${pmrep} objectimport -i ${deployed.file.path}  -c powercenter/powercenter_controlfile.xml
${exitCodeCheck}
