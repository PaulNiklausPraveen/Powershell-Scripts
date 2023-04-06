      Get-Volume   -ErrorAction Stop | Where-Object {$_.DriveLetter} | `
      Select-Object @{Name = "Computername"; Expression = {$env:COMPUTERNAME.ToUpper()}},  `
      @{Name = "Drive"; Expression = {$_.DriveLetter}}, FileSystem,@{Name = "SizeGB"; Expression = {$_.size / 1gb -as [int32]}}, `
      @{Name = "FreeGB"; Expression = {[math]::Round($_.SizeRemaining / 1gb, 2)}}, `
      @{Name = "PctFree"; Expression = {[math]::Round(($_.SizeRemaining / $_.size) * 100, 2)}}
