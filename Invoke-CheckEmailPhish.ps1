function Invoke-CheckEmailPhish{
 <#
    .SYNOPSIS

    This module performs a check if email is valid for a perticular domain. This function uses an API of a service named trumail (http://trumail.io)
    Due to the service limitations, only 1000 emails can be checked in a day. I know you will figure out a way past that .. :P

    Invoke-CheckEmailPhish Function: Invoke-CheckEmailPhish
    Author: Shantanu Khandelwal (@shantanukhande)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    .DESCRIPTION

    This module performs a check if email is valid for a perticular domain. This function uses an API of a service named trumail (http://trumail.io). Due to the service limitations, only 1000 emails can be checked in a day. I know you will figure out a way past that .. :P

    .PARAMETER UserList

    This paramater is used to supply list of email addresses to be checked for validity.

    .Parameter Email

    This parameter is used to specify only one email which is to be checked for validity.

    .Example

    C:\PS> Invoke-CheckEmailPhish -email doobly@doobly.com

    C:\PS> Invoke-CheckEmailPhish -UserList C:\list_of_emails.txt
#>
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [string]
        $UserList,
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $email
    )
    $regex = "^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"

    if ($UserList -ne "$null"){
        $resp=@()
        foreach($line in Get-Content $UserList){
            if($line -match $regex){
                $resp+=Invoke-EmailCheck($line)
            }
        }
        $resp
    }
    Elseif($email -ne $null -and $email -match $regex ) {
        $resp = Invoke-EmailCheck($email)
        $resp
    }

}
function Invoke-EmailCheck()
{
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $email = ""   
    )
    $uri = "https://api.trumail.io/v1/json/$email"
    $response = Invoke-RestMethod -Uri $uri -Method Get
    return $response
}
