param([String[]] $Scripts)
Start-Process msiexec.exe -Wait -ArgumentList '/qn /norestart /i https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi PUPPET_MASTER_SERVER=puppet'
if (Test-Path "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat") {
    & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" module install puppetlabs/windows
    & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" module install puppet/windows_env
    & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" module install puppetlabs/docker
    & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" module install puppet/download_file
    & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" module install puppet/windowsfeature
    & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" module install puppet-archive --version 3.2.1

    $ErrorActionPreference = "Continue"

    foreach($script in $scripts) {
        # Chocolatey installs are brittle, so we add a retry
        for ($retry = 0; $retry -lt 2; ++$retry) {
            & "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" apply "puppet\$script" "--disable_warnings=deprecations"
            if ($LASTEXITCODE -eq 0) {
                break
            }
        }
    }
} else {
    Write-Error "Could not find the Puppet agent executable. Make sure the script was run from an administrative Powershell session."
}