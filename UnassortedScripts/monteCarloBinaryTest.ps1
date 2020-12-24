# Monte Carlo metódus

Clear-Host

# a vizsgálandó, ismeretlen alany - teljes populáció (250 darab nulla és 750 darab egy)
$subject = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"

# generating string containing 0s and 1s randomly
#$randNumb = 1..1000 | ForEach-Object { Get-Random ('0','1','1') }; $randNumb -join "" | Out-File C:\pstest\1000bin.txt -Force

#$subject = Get-Content C:\pstest\1000bin.txt

$simCounter = 10000 # teljes szimuláció ismétlése átlagérték számításhoz

$minta = 20 # mintavétel számossága ; egy szimuláció alatt a teljes populációból hány véletlenszerűen kiválasztott elemet vizsgálunk meg

# 

$sims = 1
$result = @()
$nullaMean = 0
$egyMean = 0

# Measure-Command {

for ($g = 0;$g -lt $simCounter ; $g++){

$egy = 0
$nulla = 0


for ($i = 1;$i -lt $minta ; $i++){

$chpoint = Get-Random 999

if (($subject[$chpoint]) -eq "1")
   {
       $egy = $egy+1
   }
   else
   {
       $nulla = $nulla+1
   }

   }


$meanObject = [PSCustomObject] @{"sorszám" = $sims; "0-ás találat" = $("{0,8:P0}" -f ($nulla / $minta)); "1-es találat" = $("{0,8:P0}" -f ($egy / $minta))}
$result += $meanObject
$nullaMean = $nullaMean + ($nulla / $minta)
$egyMean = $egyMean + ($egy / $minta)

$sims = $sims+1

Write-Progress -Activity "Calculating..." -PercentComplete ($g/($simCounter/100)) # (számláló / (összes ciklus/100) )

}


#$result += [PSCustomObject] @{"sorszám" = $null; "0-ás találat" = $null; "1-es találat" = $null}
#$result += [PSCustomObject] @{"sorszám" = "Átlag"; "0-ás találat" = $("{0,8:P0}" -f ($nullaMean/$simCounter)); "1-es találat" = $("{0,8:P0}" -f ($egyMean/$simCounter))}
#$result

[PSCustomObject] @{"sorszám" = "Átlag"; "0-ás találat" = $("{0,8:P0}" -f ($nullaMean/$simCounter)); "1-es találat" = $("{0,8:P0}" -f ($egyMean/$simCounter))}

#}