
Function Get-EventlogRange {

    [CmdletBinding()]
    
    Param(
        [Parameter(ValueFromPipeline=$true,
                Position = 0,
                ValueFromRemainingArguments = $false)]
                [Alias("reserved1")]
               # [DateTime][ValidateScript({$_ -le $EndDate})] 
                $StartDate = [DateTime]::MinValue,
                
        [Parameter(ValueFromPipeline=$true,
                Position = 1,
                ValueFromRemainingArguments = $false)]
                [Alias("reserved2")]
                [DateTime][ValidateScript({$_ -ge $StartDate})]
                $EndDate = (get-date),
                
    
        [Parameter(ValueFromPipeline=$true,
                ValueFromRemainingArguments = $false)]
                [Alias("reserved3")]
                [String]$ComputerName = $env:COMPUTERNAME,
    
        [Parameter(ValueFromPipeline=$True,
                ValueFromRemainingArguments = $false)]
                [Alias("reserved4")]
                [Int32[]]$Level = @(0,1,2,3,4,5) 
        )
    
        Begin
        {
             

                #
        }
        Process
        { 
            $Eventlogs = Get-WinEvent -ComputerName $ComputerName -ListLog * -ErrorAction SilentlyContinue | 
            Where-Object {($PSitem.RecordCount -gt 0) -and ($PSitem.LastWriteTime -gt  $StartDate)} 
    
        $eventlogs | % {Get-WinEvent -ComputerName $ComputerName  -FilterHashTable @{LogName = $PSItem.Logname; 
                                                                                                        Level = $Level ; 
                                                                                                        StartTime = $StartDate ; 
                                                                                                        EndTime = $Enddate} -ErrorAction SilentlyContinue}
        }
        End
        {
            
        }
    }
    
    
    Get-EventlogRange -StartDate (get-date).AddDays(-1) -EndDate $(get-date)