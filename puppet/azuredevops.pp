host { 'devops.example.org':
  ip => '127.0.0.1',
}

package { 'sql-server-express':
  ensure   => installed,
  provider => chocolatey
}
-> download_file { 'azuredevopsexpress2019.exe':
  destination_directory => 'C:/tools',
  url                   =>
    'https://octopus-guides.s3.amazonaws.com/azuredevops/azuredevopsexpress2019.exe',
}
-> file { 'C:/install_azure.ps1':
  ensure  => 'file',
  owner   => 'Administrators',
  group   => 'Administrators',
  mode    => '0644',
  content => @(EOT)
    Start-Process "C:\tools\azuredevopsexpress2019.exe" -ArgumentList @("/silent") -NoNewWindow -Wait
    Start-Process "C:\Program Files\Azure DevOps Server 2019\Tools\TfsConfig.exe" -ArgumentList @("unattend", "/unattendfile:.\config\azuredevops.ini", "/continue") -NoNewWindow -Wait
    New-Item -ItemType file c:\AzureDevOpsStarted.txt
    | EOT
}
-> exec { 'Install Azure':
  command   => '& C:/install_azure.ps1',
  creates   => 'c:/AzureDevOpsStarted.txt',
  timeout   => 3600,
  provider  => powershell,
  logoutput => true
}
-> file { 'C:/tools/vsts-agent-win-x86-2.144.2':
  ensure => 'directory'
}
-> archive { 'C:/tools/vsts-agent-win-x86-2.144.2.zip':
  ensure       => present,
  extract      => true,
  extract_path => 'C:/tools/vsts-agent-win-x86-2.144.2',
  source       => 'https://go.microsoft.com/fwlink/?linkid=2066763',
  creates      => 'C:/tools/vsts-agent-win-x86-2.144.2/run.cmd',
  cleanup      => true,
}
-> file { 'C:/install_azure_agent.ps1':
  ensure  => 'file',
  owner   => 'Administrators',
  group   => 'Administrators',
  mode    => '0644',
  content => @(EOT)
    Write-Host "Configuring Azure DevOps agent"
    C:\tools\vsts-agent-win-x86-2.144.2\config.cmd --unattended --url http://localhost:9090 --auth integrated --pool default --agent myAgent
    Write-Host "Starting Azure DevOps agent"
    start "C:\tools\vsts-agent-win-x86-2.144.2\run.cmd" -PassThru
    New-Item -ItemType file c:\AzureAgentStarted.txt
    exit 0
    | EOT
}
-> exec { 'Configure agent':
  command   => '& C:/install_azure_agent.ps1',
  creates   => 'c:/AzureAgentStarted.txt',
  provider  => powershell,
  logoutput => true
}